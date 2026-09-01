#Requires -Version 7.0
<#
.SYNOPSIS
  Phase 2 Fast CI for host-harness-sync (dry-run OpenCode + All; no live Apply).
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$companionRoot = 'C:\Users\admin\source\repos\general-projects\cursorEscape'
$syncScript = Join-Path $companionRoot 'scripts\Sync-HostHarness.ps1'
$hostSyncRoot = Join-Path $companionRoot 'scripts\host-sync'

$fail = $false

function Assert-Pass {
    param([string]$Name, [bool]$Ok)
    $status = if ($Ok) { 'pass' } else { 'fail' }
    Write-Output "${Name}: $status"
    if (-not $Ok) { $script:fail = $true }
}

function Get-LiveOpenCodeSnapshot {
    param([string]$LiveRoot)
    $snapshot = @{}
    if (-not (Test-Path -LiteralPath $LiveRoot)) { return $snapshot }
    Get-ChildItem -LiteralPath $LiveRoot -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
        $snapshot[$_.FullName] = $_.LastWriteTimeUtc.Ticks
    }
    return $snapshot
}

function Test-LiveOpenCodeUnchanged {
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

$liveOpenCode = Join-Path $env:USERPROFILE '.config\opencode'
$before = Get-LiveOpenCodeSnapshot -LiveRoot $liveOpenCode

& pwsh -NoProfile -File $syncScript -Target OpenCode
Assert-Pass 'dry-run OpenCode exit 0' ($LASTEXITCODE -eq 0)

$afterOpenCode = Get-LiveOpenCodeSnapshot -LiveRoot $liveOpenCode
Assert-Pass 'dry-run OpenCode made no live writes' (Test-LiveOpenCodeUnchanged -Before $before -After $afterOpenCode)

$beforeAll = Get-LiveOpenCodeSnapshot -LiveRoot $liveOpenCode
$liveCursor = Join-Path $env:USERPROFILE '.cursor'
$beforeCursor = Get-LiveOpenCodeSnapshot -LiveRoot $liveCursor

& pwsh -NoProfile -File $syncScript -Target All
Assert-Pass 'dry-run All exit 0' ($LASTEXITCODE -eq 0)

$afterAllOpenCode = Get-LiveOpenCodeSnapshot -LiveRoot $liveOpenCode
$afterAllCursor = Get-LiveOpenCodeSnapshot -LiveRoot $liveCursor
Assert-Pass 'dry-run All made no OpenCode writes' (Test-LiveOpenCodeUnchanged -Before $beforeAll -After $afterAllOpenCode)
Assert-Pass 'dry-run All made no Cursor writes' (Test-LiveOpenCodeUnchanged -Before $beforeCursor -After $afterAllCursor)

$syncSources = @(
    (Join-Path $hostSyncRoot 'adapters\OpenCode.Adapter.ps1')
    (Join-Path $hostSyncRoot 'HostSync.Core.ps1')
)
$combined = ($syncSources | ForEach-Object { Get-Content -LiteralPath $_ -Raw }) -join "`n"
Assert-Pass 'OpenCode adapter present (not stub)' ($combined -notmatch 'Phase 2 stub')
Assert-Pass 'Merge-HashtablePreserve in core' ($combined -match 'Merge-HashtablePreserve')
Assert-Pass 'AGENTS dual-write helper present' ($combined -match 'Invoke-OpenCodeAgentsDualWrite')
Assert-Pass 'no host-sync-apply backup paths in OpenCode sources' ($combined -notmatch 'host-sync-apply-|SkipBackup')

$manifest = Import-PowerShellDataFile -LiteralPath (Join-Path $hostSyncRoot 'manifests\opencode.manifest.psd1')
Assert-Pass 'manifest has copy entries' ($manifest.CopyEntries.Count -ge 14)
Assert-Pass 'manifest has JsonMerge' ($null -ne $manifest.JsonMerge)
Assert-Pass 'manifest hard-excludes docs/workflow' ($manifest.HardExcludes -contains 'docs/workflow')
Assert-Pass 'manifest hard-excludes review-subagent-models' ($manifest.HardExcludes -contains 'review-subagent-models')

. (Join-Path $hostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $hostSyncRoot 'HostSync.Core.ps1')
$companionNorm = Resolve-CompanionRootPath -Path $companionRoot
$openCodeHome = Get-OpenCodeHomePath
$specimenPath = Join-Path $companionRoot 'overlays\opencode\opencode.specimen.json'
$specimenHt = Resolve-OpenCodeSpecimenJson -SpecimenPath $specimenPath -CompanionRoot $companionNorm -OpenCodeHome $openCodeHome
$instr = Get-OpenCodeInstructionsPath -Config $specimenHt
Assert-Pass 'specimen instructions absolute after merge' ($instr -like "$openCodeHome*")
Assert-Pass 'specimen has no unreplaced tokens' (-not (Test-ContentHasUnmergedTokens -Content ($specimenHt | ConvertTo-Json -Depth 20 -Compress)))

# Permission pattern maps: "*" must be first (OpenCode last-match-wins)
$liveJsonPath = Join-Path $openCodeHome 'opencode.json'
$mergedHt = Merge-OpenCodeHarnessJson -Specimen $specimenHt -LiveJsonPath $liveJsonPath -PreserveTopLevelKeys @('model', 'provider')
$taskKeys = @($mergedHt.agent.build.permission.task.Keys)
$bashKeys = @($mergedHt.permission.bash.Keys)
Assert-Pass 'merged build.task permission puts * first' ($taskKeys.Count -ge 1 -and $taskKeys[0] -eq '*')
Assert-Pass 'merged global bash permission puts * first' ($bashKeys.Count -ge 1 -and $bashKeys[0] -eq '*')
Assert-Pass 'Optimize-OpenCodePermissionKeyOrder in core' ((Get-Content (Join-Path $hostSyncRoot 'HostSync.Core.ps1') -Raw) -match 'Optimize-OpenCodePermissionKeyOrder')

# --- Antigravity stack (Phase 1 structural blocks; behavioral dry-run/snapshot/inventory blocks activate in Phase 2) ---
$agyManifestPath = Join-Path $hostSyncRoot 'manifests\antigravity.manifest.psd1'
Assert-Pass 'antigravity manifest exists' (Test-Path -LiteralPath $agyManifestPath)
if (Test-Path -LiteralPath $agyManifestPath) {
    $agyManifest = Import-PowerShellDataFile -LiteralPath $agyManifestPath
    Assert-Pass 'antigravity StackId' ($agyManifest.StackId -eq 'Antigravity')
    Assert-Pass 'antigravity overlay root declared' ($agyManifest.OverlayRelativeRoot -eq 'overlays/antigravity')
    Assert-Pass 'antigravity live root declared' ($agyManifest.LiveRelativeRoot -eq '.gemini')
    Assert-Pass 'antigravity manifest has >=13 copy entries' ($agyManifest.CopyEntries.Count -ge 13)
    Assert-Pass 'antigravity excludes use no backslashes' (@($agyManifest.HardExcludes + $agyManifest.NeverTouch | Where-Object { $_ -match '\\' }).Count -eq 0)
    Assert-Pass 'antigravity hard-excludes caveman.md' ($agyManifest.HardExcludes -contains 'antigravity/global_workflows/caveman.md')
    Assert-Pass 'antigravity never-touch caveman.md' ($agyManifest.NeverTouch -contains 'antigravity/global_workflows/caveman.md')
    foreach ($agySecret in @('settings.json', 'oauth_creds.json', 'google_accounts.json')) {
        Assert-Pass "antigravity hard-excludes $agySecret" ($agyManifest.HardExcludes -contains $agySecret)
    }
    Assert-Pass 'antigravity manifest has no JsonMerge' (-not ($agyManifest.Keys -contains 'JsonMerge'))
    Assert-Pass 'antigravity manifest has no AgentsDualWrite' (-not ($agyManifest.Keys -contains 'AgentsDualWrite'))
    Assert-Pass 'antigravity manifest has no HybridRuleIds' (-not ($agyManifest.Keys -contains 'HybridRuleIds'))
    $geminiEntries = @($agyManifest.CopyEntries | Where-Object { $_.Dest -eq 'GEMINI.md' })
    Assert-Pass 'antigravity replaces GEMINI.md via exactly one entry' ($geminiEntries.Count -eq 1)
    $skillDests = @($agyManifest.CopyEntries | Where-Object { $_.Dest -like 'config/skills/*' })
    # 2026-08-29 (Phase 3 retirement, D4 map): 9 -> 11. The canonical skill inventory is
    # now eleven ids (opencode-* pair global on every stack per the 2026-08-26 ruling;
    # pre-commit-ci-gate composed from base: SoT in Phase 2).
    Assert-Pass 'antigravity skill dests under config/skills' ($skillDests.Count -eq 11)
    $wfDests = @($agyManifest.CopyEntries | Where-Object { $_.Dest -like 'antigravity/global_workflows/*' })
    Assert-Pass 'antigravity workflow dests under global_workflows' ($wfDests.Count -eq 3)
    $agentDests = @($agyManifest.CopyEntries | Where-Object { $_.Dest -like 'config/agents/*' })
    Assert-Pass 'antigravity reviewer defs under config/agents' ($agentDests.Count -eq 3)
}

$agyAdapterPath = Join-Path $hostSyncRoot 'adapters\Generic.Adapter.ps1'
Assert-Pass 'generic adapter exists (not stub)' (Test-Path -LiteralPath $agyAdapterPath)
Assert-Pass 'antigravity clone adapter deleted (dispatches to Generic)' (-not (Test-Path -LiteralPath (Join-Path $hostSyncRoot 'adapters\Antigravity.Adapter.ps1')))
if (Test-Path -LiteralPath $agyAdapterPath) {
    $agyAdapterText = Get-Content -LiteralPath $agyAdapterPath -Raw
    Assert-Pass 'generic adapter exports Invoke-StackHarnessSync' ($agyAdapterText -match 'function Invoke-StackHarnessSync')
    Assert-Pass 'generic adapter is not a stub' ($agyAdapterText -notmatch 'Phase 2 stub')
    Assert-Pass 'generic adapter reuses shared Copy-ManifestEntry' ($agyAdapterText -match 'Copy-ManifestEntry')
}

# Fail-closed baseline gate: antigravity property/dir required before ANY Apply (isolated temp fixtures only)
# vscode bring-up 2026-09-01: vscode property added to the same fail-closed set (owner-approved Core gate edit).
$agiFixtureDir = Join-Path ([IO.Path]::GetTempPath()) ("hostsync-gate-" + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $agiFixtureDir -Force | Out-Null
try {
    $agiFixtureNoProp = Join-Path $agiFixtureDir 'no-prop.json'
    '{"cursor":"C:\\does\\not\\exist","opencode":"C:\\does\\not\\exist","companionSha":"x","created":"y"}' | Set-Content -LiteralPath $agiFixtureNoProp
    $agiThrewNoProp = $false
    try { Assert-BaselineBackupsPresent -PathsFile $agiFixtureNoProp -AllowCompanionShaMismatch | Out-Null } catch { $agiThrewNoProp = ($_.Exception.Message -match 'antigravity') }
    Assert-Pass 'baseline gate fails closed without antigravity property' $agiThrewNoProp

    $agiFixtureEmpty = Join-Path $agiFixtureDir 'empty-prop.json'
    '{"cursor":"C:\\does\\not\\exist","opencode":"C:\\does\\not\\exist","antigravity":"","companionSha":"x","created":"y"}' | Set-Content -LiteralPath $agiFixtureEmpty
    $agiThrewEmpty = $false
    try { Assert-BaselineBackupsPresent -PathsFile $agiFixtureEmpty -AllowCompanionShaMismatch | Out-Null } catch { $agiThrewEmpty = ($_.Exception.Message -match 'antigravity') }
    Assert-Pass 'baseline gate fails closed on empty antigravity path' $agiThrewEmpty

    $repoBaselineJson = Get-Content -LiteralPath (Get-BaselinePathsFile -HostSyncRoot $hostSyncRoot) -Raw | ConvertFrom-Json
    Assert-Pass 'baseline-backups.paths.json parses with antigravity property' ($null -ne $repoBaselineJson.antigravity)

    # vscode fail-closed negative tests (4th stack, 2026-09-01)
    $vscFixtureNoProp = Join-Path $agiFixtureDir 'no-prop-vsc.json'
    '{"cursor":"C:\\does\\not\\exist","opencode":"C:\\does\\not\\exist","antigravity":"C:\\does\\not\\exist","companionSha":"x","created":"y"}' | Set-Content -LiteralPath $vscFixtureNoProp
    $vscThrewNoProp = $false
    try { Assert-BaselineBackupsPresent -PathsFile $vscFixtureNoProp -AllowCompanionShaMismatch | Out-Null } catch { $vscThrewNoProp = ($_.Exception.Message -match 'vscode') }
    Assert-Pass 'baseline gate fails closed without vscode property' $vscThrewNoProp

    $vscFixtureEmpty = Join-Path $agiFixtureDir 'empty-prop-vsc.json'
    '{"cursor":"C:\\does\\not\\exist","opencode":"C:\\does\\not\\exist","antigravity":"C:\\does\\not\\exist","vscode":"","companionSha":"x","created":"y"}' | Set-Content -LiteralPath $vscFixtureEmpty
    $vscThrewEmpty = $false
    try { Assert-BaselineBackupsPresent -PathsFile $vscFixtureEmpty -AllowCompanionShaMismatch | Out-Null } catch { $vscThrewEmpty = ($_.Exception.Message -match 'vscode') }
    Assert-Pass 'baseline gate fails closed on empty vscode path' $vscThrewEmpty

    Assert-Pass 'baseline-backups.paths.json parses with vscode property' ($null -ne $repoBaselineJson.vscode)
}
finally {
    Remove-Item -LiteralPath $agiFixtureDir -Recurse -Force -ErrorAction SilentlyContinue
}

# --- VS Code stack structural blocks (vscode bring-up 2026-09-01) ---
$vscManifestPath = Join-Path $hostSyncRoot 'manifests\vscode.manifest.psd1'
Assert-Pass 'vscode manifest exists' (Test-Path -LiteralPath $vscManifestPath)
if (Test-Path -LiteralPath $vscManifestPath) {
    $vscManifest = Import-PowerShellDataFile -LiteralPath $vscManifestPath
    Assert-Pass 'vscode StackId' ($vscManifest.StackId -eq 'Vscode')
    Assert-Pass 'vscode overlay root declared' ($vscManifest.OverlayRelativeRoot -eq 'overlays/vscode')
    Assert-Pass 'vscode live root declared' ($vscManifest.LiveRelativeRoot -eq '.copilot')
    Assert-Pass 'vscode manifest has 21 copy entries' ($vscManifest.CopyEntries.Count -eq 21)
    Assert-Pass 'vscode excludes use no backslashes' (@($vscManifest.HardExcludes + $vscManifest.NeverTouch | Where-Object { $_ -match '\\' }).Count -eq 0)
    Assert-Pass 'vscode never-touch config.json' ($vscManifest.NeverTouch -contains 'config.json')
    Assert-Pass 'vscode manifest has no JsonMerge' (-not ($vscManifest.Keys -contains 'JsonMerge'))
    Assert-Pass 'vscode manifest has no AgentsDualWrite' (-not ($vscManifest.Keys -contains 'AgentsDualWrite'))
    Assert-Pass 'vscode manifest has no HybridRuleIds' (-not ($vscManifest.Keys -contains 'HybridRuleIds'))
    $vscAgentDests = @($vscManifest.CopyEntries | Where-Object { $_.Dest -like 'agents/*' })
    Assert-Pass 'vscode agent defs under agents/ (8 roles)' ($vscAgentDests.Count -eq 8)
    $vscSkillDests = @($vscManifest.CopyEntries | Where-Object { $_.Dest -like 'skills/*' })
    Assert-Pass 'vscode skill dests under skills/ (11)' ($vscSkillDests.Count -eq 11)
    $vscAdapterPath = Join-Path $hostSyncRoot 'adapters\Generic.Adapter.ps1'
    Assert-Pass 'vscode clone adapter deleted (dispatches to Generic)' (-not (Test-Path -LiteralPath (Join-Path $hostSyncRoot 'adapters\Vscode.Adapter.ps1')))
    Assert-Pass 'vscode dispatches to Generic adapter' (Test-Path -LiteralPath $vscAdapterPath)
    if (Test-Path -LiteralPath $vscAdapterPath) {
        $vscAdapterText = Get-Content -LiteralPath $vscAdapterPath -Raw
        Assert-Pass 'generic adapter exports Invoke-StackHarnessSync (vscode-leg)' ($vscAdapterText -match 'function Invoke-StackHarnessSync')
        Assert-Pass 'generic adapter is not a stub (vscode-leg)' ($vscAdapterText -notmatch 'Phase 2 stub')
    }
    $vscLive = Join-Path $env:USERPROFILE '.copilot'
    $beforeVsc = Get-LiveOpenCodeSnapshot -LiveRoot $vscLive
    & pwsh -NoProfile -File $syncScript -Target Vscode
    Assert-Pass 'dry-run Vscode exit 0' ($LASTEXITCODE -eq 0)
    $afterVsc = Get-LiveOpenCodeSnapshot -LiveRoot $vscLive
    Assert-Pass 'dry-run Vscode made no live writes' (Test-LiveOpenCodeUnchanged -Before $beforeVsc -After $afterVsc)
}

# --- Antigravity behavioral blocks (overlay leaves present) ---
$agyLive = Join-Path $env:USERPROFILE '.gemini'
$beforeAgy = Get-LiveOpenCodeSnapshot -LiveRoot $agyLive

& pwsh -NoProfile -File $syncScript -Target Antigravity
Assert-Pass 'dry-run Antigravity exit 0' ($LASTEXITCODE -eq 0)

$afterAgy = Get-LiveOpenCodeSnapshot -LiveRoot $agyLive
Assert-Pass 'dry-run Antigravity made no live writes' (Test-LiveOpenCodeUnchanged -Before $beforeAgy -After $afterAgy)

# Inventory-drift guard: overlay ids equal the canonical eleven AND each exists in companion skills/
# 2026-08-29 (Phase 3 retirement, D4 map): expectedNine -> eleven. opencode-headless-run and
# opencode-history-search are global on every stack (opencode-overlay inventory = the parity bar).
$expectedSkillIds = @('composer', 'diagnosing-bugs', 'discovery', 'documentation-architecture', 'implementation-plan', 'implementation-review', 'opencode-headless-run', 'opencode-history-search', 'plan-review', 'pre-commit-ci-gate', 'roadmap')
$agyOverlaySkillsRoot = Join-Path $companionRoot 'overlays\antigravity\skills'
$actualAgyIds = @(Get-ChildItem -LiteralPath $agyOverlaySkillsRoot -Directory | ForEach-Object { $_.Name })
$agyIdDelta = @(Compare-Object -ReferenceObject ($expectedSkillIds | Sort-Object) -DifferenceObject ($actualAgyIds | Sort-Object))
Assert-Pass 'antigravity overlay skill ids equal canonical eleven' ($agyIdDelta.Count -eq 0)
foreach ($agiId in $expectedSkillIds) {
    Assert-Pass "opencode overlay parity skill exists: $agiId" (Test-Path -LiteralPath (Join-Path $companionRoot "overlays\opencode\skills\$agiId\SKILL.md"))
    if (Test-Path -LiteralPath (Join-Path $companionRoot "skills\$agiId")) {
        Assert-Pass "companion base exists for mirrored id: $agiId" (Test-Path -LiteralPath (Join-Path $companionRoot "skills\$agiId\SKILL.md"))
    }
}

# Author-time harness hygiene: zero ../../ hops; every stub carries description:; thin files under 12k
$agyHarnessFiles = @(Get-ChildItem -LiteralPath (Join-Path $companionRoot 'overlays\antigravity') -Recurse -File -Include '*.md' |
    Where-Object { $_.Name -ne '_index.md' })
$agyHopViolations = @($agyHarnessFiles | Where-Object { (Get-Content -LiteralPath $_.FullName -Raw) -match '\.\./\.\./(docs|skills|agents)/' })
Assert-Pass 'zero ../../ docs|skills|agents hops in antigravity harness' ($agyHopViolations.Count -eq 0)
$agyMissingDescription = @($agyHarnessFiles | Where-Object {
    $agiRaw = Get-Content -LiteralPath $_.FullName -Raw
    ($_.Name -eq 'SKILL.md') -and ($agiRaw -notmatch '(?m)^description:')
})
Assert-Pass 'all SKILL.md stubs carry description frontmatter' ($agyMissingDescription.Count -eq 0)
$agyOver12k = @($agyHarnessFiles | Where-Object { (Get-Content -LiteralPath $_.FullName -Raw).Length -ge 12000 })
Assert-Pass 'antigravity gate/skills/workflows under 12k chars' ($agyOver12k.Count -eq 0)

# Hardcoded machine paths forbidden in harness leaves — token merge cannot catch them, so CI must
$agyHardcodedPaths = @($agyHarnessFiles | Where-Object { (Get-Content -LiteralPath $_.FullName -Raw) -match 'C:[/\\]Users[/\\]admin' })
Assert-Pass 'no hardcoded machine paths in antigravity harness' ($agyHardcodedPaths.Count -eq 0)

exit $(if ($fail) { 1 } else { 0 })
