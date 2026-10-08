param()

$ErrorActionPreference = 'Stop'
$dataDir = Join-Path $PSScriptRoot '..\data'
$path = Join-Path $dataDir 'launches.jsonl'

# Corrected classification (verified manually against session outputs):
# - rollout-2026-10-03T02-52-32: bold '**Verdict: APPROVED**', no heading, full sections.
# - rollout-2026-10-03T03-38-24 / 03-40-11: same-line '## Verdict: X' + '###' sub-headings.
#   All three delivered a usable verdict; format-deviant, not lost.
# - 5 records whose failureFirstLine is the missing-envelope rejection:
#   contract-compliant rejections of malformed parent payloads.
# - Remaining NO_OUTPUT records: no assistant output captured; owner states
#   these were their own mid-review aborts (external), excluded from process
#   waste metrics.

$records = Get-Content $path | ForEach-Object { $_ | ConvertFrom-Json }
$fixed = foreach ($r in $records) {
    if ($r.devIdentity -ne 'production_readiness_reviewer') { $r; continue }
    if ($r.file -like 'rollout-2026-10-03T02-52-32-*' -or
        $r.file -like 'rollout-2026-10-03T03-38-24-*' -or
        $r.file -like 'rollout-2026-10-03T03-40-11-*') {
        $r.verdictClass = 'FORMAT_DEVIANT'
    }
    elseif ($r.failureFirstLine -match 'missing invocation envelope') {
        $r.verdictClass = 'ENVELOPE_REJECTED'
    }
    $r
}
$fixed | ForEach-Object { $_ | ConvertTo-Json -Compress -Depth 5 } | Set-Content -Path $path -Encoding UTF8

$summary = $fixed | Where-Object { $_.devIdentity -eq 'production_readiness_reviewer' } | Group-Object verdictClass | Sort-Object Count -Descending
$summary | ForEach-Object { "{0}: {1}" -f $_.Name, $_.Count }
