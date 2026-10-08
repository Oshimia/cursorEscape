param()

$ErrorActionPreference = 'Stop'
$dataDir = Join-Path $PSScriptRoot '..\data'
$allRecords = Get-Content (Join-Path $dataDir 'launches.jsonl') | ForEach-Object { $_ | ConvertFrom-Json }
# True Reviewer A launches only: child session carries the adapter developer
# identity. File-level envelope matching over-matches embedded parent
# transcripts (command-approval reviewer sessions, implementer sessions).
$launches = @($allRecords | Where-Object { $_.devIdentity -eq 'production_readiness_reviewer' })

$total = $launches.Count
$distinctThreads = ($launches | Where-Object { $_.rootThreadId } | Select-Object -Unique rootThreadId).Count
$repos = $launches | Group-Object repo | Sort-Object Count -Descending
$verdicts = $launches | Group-Object verdictClass | Sort-Object Count -Descending
$iterations = $launches | Group-Object { if ($null -ne $_.iteration) { $_.iteration } else { 'unspecified' } } | Sort-Object { [int]($_.Name -replace 'unspecified','99') }

$sb = New-Object System.Text.StringBuilder
function W([string]$s) { [void]$sb.AppendLine($s) }

W '# Production reviewer - quantitative profile'
W ''
W ("Corpus: {0} Reviewer A launch sessions across {1} distinct root threads and {2} repos." -f $total, $distinctThreads, $repos.Count)
W ''

W '## Verdict distribution'
W ''
W '| Verdict | Count | % |'
W '|---|---|---|'
foreach ($v in $verdicts) {
    W ('| {0} | {1} | {2:P1} |' -f $v.Name, $v.Count, ($v.Count / $total))
}
W ''

W '## Review iteration (within block)'
W ''
W '| Iteration | Count | % |'
W '|---|---|---|'
foreach ($i in $iterations) {
    W ('| {0} | {1} | {2:P1} |' -f $i.Name, $i.Count, ($i.Count / $total))
}
W ''

W '## Per-repo launches'
W ''
W '| Repo | Launches |'
W '|---|---|'
foreach ($r in $repos) {
    W ('| {0} | {1} |' -f $r.Name, $r.Count)
}
W ''

W '## Required-section compliance'
W ''
$sectionKeys = @('Blocking findings','Non-blocking findings','Architecture alignment','Supersession closure','Lifecycle and naming closure','Regression matrix','Blocking test/docs','Batchable (deferred)','CI gate status')
W '| Section | Present | % |'
W '|---|---|---|'
foreach ($s in $sectionKeys) {
    $present = ($launches | Where-Object { $_.sections.$s }).Count
    W ('| {0} | {1} | {2:P1} |' -f $s, $present, ($present / $total))
}
W ''

W '## Finding counts per launch'
W ''
foreach ($key in @('blockingCount','nonBlockingCount','blockingTestDocsCount','batchableCount')) {
    $vals = @($launches | ForEach-Object { $_.$key } | Where-Object { $null -ne $_ })
    if ($vals.Count -eq 0) { continue }
    $sorted = $vals | Sort-Object
    $median = $sorted[[int][Math]::Floor(($sorted.Count - 1) / 2)]
    $zero = ($vals | Where-Object { $_ -eq 0 }).Count
    $mean = [Math]::Round(($vals | Measure-Object -Average).Average, 2)
    $max = ($vals | Measure-Object -Maximum).Maximum
    W ('- {0}: n={1}, mean={2}, median={3}, max={4}, zero={5} ({6:P1})' -f $key, $vals.Count, $mean, $median, $max, $zero, ($zero / $vals.Count))
}
W ''

$withFileLine = ($launches | Where-Object { $_.blockingHasFileLine }).Count
W ('- Blocking findings include file:line-style evidence in {0}/{1} launches ({2:P1})' -f $withFileLine, $total, ($withFileLine / $total))
$ciReported = ($launches | Where-Object { $_.ciMode }).Count
W ('- CI mode line present in parent payload: {0}/{1} ({2:P1})' -f $ciReported, $total, ($ciReported / $total))
$gateOk = ($launches | Where-Object { $_.completionGate -match 'review-loop' }).Count
W ('- Completion gate = review-loop: {0}/{1} ({2:P1})' -f $gateOk, $total, ($gateOk / $total))
W ''

W '## Era split (contract changes)'
W ''
$eras = @(
    @{ Name = 'pre-supersession (to 2026-09-27)'; Match = { param($d) $d -lt '2026-09-28' } },
    @{ Name = 'supersession+lifecycle (2026-09-28 to 2026-10-07)'; Match = { param($d) $d -ge '2026-09-28' -and $d -lt '2026-10-08' } },
    @{ Name = 'post short-form (2026-10-08+)'; Match = { param($d) $d -ge '2026-10-08' } }
)
W '| Era | Launches | APPROVED | CR | Non-verdict | Supersession section | Lifecycle section |'
W '|---|---|---|---|---|---|---|'
foreach ($era in $eras) {
    $in = @($launches | Where-Object { $_.startedAt -and (& $era.Match $_.startedAt.Substring(0,10)) })
    $ok = ($in | Where-Object { $_.verdictClass -eq 'APPROVED' }).Count
    $cr = ($in | Where-Object { $_.verdictClass -eq 'CHANGES REQUESTED' }).Count
    $nv = ($in | Where-Object { $_.verdictClass -notin @('APPROVED','CHANGES REQUESTED') }).Count
    $ss = ($in | Where-Object { $_.sections.'Supersession closure' }).Count
    $lc = ($in | Where-Object { $_.sections.'Lifecycle and naming closure' }).Count
    W ('| {0} | {1} | {2} | {3} | {4} | {5} | {6} |' -f $era.Name, $in.Count, $ok, $cr, $nv, $ss, $lc)
}
W ''

W '## Multi-launch loops (threads with 2+ Reviewer A launches)'
W ''
W '| Root thread | Repo | Launches | Verdict sequence | Iterations |'
W '|---|---|---|---|---|'
$loops = $launches | Group-Object rootThreadId | Where-Object { $_.Count -ge 2 } | Sort-Object Count -Descending
foreach ($l in $loops) {
    $seq = ($l.Group | Sort-Object startedAt | ForEach-Object { ($_.verdictClass -replace 'CHANGES REQUESTED','CR') -replace 'APPROVED','OK' }) -join ' > '
    $iters = ($l.Group | Sort-Object startedAt | ForEach-Object { if ($null -ne $_.iteration) { $_.iteration } else { '?' } }) -join ','
    $repoName = ($l.Group | Select-Object -First 1).repo
    W ('| {0} | {1} | {2} | {3} | {4} |' -f $l.Name, $repoName, $l.Count, $seq, $iters)
}
W ''

W '## Launches per day'
W ''
W '| Date | Launches |'
W '|---|---|'
$byDay = $launches | Group-Object { if ($_.startedAt) { $_.startedAt.Substring(0,10) } else { 'unknown' } } | Sort-Object Name
foreach ($d in $byDay) {
    W ('| {0} | {1} |' -f $d.Name, $d.Count)
}

$outPath = Join-Path $dataDir 'quantitative-profile.md'
$sb.ToString() | Set-Content -Path $outPath -Encoding UTF8
Write-Output $sb.ToString()
