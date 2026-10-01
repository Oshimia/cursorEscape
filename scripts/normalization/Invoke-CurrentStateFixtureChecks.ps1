#Requires -Version 7.4
<#
.SYNOPSIS
    Read-only current-source invariant checks.
.DESCRIPTION
    Fails closed on current catalog, manifest, lifecycle-evidence, or governed
    handoff inconsistency. Performs no live host writes and no repository writes.
#>
param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path,
    [string]$AgentsCatalogPath = ''
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'ProcedureRegistry.psm1') -Force
Import-Module (Join-Path $PSScriptRoot 'LocalScratch.psm1') -Force

$failures = [System.Collections.Generic.List[string]]::new()
function Add-Failure([string]$Invariant,[string]$Detail) { $failures.Add("${Invariant}: $Detail") }
function Test-RepoPath([string]$Relative,[string]$Invariant,[switch]$Directory) {
    if ([string]::IsNullOrWhiteSpace($Relative)) { Add-Failure $Invariant 'empty path'; return }
    $full = Join-Path $RepoRoot $Relative
    try { $resolved = (Resolve-Path -LiteralPath $full -ErrorAction Stop).ProviderPath } catch { Add-Failure $Invariant "unresolvable $Relative"; return }
    $rootNorm = [IO.Path]::GetFullPath($RepoRoot).TrimEnd('\','/') + '\'
    $resNorm = [IO.Path]::GetFullPath($resolved)
    if (-not $resNorm.StartsWith($rootNorm, [StringComparison]::OrdinalIgnoreCase)) { Add-Failure $Invariant "path escapes repo: $Relative"; return }
    $kind = if ($Directory) { 'Container' } else { 'Leaf' }
    if (-not (Test-Path -LiteralPath $resolved -PathType $kind)) { Add-Failure $Invariant "wrong type for $Relative" }
}

$hosts = @('Cursor','OpenCode','Antigravity','Vscode','Cline','Kilocode','Codex')
$catalogFiles = @{ agents = 'agents.json'; skills = 'skills.json'; rules = 'rules.json'; workflows = 'workflows.json' }
$catalogs = @{}
foreach ($kind in $catalogFiles.Keys) {
    $path = if ($kind -eq 'agents' -and $AgentsCatalogPath) { $AgentsCatalogPath } else { Join-Path $RepoRoot (Join-Path 'catalog' $catalogFiles[$kind]) }
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { Write-Error "FAIL: Missing $path"; exit 1 }
    try {
        $raw = Get-Content -Raw -LiteralPath $path
        $catalogs[$kind] = $raw | ConvertFrom-Json
    } catch { Write-Error "FAIL: Invalid $kind catalog: $($_.Exception.Message)"; exit 1 }
    if ($catalogs[$kind].schema -ne 'catalog/v1' -or $catalogs[$kind].kind -ne $kind) {
        Add-Failure 'CatalogIdentity' "$kind schema=$($catalogs[$kind].schema) kind=$($catalogs[$kind].kind)"
    }
}

$expectedAgents = @('planner','plan_reviewer','implementer','production_readiness_reviewer','bug_reviewer','repository_explorer','test_reviewer')
$agentIds = @($catalogs.agents.items | ForEach-Object { [string]$_.id })
if ($agentIds.Count -ne 7) { Add-Failure 'AgentCoverage' "expected 7, got $($agentIds.Count)" }
if ((($agentIds | Sort-Object) -join '|') -ne (($expectedAgents | Sort-Object) -join '|')) {
    Add-Failure 'AgentSet' "expected '$((($expectedAgents | Sort-Object) -join '|'))', got '$(($agentIds | Sort-Object) -join '|')'"
}
$idsByKind = @{}
foreach ($kind in @('agents','skills','rules','workflows')) {
    $kindIds = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($item in @($catalogs[$kind].items)) {
        $id = [string]$item.id
        if ([string]::IsNullOrWhiteSpace($id)) { Add-Failure 'EmptyCanonicalId' $kind; continue }
        if (-not $kindIds.Add($id)) { Add-Failure 'DuplicateCanonicalId' "$kind/$id" }
    }
    $idsByKind[$kind] = $kindIds
}

$knownIds = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
foreach ($kindIds in $idsByKind.Values) { foreach ($id in $kindIds) { $null = $knownIds.Add([string]$id) } }

try { $manifests = @(Get-RegistryManifests -RepoRoot $RepoRoot) } catch { Add-Failure 'ManifestCurrentSource' $_.Exception.Message; $manifests = @() }
if ($manifests.Count -ne 7) { Add-Failure 'ManifestCoverage' "expected 7, got $($manifests.Count)" }
$manifestsByHost = @{}
foreach ($manifest in $manifests) {
    if ($manifestsByHost.ContainsKey([string]$manifest.host)) { Add-Failure 'DuplicateManifestHost' $manifest.host; continue }
    $manifestsByHost[[string]$manifest.host] = $manifest
    Test-RepoPath $manifest.path "ManifestPath[$($manifest.host)]"
}
foreach ($hostName in $hosts) { if (-not $manifestsByHost.ContainsKey($hostName)) { Add-Failure 'ManifestHostMissing' $hostName } }

$overlayRoots = @{}
foreach ($manifest in $manifests) { $overlayRoots[$manifest.host] = @{ Overlay = $manifest.overlay_root; Shared = $manifest.shared_root } }
foreach ($kind in @('agents','skills','rules','workflows')) {
    try {
        foreach ($failure in (Test-RegistryCatalog -Catalog $catalogs[$kind] -Kind $kind -RepoRoot $RepoRoot -OverlayRoots $overlayRoots -Manifests $manifests)) { Add-Failure 'RegistryValidation' "$kind/$failure" }
    } catch { Add-Failure 'RegistryValidation' $_.Exception.Message }
}
foreach ($composition in @($catalogs.workflows.compositions)) {
    if (-not $knownIds.Contains([string]$composition.canonicalReferenceId)) {
        Add-Failure 'InvalidCompositionReference' "$($composition.id) canonical '$($composition.canonicalReferenceId)'"
    }
}

# Host policy that is intentionally checked at the public current-state boundary.
foreach ($hostName in $hosts) {
    if (-not $manifestsByHost.ContainsKey($hostName)) { continue }
    $manifest = $manifestsByHost[$hostName]
    $expectedModel = if ($hostName -eq 'Codex') { 'codex-two-logical-roots' } else { 'single-root' }
    if ($manifest.binding_model -ne $expectedModel) { Add-Failure 'BindingModel' "$hostName expected '$expectedModel', got '$($manifest.binding_model)'" }
    if ($hostName -eq 'OpenCode') {
        if (-not $manifest.agents_dual_write -or $manifest.agents_dual_write.instructions_rel -ne 'instructions/cursor-escape-loop.md') { Add-Failure 'OpenCodeDualWrite' $hostName }
        if (-not $manifest.json_merge -or $manifest.json_merge.specimen_rel -ne 'opencode.specimen.json') { Add-Failure 'OpenCodeJsonMerge' $hostName }
    }
    if ($hostName -eq 'Codex') {
        if ([string]$manifest.ownership_marker -ne 'cursorEscape-managed:v1') { Add-Failure 'CodexManifestPolicy' 'ownership_marker' }
        if ([string]$manifest.managed_block_marker -ne 'cursorEscape-managed-block:v1') { Add-Failure 'CodexManifestPolicy' 'managed_block_marker' }
        if ([int]$manifest.skill_catalog_budget_characters -ne 8000) { Add-Failure 'CodexManifestPolicy' 'skill_catalog_budget_characters' }
        if (@($manifest.overlay_only_skill_metadata).Count -ne 2) { Add-Failure 'CodexExplicitOnlyCount' }
        foreach ($metadata in @($manifest.overlay_only_skill_metadata)) {
            Test-RepoPath (Join-Path $manifest.overlay_root $metadata.relative_path) 'CodexExplicitOnlyMetadata'
        }
    }
}

# Lifecycle evidence remains explicit and current rather than derived from a dated snapshot.
$lifecycleFiles = @(
    'skills/_index.md'
    'docs/SOPs/codex-host-adapter.md'
    'docs/featureArchitecture/host-adaptation-fidelity.md'
    'docs/featureArchitecture/skill-source-and-host-overlays.md'
    'scripts/host-sync/README.md'
    'scripts/host-sync/manifests/codex.manifest.psd1'
)
foreach ($relative in $lifecycleFiles) {
    $path = Join-Path $RepoRoot $relative
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { Add-Failure 'LifecycleEvidenceMissing' $relative; continue }
    $text = Get-Content -Raw -LiteralPath $path
    foreach ($pattern in @('ApplyState','BringUp')) { if ($text -match $pattern) { Add-Failure 'StaleCodexLifecycle' "$relative matches /$pattern/" } }
}
$skillsIndex = Get-Content -Raw -LiteralPath (Join-Path $RepoRoot 'skills/_index.md')
if ($skillsIndex -notmatch [regex]::Escape('Active since 2026-09-08 with C1–C6 smoke attested')) { Add-Failure 'CodexLifecycleStatus' 'skills index missing Active/attested status' }
if ($skillsIndex -notmatch [regex]::Escape('Apply requires fresh explicit owner authorization')) { Add-Failure 'CodexApplyAuthorization' 'skills index missing Apply authorization boundary' }

# Governed handoffs exchange only the validated durable artifact path.
$planArtifactExactTemplates = @(
    'agents/plan_reviewer.md',
    'overlays/antigravity/agents/plan_reviewer.md',
    'overlays/codex/agents/plan_reviewer.toml',
    'overlays/cursor/agents/plan-reviewer.md',
    'overlays/cursor/skills/implementation-plan/SKILL.md',
    'overlays/opencode/agents/plan_reviewer.md',
    'overlays/vscode/agents/plan_reviewer.agent.md',
    'overlays/vscode/agents/planner.agent.md'
)
$planArtifactBoundaryOnlyLeaves = @(
    'rules/local-scratch.md',
    'rules/iterative-plan-review.md',
    'workflow/local-scratch.md',
    'workflow/iterative-plan-review.md',
    'skills/implementation-plan/SKILL.md',
    'skills/plan-review/SKILL.md',
    'overlays/antigravity/workflows/escape-plan.md',
    'overlays/cline/workflows/plan.md',
    'overlays/kilocode/workflows/plan.md',
    'overlays/cursor/rules/agent-invocation.mdc',
    'overlays/cursor/skills/implementation-plan/user-rules-snippet.md',
    'overlays/codex/agents/planner.toml',
    'overlays/codex/instructions/agents-block.md',
    'overlays/opencode/AGENTS.md',
    'overlays/opencode/instructions/cursor-escape-loop.md',
    'overlays/opencode/skills/implementation-plan/SKILL.md',
    'overlays/opencode/skills/plan-review/SKILL.md'
)
foreach ($relative in @($planArtifactBoundaryOnlyLeaves) + @($planArtifactExactTemplates)) {
    $path = Join-Path $RepoRoot $relative
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { Add-Failure 'PlanArtifactHandoffMissing' $relative; continue }
    $text = Get-Content -Raw -LiteralPath $path
    if (-not $text.Contains('.scratch/plans')) { Add-Failure 'PlanArtifactPathBoundary' $relative }
    if ($text.Contains('Plan artifact status') -or $text.Contains('draft returned by planner')) { Add-Failure 'PlanArtifactStatusSubstitute' $relative }
    if ($relative -in $planArtifactExactTemplates -and -not $text.Contains('Plan artifact path')) { Add-Failure 'PlanArtifactPathField' $relative }
}

if ($failures.Count) {
    Write-Host "FAIL: $($failures.Count) invariant(s) failed:" -ForegroundColor Red
    $failures | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}
Write-Host 'PASS: current catalogs, manifests, lifecycle evidence, and governed handoffs passed.' -ForegroundColor Green
exit 0
