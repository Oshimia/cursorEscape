#Requires -Version 7.0
<#
.SYNOPSIS
  Produces or verifies normalized planned-render hashes for the six registered pre-Codex stacks.

.DESCRIPTION
  The renderer is source-only: it uses an explicit temporary live root and never imports
  user-home state. Hashes normalize only line endings and one trailing newline, keeping
  the ledger useful as a regression guard while avoiding Windows/Unix EOL noise.
#>
[CmdletBinding()]
param(
    [string] $CompanionRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)),
    [string] $LedgerPath = (Join-Path $PSScriptRoot 'render-baselines/existing-six-stack-render-hashes-2026-09.json'),
    [switch] $Verify,
    [switch] $WriteLedger,
    [switch] $SkipRepeatability
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Test-PathWithin {
    param(
        [Parameter(Mandatory)][string] $Child,
        [Parameter(Mandatory)][string] $Parent
    )
    $childFull = [IO.Path]::GetFullPath($Child).TrimEnd([char]'\', [char]'/') + [IO.Path]::DirectorySeparatorChar
    $parentFull = [IO.Path]::GetFullPath($Parent).TrimEnd([char]'\', [char]'/') + [IO.Path]::DirectorySeparatorChar
    return $childFull.StartsWith($parentFull, [StringComparison]::OrdinalIgnoreCase)
}

function Assert-NoReparseAncestor {
    param([Parameter(Mandatory)][string] $Path)
    $full = [IO.Path]::GetFullPath($Path).TrimEnd([char]'\', [char]'/')
    $rootPath = [IO.Path]::GetPathRoot($full)
    $current = $full
    while ($current -and $current.Length -gt $rootPath.Length) {
        if (Test-Path -LiteralPath $current) {
            $item = Get-Item -LiteralPath $current -Force
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                throw "Reparse point detected in ancestor chain: $current"
            }
        }
        $parent = [IO.Path]::GetDirectoryName($current)
        if (-not $parent -or $parent -eq $current) { break }
        $current = $parent
    }
}

function Get-NormalizedSha256 {
    param([Parameter(Mandatory)][string] $Content)
    $normalized = (($Content -replace "`r`n", "`n").TrimEnd("`r", "`n")) + "`n"
    $bytes = [Text.UTF8Encoding]::new($false).GetBytes($normalized)
    return ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($bytes))).ToLowerInvariant()
}

function ConvertTo-CanonicalRenderNode {
    param($Node)
    if ($null -eq $Node) { return $null }
    if ($Node -is [System.Collections.IDictionary]) {
        $ordered = [ordered]@{}
        # The ledger is a normalized evidence projection, not an adapter write. Sort
        # every mapping class (Hashtable, OrderedDictionary, and generic IDictionary)
        # so insertion order cannot alter a source-only render hash.
        $keyStrings = [string[]]@($Node.Keys | ForEach-Object { [string]$_ })
        [System.Array]::Sort($keyStrings, [StringComparer]::Ordinal)
        foreach ($key in $keyStrings) {
            $ordered[$key] = ConvertTo-CanonicalRenderNode $Node[$key]
        }
        return ,$ordered
    }
    if ($Node -is [pscustomobject]) {
        $ordered = [ordered]@{}
        $properties = [object[]]@($Node.PSObject.Properties)
        [System.Array]::Sort($properties, [Comparison[object]]{ param($a, $b) [StringComparer]::Ordinal.Compare([string]$a.Name, [string]$b.Name) })
        foreach ($property in $properties) {
            $ordered[$property.Name] = ConvertTo-CanonicalRenderNode $property.Value
        }
        return ,$ordered
    }
    if ($Node -is [System.Collections.IList] -and $Node -isnot [string]) {
        $items = [System.Collections.Generic.List[object]]::new()
        foreach ($item in $Node) { [void]$items.Add((ConvertTo-CanonicalRenderNode $item)) }
        return ,$items.ToArray()
    }
    return $Node
}

function Test-LedgerArtifactsEqual {
    param($Left, $Right)
    if ($Left.schemaVersion -ne $Right.schemaVersion -or $Left.kind -ne $Right.kind -or $Left.normalization -ne $Right.normalization) { return $false }
    if (@($Left.stacks).Count -ne @($Right.stacks).Count -or @($Left.entries).Count -ne @($Right.entries).Count) { return $false }
    for ($index = 0; $index -lt @($Left.stacks).Count; $index++) {
        if ($Left.stacks[$index] -ne $Right.stacks[$index]) { return $false }
    }
    for ($index = 0; $index -lt @($Left.entries).Count; $index++) {
        $leftEntry = $Left.entries[$index]
        $rightEntry = $Right.entries[$index]
        if ($leftEntry.stack -ne $rightEntry.stack -or $leftEntry.destinationCount -ne $rightEntry.destinationCount -or $leftEntry.sha256 -ne $rightEntry.sha256) { return $false }
    }
    return $true
}

function Add-RenderRows {
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][System.Collections.Generic.List[hashtable]] $Rows,
        [Parameter(Mandatory)][string] $StackId,
        [Parameter(Mandatory)][hashtable] $Manifest,
        [Parameter(Mandatory)][string] $CompanionRoot,
        [Parameter(Mandatory)][string] $ScratchRoot
    )
    $overlayRoot = Join-Path $CompanionRoot ($Manifest.OverlayRelativeRoot -replace '/', [IO.Path]::DirectorySeparatorChar)
    $sharedRoot = if ($Manifest.ContainsKey('SharedRoot')) { [string]$Manifest.SharedRoot } else { 'overlays/opencode' }
    foreach ($entry in @($Manifest.CopyEntries)) {
        $report = New-HostSyncReport -StackId $StackId -Mode ([HostSyncMode]::DryRun)
        Copy-ManifestEntry -Report $report -Mode ([HostSyncMode]::DryRun) -CompanionRoot $CompanionRoot -OverlayRoot $overlayRoot `
            -LiveRoot $ScratchRoot -Entry $entry -SharedRoot $sharedRoot
        if (-not $report.Success) { throw "Render failed for $StackId/$($entry.Dest): $($report.Errors -join '; ')" }
        $dest = if ($entry.ContainsKey('Dest')) { [string]$entry.Dest } else { [string]$entry.Source }
        [void]$Rows.Add([ordered]@{ stack = $StackId; destination = $dest; sha256 = Get-NormalizedSha256 $report.PlannedContent[$dest] })
    }
    if ($StackId -eq 'Cursor') {
        foreach ($ruleId in @($Manifest.HybridRuleIds)) {
            [void]$Rows.Add([ordered]@{ stack = $StackId; destination = "rules/$ruleId.mdc"; sha256 = Get-NormalizedSha256 (Get-PlannedHybridRuleContent -CompanionRoot $CompanionRoot -RuleId $ruleId) })
        }
    }
    if ($StackId -eq 'OpenCode') {
        $gate = @{ Source = 'base:rules/iterative-plan-review.md'; Dest = [string]$Manifest.AgentsDualWrite.InstructionsRel; Parts = @($Manifest.AgentsDualWrite.Parts); Footer = @($Manifest.AgentsDualWrite.Footer) }
        $report = New-HostSyncReport -StackId $StackId -Mode ([HostSyncMode]::DryRun)
        Copy-ManifestEntry -Report $report -Mode ([HostSyncMode]::DryRun) -CompanionRoot $CompanionRoot -OverlayRoot $overlayRoot `
            -LiveRoot $ScratchRoot -Entry $gate -SharedRoot $sharedRoot
        if (-not $report.Success) { throw "Render failed for OpenCode AGENTS mirror: $($report.Errors -join '; ')" }
        $gateContent = $report.PlannedContent[[string]$Manifest.AgentsDualWrite.InstructionsRel]
        [void]$Rows.Add([ordered]@{ stack = $StackId; destination = 'AGENTS.md'; sha256 = Get-NormalizedSha256 $gateContent })

        # Stable synthetic home: no user state is consulted, while the tokenized
        # JSON render stays reproducible across randomly named scratch directories.
        $specimen = Resolve-OpenCodeSpecimenJson -SpecimenPath (Join-Path $overlayRoot $Manifest.JsonMerge.SpecimenRel) `
            -CompanionRoot $CompanionRoot -OpenCodeHome 'C:/codex-phase0-ledger/opencode-home'
        $merged = Merge-OpenCodeHarnessJson -Specimen $specimen -LiveJsonPath (Join-Path $ScratchRoot 'absent-opencode.json') `
            -PreserveTopLevelKeys @($Manifest.JsonMerge.PreserveTopLevelKeys)
        [void]$Rows.Add([ordered]@{ stack = $StackId; destination = 'opencode.json'; sha256 = Get-NormalizedSha256 ((ConvertTo-CanonicalRenderNode $merged) | ConvertTo-Json -Depth 100) })
    }
}

$companionRoot = [IO.Path]::GetFullPath($CompanionRoot)
$realCodexRoot = [IO.Path]::GetFullPath((Join-Path $env:USERPROFILE '.codex')).TrimEnd([char]'\', [char]'/')
$realSkillRoot = [IO.Path]::GetFullPath((Join-Path $env:USERPROFILE '.agents/skills')).TrimEnd([char]'\', [char]'/')
$scratch = Join-Path ([IO.Path]::GetTempPath()) ('codex-phase0-ledger-' + [Guid]::NewGuid().ToString('N'))
try {
    $scratchFull = [IO.Path]::GetFullPath($scratch).TrimEnd([char]'\', [char]'/')
    Assert-NoReparseAncestor -Path $scratchFull
    if ((Test-PathWithin $scratchFull $realCodexRoot) -or (Test-PathWithin $scratchFull $realSkillRoot)) {
        throw 'Scratch root resolved within a real Codex profile root.'
    }
    New-Item -ItemType Directory -Path $scratch -Force | Out-Null
    . (Join-Path $PSScriptRoot 'HostSync.Contract.ps1')
    . (Join-Path $PSScriptRoot 'HostSync.Core.ps1')
    . (Join-Path $PSScriptRoot 'Register-StackAdapters.ps1')
    $companionRoot = Resolve-CompanionRootPath $companionRoot
    $rows = [System.Collections.Generic.List[hashtable]]::new()
    $stackIds = @('Cursor', 'OpenCode', 'Antigravity', 'Vscode', 'Cline', 'Kilocode')
    foreach ($stackId in $stackIds) {
        Add-RenderRows -Rows $rows -StackId $stackId -Manifest (Get-StackManifest -StackId $stackId -HostSyncRoot $PSScriptRoot) `
            -CompanionRoot $companionRoot -ScratchRoot $scratch
    }
    $stackRows = @(
        foreach ($stackId in $stackIds) {
            $stackEntries = [object[]]@($rows | Where-Object stack -eq $stackId)
            [System.Array]::Sort($stackEntries, [Comparison[object]]{ param($a, $b) [StringComparer]::Ordinal.Compare([string]$a.destination, [string]$b.destination) })
            $signature = (($stackEntries | ForEach-Object { "$($_.destination)|$($_.sha256)" }) -join "`n") + "`n"
            [ordered]@{
                stack = $stackId
                destinationCount = $stackEntries.Count
                sha256 = Get-NormalizedSha256 $signature
            }
        }
    )
    $artifact = [ordered]@{
        schemaVersion = 1
        kind = 'existing-six-stack-normalized-render-hash-ledger'
        normalization = 'UTF-8 SHA-256 after CRLF-to-LF and exactly one terminal LF; rendering uses an explicit temporary root, never user-home state'
        stacks = $stackIds
        entries = $stackRows
    }
    $json = $artifact | ConvertTo-Json -Depth 6
    if (-not $SkipRepeatability) {
        # A separate pwsh process creates a separate randomly named scratch root.
        # This catches nondeterministic Hashtable/JSON enumeration before a ledger is
        # accepted as evidence, without importing any user-home state.
        $repeatOutput = & pwsh -NoProfile -File $PSCommandPath -CompanionRoot $companionRoot -SkipRepeatability
        if ($LASTEXITCODE -ne 0) { throw 'Independent ledger repeatability render failed.' }
        $repeatArtifact = (($repeatOutput -join "`n") | ConvertFrom-Json)
        if (-not (Test-LedgerArtifactsEqual $artifact $repeatArtifact)) {
            throw 'Independent ledger renders disagree; normalization is nondeterministic.'
        }
        Write-Output 'ledger repeatability verified: 2 independent renders'
    }
    if ($WriteLedger) {
        [IO.File]::WriteAllText($LedgerPath, $json, [Text.UTF8Encoding]::new($false))
        Write-Output "ledger written: $LedgerPath"
    }
    elseif ($Verify) {
        if (-not (Test-Path -LiteralPath $LedgerPath -PathType Leaf)) { throw "Ledger missing: $LedgerPath" }
        $expected = Get-Content -LiteralPath $LedgerPath -Raw | ConvertFrom-Json
        if (-not (Test-LedgerArtifactsEqual $artifact $expected)) { throw 'Existing-six-stack normalized render hash ledger differs.' }
        Write-Output "ledger verified: $($artifact.entries.Count) entries"
    }
    else {
        Write-Output $json
    }
}
finally {
    Remove-Item -LiteralPath $scratch -Recurse -Force -ErrorAction SilentlyContinue
}
