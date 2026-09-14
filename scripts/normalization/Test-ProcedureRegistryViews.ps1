#Requires -Version 7.4
<#.SYNOPSIS Verify managed views, canonical consistency, resolver seams, and fail-closed registry edges.#>
param([string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$RenderScript = Join-Path $PSScriptRoot 'Render-ProcedureRegistry.ps1'
Import-Module (Join-Path $PSScriptRoot 'ProcedureRegistry.psm1') -Force
$pass = 0; $failures = 0
function Assert-View([string]$Name,[bool]$Condition,[string]$Detail = '') {
  if ($Condition) { $script:pass++ } else { $script:failures++; Write-Output "FAIL: $Name $Detail" }
}
function Assert-RegistryFailure($Result,[string]$Name,[string]$Invariant) {
  $hit = @($Result.Failures | Where-Object { $_.StartsWith("${Invariant}:", [StringComparison]::Ordinal) }).Count -gt 0
  Assert-View $Name ($Result.Valid -eq $false -and $hit) ($Result.Valid ? 'unexpectedly valid' : (($Result.Failures | Select-Object -First 3) -join '; '))
}
$registry = Test-ProcedureRegistryCatalogs -RepoRoot $RepoRoot
Assert-View 'registry is valid' $registry.Valid (($registry.Failures | Select-Object -First 5) -join '; ')
Assert-View 'all registered skills carry frontmatter description metadata' (@($registry.Catalogs.skills.items | Where-Object { $null -ne $_.PSObject.Properties['description'] }).Count -eq @($registry.Catalogs.skills.items).Count)

$temp = Join-Path ([IO.Path]::GetTempPath()) ("procedure-registry-" + [Guid]::NewGuid().ToString('N'))
try {
  $one = Write-RegistryManagedView -Catalogs $registry.Catalogs -OutputRoot (Join-Path $temp 'one') -RepoRoot $RepoRoot -AllowTemporaryRoot
  $two = Write-RegistryManagedView -Catalogs $registry.Catalogs -OutputRoot (Join-Path $temp 'two') -RepoRoot $RepoRoot -AllowTemporaryRoot
  Assert-View 'double render has four files' ($one.Files.Keys.Count -eq 4 -and $two.Files.Keys.Count -eq 4)
  foreach ($name in @($one.Files.Keys)) {
    $hashA = (Get-FileHash (Join-Path (Join-Path $temp 'one') $name) -Algorithm SHA256).Hash
    $hashB = (Get-FileHash (Join-Path (Join-Path $temp 'two') $name) -Algorithm SHA256).Hash
    Assert-View "deterministic render: $name" ($hashA -eq $hashB) "$hashA != $hashB"
  }
  Assert-View 'parity view covers 49 rows' ((Get-Content (Join-Path (Join-Path $temp 'one') 'agent-parity.tsv')).Count -eq 50)
  $shadowRows = @(Get-Content (Join-Path (Join-Path $temp 'one') 'skill-frontmatter-shadow.tsv'))
  Assert-View 'skill frontmatter shadow view covers 22 rows' ($shadowRows.Count -eq 23) "rows=$($shadowRows.Count)"
  Assert-View 'skill frontmatter shadow reports all matches' (@($shadowRows | Select-Object -Skip 1 | Where-Object { $_ -notmatch "`tmatch`t" }).Count -eq 0) (($shadowRows | Select-Object -Skip 1 | Where-Object { $_ -notmatch "`tmatch`t" }) -join '; ')

  $publicRender = Join-Path $temp 'public-render'
  & $RenderScript -OutputRoot $publicRender -AllowTemporaryRoot | Out-Null
  $publicFiles = @(Get-ChildItem -LiteralPath $publicRender -File)
  Assert-View 'public render integration' ($publicFiles.Count -eq 4) "files=$($publicFiles.Count)"
  $explicitRepoRender = Join-Path $temp 'explicit-repo-render'
  & $RenderScript -RepoRoot $RepoRoot -OutputRoot $explicitRepoRender -AllowTemporaryRoot | Out-Null
  $explicitFiles = @(Get-ChildItem -LiteralPath $explicitRepoRender -File)
  Assert-View 'explicit RepoRoot render integration' ($explicitFiles.Count -eq 4) "files=$($explicitFiles.Count)"
  $rejected = $false
  try { & $RenderScript -OutputRoot $publicRender | Out-Null } catch { $rejected = $true }
  Assert-View 'public render rejects temporary root without ownership switch' $rejected
} catch { $failures++; Write-Output "FAIL: managed view execution: $($_.Exception.Message)" }

try {
  $resolver = New-RegistryProjectionResolver -ResolveHostName { param($n) $n.ToUpperInvariant() } -ResolveReference { param($r) $r }
  Assert-View 'host resolver seam' ((Resolve-RegistryProjection $resolver -Value 'codex' -Seam HostName) -eq 'CODEX')
  $threw = $false; try { $null = Resolve-RegistryProjection (New-RegistryProjectionResolver -ResolveHostName { param($n) '' }) -Value 'Codex' -Seam HostName } catch { $threw = $true }
  Assert-View 'empty resolver result fails closed' $threw
} catch { $failures++; Write-Output "FAIL: resolver execution: $($_.Exception.Message)" }

try {
  $skillsById = @{}
  foreach ($skill in $registry.Catalogs.skills.items) { $skillsById[[string]$skill.id] = $skill }
  foreach ($id in @('architecture-survey','composer','discovery','opencode-headless-run','opencode-history-search')) {
    $skill = $skillsById[$id]
    $raw = Get-Content -Raw -LiteralPath (Join-Path $RepoRoot ([string]$skill.body))
    $canonical = Get-RegistrySkillCanonicalFrontmatter -Raw $raw
    Assert-View "frontmatter builder is byte-exact: $id" ($null -ne $canonical -and ((Get-RegistryComparableFrontmatter $canonical) -ceq (Get-RegistryComparableFrontmatter (Get-RegistrySkillFrontmatter -Skill $skill))))
    $shadow = Get-RegistrySkillFrontmatterShadow -Skill $skill -Raw $raw
    Assert-View "frontmatter shadow matches: $id" ($shadow.Status -eq 'match' -and $shadow.Failures.Count -eq 0) (($shadow.Failures | Select-Object -First 2) -join '; ')
  }
  $folded = Get-RegistrySkillFrontmatter -Skill $skillsById['architecture-survey']
  Assert-View 'frontmatter bytes include delimiters, LF endings, and one terminal LF' ($folded.StartsWith("---`n") -and $folded.EndsWith("---`n") -and -not $folded.Contains("`r"))
  Assert-View 'frontmatter keeps the registry id as canonical name' ($folded.Contains("name: architecture-survey`n"))
  Assert-View 'frontmatter includes disable flag for disabled skills' ($folded.Contains("disable-model-invocation: true`n"))
  $invocable = Get-RegistrySkillFrontmatter -Skill $skillsById['discovery']
  Assert-View 'frontmatter omits disable flag for invocable skills' (-not $invocable.Contains('disable-model-invocation'))
  $plain = Get-RegistrySkillFrontmatter -Skill $skillsById['opencode-headless-run']
  Assert-View 'plain-scalar description renders on one metadata line' (@($plain -split "`n" | Where-Object { $_ -like 'description:*' }).Count -eq 1)
  $builderThrew = $false
  try { $null = Get-RegistrySkillFrontmatter -Skill ([pscustomobject]@{ id = 'broken'; description = [pscustomobject]@{ style = 'plain-scalar'; lines = @('a','b') }; modelInvocationDisabled = $false }) } catch { $builderThrew = $true }
  Assert-View 'frontmatter builder fails closed on malformed description' $builderThrew
} catch { $failures++; Write-Output "FAIL: frontmatter builder execution: $($_.Exception.Message)" }

try {
  Assert-View 'destination count: copy entries' ((Get-StackManifestDestinationCount -Manifest @{ CopyEntries = @(1,2,3) }) -eq 3)
  Assert-View 'destination count: hybrid rules' ((Get-StackManifestDestinationCount -Manifest @{ CopyEntries = @(1,2); HybridRuleIds = @(1,2,3) }) -eq 5)
  Assert-View 'destination count: dual write' ((Get-StackManifestDestinationCount -Manifest @{ CopyEntries = @(1); AgentsDualWrite = @{}; JsonMerge = @{} }) -eq 3)
  Assert-View 'destination count: destination entries' ((Get-StackManifestDestinationCount -Manifest @{ DestinationEntries = @(1,2,3,4) }) -eq 4)
  $halfDualWriteThrew = $false
  try { $null = Get-StackManifestDestinationCount -Manifest @{ CopyEntries = @(1); AgentsDualWrite = @{} } } catch { $halfDualWriteThrew = $true }
  Assert-View 'destination count: half dual-write fails closed' $halfDualWriteThrew
  $unknownShapeThrew = $false
  try { $null = Get-StackManifestDestinationCount -Manifest @{} } catch { $unknownShapeThrew = $true }
  Assert-View 'destination count: unknown manifest shape fails closed' $unknownShapeThrew
} catch { $failures++; Write-Output "FAIL: destination-count helper execution: $($_.Exception.Message)" }

function Get-FreshCatalogs {
  $catalogs = @{}
  foreach ($kind in @('agents','skills','rules','workflows')) { $catalogs[$kind] = Get-Content -Raw (Join-Path $RepoRoot "catalog/$kind.json") | ConvertFrom-Json }
  return $catalogs
}
function Invoke-EdgeCase([string]$Kind,[scriptblock]$Mutate) {
  $catalogs = Get-FreshCatalogs
  & $Mutate $catalogs
  foreach ($name in @('agents','skills','rules','workflows')) { $catalogs[$name].schema = 'catalog/v1'; $catalogs[$name].kind = $name }
  $observed = [System.Collections.Generic.List[string]]::new()
  foreach ($name in @('agents','skills','rules','workflows')) {
    foreach ($failure in (Test-RegistryCatalog -Catalog $catalogs[$name] -Kind $name -RepoRoot $RepoRoot -Inventory $registry.Inventory)) { $observed.Add($failure) }
  }
  return [pscustomobject]@{ Valid = ($observed.Count -eq 0); Failures = $observed }
}
function Invoke-SkillInventoryEdgeCase([scriptblock]$MutateInventory) {
  $inventory = $registry.Inventory | ConvertTo-Json -Depth 100 | ConvertFrom-Json
  & $MutateInventory $inventory
  $catalog = Get-FreshCatalogs
  $catalog.skills.schema = 'catalog/v1'; $catalog.skills.kind = 'skills'
  $observed = @(Test-RegistryCatalog -Catalog $catalog.skills -Kind 'skills' -RepoRoot $RepoRoot -Inventory $inventory)
  return [pscustomobject]@{ Valid = ($observed.Count -eq 0); Failures = $observed }
}
try {
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].id = 'duplicate-id'; $c.agents.items[1].id = 'duplicate-id' }
  Assert-RegistryFailure $result 'duplicate agent ID fails' 'DuplicateId'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].body = 'agents/__missing__.md' }
  Assert-RegistryFailure $result 'missing body fails' 'CanonicalBody'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].body = 'agents/test_reviewer.md' }
  Assert-RegistryFailure $result 'first-read contract mismatch fails' 'FirstReadContract'
  Assert-RegistryFailure $result 'canonical identity mismatch fails' 'CanonicalIdentity'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].authority = 'workspace-write' }
  Assert-RegistryFailure $result 'canonical authority mismatch fails' 'AuthorityContract'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].isolation = 'fresh task/session per pass' }
  Assert-RegistryFailure $result 'canonical isolation mismatch fails' 'IsolationContract'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].requiredReading = @('agents/test_reviewer.md') + @($c.agents.items[0].requiredReading | Select-Object -Skip 1) }
  Assert-RegistryFailure $result 'required reading mismatch fails' 'RequiredReadingContract'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].aliases = @('not-a-canonical-alias') }
  Assert-RegistryFailure $result 'alias contract mismatch fails' 'AliasContract'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].loopGate = 'review-loop' }
  Assert-RegistryFailure $result 'loop/gate mismatch fails' 'LoopGateContract'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].failLoudShape = 'return nothing' }
  Assert-RegistryFailure $result 'fail-loud shape mismatch fails' 'FailLoudContract'
  $result = Invoke-EdgeCase 'agents' { param($c) if ($c.agents.items[1].hostBindings[0].alias) { $c.agents.items[1].hostBindings[0].alias = 'implementer' } else { $c.agents.items[1].hostBindings[0] | Add-Member Alias 'implementer' } }
  Assert-RegistryFailure $result 'alias cannot replace canonical identity' 'AliasReplacesCanonicalIdentity'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].hostBindings[0].evidencePaths = @('analysis/procedure-normalization-inventory-2026-09.json') }
  Assert-RegistryFailure $result 'agent host evidence mismatch fails' 'HostEvidenceContract'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].hostBindings[0].routeIdentity = 'wrong-route' }
  Assert-RegistryFailure $result 'agent route identity mismatch fails' 'HostRouteIdentity'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].hostBindings[0].launchMechanism = 'wrong launch' }
  Assert-RegistryFailure $result 'agent launch mechanism mismatch fails' 'HostLaunchMechanism'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].hostBindings[0].representation = 'generated-native-projection' }
  Assert-RegistryFailure $result 'agent host representation mismatch fails' 'HostRepresentation'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].hostBindings[0].alias = 'wrong-alias' }
  Assert-RegistryFailure $result 'agent host alias mismatch fails' 'HostAlias'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].hostBindings[0].authority = 'workspace-write' }
  Assert-RegistryFailure $result 'agent host authority mismatch fails' 'HostAuthority'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].hostBindings[0].isolation = 'fresh task/session per pass' }
  Assert-RegistryFailure $result 'agent host isolation mismatch fails' 'HostIsolation'
  $result = Invoke-EdgeCase 'agents' { param($c) $c.agents.items[0].hostBindings[0].classification = 'generated output' }
  Assert-RegistryFailure $result 'agent host classification mismatch fails' 'HostClassification'
  $result = Invoke-EdgeCase 'skills' { param($c) $c.skills.items[0].explicitOnly = -not $c.skills.items[0].explicitOnly }
  Assert-RegistryFailure $result 'explicit-only mismatch fails' 'ExplicitOnlyMismatch'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $i.skills_inventory.canonical_skills | Where-Object { [string]$_.id -eq 'architecture-survey' } | ForEach-Object { $_.PSObject.Properties.Remove('explicit_only') } }
  Assert-RegistryFailure $result 'missing inventory explicit_only fails' 'ExplicitOnlyMismatch'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $i.skills_inventory.canonical_skills | Where-Object { [string]$_.id -eq 'architecture-survey' } | ForEach-Object { $_.explicit_only = 'yes' } }
  Assert-RegistryFailure $result 'non-boolean inventory explicit_only fails' 'ExplicitOnlyMismatch'
  $result = Invoke-EdgeCase 'skills' { param($c) $c.skills.items[0].modelInvocationDisabled = -not $c.skills.items[0].modelInvocationDisabled }
  Assert-RegistryFailure $result 'model-invocation-disabled mismatch fails' 'ModelInvocationDisabledMismatch'
  $result = Invoke-EdgeCase 'skills' { param($c) $c.skills.items[0].description.lines[0] = 'mutated registry description line' }
  Assert-RegistryFailure $result 'skill frontmatter shadow mismatch fails' 'SkillFrontmatterShadow'
  $shadowMismatch = @($result.Failures | Where-Object { $_.StartsWith('SkillFrontmatterShadow:', [StringComparison]::Ordinal) })
  Assert-View 'skill frontmatter mismatch names the stable skill id' ($shadowMismatch.Count -gt 0 -and $shadowMismatch[0].Contains('architecture-survey')) (($shadowMismatch | Select-Object -First 1) -join '')
  $result = Invoke-EdgeCase 'skills' { param($c) $c.skills.items[0].PSObject.Properties.Remove('description') }
  Assert-RegistryFailure $result 'missing registry description fails closed' 'SkillDescriptionMissing'
  $result = Invoke-EdgeCase 'skills' { param($c) $c.skills.items[0].description.style = 'plain-scalar' }
  Assert-RegistryFailure $result 'plain-scalar description with folded lines fails' 'SkillDescriptionScalar'
  $result = Invoke-EdgeCase 'skills' { param($c) $c.skills.items[0].description.lines = @(' leading whitespace', 'trailing') }
  Assert-RegistryFailure $result 'description line whitespace fails closed' 'SkillDescriptionLine'
  $result = Invoke-EdgeCase 'skills' { param($c) $c.skills.items[0].hostApplicability[0].status = 'maybe' }
  Assert-RegistryFailure $result 'non-explicit skill behavior fails' 'NonExplicitSkillBehavior'
  $result = Invoke-EdgeCase 'skills' { param($c) $c.skills.items[0].hostApplicability[0].status = 'applicable' }
  Assert-RegistryFailure $result 'skill host applicability mismatch fails' 'SkillHostStatus'
  $result = Invoke-EdgeCase 'skills' { param($c) $c.skills.items[0].hostApplicability[0] | Add-Member Destination 'owned-by-registry' }
  Assert-RegistryFailure $result 'registry-owned skill destination fails' 'DestinationOwnership'
  $result = Invoke-EdgeCase 'rules' { param($c) $c.rules.items[0].body = 'rules/pre-commit-ci-gate.md' }
  Assert-RegistryFailure $result 'rules canonical source mismatch fails' 'CanonicalSourceContract'
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.compositions[0].canonicalReferenceId = '__missing__' }
  Assert-RegistryFailure $result 'invalid composition reference fails' 'InvalidCompositionReference'
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.compositions[0].references = @($c.workflows.compositions[0].references | Select-Object -Skip 1) }
  Assert-RegistryFailure $result 'composition prose reference mismatch fails' 'CompositionInventory'
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.semanticOrder = @($c.workflows.semanticOrder | Select-Object -Skip 1) }
  Assert-RegistryFailure $result 'missing semantic order ID fails' 'SemanticOrderCoverage'
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.semanticOrder[1] = $c.workflows.semanticOrder[0] }
  Assert-RegistryFailure $result 'duplicate semantic order ID fails' 'SemanticOrderDuplicate'
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.compositions = @($c.workflows.compositions | Select-Object -Skip 1) }
  Assert-RegistryFailure $result 'omitted inventory composition fails' 'CompositionInventoryCoverage'

  $destinationCatalog = Get-FreshCatalogs
  $destinationCatalog.skills.items[0].hostApplicability[0] | Add-Member Destination 'owned-by-registry'
  $destinationJson = $destinationCatalog.skills | ConvertTo-Json -Depth 12
  $schemaJson = Get-Content -Raw (Join-Path $RepoRoot 'catalog/schema/v1.json')
  Assert-View 'schema rejects registry-owned destination' (-not (Test-Json -Json $destinationJson -Schema $schemaJson -ErrorAction SilentlyContinue))
  $unknownCatalog = Get-FreshCatalogs
  $unknownCatalog.rules.items[0] | Add-Member IgnoredMetadata 'not-owned'
  $unknownJson = $unknownCatalog.rules | ConvertTo-Json -Depth 12
  Assert-View 'schema rejects ignored generic metadata' (-not (Test-Json -Json $unknownJson -Schema $schemaJson -ErrorAction SilentlyContinue))
  $nonBooleanCatalog = Get-FreshCatalogs
  $nonBooleanCatalog.skills.items[0].explicitOnly = 'yes'
  Assert-View 'schema rejects non-boolean explicitOnly' (-not (Test-Json -Json ($nonBooleanCatalog.skills | ConvertTo-Json -Depth 12) -Schema $schemaJson -ErrorAction SilentlyContinue))
  $nonBooleanCatalog = Get-FreshCatalogs
  $nonBooleanCatalog.skills.items[0].modelInvocationDisabled = 'yes'
  Assert-View 'schema rejects non-boolean modelInvocationDisabled' (-not (Test-Json -Json ($nonBooleanCatalog.skills | ConvertTo-Json -Depth 12) -Schema $schemaJson -ErrorAction SilentlyContinue))
  $missingDescriptionCatalog = Get-FreshCatalogs
  $missingDescriptionCatalog.skills.items[0].PSObject.Properties.Remove('description')
  Assert-View 'schema rejects missing skill description metadata' (-not (Test-Json -Json ($missingDescriptionCatalog.skills | ConvertTo-Json -Depth 12) -Schema $schemaJson -ErrorAction SilentlyContinue))
  $unknownDescriptionCatalog = Get-FreshCatalogs
  $unknownDescriptionCatalog.skills.items[0].description | Add-Member IgnoredMetadata 'not-owned'
  Assert-View 'schema rejects unknown description metadata' (-not (Test-Json -Json ($unknownDescriptionCatalog.skills | ConvertTo-Json -Depth 12) -Schema $schemaJson -ErrorAction SilentlyContinue))
  $plainMultiLineCatalog = Get-FreshCatalogs
  @($plainMultiLineCatalog.skills.items | Where-Object { [string]$_.id -eq 'opencode-headless-run' })[0].description.lines = @('first plain line','second plain line')
  Assert-View 'schema rejects multi-line plain-scalar description' (-not (Test-Json -Json ($plainMultiLineCatalog.skills | ConvertTo-Json -Depth 12) -Schema $schemaJson -ErrorAction SilentlyContinue))
  $emptyLinesCatalog = Get-FreshCatalogs
  $emptyLinesCatalog.skills.items[0].description.lines = @()
  Assert-View 'schema rejects empty description lines' (-not (Test-Json -Json ($emptyLinesCatalog.skills | ConvertTo-Json -Depth 12) -Schema $schemaJson -ErrorAction SilentlyContinue))
  $paddedLineCatalog = Get-FreshCatalogs
  $paddedLineCatalog.skills.items[0].description.lines = @(' leading whitespace') + @($paddedLineCatalog.skills.items[0].description.lines | Select-Object -Skip 1)
  Assert-View 'schema rejects padded description line' (-not (Test-Json -Json ($paddedLineCatalog.skills | ConvertTo-Json -Depth 12) -Schema $schemaJson -ErrorAction SilentlyContinue))

  $original = Get-RegistryManagedView -Catalogs $registry.Catalogs -RepoRoot $RepoRoot
  $originalRows = @([string]$original.Files['composition-order.tsv'] -split "`r?`n" | Where-Object { $_ })
  $reorderedCatalogs = Get-FreshCatalogs
  $order = @($reorderedCatalogs.workflows.semanticOrder)
  $reorderedCatalogs.workflows.semanticOrder = @($order[1],$order[0]) + @($order | Select-Object -Skip 2)
  $reordered = Get-RegistryManagedView -Catalogs $reorderedCatalogs -RepoRoot $RepoRoot
  $reorderedRows = @([string]$reordered.Files['composition-order.tsv'] -split "`r?`n" | Where-Object { $_ })
  Assert-View 'semantic order controls rendered composition rows' (($originalRows.Count -eq $reorderedRows.Count) -and ($originalRows[1] -ne $reorderedRows[1]) -and ($originalRows[2] -ne $reorderedRows[2]))
  $protectedRootThrew = $false
  try { $null = Test-RegistryOutputRoot -OutputRoot (Join-Path $RepoRoot 'docs') -RepoRoot $RepoRoot } catch { $protectedRootThrew = $true }
  Assert-View 'exact protected output root fails closed' $protectedRootThrew
  foreach ($protectedTree in @('skills','overlays')) {
    $canonicalRootThrew = $false
    try { $null = Test-RegistryOutputRoot -OutputRoot (Join-Path $RepoRoot $protectedTree) -RepoRoot $RepoRoot } catch { $canonicalRootThrew = $true }
    Assert-View "canonical/host output root '$protectedTree' fails closed" $canonicalRootThrew
  }
  $temporaryRootExact = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
  $temporaryRootThrew = $false
  try { $null = Test-RegistryOutputRoot -OutputRoot $temporaryRootExact -RepoRoot $RepoRoot -AllowTemporaryRoot } catch { $temporaryRootThrew = $true }
  Assert-View 'exact OS temporary root fails closed' $temporaryRootThrew

  # Phase 3A machinery guard: the shadow slice must not change canonical skill
  # bodies or any host/runtime projection. Phase 3B replaces this guard with
  # managed-frontmatter migration checks when canonical files are regenerated.
  $sliceDrift = @(& git -C $RepoRoot status --porcelain -- skills overlays scripts/host-sync)
  if ($LASTEXITCODE -ne 0) { throw "FAIL: Phase 3A drift status exited $LASTEXITCODE" }
  Assert-View 'Phase 3A leaves canonical skills and host projections unchanged' ($sliceDrift.Count -eq 0) (($sliceDrift | Select-Object -First 5) -join '; ')
} catch { $failures++; Write-Output "FAIL: edge-case execution: $($_.Exception.Message)"; Write-Output $_.ScriptStackTrace }

# Current-state checker contract: an explicit -RepoRoot is honored from any
# working directory, and an absent historical baseline fails closed even under
# the sandbox opt-out (which waives inaccessibility only, never absence).
$checker = Join-Path $PSScriptRoot 'Invoke-CurrentStateFixtureChecks.ps1'
$checkerTemp = Join-Path ([IO.Path]::GetTempPath()) ("current-state-checker-" + [Guid]::NewGuid().ToString('N'))
try {
  New-Item -ItemType Directory -Path $checkerTemp | Out-Null
  Push-Location $checkerTemp
  try {
    & $checker -RepoRoot $RepoRoot -AllowInaccessibleHistoricalBaseline *> $null
    Assert-View 'current-state checker honors explicit RepoRoot from foreign CWD' ($LASTEXITCODE -eq 0) "exit=$LASTEXITCODE"
  } finally { Pop-Location }
  $checkerInventory = Get-Content -Raw (Join-Path $RepoRoot 'analysis/procedure-normalization-inventory-2026-09.json') | ConvertFrom-Json
  $checkerInventory.render_baselines.baseline_directories_historical = @((Join-Path $checkerTemp 'absent-historical-baseline')) + @($checkerInventory.render_baselines.baseline_directories_historical | Select-Object -Skip 1)
  $absentInventoryPath = Join-Path $checkerTemp 'absent-baselines.json'
  $checkerInventory | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $absentInventoryPath
  $absentOptOutOutput = (& $checker -RepoRoot $RepoRoot -InventoryJsonPath $absentInventoryPath -AllowInaccessibleHistoricalBaseline *>&1 | Out-String)
  $absentOptOutExit = $LASTEXITCODE
  Assert-View 'absent historical baseline fails closed under opt-out' ($absentOptOutExit -eq 1 -and $absentOptOutOutput.Contains('HistoricalBaselinePath: absent')) "exit=$absentOptOutExit"
  $absentDefaultOutput = (& $checker -RepoRoot $RepoRoot -InventoryJsonPath $absentInventoryPath *>&1 | Out-String)
  $absentDefaultExit = $LASTEXITCODE
  Assert-View 'absent historical baseline fails closed by default' ($absentDefaultExit -eq 1 -and $absentDefaultOutput.Contains('HistoricalBaselinePath: absent')) "exit=$absentDefaultExit"

  function Invoke-InventoryMutation([scriptblock]$Mutate) {
    $inventory = Get-Content -Raw (Join-Path $RepoRoot 'analysis/procedure-normalization-inventory-2026-09.json') | ConvertFrom-Json
    & $Mutate $inventory
    $path = Join-Path $checkerTemp ("inventory-" + [Guid]::NewGuid().ToString('N') + '.json')
    $inventory | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $path
    $output = (& $checker -RepoRoot $RepoRoot -InventoryJsonPath $path -AllowInaccessibleHistoricalBaseline *>&1 | Out-String)
    return [pscustomobject]@{ Exit = $LASTEXITCODE; Output = $output }
  }
  function Assert-CheckerMutation([string]$Name,[scriptblock]$Mutate,[string[]]$Signatures) {
    $observed = Invoke-InventoryMutation $Mutate
    $missing = @($Signatures | Where-Object { -not $observed.Output.Contains($_) })
    Assert-View $Name ($observed.Exit -eq 1 -and $missing.Count -eq 0) "exit=$($observed.Exit); missing=$($missing -join '; ')"
  }
  Assert-CheckerMutation 'represented pair listed as pending ambiguity fails' {
    param($i)
    $ambiguity = $i.ambiguities_requiring_owner_confirmation | Where-Object { $_.id -eq 'U-Cursor-Bugbot' }
    $ambiguity.pending_missing_pairs = @([pscustomobject]@{ host = 'Cline'; agent = 'planner' })
  } @('AmbiguityPendingPairRepresented: U-Cursor-Bugbot -> Cline|planner')
  Assert-CheckerMutation 'unknown pair listed as pending ambiguity fails' {
    param($i)
    $ambiguity = $i.ambiguities_requiring_owner_confirmation | Where-Object { $_.id -eq 'U-Cursor-Bugbot' }
    $ambiguity.pending_missing_pairs = @([pscustomobject]@{ host = 'Cline'; agent = 'not-a-governed-agent' })
  } @('AmbiguityPendingPairUnknown: U-Cursor-Bugbot -> Cline|not-a-governed-agent')
  # The declared ledger row feeds both row-agreement and manifest-derived count
  # invariants, so the mutation asserts both observed signatures.
  Assert-CheckerMutation 'ledger destination-count mismatch fails' {
    param($i) $i.render_baselines.six_stack_ledger_entries[0].destinationCount = 99
  } @('LedgerDestinationCount: Cursor manifest-derived=19 ledger=99', 'LedgerRowAgreement: row 0')
  Assert-CheckerMutation 'missing last_updated date fails' {
    param($i) $i.PSObject.Properties.Remove('last_updated')
  } @("InventoryLastUpdatedFormat: invalid ISO calendar date ''")
  Assert-CheckerMutation 'snapshot date drift fails' {
    param($i) $i.inventory_date = '2026-09-12'
  } @("InventorySnapshotDate: expected '2026-09-11', got '2026-09-12'")

  # Markdown drift uses a temporary fixture through the -InventoryMdPath seam;
  # repository evidence is never mutated.
  $markdownOriginal = Get-Content -Raw (Join-Path $RepoRoot 'analysis/procedure-normalization-inventory-2026-09.md')
  $markdownTrimmedPath = Join-Path $checkerTemp 'trimmed-ambiguities.md'
  ($markdownOriginal -replace '\| U-Render-Baseline-Reconciliation \|[^\r\n]+', '') | Set-Content -LiteralPath $markdownTrimmedPath
  $markdownTrimmedOutput = (& $checker -RepoRoot $RepoRoot -InventoryMdPath $markdownTrimmedPath -AllowInaccessibleHistoricalBaseline *>&1 | Out-String)
  Assert-View 'markdown ambiguity row removal fails' ($LASTEXITCODE -eq 1 -and $markdownTrimmedOutput.Contains('MarkdownAmbiguityCount: expected 4, got 3')) "exit=$LASTEXITCODE"
  $markdownRenamedPath = Join-Path $checkerTemp 'renamed-ambiguity.md'
  ($markdownOriginal -replace '\| U-Cursor-Bugbot \|', '| U-Renamed-Bugbot |') | Set-Content -LiteralPath $markdownRenamedPath
  $markdownRenamedOutput = (& $checker -RepoRoot $RepoRoot -InventoryMdPath $markdownRenamedPath -AllowInaccessibleHistoricalBaseline *>&1 | Out-String)
  Assert-View 'markdown ambiguity id drift fails' ($LASTEXITCODE -eq 1 -and $markdownRenamedOutput.Contains("MarkdownAmbiguityId: row 0 expected 'U-Cursor-Bugbot', got 'U-Renamed-Bugbot'")) "exit=$LASTEXITCODE"
  $markdownNoUpdatePath = Join-Path $checkerTemp 'stale-dates.md'
  ($markdownOriginal -replace ' · \*\*Last updated:\*\* 2026-09-14', '') | Set-Content -LiteralPath $markdownNoUpdatePath
  $markdownNoUpdateOutput = (& $checker -RepoRoot $RepoRoot -InventoryMdPath $markdownNoUpdatePath -AllowInaccessibleHistoricalBaseline *>&1 | Out-String)
  Assert-View 'markdown last-updated drift fails' ($LASTEXITCODE -eq 1 -and $markdownNoUpdateOutput.Contains('MarkdownInventoryLastUpdated')) "exit=$LASTEXITCODE"
} catch { $failures++; Write-Output "FAIL: current-state checker execution: $($_.Exception.Message)" }
finally { if (Test-Path -LiteralPath $checkerTemp) { Remove-Item -LiteralPath $checkerTemp -Recurse -Force -ErrorAction SilentlyContinue } }

if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue }
Write-Output ('registry view checks: {0} passed, {1} failed' -f $pass,$failures)
exit $(if ($failures -gt 0) { 1 } else { 0 })
