param()

$ErrorActionPreference = 'Stop'
$dataDir = Join-Path $PSScriptRoot '..\data'

$recs = Get-Content (Join-Path $dataDir 'launches.jsonl') | ForEach-Object { $_ | ConvertFrom-Json }
$prod = @($recs | Where-Object { $_.devIdentity -eq 'production_readiness_reviewer' })

function Has([string]$text, [string]$pattern) {
    return [bool][regex]::IsMatch($text, $pattern)
}

$rows = New-Object System.Collections.Generic.List[object]
foreach ($r in $prod) {
    $f = Get-ChildItem 'C:\Users\admin\.codex\sessions' -Recurse -Filter $r.file | Select-Object -First 1
    if (-not $f) { continue }
    $raw = [System.IO.File]::ReadAllText($f.FullName)

    $env = $null
    foreach ($line in ($raw -split "`n")) {
        if ($line -notlike '*"type":"response_item"*') { continue }
        try { $o = $line | ConvertFrom-Json } catch { continue }
        $p = $o.payload
        if ($p.type -ne 'message' -or $p.role -ne 'user') { continue }
        $txt = ''
        foreach ($c in $p.content) { if ($c.text) { $txt += $c.text } }
        if ($txt.StartsWith('You are the `production_readiness_reviewer` agent')) {
            if ($null -eq $env) { $env = $txt } else { $env = $env + "`n" + $txt }
        }
    }
    if ($null -eq $env) { continue }

    $iterVal = $null
    $im = [regex]::Match($env, 'Review iteration[^0-9\r\n]*(\d+)')
    if ($im.Success) { $iterVal = [int]$im.Groups[1].Value }

    $gateVal = $null
    $gm = [regex]::Match($env, '(?i)Completion gate\s*[:\-]?\s*([A-Za-z-]+)')
    if ($gm.Success) { $gateVal = $gm.Groups[1].Value }

    $ciLabel = $null
    $cm = [regex]::Match($env, '(?i)ci mode\s*[:\-]?\s*(fast|full|n/a)')
    if ($cm.Success) { $ciLabel = $cm.Groups[1].Value }

    $ciRows = [regex]::Matches($env, '(?im)^\s*(?:[-*]\s*)?[^#\r\n]{0,140}?\b(pass|fail|skipped|n/a)\b').Count

    $rows.Add([pscustomobject][ordered]@{
        file = $r.file
        startedAt = $r.startedAt
        repo = $r.repo
        rootThreadId = $r.rootThreadId
        verdictClass = $r.verdictClass
        envelopeChars = $env.Length
        iterationValue = $iterVal
        hasCounts = (Has $env '(?i)cumulative|launches this phase|per-leg')
        completionGate = $gateVal
        ciModeLabel = $ciLabel
        ciRowLines = $ciRows
        hasApplicableDocs = (Has $env '(?i)applicable docs')
        hasFocusNarrow = (Has $env '(?i)focus[- ]narrow')
        hasRenew = (Has $env '(?i)\brenew\b')
        hasPlanPhase = (Has $env '(?i)plan phase|phase \d+ of \d+')
        hasReviewModel = (Has $env '(?i)review model')
        hasEvidenceFrame = (Has $env '(?i)fixed point|spec path')
        envHostAlias = (Has $env '(?m)^Host alias:')
        envIsolation = (Has $env '(?m)^Isolation:')
        envAuthority = (Has $env '(?m)^Authority:')
        envLoopGate = (Has $env '(?m)^Loop/gate:')
        overrideAttempt = (Has $env '(?i)treat as approved|ignore tests|skip ci')
    })
}

$csvPath = Join-Path $dataDir 'envelope-content.csv'
$rows | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

$sb = New-Object System.Text.StringBuilder
function W([string]$s) { [void]$sb.AppendLine($s) }
$n = $rows.Count

W '# Envelope-content quantification (113 payloads)'
W ''
W ("Rows collated: {0}. Source: user envelope message(s) extracted from each child session; heuristics noted per row. Full rows: envelope-content.csv" -f $n)
W ''

W '## Contract-required inputs'
W ''
W '| Element | Present | % |'
W '|---|---|---|'
foreach ($spec in @(
    @('Repository/task context (non-empty envelope)', { param($x) $true }),
    @('Review iteration (value)', { param($x) $null -ne $x.iterationValue }),
    @('Cumulative per-leg counts', { param($x) $x.hasCounts }),
    @('Completion gate (any value)', { param($x) $null -ne $x.completionGate }),
    @('Completion gate = review-loop', { param($x) $x.completionGate -ieq 'review-loop' }),
    @('CI section present', { param($x) $null -ne $x.ciModeLabel -or $x.ciRowLines -gt 0 }),
    @('Literal `ci mode` label', { param($x) $null -ne $x.ciModeLabel }),
    @('Per-command CI rows (>=1 heuristic)', { param($x) $x.ciRowLines -ge 1 })
)) {
    $cnt = @($rows | Where-Object { & $spec[1] $_ }).Count
    W ('| {0} | {1} | {2:P1} |' -f $spec[0], $cnt, ($cnt / $n))
}
W ''

W '## Optional contract inputs'
W ''
W '| Element | Present | % |'
W '|---|---|---|'
foreach ($spec in @(
    @('Applicable docs hint', { param($x) $x.hasApplicableDocs }),
    @('Plan phase context', { param($x) $x.hasPlanPhase }),
    @('Review model', { param($x) $x.hasReviewModel }),
    @('Evidence frame (fixed point + spec)', { param($x) $x.hasEvidenceFrame })
)) {
    $cnt = @($rows | Where-Object { & $spec[1] $_ }).Count
    W ('| {0} | {1} | {2:P1} |' -f $spec[0], $cnt, ($cnt / $n))
}
W ''

W '## Renewal-path usage'
W ''
W '| Element | Present | % |'
W '|---|---|---|'
foreach ($spec in @(
    @('Focus-narrow declared', { param($x) $x.hasFocusNarrow }),
    @('Renew mentioned', { param($x) $x.hasRenew })
)) {
    $cnt = @($rows | Where-Object { & $spec[1] $_ }).Count
    W ('| {0} | {1} | {2:P1} |' -f $spec[0], $cnt, ($cnt / $n))
}
W ''

W '## Envelope structure lines'
W ''
W '| Line | Present | % |'
W '|---|---|---|'
foreach ($spec in @(
    @('Host alias:', { param($x) $x.envHostAlias }),
    @('Isolation:', { param($x) $x.envIsolation }),
    @('Authority:', { param($x) $x.envAuthority }),
    @('Loop/gate:', { param($x) $x.envLoopGate })
)) {
    $cnt = @($rows | Where-Object { & $spec[1] $_ }).Count
    W ('| {0} | {1} | {2:P1} |' -f $spec[0], $cnt, ($cnt / $n))
}
$ov = @($rows | Where-Object { $_.overrideAttempt }).Count
W ''
W ('Illegal-override attempts in payloads: {0}/{1}' -f $ov, $n)
W ''

W '## Value distributions'
W ''
W ('- Iteration values: ' + ((($rows | Where-Object { $null -ne $_.iterationValue }) | Group-Object iterationValue | Sort-Object { [int]$_.Name } | ForEach-Object { "$($_.Name): $($_.Count)" }) -join ', ') + ', missing: ' + @($rows | Where-Object { $null -eq $_.iterationValue }).Count)
W ('- Completion gate values: ' + ((($rows | Where-Object { $null -ne $_.completionGate }) | Group-Object completionGate | Sort-Object Count -Descending | ForEach-Object { "$($_.Name): $($_.Count)" }) -join ', ') + ', missing: ' + @($rows | Where-Object { $null -eq $_.completionGate }).Count)
W ('- CI mode labels: ' + ((($rows | Where-Object { $null -ne $_.ciModeLabel }) | Group-Object ciModeLabel | Sort-Object Count -Descending | ForEach-Object { "$($_.Name): $($_.Count)" }) -join ', ') + ', missing: ' + @($rows | Where-Object { $null -eq $_.ciModeLabel }).Count)
$lenSorted = @($rows | ForEach-Object { $_.envelopeChars } | Sort-Object)
$lenMed = $lenSorted[[int][Math]::Floor(($lenSorted.Count - 1) / 2)]
W ('- Envelope size (chars): mean {0:N0}, median {1:N0}, min {2:N0}, max {3:N0}' -f (($lenSorted | Measure-Object -Average).Average), $lenMed, $lenSorted[0], $lenSorted[-1])
$ciRowsSorted = @($rows | ForEach-Object { $_.ciRowLines } | Sort-Object)
$ciMed = $ciRowsSorted[[int][Math]::Floor(($ciRowsSorted.Count - 1) / 2)]
W ('- CI row-like lines per payload: mean {0:N1}, median {1:N0}, max {2:N0}' -f (($ciRowsSorted | Measure-Object -Average).Average), $ciMed, $ciRowsSorted[-1])

$outPath = Join-Path $dataDir 'envelope-content.md'
$sb.ToString() | Set-Content -Path $outPath -Encoding UTF8
Write-Output $sb.ToString()
