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
    # Codex bring-up Phase 3 2026-09-08: seventh stack registered source-only.
    return @('Cursor', 'OpenCode', 'Antigravity', 'Vscode', 'Cline', 'Kilocode', 'Codex')
}

function Get-StackApplyState {
    param(
        [Parameter(Mandatory)]
        [hashtable] $Manifest
    )

    # Absent ApplyState means Active for all established stacks. Codex is force-
    # held in BringUp by the Phase 3 lifecycle gate: registry membership makes it
    # visible to plans and CI, while three-client smoke acceptance (Phase 4) is
    # required before any Apply. Changing the manifest value alone cannot bypass
    # this gate.
    $configuredState = 'Active'
    if ($Manifest.ContainsKey('ApplyState') -and -not [string]::IsNullOrWhiteSpace([string]$Manifest.ApplyState)) {
        $configuredState = [string]$Manifest.ApplyState
    }
    if ($configuredState -notin @('Active', 'BringUp')) {
        throw "Invalid ApplyState '$configuredState' for stack '$($Manifest.StackId)'. Valid: Active, BringUp"
    }
    if ($Manifest.StackId -eq 'Codex') {
        return 'BringUp'
    }
    return $configuredState
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

    if (-not $Entry.ContainsKey('Source')) {
        # Guard-only destinations have no source and are intentionally distinct
        # identities (Codex AGENTS.override.md is the first such destination).
        return "guard-only:'$($Entry.Dest)'"
    }
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
        $entries = if ($manifest.ContainsKey('CopyEntries')) { @($manifest.CopyEntries) } else { @($manifest.DestinationEntries) }
        foreach ($entry in $entries) {
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

    # Dispatch convention (kilo-cline bring-up 2026-09-01, owner-approved):
    # prefer a specialized per-stack adapter; otherwise fall back to the shared
    # manifest-driven Generic adapter (copy-out copy engine, no custom legs).
    # Cursor/OpenCode keep specialized adapters (real legs); Antigravity/Vscode
    # clone files were deleted — they dispatch to Generic byte-identically.
    $adapterPath = Join-Path $HostSyncRoot "adapters/$StackId.Adapter.ps1"
    if (Test-Path -LiteralPath $adapterPath) {
        return $adapterPath
    }
    $genericPath = Join-Path $HostSyncRoot 'adapters/Generic.Adapter.ps1'
    if (Test-Path -LiteralPath $genericPath) {
        return $genericPath
    }
    throw "Adapter not found for stack '$StackId': $adapterPath (and no Generic.Adapter.ps1 at $genericPath)"
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
