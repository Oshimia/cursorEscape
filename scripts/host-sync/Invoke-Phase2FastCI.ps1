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

exit $(if ($fail) { 1 } else { 0 })
