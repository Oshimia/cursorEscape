#Requires -Version 7.0
<#
.SYNOPSIS
  Phase 0: create harness-only baseline backups (read/copy live; no live mutation).
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$companionRoot = 'C:\Users\admin\source\repos\general-projects\cursorEscape'
$cursorLive = Join-Path $env:USERPROFILE '.cursor'
$opencodeLive = Join-Path $env:USERPROFILE '.config\opencode'

$cursorBackup = Join-Path $env:USERPROFILE ".cursor-backup-pre-host-sync-build-$stamp"
$opencodeBackup = Join-Path $env:USERPROFILE '.config' "opencode-backup-pre-host-sync-build-$stamp"

function Test-PathIsChildOf {
    param([string]$ChildPath, [string]$ParentPath)
    $childNorm = [IO.Path]::GetFullPath($ChildPath).TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
    $parentNorm = [IO.Path]::GetFullPath($ParentPath).TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
    return $childNorm.StartsWith($parentNorm, [StringComparison]::OrdinalIgnoreCase)
}

# Guard: backups must be siblings, never inside live homes
foreach ($pair in @(
    @{ Live = $cursorLive; Backup = $cursorBackup },
    @{ Live = $opencodeLive; Backup = $opencodeBackup }
)) {
    if (Test-PathIsChildOf -ChildPath $pair.Backup -ParentPath $pair.Live) {
        throw "Backup path must not be inside live home: $($pair.Backup)"
    }
}

New-Item -ItemType Directory -Path $cursorBackup -Force | Out-Null
New-Item -ItemType Directory -Path $opencodeBackup -Force | Out-Null

function Copy-LeafIfPresent {
    param(
        [string]$SourceRoot,
        [string]$DestRoot,
        [string]$RelativePath
    )
    $src = Join-Path $SourceRoot $RelativePath
    if (-not (Test-Path -LiteralPath $src)) { return $false }
    $dest = Join-Path $DestRoot $RelativePath
    $destParent = Split-Path -Parent $dest
    if ($destParent -and -not (Test-Path -LiteralPath $destParent)) {
        New-Item -ItemType Directory -Path $destParent -Force | Out-Null
    }
    if (Test-Path -LiteralPath $src -PathType Container) {
        robocopy $src $dest /E /NFL /NDL /NJH /NJS /NC /NS /NP | Out-Null
        if ($LASTEXITCODE -ge 8) { throw "robocopy failed ($LASTEXITCODE): $src -> $dest" }
    }
    else {
        Copy-Item -LiteralPath $src -Destination $dest -Force
    }
    return $true
}

$cursorIncludes = @('skills', 'agents', 'rules', 'review-subagent-models.md', 'docs/workflow')
$opencodeIncludes = @('instructions', 'AGENTS.md', 'skills', 'agents', 'opencode.json')

foreach ($leaf in $cursorIncludes) {
    Copy-LeafIfPresent -SourceRoot $cursorLive -DestRoot $cursorBackup -RelativePath $leaf | Out-Null
}
foreach ($leaf in $opencodeIncludes) {
    $copied = Copy-LeafIfPresent -SourceRoot $opencodeLive -DestRoot $opencodeBackup -RelativePath $leaf
    if ($leaf -eq 'opencode.json' -and -not $copied) {
        throw "Required leaf missing on live OpenCode harness: opencode.json"
    }
}

$sha = (git -C $companionRoot rev-parse --short HEAD).Trim()
$created = (Get-Date).ToUniversalTime().ToString('o')

$pathsJson = @{
    cursor       = $cursorBackup
    opencode     = $opencodeBackup
    companionSha = $sha
    created      = $created
} | ConvertTo-Json -Compress

$hostSyncDir = Join-Path $companionRoot 'scripts\host-sync'
New-Item -ItemType Directory -Path $hostSyncDir -Force | Out-Null
$pathsFile = Join-Path $hostSyncDir 'baseline-backups.paths.json'
Set-Content -LiteralPath $pathsFile -Value $pathsJson -Encoding utf8NoBOM

function Write-BaselineManifest {
    param(
        [string]$BackupPath,
        [string]$LivePath,
        [string]$Stack,
        [string[]]$Includes,
        [string]$RestoreBlock
    )
    $manifest = @"
# $Stack harness backup — Phase 0 baseline (pre host-sync-build)

**Kind:** Baseline
**Created:** $created
**Backup path:** ``$BackupPath``
**Live path:** ``$LivePath``
**Companion:** ``$companionRoot``
**Companion SHA at backup:** ``$sha``

## BackupInclude

$(($Includes | ForEach-Object { "- ``$_``" }) -join "`n")

## Restore (after full quit of $Stack)

``````powershell
$RestoreBlock
``````

Then restart $Stack.

## Notes

- Phase 0 gate artifact: ``$pathsFile``
- Restore precedence: Phase 0 baseline ``pre-host-sync-build`` → per-Apply ``host-sync-apply`` → legacy archaeology only.
- Do **not** copy ``skills-cursor/`` or Cursor ``settings.json`` into baseline backups.
"@
    Set-Content -LiteralPath (Join-Path $BackupPath 'BACKUP_MANIFEST.md') -Value $manifest -Encoding utf8
}

$cursorRestore = @"
`$b = '$cursorBackup'
`$live = '$cursorLive'
Copy-Item -Recurse -Force (Join-Path `$b 'skills') (Join-Path `$live 'skills')
Copy-Item -Recurse -Force (Join-Path `$b 'agents') (Join-Path `$live 'agents')
Copy-Item -Recurse -Force (Join-Path `$b 'rules') (Join-Path `$live 'rules')
if (Test-Path (Join-Path `$b 'docs\workflow')) {
  New-Item -ItemType Directory -Path (Join-Path `$live 'docs') -Force | Out-Null
  Copy-Item -Recurse -Force (Join-Path `$b 'docs\workflow') (Join-Path `$live 'docs\workflow')
}
if (Test-Path (Join-Path `$b 'review-subagent-models.md')) {
  Copy-Item -Force (Join-Path `$b 'review-subagent-models.md') (Join-Path `$live 'review-subagent-models.md')
}
"@

$opencodeRestore = @"
`$b = '$opencodeBackup'
`$live = '$opencodeLive'
Copy-Item -Recurse -Force (Join-Path `$b 'instructions') (Join-Path `$live 'instructions')
Copy-Item -Force (Join-Path `$b 'AGENTS.md') (Join-Path `$live 'AGENTS.md')
Copy-Item -Recurse -Force (Join-Path `$b 'skills') (Join-Path `$live 'skills')
Copy-Item -Recurse -Force (Join-Path `$b 'agents') (Join-Path `$live 'agents')
Copy-Item -Force (Join-Path `$b 'opencode.json') (Join-Path `$live 'opencode.json')
"@

Write-BaselineManifest -BackupPath $cursorBackup -LivePath $cursorLive -Stack 'Cursor' -Includes $cursorIncludes -RestoreBlock $cursorRestore
Write-BaselineManifest -BackupPath $opencodeBackup -LivePath $opencodeLive -Stack 'OpenCode' -Includes $opencodeIncludes -RestoreBlock $opencodeRestore

Write-Output "CURSOR_BACKUP=$cursorBackup"
Write-Output "OPENCODE_BACKUP=$opencodeBackup"
Write-Output "PATHS_FILE=$pathsFile"
Write-Output "COMPANION_SHA=$sha"
Write-Output "CREATED=$created"
