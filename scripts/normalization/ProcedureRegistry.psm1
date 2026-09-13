#Requires -Version 7.4
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$script:Hosts = @('Cursor','OpenCode','Antigravity','Vscode','Cline','Kilocode','Codex')
$script:ExpectedKinds = @{ agents = 'agents.json'; skills = 'skills.json'; rules = 'rules.json'; workflows = 'workflows.json' }
$script:CanonicalAgentContractCache = @{}

function Add-RegistryFailure([System.Collections.Generic.List[string]]$Failures,[string]$Invariant,[string]$Detail) {
  $Failures.Add("${Invariant}: $Detail")
}

function Get-RegistrySequence([object]$Value) {
  $values = [System.Collections.Generic.List[string]]::new()
  if ($null -ne $Value) { foreach ($value in @($Value)) { if ($null -ne $value) { $values.Add([string]$value) } } }
  return $values
}

function Test-RegistrySequence([object]$Left,[object]$Right) {
  $leftValues = @(Get-RegistrySequence $Left)
  $rightValues = @(Get-RegistrySequence $Right)
  if ($leftValues.Count -ne $rightValues.Count) { return $false }
  for ($index = 0; $index -lt $leftValues.Count; $index++) {
    if ($leftValues[$index] -cne $rightValues[$index]) { return $false }
  }
  return $true
}

function Get-MarkdownTableRow([string[]]$Lines,[string]$Heading,[string]$Id,[int]$ExpectedCells) {
  $section = $false
  foreach ($line in $Lines) {
    if ($line -eq $Heading) { $section = $true; continue }
    if ($section -and $line -match '^## ') { break }
    if (-not $section -or -not $line.StartsWith('|')) { continue }
    $cells = @($line.Trim().Trim('|') -split '\|' | ForEach-Object { $_.Trim().Replace('`','') })
    if ($cells.Count -eq $ExpectedCells -and $cells[0] -ceq $Id) { return $cells }
  }
  return $null
}

function Get-StackManifestDestinationCount {
  <#
    Shared fail-closed rule for the expected render-destination count of one
    parsed host stack manifest. Used by the current-state checker and the
    six-stack render ledger so the count is expressed exactly once:
    CopyEntries (+ HybridRuleIds for Cursor) (+ the two dual-write
    AGENTS/opencode.json destinations for OpenCode), or the generic
    DestinationEntries model.
  #>
  param([Parameter(Mandatory)]$Manifest)
  if ($null -eq $Manifest -or $Manifest -isnot [System.Collections.IDictionary]) { throw 'FAIL: stack manifest must be a parsed hashtable' }
  $hasCopy = $Manifest.Contains('CopyEntries')
  $hasDestinations = $Manifest.Contains('DestinationEntries')
  if ($hasCopy -and $hasDestinations) { throw 'FAIL: stack manifest defines both CopyEntries and DestinationEntries' }
  if ($hasDestinations) {
    foreach ($extra in @('HybridRuleIds','AgentsDualWrite','JsonMerge')) { if ($Manifest.Contains($extra)) { throw "FAIL: DestinationEntries manifest also defines $extra" } }
    return @($Manifest['DestinationEntries']).Count
  }
  if (-not $hasCopy) { throw 'FAIL: stack manifest defines neither CopyEntries nor DestinationEntries' }
  $count = @($Manifest['CopyEntries']).Count
  if ($Manifest.Contains('HybridRuleIds')) { $count += @($Manifest['HybridRuleIds']).Count }
  $hasDualWrite = $Manifest.Contains('AgentsDualWrite')
  $hasJsonMerge = $Manifest.Contains('JsonMerge')
  if ($hasDualWrite -ne $hasJsonMerge) { throw 'FAIL: dual-write stacks must define both AgentsDualWrite and JsonMerge' }
  if ($hasDualWrite) { $count += 2 }
  return $count
}

function Get-CanonicalAgentContracts([string]$RepoRoot,$Inventory) {
  $workflowPath = Join-Path $RepoRoot 'workflow/agent-invocation.md'
  if (-not (Test-Path -LiteralPath $workflowPath -PathType Leaf)) { throw "FAIL: canonical invocation contract missing: workflow/agent-invocation.md" }
  $workflowLines = @(Get-Content -LiteralPath $workflowPath)
  $contracts = @{}
  foreach ($id in @($Inventory.governed_agents)) {
    $rows = @($Inventory.parity_matrix | Where-Object { [string]$_.agent -eq [string]$id })
    if ($rows.Count -ne 7) { throw "FAIL: CanonicalInventory: agent '$id' has $($rows.Count) parity rows" }
    $firstReads = @($rows | ForEach-Object { [string]$_.first_read_contract } | Select-Object -Unique)
    if ($firstReads.Count -ne 1) { throw "FAIL: CanonicalInventory: agent '$id' has ambiguous first-read contracts" }
    $required = $Inventory.canonical_required_reading.PSObject.Properties[$id]
    if ($null -eq $required) { throw "FAIL: CanonicalInventory: agent '$id' has no required reading" }
    $role = Get-MarkdownTableRow $workflowLines '## Role map' $id 5
    $failure = Get-MarkdownTableRow $workflowLines '## Malformed invocation' $id 2
    if ($null -eq $role -or $null -eq $failure) { throw "FAIL: CanonicalContract: agent '$id' is absent from canonical invocation tables" }
    $authorities = @($rows | ForEach-Object { [string]$_.authority } | Where-Object { $_ } | ForEach-Object { $_ -replace '\s*\(sandbox_mode\)$','' } | Select-Object -Unique)
    $canonicalIsolation = @($rows | ForEach-Object { [string]$_.isolation } | Where-Object { $_ } | ForEach-Object { if ($_ -eq 'fresh task/session per pass') { 'clean-context' } else { $_ } } | Select-Object -Unique)
    if ($authorities.Count -ne 1 -or $canonicalIsolation.Count -ne 1) { throw "FAIL: CanonicalInventory: agent '$id' has ambiguous policy evidence" }
    $aliases = if ($role[3] -eq 'none') { @() } else { @($role[3] -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ }) }
    $contracts[[string]$id] = [pscustomobject]@{
      FirstRead = $firstReads[0]
      RequiredReading = Get-RegistrySequence $required.Value
      Aliases = $aliases
      Authority = $authorities[0]
      Isolation = $canonicalIsolation[0]
      LoopGate = [string]$role[4]
      FailLoudShape = [string]$failure[1]
    }
  }
  return $contracts
}

function Test-RegistryDescendantPath([string]$RepoRoot,[string]$Relative,[System.Collections.Generic.List[string]]$Failures,[string]$Invariant,[switch]$Leaf) {
  if ([string]::IsNullOrWhiteSpace($Relative)) { Add-RegistryFailure $Failures $Invariant 'empty registry path'; return $null }
  try { $full = [IO.Path]::GetFullPath((Join-Path $RepoRoot $Relative)) } catch { Add-RegistryFailure $Failures $Invariant "invalid path '$Relative'"; return $null }
  $root = [IO.Path]::GetFullPath($RepoRoot).TrimEnd('\','/') + '\'
  if (-not $full.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)) { Add-RegistryFailure $Failures $Invariant "path escapes repository '$Relative'"; return $null }
  if (-not (Test-Path -LiteralPath $full)) { Add-RegistryFailure $Failures $Invariant "unresolvable path '$Relative'"; return $null }
  if ($Leaf -and -not (Test-Path -LiteralPath $full -PathType Leaf)) { Add-RegistryFailure $Failures $Invariant "expected leaf '$Relative'"; return $null }
  return $full
}

function Test-RegistryCatalog {
  param([Parameter(Mandatory)]$Catalog,[Parameter(Mandatory)][ValidateSet('agents','rules','skills','workflows')][string]$Kind,[Parameter(Mandatory)][string]$RepoRoot,$OverlayRoots = @{},$Inventory = $null)
  $failures = [System.Collections.Generic.List[string]]::new()
  $items = @($Catalog.items); $ids = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  $allIds = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  foreach ($item in $items) { if (-not $allIds.Add([string]$item.id)) { Add-RegistryFailure $failures 'DuplicateId' "$Kind/$($item.id)" } }
  $aliasOwners = [System.Collections.Generic.Dictionary[string,string]]::new([StringComparer]::Ordinal)
  foreach ($item in $items) {
    $id = [string]$item.id
    if (-not $ids.Add($id)) { Add-RegistryFailure $failures 'DuplicateId' "$Kind/$id"; continue }
    $body = Test-RegistryDescendantPath $RepoRoot ([string]$item.body) $failures "CanonicalBody:$id" -Leaf
    if ($null -eq $body) { continue }
    if ($body -and (Get-Content -LiteralPath $body -Raw).Contains('BEGIN MANAGED VIEW')) { Add-RegistryFailure $failures 'ManagedViewOwnership' "$id canonical body contains generated view" }
    if ($Kind -eq 'agents') {
      if ($null -eq $Inventory) { throw 'FAIL: agent canonical consistency requires the Phase 0 inventory' }
      if (-not $script:CanonicalAgentContractCache.ContainsKey($RepoRoot)) { $script:CanonicalAgentContractCache[$RepoRoot] = Get-CanonicalAgentContracts -RepoRoot $RepoRoot -Inventory $Inventory }
      $contract = $script:CanonicalAgentContractCache[$RepoRoot][$id]
      if ($null -eq $contract) { Add-RegistryFailure $failures 'CanonicalAgentContract' "$id has no canonical contract"; continue }
      $rawAgentBody = Get-Content -LiteralPath $body -Raw
      if ($rawAgentBody -notmatch "You are (?:\*\*)?the $([regex]::Escape($id)) agent") { Add-RegistryFailure $failures 'CanonicalIdentity' "$id body does not declare its canonical envelope identity" }
      if ([string]$item.body -cne $contract.FirstRead) { Add-RegistryFailure $failures 'FirstReadContract' "$id registry='$($item.body)' canonical='$($contract.FirstRead)'" }
      if ([string]$item.authority -notin @('read-only','workspace-write')) { Add-RegistryFailure $failures 'InvalidAuthority' "$id canonical" }
      if ([string]$item.authority -cne $contract.Authority) { Add-RegistryFailure $failures 'AuthorityContract' "$id registry='$($item.authority)' canonical='$($contract.Authority)'" }
      if ([string]$item.isolation -ne 'clean-context') { Add-RegistryFailure $failures 'InvalidIsolation' "$id canonical" }
      if ([string]$item.isolation -cne $contract.Isolation) { Add-RegistryFailure $failures 'IsolationContract' "$id registry='$($item.isolation)' canonical='$($contract.Isolation)'" }
      $actualReading = @(Get-RegistrySequence $item.requiredReading)
      foreach ($reading in $actualReading) { $null = Test-RegistryDescendantPath $RepoRoot $reading $failures "RequiredReading:$id" -Leaf }
      if (-not (Test-RegistrySequence $actualReading $contract.RequiredReading)) { Add-RegistryFailure $failures 'RequiredReadingContract' "$id registry='$($actualReading -join '|')' canonical='$($contract.RequiredReading -join '|')'" }
      $actualAliases = @(Get-RegistrySequence $item.aliases)
      if (-not (Test-RegistrySequence $actualAliases $contract.Aliases)) { Add-RegistryFailure $failures 'AliasContract' "$id registry='$($actualAliases -join '|')' canonical='$($contract.Aliases -join '|')'" }
      if ([string]$item.loopGate -cne $contract.LoopGate) { Add-RegistryFailure $failures 'LoopGateContract' "$id registry='$($item.loopGate)' canonical='$($contract.LoopGate)'" }
      if ([string]$item.failLoudShape -cne $contract.FailLoudShape) { Add-RegistryFailure $failures 'FailLoudContract' "$id registry='$($item.failLoudShape)' canonical='$($contract.FailLoudShape)'" }
      if (@($item.hostBindings).Count -ne 7) { Add-RegistryFailure $failures 'AgentHostCoverage' "$id has $(@($item.hostBindings).Count) bindings" }
      $seen = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
      foreach ($binding in @($item.hostBindings)) {
        $hostName = [string]$binding.host
        if ($hostName -notin $script:Hosts) { Add-RegistryFailure $failures 'InvalidHost' "$id/$hostName"; continue }
        if (-not $seen.Add($hostName)) { Add-RegistryFailure $failures 'DuplicateHostBinding' "$id/$hostName" }
        if ([string]$binding.representation -notin @('native-definition','generated-native-projection','fallback-launch-contract','missing')) { Add-RegistryFailure $failures 'InvalidRepresentation' "$id/$hostName/$($binding.representation)" }
        $boundAuthority = if ($binding.PSObject.Properties['authority']) { $binding.authority } else { $null }
        $boundIsolation = if ($binding.PSObject.Properties['isolation']) { $binding.isolation } else { $null }
        $parityRow = @($Inventory.parity_matrix | Where-Object { [string]$_.agent -eq $id -and [string]$_.host -eq $hostName })
        if ($parityRow.Count -ne 1) { Add-RegistryFailure $failures 'HostBindingInventory' "$id/$hostName has $($parityRow.Count) parity rows"; continue }
        $parityRow = $parityRow[0]
        if ([string]$binding.representation -cne [string]$parityRow.representation) { Add-RegistryFailure $failures 'HostRepresentation' "$id/$hostName registry='$($binding.representation)' inventory='$($parityRow.representation)'" }
        if ([string]$binding.alias -cne [string]$parityRow.alias) { Add-RegistryFailure $failures 'HostAlias' "$id/$hostName registry='$($binding.alias)' inventory='$($parityRow.alias)'" }
        if ([string]$binding.routeIdentity -cne [string]$parityRow.route_identity) { Add-RegistryFailure $failures 'HostRouteIdentity' "$id/$hostName registry='$($binding.routeIdentity)' inventory='$($parityRow.route_identity)'" }
        if ([string]$binding.launchMechanism -cne [string]$parityRow.launch_mechanism) { Add-RegistryFailure $failures 'HostLaunchMechanism' "$id/$hostName registry='$($binding.launchMechanism)' inventory='$($parityRow.launch_mechanism)'" }
        if ([string]$boundAuthority -cne [string]$parityRow.authority) { Add-RegistryFailure $failures 'HostAuthority' "$id/$hostName registry='$boundAuthority' inventory='$($parityRow.authority)'" }
        if ([string]$boundIsolation -cne [string]$parityRow.isolation) { Add-RegistryFailure $failures 'HostIsolation' "$id/$hostName registry='$boundIsolation' inventory='$($parityRow.isolation)'" }
        if ([string]$binding.classification -cne [string]$parityRow.classification) { Add-RegistryFailure $failures 'HostClassification' "$id/$hostName registry='$($binding.classification)' inventory='$($parityRow.classification)'" }
        if (-not (Test-RegistrySequence $binding.evidencePaths $parityRow.evidence_paths)) { Add-RegistryFailure $failures 'HostEvidenceContract' "$id/$hostName registry and Phase 0 evidence differ" }
        if ($null -ne $boundAuthority -and [string]$boundAuthority -notin @('read-only','workspace-write','read-only (sandbox_mode)','workspace-write (sandbox_mode)')) { Add-RegistryFailure $failures 'InvalidAuthority' "$id/$hostName" }
        if ($null -ne $boundIsolation -and [string]$boundIsolation -notin @('clean-context','fresh task/session per pass')) { Add-RegistryFailure $failures 'InvalidIsolation' "$id/$hostName" }
        foreach ($evidence in @($binding.evidencePaths)) { $null = Test-RegistryDescendantPath $RepoRoot ([string]$evidence) $failures "HostEvidence:$id/$hostName" }
        if ($binding.PSObject.Properties['routeIdentity'] -and $binding.routeIdentity -and [string]$binding.routeIdentity -ne $id -and $allIds.Contains([string]$binding.routeIdentity)) {
          Add-RegistryFailure $failures 'AliasReplacesCanonicalIdentity' "$id/$hostName routeIdentity -> $($binding.routeIdentity)"
        }
        foreach ($name in @('alias')) { if ($binding.PSObject.Properties[$name] -and $binding.$name) {
          $value = [string]$binding.$name
          $owner = $null
          if ($value -ne $id -and $allIds.Contains($value)) { Add-RegistryFailure $failures 'AliasReplacesCanonicalIdentity' "$id/$hostName -> $value" }
          if ($aliasOwners.TryGetValue($value, [ref]$owner)) { Add-RegistryFailure $failures 'DuplicateAlias' "$value owned by $owner and $id" } else { $aliasOwners[$value] = $id }
        } }
      }
    } elseif ($Kind -eq 'skills') {
      if ($null -eq $Inventory) { throw 'FAIL: skill canonical consistency requires the Phase 0 inventory' }
      $raw = Get-Content -LiteralPath $body -Raw
      if ($raw -notmatch "(?m)^name:\s*$([regex]::Escape($id))\s*$") { Add-RegistryFailure $failures 'CanonicalIdentity' "$id skill frontmatter name" }
      $inventorySkill = @($Inventory.skills_inventory.canonical_skills | Where-Object { [string]$_.id -eq $id })
      if ($inventorySkill.Count -ne 1) { Add-RegistryFailure $failures 'SkillInventory' "$id has $($inventorySkill.Count) inventory rows"; continue }
      $declaredDisabled = $raw -match '(?mi)^disable-model-invocation:\s*true\s*$'
      if ($item.modelInvocationDisabled -isnot [bool] -or $item.modelInvocationDisabled -ne $declaredDisabled) { Add-RegistryFailure $failures 'ModelInvocationDisabledMismatch' "$id registry=$($item.modelInvocationDisabled) markdown=$declaredDisabled" }
      $inventoryExplicitOnlyProp = $inventorySkill[0].PSObject.Properties['explicit_only']
      $inventoryExplicitOnly = if ($null -ne $inventoryExplicitOnlyProp) { $inventoryExplicitOnlyProp.Value } else { $null }
      $inventoryExplicitOnlyText = if ($null -eq $inventoryExplicitOnly) { '<missing>' } else { $inventoryExplicitOnly }
      if ($item.explicitOnly -isnot [bool] -or $inventoryExplicitOnly -isnot [bool] -or $item.explicitOnly -ne $inventoryExplicitOnly) { Add-RegistryFailure $failures 'ExplicitOnlyMismatch' "$id registry=$($item.explicitOnly) inventory=$inventoryExplicitOnlyText" }
      if (@($item.hostApplicability).Count -ne 7) { Add-RegistryFailure $failures 'SkillHostCoverage' "$id has $(@($item.hostApplicability).Count) bindings" }
      $seen = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
      foreach ($binding in @($item.hostApplicability)) {
        $hostName = [string]$binding.host
        if ($hostName -notin $script:Hosts) { Add-RegistryFailure $failures 'InvalidHost' "$id/$hostName"; continue }
        if (-not $seen.Add($hostName)) { Add-RegistryFailure $failures 'DuplicateHostBinding' "$id/$hostName" }
        if ([string]$binding.status -notin @('applicable','not-applicable')) { Add-RegistryFailure $failures 'NonExplicitSkillBehavior' "$id/$hostName/$($binding.status)" }
        if ([string]$item.body -cne [string]$inventorySkill[0].source) { Add-RegistryFailure $failures 'SkillCanonicalSource' "$id registry='$($item.body)' inventory='$($inventorySkill[0].source)'" }
        $inventoryBinding = @($inventorySkill[0].host_applicability | Where-Object { [string]$_.host -eq $hostName })
        if ($inventoryBinding.Count -ne 1) { Add-RegistryFailure $failures 'SkillHostInventory' "$id/$hostName has $($inventoryBinding.Count) inventory rows"; continue }
        if ([string]$binding.status -cne [string]$inventoryBinding[0].status) { Add-RegistryFailure $failures 'SkillHostStatus' "$id/$hostName registry='$($binding.status)' inventory='$($inventoryBinding[0].status)'" }
        if (-not (Test-RegistrySequence $binding.evidencePaths $inventoryBinding[0].evidence_paths)) { Add-RegistryFailure $failures 'SkillHostEvidence' "$id/$hostName registry and Phase 0 evidence differ" }
        foreach ($evidence in @($binding.evidencePaths)) { $null = Test-RegistryDescendantPath $RepoRoot ([string]$evidence) $failures "HostEvidence:$id/$hostName" }
        if ($binding.PSObject.Properties['destination']) { Add-RegistryFailure $failures 'DestinationOwnership' "$id/$hostName registry cannot own manifest destination metadata" }
      }
    } else {
      $first = Get-Content -LiteralPath $body -TotalCount 1
      if ($first -notmatch '^#\s+') { Add-RegistryFailure $failures 'CanonicalBodyHeading' "$id starts '$first'" }
      if ($null -eq $Inventory) { throw 'FAIL: rules/workflow consistency requires the Phase 0 inventory' }
      $inventoryName = if ($Kind -eq 'rules') { 'canonical_rules' } else { 'canonical_workflows' }
      $inventoryItems = @($Inventory.rules_workflows.PSObject.Properties[$inventoryName].Value | Where-Object { [string]$_.id -eq $id })
      if ($inventoryItems.Count -ne 1) { Add-RegistryFailure $failures 'RulesWorkflowInventory' "$Kind/$id has $($inventoryItems.Count) inventory rows"; continue }
      if ([string]$item.body -cne [string]$inventoryItems[0].source) { Add-RegistryFailure $failures 'CanonicalSourceContract' "$Kind/$id registry='$($item.body)' inventory='$($inventoryItems[0].source)'" }
    }
  }
  if ($Kind -eq 'workflows') {
    $comps = @($Catalog.compositions)
    $rulesCatalog = Get-Content -Raw -LiteralPath (Join-Path $RepoRoot 'catalog/rules.json') | ConvertFrom-Json
    $knownIds = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($item in $items) { $null = $knownIds.Add([string]$item.id) }
    foreach ($item in @($rulesCatalog.items)) { $null = $knownIds.Add([string]$item.id) }
    $compIds = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $consumedInventoryCompositions = [System.Collections.Generic.HashSet[int]]::new()
    foreach ($composition in $comps) {
      $cid = [string]$composition.id
      if (-not $compIds.Add($cid)) { Add-RegistryFailure $failures 'DuplicateCompositionId' $cid }
      if ([string]$composition.host -notin $script:Hosts) { Add-RegistryFailure $failures 'InvalidHost' "$cid/$($composition.host)" }
      if (-not $knownIds.Contains([string]$composition.canonicalReferenceId)) { Add-RegistryFailure $failures 'InvalidCompositionReference' "$cid canonical '$($composition.canonicalReferenceId)'" }
      if ($null -eq $Inventory) { throw 'FAIL: composition consistency requires the Phase 0 inventory' }
      $registryReferences = @(Get-RegistrySequence $composition.references)
      $matchedIndex = -1
      for ($index = 0; $index -lt @($Inventory.rules_workflows.compositions).Count; $index++) {
        if ($consumedInventoryCompositions.Contains($index)) { continue }
        $inventoryComposition = $Inventory.rules_workflows.compositions[$index]
        if ([string]$inventoryComposition.host -eq [string]$composition.host -and
            [string]$inventoryComposition.canonical_source -eq "base:rules/$([string]$composition.canonicalReferenceId).md" -and
            (Test-RegistrySequence $inventoryComposition.composition_order $registryReferences)) {
          $matchedIndex = $index; break
        }
      }
      if ($matchedIndex -lt 0) { Add-RegistryFailure $failures 'CompositionInventory' "$cid has no unused matching Phase 0 composition"; continue }
      $null = $consumedInventoryCompositions.Add($matchedIndex)
      $refs = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
      foreach ($reference in @($composition.references)) {
        $ref = [string]$reference
        if (-not $refs.Add($ref)) { Add-RegistryFailure $failures 'DuplicateSemanticPart' "$cid/$ref" }
        if ($ref.StartsWith('base:', [StringComparison]::Ordinal)) { $path = $ref.Substring(5) }
        else {
          $path = $ref -replace '^shared:',''
          $roots = if ($OverlayRoots.ContainsKey($composition.host)) { $OverlayRoots[$composition.host] } else { @{} }
          if ($ref.StartsWith('shared:',[StringComparison]::Ordinal)) { $sharedRoot = if ($roots.ContainsKey('Shared') -and $null -ne $roots.Shared) { $roots.Shared } else { $roots['Overlay'] }; $path = "$sharedRoot/$path" }
          elseif ($path.StartsWith('instructions/',[StringComparison]::Ordinal) -or $path.StartsWith('footers/',[StringComparison]::Ordinal)) { $path = "$($roots['Overlay'])/$path" }
        }
        $null = Test-RegistryDescendantPath $RepoRoot $path $failures "SemanticReference:$cid" -Leaf
      }
    }
    $order = @(Get-RegistrySequence $Catalog.semanticOrder)
    if ($order.Count -ne $comps.Count) { Add-RegistryFailure $failures 'SemanticOrderCoverage' "expected $($comps.Count), got $($order.Count)" }
    $duplicates = @($order | Group-Object | Where-Object Count -gt 1)
    foreach ($duplicate in $duplicates) { Add-RegistryFailure $failures 'SemanticOrderDuplicate' $duplicate.Name }
    $compositionIdSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($composition in $comps) { $null = $compositionIdSet.Add([string]$composition.id) }
    foreach ($compositionId in $order) { if (-not $compositionIdSet.Remove($compositionId)) { Add-RegistryFailure $failures 'SemanticOrderUnknownId' $compositionId } }
    foreach ($remaining in $compositionIdSet) { Add-RegistryFailure $failures 'SemanticOrderMissingId' $remaining }
    foreach ($index in @(0..(@($Inventory.rules_workflows.compositions).Count - 1))) {
      if (-not $consumedInventoryCompositions.Contains($index)) { Add-RegistryFailure $failures 'CompositionInventoryCoverage' "Phase 0 composition index $index is absent from registry" }
    }
  }
  return $failures
}

function Test-ProcedureRegistryCatalogs {
  param([string]$RepoRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)))
  $failures = [System.Collections.Generic.List[string]]::new()
  $catalogs = @{}
  $schemaPath = Join-Path $RepoRoot 'catalog/schema/v1.json'
  if (-not (Test-Path -LiteralPath $schemaPath -PathType Leaf)) { throw "FAIL: missing schema $schemaPath" }
  $schema = Get-Content -Raw -LiteralPath $schemaPath
  $inventoryPath = Join-Path $RepoRoot 'analysis/procedure-normalization-inventory-2026-09.json'
  try { $inventory = Get-Content -Raw -LiteralPath $inventoryPath | ConvertFrom-Json } catch { throw "FAIL: invalid inventory: $($_.Exception.Message)" }
  $overlayRoots = @{}; foreach ($manifest in @($inventory.manifests)) { $overlayRoots[$manifest.host] = @{ Overlay = $manifest.overlay_root; Shared = $manifest.shared_root } }
  foreach ($kind in $script:ExpectedKinds.Keys) {
    $path = Join-Path (Join-Path $RepoRoot 'catalog') $script:ExpectedKinds[$kind]
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "FAIL: missing catalog $path" }
    try { $raw = Get-Content -Raw -LiteralPath $path; $catalog = $raw | ConvertFrom-Json } catch { throw "FAIL: invalid JSON $($script:ExpectedKinds[$kind]): $($_.Exception.Message)" }
    if (-not (Test-Json -Json $raw -Schema $schema -ErrorAction SilentlyContinue)) { Add-RegistryFailure $failures 'SchemaValidation' $script:ExpectedKinds[$kind] }
    if ($catalog.schema -ne 'catalog/v1' -or $catalog.kind -ne $kind) { Add-RegistryFailure $failures 'SchemaVersionOrKindMismatch' "$($script:ExpectedKinds[$kind]) schema=$($catalog.schema) kind=$($catalog.kind)" }
    $catalogs[$kind] = $catalog
    foreach ($failure in (Test-RegistryCatalog -Catalog $catalog -Kind $kind -RepoRoot $RepoRoot -OverlayRoots $overlayRoots -Inventory $inventory)) { $failures.Add($failure) }
  }
  $pairs = @{ agents = 'governed_agents'; rules = 'canonical_rules'; skills = 'canonical_skills'; workflows = 'canonical_workflows' }
  foreach ($kind in $pairs.Keys) {
    $source = switch ($kind) { 'agents' { $inventory.governed_agents } 'skills' { $inventory.skills_inventory.canonical_skills } default { $inventory.rules_workflows | Select-Object -ExpandProperty $pairs[$kind] } }
    $expectedIds = if ($kind -eq 'agents') { $source } else { $source | ForEach-Object id }
    $expected = @($expectedIds | Sort-Object) -join '|'
    $actual = @($catalogs[$kind].items | ForEach-Object id | Sort-Object) -join '|'
    if ($expected -ne $actual) { Add-RegistryFailure $failures 'InventoryCoverageMismatch' "$kind expected '$expected' actual '$actual'" }
  }
  $knownIds = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  foreach ($kind in @('agents','skills','rules','workflows')) { foreach ($item in @($catalogs[$kind].items)) { $null = $knownIds.Add([string]$item.id) } }
  foreach ($composition in @($catalogs.workflows.compositions)) { if (-not $knownIds.Contains([string]$composition.canonicalReferenceId)) { Add-RegistryFailure $failures 'InvalidCompositionReference' "$($composition.id) canonical '$($composition.canonicalReferenceId)'" } }
  return [pscustomobject]@{ Valid = ($failures.Count -eq 0); Failures = $failures; Catalogs = $catalogs; Inventory = $inventory }
}

function New-RegistryProjectionResolver {
  param([scriptblock]$ResolveHostName,[scriptblock]$ResolveReference)
  [pscustomobject]@{
    ResolveHostName = if ($ResolveHostName) { $ResolveHostName } else { { param($Name) $Name } }
    ResolveReference = if ($ResolveReference) { $ResolveReference } else { { param($Reference) $Reference } }
  }
}

function Resolve-RegistryProjection {
  param([Parameter(Mandatory)]$Resolver,[Parameter(Mandatory)][string]$Value,[ValidateSet('HostName','Reference')][string]$Seam)
  $delegate = if ($Seam -eq 'HostName') { $Resolver.ResolveHostName } else { $Resolver.ResolveReference }
  if ($null -eq $delegate) { throw "FAIL: null $Seam projection resolver seam" }
  $result = & $delegate $Value
  if ([string]::IsNullOrWhiteSpace([string]$result)) { throw "FAIL: $Seam resolver seam returned empty for '$Value'" }
  return [string]$result
}

function Get-RegistryManagedView {
  param([Parameter(Mandatory)]$Catalogs,[Parameter(Mandatory)][string]$RepoRoot,$Resolver = (New-RegistryProjectionResolver))
  $identity = [ordered]@{ schema = 'managed-view/v1'; generatedFrom = 'catalog/v1'; hosts = @($script:Hosts); counts = [ordered]@{} }
  foreach ($kind in @('agents','skills','rules','workflows')) { $identity.counts[$kind] = @($Catalogs[$kind].items).Count }
  $identityJson = $identity | ConvertTo-Json -Depth 5
  $parity = [System.Collections.Generic.List[string]]::new(); $parity.Add("agent`thost`trouteIdentity`talias`tpolicyAuthority`tpolicyIsolation`tpolicyLoopGate`trepresentation")
  foreach ($agent in $Catalogs.agents.items) { foreach ($binding in $agent.hostBindings) {
    $host = Resolve-RegistryProjection $Resolver -Value $binding.host -Seam HostName
    $parity.Add(($agent.id,$host,[string]$binding.routeIdentity,[string]$binding.alias,[string]$agent.authority,[string]$agent.isolation,[string]$agent.loopGate,[string]$binding.representation) -join "`t")
  } }
  $composition = [System.Collections.Generic.List[string]]::new(); $composition.Add("composition`thost`tcanonicalReference`tsemanticOrder")
  $orderedCompositionIds = @(Get-RegistrySequence $Catalogs.workflows.semanticOrder)
  $compositionById = @{}
  foreach ($compositionItem in @($Catalogs.workflows.compositions)) {
    $compositionId = [string]$compositionItem.id
    if ($compositionById.ContainsKey($compositionId)) { throw "FAIL: duplicate composition ID in managed view: $compositionId" }
    $compositionById[$compositionId] = $compositionItem
  }
  foreach ($compositionId in $orderedCompositionIds) {
    if (-not $compositionById.ContainsKey($compositionId)) { throw "FAIL: semanticOrder references unknown composition '$compositionId'" }
    $compositionItem = $compositionById[$compositionId]
    $host = Resolve-RegistryProjection $Resolver -Value $compositionItem.host -Seam HostName
    $refs = @($compositionItem.references | ForEach-Object { Resolve-RegistryProjection $Resolver -Value $_ -Seam Reference })
    $composition.Add(($compositionItem.id,$host,$compositionItem.canonicalReferenceId,($refs -join '|')) -join "`t")
  }
  [pscustomobject]@{ Files = [ordered]@{ 'identity.json' = $identityJson + "`n"; 'agent-parity.tsv' = ($parity -join "`n") + "`n"; 'composition-order.tsv' = ($composition -join "`n") + "`n" } }
}

function Test-RegistryOutputRoot([string]$OutputRoot,[string]$RepoRoot,[switch]$AllowTemporaryRoot) {
  $forbidden = @('overlays','agents','skills','rules','workflow','docs','.git','.cursor','.config')
  $full = [IO.Path]::GetFullPath($OutputRoot); $root = [IO.Path]::GetFullPath($RepoRoot).TrimEnd('\','/') + '\'
  $temporaryRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\','/') + '\'
  $protectedTrees = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
  foreach ($protectedTree in ($forbidden + @('catalog','scripts'))) { $null = $protectedTrees.Add($protectedTree) }
  if ($AllowTemporaryRoot) {
    if (-not $full.StartsWith($temporaryRoot, [StringComparison]::OrdinalIgnoreCase)) { throw "FAIL: temporary output root is not under the OS temporary root: $OutputRoot" }
    $temporarySegments = @($full.Substring($temporaryRoot.Length).Trim('\','/') -split '[\\/]' | Where-Object { $_ })
    if ($temporarySegments.Count -eq 0) { throw 'FAIL: temporary output must be a dedicated subtree below the OS temporary root' }
    return
  }
  if (-not $full.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)) { throw "FAIL: output root outside repository: $OutputRoot" }
  $relativeToRepo = $full.Substring($root.Length).Trim('\','/')
  $repoSegments = @($relativeToRepo -split '[\\/]' | Where-Object { $_ })
  if ($repoSegments.Count -eq 0) { throw 'FAIL: managed-view output may not target the repository root' }
  foreach ($segment in $repoSegments) { if ($protectedTrees.Contains($segment)) { throw "FAIL: managed-view output may not target protected tree '$segment'" } }
}

function Write-RegistryManagedView {
  param([Parameter(Mandatory)]$Catalogs,[Parameter(Mandatory)][string]$OutputRoot,[string]$RepoRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)),$Resolver = (New-RegistryProjectionResolver),[switch]$AllowTemporaryRoot)
  Test-RegistryOutputRoot -OutputRoot $OutputRoot -RepoRoot $RepoRoot -AllowTemporaryRoot:$AllowTemporaryRoot
  $view = Get-RegistryManagedView -Catalogs $Catalogs -RepoRoot $RepoRoot -Resolver $Resolver
  New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
  $encoding = [System.Text.UTF8Encoding]::new($false)
  foreach ($file in $view.Files.GetEnumerator()) { [IO.File]::WriteAllText((Join-Path $OutputRoot $file.Key), [string]$file.Value, $encoding) }
  return $view
}

Export-ModuleMember -Function @('Test-ProcedureRegistryCatalogs','Test-RegistryCatalog','New-RegistryProjectionResolver','Resolve-RegistryProjection','Get-RegistryManagedView','Write-RegistryManagedView','Test-RegistryOutputRoot','Get-StackManifestDestinationCount')
