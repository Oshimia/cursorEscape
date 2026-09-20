#Requires -Version 7.0
<#
.SYNOPSIS
  Non-mutating Phase 2 Full CI for the OpenCode host harness.
.DESCRIPTION
  Validates planned bytes, C1 exact-render mirrors, OpenCode model/provider
  preservation, deterministic JSON, managed inventory, and read-only behavior.
  This gate never passes -Apply and never writes live host state.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$hostSyncRoot = $PSScriptRoot
$companionRoot = (Resolve-Path (Join-Path $hostSyncRoot '..\..')).Path
. (Join-Path $hostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $hostSyncRoot 'HostSync.Core.ps1')
. (Join-Path $hostSyncRoot 'Register-StackAdapters.ps1')

$fail = $false
function Assert-Pass {
    param([string]$Name, [bool]$Ok, [string]$Detail = '')
    $status = if ($Ok) { 'pass' } else { 'fail' }
    Write-Output ("{0}: {1} {2}".TrimEnd() -f $Name, $status, $Detail)
    if (-not $Ok) { $script:fail = $true }
}

function Invoke-RunScriptCheck {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Path,
        [string[]]$ArgumentList = @()
    )
    & pwsh -NoProfile -File $Path @ArgumentList
    Assert-Pass $Name ($LASTEXITCODE -eq 0) ("exit=$LASTEXITCODE")
}

function Get-OpenCodeManagedSnapshot {
    param(
        [Parameter(Mandatory)][string]$LiveRoot,
        [Parameter(Mandatory)][hashtable]$Manifest
    )

    $identities = [System.Collections.Generic.List[string]]::new()
    foreach ($entry in @($Manifest.CopyEntries)) {
        $identities.Add($(if ($entry.ContainsKey('Dest') -and $entry.Dest) { [string]$entry.Dest } else { [string]$entry.Source }))
    }
    $identities.Add([string]$Manifest.AgentsDualWrite.InstructionsRel)
    $identities.Add([string]$Manifest.AgentsDualWrite.AgentsRel)
    $identities.Add([string]$Manifest.JsonMerge.DestRel)

    $snapshot = @{}
    foreach ($identity in $identities) {
        $path = Join-Path $LiveRoot ($identity -replace '/', [IO.Path]::DirectorySeparatorChar)
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            $snapshot[$path] = '<missing>'
            continue
        }
        $bytes = [IO.File]::ReadAllBytes($path)
        $snapshot[$path] = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($bytes))).ToLowerInvariant()
    }
    return $snapshot
}

function Test-HashSnapshotEqual {
    param([hashtable]$Before, [hashtable]$After)
    if ($Before.Count -ne $After.Count) { return $false }
    foreach ($path in $Before.Keys) {
        if (-not $After.ContainsKey($path)) { return $false }
        if ($Before[$path] -ne $After[$path]) { return $false }
    }
    return $true
}

function Test-ConfigValueEqual {
    param($Expected, $Actual)

    if ($null -eq $Expected -or $null -eq $Actual) { return ($null -eq $Expected -and $null -eq $Actual) }
    if ($Expected -is [System.Collections.IDictionary] -and $Actual -is [System.Collections.IDictionary]) {
        if ($Expected.Count -ne $Actual.Count) { return $false }
        foreach ($key in $Expected.Keys) {
            if (-not (Test-ConfigKeyExists -Node $Actual -Key ([string]$key))) { return $false }
            if (-not (Test-ConfigValueEqual -Expected $Expected[$key] -Actual $Actual[$key])) { return $false }
        }
        return $true
    }
    if ($Expected -is [System.Collections.IList] -and $Actual -is [System.Collections.IList] -and $Expected -isnot [string] -and $Actual -isnot [string]) {
        if ($Expected.Count -ne $Actual.Count) { return $false }
        for ($index = 0; $index -lt $Expected.Count; $index++) {
            if (-not (Test-ConfigValueEqual -Expected $Expected[$index] -Actual $Actual[$index])) { return $false }
        }
        return $true
    }
    return ($Expected -eq $Actual)
}

function Test-ConfigKeyExists {
    param([Parameter(Mandatory)]$Node, [Parameter(Mandatory)][string]$Key)
    return $Node.Contains($Key)
}

$companionNorm = Resolve-CompanionRootPath -Path $companionRoot
$manifest = Get-StackManifest -StackId OpenCode -HostSyncRoot $hostSyncRoot
$liveOpenCode = Join-Path $env:USERPROFILE ([string]$manifest.LiveRelativeRoot)
$liveJsonPath = Join-Path $liveOpenCode ([string]$manifest.JsonMerge.DestRel)

$beforeSnapshot = Get-OpenCodeManagedSnapshot -LiveRoot $liveOpenCode -Manifest $manifest

$report = Invoke-RegisteredStackAdapterSync -Mode ([HostSyncMode]::DryRun) `
    -StackId OpenCode -CompanionRoot $companionNorm -Manifest $manifest `
    -HostSyncRoot $hostSyncRoot
Assert-Pass 'OpenCode dry-run succeeds' $report.Success ($report.Errors -join '; ')

if (-not $report.Success) {
    exit 1
}

$afterSnapshot = Get-OpenCodeManagedSnapshot -LiveRoot $liveOpenCode -Manifest $manifest
Assert-Pass 'dry-run made zero managed-byte changes' (
    Test-HashSnapshotEqual -Before $beforeSnapshot -After $afterSnapshot)

# C1 committed mirrors are the regression surface for exact Apply bytes.
$utf8NoBom = [Text.UTF8Encoding]::new($false)
$mirrorPaths = @{
    'instructions/cursor-escape-loop.md' = Join-Path $companionRoot 'overlays/opencode/instructions/cursor-escape-loop.md'
    'AGENTS.md' = Join-Path $companionRoot 'overlays/opencode/AGENTS.md'
}
foreach ($identity in $mirrorPaths.Keys) {
    $plannedExists = $report.PlannedContent.ContainsKey($identity)
    $committedExists = Test-Path -LiteralPath $mirrorPaths[$identity] -PathType Leaf
    Assert-Pass "C1 planned and committed mirror exists: $identity" ($plannedExists -and $committedExists)
    if ($plannedExists -and $committedExists) {
        $mirrorBytes = [IO.File]::ReadAllBytes($mirrorPaths[$identity])
        $hasUtf8Bom = $mirrorBytes.Length -ge 3 -and
            $mirrorBytes[0] -eq 239 -and $mirrorBytes[1] -eq 187 -and $mirrorBytes[2] -eq 191
        Assert-Pass "C1 committed mirror has no UTF-8 BOM: $identity" (-not $hasUtf8Bom)
        $mirrorSource = $utf8NoBom.GetString($mirrorBytes)
        $mirrorRendered = Merge-CompanionTokens -Content $mirrorSource -CompanionRoot $companionNorm
        $expectedBytes = $utf8NoBom.GetBytes([string]$report.PlannedContent[$identity])
        $actualBytes = $utf8NoBom.GetBytes($mirrorRendered)
        Assert-Pass "C1 committed token render equals exact planned bytes: $identity" (
            [BitConverter]::ToString($expectedBytes) -eq [BitConverter]::ToString($actualBytes))
        Assert-Pass "C1 committed mirror is portable token source: $identity" (
            Test-PortableCompanionTokenSource -Content $mirrorSource -CompanionRoot $companionNorm)
    }
}

$instructions = [string]$report.PlannedContent['instructions/cursor-escape-loop.md']
$agents = [string]$report.PlannedContent['AGENTS.md']
$instructionsHash = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($utf8NoBom.GetBytes($instructions)))).ToLowerInvariant()
$agentsHash = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($utf8NoBom.GetBytes($agents)))).ToLowerInvariant()
Assert-Pass 'C1 planned identity preserved' ($instructionsHash -eq $agentsHash) "sha256=$instructionsHash"

$unmergedTokenFiles = @(
    @($report.PlannedContent.GetEnumerator()) |
        Where-Object { Test-ContentHasUnmergedTokens -Content ([string]$_.Value) } |
        ForEach-Object { $_.Key }
)
Assert-Pass 'planned renders have no replacement tokens' ($unmergedTokenFiles.Count -eq 0) ($unmergedTokenFiles -join ', ')

# Validate exact planned JSON bytes and preservation of current live model/provider.
try {
    $liveBeforeJson = @{}
    if (Test-Path -LiteralPath $liveJsonPath -PathType Leaf) {
        $liveBeforeJson = ConvertTo-NestedHashtable -Node (([IO.File]::ReadAllText($liveJsonPath)) | ConvertFrom-Json)
    }
    $specimenPath = Join-Path (Join-Path $companionNorm ([string]$manifest.OverlayRelativeRoot)) `
        ([string]$manifest.JsonMerge.SpecimenRel)
    $specimen = Resolve-OpenCodeSpecimenJson -SpecimenPath $specimenPath `
        -CompanionRoot $companionNorm -OpenCodeHome (Get-OpenCodeHomePath -LiveRoot $liveOpenCode)
    $mergedJson = Merge-OpenCodeHarnessJson -Specimen $specimen -LiveJsonPath $liveJsonPath `
        -PreserveTopLevelKeys @($manifest.JsonMerge.PreserveTopLevelKeys)
    $plannedJsonText = $mergedJson | ConvertTo-Json -Depth 100

    Assert-Pass 'planned JSON has no replacement tokens' (-not (Test-ContentHasUnmergedTokens -Content $plannedJsonText))
    if (Test-ConfigKeyExists -Node $liveBeforeJson -Key 'model') {
        Assert-Pass 'planned JSON preserves live model' (
            Test-ConfigValueEqual -Expected $liveBeforeJson['model'] -Actual $mergedJson['model'])
    }
    if (Test-ConfigKeyExists -Node $liveBeforeJson -Key 'provider') {
        Assert-Pass 'planned JSON preserves live provider' (
            Test-ConfigValueEqual -Expected $liveBeforeJson['provider'] -Actual $mergedJson['provider'])
    }

    $config = ConvertTo-NestedHashtable -Node ($plannedJsonText | ConvertFrom-Json)
    $instructionsValue = Get-OpenCodeInstructionsPath -Config $config
    $expectedHome = Get-OpenCodeHomePath -LiveRoot $liveOpenCode
    Assert-Pass 'planned instructions path is absolute' (
        $null -ne $instructionsValue -and
        ($instructionsValue -match '^[A-Za-z]:/' -or $instructionsValue -match '^/') -and
        $instructionsValue.StartsWith($expectedHome, [StringComparison]::OrdinalIgnoreCase))
}
catch {
    Assert-Pass 'planned JSON validation succeeds' $false $_.Exception.Message
}

try {
    Assert-NoPerApplyBackupArtifacts
    Assert-Pass 'no per-Apply backup artifacts' $true
}
catch {
    Assert-Pass 'no per-Apply backup artifacts' $false $_.Exception.Message
}

# Inventory applies to the manifest/planned destination surface, not accidental live equality.
$skillDests = @($manifest.CopyEntries | Where-Object { $_.Dest -like 'skills/*' })
$agentDests = @($manifest.CopyEntries | Where-Object { $_.Dest -like 'agents/*' })
Assert-Pass 'planned skill inventory is current eleven' ($skillDests.Count -eq 11) "count=$($skillDests.Count)"
Assert-Pass 'planned agent inventory is eight roles' ($agentDests.Count -eq 8) "count=$($agentDests.Count)"
Assert-Pass 'procedure mirror remains hard-excluded' (
    $manifest.HardExcludes -contains 'docs/workflow' -and $manifest.NeverTouch -contains 'docs/workflow')
Assert-Pass 'review model leaf remains excluded' ($manifest.HardExcludes -contains 'review-subagent-models')

Invoke-RunScriptCheck -Name 'drift fixture suite' -Path (Join-Path $hostSyncRoot 'Invoke-HostSyncDriftFixtureChecks.ps1')
Invoke-RunScriptCheck -Name 'host-sync composition and dry-run checks' -Path (Join-Path $hostSyncRoot 'Invoke-HostSyncChecks.ps1') -ArgumentList @('-Suite','All')

$finalSnapshot = Get-OpenCodeManagedSnapshot -LiveRoot $liveOpenCode -Manifest $manifest
Assert-Pass 'Full CI made zero managed-byte changes' (
    Test-HashSnapshotEqual -Before $beforeSnapshot -After $finalSnapshot)

Write-Output ''
Write-Output 'Phase 2 Full CI: non-mutating content and behavior gate only; live Apply requires separate owner authorization.'
exit $(if ($fail) { 1 } else { 0 })
