#Requires -Version 7.0
<#
.SYNOPSIS
  Scratch-only Phase 2 checks for the specialized two-root Codex adapter.

.DESCRIPTION
  Every Apply is directed to independent explicit temporary roots. The suite
  proves that neither root can resolve to the real effective Codex profile or
  skill profile, and never performs a live Apply.
#>
[CmdletBinding()]
param(
    [string] $CompanionRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$companionRoot = [IO.Path]::GetFullPath((Resolve-Path -LiteralPath $CompanionRoot).Path)
$hostSyncRoot = $PSScriptRoot
. (Join-Path $hostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $hostSyncRoot 'HostSync.Core.ps1')
$manifestPath = Join-Path $hostSyncRoot 'manifests/codex.manifest.psd1'
$adapterPath = Join-Path $hostSyncRoot 'adapters/Codex.Adapter.ps1'
. $adapterPath

$passed = 0
$failed = 0
function Assert-Pass {
    param(
        [Parameter(Mandatory)][string] $Name,
        [Parameter(Mandatory)][bool] $Condition,
        [string] $Detail = ''
    )
    if ($Condition) {
        $script:passed++
        Write-Output "pass: $Name"
    }
    else {
        $script:failed++
        Write-Output "FAIL: $Name $Detail".TrimEnd()
    }
}

function Get-ByteSha256 {
    param([Parameter(Mandatory)][AllowNull()][byte[]] $Bytes)
    if ($null -eq $Bytes) { return '<absent>' }
    return ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($Bytes))).ToLowerInvariant()
}

function Get-FileByteSha256 {
    param([Parameter(Mandatory)][string] $Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '<absent>' }
    return Get-ByteSha256 -Bytes ([IO.File]::ReadAllBytes($Path))
}

function Test-PathWithin {
    param(
        [Parameter(Mandatory)][string] $Child,
        [Parameter(Mandatory)][string] $Parent
    )
    $childFull = [IO.Path]::GetFullPath($Child).TrimEnd([char]'\', [char]'/') + [IO.Path]::DirectorySeparatorChar
    $parentFull = [IO.Path]::GetFullPath($Parent).TrimEnd([char]'\', [char]'/') + [IO.Path]::DirectorySeparatorChar
    return $childFull.StartsWith($parentFull, [StringComparison]::OrdinalIgnoreCase)
}

function New-CodexFixtureRoots {
    $scratch = Join-Path ([IO.Path]::GetTempPath()) ('codex-adapter-check-' + [Guid]::NewGuid().ToString('N'))
    $scratchFull = [IO.Path]::GetFullPath($scratch)
    $codex = Join-Path $scratchFull 'codex-home'
    $skills = Join-Path $scratchFull 'skills'
    New-Item -ItemType Directory -Path $codex -Force | Out-Null
    New-Item -ItemType Directory -Path $skills -Force | Out-Null
    return @{
        Scratch = $scratchFull
        Codex = [IO.Path]::GetFullPath($codex)
        Skills = [IO.Path]::GetFullPath($skills)
    }
}

function Remove-CodexFixtureRoots {
    param([Parameter(Mandatory)][hashtable] $Roots)
    $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
    $scratch = [IO.Path]::GetFullPath([string]$Roots.Scratch)
    if ((Test-PathWithin -Child $scratch -Parent $tempRoot) -and (Test-Path -LiteralPath $scratch)) {
        Remove-Item -LiteralPath $scratch -Recurse -Force
    }
}

function Invoke-CodexAdapterSafe {
    param(
        [Parameter(Mandatory)][hashtable] $Manifest,
        [Parameter(Mandatory)][hashtable] $Roots,
        [HostSyncMode] $Mode = [HostSyncMode]::DryRun,
        [int] $FailAfterWrites = -1
    )
    return Invoke-StackHarnessSync -Mode $Mode -CompanionRoot $companionRoot -Manifest $Manifest `
        -CodexRoot $Roots.Codex -SkillRoot $Roots.Skills -FailAfterWrites $FailAfterWrites
}

function Get-InstalledDestinationMap {
    param(
        [Parameter(Mandatory)][hashtable] $Roots,
        [Parameter(Mandatory)][hashtable] $Manifest
    )
    $map = @{}
    foreach ($entry in $Manifest.DestinationEntries) {
        $logical = [string]$entry.LogicalRoot
        $root = if ($logical -eq 'codex-home') { $Roots.Codex } else { $Roots.Skills }
        $path = Join-Path $root (([string]$entry.Dest).Replace('/', [IO.Path]::DirectorySeparatorChar))
        $map["${logical}/$([string]$entry.Dest)"] = $path
    }
    return $map
}

function Get-TreeHashes {
    param([Parameter(Mandatory)][string] $Root)
    $result = @{}
    if (-not (Test-Path -LiteralPath $Root)) { return $result }
    foreach ($file in @(Get-ChildItem -LiteralPath $Root -Recurse -File -Force)) {
        $result[$file.FullName.Substring($Root.Length + 1)] = Get-FileByteSha256 -Path $file.FullName
    }
    return $result
}

# ---------- 1. Explicit-root and static seam guards ----------
$manifest = Import-PowerShellDataFile -LiteralPath $manifestPath
$realCodexDefault = [IO.Path]::GetFullPath((Join-Path $env:USERPROFILE '.codex'))
$realSkillDefault = [IO.Path]::GetFullPath((Join-Path $env:USERPROFILE '.agents/skills'))
$realCodexEffective = if ([string]::IsNullOrWhiteSpace($env:CODEX_HOME)) { $realCodexDefault } else { [IO.Path]::GetFullPath($env:CODEX_HOME) }
$roots = New-CodexFixtureRoots
Assert-Pass 'scratch codex root is explicit and independent of default real codex root' (
    -not [string]::IsNullOrWhiteSpace($roots.Codex) -and
    -not ([IO.Path]::GetFullPath($roots.Codex) -eq $realCodexDefault) -and
    -not (Test-PathWithin -Child $roots.Codex -Parent $realCodexDefault) -and
    -not (Test-PathWithin -Child $realCodexDefault -Parent $roots.Codex)
)
Assert-Pass 'scratch codex root is independent of effective CODEX_HOME' (
    -not ([IO.Path]::GetFullPath($roots.Codex) -eq $realCodexEffective) -and
    -not (Test-PathWithin -Child $roots.Codex -Parent $realCodexEffective) -and
    -not (Test-PathWithin -Child $realCodexEffective -Parent $roots.Codex)
)
Assert-Pass 'scratch skill root is explicit and independent of real skill root' (
    -not [string]::IsNullOrWhiteSpace($roots.Skills) -and
    -not ([IO.Path]::GetFullPath($roots.Skills) -eq $realSkillDefault) -and
    -not (Test-PathWithin -Child $roots.Skills -Parent $realSkillDefault) -and
    -not (Test-PathWithin -Child $realSkillDefault -Parent $roots.Skills)
)
Assert-Pass 'both fixture roots are beneath the same disposable scratch root' (
    (Test-PathWithin -Child $roots.Codex -Parent $roots.Scratch) -and
    (Test-PathWithin -Child $roots.Skills -Parent $roots.Scratch)
)
$adapterText = [IO.File]::ReadAllText($adapterPath)
Assert-Pass 'adapter has no environment/profile root inference' (
    -not $adapterText.Contains('$env:CODEX_HOME') -and
    -not $adapterText.Contains('$env:USERPROFILE') -and
    -not $adapterText.Contains("'.codex'") -and
    -not $adapterText.Contains("'.agents'")
)
Assert-Pass 'adapter accepts only explicit mandatory roots' (
    $adapterText.Contains("[Parameter(Mandatory)]`n        [string] `$CodexRoot") -and
    $adapterText.Contains("[Parameter(Mandatory)]`n        [string] `$SkillRoot")
)

$overlayBefore = Get-TreeHashes -Root (Join-Path $companionRoot 'overlays/codex')
$dry = Invoke-CodexAdapterSafe -Manifest $manifest -Roots $roots -Mode ([HostSyncMode]::DryRun)
Assert-Pass 'dry-run succeeds in explicit scratch roots' ($dry.Success) (($dry.Errors) -join '; ')
Assert-Pass 'dry-run plans 31 writable destinations' (@($dry.PlannedFiles).Count -eq 31) ("actual=$(@($dry.PlannedFiles).Count)")
Assert-Pass 'dry-run reports 32 root-qualified identities including guard' (
    @($dry.Destinations).Count -eq 32 -and
    $dry.Destinations.Contains('codex-home/AGENTS.override.md') -and
    $dry.Destinations.Contains('codex-home/AGENTS.md') -and
    $dry.Destinations.Contains('skill-root/pre-commit-ci-gate/SKILL.md')
)
Assert-Pass 'dry-run binds current-state hashes for every destination' (
    $dry.CurrentState.Keys.Count -eq 32 -and
    $dry.CurrentState['codex-home/AGENTS.md'].Hash -eq '<absent>' -and
    $dry.CurrentState['codex-home/AGENTS.override.md'].Hash -eq '<absent>'
)
Assert-Pass 'dry-run creates no destination bytes' (
    @(Get-ChildItem -LiteralPath $roots.Codex -Recurse -File -Force).Count -eq 0 -and
    @(Get-ChildItem -LiteralPath $roots.Skills -Recurse -File -Force).Count -eq 0
)
Assert-Pass 'openai.yaml remains overlay-only and is not an install destination' (
    @($dry.PlannedFiles | Where-Object { $_ -match 'openai\.yaml' }).Count -eq 0 -and
    @(Get-ChildItem -LiteralPath $roots.Codex -Recurse -Filter 'openai.yaml' -Force).Count -eq 0 -and
    @(Get-ChildItem -LiteralPath $roots.Skills -Recurse -Filter 'openai.yaml' -Force).Count -eq 0
)

# ---------- 2. Apply, exact planned rendering, guard, and ownership ----------
$apply = Invoke-CodexAdapterSafe -Manifest $manifest -Roots $roots -Mode ([HostSyncMode]::Apply)
Assert-Pass 'scratch Apply succeeds' ($apply.Success) (($apply.Errors) -join '; ')
Assert-Pass 'Apply records 31 root-qualified applied destinations' (@($apply.AppliedFiles).Count -eq 31) ("actual=$(@($apply.AppliedFiles).Count)")
Assert-Pass 'guard-only override remains absent' (-not (Test-Path -LiteralPath (Join-Path $roots.Codex 'AGENTS.override.md')))

$installed = Get-InstalledDestinationMap -Roots $roots -Manifest $manifest
$hashMisses = [System.Collections.Generic.List[string]]::new()
$markerMisses = [System.Collections.Generic.List[string]]::new()
foreach ($row in @($dry.PlannedFiles)) {
    $identity = ($row -split ' <= ')[0]
    if ($identity -eq 'codex-home/AGENTS.override.md') { continue }
    $path = $installed[$identity]
    $actualHash = Get-FileByteSha256 -Path $path
    $plannedBytes = [Text.UTF8Encoding]::new($false).GetBytes([string]$dry.PlannedContent[$identity])
    if ($actualHash -ne (Get-ByteSha256 -Bytes $plannedBytes)) { [void]$hashMisses.Add($identity) }
    $actualContent = [IO.File]::ReadAllText($path)
    if ($identity -eq 'codex-home/AGENTS.md') {
        if ($actualContent -notmatch 'cursorEscape-managed-block:v1' -or
            ([regex]::Matches($actualContent, 'begin managed block')).Count -ne 1 -or
            ([regex]::Matches($actualContent, 'end managed block')).Count -ne 1) {
            [void]$markerMisses.Add($identity)
        }
    }
    elseif ($actualContent -notmatch 'cursorEscape-managed:v1') {
        [void]$markerMisses.Add($identity)
    }
}
Assert-Pass 'all applied bytes equal planned dry-run bytes' ($hashMisses.Count -eq 0) (($hashMisses) -join ', ')
Assert-Pass 'all installed leaves carry stable ownership markers' ($markerMisses.Count -eq 0) (($markerMisses) -join ', ')
Assert-Pass 'Apply creates no temporary artifacts' (
    @(Get-ChildItem -LiteralPath $roots.Codex -Recurse -Force -Filter '*.tmp').Count -eq 0 -and
    @(Get-ChildItem -LiteralPath $roots.Skills -Recurse -Force -Filter '*.tmp').Count -eq 0
)
$plannedAfterFirst = Get-TreeHashes -Root (Join-Path $roots.Scratch 'codex-home')
$plannedAfterFirstSkills = Get-TreeHashes -Root $roots.Skills

$repeat = Invoke-CodexAdapterSafe -Manifest $manifest -Roots $roots -Mode ([HostSyncMode]::Apply)
Assert-Pass 'repeated scratch Apply succeeds' ($repeat.Success) (($repeat.Errors) -join '; ')
# Explicit per-file comparison avoids hashtable enumeration-order dependence.
$idempotenceMisses = @()
foreach ($kv in $plannedAfterFirst.GetEnumerator()) {
    if ((Get-FileByteSha256 -Path (Join-Path (Join-Path $roots.Scratch 'codex-home') $kv.Key)) -ne $kv.Value) { $idempotenceMisses += $kv.Key }
}
foreach ($kv in $plannedAfterFirstSkills.GetEnumerator()) {
    if ((Get-FileByteSha256 -Path (Join-Path $roots.Skills $kv.Key)) -ne $kv.Value) { $idempotenceMisses += $kv.Key }
}
Assert-Pass 'repeated Apply preserves every installed byte' ($idempotenceMisses.Count -eq 0) (($idempotenceMisses) -join ', ')

# ---------- 3. Unplanned siblings and overlay source immutability ----------
$siblingCodex = Join-Path $roots.Codex 'foreign-sibling.txt'
$siblingAgents = Join-Path $roots.Codex 'agents/foreign-sibling.toml'
$siblingSkills = Join-Path $roots.Skills 'foreign-skill/SKILL.md'
Set-Content -LiteralPath $siblingCodex -Value 'preserve codex sibling' -NoNewline
Set-Content -LiteralPath $siblingAgents -Value 'preserve nested sibling' -NoNewline
New-Item -ItemType Directory -Path (Split-Path -Parent $siblingSkills) -Force | Out-Null
Set-Content -LiteralPath $siblingSkills -Value 'preserve skill sibling' -NoNewline
$siblingHashes = @{
    Codex = Get-FileByteSha256 -Path $siblingCodex
    Agents = Get-FileByteSha256 -Path $siblingAgents
    Skills = Get-FileByteSha256 -Path $siblingSkills
}
$siblingApply = Invoke-CodexAdapterSafe -Manifest $manifest -Roots $roots -Mode ([HostSyncMode]::Apply)
Assert-Pass 'Apply with unplanned siblings succeeds' ($siblingApply.Success) (($siblingApply.Errors) -join '; ')
Assert-Pass 'unplanned codex, nested-agent, and skill siblings survive' (
    (Get-FileByteSha256 -Path $siblingCodex) -eq $siblingHashes.Codex -and
    (Get-FileByteSha256 -Path $siblingAgents) -eq $siblingHashes.Agents -and
    (Get-FileByteSha256 -Path $siblingSkills) -eq $siblingHashes.Skills
)
$overlayAfter = Get-TreeHashes -Root (Join-Path $companionRoot 'overlays/codex')
Assert-Pass 'overlay source bytes remain immutable through Apply' (
    @($overlayBefore.Keys).Count -eq @($overlayAfter.Keys).Count -and
    -not @($overlayBefore.Keys | Where-Object { -not $overlayAfter.ContainsKey($_) -or $overlayAfter[$_] -ne $overlayBefore[$_] })
)

# ---------- 4. Drift is rebound to actual current state ----------
$driftRoots = New-CodexFixtureRoots
try {
    $driftFirst = Invoke-CodexAdapterSafe -Manifest $manifest -Roots $driftRoots -Mode ([HostSyncMode]::Apply)
    Assert-Pass 'drift fixture initial Apply succeeds' ($driftFirst.Success) (($driftFirst.Errors) -join '; ')
    $driftPath = Join-Path $driftRoots.Codex 'agents/planner.toml'
    $driftOriginal = [IO.File]::ReadAllText($driftPath)
    [IO.File]::WriteAllText($driftPath, $driftOriginal + "`r`n# drifted owned current state`r`n")
    $driftedHash = Get-FileByteSha256 -Path $driftPath
    $driftSecond = Invoke-CodexAdapterSafe -Manifest $manifest -Roots $driftRoots -Mode ([HostSyncMode]::Apply)
    Assert-Pass 'owned drift is accepted by current-state preflight' ($driftSecond.Success) (($driftSecond.Errors) -join '; ')
    $plannedPlanner = [Text.UTF8Encoding]::new($false).GetBytes([string]$driftFirst.PlannedContent['codex-home/agents/planner.toml'])
    $plannedPlannerHash = Get-ByteSha256 -Bytes $plannedPlanner
    Assert-Pass 'drift report records current and planned hash separately' (
        $driftSecond.CurrentState['codex-home/agents/planner.toml'].Hash -eq $driftedHash -and
        $driftedHash -ne $plannedPlannerHash
    )
    Assert-Pass 'drift report emits owned-current-state warning' (
        @($driftSecond.Warnings).Count -eq 1 -and
        $driftSecond.Warnings.Contains('owned current-state drift selected for planned update: codex-home/agents/planner.toml')
    )
    Assert-Pass 'owned drift converges exactly to current planned render' (
        (Get-FileByteSha256 -Path $driftPath) -eq $plannedPlannerHash
    )
}
finally { Remove-CodexFixtureRoots -Roots $driftRoots }

# ---------- 5. Collision, malformed marker, override, exclusions, and path escape fail closed ----------
$collisionRoots = New-CodexFixtureRoots
try {
    $collisionPath = Join-Path $collisionRoots.Codex 'agents/planner.toml'
    New-Item -ItemType Directory -Path (Split-Path -Parent $collisionPath) -Force | Out-Null
    Set-Content -LiteralPath $collisionPath -Value 'foreign collision' -NoNewline
    $collision = Invoke-CodexAdapterSafe -Manifest $manifest -Roots $collisionRoots -Mode ([HostSyncMode]::Apply)
    Assert-Pass 'foreign destination collision fails before writes' (
        -not $collision.Success -and (($collision.Errors) -join ' ').Contains('codex-home/agents/planner.toml')
    ) (($collision.Errors) -join '; ')
    Assert-Pass 'collision fixture is unchanged and causes zero writes' (
        @(Get-ChildItem -LiteralPath $collisionRoots.Codex -Recurse -File -Force).Count -eq 1 -and
        ([IO.File]::ReadAllText($collisionPath) -eq 'foreign collision') -and
        @(Get-ChildItem -LiteralPath $collisionRoots.Skills -Recurse -File -Force).Count -eq 0
    )
}
finally { Remove-CodexFixtureRoots -Roots $collisionRoots }

$malformedRoots = New-CodexFixtureRoots
try {
    $agentsPath = Join-Path $malformedRoots.Codex 'AGENTS.md'
    Set-Content -LiteralPath $agentsPath -Value "before`r`n<!-- cursorEscape-managed-block:v1 id=`"codex-cursor-escape-loop`" source=`"x`"; begin managed block -->`r`nbody" -NoNewline
    $malformedBefore = Get-FileByteSha256 -Path $agentsPath
    $malformed = Invoke-CodexAdapterSafe -Manifest $manifest -Roots $malformedRoots -Mode ([HostSyncMode]::Apply)
    Assert-Pass 'malformed managed marker fails closed' (-not $malformed.Success) (($malformed.Errors) -join '; ')
    Assert-Pass 'malformed marker fixture is unchanged with zero other writes' (
        (Get-FileByteSha256 -Path $agentsPath) -eq $malformedBefore -and
        @(Get-ChildItem -LiteralPath $malformedRoots.Skills -Recurse -File -Force).Count -eq 0 -and
        @(Get-ChildItem -LiteralPath $malformedRoots.Codex -Recurse -File -Force).Count -eq 1
    )
}
finally { Remove-CodexFixtureRoots -Roots $malformedRoots }

$overrideRoots = New-CodexFixtureRoots
try {
    $overridePath = Join-Path $overrideRoots.Codex 'AGENTS.override.md'
    Set-Content -LiteralPath $overridePath -Value 'owner override wins' -NoNewline
    $overrideBefore = Get-FileByteSha256 -Path $overridePath
    $overrideRun = Invoke-CodexAdapterSafe -Manifest $manifest -Roots $overrideRoots -Mode ([HostSyncMode]::Apply)
    Assert-Pass 'non-empty AGENTS.override.md blocks Apply' (-not $overrideRun.Success) (($overrideRun.Errors) -join '; ')
    Assert-Pass 'override guard causes zero writes' (
        (Get-FileByteSha256 -Path $overridePath) -eq $overrideBefore -and
        @(Get-ChildItem -LiteralPath $overrideRoots.Codex -Recurse -File -Force).Count -eq 1 -and
        @(Get-ChildItem -LiteralPath $overrideRoots.Skills -Recurse -File -Force).Count -eq 0
    )
}
finally { Remove-CodexFixtureRoots -Roots $overrideRoots }

$exclusionRoots = New-CodexFixtureRoots
try {
    $exclusionManifest = Import-PowerShellDataFile -LiteralPath $manifestPath
    $exclusionManifest.DestinationEntries += @{ LogicalRoot = 'codex-home'; Source = 'agents/planner.toml'; Dest = 'config.toml'; Role = 'forbidden-by-fixture' }
    $exclusionRun = Invoke-CodexAdapterSafe -Manifest $exclusionManifest -Roots $exclusionRoots -Mode ([HostSyncMode]::DryRun)
    Assert-Pass 'per-root hard exclusion rejects config.toml' (-not $exclusionRun.Success -and (($exclusionRun.Errors) -join ' ').Contains('codex-home/config.toml')) (($exclusionRun.Errors) -join '; ')
    Assert-Pass 'exclusion dry-run writes nothing' (@(Get-ChildItem -LiteralPath $exclusionRoots.Codex -Recurse -File -Force).Count -eq 0)
}
finally { Remove-CodexFixtureRoots -Roots $exclusionRoots }

$escapeRoots = New-CodexFixtureRoots
try {
    $escapeManifest = Import-PowerShellDataFile -LiteralPath $manifestPath
    $escapeManifest.DestinationEntries[0].Dest = '../escaped-from-codex-root.md'
    $escapeRun = Invoke-CodexAdapterSafe -Manifest $escapeManifest -Roots $escapeRoots -Mode ([HostSyncMode]::DryRun)
    Assert-Pass 'path escape fails closed' (-not $escapeRun.Success -and (($escapeRun.Errors) -join ' ').Contains('path escapes')) (($escapeRun.Errors) -join '; ')
    Assert-Pass 'path escape creates no file outside root' (
        -not (Test-Path -LiteralPath (Join-Path $escapeRoots.Scratch 'escaped-from-codex-root.md')) -and
        @(Get-ChildItem -LiteralPath $escapeRoots.Codex -Recurse -File -Force).Count -eq 0
    )
}
finally { Remove-CodexFixtureRoots -Roots $escapeRoots }

# ---------- 6. Late failure rollback: created and pre-Apply bytes ----------
$lateCreatedRoots = New-CodexFixtureRoots
try {
    $lateCreated = Invoke-CodexAdapterSafe -Manifest $manifest -Roots $lateCreatedRoots -Mode ([HostSyncMode]::Apply) -FailAfterWrites 1
    Assert-Pass 'late failure on newly created first leaf fails' (-not $lateCreated.Success -and (($lateCreated.Errors) -join ' ').Contains('injected Codex late-write failure')) (($lateCreated.Errors) -join '; ')
    Assert-Pass 'rollback removes the file created by failed run' (
        -not (Test-Path -LiteralPath (Join-Path $lateCreatedRoots.Codex 'AGENTS.md')) -and
        @(Get-ChildItem -LiteralPath $lateCreatedRoots.Codex -Recurse -File -Force).Count -eq 0 -and
        @(Get-ChildItem -LiteralPath $lateCreatedRoots.Skills -Recurse -File -Force).Count -eq 0
    )
}
finally { Remove-CodexFixtureRoots -Roots $lateCreatedRoots }

$lateExistingRoots = New-CodexFixtureRoots
try {
    $lateSetup = Invoke-CodexAdapterSafe -Manifest $manifest -Roots $lateExistingRoots -Mode ([HostSyncMode]::Apply)
    Assert-Pass 'late-existing rollback fixture setup succeeds' ($lateSetup.Success) (($lateSetup.Errors) -join '; ')
    $preApplyHashes = @{}
    $lateInstalled = Get-InstalledDestinationMap -Roots $lateExistingRoots -Manifest $manifest
    foreach ($kv in $lateInstalled.GetEnumerator()) {
        $preApplyHashes[$kv.Key] = Get-FileByteSha256 -Path $kv.Value
    }
    $lateExisting = Invoke-CodexAdapterSafe -Manifest $manifest -Roots $lateExistingRoots -Mode ([HostSyncMode]::Apply) -FailAfterWrites 2
    Assert-Pass 'late failure after existing writes fails' (-not $lateExisting.Success -and (($lateExisting.Errors) -join ' ').Contains('injected Codex late-write failure')) (($lateExisting.Errors) -join '; ')
    $rollbackMisses = @()
    foreach ($kv in $preApplyHashes.GetEnumerator()) {
        if ((Get-FileByteSha256 -Path $lateInstalled[$kv.Key]) -ne $kv.Value) { $rollbackMisses += $kv.Key }
    }
    Assert-Pass 'in-memory rollback restores pre-Apply bytes for every existing leaf' ($rollbackMisses.Count -eq 0) (($rollbackMisses) -join ', ')
}
finally { Remove-CodexFixtureRoots -Roots $lateExistingRoots }

# Cleanup the primary fixture last.
Remove-CodexFixtureRoots -Roots $roots

Write-Output ('codex adapter checks: {0} passed, {1} failed' -f $passed, $failed)
exit $(if ($failed -gt 0) { 1 } else { 0 })
