param(
    [Parameter(Mandatory = $true)][string]$FileName,
    [Parameter(Mandatory = $true)][string]$OutName,
    [switch]$AlsoBug
)

$ErrorActionPreference = 'Stop'
$samplesDir = Join-Path $PSScriptRoot '..\samples'
New-Item -ItemType Directory -Force -Path $samplesDir | Out-Null

$f = Get-ChildItem 'C:\Users\admin\.codex\sessions' -Recurse -Filter $FileName | Select-Object -First 1
if (-not $f) { throw "File not found: $FileName" }
$raw = [System.IO.File]::ReadAllText($f.FullName)

$envelope = $null
$outputs = New-Object System.Collections.Generic.List[string]
foreach ($line in ($raw -split "`n")) {
    if ($line -notlike '*"type":"response_item"*') { continue }
    try { $o = $line | ConvertFrom-Json } catch { continue }
    $p = $o.payload
    if ($p.type -ne 'message') { continue }
    $txt = ''
    foreach ($c in $p.content) { if ($c.text) { $txt += $c.text } }
    if ($p.role -eq 'user' -and $txt.StartsWith('You are the `')) {
        if ($null -eq $envelope) { $envelope = $txt } else { $envelope = $envelope + "`n`n---`n`n" + $txt }
    }
    elseif ($p.role -eq 'assistant' -and $txt.Contains('## Verdict')) { $outputs.Add($txt) }
}

$outPath = Join-Path $samplesDir ($OutName + '.md')
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# Sample: $OutName")
[void]$sb.AppendLine("Source file: $($f.Name)")
[void]$sb.AppendLine('')
if ($envelope) {
    [void]$sb.AppendLine('## Invocation envelope (parent payload)')
    [void]$sb.AppendLine()
    [void]$sb.AppendLine('```markdown')
    [void]$sb.AppendLine($envelope)
    [void]$sb.AppendLine('```')
    [void]$sb.AppendLine('')
}
[void]$sb.AppendLine('## Reviewer output(s)')
foreach ($t in $outputs) {
    [void]$sb.AppendLine()
    [void]$sb.AppendLine('---')
    [void]$sb.AppendLine()
    [void]$sb.AppendLine($t)
}
$sb.ToString() | Set-Content -Path $outPath -Encoding UTF8
Write-Output ("Wrote {0} (outputs: {1}, envelope: {2})" -f $outPath, $outputs.Count, [bool]$envelope)
