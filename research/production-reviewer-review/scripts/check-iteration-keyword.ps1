param()

$rows = Import-Csv (Join-Path $PSScriptRoot '..\data\envelope-content.csv')
$missing = @($rows | Where-Object { $_.iterationValue -eq '' -and $_.verdictClass -eq 'APPROVED' })
$withKw = 0
foreach ($r in $missing) {
    $f = Get-ChildItem 'C:\Users\admin\.codex\sessions' -Recurse -Filter $r.file | Select-Object -First 1
    $raw = [System.IO.File]::ReadAllText($f.FullName)
    $env = $null
    foreach ($line in ($raw -split "`n")) {
        if ($line -notlike '*"type":"response_item"*') { continue }
        try { $o = $line | ConvertFrom-Json } catch { continue }
        $p = $o.payload
        if ($p.type -ne 'message' -or $p.role -ne 'user') { continue }
        $txt = ''
        foreach ($c in $p.content) { if ($c.text) { $txt += $c.text } }
        if ($txt.StartsWith('You are the `production_readiness_reviewer` agent')) { $env = $txt }
    }
    $m = [regex]::Match($env, '(?i)iterat')
    if ($m.Success) {
        $withKw++
        $start = [Math]::Max(0, $m.Index - 40)
        $ctx = $env.Substring($start, [Math]::Min(90, $env.Length - $start))
        $ctx = $ctx -replace "`r", ' ' -replace "`n", ' | '
        Write-Output ("HAS keyword: {0} -> ...{1}..." -f $r.file.Substring(8, 26), $ctx)
    }
}
Write-Output ('APPROVED with iteration missing but keyword present: {0} of {1}' -f $withKw, $missing.Count)
