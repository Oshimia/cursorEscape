#Requires -Version 7.4
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$script:Hosts = @('Cursor','OpenCode','Antigravity','Vscode','Cline','Kilocode','Codex')
$script:ExpectedKinds = @{ agents = 'agents.json'; skills = 'skills.json'; rules = 'rules.json'; workflows = 'workflows.json' }
$script:CanonicalAgentContractCache = @{}
$script:SkillHostFrontmatterProfileSkillIds = @('implementation-plan','plan-review','implementation-review','composer','discovery','documentation-architecture','roadmap','research','bug-review-sweep','diagnosing-bugs','architecture-survey','codebase-design','domain-modeling','grilling','prototype','tdd','resolving-merge-conflicts','teach','wait-what','wizard','opencode-headless-run','opencode-history-search')

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
    parsed host stack manifest. Used by the six-stack render ledger generator
    and its registry-view unit checks; the current-state checker validates
    current manifest agreement separately from historical row-agreement ledger
    checks. In each supported shape the count is expressed exactly once:
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

function Get-RegistrySkillFrontmatterDescription {
  <#
    Fail-closed accessor for one skill's registry-owned description metadata.
    Returns a Style/Lines object or $null after appending invariant failures.
  #>
  param([Parameter(Mandatory)]$Skill,[System.Collections.Generic.List[string]]$Failures)
  $id = [string]$Skill.id
  $property = $Skill.PSObject.Properties['description']
  if ($null -eq $property) { Add-RegistryFailure $Failures 'SkillDescriptionMissing' "$id has no registry-owned description metadata"; return $null }
  $description = $property.Value
  $style = [string]$description.style
  if ($style -notin @('folded-block','plain-scalar')) { Add-RegistryFailure $Failures 'SkillDescriptionStyle' "$id style='$style'"; return $null }
  $lines = @(Get-RegistrySequence $description.lines)
  if ($lines.Count -eq 0) { Add-RegistryFailure $Failures 'SkillDescriptionMissing' "$id has no description lines"; return $null }
  for ($index = 0; $index -lt $lines.Count; $index++) {
    if ($lines[$index].Length -eq 0 -or $lines[$index] -match '^\s' -or $lines[$index] -match '\s$' -or $lines[$index] -match '[\r\n\t]') {
      Add-RegistryFailure $Failures 'SkillDescriptionLine' "$id line $index has leading/trailing whitespace or an embedded line break"; return $null
    }
  }
  if ($style -eq 'plain-scalar') {
    if ($lines.Count -ne 1) { Add-RegistryFailure $Failures 'SkillDescriptionScalar' "$id plain-scalar description must be exactly one physical line"; return $null }
    $scalarIndicators = @('-','?',':',',','[',']','{','}','#','&','*','!','|','>','''','"','%','@','`')
    if ($scalarIndicators -contains $lines[0].Substring(0,1) -or $lines[0].Contains(': ') -or $lines[0].EndsWith(':') -or $lines[0].Contains(' #')) {
      Add-RegistryFailure $Failures 'SkillDescriptionScalar' "$id plain-scalar description is not a safe single-line YAML value"; return $null
    }
    $yaml11BoolOrNull = $lines[0] -cmatch '^(?:y|Y|yes|Yes|YES|n|N|no|No|NO|true|True|TRUE|false|False|FALSE|on|On|ON|off|Off|OFF|~|null|Null|NULL)$'
    $yaml11Number = $lines[0] -cmatch '^(?:[-+]?(?:0[bB][0-1_]+|0[xX][0-9A-Fa-f_]+|0[oO][0-7_]+|(?:[0-9][0-9_]*(?:\.[0-9_]*)?|\.[0-9_]+)(?:[eE][-+]?[0-9]+)?|[0-9][0-9_]*(?::[0-5]?[0-9])+(?:\.[0-9_]*)?)|[-+]?\.(?:inf|Inf|INF|nan|NaN|NAN))$'
    if ($yaml11BoolOrNull -or $yaml11Number) {
      Add-RegistryFailure $Failures 'SkillDescriptionScalar' "$id plain-scalar description '$($lines[0])' resolves to a YAML-1.1 bool, null, or number-like value"; return $null
    }
  }
  return [pscustomobject]@{ Style = $style; Lines = $lines }
}

function Get-RegistrySkillFrontmatter {
  <#
    Deterministic canonical skill frontmatter builder. Emits the exact YAML
    frontmatter byte sequence — delimiters, metadata lines, and a terminal
    newline — using LF, matching the managed-view renderer's byte convention.
    Methodology prose is never duplicated: only frontmatter metadata is owned
    here and it is sourced from the registry catalog.
  #>
  param([Parameter(Mandatory)]$Skill)
  $failures = [System.Collections.Generic.List[string]]::new()
  $description = Get-RegistrySkillFrontmatterDescription -Skill $Skill -Failures $failures
  if ($null -eq $description) { throw "FAIL: $($failures[0])" }
  $id = [string]$Skill.id
  if ([string]::IsNullOrWhiteSpace($id) -or $id -notmatch '^[a-z][a-z0-9_-]{0,63}$') { throw "FAIL: skill frontmatter requires a canonical registry id: '$id'" }
  $lines = [System.Collections.Generic.List[string]]::new()
  $lines.Add('---')
  $lines.Add("name: $id")
  if ($description.Style -eq 'folded-block') {
    $lines.Add('description: >-')
    foreach ($line in $description.Lines) { $lines.Add("  $line") }
  } else {
    $lines.Add("description: $($description.Lines[0])")
  }
  $disabled = $Skill.PSObject.Properties['modelInvocationDisabled']
  if ($null -ne $disabled -and $disabled.Value -is [bool] -and $disabled.Value) { $lines.Add('disable-model-invocation: true') }
  $lines.Add('---')
  return (($lines -join "`n") + "`n")
}

function Get-RegistrySkillCanonicalFrontmatter {
  <# Extracts the leading frontmatter block, including both delimiters. #>
  param([Parameter(Mandatory)][string]$Raw)
  $match = [regex]::Match($Raw, '\A---\r?\n.*?\r?\n---(?:\r?\n|\z)', [Text.RegularExpressions.RegexOptions]::Singleline)
  if (-not $match.Success) { return $null }
  return $match.Value
}

function Get-RegistryComparableFrontmatter {
  <#
    Canonical comparison form, matching the repository deterministic-render
    convention:
    UTF-8 text after CRLF-to-LF and exactly one terminal LF. Existing skill
    files carry mixed historical line endings; the normalization is explicit
    and every file's observed newline pattern is still reported as evidence.
  #>
  param([Parameter(Mandatory)][string]$Value)
  return (($Value -replace "`r`n", "`n").TrimEnd("`r", "`n") + "`n")
}

function Get-RegistryFrontmatterNewlinePattern {
  param([Parameter(Mandatory)][string]$Value)
  $crlf = [regex]::Matches($Value, "\r\n").Count
  $lf = [regex]::Matches($Value, "(?<!\r)\n").Count
  if ($crlf -eq 0 -and $lf -eq 0) { return 'none' }
  if ($crlf -eq 0) { return 'lf' }
  if ($lf -eq 0) { return 'crlf' }
  return 'mixed'
}

function Get-RegistrySkillSourceRaw {
  <#
    BOM fail-closed file ingress for canonical and host wrapper skill sources.
    Registry-rendered sources are UTF-8 without a BOM, so every Unicode BOM
    signature is rejected from the leading bytes before decoding instead of
    being silently stripped by a BOM-aware reader. Returns the decoded text
    or $null after appending an invariant failure.
  #>
  param([Parameter(Mandatory)][string]$Path,[Parameter(Mandatory)][string]$Label,[System.Collections.Generic.List[string]]$Failures)
  try { $bytes = [IO.File]::ReadAllBytes($Path) } catch {
    Add-RegistryFailure $Failures 'SkillSourceRead' "$Label skill source could not be read: $($_.Exception.Message)"
    return $null
  }
  $bomSignatures = @(
    ,([byte[]]@(0xEF,0xBB,0xBF))
    ,([byte[]]@(0xFE,0xFF))
    ,([byte[]]@(0xFF,0xFE))
    ,([byte[]]@(0x00,0x00,0xFE,0xFF))
  )
  foreach ($signature in $bomSignatures) {
    if ($bytes.Length -lt $signature.Length) { continue }
    $matched = $true
    for ($index = 0; $index -lt $signature.Length; $index++) { if ($bytes[$index] -ne $signature[$index]) { $matched = $false; break } }
    if ($matched) { Add-RegistryFailure $Failures 'SkillSourceBom' "$Label skill source begins with a Unicode BOM"; return $null }
  }
  return [Text.UTF8Encoding]::new($false).GetString($bytes)
}

function Get-RegistrySkillFrontmatterShadow {
  <#
    Fail-closed Phase 3A shadow comparison for one registered skill: the
    registry-generated frontmatter must byte-match the canonical skill-file
    frontmatter under the explicit comparison convention. Differences are
    reported under the invariant plus the stable skill id; nothing is
    rewritten or silently normalized.
  #>
  param([Parameter(Mandatory)]$Skill,[Parameter(Mandatory)][string]$Raw)
  $failures = [System.Collections.Generic.List[string]]::new()
  $id = [string]$Skill.id
  $canonical = Get-RegistrySkillCanonicalFrontmatter -Raw $Raw
  $newlines = 'none'
  if ($null -eq $canonical) {
    Add-RegistryFailure $failures 'SkillFrontmatterShape' "$id canonical body has no frontmatter block"
  } else {
    $newlines = Get-RegistryFrontmatterNewlinePattern $canonical
    $descriptionFailures = [System.Collections.Generic.List[string]]::new()
    $null = Get-RegistrySkillFrontmatterDescription -Skill $Skill -Failures $descriptionFailures
    if ($descriptionFailures.Count -gt 0) {
      foreach ($descriptionFailure in $descriptionFailures) { $failures.Add($descriptionFailure) }
    } else {
      try {
        $generated = Get-RegistrySkillFrontmatter -Skill $Skill
        if ((Get-RegistryComparableFrontmatter $canonical) -cne (Get-RegistryComparableFrontmatter $generated)) {
          Add-RegistryFailure $failures 'SkillFrontmatterShadow' "$id registry-generated and canonical frontmatter differ"
        }
      }
      catch { Add-RegistryFailure $failures 'SkillFrontmatterMetadata' "$id $($_.Exception.Message -replace '^FAIL:\s*','')" }
    }
  }
  $status = if ($failures.Count -eq 0) { 'match' } else { 'mismatch' }
  return [pscustomobject]@{ Id = $id; Status = $status; Newlines = $newlines; Failures = $failures }
}

function Get-RegistrySkillWrapperFrontmatterShadow {
  <#
    Fail-closed wrapper-frontmatter comparator for one applicable host binding: the
    registry-owned host frontmatter profile must byte-match the wrapper's
    frontmatter under the deterministic-render comparison convention. Canonical
    name, exact description, and the effective disable-model-invocation
    policy are each checked so every mismatch names both the host and the
    canonical skill id. Nothing is rewritten or silently normalized.
  #>
  param([Parameter(Mandatory)][string]$SkillId,[Parameter(Mandatory)]$Profile,[Parameter(Mandatory)][string]$HostName,[Parameter(Mandatory)][string]$Raw,[System.Collections.Generic.List[string]]$Failures)
  $before = $Failures.Count
  $canonical = Get-RegistrySkillCanonicalFrontmatter -Raw $Raw
  if ($null -eq $canonical) {
    Add-RegistryFailure $Failures 'SkillWrapperShape' "$SkillId/$HostName wrapper has no frontmatter block"
    return 'mismatch'
  }
  $normalized = Get-RegistryComparableFrontmatter $canonical
  if ($normalized -notmatch "(?m)^name:[ \t]*$([regex]::Escape($SkillId))[ \t]*$") {
    Add-RegistryFailure $Failures 'SkillWrapperName' "$SkillId/$HostName wrapper name does not equal the canonical registry id"
  }
  $disabledProperty = $Profile.PSObject.Properties['modelInvocationDisabled']
  $effectiveDisabled = $normalized -match '(?m)^disable-model-invocation:[ \t]*true[ \t]*$'
  if ($null -eq $disabledProperty -or $disabledProperty.Value -isnot [bool]) {
    Add-RegistryFailure $Failures 'SkillHostFrontmatterProfilePolicy' "$SkillId/$HostName profile modelInvocationDisabled must be boolean"
  } elseif ($effectiveDisabled -ne $disabledProperty.Value) {
    Add-RegistryFailure $Failures 'SkillWrapperDisableModelInvocation' "$SkillId/$HostName effective=$effectiveDisabled profile=$($disabledProperty.Value)"
  }
  $descriptionProperty = $Profile.PSObject.Properties['description']
  $descriptionValid = $false
  if ($null -eq $descriptionProperty) {
    Add-RegistryFailure $Failures 'SkillDescriptionMissing' "$SkillId/$HostName host frontmatter profile has no description"
  } else {
    $profileDisabled = if ($null -ne $disabledProperty -and $disabledProperty.Value -is [bool]) { $disabledProperty.Value } else { $false }
    $profileSkill = [pscustomobject]@{ id = $SkillId; description = $descriptionProperty.Value; modelInvocationDisabled = $profileDisabled }
    $descriptionFailures = [System.Collections.Generic.List[string]]::new()
    $null = Get-RegistrySkillFrontmatterDescription -Skill $profileSkill -Failures $descriptionFailures
    foreach ($descriptionFailure in $descriptionFailures) { $Failures.Add($descriptionFailure) }
    $descriptionValid = $descriptionFailures.Count -eq 0
    if ($descriptionValid) {
      try {
        $expected = Get-RegistrySkillFrontmatter -Skill $profileSkill
        if ((Get-RegistryComparableFrontmatter $expected) -cne $normalized) {
          Add-RegistryFailure $Failures 'SkillWrapperFrontmatterShadow' "$SkillId/$HostName registry profile and wrapper frontmatter differ"
        }
      }
      catch { Add-RegistryFailure $Failures 'SkillWrapperFrontmatterMetadata' "$SkillId/$HostName $($_.Exception.Message -replace '^FAIL:\s*','')" }
    }
  }
  return $(if ($Failures.Count -eq $before) { 'match' } else { 'mismatch' })
}

function Get-RegistrySkillWrapperSourcePath {
  <#
    Resolves one applicable skill binding's manifest-declared wrapper source to
    a repository-relative path through the existing Phase 0 inventory manifest
    seam (binding source plus the host's overlay/shared root). No second
    routing system is introduced and manifests are never duplicated.
  #>
  param([Parameter(Mandatory)]$Binding,[Parameter(Mandatory)]$Manifest,[Parameter(Mandatory)][string]$SkillId,[Parameter(Mandatory)][string]$HostName,[System.Collections.Generic.List[string]]$Failures)
  $sourceProperty = $Binding.PSObject.Properties['source']
  if ($null -eq $sourceProperty -or [string]::IsNullOrWhiteSpace([string]$sourceProperty.Value)) {
    Add-RegistryFailure $Failures 'SkillWrapperSource' "$SkillId/$HostName applicable binding declares no manifest source"; return $null
  }
  $source = [string]$sourceProperty.Value
  $rootName = if ($source.StartsWith('shared:', [StringComparison]::Ordinal)) { 'shared_root' } else { 'overlay_root' }
  $rootProperty = $Manifest.PSObject.Properties[$rootName]
  $root = if ($null -ne $rootProperty) { [string]$rootProperty.Value } else { '' }
  if ([string]::IsNullOrWhiteSpace($root)) {
    Add-RegistryFailure $Failures 'SkillWrapperSource' "$SkillId/$HostName manifest source '$source' has no '$rootName'"; return $null
  }
  $rest = if ($source.StartsWith('shared:', [StringComparison]::Ordinal)) { $source.Substring(7) } else { $source }
  return (($root.TrimEnd('/','\')) + '/' + $rest)
}

function Get-RegistrySkillHostFrontmatterShadow {
  <#
    Wrapper-frontmatter shadow check for one registered skill across
    all seven hosts. Applicable bindings resolve their manifest-derived
    wrapper source and byte-compare its frontmatter against the registry-owned
    host frontmatter profile; declared not-applicable bindings must show no
    manifest entry delivering the skill wrapper. Returns one row per host for
    managed-view evidence; all defects are appended as fail-closed invariants.
  #>
  param([Parameter(Mandatory)]$Skill,[Parameter(Mandatory)]$Inventory,[Parameter(Mandatory)][string]$RepoRoot,[System.Collections.Generic.List[string]]$Failures)
  $id = [string]$Skill.id
  $profilesProperty = $Skill.PSObject.Properties['hostFrontmatterProfiles']
  $profiles = @(if ($null -ne $profilesProperty) { $profilesProperty.Value })
  $required = $id -in $script:SkillHostFrontmatterProfileSkillIds
  if (-not $required) {
    if ($profiles.Count -gt 0) { Add-RegistryFailure $Failures 'SkillHostFrontmatterProfileScope' "$id is outside the governed host-frontmatter profile set" }
    return @()
  }
  $manifestsByHost = @{}
  $manifestHostsSeen = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  foreach ($manifest in @($Inventory.manifests)) {
    $manifestHost = [string]$manifest.host
    if (-not $manifestHostsSeen.Add($manifestHost)) {
      Add-RegistryFailure $Failures 'SkillWrapperManifestInventory' "$id has more than one Phase 0 manifest for host '$manifestHost'"
      continue
    }
    $manifestsByHost[$manifestHost] = $manifest
  }
  $bindingsByHost = @{}
  foreach ($binding in @($Skill.hostApplicability)) { $bindingsByHost[[string]$binding.host] = $binding }
  $inventorySkill = @($Inventory.skills_inventory.canonical_skills | Where-Object { [string]$_.id -eq $id })
  $inventoryBindingsByHost = @{}
  if ($inventorySkill.Count -eq 1) { foreach ($binding in @($inventorySkill[0].host_applicability)) { $inventoryBindingsByHost[[string]$binding.host] = $binding } }
  $profileByHost = @{}
  $covered = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  foreach ($profile in $profiles) {
    $hostsProperty = $profile.PSObject.Properties['hosts']
    $hosts = @(if ($null -ne $hostsProperty) { Get-RegistrySequence $hostsProperty.Value })
    if ($hosts.Count -eq 0) { Add-RegistryFailure $Failures 'SkillHostFrontmatterProfileHosts' "$id has a host frontmatter profile with no hosts"; continue }
    foreach ($hostName in $hosts) {
      if ($hostName -notin $script:Hosts) { Add-RegistryFailure $Failures 'SkillHostFrontmatterProfileHosts' "$id/$hostName profile declares an invalid host"; continue }
      if (-not $covered.Add($hostName)) { Add-RegistryFailure $Failures 'SkillHostFrontmatterProfileOverlap' "$id/$hostName is covered by multiple host frontmatter profiles"; continue }
      $status = if ($bindingsByHost.ContainsKey($hostName)) { [string]$bindingsByHost[$hostName].status } else { '<missing>' }
      if ($status -cne 'applicable') { Add-RegistryFailure $Failures 'SkillHostFrontmatterProfileApplicability' "$id/$hostName profile covers a '$status' binding" }
      if (-not $profileByHost.ContainsKey($hostName)) { $profileByHost[$hostName] = $profile }
    }
    $sourceProperty = $profile.PSObject.Properties['wrapperSource']
    if ($null -eq $sourceProperty -or [string]::IsNullOrWhiteSpace([string]$sourceProperty.Value)) {
      Add-RegistryFailure $Failures 'SkillWrapperSource' "$id profile declares no wrapperSource"
    } else {
      $null = Test-RegistryDescendantPath $RepoRoot ([string]$sourceProperty.Value) $Failures "SkillWrapperSource:$id" -Leaf
    }
    $disabledProperty = $profile.PSObject.Properties['modelInvocationDisabled']
    if ($null -eq $disabledProperty -or $disabledProperty.Value -isnot [bool]) { Add-RegistryFailure $Failures 'SkillHostFrontmatterProfilePolicy' "$id profile modelInvocationDisabled must be boolean" }
    $descriptionProperty = $profile.PSObject.Properties['description']
    if ($null -eq $descriptionProperty) { Add-RegistryFailure $Failures 'SkillDescriptionMissing' "$id host frontmatter profile has no description" }
    else {
      $profileSkill = [pscustomobject]@{ id = $id; description = $descriptionProperty.Value; modelInvocationDisabled = $true }
      $descriptionFailures = [System.Collections.Generic.List[string]]::new()
      $null = Get-RegistrySkillFrontmatterDescription -Skill $profileSkill -Failures $descriptionFailures
      foreach ($descriptionFailure in $descriptionFailures) { $Failures.Add($descriptionFailure) }
    }
  }
  if ($profiles.Count -eq 0) { Add-RegistryFailure $Failures 'SkillHostFrontmatterProfileMissing' "$id must declare host frontmatter profiles" }
  $rows = [System.Collections.Generic.List[object]]::new()
  foreach ($hostName in $script:Hosts) {
    $binding = if ($bindingsByHost.ContainsKey($hostName)) { $bindingsByHost[$hostName] } else { $null }
    $status = if ($null -ne $binding) { [string]$binding.status } else { '<missing>' }
    $manifest = if ($manifestsByHost.ContainsKey($hostName)) { $manifestsByHost[$hostName] } else { $null }
    $manifestEntries = $null
    if ($null -eq $manifest) {
      Add-RegistryFailure $Failures 'SkillWrapperManifestInventory' "$id/$hostName has no Phase 0 host manifest"
    } else {
      $entriesProperty = $manifest.PSObject.Properties['entries']
      if ($null -eq $entriesProperty) {
        Add-RegistryFailure $Failures 'SkillWrapperManifestInventory' "$id/$hostName Phase 0 host manifest declares no entries"
      } else {
        $manifestEntries = @($entriesProperty.Value)
      }
    }
    if ($status -ceq 'applicable') {
      if (-not $covered.Contains($hostName)) { Add-RegistryFailure $Failures 'SkillHostFrontmatterProfileCoverage' "$id/$hostName applicable binding has no host frontmatter profile" }
      $rowStatus = 'mismatch'; $wrapperSource = '-'
      $profile = if ($profileByHost.ContainsKey($hostName)) { $profileByHost[$hostName] } else { $null }
      $inventoryBinding = if ($inventoryBindingsByHost.ContainsKey($hostName)) { $inventoryBindingsByHost[$hostName] } else { $null }
      $sourceProperty = if ($null -ne $profile) { $profile.PSObject.Properties['wrapperSource'] } else { $null }
      $bindingSource = ''; $bindingDestination = ''
      $deliveryEvidence = -1
      if ($null -ne $inventoryBinding -and $null -ne $manifestEntries) {
        $bindingSourceProperty = $inventoryBinding.PSObject.Properties['source']
        $bindingDestinationProperty = $inventoryBinding.PSObject.Properties['destination']
        $bindingSource = if ($null -ne $bindingSourceProperty) { [string]$bindingSourceProperty.Value } else { '' }
        $bindingDestination = if ($null -ne $bindingDestinationProperty) { [string]$bindingDestinationProperty.Value } else { '' }
        $deliveryEvidence = @($manifestEntries | Where-Object {
          $entrySource = if ($_.PSObject.Properties['source']) { [string]$_.source } else { '' }
          $entryDestination = if ($_.PSObject.Properties['destination']) { [string]$_.destination } else { '' }
          $entrySource -ceq $bindingSource -and $entryDestination -ceq $bindingDestination
        }).Count
      }
      if ($deliveryEvidence -ne 1) {
        Add-RegistryFailure $Failures 'SkillWrapperManifestInventory' "$id/$hostName expected exactly one manifest entry delivering source='$bindingSource' destination='$bindingDestination'; found $deliveryEvidence"
      }
      if ($null -ne $profile -and $null -ne $sourceProperty -and $null -ne $inventoryBinding -and $null -ne $manifest -and $null -ne $manifestEntries) {
        $wrapperSource = [string]$sourceProperty.Value
        $resolved = Get-RegistrySkillWrapperSourcePath -Binding $inventoryBinding -Manifest $manifest -SkillId $id -HostName $hostName -Failures $Failures
        if ($null -ne $resolved) {
          if ($resolved -cne $wrapperSource) {
            Add-RegistryFailure $Failures 'SkillWrapperRouting' "$id/$hostName manifest-resolved='$resolved' profile='$wrapperSource'"
          } elseif ($deliveryEvidence -eq 1) {
            $raw = Get-RegistrySkillSourceRaw -Path (Join-Path $RepoRoot $resolved) -Label "$id/$hostName" -Failures $Failures
            if ($null -ne $raw) {
              $rowStatus = Get-RegistrySkillWrapperFrontmatterShadow -SkillId $id -Profile $profile -HostName $hostName -Raw $raw -Failures $Failures
            }
          }
        }
      }
      $rows.Add([pscustomobject]@{ Skill = $id; Host = $hostName; Status = $rowStatus; WrapperSource = $wrapperSource })
    } else {
      $delivering = @()
      $provedAbsent = $false
      if ($status -ceq 'not-applicable' -and $null -ne $manifestEntries) {
        $delivering = @($manifestEntries | Where-Object {
          $entrySource = if ($_.PSObject.Properties['source']) { [string]$_.source } else { '' }
          $entryDestination = if ($_.PSObject.Properties['destination']) { [string]$_.destination } else { '' }
          $entrySource -ceq "skills/$id/SKILL.md" -or $entrySource -ceq "shared:skills/$id/SKILL.md" -or $entryDestination -cmatch "(^|/)$([regex]::Escape($id))/SKILL\.md$"
        })
        if ($delivering.Count -gt 0) {
          $delivered = if ($delivering[0].PSObject.Properties['destination']) { [string]$delivering[0].destination } else { '<unknown>' }
          Add-RegistryFailure $Failures 'SkillWrapperNotApplicable' "$id/$hostName declared not-applicable but the manifest delivers a wrapper ('$delivered')"
        } else {
          $provedAbsent = $true
        }
      }
      $rows.Add([pscustomobject]@{ Skill = $id; Host = $hostName; Status = $(if ($provedAbsent) { 'not-applicable' } else { 'mismatch' }); WrapperSource = '-' })
    }
  }
  return $rows
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

function Get-RegistryCompositionReferencePath {
  <#
    Shared fail-closed reference resolver for registry-declared composition
    references. Returns the repository-relative path for one reference token;
    callers remain responsible for leaf existence checks.
  #>
  param([Parameter(Mandatory)][string]$Reference,[Parameter(Mandatory)][string]$HostName,$OverlayRoots = @{})
  if ($Reference.StartsWith('base:', [StringComparison]::Ordinal)) { return $Reference.Substring(5) }
  $roots = if ($OverlayRoots.ContainsKey($HostName)) { $OverlayRoots[$HostName] } else { @{} }
  if ($Reference.StartsWith('shared:', [StringComparison]::Ordinal)) {
    $rest = $Reference.Substring(7)
    $sharedRoot = if ($roots.ContainsKey('Shared') -and $null -ne $roots.Shared) { $roots.Shared } else { $roots['Overlay'] }
    return "$sharedRoot/$rest"
  }
  if ($Reference.StartsWith('instructions/', [StringComparison]::Ordinal) -or $Reference.StartsWith('footers/', [StringComparison]::Ordinal)) {
    return "$($roots['Overlay'])/$Reference"
  }
  return $Reference
}

function Test-RegistryHostCompositionOwnership {
  <#
    Phase 4C fail-closed ownership bridge. The catalog owns every runtime
    composition reference sequence; manifests own only destinations, host
    bindings, and explicit composition IDs. Any manifest-local semantic order
    is an ownership mismatch and is never consumed.
  #>
  param([Parameter(Mandatory)]$Catalog,[Parameter(Mandatory)][string]$RepoRoot,[Parameter(Mandatory)]$Failures)
  $invariant = 'composition-order-ownership'
  $compositionById = @{}
  foreach ($composition in @($Catalog.compositions)) { $compositionById[[string]$composition.id] = $composition }

  try { $cursorManifest = Import-PowerShellDataFile -Path (Join-Path $RepoRoot 'scripts/host-sync/manifests/cursor.manifest.psd1') } catch {
    Add-RegistryFailure $Failures $invariant "cursor manifest read failed: $($_.Exception.Message)"; return
  }
  $cursorRuleIds = @(Get-RegistrySequence $cursorManifest.HybridRuleIds)
  # Derive the host-facing rule order from semanticOrder -> runtime composition ->
  # canonicalReferenceId. Never keep a second hardcoded canonical sequence here.
  $cursorExpectedRules = [System.Collections.Generic.List[string]]::new()
  foreach ($compositionId in @($Catalog.semanticOrder)) {
    $composition = $compositionById[[string]$compositionId]
    if ($null -eq $composition -or [string]$composition.host -cne 'Cursor' -or
        -not ($composition.PSObject.Properties['runtimeOnly'] -and [bool]$composition.runtimeOnly)) { continue }
    if (-not $composition.PSObject.Properties['canonicalReferenceId']) {
      Add-RegistryFailure $Failures $invariant "Cursor runtime composition '$compositionId' has no canonicalReferenceId"
      continue
    }
    $cursorExpectedRules.Add([string]$composition.canonicalReferenceId)
  }
  if (-not (Test-RegistrySequence $cursorRuleIds $cursorExpectedRules)) {
    Add-RegistryFailure $Failures $invariant "Cursor rule bindings '$($cursorRuleIds -join '|')' do not match registry surface"
  }
  # Complete binding validation: compare actual (RuleId, CompositionId, Destination)
  # set against the registry-derived expected set; reject duplicates, omissions,
  # and extras under composition-order-ownership. No hardcoded count or order.
  $cursorExpectedBindings = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  foreach ($compositionId in @($Catalog.semanticOrder)) {
    $composition = $compositionById[[string]$compositionId]
    if ($null -eq $composition -or [string]$composition.host -cne 'Cursor' -or
        -not ($composition.PSObject.Properties['runtimeOnly'] -and [bool]$composition.runtimeOnly)) { continue }
    if (-not $composition.PSObject.Properties['canonicalReferenceId']) { continue }
    $ruleId = [string]$composition.canonicalReferenceId
    $null = $cursorExpectedBindings.Add("${ruleId}|cursor-${ruleId}|rules/${ruleId}.mdc")
  }
  $cursorActualBindings = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  foreach ($row in @($cursorManifest.HybridCompositions)) {
    $ruleId = [string]$row['RuleId']; $compositionId = [string]$row['CompositionId']; $destination = [string]$row['Destination']
    foreach ($forbidden in @('Order','References','Parts','Footer')) {
      if ($row -is [hashtable] -and $row.ContainsKey($forbidden)) {
        Add-RegistryFailure $Failures $invariant "Cursor '$ruleId' manifest-owned semantic field '$forbidden'"
      }
    }
    $bindingKey = "$ruleId|$compositionId|$destination"
    if (-not $cursorActualBindings.Add($bindingKey)) {
      Add-RegistryFailure $Failures $invariant "Cursor duplicate hybrid binding: '$bindingKey'"
    }
  }
  foreach ($expected in $cursorExpectedBindings) {
    if (-not $cursorActualBindings.Contains($expected)) {
      Add-RegistryFailure $Failures $invariant "Cursor binding omitted from manifest: '$expected'"
    }
  }
  foreach ($actual in $cursorActualBindings) {
    if (-not $cursorExpectedBindings.Contains($actual)) {
      Add-RegistryFailure $Failures $invariant "Cursor extra binding in manifest: '$actual'"
    }
  }

  try { $openCodeManifest = Import-PowerShellDataFile -Path (Join-Path $RepoRoot 'scripts/host-sync/manifests/opencode.manifest.psd1') } catch {
    Add-RegistryFailure $Failures $invariant "OpenCode manifest read failed: $($_.Exception.Message)"; return
  }
  if (-not $openCodeManifest.Contains('AgentsDualWrite')) {
    Add-RegistryFailure $Failures $invariant 'OpenCode dual-write host binding is absent'; return
  }
  $dualWrite = $openCodeManifest.AgentsDualWrite
  $destChecks = [ordered]@{
    'InstructionsRel' = 'instructions/cursor-escape-loop.md'
    'AgentsRel'       = 'AGENTS.md'
  }
  foreach ($key in $destChecks.Keys) {
    $actual = if ($dualWrite.Contains($key)) { [string]$dualWrite[$key] } else { '' }
    if ($actual -cne [string]$destChecks[$key]) {
      Add-RegistryFailure $Failures $invariant "OpenCode dual-write $key mismatch: '$actual'"
    }
  }
  foreach ($forbidden in @('Order','References','Parts','Footer')) {
    if ($dualWrite.Contains($forbidden)) {
      Add-RegistryFailure $Failures $invariant "OpenCode dual-write manifest-owned semantic field '$forbidden'"
    }
  }
  # Derive expected OpenCode runtime composition IDs from the registry semanticOrder.
  $openCodeRuntimeIds = [System.Collections.Generic.List[string]]::new()
  foreach ($compositionId in @($Catalog.semanticOrder)) {
    $composition = $compositionById[[string]$compositionId]
    if ($null -eq $composition -or [string]$composition.host -cne 'OpenCode' -or
        -not ($composition.PSObject.Properties['runtimeOnly'] -and [bool]$composition.runtimeOnly)) { continue }
    $openCodeRuntimeIds.Add([string]$compositionId)
  }
  $boundInstrId = if ($dualWrite.Contains('InstructionsCompositionId')) { [string]$dualWrite['InstructionsCompositionId'] } else { '' }
  $boundAgentsId = if ($dualWrite.Contains('AgentsCompositionId')) { [string]$dualWrite['AgentsCompositionId'] } else { '' }
  if (-not $dualWrite.Contains('InstructionsCompositionId')) {
    Add-RegistryFailure $Failures $invariant 'OpenCode InstructionsCompositionId is absent'
  }
  if (-not $dualWrite.Contains('AgentsCompositionId')) {
    Add-RegistryFailure $Failures $invariant 'OpenCode AgentsCompositionId is absent'
  }
  if ($openCodeRuntimeIds.Count -ne 2) {
    Add-RegistryFailure $Failures $invariant "expected 2 OpenCode runtime compositions, got $($openCodeRuntimeIds.Count)"
  }
  if ($boundInstrId -and ($openCodeRuntimeIds -notcontains $boundInstrId)) {
    Add-RegistryFailure $Failures $invariant "OpenCode instructions composition '$boundInstrId' not in registry"
  }
  if ($boundAgentsId -and ($openCodeRuntimeIds -notcontains $boundAgentsId)) {
    Add-RegistryFailure $Failures $invariant "OpenCode agents composition '$boundAgentsId' not in registry"
  }
  if ($boundInstrId -and $boundAgentsId -and $boundInstrId -ceq $boundAgentsId) {
    Add-RegistryFailure $Failures $invariant 'OpenCode instructions and agents composition IDs must be distinct'
  }
  $instructionComp = if ($boundInstrId -and $compositionById.ContainsKey($boundInstrId)) { $compositionById[$boundInstrId] } else { $null }
  $agentsComp = if ($boundAgentsId -and $compositionById.ContainsKey($boundAgentsId)) { $compositionById[$boundAgentsId] } else { $null }
  if ($null -ne $instructionComp -and $null -ne $agentsComp -and
      -not (Test-RegistrySequence (Get-RegistrySequence $instructionComp.references) (Get-RegistrySequence $agentsComp.references))) {
    Add-RegistryFailure $Failures $invariant 'OpenCode instruction/AGENTS registry orders differ'
  }

  # Phase 4D: Antigravity Generic-adapter CopyEntry composition ownership.
  try { $antigravityManifest = Import-PowerShellDataFile -Path (Join-Path $RepoRoot 'scripts/host-sync/manifests/antigravity.manifest.psd1') } catch {
    Add-RegistryFailure $Failures $invariant "Antigravity manifest read failed: $($_.Exception.Message)"; return
  }
  # Derive expected Antigravity runtime composition IDs from the registry.
  $antigravityRuntimeIds = [System.Collections.Generic.List[string]]::new()
  $antigravityExpectedBindings = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  foreach ($compositionId in @($Catalog.semanticOrder)) {
    $composition = $compositionById[[string]$compositionId]
    if ($null -eq $composition -or [string]$composition.host -cne 'Antigravity' -or
        -not ($composition.PSObject.Properties['runtimeOnly'] -and [bool]$composition.runtimeOnly)) { continue }
    $antigravityRuntimeIds.Add([string]$compositionId)
    if (-not $composition.PSObject.Properties['canonicalReferenceId']) {
      Add-RegistryFailure $Failures $invariant "Antigravity runtime composition '$compositionId' has no canonicalReferenceId"
      continue
    }
    # Find the composition reference that matches the canonicalReferenceId path.
    # The Source is the body reference; derive expected binding key.
    $sourceRef = $null
    foreach ($ref in @($composition.references)) {
      $refStr = [string]$ref
      if ($refStr -like "*$([string]$composition.canonicalReferenceId)*" -and $refStr -notlike 'footers/*' -and $refStr -notlike 'instructions/*') { $sourceRef = $refStr; break }
    }
    if ($null -eq $sourceRef) { $sourceRef = [string]$composition.references[1] }
    $null = $antigravityExpectedBindings.Add("$sourceRef|$compositionId")
  }
  $antigravityActualBindings = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  foreach ($entry in @($antigravityManifest.CopyEntries)) {
    foreach ($forbidden in @('Parts','Footer','References','Order')) {
      if ($entry -is [hashtable] -and $entry.ContainsKey($forbidden)) {
        $destKey = if ($entry.ContainsKey('Dest')) { [string]$entry['Dest'] } else { [string]$entry['Source'] }
        Add-RegistryFailure $Failures $invariant "Antigravity '$destKey' manifest-owned semantic field '$forbidden'"
      }
    }
    if ($entry -is [hashtable] -and $entry.ContainsKey('CompositionId')) {
      $boundId = [string]$entry['CompositionId']
      $sourceRel = [string]$entry['Source']
      $destKey = if ($entry.ContainsKey('Dest')) { [string]$entry['Dest'] } else { $sourceRel }
      if (-not $compositionById.ContainsKey($boundId)) {
        Add-RegistryFailure $Failures $invariant "Antigravity '$destKey' composition '$boundId' not in registry"
        continue
      }
      $boundComp = $compositionById[$boundId]
      if ([string]$boundComp.host -cne 'Antigravity') {
        Add-RegistryFailure $Failures $invariant "Antigravity '$destKey' composition '$boundId' host mismatch"
      }
      if (-not ($boundComp.PSObject.Properties['runtimeOnly'] -and [bool]$boundComp.runtimeOnly)) {
        Add-RegistryFailure $Failures $invariant "Antigravity '$destKey' composition '$boundId' is not runtimeOnly"
      }
      $bindingKey = "$sourceRel|$boundId"
      if (-not $antigravityActualBindings.Add($bindingKey)) {
        Add-RegistryFailure $Failures $invariant "Antigravity duplicate composition binding: '$bindingKey'"
      }
    }
  }
  foreach ($expected in $antigravityExpectedBindings) {
    if (-not $antigravityActualBindings.Contains($expected)) {
      Add-RegistryFailure $Failures $invariant "Antigravity binding omitted from manifest: '$expected'"
    }
  }
  foreach ($actual in $antigravityActualBindings) {
    if (-not $antigravityExpectedBindings.Contains($actual)) {
      Add-RegistryFailure $Failures $invariant "Antigravity extra binding in manifest: '$actual'"
    }
  }

  # Phase 4E: Cline/Kilocode Generic-adapter CopyEntry composition ownership.
  # Standalone fallback leaves remain plain CopyEntries and are intentionally
  # excluded from semantic-order comparison.
  foreach ($genericHost in @('Cline', 'Kilocode')) {
    try {
      $genericManifest = Import-PowerShellDataFile -Path (Join-Path $RepoRoot "scripts/host-sync/manifests/$([string]$genericHost.ToLowerInvariant()).manifest.psd1")
    } catch {
      Add-RegistryFailure $Failures $invariant "$genericHost manifest read failed: $($_.Exception.Message)"; continue
    }
    $genericExpectedBindings = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($compositionId in @($Catalog.semanticOrder)) {
      $composition = $compositionById[[string]$compositionId]
      if ($null -eq $composition -or [string]$composition.host -cne $genericHost -or
          -not ($composition.PSObject.Properties['runtimeOnly'] -and [bool]$composition.runtimeOnly)) { continue }
      if (-not $composition.PSObject.Properties['canonicalReferenceId']) {
        Add-RegistryFailure $Failures $invariant "$genericHost runtime composition '$compositionId' has no canonicalReferenceId"
        continue
      }
      $sourceRef = "base:rules/$([string]$composition.canonicalReferenceId).md"
      $null = $genericExpectedBindings.Add("$sourceRef|$compositionId")
    }
    $genericActualBindings = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($entry in @($genericManifest.CopyEntries)) {
      foreach ($forbidden in @('Parts','Footer','References','Order')) {
        if ($entry -is [hashtable] -and $entry.ContainsKey($forbidden)) {
          $destKey = if ($entry.ContainsKey('Dest')) { [string]$entry['Dest'] } else { [string]$entry['Source'] }
          Add-RegistryFailure $Failures $invariant "$genericHost '$destKey' manifest-owned semantic field '$forbidden'"
        }
      }
      if (-not ($entry -is [hashtable] -and $entry.ContainsKey('CompositionId'))) { continue }
      $boundId = [string]$entry['CompositionId']
      $sourceRel = [string]$entry['Source']
      $destKey = if ($entry.ContainsKey('Dest')) { [string]$entry['Dest'] } else { $sourceRel }
      if (-not $compositionById.ContainsKey($boundId)) {
        Add-RegistryFailure $Failures $invariant "$genericHost '$destKey' composition '$boundId' not in registry"
        continue
      }
      $boundComp = $compositionById[$boundId]
      if ([string]$boundComp.host -cne $genericHost) {
        Add-RegistryFailure $Failures $invariant "$genericHost '$destKey' composition '$boundId' host mismatch"
      }
      if (-not ($boundComp.PSObject.Properties['runtimeOnly'] -and [bool]$boundComp.runtimeOnly)) {
        Add-RegistryFailure $Failures $invariant "$genericHost '$destKey' composition '$boundId' is not runtimeOnly"
      }
      $bindingKey = "$sourceRel|$boundId"
      if (-not $genericActualBindings.Add($bindingKey)) {
        Add-RegistryFailure $Failures $invariant "$genericHost duplicate composition binding: '$bindingKey'"
      }
    }
    foreach ($expected in $genericExpectedBindings) {
      if (-not $genericActualBindings.Contains($expected)) {
        Add-RegistryFailure $Failures $invariant "$genericHost binding omitted from manifest: '$expected'"
      }
    }
    foreach ($actual in $genericActualBindings) {
      if (-not $genericExpectedBindings.Contains($actual)) {
        Add-RegistryFailure $Failures $invariant "$genericHost extra binding in manifest: '$actual'"
      }
    }
  }

  # Phase 4F: Codex specialized-adapter managed AGENTS block composition
  # ownership. The managed block binds a canonical-rule prefix followed by the
  # overlay-local Codex footer (the writer Source and registry split point);
  # the manifest owns only the destination, binding, and composition ID.
  try { $codexManifest = Import-PowerShellDataFile -Path (Join-Path $RepoRoot 'scripts/host-sync/manifests/codex.manifest.psd1') } catch {
    Add-RegistryFailure $Failures $invariant "Codex manifest read failed: $($_.Exception.Message)"; return
  }
  $codexExpectedBindings = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  foreach ($compositionId in @($Catalog.semanticOrder)) {
    $composition = $compositionById[[string]$compositionId]
    if ($null -eq $composition -or [string]$composition.host -cne 'Codex' -or
        -not ($composition.PSObject.Properties['runtimeOnly'] -and [bool]$composition.runtimeOnly)) { continue }
    if (-not $composition.PSObject.Properties['canonicalReferenceId']) {
      Add-RegistryFailure $Failures $invariant "Codex runtime composition '$compositionId' has no canonicalReferenceId"
      continue
    }
    $codexRefs = @(Get-RegistrySequence $composition.references)
    $expectedCodexRefs = [string[]]@(
      'base:rules/agent-invocation.md',
      'base:rules/iterative-plan-review.md',
      'base:rules/iterative-code-review.md',
      'base:rules/pre-commit-ci-gate.md',
      'footers/codex-wiring.md'
    )
    if ((@($codexRefs) -join '|') -cne ($expectedCodexRefs -join '|')) {
      Add-RegistryFailure $Failures $invariant "Codex runtime composition '$compositionId' must declare canonical rules followed by the Codex footer"
      continue
    }
    $null = $codexExpectedBindings.Add("$($codexRefs[-1])|$compositionId")
  }
  $codexActualBindings = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  foreach ($codexEntry in @($codexManifest.DestinationEntries)) {
    foreach ($forbidden in @('Parts','Footer','References','Order')) {
      if ($codexEntry -is [hashtable] -and $codexEntry.ContainsKey($forbidden)) {
        $codexDestKey = if ($codexEntry.ContainsKey('Dest')) { [string]$codexEntry['Dest'] } else { [string]$codexEntry['Source'] }
        Add-RegistryFailure $Failures $invariant "Codex '$codexDestKey' manifest-owned semantic field '$forbidden'"
      }
    }
    if (-not ($codexEntry -is [hashtable] -and $codexEntry.ContainsKey('CompositionId'))) { continue }
    $codexBoundId = [string]$codexEntry['CompositionId']
    $codexSourceRel = [string]$codexEntry['Source']
    $codexDestKey = if ($codexEntry.ContainsKey('Dest')) { [string]$codexEntry['Dest'] } else { $codexSourceRel }
    if (-not $compositionById.ContainsKey($codexBoundId)) {
      Add-RegistryFailure $Failures $invariant "Codex '$codexDestKey' composition '$codexBoundId' not in registry"
      continue
    }
    $codexBoundComp = $compositionById[$codexBoundId]
    if ([string]$codexBoundComp.host -cne 'Codex') {
      Add-RegistryFailure $Failures $invariant "Codex '$codexDestKey' composition '$codexBoundId' host mismatch"
    }
    if (-not ($codexBoundComp.PSObject.Properties['runtimeOnly'] -and [bool]$codexBoundComp.runtimeOnly)) {
      Add-RegistryFailure $Failures $invariant "Codex '$codexDestKey' composition '$codexBoundId' is not runtimeOnly"
    }
    $codexBindingKey = "$codexSourceRel|$codexBoundId"
    if (-not $codexActualBindings.Add($codexBindingKey)) {
      Add-RegistryFailure $Failures $invariant "Codex duplicate composition binding: '$codexBindingKey'"
    }
  }
  foreach ($expected in $codexExpectedBindings) {
    if (-not $codexActualBindings.Contains($expected)) {
      Add-RegistryFailure $Failures $invariant "Codex binding omitted from manifest: '$expected'"
    }
  }
  foreach ($actual in $codexActualBindings) {
    if (-not $codexExpectedBindings.Contains($actual)) {
      Add-RegistryFailure $Failures $invariant "Codex extra binding in manifest: '$actual'"
    }
  }
}

function Test-RegistryCatalog {
  param([Parameter(Mandatory)]$Catalog,[Parameter(Mandatory)][ValidateSet('agents','rules','skills','workflows')][string]$Kind,[Parameter(Mandatory)][string]$RepoRoot,$OverlayRoots = @{},$Inventory = $null)
  $failures = [System.Collections.Generic.List[string]]::new()
  $items = @($Catalog.items); $ids = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  $allIds = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  foreach ($item in $items) { if (-not $allIds.Add([string]$item.id)) { Add-RegistryFailure $failures 'DuplicateId' "$Kind/$($item.id)" } }
  if ($Kind -eq 'skills') {
    if ($null -eq $Inventory) { throw 'FAIL: skill canonical consistency requires the Phase 0 inventory' }
    $registeredSkillIds = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($item in $items) { $null = $registeredSkillIds.Add([string]$item.id) }
    $inventorySkillIds = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($item in @($Inventory.skills_inventory.canonical_skills)) { $null = $inventorySkillIds.Add([string]$item.id) }
    $governedProfileIds = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($skillId in $script:SkillHostFrontmatterProfileSkillIds) { $null = $governedProfileIds.Add([string]$skillId) }
    $guardComplete = $registeredSkillIds.Count -eq 22 -and $inventorySkillIds.Count -eq 22 -and $governedProfileIds.Count -eq 22 -and
      $registeredSkillIds.SetEquals($inventorySkillIds) -and $registeredSkillIds.SetEquals($governedProfileIds)
    if (-not $guardComplete) {
      Add-RegistryFailure $failures 'SkillHostFrontmatterProfileGuard' "registered=$($registeredSkillIds.Count) inventory=$($inventorySkillIds.Count) governed=$($governedProfileIds.Count) sets-equal=$($registeredSkillIds.SetEquals($inventorySkillIds) -and $registeredSkillIds.SetEquals($governedProfileIds))"
    }
  }
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
      $raw = Get-RegistrySkillSourceRaw -Path $body -Label $id -Failures $failures
      if ($null -eq $raw) { continue }
      $frontmatterShadow = Get-RegistrySkillFrontmatterShadow -Skill $item -Raw $raw
      foreach ($shadowFailure in $frontmatterShadow.Failures) { $failures.Add($shadowFailure) }
      $null = Get-RegistrySkillHostFrontmatterShadow -Skill $item -Inventory $Inventory -RepoRoot $RepoRoot -Failures $failures
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
      $duplicateRefs = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
      foreach ($reference in @($composition.references)) {
        $ref = [string]$reference
        if (-not $duplicateRefs.Add($ref)) { Add-RegistryFailure $failures 'DuplicateSemanticPart' "$cid/$ref" }
      }
      $isRuntimeComposition = $composition.PSObject.Properties['runtimeOnly'] -and [bool]$composition.runtimeOnly
      if ($isRuntimeComposition) {
        # Structural validation: references are already checked for non-empty and
        # uniqueness above. Cross-composition invariants (Cursor HybridRuleIds
        # order, Cursor binding set, OpenCode instruction/AGENTS sequence match)
        # are validated by Test-RegistryHostCompositionOwnership. No hardcoded
        # canonical reference sequence is maintained here; the registry
        # semanticOrder is the sole owner of runtime composition order.
        if ($cid -like 'cursor-*') {
          $ruleId = $cid.Substring('cursor-'.Length)
          if (-not $composition.PSObject.Properties['canonicalReferenceId'] -or
              [string]$composition.canonicalReferenceId -cne $ruleId) {
            Add-RegistryFailure $failures 'composition-order-ownership' "Cursor runtime '$cid' canonicalReferenceId does not match ID suffix '$ruleId'"
          }
        }
        continue
      }
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
      foreach ($reference in @($composition.references)) {
        $ref = [string]$reference
        $path = Get-RegistryCompositionReferencePath -Reference $ref -HostName ([string]$composition.host) -OverlayRoots $OverlayRoots
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
    Test-RegistryHostCompositionOwnership -Catalog $Catalog -RepoRoot $RepoRoot -Failures $failures
    # Phase 4D: runtimeOnly compositions that correspond to Phase 0 inventory
    # entries still account for their inventory counterparts. Antigravity
    # compositions migrated to runtimeOnly in Phase 4D consumed inventory
    # indices 1 and 2; match them by host + canonicalReferenceId-derived source.
    foreach ($composition in $comps) {
      $isRuntimeComposition = $composition.PSObject.Properties['runtimeOnly'] -and [bool]$composition.runtimeOnly
      if (-not $isRuntimeComposition) { continue }
      if (-not $composition.PSObject.Properties['canonicalReferenceId']) { continue }
      $derivedSource = "base:rules/$([string]$composition.canonicalReferenceId).md"
      for ($index = 0; $index -lt @($Inventory.rules_workflows.compositions).Count; $index++) {
        if ($consumedInventoryCompositions.Contains($index)) { continue }
        $inventoryComposition = $Inventory.rules_workflows.compositions[$index]
        if ([string]$inventoryComposition.host -eq [string]$composition.host -and
            [string]$inventoryComposition.canonical_source -eq $derivedSource) {
          $null = $consumedInventoryCompositions.Add($index)
          break
        }
      }
    }
    foreach ($index in @(0..(@($Inventory.rules_workflows.compositions).Count - 1))) {
      if (-not $consumedInventoryCompositions.Contains($index)) { Add-RegistryFailure $failures 'CompositionInventoryCoverage' "Phase 0 composition index $index is absent from registry" }
    }
    $alwaysOnHosts = [string[]]@('Cursor','OpenCode','Codex','Antigravity')
    $alwaysOnGates = [string[]]@('invocation','plan-review','code-review','pre-commit')
    $expectedSurfaces = @{
      'Cursor'      = [string[]]@('cursor-hybrid-rule')
      'OpenCode'    = [string[]]@('opencode-agents-dual-write','opencode-skill')
      'Codex'       = [string[]]@('codex-managed-block')
      'Antigravity' = [string[]]@('antigravity-gemini','antigravity-skill')
    }
    $expectedCanonicalRefs = @{
      'invocation'  = 'agent-invocation'
      'plan-review' = 'iterative-plan-review'
      'code-review' = 'iterative-code-review'
      'pre-commit'  = 'pre-commit-ci-gate'
    }
    $alwaysOnProps = $Catalog.PSObject.Properties['alwaysOn']
    $alwaysOnItems = if ($null -ne $alwaysOnProps) { @($alwaysOnProps.Value) } else { @() }
    if ($alwaysOnItems.Count -ne 16) { Add-RegistryFailure $failures 'AlwaysOnCoverage' "expected 16 policies, got $($alwaysOnItems.Count)" }
    $seenPairs = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($policy in $alwaysOnItems) {
      $policyId = [string]$policy.id; $hostName = [string]$policy.host; $gateName = [string]$policy.gate
      if ($hostName -notin $alwaysOnHosts) { Add-RegistryFailure $failures 'AlwaysOnInvalidHost' "$policyId host='$hostName'" }
      if ($gateName -notin $alwaysOnGates) { Add-RegistryFailure $failures 'AlwaysOnInvalidGate' "$policyId gate='$gateName'" }
      $pair = "${hostName}|${gateName}"
      if (-not $seenPairs.Add($pair)) { Add-RegistryFailure $failures 'AlwaysOnDuplicateHostGate' $pair }
      if ($policy.PSObject.Properties['surface']) {
        $surface = [string]$policy.surface
        if (-not ($expectedSurfaces.ContainsKey($hostName) -and $surface -in $expectedSurfaces[$hostName])) {
          Add-RegistryFailure $failures 'AlwaysOnInvalidSurface' "$policyId host='$hostName' surface='$surface'"
        }
      } else { Add-RegistryFailure $failures 'AlwaysOnMissingSurface' $policyId }
      if (-not $knownIds.Contains([string]$policy.canonicalReferenceId)) { Add-RegistryFailure $failures 'AlwaysOnInvalidCanonicalReference' "$policyId '$($policy.canonicalReferenceId)'" }
      if ($expectedCanonicalRefs.ContainsKey($gateName) -and [string]$policy.canonicalReferenceId -cne $expectedCanonicalRefs[$gateName]) {
        Add-RegistryFailure $failures 'AlwaysOnCanonicalReferenceMismatch' "$policyId gate='$gateName' ref='$($policy.canonicalReferenceId)' expected='$($expectedCanonicalRefs[$gateName])'"
      }
      if ($policy.PSObject.Properties['evidencePaths'] -and @($policy.evidencePaths).Count -gt 0) {
        foreach ($evidence in @($policy.evidencePaths)) { $null = Test-RegistryDescendantPath $RepoRoot ([string]$evidence) $failures "AlwaysOnEvidence:$policyId" -Leaf }
      } else { Add-RegistryFailure $failures 'AlwaysOnMissingEvidence' $policyId }
    }
    if ($alwaysOnItems.Count -eq 16 -and $seenPairs.Count -eq 16) {
      $inventoryAlwaysOnProps = $Inventory.rules_workflows.PSObject.Properties['always_on']
      $inventoryAlwaysOnItems = if ($null -ne $inventoryAlwaysOnProps) { @($inventoryAlwaysOnProps.Value) } else { @() }
      if ($inventoryAlwaysOnItems.Count -ne 16) { Add-RegistryFailure $failures 'AlwaysOnInventoryCoverage' "inventory expected 16 policies, got $($inventoryAlwaysOnItems.Count)" }
      else {
        $inventoryPairs = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
        foreach ($inventoryPolicy in $inventoryAlwaysOnItems) {
          $invHost = [string]$inventoryPolicy.host; $invGate = [string]$inventoryPolicy.gate
          $null = $inventoryPairs.Add("${invHost}|${invGate}")
        }
        if (-not $seenPairs.SetEquals($inventoryPairs)) {
          Add-RegistryFailure $failures 'AlwaysOnInventoryMismatch' "registry coverage '$(($seenPairs | Sort-Object) -join '|')' differs from inventory '$(($inventoryPairs | Sort-Object) -join '|')'"
        }
        foreach ($registryPolicy in $alwaysOnItems) {
          $matchedInventory = @($inventoryAlwaysOnItems | Where-Object { [string]$_.host -eq [string]$registryPolicy.host -and [string]$_.gate -eq [string]$registryPolicy.gate })
          if ($matchedInventory.Count -ne 1) { continue }
          $invPolicy = $matchedInventory[0]
          foreach ($field in @('id','surface','canonicalReferenceId')) {
            $registryValue = [string]$registryPolicy.$field
            $invProp = $invPolicy.PSObject.Properties[$field]
            $inventoryValue = if ($null -ne $invProp) { [string]$invProp.Value } else { '' }
            if ($registryValue -cne $inventoryValue) { Add-RegistryFailure $failures 'AlwaysOnInventoryMismatch' "$field registry='$registryValue' inventory='$inventoryValue'" }
          }
          $registryEvidence = @(Get-RegistrySequence $registryPolicy.evidencePaths)
          $invEvidenceProp = $invPolicy.PSObject.Properties['evidence_paths']
          $inventoryEvidence = if ($null -ne $invEvidenceProp) { @(Get-RegistrySequence $invEvidenceProp.Value) } else { @() }
          if (-not (Test-RegistrySequence $registryEvidence $inventoryEvidence)) { Add-RegistryFailure $failures 'AlwaysOnInventoryEvidenceMismatch' "$($registryPolicy.id) evidence differs from inventory" }
        }
      }
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
  param([Parameter(Mandatory)]$Catalogs,[Parameter(Mandatory)][string]$RepoRoot,$Resolver = (New-RegistryProjectionResolver),$Inventory = $null)
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
  $skillShadow = [System.Collections.Generic.List[string]]::new(); $skillShadow.Add("skill`tfrontmatterShadow`tcanonicalNewlines")
  foreach ($skill in $Catalogs.skills.items) {
    $renderFailures = [System.Collections.Generic.List[string]]::new()
    $skillRaw = Get-RegistrySkillSourceRaw -Path (Join-Path $RepoRoot ([string]$skill.body)) -Label ([string]$skill.id) -Failures $renderFailures
    if ($null -eq $skillRaw) { throw "FAIL: $($renderFailures[0])" }
    $shadow = Get-RegistrySkillFrontmatterShadow -Skill $skill -Raw $skillRaw
    $skillShadow.Add(($shadow.Id,$shadow.Status,$shadow.Newlines) -join "`t")
  }
  if ($null -eq $Inventory) {
    $inventoryPath = Join-Path $RepoRoot 'analysis/procedure-normalization-inventory-2026-09.json'
    try { $Inventory = Get-Content -Raw -LiteralPath $inventoryPath | ConvertFrom-Json } catch { throw "FAIL: invalid inventory: $($_.Exception.Message)" }
  }
  $wrapperShadow = [System.Collections.Generic.List[string]]::new(); $wrapperShadow.Add("skill`thost`twrapperShadow`twrapperSource")
  foreach ($skill in $Catalogs.skills.items) {
    $shadowFailures = [System.Collections.Generic.List[string]]::new()
    foreach ($row in (Get-RegistrySkillHostFrontmatterShadow -Skill $skill -Inventory $Inventory -RepoRoot $RepoRoot -Failures $shadowFailures)) {
      $wrapperShadow.Add(($row.Skill,$row.Host,$row.Status,$row.WrapperSource) -join "`t")
    }
    if ($shadowFailures.Count -gt 0) { throw "FAIL: $($shadowFailures[0])" }
  }
  $alwaysOnView = [System.Collections.Generic.List[string]]::new()
  $alwaysOnView.Add("host`tsurface`tdomain`tcanonicalReference`tpolicyId")
  $alwaysOnProps = $Catalogs.workflows.PSObject.Properties['alwaysOn']
  $alwaysOnItems = if ($null -ne $alwaysOnProps) { @($alwaysOnProps.Value) } else { @() }
  $alwaysOnGateOrder = [string[]]@('invocation','plan-review','code-review','pre-commit')
  $alwaysOnHostOrder = [string[]]@('Antigravity','Codex','Cursor','OpenCode')
  foreach ($hostName in $alwaysOnHostOrder) {
    foreach ($gateName in $alwaysOnGateOrder) {
      $policy = @($alwaysOnItems | Where-Object { [string]$_.host -eq $hostName -and [string]$_.gate -eq $gateName })[0]
      if ($null -eq $policy) { throw "FAIL: always-on view missing policy for host='$hostName' gate='$gateName'" }
      $alwaysOnView.Add(($hostName,[string]$policy.surface,$gateName,[string]$policy.canonicalReferenceId,[string]$policy.id) -join "`t")
    }
  }
  $files = [ordered]@{ 'identity.json' = $identityJson + "`n"; 'agent-parity.tsv' = ($parity -join "`n") + "`n"; 'composition-order.tsv' = ($composition -join "`n") + "`n"; 'skill-frontmatter-shadow.tsv' = ($skillShadow -join "`n") + "`n"; 'skill-host-frontmatter-shadow.tsv' = ($wrapperShadow -join "`n") + "`n"; 'always-on.tsv' = ($alwaysOnView -join "`n") + "`n" }
  $compositionFiles = Get-RegistryCompositionFiles -Catalogs $Catalogs -RepoRoot $RepoRoot -Inventory $Inventory
  foreach ($compositionKey in @($compositionFiles.Keys)) { $files[$compositionKey] = [string]$compositionFiles[$compositionKey] }
  [pscustomobject]@{ Files = $files }
}

function Get-RegistryCompositionFiles {
  <#
    Phase 4A deterministic composition renderer: for each registry composition,
    in registry-declared semantic order, resolves every registry-declared
    reference and concatenates the referenced leaf bodies. Fail-closed on
    missing/duplicate compositions, missing semantic order, unresolved
    references, or BOM-marked inputs. Output is managed-view-only; canonical
    and host files are never written by this function.
  #>
  param([Parameter(Mandatory)]$Catalogs,[Parameter(Mandatory)][string]$RepoRoot,$Inventory = $null)
  $workflowsProperty = $Catalogs.workflows.PSObject.Properties['compositions']
  $orderProperty = $Catalogs.workflows.PSObject.Properties['semanticOrder']
  if ($null -eq $workflowsProperty -or $null -eq $orderProperty) { throw 'FAIL: composition render requires registry-owned compositions and semanticOrder' }
  $comps = @($workflowsProperty.Value)
  $order = @(Get-RegistrySequence $orderProperty.Value)
  if ($order.Count -ne $comps.Count) { throw "FAIL: SemanticOrderCoverage: expected $($comps.Count), got $($order.Count)" }
  $compositionById = @{}
  foreach ($compositionItem in $comps) {
    $compositionId = [string]$compositionItem.id
    if ($compositionById.ContainsKey($compositionId)) { throw "FAIL: DuplicateCompositionId: $compositionId" }
    $compositionById[$compositionId] = $compositionItem
  }
  if ($null -eq $Inventory) {
    $inventoryPath = Join-Path $RepoRoot 'analysis/procedure-normalization-inventory-2026-09.json'
    try { $Inventory = Get-Content -Raw -LiteralPath $inventoryPath | ConvertFrom-Json } catch { throw "FAIL: invalid inventory: $($_.Exception.Message)" }
  }
  $overlayRoots = @{}
  foreach ($manifest in @($Inventory.manifests)) { $overlayRoots[[string]$manifest.host] = @{ Overlay = $manifest.overlay_root; Shared = $manifest.shared_root } }
  $files = [ordered]@{}
  foreach ($compositionId in $order) {
    if (-not $compositionById.ContainsKey($compositionId)) { throw "FAIL: SemanticOrderUnknownId: $compositionId" }
    $compositionItem = $compositionById[$compositionId]
    $null = $compositionById.Remove($compositionId)
    if ($compositionItem.PSObject.Properties['runtimeOnly'] -and [bool]$compositionItem.runtimeOnly) { continue }
    $parts = [System.Collections.Generic.List[string]]::new()
    $seenRefs = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($reference in @($compositionItem.references)) {
      $ref = [string]$reference
      if (-not $seenRefs.Add($ref)) { throw "FAIL: DuplicateSemanticPart: $compositionId/$ref" }
      $path = Get-RegistryCompositionReferencePath -Reference $ref -HostName ([string]$compositionItem.host) -OverlayRoots $overlayRoots
      $pathFailures = [System.Collections.Generic.List[string]]::new()
      $resolved = Test-RegistryDescendantPath $RepoRoot $path $pathFailures "SemanticReference:$compositionId" -Leaf
      if ($null -eq $resolved) { throw "FAIL: $($pathFailures[0])" }
      $readFailures = [System.Collections.Generic.List[string]]::new()
      $raw = Get-RegistrySkillSourceRaw -Path $resolved -Label "$compositionId/$ref" -Failures $readFailures
      if ($null -eq $raw) { throw "FAIL: $($readFailures[0])" }
      $parts.Add($raw)
    }
    $files["compositions/$compositionId.md"] = ($parts -join '')
  }
  foreach ($remaining in $compositionById.Keys) { throw "FAIL: SemanticOrderMissingId: $remaining" }
  return $files
}

function Get-RegistryCompositionOrderById {
  <# Returns the registry-owned reference sequence for one runtime composition. #>
  param([Parameter(Mandatory)]$Catalogs,[Parameter(Mandatory)][string]$CompositionId)
  $composition = @($Catalogs.workflows.compositions | Where-Object { [string]$_.id -eq $CompositionId })[0]
  if ($null -eq $composition) { throw "FAIL: CompositionOrderMissing: $CompositionId" }
  if (-not ($composition.PSObject.Properties['runtimeOnly'] -and [bool]$composition.runtimeOnly)) { throw "FAIL: CompositionOrderNotRuntimeOwned: $CompositionId" }
  return @(Get-RegistrySequence $composition.references)
}

function Test-RegistryCompositionOutputBoundary {
  <#
    Phase 4A fail-closed boundary verifier: no canonical body, overlay leaf,
    protected repository tree, or host projection may receive generated
    composition output. Temporary output under the OS temporary root passes.
  #>
  param([Parameter(Mandatory)][string]$OutputRoot,[Parameter(Mandatory)][string]$RepoRoot,[Parameter(Mandatory)]$Catalogs,$Inventory = $null)
  $full = [IO.Path]::GetFullPath($OutputRoot)
  $root = [IO.Path]::GetFullPath($RepoRoot).TrimEnd('\','/') + '\'
  $temporaryRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\','/') + '\'
  if ($full.StartsWith($temporaryRoot, [StringComparison]::OrdinalIgnoreCase)) { return }
  if (-not $full.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)) { throw "FAIL: CompositionOutputBoundary outside repository and temporary root: $OutputRoot" }
  $relative = $full.Substring($root.Length).Trim('\','/').Replace('/','\')
  if ($relative.Length -eq 0) { throw "FAIL: CompositionOutputBoundary rejects the repository root: $OutputRoot" }
  $relativeLower = $relative.ToLowerInvariant()
  $protectedTreeSegments = @('overlays','agents','skills','rules','workflow','docs','.git','.cursor','.config','catalog','scripts','instructions','config')
  foreach ($segment in @($relativeLower -split '[\\/]')) {
    if ($protectedTreeSegments -ccontains $segment) { throw "FAIL: CompositionOutputBoundary violates protected tree '$segment': $OutputRoot" }
  }
  foreach ($kind in @('agents','rules','skills','workflows')) {
    foreach ($item in @($Catalogs[$kind].items)) {
      $bodyLower = ([string]$item.body).Replace('/','\').ToLowerInvariant()
      if ($relativeLower -eq $bodyLower -or $relativeLower.StartsWith("$bodyLower\")) { throw "FAIL: CompositionOutputBoundary violates canonical body '$($item.body)': $OutputRoot" }
    }
  }
  if ($null -eq $Inventory) {
    $inventoryPath = Join-Path $RepoRoot 'analysis/procedure-normalization-inventory-2026-09.json'
    try { $Inventory = Get-Content -Raw -LiteralPath $inventoryPath | ConvertFrom-Json } catch { throw "FAIL: invalid inventory: $($_.Exception.Message)" }
  }
  foreach ($manifest in @($Inventory.manifests)) {
    foreach ($boundaryPath in @($manifest.overlay_root, $manifest.shared_root)) {
      if ([string]::IsNullOrWhiteSpace([string]$boundaryPath)) { continue }
      $boundaryLower = ([string]$boundaryPath).Replace('/','\').TrimEnd('\','/').ToLowerInvariant()
      if ($relativeLower -eq $boundaryLower -or $relativeLower.StartsWith("$boundaryLower\")) { throw "FAIL: CompositionOutputBoundary violates overlay leaf '$boundaryPath': $OutputRoot" }
    }
    foreach ($entry in @($manifest.entries)) {
      $destinationProperty = $entry.PSObject.Properties['destination']
      if ($null -eq $destinationProperty -or [string]::IsNullOrWhiteSpace([string]$destinationProperty.Value)) { continue }
      $destinationLower = ([string]$destinationProperty.Value).Replace('/','\').ToLowerInvariant()
      if ($relativeLower -eq $destinationLower -or $relativeLower.StartsWith("$destinationLower\")) { throw "FAIL: CompositionOutputBoundary violates host projection '$($destinationProperty.Value)': $OutputRoot" }
    }
  }
}

function Test-RegistryOutputRoot([string]$OutputRoot,[string]$RepoRoot,[switch]$AllowTemporaryRoot) {
  $forbidden = @('overlays','agents','skills','rules','workflow','docs','.git','.cursor','.config','instructions','config')
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
  param([Parameter(Mandatory)]$Catalogs,[Parameter(Mandatory)][string]$OutputRoot,[string]$RepoRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)),$Resolver = (New-RegistryProjectionResolver),$Inventory = $null,[switch]$AllowTemporaryRoot)
  Test-RegistryOutputRoot -OutputRoot $OutputRoot -RepoRoot $RepoRoot -AllowTemporaryRoot:$AllowTemporaryRoot
  if ($null -eq $Inventory) {
    $inventoryPath = Join-Path $RepoRoot 'analysis/procedure-normalization-inventory-2026-09.json'
    try { $Inventory = Get-Content -Raw -LiteralPath $inventoryPath | ConvertFrom-Json } catch { throw "FAIL: invalid inventory: $($_.Exception.Message)" }
  }
  Test-RegistryCompositionOutputBoundary -OutputRoot $OutputRoot -RepoRoot $RepoRoot -Catalogs $Catalogs -Inventory $Inventory
  $view = Get-RegistryManagedView -Catalogs $Catalogs -RepoRoot $RepoRoot -Resolver $Resolver -Inventory $Inventory
  New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
  $encoding = [System.Text.UTF8Encoding]::new($false)
  foreach ($file in $view.Files.GetEnumerator()) {
    $filePath = Join-Path $OutputRoot $file.Key
    $fileDir = Split-Path -Parent $filePath
    if (-not (Test-Path -LiteralPath $fileDir)) { New-Item -ItemType Directory -Force -Path $fileDir | Out-Null }
    [IO.File]::WriteAllText($filePath, [string]$file.Value, $encoding)
  }
  return $view
}

Export-ModuleMember -Function @('Test-ProcedureRegistryCatalogs','Test-RegistryCatalog','New-RegistryProjectionResolver','Resolve-RegistryProjection','Get-RegistryManagedView','Write-RegistryManagedView','Test-RegistryOutputRoot','Get-RegistryCompositionReferencePath','Get-RegistryCompositionFiles','Get-RegistryCompositionOrderById','Test-RegistryCompositionOutputBoundary','Get-StackManifestDestinationCount','Get-RegistrySkillFrontmatter','Get-RegistrySkillCanonicalFrontmatter','Get-RegistryComparableFrontmatter','Get-RegistrySkillSourceRaw','Get-RegistrySkillFrontmatterShadow','Get-RegistrySkillWrapperFrontmatterShadow','Get-RegistrySkillWrapperSourcePath','Get-RegistrySkillHostFrontmatterShadow')
