#Requires -Version 7.0
<#
.SYNOPSIS
  Phase 1 Full CI — dry-run evidence, token/hybrid checks; no live Apply unless operator authorized.
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

# Dry-run capture
$dryRunOutput = & pwsh -NoProfile -File $syncScript -Target Cursor 2>&1 | Out-String
Assert-Pass 'dry-run Cursor exit 0' ($LASTEXITCODE -eq 0)

# Token grep on planned hybrid content (companion rules used in dry-run verification)
. (Join-Path $hostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $hostSyncRoot 'HostSync.Core.ps1')
$companionNorm = Resolve-CompanionRootPath -Path $companionRoot
$ruleIds = @('iterative-plan-review', 'iterative-code-review', 'pre-commit-ci-gate')
$tokenOk = $true
$pressureOk = $true
foreach ($ruleId in $ruleIds) {
    $planned = Get-PlannedHybridRuleContent -CompanionRoot $companionNorm -RuleId $ruleId
    if ($planned -match '\{\{COMPANION_ROOT\}\}') { $tokenOk = $false }
}
$codeReviewPlanned = Get-PlannedHybridRuleContent -CompanionRoot $companionNorm -RuleId 'iterative-code-review'
if ($codeReviewPlanned -notmatch '4-iteration|pressure-release|≤4') { $pressureOk = $false }
Assert-Pass 'dry-run hybrid token merge (0 unreplaced tokens)' $tokenOk
Assert-Pass 'dry-run hybrid pressure-release wording (iterative-code-review)' $pressureOk

# Overlay copy sources: no unreplaced tokens after merge simulation
$manifest = Import-PowerShellDataFile -LiteralPath (Join-Path $hostSyncRoot 'manifests\cursor.manifest.psd1')
$overlayRoot = Join-Path $companionRoot 'overlays\cursor'
$overlayTokenOk = $true
foreach ($entry in $manifest.CopyEntries) {
    $src = Join-Path $overlayRoot $entry.Source
    if (-not (Test-Path -LiteralPath $src)) { continue }
    $merged = Merge-CompanionTokens -Content ([IO.File]::ReadAllText($src)) -CompanionRoot $companionNorm
    if ($merged -match '\{\{COMPANION_ROOT\}\}') { $overlayTokenOk = $false }
}
Assert-Pass 'overlay copy token merge simulation' $overlayTokenOk

# Registry stacks listed in entry help (registry-driven validation)
$entrySource = Get-Content -LiteralPath $syncScript -Raw
Assert-Pass 'entry uses Get-RegisteredStackIds' ($entrySource -match 'Get-RegisteredStackIds')
Assert-Pass 'entry documents registry stacks in comment help' ($entrySource -match 'Registry stacks: Cursor, OpenCode')
Assert-Pass 'entry documents invalid Target message' ($entrySource -match 'Invalid -Target')

# Fast CI re-run as part of closeout suite
& pwsh -NoProfile -File (Join-Path $hostSyncRoot 'Invoke-Phase1FastCI.ps1')
Assert-Pass 'Phase1 Fast CI nested pass' ($LASTEXITCODE -eq 0)

exit $(if ($fail) { 1 } else { 0 })
