#Requires -Version 7.0
<#
.SYNOPSIS
  Distribute companion overlay harness to live host stacks (dry-run default).
.DESCRIPTION
  Modular sync: shared core + per-stack manifest + adapter.
  Dry-run by default; use -Apply for live writes (requires Phase 0 baseline gate).
  Sync does NOT create backups on Apply (companion repo is ongoing SoT).
.PARAMETER Target
  Stack target: Cursor, OpenCode, or All (continue-with-report).
.PARAMETER Apply
  Live write mode. Runs Assert-BaselineBackupsPresent (read-only gate) first.
.PARAMETER FailFast
  With -Target All, stop after first stack failure.
.PARAMETER CompanionRoot
  Optional override for companion checkout root (defaults to repo containing scripts/).
.EXAMPLE
  pwsh ./scripts/Sync-HostHarness.ps1 -Target Cursor
.EXAMPLE
  pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target Cursor
#>
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('Cursor', 'OpenCode', 'All')]
    [string] $Target = 'Cursor',

    [switch] $Apply,

    [switch] $FailFast,

    [string] $CompanionRoot = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$hostSyncRoot = Join-Path $PSScriptRoot 'host-sync'
. (Join-Path $hostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $hostSyncRoot 'HostSync.Core.ps1')
. (Join-Path $hostSyncRoot 'Register-StackAdapters.ps1')

if ([string]::IsNullOrWhiteSpace($CompanionRoot)) {
    $CompanionRoot = Get-DefaultCompanionRoot -HostSyncRoot $hostSyncRoot
}
else {
    $CompanionRoot = Resolve-CompanionRootPath -Path $CompanionRoot
}

$mode = if ($Apply) { [HostSyncMode]::Apply } else { [HostSyncMode]::DryRun }

function Get-TargetStackIds {
    param([string]$TargetName)
    if ($TargetName -eq 'All') {
        return (Get-RegisteredStackIds)
    }
    return @($TargetName)
}

if ($mode -eq [HostSyncMode]::Apply) {
    try {
        Assert-BaselineBackupsPresent -PathsFile (Get-BaselinePathsFile -HostSyncRoot $hostSyncRoot) -CompanionRoot $CompanionRoot
    }
    catch {
        Write-Output "FATAL (gate): $($_.Exception.Message)"
        exit 1
    }
}

$stackIds = Get-TargetStackIds -TargetName $Target
$reports = [System.Collections.Generic.List[hashtable]]::new()
$anyFailed = $false

foreach ($stackId in $stackIds) {
    Write-Output "--- Target: $stackId ---"
    try {
        $manifest = Get-StackManifest -StackId $stackId -HostSyncRoot $hostSyncRoot
        $adapterPath = Get-StackAdapterScript -StackId $stackId -HostSyncRoot $hostSyncRoot
        . $adapterPath
        $report = Invoke-StackHarnessSync -Mode $mode -CompanionRoot $CompanionRoot -Manifest $manifest
        Write-HostSyncReport -Report $report
        [void]$reports.Add($report)
        if (-not $report.Success) {
            $anyFailed = $true
            if ($FailFast) { break }
        }
    }
    catch {
        $anyFailed = $true
        Write-Output "FATAL ($stackId): $($_.Exception.Message)"
        if ($FailFast) { break }
    }
}

Write-Output "=== Summary: mode=$($mode.ToString()) target=$Target stacks=$($stackIds -join ',') success=$(-not $anyFailed) ==="
exit $(if ($anyFailed) { 1 } else { 0 })
