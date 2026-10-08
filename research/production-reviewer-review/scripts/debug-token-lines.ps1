param()

$f = Get-ChildItem 'C:\Users\admin\.codex\sessions' -Recurse -Filter 'rollout-2026-10-08T03-55-47-01a11826-a172-7fb0-bb60-d180f19308f1.jsonl' | Select-Object -First 1
$m = 0; $rec = 0; $parsed = 0; $lastTotals = $null
foreach ($line in [System.IO.File]::ReadLines($f.FullName)) {
    if ($line -like '*thread_token_usage*') { $m++ }
    if ($line -like '*token_usage_record*') {
        $rec++
        try {
            $o = $line | ConvertFrom-Json
            if ($o.type -eq 'token_usage_record') { $parsed++; $lastTotals = $o.payload.thread_token_usage }
        } catch { Write-Output ('parse error: ' + $_.Exception.Message) }
    }
}
Write-Output ('lines matching thread_token_usage: ' + $m)
Write-Output ('lines matching token_usage_record: ' + $rec)
Write-Output ('parsed token_usage_record lines: ' + $parsed)
if ($lastTotals) { Write-Output ('last totals: ' + ($lastTotals | ConvertTo-Json -Compress)) } else { Write-Output 'last totals: NONE' }
