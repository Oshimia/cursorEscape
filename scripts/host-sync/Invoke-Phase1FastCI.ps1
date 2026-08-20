#Requires -Version 7.0
<#
.SYNOPSIS
  Phase 1 Fast CI for host-harness-sync (dry-run + gate checks; no live Apply).
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$companionRoot = 'C:\Users\admin\source\repos\general-projects\cursorEscape'
$syncScript = Join-Path $companionRoot 'scripts\Sync-HostHarness.ps1'
$pathsFile = Join-Path $companionRoot 'scripts\host-sync\baseline-backups.paths.json'
$hostSyncRoot = Join-Path $companionRoot 'scripts\host-sync'

. (Join-Path $hostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $hostSyncRoot 'HostSync.Core.ps1')

$originalPathsBytes = $null
if (Test-Path -LiteralPath $pathsFile) {
    $originalPathsBytes = [IO.File]::ReadAllBytes($pathsFile)
}

$fail = $false

function Assert-Pass {
    param([string]$Name, [bool]$Ok)
    $status = if ($Ok) { 'pass' } else { 'fail' }
    Write-Output "${Name}: $status"
    if (-not $Ok) { $script:fail = $true }
}

function Get-LiveCursorSnapshot {
    param([string]$LiveRoot)
    $snapshot = @{}
    if (-not (Test-Path -LiteralPath $LiveRoot)) { return $snapshot }
    Get-ChildItem -LiteralPath $LiveRoot -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
        $snapshot[$_.FullName] = $_.LastWriteTimeUtc.Ticks
    }
    return $snapshot
}

function Test-LiveCursorUnchanged {
    param([hashtable]$Before, [hashtable]$After)
    foreach ($key in $Before.Keys) {
        if (-not $After.ContainsKey($key)) { return $false }
        if ($Before[$key] -ne $After[$key]) { return $false }
    }
    foreach ($key in $After.Keys) {
        if (-not $Before.ContainsKey($key)) { return $false }
    }
    return $true
}

# 1) Dry-run Cursor exits 0
$liveCursor = Join-Path $env:USERPROFILE '.cursor'
$before = Get-LiveCursorSnapshot -LiveRoot $liveCursor
& pwsh -NoProfile -File $syncScript -Target Cursor
$dryRunExit = $LASTEXITCODE
Assert-Pass 'dry-run Cursor exit 0' ($dryRunExit -eq 0)

$after = Get-LiveCursorSnapshot -LiveRoot $liveCursor
Assert-Pass 'dry-run made no live writes' (Test-LiveCursorUnchanged -Before $before -After $after)

# 2) Apply without paths file → non-zero
$backupPathsBytes = $null
if (Test-Path -LiteralPath $pathsFile) {
    $backupPathsBytes = [IO.File]::ReadAllBytes($pathsFile)
    Remove-Item -LiteralPath $pathsFile -Force
}
try {
    & pwsh -NoProfile -File $syncScript -Target Cursor -Apply
    $gateExit = $LASTEXITCODE
    Assert-Pass 'Apply without paths file non-zero' ($gateExit -ne 0)
}
finally {
    if ($null -ne $backupPathsBytes) {
        [IO.File]::WriteAllBytes($pathsFile, $backupPathsBytes)
    }
}

# 3) Static: no host-sync-apply backup creation code paths
$syncSources = @(
    (Join-Path $companionRoot 'scripts\Sync-HostHarness.ps1')
    (Join-Path $hostSyncRoot 'HostSync.Core.ps1')
    (Join-Path $hostSyncRoot 'adapters\Cursor.Adapter.ps1')
)
$combined = ($syncSources | ForEach-Object { Get-Content -LiteralPath $_ -Raw }) -join "`n"
Assert-Pass 'no host-sync-apply backup paths in sync sources' ($combined -notmatch 'host-sync-apply-|SkipBackup|-SkipBackup')
Assert-Pass 'Assert-BaselineBackupsPresent present (read-only gate)' ($combined -match 'Assert-BaselineBackupsPresent')
Assert-Pass 'Assert-NoPerApplyBackupArtifacts present' ($combined -match 'Assert-NoPerApplyBackupArtifacts')

# 4) Apply gate passes read-only check when paths restored
try {
    Assert-BaselineBackupsPresent -PathsFile $pathsFile -CompanionRoot $companionRoot
    Assert-Pass 'baseline gate read-only assert' $true
}
catch {
    Assert-Pass 'baseline gate read-only assert' $false
}

# 5) No host-sync-apply dirs currently on machine (forbidden artifact)
try {
    Assert-NoPerApplyBackupArtifacts
    Assert-Pass 'no host-sync-apply dirs on host' $true
}
catch {
    Assert-Pass 'no host-sync-apply dirs on host' $false
}

if ($null -ne $originalPathsBytes) {
    $finalPathsBytes = [IO.File]::ReadAllBytes($pathsFile)
    $bytesMatch = ($originalPathsBytes.Length -eq $finalPathsBytes.Length)
    if ($bytesMatch) {
        for ($i = 0; $i -lt $originalPathsBytes.Length; $i++) {
            if ($originalPathsBytes[$i] -ne $finalPathsBytes[$i]) {
                $bytesMatch = $false
                break
            }
        }
    }
    Assert-Pass 'paths.json bytes unchanged after Fast CI' $bytesMatch
}

exit $(if ($fail) { 1 } else { 0 })
