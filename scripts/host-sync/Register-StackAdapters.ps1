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

function Get-CrossStackSourceOverlap {
    # Returns @{ Source; Stacks } rows for every CopyEntries.Source of $StackId
    # that also appears in at least one other registered stack's manifest.
    # Global-distribution guard input: a shared source pushed to one stack only
    # leaves sibling stacks stale.
    param(
        [Parameter(Mandatory)]
        [string] $StackId,
        [string]$HostSyncRoot = $PSScriptRoot
    )

    $sourceOwners = @{}
    foreach ($sid in (Get-RegisteredStackIds)) {
        $manifest = Get-StackManifest -StackId $sid -HostSyncRoot $HostSyncRoot
        foreach ($entry in @($manifest.CopyEntries)) {
            $src = [string]$entry.Source
            if (-not $sourceOwners.ContainsKey($src)) {
                $sourceOwners[$src] = [System.Collections.Generic.List[string]]::new()
            }
            if ($sourceOwners[$src] -notcontains $sid) {
                [void]$sourceOwners[$src].Add($sid)
            }
        }
    }

    $result = @()
    foreach ($kv in $sourceOwners.GetEnumerator()) {
        if ($kv.Value.Count -lt 2) { continue }
        if ($kv.Value -notcontains $StackId) { continue }
        $siblings = @($kv.Value | Where-Object { $_ -ne $StackId })
        $result += @{
            Source  = $kv.Key
            Sibling = $siblings
        }
    }
    return $result
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
