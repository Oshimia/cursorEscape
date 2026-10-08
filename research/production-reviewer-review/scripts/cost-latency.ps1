param()

$ErrorActionPreference = 'Stop'
$dataDir = Join-Path $PSScriptRoot '..\data'

$recs = Get-Content (Join-Path $dataDir 'launches.jsonl') | ForEach-Object { $_ | ConvertFrom-Json }
$prod = @($recs | Where-Object { $_.devIdentity -eq 'production_readiness_reviewer' })

$rows = New-Object System.Collections.Generic.List[object]
foreach ($r in $prod) {
    $f = Get-ChildItem 'C:\Users\admin\.codex\sessions' -Recurse -Filter $r.file | Select-Object -First 1
    if (-not $f) { continue }

    $firstTs = $null; $lastTs = $null
    $lastTotals = $null
    foreach ($line in ([System.IO.File]::ReadLines($f.FullName))) {
        if ($null -eq $firstTs -and $line -match '^\{"timestamp":"([^"]+)"') { $firstTs = $Matches[1] }
        if ($line -match '^\{"timestamp":"([^"]+)"') { $lastTs = $Matches[1] }
        if ($line -like '*"thread_token_usage"*') {
            try {
                $o = $line | ConvertFrom-Json
                if ($o.type -eq 'token_usage_record') { $lastTotals = $o.payload.thread_token_usage }
            } catch {}
        }
    }

    $durationSec = $null
    if ($firstTs -and $lastTs) {
        try {
            $d = [DateTimeOffset]::Parse($lastTs) - [DateTimeOffset]::Parse($firstTs)
            $durationSec = [Math]::Round($d.TotalSeconds, 1)
        } catch {}
    }

    $rows.Add([pscustomobject][ordered]@{
        file = $r.file
        startedAt = $r.startedAt
        repo = $r.repo
        rootThreadId = $r.rootThreadId
        verdictClass = $r.verdictClass
        iteration = $r.iteration
        blockingCount = $r.blockingCount
        nonBlockingCount = $r.nonBlockingCount
        blockingTestDocsCount = $r.blockingTestDocsCount
        batchableCount = $r.batchableCount
        durationSec = $durationSec
        inputTokens = $lastTotals.input_tokens
        cachedInputTokens = $lastTotals.cached_input_tokens
        outputTokens = $lastTotals.output_tokens
        reasoningTokens = $lastTotals.reasoning_output_tokens
        totalTokens = $lastTotals.total_tokens
    })
}

$csvPath = Join-Path $dataDir 'cost-latency.csv'
$rows | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

# Summary
$sb = New-Object System.Text.StringBuilder
function W([string]$s) { [void]$sb.AppendLine($s) }
function Stats([string]$label, [object[]]$group) {
    if ($group.Count -eq 0) { return }
    $dur = @($group | ForEach-Object { $_.durationSec } | Where-Object { $null -ne $_ } | Sort-Object)
    $tot = @($group | ForEach-Object { $_.totalTokens } | Where-Object { $null -ne $_ } | Sort-Object)
    $out = @($group | ForEach-Object { $_.outputTokens } | Where-Object { $null -ne $_ } | Sort-Object)
    $med = { param($a) if ($a.Count -eq 0) { return $null }; $a[[int][Math]::Floor(($a.Count - 1) / 2)] }
    $medDur = 0
    if ($dur.Count -gt 0) { $medDur = (& $med $dur) / 60 }
    W ('| {0} | {1} | {2:N0} | {3:N0} | {4:N1} | {5:N0} | {6:N0} | {7:N1} |' -f `
        $label, $group.Count, ($tot | Measure-Object -Average).Average, (& $med $tot), `
        ($out | Measure-Object -Average).Average, (& $med $out), `
        (($dur | Measure-Object -Average).Average / 60), $medDur)
}

W '# Cost/latency per Reviewer A launch'
W ''
W ('Corpus rows: {0} (missing token data possible for aborted launches). Source: cumulative thread_token_usage from token_usage_record events; duration = last minus first event timestamp.' -f $rows.Count)
W ''
W '| Group | n | mean total tokens | median total tokens | mean output tokens | median output tokens | mean duration (min) | median duration (min) |'
W '|---|---|---|---|---|---|---|---|'
foreach ($vc in ($rows | Group-Object verdictClass | Sort-Object Count -Descending)) {
    Stats $vc.Name @($vc.Group)
}
W ''

$withTok = @($rows | Where-Object { $_.totalTokens })
W ('Corpus totals: {0:N0} input tokens ({1:N0} cached), {2:N0} output tokens ({3:N0} reasoning), {4:N0} total tokens across {5} launches with token data.' -f `
    (($withTok | Measure-Object inputTokens -Sum).Sum), (($withTok | Measure-Object cachedInputTokens -Sum).Sum), `
    (($withTok | Measure-Object outputTokens -Sum).Sum), (($withTok | Measure-Object reasoningTokens -Sum).Sum), `
    (($withTok | Measure-Object totalTokens -Sum).Sum), $withTok.Count)
$env = @($rows | Where-Object { $_.verdictClass -eq 'ENVELOPE_REJECTED' })
if ($env.Count -gt 0) {
    W ('Waste check - {0} envelope-rejection launches cost {1:N0} total tokens and {2:N1} minutes combined (pure orchestration overhead).' -f `
        $env.Count, (($env | Measure-Object totalTokens -Sum).Sum), ((@($env | ForEach-Object { $_.durationSec } | Where-Object { $null -ne $_ }) | Measure-Object -Sum).Sum / 60))
}
W ''

$outPath = Join-Path $dataDir 'cost-latency.md'
$sb.ToString() | Set-Content -Path $outPath -Encoding UTF8
Write-Output $sb.ToString()
