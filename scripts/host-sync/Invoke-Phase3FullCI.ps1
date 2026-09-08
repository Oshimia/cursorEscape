#Requires -Version 7.0
<#
.SYNOPSIS
  Codex bring-up Phase 3 Full CI — focused Fast CI, seven-stack lifecycle, and
  non-mutating documentation-cascade checks.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$companionRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$hostSyncRoot = $PSScriptRoot

$fail = $false
function Assert-Pass {
    param(
        [Parameter(Mandatory)][string] $Name,
        [Parameter(Mandatory)][bool] $Ok,
        [string] $Detail = ''
    )
    $status = if ($Ok) { 'pass' } else { 'FAIL' }
    Write-Output "${Name}: $status $Detail".TrimEnd()
    if (-not $Ok) { $script:fail = $true }
}

function Read-RepoFile {
    param([Parameter(Mandatory)][string] $RelativePath)
    return Get-Content -LiteralPath (Join-Path $companionRoot $RelativePath) -Raw
}

# Focused temporary-root Fast CI: explicit Codex dry-run, all dry-run, BringUp
# All-Apply refusal, Active collision zero-write gate, and invalid-target output.
& pwsh -NoProfile -File (Join-Path $hostSyncRoot 'Invoke-CodexPhase3Checks.ps1')
Assert-Pass 'Codex Phase 3 Fast CI' ($LASTEXITCODE -eq 0)

. (Join-Path $hostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $hostSyncRoot 'HostSync.Core.ps1')
. (Join-Path $hostSyncRoot 'Register-StackAdapters.ps1')

$registered = Get-RegisteredStackIds
Assert-Pass 'registry has seven stacks' ($registered.Count -eq 7) (($registered -join ','))
Assert-Pass 'Codex is seventh registered stack' ($registered[-1] -eq 'Codex')
$codexManifest = Get-StackManifest -StackId 'Codex' -HostSyncRoot $hostSyncRoot
Assert-Pass 'Codex manifest declares Active' ($codexManifest.ApplyState -eq 'Active')
Assert-Pass 'registry defers to manifest for Codex ApplyState' ((Get-StackApplyState -Manifest $codexManifest) -eq 'Active')
Assert-Pass 'established stacks default Active' (
    @($registered | Where-Object { $_ -ne 'Codex' } | ForEach-Object {
        Get-StackApplyState -Manifest (Get-StackManifest -StackId $_ -HostSyncRoot $hostSyncRoot)
    }) -notcontains 'BringUp'
)

$coreSource = Read-RepoFile 'scripts/host-sync/HostSync.Core.ps1'
$entrySource = Read-RepoFile 'scripts/Sync-HostHarness.ps1'
Assert-Pass 'orchestration has global preflight function' ($coreSource.Contains('function Invoke-HostHarnessSyncPlan'))
Assert-Pass 'orchestration preflights before write pass' ($coreSource.Contains('Preflight every selected adapter before the first Apply write'))
Assert-Pass 'entry passes explicit effective Codex roots' (
    $entrySource.Contains('-CodexRoot $CodexRoot -SkillRoot $SkillRoot') -and
    $entrySource.Contains('BaselinePathsFile')
)
Assert-Pass 'entry invalid target uses registry' ($entrySource.Contains('$validTargets = @($registeredStackIds)'))

$sop = Read-RepoFile 'docs/SOPs/codex-host-adapter.md'
Assert-Pass 'Codex SOP documents activation' ($sop.Contains('`ApplyState = Active` (activated 2026-09-08'))
Assert-Pass 'Codex SOP documents two explicit roots' ($sop.Contains('explicit absolute roots'))
Assert-Pass 'Codex SOP documents smoke attestation' ($sop.Contains('three-client smoke attested 2026-09-08'))
Assert-Pass 'Codex SOP cites Fast CI' ($sop.Contains('Invoke-CodexPhase3Checks.ps1'))

$overlay = Read-RepoFile 'overlays/codex/_index.md'
Assert-Pass 'Codex overlay index records registered BringUp' (
    $overlay.Contains('Phase 3 registered source-only') -and
    $overlay.Contains('activated 2026-09-08 after three-client smoke')
)
$overlayIndex = Read-RepoFile 'overlays/_index.md'
Assert-Pass 'overlay index includes Codex' ($overlayIndex.Contains('[codex/](./codex/_index.md)'))
$sopIndex = Read-RepoFile 'docs/SOPs/_index.md'
Assert-Pass 'SOP index includes Codex adapter' ($sopIndex.Contains('./codex-host-adapter.md'))
$skillsIndex = Read-RepoFile 'skills/_index.md'
Assert-Pass 'skills index includes Codex overlay' ($skillsIndex.Contains('../overlays/codex/_index.md'))
$agentsIndex = Read-RepoFile 'agents/_index.md'
Assert-Pass 'agents index includes Codex agents' ($agentsIndex.Contains('../overlays/codex/agents/'))

$sourceFa = Read-RepoFile 'docs/featureArchitecture/skill-source-and-host-overlays.md'
Assert-Pass 'skill-source FA records seven stacks and preflight' (
    $sourceFa.Contains('currently Cursor, OpenCode, Antigravity, VS Code, Cline, Kilo Code, and Codex') -and
    $sourceFa.Contains('global-preflighted')
)
$layerFa = Read-RepoFile 'docs/featureArchitecture/instruction-layering.md'
Assert-Pass 'instruction-layering FA records Codex mapping' (
    $layerFa.Contains('Codex mapping (registered, Active)') -and
    $layerFa.Contains('marker-bounded managed block')
)
$fidelityFa = Read-RepoFile 'docs/featureArchitecture/host-adaptation-fidelity.md'
Assert-Pass 'host-fidelity FA keeps Codex not-Done' (
    $fidelityFa.Contains('Codex Phase 4 activated 2026-09-08') -and
    $fidelityFa.Contains('C1–C6 runtime attestation')
)

$workflowSop = Read-RepoFile 'docs/SOPs/editing-companion-workflow.md'
Assert-Pass 'editing workflow includes Codex host row' (
    $workflowSop.Contains('[codex-host-adapter](./codex-host-adapter.md)') -and
    $workflowSop.Contains('BringUp` lifecycle gate blocks any Apply write pass')
)
$readme = Read-RepoFile 'README.md'
Assert-Pass 'repository README includes seventh-stack status' (
    $readme.Contains('seventh `Codex` stack') -and
    $readme.Contains('activated `Active`')
)
$hostReadme = Read-RepoFile 'scripts/host-sync/README.md'
Assert-Pass 'host-sync README documents lifecycle/global preflight' (
    $hostReadme.Contains('## Apply lifecycle and global preflight') -and
    $hostReadme.Contains('zero writes')
)
$roadmap = Read-RepoFile 'docs/roadmaps/codex-bring-up.md'
Assert-Pass 'Codex roadmap Phase 3 complete' ($roadmap.Contains('[x] **Phase 3 — Registration, orchestration-wide preflight, CI, and docs**'))

# The legacy ledger intentionally remains a six-established-stack regression
# artifact; Codex has no initial live install or ledger hash yet.
$ledgerSource = Read-RepoFile 'scripts/host-sync/Get-ExistingSixStackRenderLedger.ps1'
Assert-Pass 'existing-stack ledger remains explicitly six' ($ledgerSource.Contains("@('Cursor', 'OpenCode', 'Antigravity', 'Vscode', 'Cline', 'Kilocode')"))

exit $(if ($fail) { 1 } else { 0 })
