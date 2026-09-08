#Requires -Version 7.0
<#
  Codex bring-up Phase 3 Fast CI (temporary roots only).
  Covers: explicit-root Codex dry-run, all-stack dry-run, the BringUp lifecycle
  gate (regression-covered via a test-only state resolver), real-state Codex
  Apply in disposable fixtures, Active-state Codex collision causing zero
  selected-stack writes, and invalid-target registry output.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$companionRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$hostSyncRoot = $PSScriptRoot
$syncScript = Join-Path $companionRoot 'scripts/Sync-HostHarness.ps1'

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

function Test-PathWithin {
    param(
        [Parameter(Mandatory)][string] $Child,
        [Parameter(Mandatory)][string] $Parent
    )
    $childFull = [IO.Path]::GetFullPath($Child).TrimEnd([char]'\', [char]'/') + [IO.Path]::DirectorySeparatorChar
    $parentFull = [IO.Path]::GetFullPath($Parent).TrimEnd([char]'\', [char]'/') + [IO.Path]::DirectorySeparatorChar
    return $childFull.StartsWith($parentFull, [StringComparison]::OrdinalIgnoreCase)
}

function Get-LiveTreeSnapshot {
    param([Parameter(Mandatory)][string] $Root)
    $result = @{}
    if (-not (Test-Path -LiteralPath $Root)) { return $result }
    foreach ($file in @(Get-ChildItem -LiteralPath $Root -Recurse -File -Force -ErrorAction SilentlyContinue)) {
        $hash = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([IO.File]::ReadAllBytes($file.FullName)))).ToLowerInvariant()
        $result[$file.FullName] = "$hash|$($file.Length)|$($file.LastWriteTimeUtc.Ticks)"
    }
    return $result
}

function Test-SnapshotUnchanged {
    param(
        [Parameter(Mandatory)][hashtable] $Before,
        [Parameter(Mandatory)][hashtable] $After
    )
    if ($Before.Count -ne $After.Count) { return $false }
    foreach ($key in $Before.Keys) {
        if (-not $After.ContainsKey($key) -or $After[$key] -ne $Before[$key]) { return $false }
    }
    return $true
}

function Invoke-CodexPhase3Sync {
    param(
        [Parameter(Mandatory)][string] $Target,
        [Parameter(Mandatory)][hashtable] $Roots,
        [switch] $Apply,
        [Parameter(Mandatory)][string] $LiveHome,
        [string] $BaselinePathsFile = ''
    )
    $arguments = @(
        '-NoProfile', '-File', $syncScript, '-Target', $Target,
        '-CodexRoot', $Roots.Codex, '-SkillRoot', $Roots.Skills
    )
    if ($Apply) { $arguments += '-Apply' }
    if (-not [string]::IsNullOrWhiteSpace($BaselinePathsFile)) { $arguments += @('-BaselinePathsFile', $BaselinePathsFile) }
    $previousHome = $env:USERPROFILE
    try {
        $env:USERPROFILE = $LiveHome
        $output = & pwsh @arguments 2>&1 | Out-String
    }
    finally {
        $env:USERPROFILE = $previousHome
    }
    return @{
        ExitCode = $LASTEXITCODE
        Output   = $output
    }
}

function Invoke-CodexPhase3ActiveCollisionProbe {
    param(
        [Parameter(Mandatory)][hashtable] $Roots,
        [Parameter(Mandatory)][string] $LiveHome
    )

    $probePath = Join-Path $Roots.Scratch 'active-collision-probe.ps1'
    @'
param(
    [string] $CompanionRoot,
    [string] $HostSyncRoot,
    [string] $CodexRoot,
    [string] $SkillRoot
)
Set-StrictMode -Version Latest
. (Join-Path $HostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $HostSyncRoot 'HostSync.Core.ps1')
. (Join-Path $HostSyncRoot 'Register-StackAdapters.ps1')
$stackIds = Get-RegisteredStackIds
$plan = Invoke-HostHarnessSyncPlan -Mode ([HostSyncMode]::Apply) -StackIds $stackIds `
    -CompanionRoot $CompanionRoot -HostSyncRoot $HostSyncRoot `
    -CodexRoot $CodexRoot -SkillRoot $SkillRoot `
    -ApplyStateResolver { param([hashtable] $Manifest) 'Active' }
if ($null -eq $plan) { throw 'Active collision probe did not return a plan.' }
$codex = @($plan.PreflightReports | Where-Object StackId -eq 'Codex')
[pscustomobject]@{
    Success = [bool]$plan.Success
    ExitReason = [string]$plan.ExitReason
    PreflightCount = @($plan.PreflightReports).Count
    WriteReportCount = @($plan.Reports).Count
    CodexFailed = (($codex.Count -eq 1) -and -not $codex[0].Success)
    CodexError = [string]($codex[0].Errors -join '; ')
} | ConvertTo-Json -Compress
'@ | Set-Content -LiteralPath $probePath -Encoding UTF8

    $previousHome = $env:USERPROFILE
    try {
        $env:USERPROFILE = $LiveHome
        $output = & pwsh -NoProfile -File $probePath `
            -CompanionRoot $companionRoot -HostSyncRoot $hostSyncRoot `
            -CodexRoot $Roots.Codex -SkillRoot $Roots.Skills 2>&1 | Out-String
    }
    finally {
        $env:USERPROFILE = $previousHome
    }
    $lastJson = @($output -split "`n" | Where-Object { $_.Trim() } | Select-Object -Last 1)[0]
    return ($lastJson | ConvertFrom-Json)
}

function Invoke-CodexPhase3BringUpGateProbe {
    param(
        [Parameter(Mandatory)][hashtable] $Roots,
        [Parameter(Mandatory)][string] $LiveHome
    )

    $probePath = Join-Path $Roots.Scratch 'bringup-gate-probe.ps1'
    @'
param(
    [string] $CompanionRoot,
    [string] $HostSyncRoot,
    [string] $CodexRoot,
    [string] $SkillRoot
)
Set-StrictMode -Version Latest
. (Join-Path $HostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $HostSyncRoot 'HostSync.Core.ps1')
. (Join-Path $HostSyncRoot 'Register-StackAdapters.ps1')
$stackIds = Get-RegisteredStackIds
$plan = Invoke-HostHarnessSyncPlan -Mode ([HostSyncMode]::Apply) -StackIds $stackIds `
    -CompanionRoot $CompanionRoot -HostSyncRoot $HostSyncRoot `
    -CodexRoot $CodexRoot -SkillRoot $SkillRoot `
    -ApplyStateResolver { param([hashtable] $Manifest) if ($Manifest.StackId -eq 'Codex') { 'BringUp' } else { 'Active' } }
if ($null -eq $plan) { throw 'BringUp gate probe did not return a plan.' }
[pscustomobject]@{
    Success = [bool]$plan.Success
    ExitReason = [string]$plan.ExitReason
    PreflightCount = @($plan.PreflightReports).Count
    WriteReportCount = @($plan.Reports).Count
} | ConvertTo-Json -Compress
'@ | Set-Content -LiteralPath $probePath -Encoding UTF8

    $previousHome = $env:USERPROFILE
    try {
        $env:USERPROFILE = $LiveHome
        $output = & pwsh -NoProfile -File $probePath `
            -CompanionRoot $companionRoot -HostSyncRoot $hostSyncRoot `
            -CodexRoot $Roots.Codex -SkillRoot $Roots.Skills 2>&1 | Out-String
    }
    finally {
        $env:USERPROFILE = $previousHome
    }
    $lastJson = @($output -split "`n" | Where-Object { $_.Trim() } | Select-Object -Last 1)[0]
    return ($lastJson | ConvertFrom-Json)
}

function Invoke-CodexPhase3RealApplyProbe {
    param(
        [Parameter(Mandatory)][hashtable] $Roots,
        [Parameter(Mandatory)][string] $LiveHome
    )

    $probePath = Join-Path $Roots.Scratch 'real-apply-probe.ps1'
    @'
param(
    [string] $CompanionRoot,
    [string] $HostSyncRoot,
    [string] $CodexRoot,
    [string] $SkillRoot
)
Set-StrictMode -Version Latest
. (Join-Path $HostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $HostSyncRoot 'HostSync.Core.ps1')
. (Join-Path $HostSyncRoot 'Register-StackAdapters.ps1')
$plan = Invoke-HostHarnessSyncPlan -Mode ([HostSyncMode]::Apply) -StackIds @('Codex') `
    -CompanionRoot $CompanionRoot -HostSyncRoot $HostSyncRoot `
    -CodexRoot $CodexRoot -SkillRoot $SkillRoot
if ($null -eq $plan) { throw 'Real apply probe did not return a plan.' }
[pscustomobject]@{
    Success = [bool]$plan.Success
    ExitReason = [string]$plan.ExitReason
    WriteReportCount = @($plan.Reports).Count
} | ConvertTo-Json -Compress
'@ | Set-Content -LiteralPath $probePath -Encoding UTF8

    $previousHome = $env:USERPROFILE
    try {
        $env:USERPROFILE = $LiveHome
        $output = & pwsh -NoProfile -File $probePath `
            -CompanionRoot $companionRoot -HostSyncRoot $hostSyncRoot `
            -CodexRoot $Roots.Codex -SkillRoot $Roots.Skills 2>&1 | Out-String
    }
    finally {
        $env:USERPROFILE = $previousHome
    }
    $lastJson = @($output -split "`n" | Where-Object { $_.Trim() } | Select-Object -Last 1)[0]
    return ($lastJson | ConvertFrom-Json)
}

function Get-SelectedLiveSnapshots {
    param([Parameter(Mandatory)][string] $HomeRoot)
    $result = @{}
    foreach ($pair in @(
        @{ Id = 'Cursor'; Root = Join-Path $HomeRoot '.cursor' },
        @{ Id = 'OpenCode'; Root = Join-Path $HomeRoot '.config/opencode' },
        @{ Id = 'Antigravity'; Root = Join-Path $HomeRoot '.gemini' },
        @{ Id = 'Vscode'; Root = Join-Path $HomeRoot '.copilot' },
        @{ Id = 'Cline'; Root = Join-Path $HomeRoot '.cline' },
        @{ Id = 'Kilocode'; Root = Join-Path $HomeRoot '.kilocode' }
    )) {
        $result[$pair.Id] = Get-LiveTreeSnapshot -Root $pair.Root
    }
    return $result
}

function Test-SelectedLiveSnapshotsUnchanged {
    param(
        [Parameter(Mandatory)][hashtable] $Before,
        [Parameter(Mandatory)][hashtable] $After
    )
    foreach ($stackId in $Before.Keys) {
        if (-not (Test-SnapshotUnchanged -Before $Before[$stackId] -After $After[$stackId])) {
            return $false
        }
    }
    return $true
}

function Test-FixtureRootsClean {
    param([Parameter(Mandatory)][hashtable] $Roots)
    return @(
        @(Get-ChildItem -LiteralPath $Roots.Codex -Recurse -File -Force -ErrorAction SilentlyContinue).Count -eq 0 -and
        @(Get-ChildItem -LiteralPath $Roots.Skills -Recurse -File -Force -ErrorAction SilentlyContinue).Count -eq 0
    )
}

. (Join-Path $hostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $hostSyncRoot 'HostSync.Core.ps1')
. (Join-Path $hostSyncRoot 'Register-StackAdapters.ps1')

$registeredStackIds = Get-RegisteredStackIds
Assert-Pass 'seven-stack registry order' (($registeredStackIds -join ',') -eq 'Cursor,OpenCode,Antigravity,Vscode,Cline,Kilocode,Codex') ($registeredStackIds -join ',')
$manifests = @{}
foreach ($stackId in $registeredStackIds) {
    $manifests[$stackId] = Get-StackManifest -StackId $stackId -HostSyncRoot $hostSyncRoot
}
Assert-Pass 'ApplyState defaults Active outside Codex' (
    (@($registeredStackIds | Where-Object { $_ -ne 'Codex' } | ForEach-Object { Get-StackApplyState -Manifest $manifests[$_] }) -join ',') -eq 'Active,Active,Active,Active,Active,Active'
)
Assert-Pass 'Codex ApplyState governed by manifest (Active after Phase 4)' ((Get-StackApplyState -Manifest $manifests['Codex']) -eq 'Active')

$scratch = Join-Path ([IO.Path]::GetTempPath()) ('codex-phase3-check-' + [Guid]::NewGuid().ToString('N'))
$scratchFull = [IO.Path]::GetFullPath($scratch).TrimEnd([char]'\', [char]'/')
$tempFull = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd([char]'\', [char]'/')
$realCodexRoot = [IO.Path]::GetFullPath((Join-Path $env:USERPROFILE '.codex')).TrimEnd([char]'\', [char]'/')
$realSkillRoot = [IO.Path]::GetFullPath((Join-Path $env:USERPROFILE '.agents/skills')).TrimEnd([char]'\', [char]'/')
if (-not (Test-PathWithin -Child $scratchFull -Parent $tempFull)) { throw 'Phase 3 scratch root is not beneath TEMP.' }
if ((Test-PathWithin -Child $scratchFull -Parent $realCodexRoot) -or (Test-PathWithin -Child $realCodexRoot -Parent $scratchFull)) { throw 'Phase 3 scratch overlaps real Codex home.' }
if ((Test-PathWithin -Child $scratchFull -Parent $realSkillRoot) -or (Test-PathWithin -Child $realSkillRoot -Parent $scratchFull)) { throw 'Phase 3 scratch overlaps real skill root.' }

$roots = @{
    Scratch = $scratchFull
    Codex   = Join-Path $scratchFull 'codex-home'
    Skills  = Join-Path $scratchFull 'skills'
}
New-Item -ItemType Directory -Path $roots.Codex -Force | Out-Null
New-Item -ItemType Directory -Path $roots.Skills -Force | Out-Null
foreach ($relativeLiveRoot in @('.cursor', '.config/opencode', '.gemini', '.copilot', '.cline', '.kilocode')) {
    New-Item -ItemType Directory -Path (Join-Path $roots.Scratch ('live-home/' + $relativeLiveRoot)) -Force | Out-Null
}
$liveHome = Join-Path $roots.Scratch 'live-home'
$baselinePathsFile = Join-Path $roots.Scratch 'baseline-paths.json'
$baselineFixture = [ordered]@{
    cursor       = Join-Path $roots.Scratch 'baseline/cursor'
    opencode     = Join-Path $roots.Scratch 'baseline/opencode'
    antigravity  = Join-Path $roots.Scratch 'baseline/antigravity'
    vscode       = Join-Path $roots.Scratch 'baseline/vscode'
    cline        = Join-Path $roots.Scratch 'baseline/cline'
    kilocode     = Join-Path $roots.Scratch 'baseline/kilocode'
    companionSha = 'phase3-fixture'
    created      = '2026-09-08T00:00:00.0000000Z'
}
foreach ($value in $baselineFixture.Values) {
    if ($value -notlike "$scratchFull*") { continue }
    New-Item -ItemType Directory -Path $value -Force | Out-Null
}
[IO.File]::WriteAllText($baselinePathsFile, ($baselineFixture | ConvertTo-Json), [Text.UTF8Encoding]::new($false))

try {
    # 1. Explicit mandatory roots: Codex dry-run.
    $codexDry = Invoke-CodexPhase3Sync -Target 'Codex' -Roots $roots -LiveHome $liveHome
    Assert-Pass 'Codex explicit-root dry-run exits 0' ($codexDry.ExitCode -eq 0) $codexDry.Output
    Assert-Pass 'Codex dry-run writes zero fixture bytes' (Test-FixtureRootsClean -Roots $roots)

    # 2. All selected stacks dry-run; only Codex consumes the temporary roots.
    $allDry = Invoke-CodexPhase3Sync -Target 'All' -Roots $roots -LiveHome $liveHome
    Assert-Pass 'All explicit-root dry-run exits 0' ($allDry.ExitCode -eq 0) $allDry.Output
    Assert-Pass 'All dry-run writes zero fixture bytes' (Test-FixtureRootsClean -Roots $roots)
    Assert-Pass 'All dry-run reports global preflight semantics' ($allDry.Output.Contains('--- Preflight: Codex ---'))

    # 3. BringUp lifecycle gate still refuses All-Apply when Codex is BringUp.
    # Post-activation the real registry state is Active, so the gate path is
    # regression-covered via a test-only state resolver (operator entry remains
    # governed by Get-StackApplyState; setting the manifest back to BringUp
    # re-arms the gate for real).
    $beforeBringUp = Get-SelectedLiveSnapshots -HomeRoot $liveHome
    $bringUpApply = Invoke-CodexPhase3BringUpGateProbe -Roots $roots -LiveHome $liveHome
    $afterBringUp = Get-SelectedLiveSnapshots -HomeRoot $liveHome
    Assert-Pass 'BringUp-forced All-Apply refuses with BringUpGate' (
        (-not $bringUpApply.Success) -and $bringUpApply.ExitReason -eq 'BringUpGate'
    ) $bringUpApply.ExitReason
    Assert-Pass 'BringUp All-Apply changes no selected live stack' (Test-SelectedLiveSnapshotsUnchanged -Before $beforeBringUp -After $afterBringUp)
    Assert-Pass 'BringUp All-Apply writes zero fixture bytes' (Test-FixtureRootsClean -Roots $roots)

    # 3b. Real-state (Active) Codex-only Apply succeeds in disposable fixtures.
    # In-process plan skips the operator-level baseline gate by design; fixture
    # live roots are redirected and disposable.
    $realApply = Invoke-CodexPhase3RealApplyProbe -Roots $roots -LiveHome $liveHome
    Assert-Pass 'real-state Codex-only Apply succeeds in fixtures' (
        $realApply.Success -and $realApply.ExitReason -eq 'Complete' -and $realApply.WriteReportCount -eq 1
    ) $realApply.ExitReason

    # 4. Test-only Active-state seam proves the orchestration-wide collision gate.
    $collisionPath = Join-Path $roots.Codex 'agents/planner.toml'
    New-Item -ItemType Directory -Path (Split-Path -Parent $collisionPath) -Force | Out-Null
    [IO.File]::WriteAllText($collisionPath, "foreign destination`n", [Text.UTF8Encoding]::new($false))
    $beforeActiveCollision = Get-SelectedLiveSnapshots -HomeRoot $liveHome
    $activePlan = Invoke-CodexPhase3ActiveCollisionProbe -Roots $roots -LiveHome $liveHome
    $afterActiveCollision = Get-SelectedLiveSnapshots -HomeRoot $liveHome
    Assert-Pass 'Active Codex collision fails global preflight' (
        (-not $activePlan.Success) -and $activePlan.ExitReason -eq 'GlobalPreflight'
    ) $activePlan.CodexError
    Assert-Pass 'global preflight covers all seven stacks before write pass' ($activePlan.PreflightCount -eq 7)
    Assert-Pass 'Active Codex collision performs zero write passes' ($activePlan.WriteReportCount -eq 0)
    Assert-Pass 'Active Codex collision reports foreign ownership failure' (
        [bool]$activePlan.CodexFailed -and $activePlan.CodexError.Contains('Foreign or malformed')
    ) $activePlan.CodexError
    Assert-Pass 'Active Codex collision changes no selected live stack' (Test-SelectedLiveSnapshotsUnchanged -Before $beforeActiveCollision -After $afterActiveCollision)

    # 5. Invalid-target output exposes the complete seven-stack registry.
    $invalidOutput = & pwsh -NoProfile -File $syncScript -Target 'NotAStack' 2>&1 | Out-String
    Assert-Pass 'invalid target exits non-zero' ($LASTEXITCODE -ne 0)
    Assert-Pass 'invalid target lists all seven registered stacks and All' (
        $invalidOutput.Contains('Valid: Cursor, OpenCode, Antigravity, Vscode, Cline, Kilocode, Codex, All')
    ) $invalidOutput
}
finally {
    if ((Test-PathWithin -Child $scratchFull -Parent $tempFull) -and (Test-Path -LiteralPath $scratchFull)) {
        Remove-Item -LiteralPath $scratchFull -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Output ('codex phase3 checks: {0} passed, {1} failed' -f $passed, $failed)
exit $(if ($failed -gt 0) { 1 } else { 0 })
