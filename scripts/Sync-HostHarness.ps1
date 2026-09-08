#Requires -Version 7.0
<#
.SYNOPSIS
  Distribute companion overlay harness to live host stacks (dry-run default).
.DESCRIPTION
  Modular sync under scripts/host-sync/: shared core + per-stack manifest + adapter.
  Registry stacks: Cursor, OpenCode, Antigravity, Vscode, Cline, Kilocode, Codex
  (see Register-StackAdapters.ps1 / manifests/).
  Dry-run by default; use -Apply for live writes (requires Phase 0 baseline gate).
  Apply is also lifecycle-gated: all selected stacks must be Active. Codex was force-held
  BringUp through Phase 3 and activated Active on 2026-09-08 after three-client smoke;
  setting its manifest back to BringUp re-arms the gate. Global Apply preflights every selected
  stack before any write pass; any preflight failure causes zero Apply writes.
  Sync does NOT create backups on Apply — companion repo is ongoing SoT.
  Phase 0 baselines (restore-only): see scripts/host-sync/baseline-backups.paths.json.
  Layout + expansion recipe: scripts/host-sync/README.md.
.PARAMETER Target
  Stack target: a registered stack id, or All (continue-with-report; optional -FailFast).
  DEFAULT AND NORMATIVE VALUE IS All: the harness is a global skill set; live pushes go to every registered stack in one operation.
  Single-stack Apply is an exceptional, deliberate act (new-stack bring-up, scoped repair) and is refused unless -AllowSkew is passed.
.PARAMETER Apply
  Live write mode. Runs Assert-BaselineBackupsPresent (read-only gate) first.
.PARAMETER AllowSkew
  Required switch to permit single-stack -Apply when that target shares source files with other registered stacks (the guard fails closed otherwise).
  Using it intentionally leaves sibling stacks stale until the next full sync.
.PARAMETER FailFast
  After all-stack preflight succeeds, stop the write pass after first stack failure. It does not shorten the all-stack preflight.
.PARAMETER BringUpException
  One-time, owner-authorized exception that permits -Apply -Target Codex while the Codex manifest is ApplyState=BringUp (initial install only).
  Refused for every other target or any multi-stack selection. Without this switch the BringUp lifecycle gate fails closed.
.PARAMETER CodexRoot
  Optional explicit Codex home override for dry-run/test seams. Defaults to effective CODEX_HOME (~/.codex). The Codex adapter never infers roots itself.
.PARAMETER SkillRoot
  Optional explicit Codex skill-root override for dry-run/test seams. Defaults to ~/.agents/skills. The Codex adapter never infers roots itself.
.PARAMETER CompanionRoot
  Optional override for companion checkout root (defaults to repo containing scripts/).
.PARAMETER BaselinePathsFile
  Optional baseline paths override for disposable Apply-gate fixtures. Defaults to scripts/host-sync/baseline-backups.paths.json.
.NOTES
  Hard excludes (manifest-owned):
  - Cursor: skills-cursor/, settings.json; never delete/refresh docs/workflow/; hybrid rules only
  - OpenCode: no procedure mirror re-copy; review-subagent-models not host copy-out; preserve model/provider
  - Antigravity: full-replace GEMINI.md via single entry; never touch caveman.md or credential/app-state files
  - VS Code: never touch config.json, ide/, logs/
  - Cline/Kilo: narrow rules/workflows surfaces; platform state untouched
  - Codex: config.toml/auth.json/history.jsonl/logs/sessions/databases; non-empty AGENTS.override.md blocks Apply
  Post-apply verification policy: the script's built-in byte-level merge checks are authoritative for routine
  content syncs. Operator/agent smoke attestation belongs to first-time surfaces and harness-machinery changes
  only — not per-skill updates.
.EXAMPLE
  pwsh ./scripts/Sync-HostHarness.ps1                 # dry-run, all stacks (default)
.EXAMPLE
  pwsh ./scripts/Sync-HostHarness.ps1 -Apply          # live write, ALL stacks
.EXAMPLE
  pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target All -FailFast
.EXAMPLE
  pwsh ./scripts/Sync-HostHarness.ps1 -Target OpenCode                 # dry-run inspection of one manifest
.EXAMPLE
  pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target Cursor -AllowSkew # EXCEPTION path only
.EXAMPLE
  pwsh ./scripts/Sync-HostHarness.ps1 -Target Codex -CodexRoot C:/temp/codex -SkillRoot C:/temp/skills
.EXAMPLE
  pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target Codex -AllowSkew -BringUpException # Phase 4 initial install only
.LINK
  scripts/host-sync/README.md
.LINK
  docs/roadmaps/host-harness-sync-build.md
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string] $Target = 'All',

    [switch] $Apply,

    [switch] $AllowSkew,

    [switch] $FailFast,

    [switch] $BringUpException,

    [string] $CodexRoot = '',

    [string] $SkillRoot = '',

    [string] $CompanionRoot = '',

    [string] $BaselinePathsFile = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$hostSyncRoot = Join-Path $PSScriptRoot 'host-sync'
. (Join-Path $hostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $hostSyncRoot 'HostSync.Core.ps1')
. (Join-Path $hostSyncRoot 'Register-StackAdapters.ps1')

$registeredStackIds = Get-RegisteredStackIds
$validTargets = @($registeredStackIds) + @('All')
if ($Target -notin $validTargets) {
    Write-Output "FATAL: Invalid -Target '$Target'. Valid: $($validTargets -join ', ')"
    exit 1
}

if ([string]::IsNullOrWhiteSpace($CompanionRoot)) {
    $CompanionRoot = Get-DefaultCompanionRoot -HostSyncRoot $hostSyncRoot
}
else {
    $CompanionRoot = Resolve-CompanionRootPath -Path $CompanionRoot
}

$mode = if ($Apply) { [HostSyncMode]::Apply } else { [HostSyncMode]::DryRun }

function Get-TargetStackIds {
    param([string]$TargetName)
    if ($TargetName -eq 'All') {
        return (Get-RegisteredStackIds)
    }
    return @($TargetName)
}

if ($mode -eq [HostSyncMode]::Apply) {
    try {
        $baselinePaths = if ([string]::IsNullOrWhiteSpace($BaselinePathsFile)) {
            Get-BaselinePathsFile -HostSyncRoot $hostSyncRoot
        }
        else {
            $BaselinePathsFile
        }
        Assert-BaselineBackupsPresent -PathsFile $baselinePaths -CompanionRoot $CompanionRoot
    }
    catch {
        Write-Output "FATAL (gate): $($_.Exception.Message)"
        exit 1
    }
}

$stackIds = @(Get-TargetStackIds -TargetName $Target)

if ($stackIds.Count -eq 1) {
    # Global-distribution guard: this skill set is global; a live push to one
    # stack alone silently strands every sibling stack carrying the same sources.
    # Unroll defensively: the helper may return a single array object (comma return)
    # or a stream of @{Identity;Siblings} rows — @(…) would re-wrap a lone array as
    # one element and fake Count=1. Flatten rows, then count rows.
    $overlapRaw = Get-CrossStackSourceOverlap -StackId $Target -HostSyncRoot $hostSyncRoot
    $overlap = @(
        foreach ($o in $overlapRaw) { $o }
    )
    if ($overlap.Count -gt 0) {
        if ($mode -eq [HostSyncMode]::Apply) {
            if (-not $AllowSkew) {
                Write-Output "FATAL (skew guard): '-Apply -Target $Target' updates $($overlap.Count) source identity(ies) also distributed to other stacks; siblings would go stale."
                foreach ($o in $overlap) {
                    Write-Output ("  {0} -> also in: {1}" -f $o.Identity, ($o.Siblings -join ', '))
                }
                Write-Output "Normative path: run without -Target (or with -Target All). Single-stack Apply is a deliberate exception; re-run with -AllowSkew to proceed anyway."
                exit 1
            }
            Write-Output "SKEW WARNING (-AllowSkew): shared sources stale on sibling stacks until next full sync:"
            foreach ($o in $overlap) {
                Write-Output ("  {0} -> also in: {1}" -f $o.Identity, ($o.Siblings -join ', '))
            }
        }
        else {
            Write-Output "NOTE (dry-run): target shares $($overlap.Count) source file(s) with sibling stacks; live writes here will require -Target All or -AllowSkew."
        }
    }
}

$plan = Invoke-HostHarnessSyncPlan -Mode $mode -StackIds $stackIds `
    -CompanionRoot $CompanionRoot -HostSyncRoot $hostSyncRoot `
    -CodexRoot $CodexRoot -SkillRoot $SkillRoot -FailFast:$FailFast -BringUpException:$BringUpException
$anyFailed = -not $plan.Success

Write-Output "=== Summary: mode=$($mode.ToString()) target=$Target stacks=$($stackIds -join ',') success=$(-not $anyFailed) ==="
exit $(if ($anyFailed) { 1 } else { 0 })
