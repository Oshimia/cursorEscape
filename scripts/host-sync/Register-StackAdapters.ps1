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

function ConvertTo-SkewIdentitySource {
    # Skew-guard v2 source identity (remediation program, 2026-08-28).
    # Keyed on SOURCE (not Dest strings): base:/shared:/plain classes canonicalize
    # to a stable identity string; the ordered substitution signature is included
    # so different substitution sets across stacks flag as siblings needing sync.
    param(
        [Parameter(Mandatory)]
        [hashtable] $Entry,
        [Parameter(Mandatory)]
        [string] $OverlayRelativeRoot,
        [string] $SharedRoot = 'overlays/opencode'
    )

    $sourceRel = [string]$Entry.Source
    $class = 'plain'
    $canonical = $null

    if ($sourceRel -match '^\s*base:(?<rest>.+)$') {
        $class = 'base'
        $canonical = "base:'$($Matches['rest'].Trim())'"
    }
    elseif ($sourceRel -match '^\s*shared:(?<rest>.+)$') {
        $class = 'shared'
        $canonical = "shared:'$SharedRoot':'$($Matches['rest'].Trim())'"
    }
    else {
        $canonical = "plain:'$OverlayRelativeRoot/$sourceRel'"
    }

    $sig = '<none>'
    if ($Entry.ContainsKey('Substitutions') -and $null -ne $Entry.Substitutions) {
        $pairs = @()
        foreach ($sub in @($Entry.Substitutions)) {
            $f = ([string]$sub.Find).Replace('|', '‖')
            $r = ([string]$sub.Replace).Replace('|', '‖')
            $pairs += "F$f⇒R$r"
        }
        $sig = ($pairs -join '|')
    }

    return "$canonical#$sig"
}

function Get-CrossStackSourceOverlap {
    # Returns @{ Identity; Siblings } rows for every CopyEntries source identity of
    # $StackId that also appears in at least one other registered stack's manifest.
    # Identity = canonicalized source class + ordered-substitution signature, so
    # v2 entries (base:/shared:/Substitutions) participate in the guard.
    # Whole-leaf (Dest) granularity; degeneration note recorded in FA v2 doc.
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
        $sharedRoot = 'overlays/opencode'
        foreach ($key in @('SharedRoot')) {
            if ($manifest.ContainsKey($key) -and -not [string]::IsNullOrWhiteSpace([string]$manifest[$key])) {
                $sharedRoot = [string]$manifest[$key]
            }
        }
        foreach ($entry in @($manifest.CopyEntries)) {
            $entryHt = $entry
            $identity = ConvertTo-SkewIdentitySource -Entry $entryHt `
                -OverlayRelativeRoot ([string]$manifest.OverlayRelativeRoot) -SharedRoot $sharedRoot
            if (-not $sourceOwners.ContainsKey($identity)) {
                $sourceOwners[$identity] = [System.Collections.Generic.List[string]]::new()
            }
            if ($sourceOwners[$identity] -notcontains $sid) {
                [void]$sourceOwners[$identity].Add($sid)
            }
        }
    }

    $result = @()
    foreach ($kv in $sourceOwners.GetEnumerator()) {
        if ($kv.Value.Count -lt 2) { continue }
        if ($kv.Value -notcontains $StackId) { continue }
        $siblings = @($kv.Value | Where-Object { $_ -ne $StackId })
        $result += @{
            Identity = $kv.Key
            Siblings = $siblings
        }
    }
    # Stream rows (no comma operator): callers unroll with foreach/@() — a wrapped
    # single array here makes an EMPTY result indistinguishable from one row.
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
