#Requires -Version 7.4
<#
.SYNOPSIS
    Read-only Phase 0 current-state and fixture invariant checks.
.DESCRIPTION
    Fails closed on inventory/manifest/Markdown inconsistency or missing
    referenced evidence. Performs no live host writes and no repository writes.
#>
param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path,
    [string]$InventoryJsonPath = '',
    [string]$InventoryMdPath = ''
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'ProcedureRegistry.psm1') -Force
Import-Module (Join-Path $PSScriptRoot 'LocalScratch.psm1') -Force
$JsonPath = if ($InventoryJsonPath) { $InventoryJsonPath } else { Join-Path $RepoRoot 'analysis' 'procedure-normalization-inventory-2026-09.json' }
$MdPath = if ($InventoryMdPath) { $InventoryMdPath } else { Join-Path $RepoRoot 'analysis' 'procedure-normalization-inventory-2026-09.md' }
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
function Compare-Arr($A,$E,[string]$Inv,[string]$Name) {
    $a = @($A); $e = @($E)
    if ($a.Count -ne $e.Count) { Add-Failure $Inv "$Name count differs (expected $($e.Count), got $($a.Count))"; return }
    for ($i = 0; $i -lt $e.Count; $i++) { if ("$($a[$i])" -ne "$($e[$i])") { Add-Failure $Inv "$Name row $i differs" } }
}
function Get-SourceProp($Obj,[string]$Prop) {
    if ($null -eq $Obj) { return $null }
    $p = $Obj.PSObject.Properties[$Prop]
    if ($null -eq $p) { return $null }
    return $p.Value
}
function Get-MarkdownTableRows([string]$Text,[string]$ExpectedHeader) {
    $lines = @($Text -split "`r?`n")
    $headerIndex = -1
    for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i] -eq $ExpectedHeader) { $headerIndex = $i; break } }
    if ($headerIndex -lt 0 -or $headerIndex + 2 -ge $lines.Count) { return $null }
    $result = [System.Collections.Generic.List[string]]::new()
    for ($i = $headerIndex + 2; $i -lt $lines.Count -and $lines[$i].StartsWith('|'); $i++) { $result.Add($lines[$i]) }
    return $result
}
function Get-ManifestFieldValue($Manifest,[string]$Name) {
    if (-not $Manifest.Contains($Name)) { return @{ Present = $false; Value = $null } }
    return @{ Present = $true; Value = $Manifest[$Name] }
}

foreach ($p in @($JsonPath,$MdPath)) { if (-not (Test-Path -LiteralPath $p -PathType Leaf)) { Write-Error "FAIL: Missing $p"; exit 1 } }
try { $j = Get-Content -Raw -LiteralPath $JsonPath | ConvertFrom-Json } catch { Write-Error "FAIL: Invalid JSON: $($_.Exception.Message)"; exit 1 }
$md = Get-Content -Raw -LiteralPath $MdPath
$hosts = @('Cursor','OpenCode','Antigravity','Vscode','Cline','Kilocode','Codex')
$agents = @('planner','plan_reviewer','implementer','production_readiness_reviewer','bug_reviewer','repository_explorer','test_reviewer')

# Representation taxonomy: exactly 4
$reps = @('native-definition','generated-native-projection','fallback-launch-contract','missing')
if ($j.representation_values.Count -ne 4) { Add-Failure 'RepresentationCount' "expected 4, got $($j.representation_values.Count)" }
foreach ($r in $reps) { if ($r -notin $j.representation_values) { Add-Failure 'RepresentationEnum' "missing '$r'" } }

# Status
if ($j.schema_version -ne 2) { Add-Failure 'SchemaVersion' "expected 2" }
if ($j.status -ne 'implementation-under-review') { Add-Failure 'Status' 'wrong' }
if ($j.review_iteration -ne 3) { Add-Failure 'ReviewIteration' "expected 3, got $($j.review_iteration)" }

# Inventory dates: inventory_date is the immutable Phase 0 snapshot; last_updated
# records later maintenance. Both are required, must parse as ISO calendar dates,
# and must stay ordered. Presence is not optional.
$snapshotDate = [string](Get-SourceProp $j 'inventory_date')
$lastUpdated = [string](Get-SourceProp $j 'last_updated')
if ($snapshotDate -ne '2026-09-11') { Add-Failure 'InventorySnapshotDate' "expected '2026-09-11', got '$snapshotDate'" }
$parsedSnapshot = [datetime]::MinValue; $parsedUpdated = [datetime]::MinValue
$snapshotParsed = [datetime]::TryParseExact($snapshotDate, 'yyyy-MM-dd', [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::None, [ref]$parsedSnapshot)
$updatedParsed = [datetime]::TryParseExact($lastUpdated, 'yyyy-MM-dd', [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::None, [ref]$parsedUpdated)
if (-not $updatedParsed) { Add-Failure 'InventoryLastUpdatedFormat' "invalid ISO calendar date '$lastUpdated'" }
elseif (-not $snapshotParsed -or $parsedUpdated -lt $parsedSnapshot) { Add-Failure 'InventoryLastUpdatedFormat' "last_updated '$lastUpdated' predates snapshot '$snapshotDate'" }
if (($j.hosts | Sort-Object) -join '|' -ne (($hosts | Sort-Object) -join '|')) { Add-Failure 'HostSet' 'differs' }
if (($j.governed_agents | Sort-Object) -join '|' -ne (($agents | Sort-Object) -join '|')) { Add-Failure 'AgentSet' 'differs' }
if ($j.parity_matrix.Count -ne 49) { Add-Failure 'CartesianCoverage' "expected 49, got $($j.parity_matrix.Count)" }

# Parity rows
$rows = @{}; foreach ($p in $j.parity_matrix) { $k = "$($p.host)|$($p.agent)"; if ($rows.ContainsKey($k)) { Add-Failure 'DuplicatePair' $k } else { $rows[$k] = $p } }
foreach ($h in $hosts) { foreach ($a in $agents) { if (-not $rows.ContainsKey("$h|$a")) { Add-Failure 'MissingPair' "$h|$a" } } }

$proposals = @('native','fresh-task-session-fallback','retain-fallback-with-explicit-envelope-and-isolation')
$auths = @('read-only','workspace-write','read-only (sandbox_mode)','workspace-write (sandbox_mode)')
$isoVals = @('clean-context','fresh task/session per pass')
$clsVals = @('host wrapper','generated output','intentional host deviation','primary-mode definition','fallback contract')
$canonicalReading = $j.canonical_required_reading
# Assert authoritative expected lists (not just self-comparison)
$expectedReading = @{
    'planner' = @('workflow/agent-invocation.md','agents/planner.md','skills/implementation-plan/SKILL.md')
    'plan_reviewer' = @('workflow/agent-invocation.md','agents/plan_reviewer.md','workflow/plan-reviewer-report.md','skills/implementation-plan/SKILL.md')
    'implementer' = @('workflow/agent-invocation.md','agents/implementer.md')
    'production_readiness_reviewer' = @('workflow/agent-invocation.md','agents/production_readiness_reviewer.md')
    'bug_reviewer' = @('workflow/agent-invocation.md','agents/bug_reviewer.md','docs/featureArchitecture/bug-reviewer-finding-rubric.md','skills/bug-review-sweep/SKILL.md')
    'repository_explorer' = @('workflow/agent-invocation.md','agents/repository_explorer.md')
    'test_reviewer' = @('workflow/agent-invocation.md','agents/test_reviewer.md')
}
foreach ($agentName in $expectedReading.Keys) {
    if (-not $canonicalReading.PSObject.Properties[$agentName]) { Add-Failure 'CanonicalReadingMissing' $agentName; continue }
    Compare-Arr $canonicalReading.($agentName) $expectedReading[$agentName] 'CanonicalReadingMismatch' $agentName
}

foreach ($p in $j.parity_matrix) {
    $k = "$($p.host)|$($p.agent)"
    if ($p.canonical_identity -ne $p.agent) { Add-Failure 'CanonicalIdentity' "${k}: $($p.canonical_identity) != $($p.agent)" }
    if ($p.representation -notin $reps) { Add-Failure 'RepresentationValue' "$k=$($p.representation)"; continue }
    if ($p.representation -eq 'missing') {
        if ($p.proposed_phase2_representation -notin $proposals) { Add-Failure 'ProposalValue' "$k=$($p.proposed_phase2_representation)" }
        foreach ($f in @('canonical_identity','first_read_contract','proposed_phase2_representation')) { if ([string]::IsNullOrWhiteSpace([string]$p.$f)) { Add-Failure 'MissingRowField' "$k.$f" } }
    } else {
        foreach ($f in @('canonical_identity','route_identity','authority','isolation','first_read_contract','launch_mechanism','classification')) { if ([string]::IsNullOrWhiteSpace([string]$p.$f)) { Add-Failure 'RepresentedRowField' "$k.$f" } }
        if ($p.authority -and $p.authority -notin $auths) { Add-Failure 'AuthorityEnum' "$k=$($p.authority)" }
        if ($p.isolation -and $p.isolation -notin $isoVals) { Add-Failure 'IsolationEnum' "$k=$($p.isolation)" }
        if ($p.classification -and $p.classification -notin $clsVals) { Add-Failure 'ClassificationEnum' "$k=$($p.classification)" }
        if (@($p.evidence_paths).Count -lt 1) { Add-Failure 'RepresentedEvidence' $k }
    }
    if ($null -eq (Get-SourceProp $p 'required_reading')) { Add-Failure 'RequiredReadingMissing' $k }
    elseif ($canonicalReading.PSObject.Properties[$p.agent]) { Compare-Arr $p.required_reading $canonicalReading.($p.agent) 'RequiredReadingMismatch' $k }
    foreach ($f in @('canonical_identity','evidence_paths','first_read_contract')) { if ($null -eq $p.$f) { Add-Failure 'RequiredField' "$k.$f" } }
    foreach ($e in @($p.evidence_paths)) { if ($e -match "/$") { Test-RepoPath $e "PairEvidence[$k]" -Directory } else { Test-RepoPath $e "PairEvidence[$k]" } }
}

# Ambiguity truth: an open owner question may reference only pairs that are
# still missing in the parity matrix. A represented pair (or an unknown pair)
# listed as pending reopens settled work and fails closed.
foreach ($a in @($j.ambiguities_requiring_owner_confirmation)) {
    $aid = [string]$a.id
    if ([string]::IsNullOrWhiteSpace($aid)) { Add-Failure 'AmbiguityIdentity' 'missing id'; continue }
    $pendingProp = $a.PSObject.Properties['pending_missing_pairs']
    if ($null -eq $pendingProp) { Add-Failure 'AmbiguityPendingPairsMissing' $aid; continue }
    $pending = @($pendingProp.Value)
    foreach ($pair in @($pending)) {
        $pk = "$($pair.host)|$($pair.agent)"
        if (-not $rows.ContainsKey($pk)) { Add-Failure 'AmbiguityPendingPairUnknown' "$aid -> $pk"; continue }
        if ($rows[$pk].representation -ne 'missing') { Add-Failure 'AmbiguityPendingPairRepresented' "$aid -> $pk is $($rows[$pk].representation)" }
    }
}

# Counts
$actualMissing = @($j.parity_matrix | Where-Object representation -eq 'missing')
if ($j.missing_count -ne $actualMissing.Count -or $j.represented_count -ne (49 - $actualMissing.Count) -or $j.total_pairs -ne 49) { Add-Failure 'ParityCounts' 'wrong' }
$expMissing = @($actualMissing | ForEach-Object { [pscustomobject]@{host=$_.host;agent=$_.agent;proposed_phase2=$_.proposed_phase2_representation} })
$decMissing = @($j.missing_pairs_with_proposed_phase2)
if ($decMissing.Count -ne $expMissing.Count) { Add-Failure 'MissingPairCount' "expected $($expMissing.Count), got $($decMissing.Count)" }
else { for ($i = 0; $i -lt $expMissing.Count; $i++) { foreach ($f in @('host','agent','proposed_phase2')) { if ($expMissing[$i].$f -ne $decMissing[$i].$f) { Add-Failure 'MissingPairAgreement' "row $i $f" } } } }

# Manifests: coverage + current-source validation
$manifestRows = @{}
$manifestSummary = @{}
try { $currentManifests = @(Get-RegistryManifests -RepoRoot $RepoRoot) } catch { Add-Failure 'ManifestCurrentSource' $_.Exception.Message; $currentManifests = @() }
if ($currentManifests.Count -ne 7) { Add-Failure 'ManifestCoverage' "expected 7, got $($currentManifests.Count)" }
foreach ($m in $currentManifests) {
    if ($manifestRows.ContainsKey($m.host)) { Add-Failure 'DuplicateManifestHost' $m.host } else { $manifestRows[$m.host] = $m }
    Test-RepoPath $m.path "ManifestPath[$($m.host)]"
}
foreach ($h in $hosts) {
    if (-not $manifestRows.ContainsKey($h)) { Add-Failure 'ManifestHostMissing' $h; continue }
    $m = $manifestRows[$h]
    $actualEntries = @($m.entries)
    $expectedModel = if ($h -eq 'Codex') { 'codex-two-logical-roots' } else { 'single-root' }
    if ($m.binding_model -ne $expectedModel) { Add-Failure 'BindingModel' "$h expected '$expectedModel', got '$($m.binding_model)'" }
    if ($h -ne 'Codex') {
        if ($null -ne $m.logical_roots) { Add-Failure 'BindingModelShape' "$h is single-root but current manifest logical_roots is populated" }
    } else {
        if (($m.logical_roots -join '|') -ne 'codex-home|skill-root') { Add-Failure 'CodexLogicalRoots' ($m.logical_roots -join '|') }
    }

    foreach ($boundaryList in @(@('HardExcludes',$m.hard_excludes),@('NeverTouch',$m.never_touch))) {
        $seen = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
        foreach ($boundary in @($boundaryList[1])) { if (-not $seen.Add([string]$boundary)) { Add-Failure "Manifest$($boundaryList[0])Duplicate" "$h '$boundary'" } }
    }

    if ($m.copy_entry_count -ne $actualEntries.Count) { Add-Failure 'ManifestEntryCount' "$h expected $($actualEntries.Count), normalized $($m.copy_entry_count)" }
    $hybrid = @($m.hybrid_rule_ids)
    $manifestSummary[$h] = @{
        host = $h
        path = $m.path
        binding_model = $m.binding_model
        copy_entry_count = $actualEntries.Count
        hard_excludes = @($m.hard_excludes).Count
        never_touch = @($m.never_touch).Count
        hybrid_rule_ids = $hybrid.Count
    }

    # Current source-state manifest agreement: every native wrapper named by a
    # represented parity row must be delivered exactly once by its host
    # manifest.
    foreach ($p in @($j.parity_matrix | Where-Object { $_.host -eq $h -and $_.representation -eq 'native-definition' })) {
        $wrapper = @(@($p.evidence_paths) | Where-Object { $_.StartsWith(($m.overlay_root.TrimEnd('/','\') + '/'), [StringComparison]::OrdinalIgnoreCase) } | Select-Object -First 1)
        if ($wrapper.Count -ne 1) { continue }
        $expectedSource = $wrapper[0].Substring($m.overlay_root.TrimEnd('/','\').Length + 1).Replace('\','/')
        $matches = @(@($m.entries) | Where-Object { "$($_.source)" -ceq $expectedSource })
        if ($matches.Count -ne 1) { Add-Failure 'NativeManifestEntry' "$h|$($p.agent) expected source '$expectedSource', found $($matches.Count)" }
    }

    if ($h -eq 'OpenCode') {
        if (-not $m.agents_dual_write -or $m.agents_dual_write.instructions_rel -ne 'instructions/cursor-escape-loop.md') { Add-Failure 'OpenCodeDualWrite' }
        if (-not $m.json_merge -or $m.json_merge.specimen_rel -ne 'opencode.specimen.json') { Add-Failure 'OpenCodeJsonMerge' }
    }
    if ($h -eq 'Codex') {
        if ([string]$m.ownership_marker -ne 'cursorEscape-managed:v1') { Add-Failure 'CodexManifestPolicy' 'ownership_marker' }
        if ([string]$m.managed_block_marker -ne 'cursorEscape-managed-block:v1') { Add-Failure 'CodexManifestPolicy' 'managed_block_marker' }
        if ([int]$m.skill_catalog_budget_characters -ne 8000) { Add-Failure 'CodexManifestPolicy' 'skill_catalog_budget_characters' }
        if (@($m.overlay_only_skill_metadata).Count -ne 2) { Add-Failure 'CodexExplicitOnlyCount' }
        foreach ($x in @($m.overlay_only_skill_metadata)) { Test-RepoPath (Join-Path $m.overlay_root $x.relative_path) 'CodexExplicitOnlyMetadata' }
    }
}
# Compositions: bidirectional exact equivalence
$comps = @($j.rules_workflows.compositions)
if ($comps.Count -lt 1) { Add-Failure 'CompositionCoverage' 'none' }
# Build manifest compositions (entries with parts or footer)
$manifestComps = @{}
foreach ($h in $hosts) { if (-not $manifestRows.ContainsKey($h)) { continue }
    $m = $manifestRows[$h]
    foreach ($entry in @($m.entries)) {
        if ($h -eq 'Codex' -and "$($entry.destination)" -eq 'AGENTS.md') { continue }
        $p = Get-SourceProp $entry 'parts'; $f = Get-SourceProp $entry 'footer'
        $hp = $null -ne $p -and @($p).Count -gt 0; $hf = $null -ne $f -and @($f).Count -gt 0
        if ($hp -or $hf) { $manifestComps["$h|$($entry.destination)"] = $entry }
    }
}
$invCompKeys = @{}
foreach ($c in $comps) {
    foreach ($f in @('host','canonical_source','destination','parts','footer','composition_order','evidence_paths')) { if ($null -eq ($c.PSObject.Properties[$f])) { Add-Failure 'CompositionField' "$($c.host):$f" } }
    $ck = "$($c.host)|$($c.destination)"; $invCompKeys[$ck] = $c
    if (-not $manifestComps.ContainsKey($ck)) { Add-Failure 'CompositionInvented' $ck; continue }
    $mc = $manifestComps[$ck]
    $mcSrc = Get-SourceProp $mc 'source'
    if ("$($c.canonical_source)" -ne "$mcSrc") { Add-Failure 'CompositionSource' "$ck" }
    $mcP = Get-SourceProp $mc 'parts'; $mcP = if ($null -ne $mcP) { @($mcP) } else { @() }
    $cP = Get-SourceProp $c 'parts'; $cP = if ($null -ne $cP) { @($cP) } else { @() }
    Compare-Arr $cP $mcP "CompositionParts[$ck]" $c.host
    $mcF = Get-SourceProp $mc 'footer'; $mcF = if ($null -ne $mcF) { @($mcF) } else { @() }
    $cF = Get-SourceProp $c 'footer'; $cF = if ($null -ne $cF) { @($cF) } else { @() }
    Compare-Arr $cF $mcF "CompositionFooter[$ck]" $c.host
    $expOrder = @($mcP) + @($mcSrc) + @($mcF)
    $cO = Get-SourceProp $c 'composition_order'; $cO = if ($null -ne $cO) { @($cO) } else { @() }
    Compare-Arr $cO $expOrder "CompositionOrder[$ck]" $c.host
}
foreach ($ck in $manifestComps.Keys) { if (-not $invCompKeys.ContainsKey($ck)) { Add-Failure 'CompositionMissing' $ck } }

# Skills
if (@($j.skills_inventory.canonical_skills).Count -ne 22 -or $j.skills_inventory.skill_count_canonical -ne 22 -or $j.skills_inventory.skill_count_total_with_generated -ne 23) { Add-Failure 'SkillCounts' }
$skillManifestEvidence = @{}
foreach ($h in $hosts) { if (-not $manifestRows.ContainsKey($h)) { continue }
    $m = $manifestRows[$h]; $dist = @{}
    foreach ($entry in @($m.entries)) {
        $src = Get-SourceProp $entry 'source'; $dst = $entry.destination
        if ($src) { $clean = $src; if ($clean.StartsWith('base:')) { $clean = $clean.Substring(5) } elseif ($clean.StartsWith('shared:')) { $clean = $clean.Substring(7) }; if ($clean -match '^skills/([^/]+)/SKILL\.md$') { $dist[$Matches[1]] = @{source=$src;destination=$dst} } }
        if ($dst -match '(?:^|/)([^/]+)/SKILL\.md$') { if (-not $dist.ContainsKey($Matches[1])) { $dist[$Matches[1]] = @{source=$src;destination=$dst} } }
    }
    $skillManifestEvidence[$h] = $dist
}
foreach ($s in @($j.skills_inventory.canonical_skills)) {
    Test-RepoPath $s.source "CanonicalSkill[$($s.id)]"
    if (@($s.host_applicability).Count -ne 7) { Add-Failure 'SkillHostCoverage' "$($s.id) expected 7, got $(@($s.host_applicability).Count)" }
    $seen = @{}
    foreach ($x in @($s.host_applicability)) {
        if ($seen.ContainsKey($x.host)) { Add-Failure 'DuplicateSkillHost' "$($s.id)/$($x.host)" }; $seen[$x.host] = 1
        if ($x.status -notin @('applicable','not-applicable')) { Add-Failure 'SkillApplicabilityValue' "$($s.id)/$($x.host)=$($x.status)" }
        $mEntry = $null
        if ($skillManifestEvidence.ContainsKey($x.host) -and $skillManifestEvidence[$x.host].ContainsKey($s.id)) { $mEntry = $skillManifestEvidence[$x.host][$s.id] }
        if ($x.status -eq 'applicable' -and $null -eq $mEntry) { Add-Failure 'SkillAppNoEvidence' "$($s.id)/$($x.host)" }
        if ($x.status -eq 'not-applicable' -and $null -ne $mEntry) { Add-Failure 'SkillAppMismatch' "$($s.id)/$($x.host)" }
        if ($x.status -eq 'applicable' -and $null -ne $mEntry) {
        $xSrc = Get-SourceProp $x 'source'; $xDst = Get-SourceProp $x 'destination'
        if ([string]::IsNullOrWhiteSpace([string]$xSrc) -or [string]::IsNullOrWhiteSpace([string]$xDst)) { Add-Failure 'SkillAppMissingEvidence' "$($s.id)/$($x.host)" }
        elseif ("$($mEntry.source)" -ne "$xSrc" -or "$($mEntry.destination)" -ne "$xDst") { Add-Failure 'SkillAppSrcDestMismatch' "$($s.id)/$($x.host) expected src='$($mEntry.source)' dst='$($mEntry.destination)' got src='$xSrc' dst='$xDst'" }
        $resolvedSrc = if ("$xSrc".StartsWith('base:')) { "$xSrc".Substring(5) } elseif ("$xSrc".StartsWith('shared:')) { 'overlays/opencode/' + "$xSrc".Substring(7) } elseif ("$xSrc" -match '^(overlays|scripts|analysis|docs|skills|agents|workflow|rules)/') { $xSrc } else { "$($m.overlay_root)/$xSrc" }
        Test-RepoPath $resolvedSrc "SkillAppSrcPath[$($s.id)/$($x.host)]"
        }
        if ($x.status -eq 'applicable') { if ($null -eq (Get-SourceProp $x 'source') -or $null -eq (Get-SourceProp $x 'destination')) { Add-Failure 'SkillAppMissingEvidence' "$($s.id)/$($x.host)" } }
        foreach ($e in @($x.evidence_paths)) { Test-RepoPath $e "SkillEvidence[$($s.id)/$($x.host)]" }
    }
    foreach ($h in $hosts) { if (-not $seen.ContainsKey($h)) { Add-Failure 'SkillHostMissing' "$($s.id)/$h" } }
}
$grw = $j.skills_inventory.generated_rule_wrapper
if ($grw) { foreach ($x in @($grw.host_applicability)) { $mSays = $skillManifestEvidence.ContainsKey($x.host) -and $skillManifestEvidence[$x.host].ContainsKey('pre-commit-ci-gate'); if ($x.status -eq 'applicable' -and -not $mSays) { Add-Failure 'GenWrapperNoEvidence' $x.host }; if ($x.status -eq 'not-applicable' -and $mSays) { Add-Failure 'GenWrapperMismatch' $x.host } } }

# Rules/workflows
foreach ($r in @($j.rules_workflows.canonical_rules)) { Test-RepoPath $r.source 'CanonicalRule' }
foreach ($w in @($j.rules_workflows.canonical_workflows)) { Test-RepoPath $w.source 'CanonicalWorkflow' }

# Operator matrix
if (@($j.operator_matrix).Count -ne 7) { Add-Failure 'OperatorCoverage' }
$opHosts = @{}
foreach ($o in $j.operator_matrix) { if ($opHosts.ContainsKey($o.host)) { Add-Failure 'DuplicateOperatorHost' $o.host }; $opHosts[$o.host] = 1; foreach ($x in @($o.lifecycle_evidence -split ';')) { Test-RepoPath $x.Trim() "OperatorEvidence[$($o.host)]" }; foreach ($f in @('restart_reload','smoke_check','recovery_owner')) { if ([string]::IsNullOrWhiteSpace($o.$f)) { Add-Failure 'OperatorField' "$($o.host).$f" } } }
if (($opHosts.Keys | Sort-Object) -join '|' -ne (($hosts | Sort-Object) -join '|')) { Add-Failure 'OperatorHostSet' }

# Baselines
$b = $j.render_baselines
Test-RepoPath $b.codex_render_plan_path 'RenderPlanPath'; Test-RepoPath $b.codex_physical_fixture_root 'FixtureRoot' -Directory
$render = Get-Content -Raw (Join-Path $RepoRoot $b.codex_render_plan_path) | ConvertFrom-Json
if ($b.codex_rendered_destination_count -ne $render.entries.Count) { Add-Failure 'CodexRenderedCount' }
$phys = @(Get-ChildItem -LiteralPath (Join-Path $RepoRoot $b.codex_physical_fixture_root) -Recurse -File | ForEach-Object { $_.FullName.Substring($RepoRoot.Length+1).Replace('\','/') } | Sort-Object)
$decFix = @($b.codex_physical_fixture_files | Sort-Object)
if ($phys.Count -ne $decFix.Count -or (ConvertTo-Json $phys -Compress) -ne (ConvertTo-Json $decFix -Compress)) { Add-Failure 'CodexFixtureLeaves' }
if ($b.codex_physical_fixture_count -ne $phys.Count) { Add-Failure 'CodexFixtureCount' }
if (@($b.codex_explicit_only_openai_metadata_files).Count -ne 2) { Add-Failure 'ExplicitOnlyMetadataCount' }
foreach ($x in @($b.codex_explicit_only_openai_metadata_files) + $decFix) { Test-RepoPath $x 'BaselineFixturePath' }
# Markdown/JSON consistency
if ($md -notmatch [regex]::Escape('| Total pairs | 49 |')) { Add-Failure 'MarkdownTotalPairs' }
if ($snapshotDate -and -not ($md -match [regex]::Escape("**Snapshot date:** $snapshotDate"))) { Add-Failure 'MarkdownInventorySnapshotDate' "expected '$snapshotDate'" }
if ($lastUpdated -and -not ($md -match [regex]::Escape("**Last updated:** $lastUpdated"))) { Add-Failure 'MarkdownInventoryLastUpdated' "expected '$lastUpdated'" }
if (-not ($md -match [regex]::Escape("| Represented | $($j.represented_count) |"))) { Add-Failure 'MarkdownRepresented' }
if (-not ($md -match [regex]::Escape("| Missing | $($j.missing_count) |"))) { Add-Failure 'MarkdownMissing' }
foreach ($h in $hosts) { $hr = @($j.parity_matrix | Where-Object host -eq $h); $n = @($hr | Where-Object representation -eq 'native-definition').Count; $g = @($hr | Where-Object representation -eq 'generated-native-projection').Count; $fb = @($hr | Where-Object representation -eq 'fallback-launch-contract').Count; $ms = @($hr | Where-Object representation -eq 'missing').Count; if ($md -notmatch [regex]::Escape("| $h | $n | $g | $fb | $ms |")) { Add-Failure 'MarkdownMatrixRow' $h } }
foreach ($x in $j.missing_pairs_with_proposed_phase2) { $row = "| $($x.host) | ``$($x.agent)`` | ``$($x.proposed_phase2)`` |"; if (-not $md.Contains($row)) { Add-Failure 'MarkdownMissingPair' "$($x.host)/$($x.agent)" } }

# Ambiguity IDs must agree exactly between JSON and the Markdown table.
$ambiguityHeader = '| ID | Question |'
$ambiguityRows = @(Get-MarkdownTableRows $md $ambiguityHeader)
$mdAmbiguityIds = @($ambiguityRows | ForEach-Object { @($_.Trim('|').Split('|'))[0].Trim() } | Where-Object { $_ })
$jsonAmbiguityIds = @($j.ambiguities_requiring_owner_confirmation | ForEach-Object { [string]$_.id })
if ($mdAmbiguityIds.Count -ne $jsonAmbiguityIds.Count) { Add-Failure 'MarkdownAmbiguityCount' "expected $($jsonAmbiguityIds.Count), got $($mdAmbiguityIds.Count)" }
else { for ($i = 0; $i -lt $jsonAmbiguityIds.Count; $i++) { if ($mdAmbiguityIds[$i] -cne $jsonAmbiguityIds[$i]) { Add-Failure 'MarkdownAmbiguityId' "row $i expected '$($jsonAmbiguityIds[$i])', got '$($mdAmbiguityIds[$i])'" } } }

# Manifest summary: every Markdown column is checked against inventory and the
# parsed manifest. Table order also makes the reverse direction exact.
$summaryHeader = '| Host | Manifest | Binding model | Copy/Destination entries | HardExcludes | NeverTouch | HybridRuleIds |'
$summaryRows = @(Get-MarkdownTableRows $md $summaryHeader)
if ($summaryRows.Count -ne 7) { Add-Failure 'MarkdownManifestTable' "expected 7 rows, got $($summaryRows.Count)" }
else {
    for ($i = 0; $i -lt 7; $i++) {
        $cells = @($summaryRows[$i].Trim('|').Split('|') | ForEach-Object { $_.Trim() })
        $s = $manifestSummary[$hosts[$i]]
        $expected = @(
            $s.host
            ('`' + $s.path + '`')
            ('`' + $s.binding_model + '`')
            "$($s.copy_entry_count)"
            "$($s.hard_excludes)"
            "$($s.never_touch)"
            "$($s.hybrid_rule_ids)"
        )
        if ($cells.Count -ne $expected.Count) { Add-Failure 'MarkdownManifestColumns' "$($hosts[$i]) expected $($expected.Count), got $($cells.Count)"; continue }
        for ($c = 0; $c -lt $expected.Count; $c++) { if ($cells[$c] -ne $expected[$c]) { Add-Failure 'MarkdownManifestSummary' "$($hosts[$i]) column $($c + 1): expected '$($expected[$c])', got '$($cells[$c])'" } }
    }
}
$rc = @($j.rules_workflows.canonical_rules).Count; $wc = @($j.rules_workflows.canonical_workflows).Count; $cc = $comps.Count
if ($md -notmatch [regex]::Escape("Canonical rules: **$rc**")) { Add-Failure 'MarkdownRuleCount' "expected $rc" }
if ($md -notmatch [regex]::Escape("Canonical workflows: **$wc**")) { Add-Failure 'MarkdownWorkflowCount' "expected $wc" }
if ($md -notmatch [regex]::Escape("compositions: **$cc**")) { Add-Failure 'MarkdownCompositionCount' "expected $cc" }
if ($md -notmatch [regex]::Escape('**22 canonical skills**')) { Add-Failure 'MarkdownSkillCanonical' }
if ($md -notmatch [regex]::Escape('**1 generated rule wrapper**')) { Add-Failure 'MarkdownSkillGenerated' }
if ($md -notmatch [regex]::Escape('23 advertised')) { Add-Failure 'MarkdownSkillTotal' }
if ($md -notmatch [regex]::Escape('six historical restore directories')) { Add-Failure 'MarkdownBaselineSix' }
if ($md -notmatch [regex]::Escape('31 rendered destinations')) { Add-Failure 'MarkdownBaselineCodex' }
if ($md -notmatch [regex]::Escape('13 physical fixture leaves')) { Add-Failure 'MarkdownFixtureLeaves' }

# Codex lifecycle docs retain activation/smoke evidence without a migration state gate.
$lifecycleFiles = @(
    'skills/_index.md'
    'docs/SOPs/codex-host-adapter.md'
    'docs/featureArchitecture/host-adaptation-fidelity.md'
    'docs/featureArchitecture/skill-source-and-host-overlays.md'
    'scripts/host-sync/README.md'
    'scripts/host-sync/manifests/codex.manifest.psd1'
)
$staleLifecyclePatterns = @('ApplyState', 'BringUp')
foreach ($relative in $lifecycleFiles) {
    $lifecyclePath = Join-Path $RepoRoot $relative
    if (-not (Test-Path -LiteralPath $lifecyclePath -PathType Leaf)) { Add-Failure 'LifecycleEvidenceMissing' $relative; continue }
    $lifecycleText = Get-Content -Raw -LiteralPath $lifecyclePath
    foreach ($pattern in $staleLifecyclePatterns) { if ($lifecycleText -match $pattern) { Add-Failure 'StaleCodexLifecycle' "$relative matches /$pattern/" } }
}
$skillsText = Get-Content -Raw -LiteralPath (Join-Path $RepoRoot 'skills/_index.md')
if ($skillsText -notmatch [regex]::Escape('Active since 2026-09-08 with C1–C6 smoke attested')) { Add-Failure 'CodexLifecycleStatus' 'skills index missing Active/attested status' }
if ($skillsText -notmatch [regex]::Escape('Apply requires fresh explicit owner authorization')) { Add-Failure 'CodexApplyAuthorization' 'skills index missing Apply authorization boundary' }

# Plan-review handoffs must exchange only the validated durable artifact path.
# These are the explicit governed handoff/launcher templates that name the
# reviewer input; baselines are checked separately by byte-level fixtures.
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
$planArtifactBoundaryLeaves = @($planArtifactBoundaryOnlyLeaves) + @($planArtifactExactTemplates)
foreach ($relative in $planArtifactBoundaryLeaves) {
    $path = Join-Path $RepoRoot $relative
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { Add-Failure 'PlanArtifactHandoffMissing' $relative; continue }
    $text = Get-Content -Raw -LiteralPath $path
    if (-not $text.Contains('.scratch/plans')) { Add-Failure 'PlanArtifactPathBoundary' $relative }
    if ($text.Contains('Plan artifact status') -or $text.Contains('draft returned by planner')) { Add-Failure 'PlanArtifactStatusSubstitute' $relative }
    if ($relative -in $planArtifactExactTemplates -and -not $text.Contains('Plan artifact path')) { Add-Failure 'PlanArtifactPathField' $relative }
}

# Retired-term search (char-code literal)
$forbidden = -join @(103,111,108,100,101,110)
$files = Get-GovernedRepositoryFiles -RepositoryRoot $RepoRoot
foreach ($f in $files) { $bytes = [System.IO.File]::ReadAllBytes($f.FullName); if ($bytes.Length -eq 0 -or ($bytes[0..([Math]::Min($bytes.Length-1,1023))] | Where-Object { $_ -eq 0 })) { continue }; $text = [Text.Encoding]::UTF8.GetString($bytes); if ($text.Contains($forbidden)) { Add-Failure 'RetiredTermAbsent' $f.FullName.Substring($RepoRoot.Length+1) } }

if ($failures.Count) { Write-Host "FAIL: $($failures.Count) invariant(s) failed:" -ForegroundColor Red; $failures | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }; exit 1 }
Write-Host 'PASS: 7x7 current-state, representation taxonomy, required-reading, semantic enums, manifest-entry equivalence, composition equivalence, skill applicability, baseline, Markdown, and repository-term invariants passed.' -ForegroundColor Green
exit 0
