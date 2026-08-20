#Requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$companionRoot = 'C:\Users\admin\source\repos\general-projects\cursorEscape'
$pathsFile = Join-Path $companionRoot 'scripts\host-sync\baseline-backups.paths.json'

if (-not (Test-Path -LiteralPath $pathsFile)) {
    Write-Output 'baseline-backups.paths.json: fail (missing)'
    exit 1
}

$json = Get-Content -LiteralPath $pathsFile -Raw | ConvertFrom-Json
$fail = $false

function Assert-Pass {
    param([string]$Name, [bool]$Ok)
    $status = if ($Ok) { 'pass' } else { 'fail' }
    Write-Output "${Name}: $status"
    if (-not $Ok) { script:fail = $true }
}

$cursorLive = Join-Path $env:USERPROFILE '.cursor'
$opencodeLive = Join-Path $env:USERPROFILE '.config\opencode'

Assert-Pass 'paths.json parses' ($null -ne $json.cursor -and $null -ne $json.opencode -and $null -ne $json.companionSha -and $null -ne $json.created)
Assert-Pass 'cursor backup dir exists' (Test-Path -LiteralPath $json.cursor -PathType Container)
Assert-Pass 'opencode backup dir exists' (Test-Path -LiteralPath $json.opencode -PathType Container)
function Test-PathIsChildOf {
    param([string]$ChildPath, [string]$ParentPath)
    $childNorm = [IO.Path]::GetFullPath($ChildPath).TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
    $parentNorm = [IO.Path]::GetFullPath($ParentPath).TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
    return $childNorm.StartsWith($parentNorm, [StringComparison]::OrdinalIgnoreCase)
}

Assert-Pass 'cursor backup sibling not inside live' (-not (Test-PathIsChildOf -ChildPath $json.cursor -ParentPath $cursorLive))
Assert-Pass 'opencode backup sibling not inside live' (-not (Test-PathIsChildOf -ChildPath $json.opencode -ParentPath $opencodeLive))
Assert-Pass 'cursor manifest Kind Baseline' ((Get-Content -LiteralPath (Join-Path $json.cursor 'BACKUP_MANIFEST.md') -Raw) -match '\*\*Kind:\*\* Baseline')
Assert-Pass 'opencode manifest Kind Baseline' ((Get-Content -LiteralPath (Join-Path $json.opencode 'BACKUP_MANIFEST.md') -Raw) -match '\*\*Kind:\*\* Baseline')

$headSha = (git -C $companionRoot rev-parse --short HEAD).Trim()
Assert-Pass 'companionSha matches HEAD' ($json.companionSha -eq $headSha)

Assert-Pass 'cursor backup excludes skills-cursor' (-not (Test-Path -LiteralPath (Join-Path $json.cursor 'skills-cursor')))
Assert-Pass 'cursor backup excludes settings.json' (-not (Test-Path -LiteralPath (Join-Path $json.cursor 'settings.json')))
Assert-Pass 'opencode backup includes opencode.json' (Test-Path -LiteralPath (Join-Path $json.opencode 'opencode.json'))

exit $(if ($fail) { 1 } else { 0 })
