#Requires -Version 7.0
Set-StrictMode -Version Latest

function Get-StackManifest {
    param(
        [Parameter(Mandatory)]
        [string] $StackId,
        [string]$HostSyncRoot = $PSScriptRoot
    )

    $manifestPath = Join-Path $HostSyncRoot "manifests/$($StackId.ToLower()).manifest.psd1"
    if (-not (Test-Path -LiteralPath $manifestPath)) {
        throw "Manifest not found for stack '$StackId': $manifestPath"
    }
    return (Import-PowerShellDataFile -LiteralPath $manifestPath)
}

function Get-RegisteredStackIds {
    return @('Cursor', 'OpenCode', 'Antigravity')
}

function Get-StackAdapterScript {
    param(
        [Parameter(Mandatory)]
        [string] $StackId,
        [string]$HostSyncRoot = $PSScriptRoot
    )

    $adapterPath = Join-Path $HostSyncRoot "adapters/$StackId.Adapter.ps1"
    if (-not (Test-Path -LiteralPath $adapterPath)) {
        throw "Adapter not found for stack '$StackId': $adapterPath"
    }
    return $adapterPath
}

function Import-StackAdapter {
    param(
        [Parameter(Mandatory)]
        [string] $StackId,
        [string]$HostSyncRoot = $PSScriptRoot
    )

    $adapterPath = Get-StackAdapterScript -StackId $StackId -HostSyncRoot $HostSyncRoot
    . $adapterPath
}
