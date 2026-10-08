param()

$ErrorActionPreference = 'Stop'
$dataDir = Join-Path $PSScriptRoot '..\data'
$samplesDir = Join-Path $PSScriptRoot '..\category-scan'
New-Item -ItemType Directory -Force -Path $samplesDir | Out-Null

$recs = Get-Content (Join-Path $dataDir 'launches.jsonl') | ForEach-Object { $_ | ConvertFrom-Json }
$prod = @($recs | Where-Object { $_.devIdentity -eq 'production_readiness_reviewer' })

$categories = [ordered]@{
    'size/line-gate'          = 'size gate|line split|split threshold|1,000 lines|800 lines|exceeds the (mandatory|plan)'
    'payload/iteration'       = 'review iteration|invocation envelope|missing invocation|cumulative per-leg'
    'stale-doc/roadmap'       = 'roadmap|stale doc|doc drift|stale .* doc|superseded .*(doc|readme|guide)'
    'test-gap'                = 'regression test|test coverage|missing .* test|untested|UNTESTED'
    'supersession/lifecycle'  = 'supersession|lifecycle|naming closure'
    'safety/data-loss'        = 'path containment|overwrite|erasure|data loss|backup|unsafe|injection'
    'ci-gate'                 = 'ci mode|fast ci|claimed-only|skipped'
    'identity/hash'           = 'hash|identity|fingerprint'
}

$counts = @{}
foreach ($k in $categories.Keys) { $counts[$k] = 0 }
$crWithBlocking = 0
$filesScanned = 0

foreach ($r in $prod) {
    if ($r.verdictClass -notin @('CHANGES REQUESTED', 'FORMAT_DEVIANT')) { continue }
    $f = Get-ChildItem 'C:\Users\admin\.codex\sessions' -Recurse -Filter $r.file | Select-Object -First 1
    if (-not $f) { continue }
    $raw = [System.IO.File]::ReadAllText($f.FullName)
    $out = $null
    foreach ($line in ($raw -split "`n")) {
        if ($line -notlike '*"type":"response_item"*') { continue }
        try { $o = $line | ConvertFrom-Json } catch { continue }
        $p = $o.payload
        if ($p.type -eq 'message' -and $p.role -eq 'assistant') {
            $txt = ''
            foreach ($c in $p.content) { if ($c.text) { $txt += $c.text } }
            if ($txt.Contains('## Verdict')) { $out = $txt }
        }
    }
    if (-not $out) { continue }
    $filesScanned++
    $blk = $null; $btd = $null
    $m = [regex]::Match($out, '(?s)(?m)^## Blocking findings\s*\r?\n(.*?)(?=\r?\n## |\z)')
    if ($m.Success) { $blk = $m.Groups[1].Value }
    $m = [regex]::Match($out, '(?s)(?m)^## Blocking test/docs\s*\r?\n(.*?)(?=\r?\n## |\z)')
    if ($m.Success) { $btd = $m.Groups[1].Value }
    $combined = "$blk`n$btd"
    if ($combined -match '(?m)^\s*\d+\.\s') { $crWithBlocking++ }
    $hitFile = @()
    foreach ($k in $categories.Keys) {
        if ($combined -match $categories[$k]) {
            $counts[$k]++
            $hitFile += $k
        }
    }
    $scanRec = [ordered]@{ file = $r.file; categories = ($hitFile -join ',') }
    [pscustomobject]$scanRec | ConvertTo-Json -Compress | Set-Content -Path (Join-Path $samplesDir ($r.file + '.json')) -Encoding UTF8
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('# Blocking-finding category scan (CR launches)')
[void]$sb.AppendLine('')
[void]$sb.AppendLine(("CR launches scanned (incl. format-deviant CR): {0}; with numbered blocking items: {1}" -f $filesScanned, $crWithBlocking))
[void]$sb.AppendLine('')
[void]$sb.AppendLine('| Category | CR launches matching | % of scanned |')
[void]$sb.AppendLine('|---|---|---|')
foreach ($k in $categories.Keys) {
    [void]$sb.AppendLine(('| {0} | {1} | {2:P1} |' -f $k, $counts[$k], ($counts[$k] / [Math]::Max(1, $filesScanned))))
}
$outPath = Join-Path $dataDir 'finding-categories.md'
$sb.ToString() | Set-Content -Path $outPath -Encoding UTF8
Write-Output $sb.ToString()
