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

$phase2cPairs = @(
  @{ Host = 'Cursor'; Agent = 'implementer'; Wrapper = 'overlays/cursor/agents/implementer.md'; Destination = 'agents/implementer.md'; Launch = 'Cursor Task with subagent_type implementer'; Authority = 'workspace-write' },
  @{ Host = 'Cursor'; Agent = 'test_reviewer'; Wrapper = 'overlays/cursor/agents/test_reviewer.md'; Destination = 'agents/test_reviewer.md'; Launch = 'Cursor Task with subagent_type test_reviewer'; Authority = 'read-only' },
  @{ Host = 'Antigravity'; Agent = 'implementer'; Wrapper = 'overlays/antigravity/agents/implementer.md'; Destination = 'config/agents/implementer.md'; Launch = 'Antigravity invoke_subagent'; Authority = 'workspace-write' },
  @{ Host = 'Antigravity'; Agent = 'test_reviewer'; Wrapper = 'overlays/antigravity/agents/test_reviewer.md'; Destination = 'config/agents/test_reviewer.md'; Launch = 'Antigravity invoke_subagent'; Authority = 'read-only' }
)
foreach ($pair in $phase2cPairs) {
  $item = @($registry.Catalogs.agents.items | Where-Object { [string]$_.id -eq $pair.Agent })[0]
  $binding = @($item.hostBindings | Where-Object { [string]$_.host -eq $pair.Host })[0]
  $row = @($registry.Inventory.parity_matrix | Where-Object { [string]$_.host -eq $pair.Host -and [string]$_.agent -eq $pair.Agent })[0]
  Assert-View "Phase 2C registry binding parity: $($pair.Host)|$($pair.Agent)" (
    [string]$binding.representation -eq 'native-definition' -and
    [string]$binding.routeIdentity -eq $pair.Agent -and
    [string]$binding.alias -eq '' -and
    [string]$binding.launchMechanism -eq $pair.Launch -and
    [string]$binding.authority -eq $pair.Authority -and
    [string]$binding.isolation -eq 'clean-context' -and
    [string]$binding.classification -eq 'host wrapper' -and
    [string]$row.representation -eq 'native-definition' -and
    [string]$row.route_identity -eq $pair.Agent -and
    [string]$row.launch_mechanism -eq $pair.Launch -and
    [string]$row.authority -eq $pair.Authority -and
    [string]$row.isolation -eq 'clean-context' -and
    [string]$row.classification -eq 'host wrapper'
  ) "binding=$($binding | ConvertTo-Json -Compress)"

  $manifest = @($registry.Inventory.manifests | Where-Object { [string]$_.host -eq $pair.Host })[0]
  $entries = @($manifest.entries | Where-Object {
    [string]$_.source -eq $pair.Wrapper.Substring($manifest.overlay_root.Length + 1) -and
    [string]$_.destination -eq $pair.Destination
  })
  Assert-View "Phase 2C evidence-path/manifest agreement: $($pair.Host)|$($pair.Agent)" (
    @($binding.evidencePaths) -contains $pair.Wrapper -and
    @($binding.evidencePaths) -contains $manifest.path -and
    @($row.evidence_paths) -contains $pair.Wrapper -and
    @($row.evidence_paths) -contains $manifest.path -and
    $entries.Count -eq 1
  ) "entries=$($entries.Count)"
}
$cursorImplementer = @(@($registry.Catalogs.agents.items | Where-Object { [string]$_.id -eq 'implementer' })[0].hostBindings | Where-Object { [string]$_.host -eq 'Cursor' })[0]
$cursorTestReviewer = @(@($registry.Catalogs.agents.items | Where-Object { [string]$_.id -eq 'test_reviewer' })[0].hostBindings | Where-Object { [string]$_.host -eq 'Cursor' })[0]
$cursorImplementerRaw = Get-Content -Raw (Join-Path $RepoRoot 'overlays/cursor/agents/implementer.md')
$cursorTestReviewerRaw = Get-Content -Raw (Join-Path $RepoRoot 'overlays/cursor/agents/test_reviewer.md')
Assert-View 'Phase 2C Cursor authority difference is explicit in metadata and spawn route' (
  [string]$cursorImplementer.authority -eq 'workspace-write' -and
  [string]$cursorTestReviewer.authority -eq 'read-only' -and
  $cursorImplementerRaw.Contains('readonly: false') -and
  $cursorTestReviewerRaw.Contains('readonly: true')
)
$antigravityTestReviewer = @(@($registry.Catalogs.agents.items | Where-Object { [string]$_.id -eq 'test_reviewer' })[0].hostBindings | Where-Object { [string]$_.host -eq 'Antigravity' })[0]
$antigravityTestReviewerRaw = Get-Content -Raw (Join-Path $RepoRoot 'overlays/antigravity/agents/test_reviewer.md')
$toolsMatch = [regex]::Match($antigravityTestReviewerRaw, '(?m)^tools:\r?$([\s\S]*?)^subagent:')
$observedTools = @(
  if ($toolsMatch.Success) {
    @($toolsMatch.Groups[1].Value -split '\r?\n' | ForEach-Object { ($_.Trim() -replace '^-\s*', '').Trim() } | Where-Object { $_ })
  }
)
Assert-View 'Phase 2C Antigravity test_reviewer preserves the read-only reviewer allowlist' (
  [string]$antigravityTestReviewer.authority -eq 'read-only' -and
  ($observedTools -join ',') -eq 'view_file,grep_search,run_command' -and
  $antigravityTestReviewerRaw.Contains('commandExecutionPolicy: sandbox') -and
  $antigravityTestReviewerRaw.Contains('tool allowlist is read-only')
)

$phase2FallbackPairs = @(
  @{ Host = 'Cline'; Agent = 'implementer'; Workflow = 'overlays/cline/workflows/agents.md'; Destination = 'data/workflows/agents.md'; Launch = 'Cline fresh task with canonical envelope'; Authority = 'workspace-write'; LoopGate = 'phase' },
  @{ Host = 'Cline'; Agent = 'test_reviewer'; Workflow = 'overlays/cline/workflows/agents.md'; Destination = 'data/workflows/agents.md'; Launch = 'Cline fresh task with canonical envelope'; Authority = 'read-only'; LoopGate = 'test-review' },
  @{ Host = 'Kilocode'; Agent = 'implementer'; Workflow = 'overlays/kilocode/workflows/agents.md'; Destination = 'workflows/agents.md'; Launch = 'Kilocode fresh task with canonical envelope'; Authority = 'workspace-write'; LoopGate = 'phase' },
  @{ Host = 'Kilocode'; Agent = 'test_reviewer'; Workflow = 'overlays/kilocode/workflows/agents.md'; Destination = 'workflows/agents.md'; Launch = 'Kilocode fresh task with canonical envelope'; Authority = 'read-only'; LoopGate = 'test-review' }
)
$governedRouteIdentities = @('planner','plan_reviewer','implementer','production_readiness_reviewer','bug_reviewer','repository_explorer','test_reviewer')
$routeIdentityTick = [char]96
foreach ($pair in $phase2FallbackPairs) {
  $item = @($registry.Catalogs.agents.items | Where-Object { [string]$_.id -eq $pair.Agent })[0]
  $binding = @($item.hostBindings | Where-Object { [string]$_.host -eq $pair.Host })[0]
  $row = @($registry.Inventory.parity_matrix | Where-Object { [string]$_.host -eq $pair.Host -and [string]$_.agent -eq $pair.Agent })[0]
  $manifest = @($registry.Inventory.manifests | Where-Object { [string]$_.host -eq $pair.Host })[0]
  $workflowRelative = $pair.Workflow.Substring($manifest.overlay_root.Length + 1)
  $inventoryEntries = @($manifest.entries | Where-Object {
    [string]$_.source -eq $workflowRelative -and [string]$_.destination -eq $pair.Destination
  })
  $manifestData = Import-PowerShellDataFile (Join-Path $RepoRoot $manifest.path)
  $manifestEntries = @($manifestData.CopyEntries | Where-Object {
    [string]$_['Source'] -eq $workflowRelative -and [string]$_['Dest'] -eq $pair.Destination
  })
  $workflowLines = @(Get-Content (Join-Path $RepoRoot $pair.Workflow))
  $workflowRaw = $workflowLines -join "`n"
  $routeRows = @($workflowLines | Where-Object { $_.StartsWith('| `') })
  $sectionStart = -1
  for ($lineIndex = 0; $lineIndex -lt $workflowLines.Count; $lineIndex++) {
    if ($workflowLines[$lineIndex].StartsWith('## ') -and
        $workflowLines[$lineIndex].Contains($pair.Agent) -and
        $workflowLines[$lineIndex].Contains('fresh-task envelope')) { $sectionStart = $lineIndex; break }
  }
  $sectionEnd = $workflowLines.Count
  for ($lineIndex = $sectionStart + 1; $lineIndex -lt $workflowLines.Count; $lineIndex++) {
    if ($workflowLines[$lineIndex].StartsWith('## ')) { $sectionEnd = $lineIndex; break }
  }
  $section = if ($sectionStart -ge 0 -and $sectionEnd -gt ($sectionStart + 1)) {
    $workflowLines[($sectionStart + 1)..($sectionEnd - 1)] -join "`n"
  } else { '' }
  $identityMatchFailures = @(
    foreach ($identity in $governedRouteIdentities) {
      if (@($routeRows | Where-Object { $_.Contains("| $routeIdentityTick$identity$routeIdentityTick |") }).Count -ne 1) { $identity }
    }
  )
  $identityRowsExactOnce = $identityMatchFailures.Count -eq 0
  Assert-View "Phase 2 fallback binding parity: $($pair.Host)|$($pair.Agent)" (
    [string]$binding.representation -eq 'fallback-launch-contract' -and
    [string]$binding.routeIdentity -eq $pair.Agent -and
    [string]$binding.alias -eq '' -and
    [string]$binding.launchMechanism -eq $pair.Launch -and
    [string]$binding.authority -eq $pair.Authority -and
    [string]$binding.isolation -eq 'fresh task/session per pass' -and
    [string]$binding.classification -eq 'host wrapper' -and
    [string]$row.representation -eq 'fallback-launch-contract' -and
    [string]$row.route_identity -eq $pair.Agent -and
    [string]$row.launch_mechanism -eq $pair.Launch -and
    [string]$row.authority -eq $pair.Authority -and
    [string]$row.isolation -eq 'fresh task/session per pass' -and
    [string]$row.classification -eq 'host wrapper'
  ) "binding=$($binding | ConvertTo-Json -Compress)"
  Assert-View "Phase 2 fallback delivery is exactly once: $($pair.Host)|$($pair.Agent)" (
    @($binding.evidencePaths) -contains $pair.Workflow -and
    @($binding.evidencePaths) -contains $manifest.path -and
    @($row.evidence_paths) -contains $pair.Workflow -and
    @($row.evidence_paths) -contains $manifest.path -and
    $inventoryEntries.Count -eq 1 -and
    $manifestEntries.Count -eq 1
  ) "inventory=$($inventoryEntries.Count); manifest=$($manifestEntries.Count)"
  Assert-View "Phase 2 fallback workflow contract: $($pair.Host)|$($pair.Agent)" (
    $workflowRaw.Contains('separate fresh') -and
    $workflowRaw.Contains('per governed leg') -and
    $routeRows.Count -eq 7 -and
    $identityRowsExactOnce -and
    $section.Contains("You are the ``$($pair.Agent)`` agent.") -and
    $section.Contains('Read `{{COMPANION_ROOT}}/agents/' + $pair.Agent + '.md` before acting.') -and
    $section.Contains('Required reading:') -and
    $section.Contains('{{COMPANION_ROOT}}/workflow/agent-invocation.md') -and
    $section.Contains('{{COMPANION_ROOT}}/agents/' + $pair.Agent + '.md') -and
    $section.Contains('Host alias: none') -and
    $section.Contains('Isolation: clean-context') -and
    $section.Contains('Authority: ' + $pair.Authority) -and
    $section.Contains('Loop/gate: ' + $pair.LoopGate) -and
    $section.Contains("`n---`n") -and
    $workflowRaw.Contains('missing, malformed, contradictory, or unreadable envelope')
  ) "workflow=$($pair.Workflow); routeRows=$($routeRows.Count); identityFailures=$($identityMatchFailures -join ','); section=$($sectionStart -ge 0)"
}

Assert-View 'Phase 2 inventory derives exact final 49 represented / 0 missing counts' (
  [int]$registry.Inventory.represented_count -eq 49 -and
  [int]$registry.Inventory.missing_count -eq 0 -and
  @($registry.Inventory.parity_matrix | Where-Object { $_.representation -ne 'missing' }).Count -eq 49 -and
  @($registry.Inventory.parity_matrix | Where-Object { $_.representation -eq 'missing' }).Count -eq 0 -and
  @($registry.Inventory.missing_pairs_with_proposed_phase2).Count -eq 0
)
$representedKeys = @(
  $phase2cPairs + $phase2FallbackPairs | ForEach-Object { "$($_.Host)|$($_.Agent)" }
)
$pendingPairs = @($registry.Inventory.ambiguities_requiring_owner_confirmation | ForEach-Object { $_.pending_missing_pairs } | ForEach-Object { "$($_.host)|$($_.agent)" })
Assert-View 'Phase 2 represented pairs are closed against every pending ambiguity' (
  @($pendingPairs | Where-Object { $representedKeys -contains $_ }).Count -eq 0 -and
  @($pendingPairs).Count -eq 0 -and
  @($registry.Inventory.ambiguities_requiring_owner_confirmation | Where-Object { [string]$_.id -eq 'U-Antigravity-Authority' }).Count -eq 0
) "pending=$($pendingPairs -join '; ')"

$temp = Join-Path ([IO.Path]::GetTempPath()) ("procedure-registry-" + [Guid]::NewGuid().ToString('N'))
try {
  $one = Write-RegistryManagedView -Catalogs $registry.Catalogs -OutputRoot (Join-Path $temp 'one') -RepoRoot $RepoRoot -Inventory $registry.Inventory -AllowTemporaryRoot
  $two = Write-RegistryManagedView -Catalogs $registry.Catalogs -OutputRoot (Join-Path $temp 'two') -RepoRoot $RepoRoot -Inventory $registry.Inventory -AllowTemporaryRoot
  Assert-View 'double render has twelve files (six base + six managed compositions)' ($one.Files.Keys.Count -eq 12 -and $two.Files.Keys.Count -eq 12) "one=$($one.Files.Keys.Count) two=$($two.Files.Keys.Count)"
  foreach ($name in @($one.Files.Keys)) {
    $hashA = (Get-FileHash (Join-Path (Join-Path $temp 'one') $name) -Algorithm SHA256).Hash
    $hashB = (Get-FileHash (Join-Path (Join-Path $temp 'two') $name) -Algorithm SHA256).Hash
    Assert-View "deterministic render: $name" ($hashA -eq $hashB) "$hashA != $hashB"
  }
  Assert-View 'parity view covers 49 rows' ((Get-Content (Join-Path (Join-Path $temp 'one') 'agent-parity.tsv')).Count -eq 50)
  $shadowRows = @(Get-Content (Join-Path (Join-Path $temp 'one') 'skill-frontmatter-shadow.tsv'))
  Assert-View 'skill frontmatter shadow view covers 22 rows' ($shadowRows.Count -eq 23) "rows=$($shadowRows.Count)"
  Assert-View 'skill frontmatter shadow reports all matches' (@($shadowRows | Select-Object -Skip 1 | Where-Object { $_ -notmatch "`tmatch`t" }).Count -eq 0) (($shadowRows | Select-Object -Skip 1 | Where-Object { $_ -notmatch "`tmatch`t" }) -join '; ')
  $wrapperRows = @(Get-Content (Join-Path (Join-Path $temp 'one') 'skill-host-frontmatter-shadow.tsv'))
  Assert-View 'skill host wrapper shadow view grows exactly 119 to 154 rows' ($wrapperRows.Count -eq 155) "rows=$($wrapperRows.Count)"
  Assert-View 'skill host wrapper shadow reports only match or not-applicable' (@($wrapperRows | Select-Object -Skip 1 | Where-Object { $_ -notmatch "`t(match|not-applicable)`t" }).Count -eq 0) (($wrapperRows | Select-Object -Skip 1 | Where-Object { $_ -notmatch "`t(match|not-applicable)`t" }) -join '; ')
  Assert-View 'skill host wrapper shadow pins the shared OpenCode source' ((@($wrapperRows | Where-Object { $_ -like "implementation-plan`tAntigravity`tmatch`toverlays/opencode/skills/implementation-plan/SKILL.md" }).Count -eq 1) -and (@($wrapperRows | Where-Object { $_ -like "plan-review`tVscode`tmatch`toverlays/opencode/skills/plan-review/SKILL.md" }).Count -eq 1))
  Assert-View 'skill host wrapper shadow pins authored per-source deltas' ((@($wrapperRows | Where-Object { $_ -like "implementation-review`tAntigravity`tmatch`toverlays/antigravity/skills/implementation-review/SKILL.md" }).Count -eq 1) -and (@($wrapperRows | Where-Object { $_ -like "composer`tVscode`tmatch`toverlays/vscode/skills/composer/SKILL.md" }).Count -eq 1))
  Assert-View 'skill host wrapper shadow pins roadmap shared OpenCode source' ((@($wrapperRows | Where-Object { $_ -like "roadmap`tAntigravity`tmatch`toverlays/opencode/skills/roadmap/SKILL.md" }).Count -eq 1) -and (@($wrapperRows | Where-Object { $_ -like "roadmap`tVscode`tmatch`toverlays/opencode/skills/roadmap/SKILL.md" }).Count -eq 1))
  Assert-View 'skill host wrapper shadow pins research Codex-only source' ((@($wrapperRows | Where-Object { $_ -like "research`tCodex`tmatch`toverlays/codex/skills/research/SKILL.md" }).Count -eq 1) -and (@($wrapperRows | Where-Object { $_ -like "research`t*`tnot-applicable`t-" }).Count -eq 6))
  Assert-View 'skill host wrapper shadow pins bug-review-sweep Codex-only source' ((@($wrapperRows | Where-Object { $_ -like "bug-review-sweep`tCodex`tmatch`toverlays/codex/skills/bug-review-sweep/SKILL.md" }).Count -eq 1) -and (@($wrapperRows | Where-Object { $_ -like "bug-review-sweep`t*`tnot-applicable`t-" }).Count -eq 6))
  Assert-View 'skill host wrapper shadow pins diagnosing-bugs shared and Codex sources' ((@($wrapperRows | Where-Object { $_ -like "diagnosing-bugs`tOpenCode`tmatch`toverlays/opencode/skills/diagnosing-bugs/SKILL.md" }).Count -eq 1) -and (@($wrapperRows | Where-Object { $_ -like "diagnosing-bugs`tAntigravity`tmatch`toverlays/opencode/skills/diagnosing-bugs/SKILL.md" }).Count -eq 1) -and (@($wrapperRows | Where-Object { $_ -like "diagnosing-bugs`tVscode`tmatch`toverlays/opencode/skills/diagnosing-bugs/SKILL.md" }).Count -eq 1) -and (@($wrapperRows | Where-Object { $_ -like "diagnosing-bugs`tCodex`tmatch`toverlays/codex/skills/diagnosing-bugs/SKILL.md" }).Count -eq 1) -and (@($wrapperRows | Where-Object { $_ -like "diagnosing-bugs`t*`tnot-applicable`t-" }).Count -eq 3))
  Assert-View 'skill host wrapper shadow pins architecture-survey Codex-only source' ((@($wrapperRows | Where-Object { $_ -like "architecture-survey`tCodex`tmatch`toverlays/codex/skills/architecture-survey/SKILL.md" }).Count -eq 1) -and (@($wrapperRows | Where-Object { $_ -like "architecture-survey`t*`tnot-applicable`t-" }).Count -eq 6))
  Assert-View 'skill host wrapper shadow pins codebase-design Codex-only source' ((@($wrapperRows | Where-Object { $_ -like "codebase-design`tCodex`tmatch`toverlays/codex/skills/codebase-design/SKILL.md" }).Count -eq 1) -and (@($wrapperRows | Where-Object { $_ -like "codebase-design`t*`tnot-applicable`t-" }).Count -eq 6))
  foreach ($codexOnlyId in @('domain-modeling','grilling','prototype')) {
    $codexRows = @($wrapperRows | Where-Object { $_ -like "$codexOnlyId`t*" })
    Assert-View "skill host wrapper shadow pins $codexOnlyId Codex-only applicability" ($codexRows.Count -eq 7 -and @($codexRows | Where-Object { $_ -like "$codexOnlyId`tCodex`tmatch`t*" }).Count -eq 1 -and @($codexRows | Where-Object { $_ -like "$codexOnlyId`t*`tnot-applicable`t-" }).Count -eq 6) (($codexRows) -join '; ')
  }
  foreach ($phase3IId in @('tdd','resolving-merge-conflicts')) {
    $codexRows = @($wrapperRows | Where-Object { $_ -like "$phase3IId`t*" })
    $expectedSource = "overlays/codex/skills/$phase3IId/SKILL.md"
    Assert-View "skill host wrapper shadow pins $phase3IId Codex-only source" ($codexRows.Count -eq 7 -and @($codexRows | Where-Object { $_ -like "$phase3IId`tCodex`tmatch`t$expectedSource" }).Count -eq 1 -and @($codexRows | Where-Object { $_ -like "$phase3IId`t*`tnot-applicable`t-" }).Count -eq 6) (($codexRows) -join '; ')
  }
  foreach ($phase3JId in @('teach','wait-what','wizard')) {
    $codexRows = @($wrapperRows | Where-Object { $_ -like "$phase3JId`t*" })
    $expectedSource = "overlays/codex/skills/$phase3JId/SKILL.md"
    Assert-View "skill host wrapper shadow pins $phase3JId Codex-only source" ($codexRows.Count -eq 7 -and @($codexRows | Where-Object { $_ -like "$phase3JId`tCodex`tmatch`t$expectedSource" }).Count -eq 1 -and @($codexRows | Where-Object { $_ -like "$phase3JId`t*`tnot-applicable`t-" }).Count -eq 6) (($codexRows) -join '; ')
  }
  foreach ($phase3KPin in @(
    @{ Skill = 'opencode-headless-run'; Host = 'Cursor'; Source = 'overlays/cursor/skills/opencode-headless-run/SKILL.md' },
    @{ Skill = 'opencode-headless-run'; Host = 'OpenCode'; Source = 'overlays/opencode/skills/opencode-headless-run/SKILL.md' },
    @{ Skill = 'opencode-headless-run'; Host = 'Antigravity'; Source = 'overlays/opencode/skills/opencode-headless-run/SKILL.md' },
    @{ Skill = 'opencode-headless-run'; Host = 'Vscode'; Source = 'overlays/opencode/skills/opencode-headless-run/SKILL.md' },
    @{ Skill = 'opencode-headless-run'; Host = 'Codex'; Source = 'overlays/codex/skills/opencode-headless-run/SKILL.md' },
    @{ Skill = 'opencode-history-search'; Host = 'Cursor'; Source = 'overlays/cursor/skills/opencode-history-search/SKILL.md' },
    @{ Skill = 'opencode-history-search'; Host = 'OpenCode'; Source = 'overlays/opencode/skills/opencode-history-search/SKILL.md' },
    @{ Skill = 'opencode-history-search'; Host = 'Antigravity'; Source = 'overlays/antigravity/skills/opencode-history-search/SKILL.md' },
    @{ Skill = 'opencode-history-search'; Host = 'Vscode'; Source = 'overlays/vscode/skills/opencode-history-search/SKILL.md' },
    @{ Skill = 'opencode-history-search'; Host = 'Codex'; Source = 'overlays/codex/skills/opencode-history-search/SKILL.md' }
  )) {
    $pinned = @($wrapperRows | Where-Object { $_ -like "$($phase3KPin.Skill)`t$($phase3KPin.Host)`tmatch`t$($phase3KPin.Source)" }).Count
    Assert-View "skill host wrapper shadow pins $($phase3KPin.Skill)/$($phase3KPin.Host) exact source" ($pinned -eq 1) "pins=$pinned"
  }
  foreach ($phase3KId in @('opencode-headless-run','opencode-history-search')) {
    $explicitOnlyRows = @($wrapperRows | Where-Object { $_ -like "$phase3KId`t*" })
    Assert-View "skill host wrapper shadow pins $phase3KId explicit-only five-host applicability" ($explicitOnlyRows.Count -eq 7 -and @($explicitOnlyRows | Where-Object { $_ -like "$phase3KId`t*`tmatch`t*" }).Count -eq 5 -and @($explicitOnlyRows | Where-Object { $_ -like "$phase3KId`t*`tnot-applicable`t-" }).Count -eq 2) (($explicitOnlyRows) -join '; ')
  }
  foreach ($perSourceId in @('implementation-review','composer')) {
    $sources = @($wrapperRows | Select-Object -Skip 1 | Where-Object { $_ -like "$perSourceId`t*`tmatch`t*" } | ForEach-Object { ($_ -split "`t")[3] })
    Assert-View "skill host wrapper shadow routes $perSourceId through five distinct sources" ($sources.Count -eq 5 -and @($sources | Select-Object -Unique).Count -eq 5) ((@($sources | Select-Object -Unique)) -join ', ')
  }
  foreach ($sourcePin in @(
    @{ Skill = 'discovery'; Host = 'OpenCode'; Source = 'overlays/opencode/skills/discovery/SKILL.md' },
    @{ Skill = 'discovery'; Host = 'Antigravity'; Source = 'overlays/opencode/skills/discovery/SKILL.md' },
    @{ Skill = 'discovery'; Host = 'Vscode'; Source = 'overlays/opencode/skills/discovery/SKILL.md' },
    @{ Skill = 'documentation-architecture'; Host = 'OpenCode'; Source = 'overlays/opencode/skills/documentation-architecture/SKILL.md' },
    @{ Skill = 'documentation-architecture'; Host = 'Antigravity'; Source = 'overlays/opencode/skills/documentation-architecture/SKILL.md' },
    @{ Skill = 'documentation-architecture'; Host = 'Vscode'; Source = 'overlays/opencode/skills/documentation-architecture/SKILL.md' }
  )) {
    $pinned = @($wrapperRows | Where-Object { $_ -like "$($sourcePin.Skill)`t$($sourcePin.Host)`tmatch`t$($sourcePin.Source)" }).Count
    Assert-View "skill host wrapper shadow pins $($sourcePin.Skill)/$($sourcePin.Host) shared source" ($pinned -eq 1) "pins=$pinned"
  }
  foreach ($sourceTopology in @(
    @{ Skill = 'discovery'; MatchedHosts = 4; DistinctSources = 2 },
    @{ Skill = 'documentation-architecture'; MatchedHosts = 5; DistinctSources = 3 },
    @{ Skill = 'roadmap'; MatchedHosts = 5; DistinctSources = 3 },
    @{ Skill = 'research'; MatchedHosts = 1; DistinctSources = 1 },
    @{ Skill = 'bug-review-sweep'; MatchedHosts = 1; DistinctSources = 1 },
    @{ Skill = 'diagnosing-bugs'; MatchedHosts = 4; DistinctSources = 2 },
    @{ Skill = 'architecture-survey'; MatchedHosts = 1; DistinctSources = 1 },
    @{ Skill = 'codebase-design'; MatchedHosts = 1; DistinctSources = 1 },
    @{ Skill = 'domain-modeling'; MatchedHosts = 1; DistinctSources = 1 },
    @{ Skill = 'grilling'; MatchedHosts = 1; DistinctSources = 1 },
    @{ Skill = 'prototype'; MatchedHosts = 1; DistinctSources = 1 },
    @{ Skill = 'tdd'; MatchedHosts = 1; DistinctSources = 1 },
    @{ Skill = 'resolving-merge-conflicts'; MatchedHosts = 1; DistinctSources = 1 },
    @{ Skill = 'teach'; MatchedHosts = 1; DistinctSources = 1 },
    @{ Skill = 'wait-what'; MatchedHosts = 1; DistinctSources = 1 },
    @{ Skill = 'wizard'; MatchedHosts = 1; DistinctSources = 1 },
    @{ Skill = 'opencode-headless-run'; MatchedHosts = 5; DistinctSources = 3 },
    @{ Skill = 'opencode-history-search'; MatchedHosts = 5; DistinctSources = 5 }
  )) {
    $sources = @($wrapperRows | Select-Object -Skip 1 | Where-Object { $_ -like "$($sourceTopology.Skill)`t*`tmatch`t*" } | ForEach-Object { ($_ -split "`t")[3] })
    Assert-View "skill host wrapper shadow routes $($sourceTopology.Skill) through its shared and distinct sources" ($sources.Count -eq $sourceTopology.MatchedHosts -and @($sources | Select-Object -Unique).Count -eq $sourceTopology.DistinctSources) (($sources | Select-Object -Unique) -join ', ')
  }

  $publicRender = Join-Path $temp 'public-render'
  & $RenderScript -OutputRoot $publicRender -AllowTemporaryRoot | Out-Null
  $publicFiles = @(Get-ChildItem -LiteralPath $publicRender -File)
  Assert-View 'public render integration' ($publicFiles.Count -eq 6) "files=$($publicFiles.Count)"
  $explicitRepoRender = Join-Path $temp 'explicit-repo-render'
  & $RenderScript -RepoRoot $RepoRoot -OutputRoot $explicitRepoRender -AllowTemporaryRoot | Out-Null
  $explicitFiles = @(Get-ChildItem -LiteralPath $explicitRepoRender -File)
  Assert-View 'explicit RepoRoot render integration' ($explicitFiles.Count -eq 6) "files=$($explicitFiles.Count)"
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
  $yamlBuilderThrew = $false
  try { $null = Get-RegistrySkillFrontmatter -Skill ([pscustomobject]@{ id = 'yaml-ambiguous'; description = [pscustomobject]@{ style = 'plain-scalar'; lines = @('on') }; modelInvocationDisabled = $false }) } catch { $yamlBuilderThrew = $true }
  Assert-View 'frontmatter builder fails closed on YAML-1.1 bool description' $yamlBuilderThrew
  $foldedAmbiguousThrew = $false
  try { $null = Get-RegistrySkillFrontmatter -Skill ([pscustomobject]@{ id = 'folded-ok'; description = [pscustomobject]@{ style = 'folded-block'; lines = @('no','on') }; modelInvocationDisabled = $false }) } catch { $foldedAmbiguousThrew = $true }
  Assert-View 'folded-block descriptions keep working despite scalar-looking words' (-not $foldedAmbiguousThrew)
  $bomSkill = $skillsById['implementation-plan']
  $bomRaw = Get-Content -Raw -LiteralPath (Join-Path $RepoRoot ([string]$bomSkill.body))
  $bomShadow = Get-RegistrySkillFrontmatterShadow -Skill $bomSkill -Raw ("$([char]0xFEFF)$bomRaw")
  Assert-View 'BOM-prefixed canonical skill frontmatter fails closed' ($bomShadow.Status -eq 'mismatch' -and @($bomShadow.Failures | Where-Object { $_.StartsWith('SkillFrontmatterShape:', [StringComparison]::Ordinal) }).Count -gt 0) (($bomShadow.Failures | Select-Object -First 1) -join '')
  $bomPath = Join-Path $temp 'bom-source.md'
  [IO.File]::WriteAllBytes($bomPath, [byte[]]([byte[]]@(0xEF,0xBB,0xBF) + [Text.UTF8Encoding]::new($false).GetBytes($bomRaw)))
  $bomIngressFailures = [System.Collections.Generic.List[string]]::new()
  $bomIngressRaw = Get-RegistrySkillSourceRaw -Path $bomPath -Label 'implementation-plan' -Failures $bomIngressFailures
  Assert-View 'BOM-prefixed skill source fails closed at the file ingress loader' ($null -eq $bomIngressRaw -and @($bomIngressFailures | Where-Object { $_.StartsWith('SkillSourceBom:', [StringComparison]::Ordinal) }).Count -gt 0) (($bomIngressFailures | Select-Object -First 1) -join '')
  $cleanSourcePath = Join-Path $temp 'clean-source.md'
  [IO.File]::WriteAllBytes($cleanSourcePath, [Text.UTF8Encoding]::new($false).GetBytes($bomRaw))
  $cleanIngressFailures = [System.Collections.Generic.List[string]]::new()
  $cleanIngressRaw = Get-RegistrySkillSourceRaw -Path $cleanSourcePath -Label 'implementation-plan' -Failures $cleanIngressFailures
  Assert-View 'BOM-free skill source ingests unchanged through the loader' ($null -ne $cleanIngressRaw -and $cleanIngressRaw -ceq $bomRaw -and $cleanIngressFailures.Count -eq 0) (($cleanIngressFailures | Select-Object -First 1) -join '')
  $missingIngressFailures = [System.Collections.Generic.List[string]]::new()
  $missingIngressRaw = Get-RegistrySkillSourceRaw -Path (Join-Path $temp 'missing-source.md') -Label 'implementation-plan' -Failures $missingIngressFailures
  Assert-View 'unreadable skill source fails closed instead of crashing the validator' ($null -eq $missingIngressRaw -and @($missingIngressFailures | Where-Object { $_.StartsWith('SkillSourceRead:', [StringComparison]::Ordinal) }).Count -gt 0) (($missingIngressFailures | Select-Object -First 1) -join '')
  $viewMirror = Join-Path $temp 'view-mirror'
  foreach ($skill in $registry.Catalogs.skills.items) {
    $mirrorPath = Join-Path $viewMirror ([string]$skill.body)
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $mirrorPath) | Out-Null
    Copy-Item -LiteralPath (Join-Path $RepoRoot ([string]$skill.body)) -Destination $mirrorPath
  }
  foreach ($namedId in @('implementation-plan','plan-review','implementation-review','composer','discovery','documentation-architecture','roadmap','research','bug-review-sweep','diagnosing-bugs','architecture-survey','codebase-design','domain-modeling','grilling','prototype','tdd','resolving-merge-conflicts','teach','wait-what','wizard','opencode-headless-run','opencode-history-search')) {
    foreach ($profile in @(@($registry.Catalogs.skills.items | Where-Object { [string]$_.id -eq $namedId }).hostFrontmatterProfiles)) {
      $mirrorPath = Join-Path $viewMirror ([string]$profile.wrapperSource)
      New-Item -ItemType Directory -Force -Path (Split-Path -Parent $mirrorPath) | Out-Null
      Copy-Item -LiteralPath (Join-Path $RepoRoot ([string]$profile.wrapperSource)) -Destination $mirrorPath
    }
  }
  $mirrorOverlayRoots = @{}
  foreach ($mirrorManifest in @($registry.Inventory.manifests)) { $mirrorOverlayRoots[[string]$mirrorManifest.host] = @{ Overlay = $mirrorManifest.overlay_root; Shared = $mirrorManifest.shared_root } }
  foreach ($mirrorComposition in @($registry.Catalogs.workflows.compositions)) {
    if ($mirrorComposition.PSObject.Properties['runtimeOnly'] -and [bool]$mirrorComposition.runtimeOnly) { continue }
    foreach ($mirrorReference in @($mirrorComposition.references)) {
      $mirrorRefPath = Get-RegistryCompositionReferencePath -Reference ([string]$mirrorReference) -HostName ([string]$mirrorComposition.host) -OverlayRoots $mirrorOverlayRoots
      $mirrorTarget = Join-Path $viewMirror $mirrorRefPath
      New-Item -ItemType Directory -Force -Path (Split-Path -Parent $mirrorTarget) | Out-Null
      Copy-Item -LiteralPath (Join-Path $RepoRoot $mirrorRefPath) -Destination $mirrorTarget
    }
  }
  $cleanView = Get-RegistryManagedView -Catalogs $registry.Catalogs -RepoRoot $viewMirror -Inventory $registry.Inventory
  Assert-View 'managed view renders clean sources through the ingress loader' ((@(($cleanView.Files['skill-frontmatter-shadow.tsv'] -split "`n" | Where-Object { $_ }) | Select-Object -Skip 1 | Where-Object { $_ -notmatch "`tmatch`t" })).Count -eq 0)
  [IO.File]::WriteAllBytes((Join-Path $viewMirror ([string]$bomSkill.body)), [byte[]]([byte[]]@(0xEF,0xBB,0xBF) + [Text.UTF8Encoding]::new($false).GetBytes($bomRaw)))
  $viewBomThrew = $false
  try { $null = Get-RegistryManagedView -Catalogs $registry.Catalogs -RepoRoot $viewMirror -Inventory $registry.Inventory } catch { $viewBomThrew = ($_.Exception.Message -like 'FAIL: SkillSourceBom:*') }
  Assert-View 'managed view rejects a BOM-prefixed canonical source before rendering shadow evidence' $viewBomThrew
  $cursorProfile = @(@($registry.Catalogs.skills.items | Where-Object { [string]$_.id -eq 'implementation-plan' }).hostFrontmatterProfiles | Where-Object { @($_.hosts) -contains 'Cursor' })[0]
  $wrongNameFailures = [System.Collections.Generic.List[string]]::new()
  $wrongNameStatus = Get-RegistrySkillWrapperFrontmatterShadow -SkillId 'implementation-plan' -Profile $cursorProfile -HostName 'Cursor' -Raw "---`nname: wrong-name`ndescription: ignored`n---`n" -Failures $wrongNameFailures
  Assert-View 'wrapper name mismatch names host and skill id' ($wrongNameStatus -eq 'mismatch' -and @($wrongNameFailures | Where-Object { $_.StartsWith('SkillWrapperName: implementation-plan/Cursor', [StringComparison]::Ordinal) }).Count -gt 0) (($wrongNameFailures | Select-Object -First 2) -join '; ')
  $shapeFailures = [System.Collections.Generic.List[string]]::new()
  $shapeStatus = Get-RegistrySkillWrapperFrontmatterShadow -SkillId 'implementation-plan' -Profile $cursorProfile -HostName 'Cursor' -Raw 'no frontmatter here' -Failures $shapeFailures
  Assert-View 'wrapper without frontmatter fails closed naming host and skill id' ($shapeStatus -eq 'mismatch' -and @($shapeFailures | Where-Object { $_.StartsWith('SkillWrapperShape: implementation-plan/Cursor', [StringComparison]::Ordinal) }).Count -gt 0) (($shapeFailures | Select-Object -First 2) -join '; ')
  $reviewCursorProfile = @(@($registry.Catalogs.skills.items | Where-Object { [string]$_.id -eq 'implementation-review' }).hostFrontmatterProfiles | Where-Object { @($_.hosts) -contains 'Cursor' })[0]
  $disableFailures = [System.Collections.Generic.List[string]]::new()
  $disableStatus = Get-RegistrySkillWrapperFrontmatterShadow -SkillId 'implementation-review' -Profile $reviewCursorProfile -HostName 'Cursor' -Raw "---`nname: implementation-review`ndescription: ignored`n---`n" -Failures $disableFailures
  Assert-View 'implementation-review Cursor wrapper missing disable flag fails closed' ($disableStatus -eq 'mismatch' -and @($disableFailures | Where-Object { $_.StartsWith('SkillWrapperDisableModelInvocation: implementation-review/Cursor', [StringComparison]::Ordinal) }).Count -gt 0) (($disableFailures | Select-Object -First 2) -join '; ')
  $composerCodexProfile = @(@($registry.Catalogs.skills.items | Where-Object { [string]$_.id -eq 'composer' }).hostFrontmatterProfiles | Where-Object { @($_.hosts) -contains 'Codex' })[0]
  $plainScalarFailures = [System.Collections.Generic.List[string]]::new()
  $plainScalarStatus = Get-RegistrySkillWrapperFrontmatterShadow -SkillId 'composer' -Profile $composerCodexProfile -HostName 'Codex' -Raw "---`nname: composer`ndescription: wrong plain scalar`n---`n" -Failures $plainScalarFailures
  Assert-View 'composer Codex plain-scalar wrapper description mismatch fails closed' ($plainScalarStatus -eq 'mismatch' -and @($plainScalarFailures | Where-Object { $_.StartsWith('SkillWrapperFrontmatterShadow: composer/Codex', [StringComparison]::Ordinal) }).Count -gt 0) (($plainScalarFailures | Select-Object -First 2) -join '; ')
  $docArchCursorProfile = @(@($registry.Catalogs.skills.items | Where-Object { [string]$_.id -eq 'documentation-architecture' }).hostFrontmatterProfiles | Where-Object { @($_.hosts) -contains 'Cursor' })[0]
  $docArchDisableFailures = [System.Collections.Generic.List[string]]::new()
  $docArchDisableStatus = Get-RegistrySkillWrapperFrontmatterShadow -SkillId 'documentation-architecture' -Profile $docArchCursorProfile -HostName 'Cursor' -Raw "---`nname: documentation-architecture`ndescription: ignored`n---`n" -Failures $docArchDisableFailures
  Assert-View 'documentation-architecture Cursor wrapper missing disable flag fails closed' ($docArchDisableStatus -eq 'mismatch' -and @($docArchDisableFailures | Where-Object { $_.StartsWith('SkillWrapperDisableModelInvocation: documentation-architecture/Cursor', [StringComparison]::Ordinal) }).Count -gt 0) (($docArchDisableFailures | Select-Object -First 2) -join '; ')
  $roadmapCursorProfile = @(@($registry.Catalogs.skills.items | Where-Object { [string]$_.id -eq 'roadmap' }).hostFrontmatterProfiles | Where-Object { @($_.hosts) -contains 'Cursor' })[0]
  $roadmapDisableFailures = [System.Collections.Generic.List[string]]::new()
  $roadmapDisableStatus = Get-RegistrySkillWrapperFrontmatterShadow -SkillId 'roadmap' -Profile $roadmapCursorProfile -HostName 'Cursor' -Raw "---`nname: roadmap`ndescription: ignored`n---`n" -Failures $roadmapDisableFailures
  Assert-View 'roadmap Cursor wrapper missing disable flag fails closed' ($roadmapDisableStatus -eq 'mismatch' -and @($roadmapDisableFailures | Where-Object { $_.StartsWith('SkillWrapperDisableModelInvocation: roadmap/Cursor', [StringComparison]::Ordinal) }).Count -gt 0) (($roadmapDisableFailures | Select-Object -First 2) -join '; ')
  $researchCodexProfile = @(@($registry.Catalogs.skills.items | Where-Object { [string]$_.id -eq 'research' }).hostFrontmatterProfiles | Where-Object { @($_.hosts) -contains 'Codex' })[0]
  $researchDescriptionFailures = [System.Collections.Generic.List[string]]::new()
  $researchDescriptionStatus = Get-RegistrySkillWrapperFrontmatterShadow -SkillId 'research' -Profile $researchCodexProfile -HostName 'Codex' -Raw "---`nname: research`ndescription: wrong plain scalar`n---`n" -Failures $researchDescriptionFailures
  Assert-View 'research Codex plain-scalar wrapper description mismatch fails closed' ($researchDescriptionStatus -eq 'mismatch' -and @($researchDescriptionFailures | Where-Object { $_.StartsWith('SkillWrapperFrontmatterShadow: research/Codex', [StringComparison]::Ordinal) }).Count -gt 0) (($researchDescriptionFailures | Select-Object -First 2) -join '; ')
  $archSurveyCodexProfile = @(@($registry.Catalogs.skills.items | Where-Object { [string]$_.id -eq 'architecture-survey' }).hostFrontmatterProfiles | Where-Object { @($_.hosts) -contains 'Codex' })[0]
  $archSurveyDescriptionFailures = [System.Collections.Generic.List[string]]::new()
  $archSurveyDescriptionStatus = Get-RegistrySkillWrapperFrontmatterShadow -SkillId 'architecture-survey' -Profile $archSurveyCodexProfile -HostName 'Codex' -Raw "---`nname: architecture-survey`ndescription: wrong plain scalar`n---`n" -Failures $archSurveyDescriptionFailures
  Assert-View 'architecture-survey Codex plain-scalar wrapper description mismatch fails closed' ($archSurveyDescriptionStatus -eq 'mismatch' -and @($archSurveyDescriptionFailures | Where-Object { $_.StartsWith('SkillWrapperFrontmatterShadow: architecture-survey/Codex', [StringComparison]::Ordinal) }).Count -gt 0) (($archSurveyDescriptionFailures | Select-Object -First 2) -join '; ')
  $codebaseDesignCodexProfile = @(@($registry.Catalogs.skills.items | Where-Object { [string]$_.id -eq 'codebase-design' }).hostFrontmatterProfiles | Where-Object { @($_.hosts) -contains 'Codex' })[0]
  $codebaseDesignDescriptionFailures = [System.Collections.Generic.List[string]]::new()
  $codebaseDesignDescriptionStatus = Get-RegistrySkillWrapperFrontmatterShadow -SkillId 'codebase-design' -Profile $codebaseDesignCodexProfile -HostName 'Codex' -Raw "---`nname: codebase-design`ndescription: wrong plain scalar`n---`n" -Failures $codebaseDesignDescriptionFailures
  Assert-View 'codebase-design Codex plain-scalar wrapper description mismatch fails closed' ($codebaseDesignDescriptionStatus -eq 'mismatch' -and @($codebaseDesignDescriptionFailures | Where-Object { $_.StartsWith('SkillWrapperFrontmatterShadow: codebase-design/Codex', [StringComparison]::Ordinal) }).Count -gt 0) (($codebaseDesignDescriptionFailures | Select-Object -First 2) -join '; ')
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
  foreach ($yamlScalar in @('no','on','null','42','0b1010','1:30','190:20:30','190:20:30.15')) {
    $scalarValue = $yamlScalar
    $result = Invoke-EdgeCase 'skills' { param($c) (@($c.skills.items | Where-Object { [string]$_.id -eq 'opencode-headless-run' }))[0].description.lines = @($scalarValue) }.GetNewClosure()
    Assert-RegistryFailure $result "plain-scalar YAML-1.1 value '$yamlScalar' fails closed" 'SkillDescriptionScalar'
  }
  $result = Invoke-EdgeCase 'skills' { param($c) (@($c.skills.items | Where-Object { [string]$_.id -eq 'implementation-plan' }))[0].PSObject.Properties.Remove('hostFrontmatterProfiles') }
  Assert-RegistryFailure $result 'missing host frontmatter profiles fails closed' 'SkillHostFrontmatterProfileMissing'
  $result = Invoke-EdgeCase 'skills' { param($c) (@($c.skills.items | Where-Object { [string]$_.id -eq 'composer' }))[0].PSObject.Properties.Remove('hostFrontmatterProfiles') }
  Assert-RegistryFailure $result 'composer profile removal fails closed' 'SkillHostFrontmatterProfileMissing'
  $result = Invoke-EdgeCase 'skills' { param($c) (@($c.skills.items | Where-Object { [string]$_.id -eq 'discovery' }))[0].PSObject.Properties.Remove('hostFrontmatterProfiles') }
  Assert-RegistryFailure $result 'discovery profile removal fails closed' 'SkillHostFrontmatterProfileMissing'
  $result = Invoke-EdgeCase 'skills' { param($c) (@($c.skills.items | Where-Object { [string]$_.id -eq 'documentation-architecture' }))[0].PSObject.Properties.Remove('hostFrontmatterProfiles') }
  Assert-RegistryFailure $result 'documentation-architecture profile removal fails closed' 'SkillHostFrontmatterProfileMissing'
  $result = Invoke-EdgeCase 'skills' { param($c) (@($c.skills.items | Where-Object { [string]$_.id -eq 'roadmap' }))[0].PSObject.Properties.Remove('hostFrontmatterProfiles') }
  Assert-RegistryFailure $result 'roadmap profile removal fails closed' 'SkillHostFrontmatterProfileMissing'
  $result = Invoke-EdgeCase 'skills' { param($c) (@($c.skills.items | Where-Object { [string]$_.id -eq 'research' }))[0].PSObject.Properties.Remove('hostFrontmatterProfiles') }
  Assert-RegistryFailure $result 'research profile removal fails closed' 'SkillHostFrontmatterProfileMissing'
  $result = Invoke-EdgeCase 'skills' { param($c) (@($c.skills.items | Where-Object { [string]$_.id -eq 'bug-review-sweep' }))[0].PSObject.Properties.Remove('hostFrontmatterProfiles') }
  Assert-RegistryFailure $result 'bug-review-sweep profile removal fails closed' 'SkillHostFrontmatterProfileMissing'
  $result = Invoke-EdgeCase 'skills' { param($c) (@($c.skills.items | Where-Object { [string]$_.id -eq 'diagnosing-bugs' }))[0].PSObject.Properties.Remove('hostFrontmatterProfiles') }
  Assert-RegistryFailure $result 'diagnosing-bugs profile removal fails closed' 'SkillHostFrontmatterProfileMissing'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'discovery' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Vscode' })[0].hosts = @('OpenCode','Antigravity') }
  Assert-RegistryFailure $result 'discovery uncovered applicable host fails closed' 'SkillHostFrontmatterProfileCoverage'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'documentation-architecture' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].hosts = @('OpenCode') }
  Assert-RegistryFailure $result 'documentation-architecture uncovered applicable host fails closed' 'SkillHostFrontmatterProfileCoverage'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'roadmap' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Vscode' })[0].hosts = @('OpenCode') }
  Assert-RegistryFailure $result 'roadmap uncovered applicable host fails closed' 'SkillHostFrontmatterProfileCoverage'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'research' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].hosts = @('Cursor') }
  Assert-RegistryFailure $result 'research uncovered Codex binding and not-applicable profile fail closed' 'SkillHostFrontmatterProfileCoverage'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'diagnosing-bugs' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Vscode' })[0].hosts = @('OpenCode','Antigravity') }
  Assert-RegistryFailure $result 'diagnosing-bugs uncovered applicable host fails closed' 'SkillHostFrontmatterProfileCoverage'
  $result = Invoke-EdgeCase 'skills' { param($c) @((@($c.skills.items | Where-Object { [string]$_.id -eq 'bug-review-sweep' }))[0].hostFrontmatterProfiles)[0].hosts = @('Cursor') }
  Assert-RegistryFailure $result 'bug-review-sweep profile covering a not-applicable host fails closed' 'SkillHostFrontmatterProfileApplicability'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'implementation-plan' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Vscode' })[0].hosts = @('OpenCode','Antigravity') }
  Assert-RegistryFailure $result 'uncovered applicable host binding fails closed' 'SkillHostFrontmatterProfileCoverage'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'composer' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Antigravity' })[0].hosts = @('OpenCode') }
  Assert-RegistryFailure $result 'composer per-source profile removal fails closed' 'SkillHostFrontmatterProfileCoverage'
  $result = Invoke-EdgeCase 'skills' { param($c) @((@($c.skills.items | Where-Object { [string]$_.id -eq 'plan-review' }))[0].hostFrontmatterProfiles)[0].hosts = @('Cline') }
  Assert-RegistryFailure $result 'profile covering a not-applicable host fails closed' 'SkillHostFrontmatterProfileApplicability'
  $result = Invoke-EdgeCase 'skills' { param($c) @((@($c.skills.items | Where-Object { [string]$_.id -eq 'implementation-review' }))[0].hostFrontmatterProfiles)[4].hosts = @('Cline') }
  Assert-RegistryFailure $result 'implementation-review profile covering a not-applicable host fails closed' 'SkillHostFrontmatterProfileApplicability'
  $result = Invoke-EdgeCase 'skills' { param($c) @((@($c.skills.items | Where-Object { [string]$_.id -eq 'plan-review' }))[0].hostFrontmatterProfiles)[1].hosts = @('OpenCode','Codex') }
  Assert-RegistryFailure $result 'overlapping profile host coverage fails closed' 'SkillHostFrontmatterProfileOverlap'
  $result = Invoke-EdgeCase 'skills' { param($c) @((@($c.skills.items | Where-Object { [string]$_.id -eq 'implementation-review' }))[0].hostFrontmatterProfiles)[2].hosts = @('OpenCode') }
  Assert-RegistryFailure $result 'implementation-review per-source profile consolidation fails closed' 'SkillHostFrontmatterProfileOverlap'
  foreach ($profileId in @('domain-modeling','grilling','prototype')) {
    $result = Invoke-EdgeCase 'skills' { param($c) (@($c.skills.items | Where-Object { [string]$_.id -eq $profileId }))[0].PSObject.Properties.Remove('hostFrontmatterProfiles') }.GetNewClosure()
    Assert-RegistryFailure $result "$profileId profile removal fails closed" 'SkillHostFrontmatterProfileMissing'
    $result = Invoke-EdgeCase 'skills' { param($c) @((@($c.skills.items | Where-Object { [string]$_.id -eq $profileId }))[0].hostFrontmatterProfiles)[0].hosts = @('Cursor') }.GetNewClosure()
    Assert-RegistryFailure $result "$profileId profile covering a not-applicable host fails closed" 'SkillHostFrontmatterProfileCoverage'
    $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.skills_inventory.canonical_skills | Where-Object { [string]$_.id -eq $profileId }))[0].host_applicability | Where-Object { $_.host -eq 'Codex' } | ForEach-Object { $_.source = 'skills/roadmap/SKILL.md' } }.GetNewClosure()
    Assert-RegistryFailure $result "$profileId wrong-source routing fails closed" 'SkillWrapperRouting'
    $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq $profileId }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].description.lines = @('Wrong plain scalar.') }.GetNewClosure()
    Assert-RegistryFailure $result "$profileId Codex plain-scalar wrapper description mismatch fails closed" 'SkillWrapperFrontmatterShadow'
    $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq $profileId }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].modelInvocationDisabled = $true }.GetNewClosure()
    Assert-RegistryFailure $result "$profileId Codex disable mismatch fails closed" 'SkillWrapperDisableModelInvocation'
    $notApplicableHost = if ($profileId -eq 'domain-modeling') { 'Cursor' } elseif ($profileId -eq 'grilling') { 'Kilocode' } else { 'Cline' }
    $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq $notApplicableHost }))[0].entries += [pscustomobject]@{ source = "skills/$profileId/SKILL.md"; destination = "skills/$profileId/SKILL.md" } }.GetNewClosure()
    Assert-RegistryFailure $result "$profileId not-applicable delivery injection fails closed" 'SkillWrapperNotApplicable'
  }
  foreach ($profileId in @('tdd','resolving-merge-conflicts','teach','wait-what','wizard')) {
    $result = Invoke-EdgeCase 'skills' { param($c) (@($c.skills.items | Where-Object { [string]$_.id -eq $profileId }))[0].PSObject.Properties.Remove('hostFrontmatterProfiles') }.GetNewClosure()
    Assert-RegistryFailure $result "$profileId profile removal fails closed" 'SkillHostFrontmatterProfileMissing'
    $result = Invoke-EdgeCase 'skills' { param($c) @((@($c.skills.items | Where-Object { [string]$_.id -eq $profileId }))[0].hostFrontmatterProfiles)[0].hosts = @('Cursor') }.GetNewClosure()
    Assert-RegistryFailure $result "$profileId uncovered Codex binding and not-applicable profile fail closed" 'SkillHostFrontmatterProfileCoverage'
    $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.skills_inventory.canonical_skills | Where-Object { [string]$_.id -eq $profileId }))[0].host_applicability | Where-Object { $_.host -eq 'Codex' } | ForEach-Object { $_.source = 'skills/roadmap/SKILL.md' } }.GetNewClosure()
    Assert-RegistryFailure $result "$profileId wrong-source routing fails closed" 'SkillWrapperRouting'
    $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq $profileId }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].description.lines = @('Wrong plain scalar.') }.GetNewClosure()
    Assert-RegistryFailure $result "$profileId Codex plain-scalar wrapper description mismatch fails closed" 'SkillWrapperFrontmatterShadow'
    $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq $profileId }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].modelInvocationDisabled = $true }.GetNewClosure()
    Assert-RegistryFailure $result "$profileId Codex disable mismatch fails closed" 'SkillWrapperDisableModelInvocation'
    $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq $profileId }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].wrapperSource = 'overlays/codex/skills/roadmap/SKILL.md' }.GetNewClosure()
    Assert-RegistryFailure $result "$profileId wrong profile-source routing fails closed" 'SkillWrapperRouting'
    $notApplicableHost = if ($profileId -eq 'tdd') { 'Cursor' } elseif ($profileId -eq 'resolving-merge-conflicts') { 'Kilocode' } elseif ($profileId -eq 'teach') { 'OpenCode' } elseif ($profileId -eq 'wait-what') { 'Antigravity' } else { 'Vscode' }
    $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq $notApplicableHost }))[0].entries += [pscustomobject]@{ source = "skills/$profileId/SKILL.md"; destination = "skills/$profileId/SKILL.md" } }.GetNewClosure()
    Assert-RegistryFailure $result "$profileId not-applicable delivery injection fails closed" 'SkillWrapperNotApplicable'
    $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq 'Codex' }))[0].entries += [pscustomobject]@{ source = "skills/$profileId/SKILL.md"; destination = "$profileId/SKILL.md" } }.GetNewClosure()
    Assert-RegistryFailure $result "$profileId duplicate manifest delivery fails closed" 'SkillWrapperManifestInventory'
    $result = Invoke-SkillInventoryEdgeCase { param($i) $codexManifest = @(@($i.manifests | Where-Object { [string]$_.host -eq 'Codex' }))[0]; $codexManifest.entries = @($codexManifest.entries | Where-Object { -not ($_.source -ceq "skills/$profileId/SKILL.md" -and $_.destination -ceq "$profileId/SKILL.md") }) }.GetNewClosure()
    Assert-RegistryFailure $result "$profileId missing manifest delivery fails closed" 'SkillWrapperManifestInventory'
  }
  $governedSkillIdSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  foreach ($governedId in @(& (Get-Module ProcedureRegistry) { $script:SkillHostFrontmatterProfileSkillIds })) { $null = $governedSkillIdSet.Add([string]$governedId) }
  $catalogSkillIdSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  foreach ($skillItem in $registry.Catalogs.skills.items) { $null = $catalogSkillIdSet.Add([string]$skillItem.id) }
  Assert-View 'governed profile skill set equals the full catalog skill set' ($governedSkillIdSet.Count -eq 22 -and $catalogSkillIdSet.Count -eq 22 -and $governedSkillIdSet.SetEquals($catalogSkillIdSet)) "governed=$($governedSkillIdSet.Count) catalog=$($catalogSkillIdSet.Count)"
  $registryModule = Get-Module ProcedureRegistry
  $governedSkillIdBackup = @(& $registryModule { $script:SkillHostFrontmatterProfileSkillIds })
  try {
    & $registryModule { $script:SkillHostFrontmatterProfileSkillIds = @($script:SkillHostFrontmatterProfileSkillIds | Where-Object { $_ -cne 'composer' }) }
    $result = Invoke-EdgeCase 'skills' { param($c) }
    Assert-RegistryFailure $result 'uncovered governed catalog skill fails the blocking closeout guard' 'SkillHostFrontmatterProfileGuard'
    & $registryModule { $script:SkillHostFrontmatterProfileSkillIds = @($script:SkillHostFrontmatterProfileSkillIds) + @('not-a-catalog-skill') }
    $result = Invoke-EdgeCase 'skills' { param($c) }
    Assert-RegistryFailure $result 'profile guard identity outside the registered governed set fails closed' 'SkillHostFrontmatterProfileGuard'
  } finally {
    & $registryModule { $script:SkillHostFrontmatterProfileSkillIds = $args[0] } $governedSkillIdBackup
  }
  foreach ($phase3KId in @('opencode-headless-run','opencode-history-search')) {
    $result = Invoke-EdgeCase 'skills' { param($c) (@($c.skills.items | Where-Object { [string]$_.id -eq $phase3KId }))[0].PSObject.Properties.Remove('hostFrontmatterProfiles') }.GetNewClosure()
    Assert-RegistryFailure $result "$phase3KId profile removal fails closed" 'SkillHostFrontmatterProfileMissing'
    $result = Invoke-EdgeCase 'skills' { param($c) @((@($c.skills.items | Where-Object { [string]$_.id -eq $phase3KId }))[0].hostFrontmatterProfiles)[0].hosts = @('Cline') }.GetNewClosure()
    Assert-RegistryFailure $result "$phase3KId uncovered Codex binding and not-applicable profile fail closed" 'SkillHostFrontmatterProfileCoverage'
    $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.skills_inventory.canonical_skills | Where-Object { [string]$_.id -eq $phase3KId }))[0].host_applicability | Where-Object { $_.host -eq 'Codex' } | ForEach-Object { $_.source = 'skills/roadmap/SKILL.md' } }.GetNewClosure()
    Assert-RegistryFailure $result "$phase3KId wrong-source routing fails closed" 'SkillWrapperRouting'
    $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq $phase3KId }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].description.lines = @('Wrong plain scalar.') }.GetNewClosure()
    Assert-RegistryFailure $result "$phase3KId Codex plain-scalar wrapper description mismatch fails closed" 'SkillWrapperFrontmatterShadow'
    $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq $phase3KId }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].modelInvocationDisabled = $true }.GetNewClosure()
    Assert-RegistryFailure $result "$phase3KId Codex disable mismatch fails closed" 'SkillWrapperDisableModelInvocation'
    $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq $phase3KId }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].wrapperSource = 'overlays/codex/skills/roadmap/SKILL.md' }.GetNewClosure()
    Assert-RegistryFailure $result "$phase3KId wrong profile-source routing fails closed" 'SkillWrapperRouting'
    $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq 'Cline' }))[0].entries += [pscustomobject]@{ source = "skills/$phase3KId/SKILL.md"; destination = "skills/$phase3KId/SKILL.md" } }.GetNewClosure()
    Assert-RegistryFailure $result "$phase3KId not-applicable delivery injection fails closed" 'SkillWrapperNotApplicable'
    $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq 'Codex' }))[0].entries += [pscustomobject]@{ source = "skills/$phase3KId/SKILL.md"; destination = "$phase3KId/SKILL.md" } }.GetNewClosure()
    Assert-RegistryFailure $result "$phase3KId duplicate manifest delivery fails closed" 'SkillWrapperManifestInventory'
    $result = Invoke-SkillInventoryEdgeCase { param($i) $codexManifest = @(@($i.manifests | Where-Object { [string]$_.host -eq 'Codex' }))[0]; $codexManifest.entries = @($codexManifest.entries | Where-Object { -not ($_.source -ceq "skills/$phase3KId/SKILL.md" -and $_.destination -ceq "$phase3KId/SKILL.md") }) }.GetNewClosure()
    Assert-RegistryFailure $result "$phase3KId missing manifest delivery fails closed" 'SkillWrapperManifestInventory'
  }
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'plan-review' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].description.lines = @('Wrong wrapper description.') }
  Assert-RegistryFailure $result 'wrapper description mismatch fails closed' 'SkillWrapperFrontmatterShadow'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'implementation-review' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Antigravity' })[0].description.lines = @('Wrong authored delta description.') }
  Assert-RegistryFailure $result 'implementation-review authored wrapper description mismatch fails closed' 'SkillWrapperFrontmatterShadow'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'discovery' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'OpenCode' })[0].description.lines = @('Wrong shared wrapper description.') }
  Assert-RegistryFailure $result 'discovery shared wrapper description mismatch fails closed' 'SkillWrapperFrontmatterShadow'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'documentation-architecture' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'OpenCode' })[0].description.lines = @('Wrong shared wrapper description.') }
  Assert-RegistryFailure $result 'documentation-architecture shared wrapper description mismatch fails closed' 'SkillWrapperFrontmatterShadow'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'roadmap' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'OpenCode' })[0].description.lines = @('Wrong shared wrapper description.') }
  Assert-RegistryFailure $result 'roadmap shared wrapper description mismatch fails closed' 'SkillWrapperFrontmatterShadow'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'bug-review-sweep' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].description.lines = @('Wrong plain scalar.') }
  Assert-RegistryFailure $result 'bug-review-sweep Codex plain-scalar wrapper description mismatch fails closed' 'SkillWrapperFrontmatterShadow'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'diagnosing-bugs' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'OpenCode' })[0].description.lines = @('Wrong shared wrapper description.') }
  Assert-RegistryFailure $result 'diagnosing-bugs shared wrapper description mismatch fails closed' 'SkillWrapperFrontmatterShadow'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'implementation-plan' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Cursor' })[0].modelInvocationDisabled = $false }
  Assert-RegistryFailure $result 'wrapper disable-model-invocation mismatch fails closed' 'SkillWrapperDisableModelInvocation'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'documentation-architecture' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Cursor' })[0].modelInvocationDisabled = $false }
  Assert-RegistryFailure $result 'documentation-architecture Cursor disable-model-invocation mismatch fails closed' 'SkillWrapperDisableModelInvocation'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'composer' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Cursor' })[0].modelInvocationDisabled = $false }
  Assert-RegistryFailure $result 'composer Cursor disable-flag asymmetry mismatch fails closed' 'SkillWrapperDisableModelInvocation'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'roadmap' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Cursor' })[0].modelInvocationDisabled = $false }
  Assert-RegistryFailure $result 'roadmap Cursor disable-flag asymmetry mismatch fails closed' 'SkillWrapperDisableModelInvocation'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'diagnosing-bugs' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].modelInvocationDisabled = $true }
  Assert-RegistryFailure $result 'diagnosing-bugs Codex disable mismatch fails closed' 'SkillWrapperDisableModelInvocation'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'implementation-plan' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'OpenCode' })[0].wrapperSource = 'overlays/antigravity/skills/implementation-plan/SKILL.md' }
  Assert-RegistryFailure $result 'profile wrapper source disagreement fails closed' 'SkillWrapperRouting'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'implementation-review' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Antigravity' })[0].wrapperSource = 'overlays/opencode/skills/implementation-review/SKILL.md' }
  Assert-RegistryFailure $result 'implementation-review authored-source consolidation fails closed' 'SkillWrapperRouting'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'diagnosing-bugs' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].wrapperSource = 'overlays/opencode/skills/diagnosing-bugs/SKILL.md' }
  Assert-RegistryFailure $result 'diagnosing-bugs wrong-source routing fails closed' 'SkillWrapperRouting'
  $result = Invoke-EdgeCase 'skills' { param($c) (@($c.skills.items | Where-Object { [string]$_.id -eq 'architecture-survey' }))[0].PSObject.Properties.Remove('hostFrontmatterProfiles') }
  Assert-RegistryFailure $result 'architecture-survey profile removal fails closed' 'SkillHostFrontmatterProfileMissing'
  $result = Invoke-EdgeCase 'skills' { param($c) (@($c.skills.items | Where-Object { [string]$_.id -eq 'codebase-design' }))[0].PSObject.Properties.Remove('hostFrontmatterProfiles') }
  Assert-RegistryFailure $result 'codebase-design profile removal fails closed' 'SkillHostFrontmatterProfileMissing'
  $result = Invoke-EdgeCase 'skills' { param($c) @((@($c.skills.items | Where-Object { [string]$_.id -eq 'architecture-survey' }))[0].hostFrontmatterProfiles)[0].hosts = @('Cursor') }
  Assert-RegistryFailure $result 'architecture-survey uncovered Codex binding and not-applicable profile fail closed' 'SkillHostFrontmatterProfileCoverage'
  $result = Invoke-EdgeCase 'skills' { param($c) @((@($c.skills.items | Where-Object { [string]$_.id -eq 'codebase-design' }))[0].hostFrontmatterProfiles)[0].hosts = @('Cursor') }
  Assert-RegistryFailure $result 'codebase-design uncovered Codex binding and not-applicable profile fail closed' 'SkillHostFrontmatterProfileCoverage'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'architecture-survey' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].description.lines = @('Wrong plain scalar.') }
  Assert-RegistryFailure $result 'architecture-survey Codex plain-scalar wrapper description mismatch fails closed' 'SkillWrapperFrontmatterShadow'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'codebase-design' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].description.lines = @('Wrong plain scalar.') }
  Assert-RegistryFailure $result 'codebase-design Codex plain-scalar wrapper description mismatch fails closed' 'SkillWrapperFrontmatterShadow'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'architecture-survey' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].modelInvocationDisabled = $true }
  Assert-RegistryFailure $result 'architecture-survey Codex disable mismatch fails closed' 'SkillWrapperDisableModelInvocation'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'codebase-design' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].modelInvocationDisabled = $true }
  Assert-RegistryFailure $result 'codebase-design Codex disable mismatch fails closed' 'SkillWrapperDisableModelInvocation'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'architecture-survey' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].wrapperSource = 'overlays/codex/skills/codebase-design/SKILL.md' }
  Assert-RegistryFailure $result 'architecture-survey wrong-source routing fails closed' 'SkillWrapperRouting'
  $result = Invoke-EdgeCase 'skills' { param($c) (@((@($c.skills.items | Where-Object { [string]$_.id -eq 'codebase-design' }))[0].hostFrontmatterProfiles) | Where-Object { @($_.hosts) -contains 'Codex' })[0].wrapperSource = 'overlays/codex/skills/architecture-survey/SKILL.md' }
  Assert-RegistryFailure $result 'codebase-design wrong-source routing fails closed' 'SkillWrapperRouting'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.skills_inventory.canonical_skills | Where-Object { [string]$_.id -eq 'implementation-plan' }))[0].host_applicability | Where-Object { [string]$_.host -eq 'Antigravity' } | ForEach-Object { $_.source = 'skills/implementation-plan/SKILL.md' } }
  Assert-RegistryFailure $result 'shared wrapper source rebinding fails closed' 'SkillWrapperRouting'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.skills_inventory.canonical_skills | Where-Object { [string]$_.id -eq 'composer' }))[0].host_applicability | Where-Object { $_.host -eq 'Vscode' } | ForEach-Object { $_.source = 'shared:skills/composer/SKILL.md' } }
  Assert-RegistryFailure $result 'composer authored wrapper source rebinding fails closed' 'SkillWrapperRouting'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.skills_inventory.canonical_skills | Where-Object { [string]$_.id -eq 'discovery' }))[0].host_applicability | Where-Object { $_.host -eq 'Antigravity' } | ForEach-Object { $_.source = 'shared:skills/implementation-plan/SKILL.md' } }
  Assert-RegistryFailure $result 'discovery wrong-source routing fails closed' 'SkillWrapperRouting'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.skills_inventory.canonical_skills | Where-Object { [string]$_.id -eq 'documentation-architecture' }))[0].host_applicability | Where-Object { $_.host -eq 'Vscode' } | ForEach-Object { $_.source = 'shared:skills/discovery/SKILL.md' } }
  Assert-RegistryFailure $result 'documentation-architecture wrong-source routing fails closed' 'SkillWrapperRouting'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.skills_inventory.canonical_skills | Where-Object { [string]$_.id -eq 'roadmap' }))[0].host_applicability | Where-Object { $_.host -eq 'Antigravity' } | ForEach-Object { $_.source = 'shared:skills/discovery/SKILL.md' } }
  Assert-RegistryFailure $result 'roadmap wrong-source routing fails closed' 'SkillWrapperRouting'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.skills_inventory.canonical_skills | Where-Object { [string]$_.id -eq 'research' }))[0].host_applicability | Where-Object { $_.host -eq 'Codex' } | ForEach-Object { $_.source = 'skills/roadmap/SKILL.md' } }
  Assert-RegistryFailure $result 'research wrong-source routing fails closed' 'SkillWrapperRouting'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.skills_inventory.canonical_skills | Where-Object { [string]$_.id -eq 'architecture-survey' }))[0].host_applicability | Where-Object { $_.host -eq 'Codex' } | ForEach-Object { $_.source = 'skills/codebase-design/SKILL.md' } }
  Assert-RegistryFailure $result 'architecture-survey wrong-source routing fails closed' 'SkillWrapperRouting'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.skills_inventory.canonical_skills | Where-Object { [string]$_.id -eq 'codebase-design' }))[0].host_applicability | Where-Object { $_.host -eq 'Codex' } | ForEach-Object { $_.source = 'skills/architecture-survey/SKILL.md' } }
  Assert-RegistryFailure $result 'codebase-design wrong-source routing fails closed' 'SkillWrapperRouting'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq 'Cursor' }))[0].entries += [pscustomobject]@{ source = 'skills/plan-review/SKILL.md'; destination = 'skills/plan-review/SKILL.md' } }
  Assert-RegistryFailure $result 'declared not-applicable wrapper delivery fails closed' 'SkillWrapperNotApplicable'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq 'Kilocode' }))[0].entries += [pscustomobject]@{ source = 'skills/composer/SKILL.md'; destination = 'skills/composer/SKILL.md' } }
  Assert-RegistryFailure $result 'composer not-applicable delivery injection fails closed' 'SkillWrapperNotApplicable'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq 'Cursor' }))[0].entries += [pscustomobject]@{ source = 'skills/discovery/SKILL.md'; destination = 'skills/discovery/SKILL.md' } }
  Assert-RegistryFailure $result 'discovery not-applicable delivery injection fails closed' 'SkillWrapperNotApplicable'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq 'Kilocode' }))[0].entries += [pscustomobject]@{ source = 'skills/documentation-architecture/SKILL.md'; destination = 'skills/documentation-architecture/SKILL.md' } }
  Assert-RegistryFailure $result 'documentation-architecture not-applicable delivery injection fails closed' 'SkillWrapperNotApplicable'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq 'Kilocode' }))[0].entries += [pscustomobject]@{ source = 'skills/roadmap/SKILL.md'; destination = 'skills/roadmap/SKILL.md' } }
  Assert-RegistryFailure $result 'roadmap not-applicable delivery injection fails closed' 'SkillWrapperNotApplicable'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq 'Cursor' }))[0].entries += [pscustomobject]@{ source = 'skills/research/SKILL.md'; destination = 'skills/research/SKILL.md' } }
  Assert-RegistryFailure $result 'research not-applicable delivery injection fails closed' 'SkillWrapperNotApplicable'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq 'Kilocode' }))[0].entries += [pscustomobject]@{ source = 'skills/bug-review-sweep/SKILL.md'; destination = 'skills/bug-review-sweep/SKILL.md' } }
  Assert-RegistryFailure $result 'bug-review-sweep not-applicable delivery injection fails closed' 'SkillWrapperNotApplicable'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq 'Cursor' }))[0].entries += [pscustomobject]@{ source = 'skills/diagnosing-bugs/SKILL.md'; destination = 'skills/diagnosing-bugs/SKILL.md' } }
  Assert-RegistryFailure $result 'diagnosing-bugs not-applicable delivery injection fails closed' 'SkillWrapperNotApplicable'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq 'Kilocode' }))[0].entries += [pscustomobject]@{ source = 'skills/architecture-survey/SKILL.md'; destination = 'skills/architecture-survey/SKILL.md' } }
  Assert-RegistryFailure $result 'architecture-survey not-applicable delivery injection fails closed' 'SkillWrapperNotApplicable'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq 'Kilocode' }))[0].entries += [pscustomobject]@{ source = 'skills/codebase-design/SKILL.md'; destination = 'skills/codebase-design/SKILL.md' } }
  Assert-RegistryFailure $result 'codebase-design not-applicable delivery injection fails closed' 'SkillWrapperNotApplicable'
  foreach ($deliveryId in @('domain-modeling','grilling','prototype')) {
    $result = Invoke-SkillInventoryEdgeCase { param($i) @(@($i.manifests | Where-Object { [string]$_.host -eq 'Codex' }))[0].entries += [pscustomobject]@{ source = "skills/$deliveryId/SKILL.md"; destination = "$deliveryId/SKILL.md" } }.GetNewClosure()
    Assert-RegistryFailure $result "$deliveryId duplicate manifest delivery fails closed" 'SkillWrapperManifestInventory'
    $result = Invoke-SkillInventoryEdgeCase { param($i) $codexManifest = @(@($i.manifests | Where-Object { [string]$_.host -eq 'Codex' }))[0]; $codexManifest.entries = @($codexManifest.entries | Where-Object { -not ($_.source -ceq "skills/$deliveryId/SKILL.md" -and $_.destination -ceq "$deliveryId/SKILL.md") }) }.GetNewClosure()
    Assert-RegistryFailure $result "$deliveryId missing manifest delivery fails closed" 'SkillWrapperManifestInventory'
  }
  $result = Invoke-SkillInventoryEdgeCase { param($i) $i.manifests = @($i.manifests | Where-Object { [string]$_.host -ne 'Cline' }) }
  Assert-RegistryFailure $result 'missing host manifest evidence fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) @($i.manifests | Where-Object { [string]$_.host -eq 'Cline' })[0].PSObject.Properties.Remove('entries') }
  Assert-RegistryFailure $result 'manifest without entries fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $i.manifests = @($i.manifests) + @($i.manifests[0]) }
  Assert-RegistryFailure $result 'duplicate host manifest inventory fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $cursorManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Cursor' })[0]; $cursorManifest.entries = @($cursorManifest.entries | Where-Object { -not ($_.source -ceq 'skills/implementation-plan/SKILL.md' -and $_.destination -ceq 'skills/implementation-plan/SKILL.md') }) }
  Assert-RegistryFailure $result 'applicable wrapper without a delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $vscodeManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Vscode' })[0]; $vscodeManifest.entries = @($vscodeManifest.entries | Where-Object { -not ($_.source -ceq 'skills/composer/SKILL.md' -and $_.destination -ceq 'skills/composer/SKILL.md') }) }
  Assert-RegistryFailure $result 'composer applicable wrapper without a delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $opencodeManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'OpenCode' })[0]; $opencodeManifest.entries = @($opencodeManifest.entries | Where-Object { -not ($_.source -ceq 'skills/discovery/SKILL.md' -and $_.destination -ceq 'skills/discovery/SKILL.md') }) }
  Assert-RegistryFailure $result 'discovery applicable wrapper without a delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $cursorManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Cursor' })[0]; $cursorManifest.entries = @($cursorManifest.entries | Where-Object { -not ($_.source -ceq 'skills/documentation-architecture/SKILL.md' -and $_.destination -ceq 'skills/documentation-architecture/SKILL.md') }) }
  Assert-RegistryFailure $result 'documentation-architecture applicable wrapper without a delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $cursorManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Cursor' })[0]; $cursorManifest.entries = @($cursorManifest.entries | Where-Object { -not ($_.source -ceq 'skills/roadmap/SKILL.md' -and $_.destination -ceq 'skills/roadmap/SKILL.md') }) }
  Assert-RegistryFailure $result 'roadmap applicable wrapper without a delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $codexManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Codex' })[0]; $codexManifest.entries = @($codexManifest.entries | Where-Object { -not ($_.source -ceq 'skills/research/SKILL.md' -and $_.destination -ceq 'research/SKILL.md') }) }
  Assert-RegistryFailure $result 'research applicable wrapper without a delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $codexManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Codex' })[0]; $codexManifest.entries = @($codexManifest.entries | Where-Object { -not ($_.source -ceq 'skills/bug-review-sweep/SKILL.md' -and $_.destination -ceq 'bug-review-sweep/SKILL.md') }) }
  Assert-RegistryFailure $result 'bug-review-sweep applicable wrapper without a delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $opencodeManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'OpenCode' })[0]; $opencodeManifest.entries = @($opencodeManifest.entries | Where-Object { -not ($_.source -ceq 'skills/diagnosing-bugs/SKILL.md' -and $_.destination -ceq 'skills/diagnosing-bugs/SKILL.md') }) }
  Assert-RegistryFailure $result 'diagnosing-bugs applicable wrapper without a delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $codexManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Codex' })[0]; $codexManifest.entries = @($codexManifest.entries | Where-Object { -not ($_.source -ceq 'skills/architecture-survey/SKILL.md' -and $_.destination -ceq 'architecture-survey/SKILL.md') }) }
  Assert-RegistryFailure $result 'architecture-survey applicable wrapper without a delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $codexManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Codex' })[0]; $codexManifest.entries = @($codexManifest.entries | Where-Object { -not ($_.source -ceq 'skills/codebase-design/SKILL.md' -and $_.destination -ceq 'codebase-design/SKILL.md') }) }
  Assert-RegistryFailure $result 'codebase-design applicable wrapper without a delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $cursorManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Cursor' })[0]; $cursorManifest.entries = @($cursorManifest.entries) + @(@($cursorManifest.entries | Where-Object { $_.source -ceq 'skills/implementation-plan/SKILL.md' }) | Select-Object -First 1) }
  Assert-RegistryFailure $result 'duplicate delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $antigravityManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Antigravity' })[0]; $antigravityManifest.entries = @($antigravityManifest.entries) + @(@($antigravityManifest.entries | Where-Object { $_.source -ceq 'skills/implementation-review/SKILL.md' }) | Select-Object -First 1) }
  Assert-RegistryFailure $result 'implementation-review duplicate delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $antigravityManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Antigravity' })[0]; $antigravityManifest.entries = @($antigravityManifest.entries) + @(@($antigravityManifest.entries | Where-Object { $_.source -ceq 'shared:skills/discovery/SKILL.md' }) | Select-Object -First 1) }
  Assert-RegistryFailure $result 'discovery duplicate delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $opencodeManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'OpenCode' })[0]; $opencodeManifest.entries = @($opencodeManifest.entries) + @(@($opencodeManifest.entries | Where-Object { $_.source -ceq 'skills/documentation-architecture/SKILL.md' }) | Select-Object -First 1) }
  Assert-RegistryFailure $result 'documentation-architecture duplicate delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $antigravityManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Antigravity' })[0]; $antigravityManifest.entries = @($antigravityManifest.entries) + @(@($antigravityManifest.entries | Where-Object { $_.source -ceq 'shared:skills/roadmap/SKILL.md' }) | Select-Object -First 1) }
  Assert-RegistryFailure $result 'roadmap duplicate delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $codexManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Codex' })[0]; $codexManifest.entries = @($codexManifest.entries) + @(@($codexManifest.entries | Where-Object { $_.source -ceq 'skills/research/SKILL.md' }) | Select-Object -First 1) }
  Assert-RegistryFailure $result 'research duplicate delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $codexManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Codex' })[0]; $codexManifest.entries = @($codexManifest.entries) + @(@($codexManifest.entries | Where-Object { $_.source -ceq 'skills/bug-review-sweep/SKILL.md' }) | Select-Object -First 1) }
  Assert-RegistryFailure $result 'bug-review-sweep duplicate delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $antigravityManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Antigravity' })[0]; $antigravityManifest.entries = @($antigravityManifest.entries) + @(@($antigravityManifest.entries | Where-Object { $_.source -ceq 'shared:skills/diagnosing-bugs/SKILL.md' }) | Select-Object -First 1) }
  Assert-RegistryFailure $result 'diagnosing-bugs duplicate delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $codexManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Codex' })[0]; $codexManifest.entries = @($codexManifest.entries) + @(@($codexManifest.entries | Where-Object { $_.source -ceq 'skills/architecture-survey/SKILL.md' }) | Select-Object -First 1) }
  Assert-RegistryFailure $result 'architecture-survey duplicate delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
  $result = Invoke-SkillInventoryEdgeCase { param($i) $codexManifest = @($i.manifests | Where-Object { [string]$_.host -eq 'Codex' })[0]; $codexManifest.entries = @($codexManifest.entries) + @(@($codexManifest.entries | Where-Object { $_.source -ceq 'skills/codebase-design/SKILL.md' }) | Select-Object -First 1) }
  Assert-RegistryFailure $result 'codebase-design duplicate delivering manifest entry fails closed' 'SkillWrapperManifestInventory'
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
  $profileExtraCatalog = Get-FreshCatalogs
  @(@($profileExtraCatalog.skills.items | Where-Object { [string]$_.id -eq 'plan-review' }).hostFrontmatterProfiles)[0] | Add-Member Destination 'owned-by-registry'
  Assert-View 'schema rejects unknown host frontmatter profile metadata' (-not (Test-Json -Json ($profileExtraCatalog.skills | ConvertTo-Json -Depth 12) -Schema $schemaJson -ErrorAction SilentlyContinue))
  $profileHostCatalog = Get-FreshCatalogs
  @(@($profileHostCatalog.skills.items | Where-Object { [string]$_.id -eq 'plan-review' }).hostFrontmatterProfiles)[0].hosts = @('NotAHost')
  Assert-View 'schema rejects unknown profile host' (-not (Test-Json -Json ($profileHostCatalog.skills | ConvertTo-Json -Depth 12) -Schema $schemaJson -ErrorAction SilentlyContinue))
  $profileFlagCatalog = Get-FreshCatalogs
  @(@($profileFlagCatalog.skills.items | Where-Object { [string]$_.id -eq 'plan-review' }).hostFrontmatterProfiles)[0].modelInvocationDisabled = 'yes'
  Assert-View 'schema rejects non-boolean profile modelInvocationDisabled' (-not (Test-Json -Json ($profileFlagCatalog.skills | ConvertTo-Json -Depth 12) -Schema $schemaJson -ErrorAction SilentlyContinue))
  $duplicateHostCatalog = Get-FreshCatalogs
  @(@($duplicateHostCatalog.skills.items | Where-Object { [string]$_.id -eq 'plan-review' }).hostFrontmatterProfiles)[0].hosts = @('OpenCode','OpenCode')
  Assert-View 'schema rejects duplicate profile hosts' (-not (Test-Json -Json ($duplicateHostCatalog.skills | ConvertTo-Json -Depth 12) -Schema $schemaJson -ErrorAction SilentlyContinue))

  $original = Get-RegistryManagedView -Catalogs $registry.Catalogs -RepoRoot $RepoRoot
  $originalRows = @([string]$original.Files['composition-order.tsv'] -split "`r?`n" | Where-Object { $_ })
  $reorderedCatalogs = Get-FreshCatalogs
  $order = @($reorderedCatalogs.workflows.semanticOrder)
  # Phase 4D: Antigravity compositions are runtimeOnly and excluded from managed
  # output. Swap managed composition indices (0 ↔ 3) so the assertion remains
  # meaningful for managed-view sequence control.
  $swap = $order[0]; $order[0] = $order[3]; $order[3] = $swap
  $reorderedCatalogs.workflows.semanticOrder = $order
  $reordered = Get-RegistryManagedView -Catalogs $reorderedCatalogs -RepoRoot $RepoRoot
  $reorderedRows = @([string]$reordered.Files['composition-order.tsv'] -split "`r?`n" | Where-Object { $_ })
  Assert-View 'semantic order controls rendered composition rows' (($originalRows.Count -eq $reorderedRows.Count) -and ($originalRows[1] -ne $reorderedRows[1]) -and ($originalRows[4] -ne $reorderedRows[4]))
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

  # --- Phase 4A: composition renderer, semantic-order validator, and boundary verifier ---
  $compositionFileKeys = @($one.Files.Keys | Where-Object { $_ -like 'compositions/*' })
  Assert-View 'composition render produces six managed files' ($compositionFileKeys.Count -eq 6) "count=$($compositionFileKeys.Count)"
  $nonRuntimeOrderIds = @($registry.Catalogs.workflows.compositions | Where-Object {
    -not ($_.PSObject.Properties['runtimeOnly'] -and [bool]$_.runtimeOnly)
  } | ForEach-Object { [string]$_.id })
  Assert-View 'composition render order matches registry semantic order' (
    (@($compositionFileKeys) -join '|') -ceq (@($registry.Catalogs.workflows.semanticOrder | Where-Object { $_ -in $nonRuntimeOrderIds } | ForEach-Object { "compositions/$($_).md" }) -join '|')
  ) "observed=$(($compositionFileKeys | Select-Object -First 3) -join '|')"
  $invOverlayRoots = @{}
  foreach ($invManifest in @($registry.Inventory.manifests)) { $invOverlayRoots[[string]$invManifest.host] = @{ Overlay = $invManifest.overlay_root; Shared = $invManifest.shared_root } }
  foreach ($compositionItem in @($registry.Catalogs.workflows.compositions)) {
    if ($compositionItem.PSObject.Properties['runtimeOnly'] -and [bool]$compositionItem.runtimeOnly) { continue }
    $cid = [string]$compositionItem.id
    $expectedContent = ''
    foreach ($reference in @($compositionItem.references)) {
      $refPath = Get-RegistryCompositionReferencePath -Reference ([string]$reference) -HostName ([string]$compositionItem.host) -OverlayRoots $invOverlayRoots
      $expectedContent += [Text.UTF8Encoding]::new($false).GetString([IO.File]::ReadAllBytes((Join-Path $RepoRoot $refPath)))
    }
    $observedContent = [string]$one.Files["compositions/$cid.md"]
    Assert-View "composition $cid content matches reference concatenation" ($observedContent -ceq $expectedContent) "observed=$($observedContent.Length) expected=$($expectedContent.Length)"
  }
  $originalCompKeys = @($original.Files.Keys | Where-Object { $_ -like 'compositions/*' })
  $reorderedCompKeys = @($reordered.Files.Keys | Where-Object { $_ -like 'compositions/*' })
  Assert-View 'semantic order controls composition file sequence' (($originalCompKeys.Count -eq $reorderedCompKeys.Count) -and ($originalCompKeys[0] -ne $reorderedCompKeys[0]) -and ($originalCompKeys[1] -ne $reorderedCompKeys[1])) "orig0=$($originalCompKeys[0]) reord0=$($reorderedCompKeys[0])"
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.compositions[0].references = @($c.workflows.compositions[0].references) + @($c.workflows.compositions[0].references[0]) }
  Assert-RegistryFailure $result 'duplicate composition reference fails closed' 'DuplicateSemanticPart'
  $unresolvedCatalogs = Get-FreshCatalogs
  $unresolvedCatalogs.workflows.compositions[0].references[0] = 'base:rules/__missing__.md'
  $unresolvedThrew = $false
  try { $null = Get-RegistryCompositionFiles -Catalogs $unresolvedCatalogs -RepoRoot $RepoRoot -Inventory $registry.Inventory } catch { $unresolvedThrew = ($_.Exception.Message -like 'FAIL: SemanticReference:*') }
  Assert-View 'unresolved composition reference fails closed in renderer' $unresolvedThrew
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.semanticOrder[0] = 'unknown-composition-id' }
  Assert-RegistryFailure $result 'unknown semantic order ID fails closed' 'SemanticOrderUnknownId'
  foreach ($protectedTree4A in @('instructions','config')) {
    $protected4AThrew = $false
    try { $null = Test-RegistryOutputRoot -OutputRoot (Join-Path $RepoRoot $protectedTree4A) -RepoRoot $RepoRoot } catch { $protected4AThrew = $true }
    Assert-View "protected output root '$protectedTree4A' fails closed" $protected4AThrew
  }
  foreach ($boundaryCase in @(
    @{ Name = 'canonical body'; Path = 'workflow/agent-invocation.md' },
    @{ Name = 'overlay leaf'; Path = 'overlays/cursor' },
    @{ Name = 'host projection GEMINI.md'; Path = 'GEMINI.md' },
    @{ Name = 'host projection AGENTS.md'; Path = 'AGENTS.md' },
    @{ Name = 'protected tree instructions'; Path = 'instructions' },
    @{ Name = 'protected tree config'; Path = 'config/generated' }
  )) {
    $boundaryThrew = $false
    try { $null = Test-RegistryCompositionOutputBoundary -OutputRoot (Join-Path $RepoRoot $boundaryCase.Path) -RepoRoot $RepoRoot -Catalogs $registry.Catalogs -Inventory $registry.Inventory } catch { $boundaryThrew = $true }
    Assert-View "composition output boundary: $($boundaryCase.Name) fails closed" $boundaryThrew
  }
  $boundaryTempOk = $false
  try { $null = Test-RegistryCompositionOutputBoundary -OutputRoot (Join-Path ([IO.Path]::GetTempPath()) 'procedure-registry-boundary-ok') -RepoRoot $RepoRoot -Catalogs $registry.Catalogs -Inventory $registry.Inventory; $boundaryTempOk = $true } catch { }
  Assert-View 'composition output boundary: temporary root passes' $boundaryTempOk
  $writeBoundaryThrew = $false
  try { $null = Write-RegistryManagedView -Catalogs $registry.Catalogs -OutputRoot (Join-Path $RepoRoot 'GEMINI.md') -RepoRoot $RepoRoot -Inventory $registry.Inventory } catch { $writeBoundaryThrew = $true }
  Assert-View 'managed writer rejects host projection output root' $writeBoundaryThrew
  $phase4aDrift = @(& git -C $RepoRoot status --porcelain -- rules workflow 'overlays')
  if ($LASTEXITCODE -ne 0) { throw "FAIL: Phase 4A drift status exited $LASTEXITCODE" }
  Assert-View 'Phase 4A leaves canonical rules, workflows, and overlay leaves unchanged' ($phase4aDrift.Count -eq 0) (($phase4aDrift | Select-Object -First 5) -join '; ')

  # --- Phase 4B: explicit always-on policy for invocation/plan-review/code-review/pre-commit on Cursor/OpenCode/Codex/Antigravity ---
  $alwaysOnItems = @($registry.Catalogs.workflows.alwaysOn)
  Assert-View 'always-on policy count is exactly 16' ($alwaysOnItems.Count -eq 16) "count=$($alwaysOnItems.Count)"
  $expected4BHosts = [string[]]@('Cursor','OpenCode','Codex','Antigravity')
  $expected4BGates = [string[]]@('invocation','plan-review','code-review','pre-commit')
  $seen4BPairs = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  $alwaysOnPolicyIds = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  foreach ($policy4B in $alwaysOnItems) {
    $policyHost = [string]$policy4B.host; $policyGate = [string]$policy4B.gate
    Assert-View "always-on host '$policyHost' is in Phase 4B host set" ($policyHost -in $expected4BHosts) "host=$policyHost"
    Assert-View "always-on gate '$policyGate' is in Phase 4B gate set" ($policyGate -in $expected4BGates) "gate=$policyGate"
    $pair4B = "${policyHost}|${policyGate}"
    Assert-View "always-on host+gate pair '${pair4B}' is unique" ($seen4BPairs.Add($pair4B)) "duplicate pair"
    $policyId = [string]$policy4B.id
    Assert-View "always-on policy ID '$policyId' is unique" ($alwaysOnPolicyIds.Add($policyId)) "duplicate policy ID"
    Assert-View "always-on canonical ref resolves" ($null -ne (@($registry.Catalogs.workflows.items + $registry.Catalogs.rules.items) | Where-Object { [string]$_.id -eq [string]$policy4B.canonicalReferenceId }) -or [string]$policy4B.canonicalReferenceId -in @('agent-invocation','iterative-plan-review','iterative-code-review','pre-commit-ci-gate')) "ref='$($policy4B.canonicalReferenceId)'"
    Assert-View "always-on policy '$policyId' has evidence paths" (@($policy4B.evidencePaths).Count -gt 0) "evidencePaths empty"
    foreach ($evidence4B in @($policy4B.evidencePaths)) {
      Assert-View "always-on policy '$policyId' evidence path exists" (Test-Path -LiteralPath (Join-Path $RepoRoot $evidence4B) -PathType Leaf) "path=$evidence4B"
    }
  }
  Assert-View 'always-on covers exactly 4x4 host+gate pairs' ($seen4BPairs.Count -eq 16) "uniquePairs=$($seen4BPairs.Count)"
  $inventoryAlwaysOn = @($registry.Inventory.rules_workflows.always_on)
  Assert-View 'inventory mirrors 16 always-on policies' ($inventoryAlwaysOn.Count -eq 16) "inventoryCount=$($inventoryAlwaysOn.Count)"
  $inventory4BPairs = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
  foreach ($invPolicy in $inventoryAlwaysOn) { $null = $inventory4BPairs.Add("$([string]$invPolicy.host)|$([string]$invPolicy.gate)") }
  Assert-View 'registry and inventory always-on coverage match' ($seen4BPairs.SetEquals($inventory4BPairs)) "registry=$($seen4BPairs.Count) inventory=$($inventory4BPairs.Count)"
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.alwaysOn[0].host = 'Vscode' }
  Assert-RegistryFailure $result 'always-on unknown host fails closed' 'AlwaysOnInvalidHost'
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.alwaysOn[0].gate = 'unknown-gate' }
  Assert-RegistryFailure $result 'always-on unknown gate fails closed' 'AlwaysOnInvalidGate'
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.alwaysOn[0].canonicalReferenceId = '__missing__' }
  Assert-RegistryFailure $result 'always-on unknown canonical ref fails closed' 'AlwaysOnInvalidCanonicalReference'
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.alwaysOn[1].canonicalReferenceId = 'agent-invocation' }
  Assert-RegistryFailure $result 'always-on canonical ref gate mismatch fails closed' 'AlwaysOnCanonicalReferenceMismatch'
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.alwaysOn[0].surface = 'codex-managed-block' }
  Assert-RegistryFailure $result 'always-on invalid surface for host fails closed' 'AlwaysOnInvalidSurface'
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.alwaysOn[1].host = $c.workflows.alwaysOn[0].host; $c.workflows.alwaysOn[1].gate = $c.workflows.alwaysOn[0].gate }
  Assert-RegistryFailure $result 'always-on duplicate host+gate fails closed' 'AlwaysOnDuplicateHostGate'
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.alwaysOn = @($c.workflows.alwaysOn | Select-Object -Skip 1) }
  Assert-RegistryFailure $result 'always-on missing host/gate coverage fails closed' 'AlwaysOnCoverage'
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.alwaysOn[0].evidencePaths = @() }
  Assert-RegistryFailure $result 'always-on empty evidence fails closed' 'AlwaysOnMissingEvidence'
  $result = Invoke-EdgeCase 'workflows' { param($c) $c.workflows.alwaysOn[0].evidencePaths[0] = 'rules/__missing_evidence__.md' }
  Assert-RegistryFailure $result 'always-on invalid evidence path fails closed' 'AlwaysOnEvidence'
  $schemaJson4B = Get-Content -Raw (Join-Path $RepoRoot 'catalog/schema/v1.json')
  $unknownAlwaysOnHost = Get-FreshCatalogs
  $unknownAlwaysOnHost.workflows.alwaysOn[0].host = 'Cline'
  Assert-View 'schema rejects always-on host outside Phase 4B set' (-not (Test-Json -Json ($unknownAlwaysOnHost.workflows | ConvertTo-Json -Depth 12) -Schema $schemaJson4B -ErrorAction SilentlyContinue))
  $unknownAlwaysOnGate = Get-FreshCatalogs
  $unknownAlwaysOnGate.workflows.alwaysOn[0].gate = 'deployment'
  Assert-View 'schema rejects unknown always-on gate' (-not (Test-Json -Json ($unknownAlwaysOnGate.workflows | ConvertTo-Json -Depth 12) -Schema $schemaJson4B -ErrorAction SilentlyContinue))
  $unknownAlwaysOnSurface = Get-FreshCatalogs
  $unknownAlwaysOnSurface.workflows.alwaysOn[0].surface = 'generic-rule'
  Assert-View 'schema rejects unknown always-on surface' (-not (Test-Json -Json ($unknownAlwaysOnSurface.workflows | ConvertTo-Json -Depth 12) -Schema $schemaJson4B -ErrorAction SilentlyContinue))
  $extraAlwaysOnField = Get-FreshCatalogs
  $extraAlwaysOnField.workflows.alwaysOn[0] | Add-Member ExtraField 'not-owned'
  Assert-View 'schema rejects extra always-on field' (-not (Test-Json -Json ($extraAlwaysOnField.workflows | ConvertTo-Json -Depth 12) -Schema $schemaJson4B -ErrorAction SilentlyContinue))
  $alwaysOnView = @([string]$one.Files['always-on.tsv'] -split "`r?`n" | Where-Object { $_ })
  Assert-View 'always-on managed view has header + 16 rows' ($alwaysOnView.Count -eq 17) "rows=$($alwaysOnView.Count)"
  $expectedAlwaysOnHeader = "host`tsurface`tdomain`tcanonicalReference`tpolicyId"
  Assert-View 'always-on managed view header is deterministic' ($alwaysOnView[0] -ceq $expectedAlwaysOnHeader) "header='$($alwaysOnView[0])'"
  $expectedAlwaysOnHostOrder = [string[]]@('Antigravity','Codex','Cursor','OpenCode')
  $expectedAlwaysOnGateOrder = [string[]]@('invocation','plan-review','code-review','pre-commit')
  for ($row4B = 1; $row4B -lt $alwaysOnView.Count; $row4B++) {
    $expectedHost = $expectedAlwaysOnHostOrder[[Math]::Floor(($row4B - 1) / 4)]
    $expectedGate = $expectedAlwaysOnGateOrder[($row4B - 1) % 4]
    $cells4B = @($alwaysOnView[$row4B] -split "`t")
    Assert-View "always-on view row $row4B deterministic ($expectedHost/$expectedGate)" ($cells4B.Count -eq 5 -and $cells4B[0] -ceq $expectedHost -and $cells4B[2] -ceq $expectedGate) "cells='$($alwaysOnView[$row4B])'"
  }
  $alwaysOnRenderB = Get-RegistryManagedView -Catalogs $registry.Catalogs -RepoRoot $RepoRoot
  Assert-View 'always-on managed view is deterministic across calls' ([string]$one.Files['always-on.tsv'] -ceq [string]$alwaysOnRenderB.Files['always-on.tsv'])

  # --- Phase 4C: Cursor hybrid rules and OpenCode AGENTS/instruction dual-write ---
  $runtimeComps = @($registry.Catalogs.workflows.compositions | Where-Object { $_.PSObject.Properties['runtimeOnly'] -and [bool]$_.runtimeOnly })
  $expectedRuntimeIds = [string[]]@(
    'antigravity-gemini','antigravity-skill',
    'cursor-agent-invocation','cursor-iterative-plan-review','cursor-iterative-code-review','cursor-pre-commit-ci-gate',
    'opencode-agents-dual-write-instructions','opencode-agents-dual-write-agents'
  )
  Assert-View 'Phase 4D registry has exactly eight runtime compositions' ($runtimeComps.Count -eq 8) "count=$($runtimeComps.Count)"
  Assert-View 'Phase 4C runtime composition IDs match expected set' (
    (@($runtimeComps | ForEach-Object { [string]$_.id }) -join '|') -ceq ($expectedRuntimeIds -join '|')
  ) "observed=$(($runtimeComps | ForEach-Object { [string]$_.id }) -join '|')"
  $runtimeOrderInSemantic = @($registry.Catalogs.workflows.semanticOrder | Where-Object { $_ -in $expectedRuntimeIds })
  Assert-View 'Phase 4D semanticOrder owns all eight runtime IDs in correct order' (
    (@($runtimeOrderInSemantic) -join '|') -ceq ($expectedRuntimeIds -join '|')
  ) "semantic=$(($runtimeOrderInSemantic) -join '|')"

  # Registry order ownership: Get-RegistryCompositionOrderById returns deterministic refs.
  $openCodeInstrRefs = Get-RegistryCompositionOrderById -Catalogs $registry.Catalogs -CompositionId 'opencode-agents-dual-write-instructions'
  $openCodeAgentsRefs = Get-RegistryCompositionOrderById -Catalogs $registry.Catalogs -CompositionId 'opencode-agents-dual-write-agents'
  $openCodeInstrRefsAgain = Get-RegistryCompositionOrderById -Catalogs $registry.Catalogs -CompositionId 'opencode-agents-dual-write-instructions'
  Assert-View 'Phase 4C OpenCode instructions composition order is deterministic' (($openCodeInstrRefs -join '|') -ceq ($openCodeInstrRefsAgain -join '|')) "refs=$(($openCodeInstrRefs) -join '|')"
  Assert-View 'Phase 4C OpenCode instruction/AGENTS registry orders are identical' (($openCodeInstrRefs -join '|') -ceq ($openCodeAgentsRefs -join '|'))
  $expectedOpenCodeRefs = [string[]]@(
    'instructions/__header__.md',
    'base:rules/agent-invocation.md',
    'base:rules/iterative-plan-review.md',
    'base:rules/iterative-code-review.md',
    'footers/instructions-wiring.md'
  )
  Assert-View 'Phase 4C OpenCode registry order matches known byte-parity reference sequence' (
    (@($openCodeInstrRefs) -join '|') -ceq ($expectedOpenCodeRefs -join '|')
  ) "observed=$(($openCodeInstrRefs) -join '|')"

  # Effective-order mismatches fail closed at both sources of the order:
  # semanticOrder -> Cursor canonical rules, and manifest composition bindings.
  $result4CCursorSemanticOrder = Invoke-EdgeCase 'workflows' {
    param($c)
    $cursorRuntimeIds = @(
      $c.workflows.semanticOrder | Where-Object {
        $semanticId = [string]$_
        $composition = @($c.workflows.compositions | Where-Object { [string]$_.id -eq $semanticId })[0]
        $null -ne $composition -and [string]$composition.host -ceq 'Cursor' -and
          $composition.PSObject.Properties['runtimeOnly'] -and [bool]$composition.runtimeOnly
      }
    )
    $firstIndex = [int]@($c.workflows.semanticOrder).IndexOf([string]$cursorRuntimeIds[0])
    $lastIndex = [int]@($c.workflows.semanticOrder).IndexOf([string]$cursorRuntimeIds[-1])
    $semantic = @($c.workflows.semanticOrder)
    $semantic[$firstIndex] = [string]$cursorRuntimeIds[-1]
    $semantic[$lastIndex] = [string]$cursorRuntimeIds[0]
    $c.workflows.semanticOrder = $semantic
  }
  Assert-RegistryFailure $result4CCursorSemanticOrder 'Phase 4C Cursor semanticOrder reorder fails' 'composition-order-ownership'

  $manifestMismatchRoot = Join-Path ([IO.Path]::GetTempPath()) ("phase4c-manifest-mismatch-" + [Guid]::NewGuid().ToString('N'))
  try {
    New-Item -ItemType Directory -Path (Join-Path $manifestMismatchRoot 'scripts/host-sync/manifests') -Force | Out-Null
    Copy-Item (Join-Path $RepoRoot 'scripts/host-sync/manifests/cursor.manifest.psd1') (Join-Path $manifestMismatchRoot 'scripts/host-sync/manifests/cursor.manifest.psd1')
    $cursorManifestPath = Join-Path $manifestMismatchRoot 'scripts/host-sync/manifests/cursor.manifest.psd1'
    $cursorManifestText = Get-Content -Raw $cursorManifestPath
    $cursorManifestText = $cursorManifestText.Replace(
      "@('agent-invocation', 'iterative-plan-review', 'iterative-code-review', 'pre-commit-ci-gate')",
      "@('iterative-plan-review', 'agent-invocation', 'iterative-code-review', 'pre-commit-ci-gate')"
    )
    Set-Content -LiteralPath $cursorManifestPath -Value $cursorManifestText -NoNewline
    $manifestFailures = [System.Collections.Generic.List[string]]::new()
    $freshWorkflows = (Get-FreshCatalogs).workflows
    & (Get-Module ProcedureRegistry) { param($Catalog,$RepoRoot,$Failures)
      Test-RegistryHostCompositionOwnership -Catalog $Catalog -RepoRoot $RepoRoot -Failures $Failures
    } $freshWorkflows $manifestMismatchRoot $manifestFailures
    Assert-View 'Phase 4C Cursor manifest rule reorder fails' (
      @($manifestFailures | Where-Object { $_ -like 'composition-order-ownership*' }).Count -gt 0
    ) (($manifestFailures | Select-Object -First 3) -join '; ')
  } finally {
    if (Test-Path -LiteralPath $manifestMismatchRoot) { Remove-Item -LiteralPath $manifestMismatchRoot -Recurse -Force }
  }

  $cursorComp1Refs = Get-RegistryCompositionOrderById -Catalogs $registry.Catalogs -CompositionId 'cursor-agent-invocation'
  Assert-View 'Phase 4C Cursor composition has three references (frontmatter, body, pointer)' (
    $cursorComp1Refs.Count -eq 3 -and
    $cursorComp1Refs[0] -ceq 'cursor-host:rules/agent-invocation.mdc#frontmatter' -and
    $cursorComp1Refs[1] -ceq 'base:rules/agent-invocation.md' -and
    $cursorComp1Refs[2] -ceq 'cursor-generated:cursor-hybrid-pointer#agent-invocation'
  ) "refs=$(($cursorComp1Refs) -join '|')"

  # Runtime compositions are excluded from managed-view composition file output.
  $allCompositionFileKeys = @($one.Files.Keys | Where-Object { $_ -like 'compositions/*' })
  Assert-View 'Phase 4C runtime compositions excluded from managed composition output' (
    $allCompositionFileKeys.Count -eq 6 -and
    @($allCompositionFileKeys | Where-Object { $_ -match 'compositions/cursor-|compositions/opencode-agents|compositions/antigravity-' }).Count -eq 0
  ) "keys=$($allCompositionFileKeys -join ';')"

  # Host composition ownership: validation passes on current working tree (uses full-catalog registry result which includes overlay roots).
  Assert-View 'Phase 4C host composition ownership passes on current tree' (
    $registry.Valid -and @($registry.Failures | Where-Object { $_ -like 'composition-order-ownership*' }).Count -eq 0
  ) (($registry.Failures | Select-Object -First 3) -join '; ')

  # Registry-owned Cursor reference reorder is valid: the registry is the sole
  # owner of runtime composition order, and no hardcoded canonical sequence is
  # used to validate it. Only cross-composition invariants reject mismatch.
  $result4CMismatch = Invoke-EdgeCase 'workflows' {
    param($c)
    $comp = @($c.workflows.compositions | Where-Object { [string]$_.id -eq 'cursor-agent-invocation' })[0]
    $refs = @($comp.references); $refs[0],$refs[1] = $refs[1],$refs[0]
    $comp.references = $refs
  }
  Assert-View 'Phase 4C Cursor registry-owned reference reorder remains valid' (
    @($result4CMismatch.Failures | Where-Object { $_ -like 'composition-order-ownership*' }).Count -eq 0
  ) (($result4CMismatch.Failures | Select-Object -First 3) -join '; ')

  $result4COrder = Invoke-EdgeCase 'workflows' {
    param($c)
    $order = @($c.workflows.semanticOrder)
    $c.workflows.semanticOrder = @($order[0],$order[0]) + @($order | Select-Object -Skip 1)
  }
  Assert-RegistryFailure $result4COrder 'Phase 4C semantic order duplication fails' 'SemanticOrderDuplicate'

  $result4COpenCodeRefs = Invoke-EdgeCase 'workflows' {
    param($c)
    $comp = @($c.workflows.compositions | Where-Object { [string]$_.id -eq 'opencode-agents-dual-write-instructions' })[0]
    $reversed = @($comp.references); [array]::Reverse($reversed)
    $comp.references = $reversed
  }
  Assert-RegistryFailure $result4COpenCodeRefs 'Phase 4C OpenCode reference sequence mismatch fails' 'composition-order-ownership'

  # OpenCode manifest fail-closed: forbidden manifest-owned Parts/Footer field.
  $openCodePartsRoot = Join-Path ([IO.Path]::GetTempPath()) ("phase4c-opencode-parts-" + [Guid]::NewGuid().ToString('N'))
  try {
    New-Item -ItemType Directory -Path (Join-Path $openCodePartsRoot 'scripts/host-sync/manifests') -Force | Out-Null
    Copy-Item (Join-Path $RepoRoot 'scripts/host-sync/manifests/opencode.manifest.psd1') (Join-Path $openCodePartsRoot 'scripts/host-sync/manifests/opencode.manifest.psd1')
    $openCodeManifestPath = Join-Path $openCodePartsRoot 'scripts/host-sync/manifests/opencode.manifest.psd1'
    $openCodeManifestText = Get-Content -Raw $openCodeManifestPath
    $openCodeManifestText = $openCodeManifestText.Replace(
      "AgentsCompositionId       = 'opencode-agents-dual-write-agents'",
      "AgentsCompositionId       = 'opencode-agents-dual-write-agents'`n        Parts           = @('instructions/__header__.md')"
    )
    Set-Content -LiteralPath $openCodeManifestPath -Value $openCodeManifestText -NoNewline
    $openCodePartsFailures = [System.Collections.Generic.List[string]]::new()
    $freshWorkflowsParts = (Get-FreshCatalogs).workflows
    & (Get-Module ProcedureRegistry) { param($Catalog,$RepoRoot,$Failures)
      Test-RegistryHostCompositionOwnership -Catalog $Catalog -RepoRoot $RepoRoot -Failures $Failures
    } $freshWorkflowsParts $openCodePartsRoot $openCodePartsFailures
    Assert-View 'Phase 4C OpenCode forbidden manifest Parts fails' (
      @($openCodePartsFailures | Where-Object { $_ -like 'composition-order-ownership*' }).Count -gt 0
    ) (($openCodePartsFailures | Select-Object -First 3) -join '; ')
  } finally {
    if (Test-Path -LiteralPath $openCodePartsRoot) { Remove-Item -LiteralPath $openCodePartsRoot -Recurse -Force }
  }

  # OpenCode manifest fail-closed: missing InstructionsCompositionId.
  $openCodeMissingRoot = Join-Path ([IO.Path]::GetTempPath()) ("phase4c-opencode-missing-" + [Guid]::NewGuid().ToString('N'))
  try {
    New-Item -ItemType Directory -Path (Join-Path $openCodeMissingRoot 'scripts/host-sync/manifests') -Force | Out-Null
    Copy-Item (Join-Path $RepoRoot 'scripts/host-sync/manifests/opencode.manifest.psd1') (Join-Path $openCodeMissingRoot 'scripts/host-sync/manifests/opencode.manifest.psd1')
    $openCodeMissingPath = Join-Path $openCodeMissingRoot 'scripts/host-sync/manifests/opencode.manifest.psd1'
    $openCodeMissingText = Get-Content -Raw $openCodeMissingPath
    $openCodeMissingText = $openCodeMissingText.Replace(
      "        InstructionsCompositionId = 'opencode-agents-dual-write-instructions'`n",
      ''
    )
    Set-Content -LiteralPath $openCodeMissingPath -Value $openCodeMissingText -NoNewline
    $openCodeMissingFailures = [System.Collections.Generic.List[string]]::new()
    $freshWorkflowsMissing = (Get-FreshCatalogs).workflows
    & (Get-Module ProcedureRegistry) { param($Catalog,$RepoRoot,$Failures)
      Test-RegistryHostCompositionOwnership -Catalog $Catalog -RepoRoot $RepoRoot -Failures $Failures
    } $freshWorkflowsMissing $openCodeMissingRoot $openCodeMissingFailures
    Assert-View 'Phase 4C OpenCode missing composition ID fails' (
      @($openCodeMissingFailures | Where-Object { $_ -like 'composition-order-ownership*' }).Count -gt 0
    ) (($openCodeMissingFailures | Select-Object -First 3) -join '; ')
  } finally {
    if (Test-Path -LiteralPath $openCodeMissingRoot) { Remove-Item -LiteralPath $openCodeMissingRoot -Recurse -Force }
  }

  # Runtime fail-closed paths: Cursor preflight and OpenCode dual-write guards.
  # Source HostSync.Core.ps1 for the runtime helper functions (not normally
  # loaded by this test script; dot-sourcing is scoped to the test block).
  . (Join-Path $PSScriptRoot (Join-Path '..' (Join-Path 'host-sync' 'HostSync.Contract.ps1')))
  . (Join-Path $PSScriptRoot (Join-Path '..' (Join-Path 'host-sync' 'HostSync.Core.ps1')))
  . (Join-Path $PSScriptRoot (Join-Path '..' (Join-Path 'host-sync' (Join-Path 'adapters' 'OpenCode.Adapter.ps1'))))
  $runtimeThrowMsg = ''
  $runtimeThrew = $false
  try {
    Test-RegistryCursorHybridOrder -CompanionRoot $RepoRoot -RuleIds @('iterative-plan-review','agent-invocation','iterative-code-review','pre-commit-ci-gate')
  } catch { $runtimeThrew = $true; $runtimeThrowMsg = $_.Exception.Message }
  Assert-View 'Phase 4C Cursor preflight fails closed on reordered rule IDs' (
    $runtimeThrew -and $runtimeThrowMsg -like '*composition-order-ownership*')
  $runtimeThrew = $false
  try {
    Test-RegistryCursorHybridOrder -CompanionRoot $RepoRoot -RuleIds @('agent-invocation','iterative-plan-review','iterative-code-review','pre-commit-ci-gate')
  } catch { $runtimeThrew = $true }
  Assert-View 'Phase 4C Cursor preflight passes with registry-owned order' (-not $runtimeThrew)
  # Regression: a cursor-* semanticOrder entry whose composition is missing from
  # the catalog must reach the composition-order-ownership invariant path (via
  # the shortened expected-rule list failing the join comparison), not an
  # out-of-bounds indexing error under StrictMode.
  $cursorMissingCompRoot = Join-Path ([IO.Path]::GetTempPath()) ("phase4c-cursor-missing-comp-" + [Guid]::NewGuid().ToString('N'))
  try {
    New-Item -ItemType Directory -Path (Join-Path $cursorMissingCompRoot 'catalog') -Force | Out-Null
    $wfRaw = Get-Content -Raw (Join-Path $RepoRoot 'catalog/workflows.json')
    $wfObj = $wfRaw | ConvertFrom-Json
    $filteredComps = @($wfObj.compositions | Where-Object { [string]$_.id -cne 'cursor-agent-invocation' })
    $wfObj.compositions = $filteredComps
    $wfJson = $wfObj | ConvertTo-Json -Depth 100
    Set-Content -LiteralPath (Join-Path $cursorMissingCompRoot 'catalog/workflows.json') -Value $wfJson -NoNewline
    $runtimeThrew = $false; $runtimeThrowMsg = ''
    try {
      Test-RegistryCursorHybridOrder -CompanionRoot $cursorMissingCompRoot -RuleIds @('agent-invocation','iterative-plan-review','iterative-code-review','pre-commit-ci-gate')
    } catch { $runtimeThrew = $true; $runtimeThrowMsg = $_.Exception.Message }
    Assert-View 'Phase 4C Cursor preflight fails closed when cursor composition is missing' (
      $runtimeThrew -and $runtimeThrowMsg -like '*composition-order-ownership*' -and
      $runtimeThrowMsg -notlike '*Index*' -and $runtimeThrowMsg -notlike '*index*')
  } finally {
    if (Test-Path -LiteralPath $cursorMissingCompRoot) { Remove-Item -LiteralPath $cursorMissingCompRoot -Recurse -Force }
  }
  $runtimeThrew = $false; $runtimeThrowMsg = ''
  try {
    Get-RegistryRuntimeCompositionOrder -CompanionRoot $RepoRoot -CompositionId 'nonexistent-composition'
  } catch { $runtimeThrew = $true; $runtimeThrowMsg = $_.Exception.Message }
  Assert-View 'Phase 4C runtime composition order fails closed on missing ID' (
    $runtimeThrew -and $runtimeThrowMsg -like '*CompositionOrderMissing*')
  $dualWriteReport = New-HostSyncReport -StackId 'OpenCode' -Mode ([HostSyncMode]::DryRun)
  $dualConfigParts = @{
    InstructionsRel = 'instructions/cursor-escape-loop.md'; AgentsRel = 'AGENTS.md'
    InstructionsCompositionId = 'opencode-agents-dual-write-instructions'
    AgentsCompositionId = 'opencode-agents-dual-write-agents'
    Parts = @('instructions/__header__.md')
  }
  Invoke-OpenCodeAgentsDualWrite -Report $dualWriteReport -Mode ([HostSyncMode]::DryRun) `
    -OverlayRoot (Join-Path $RepoRoot 'overlays/opencode') -LiveRoot (Join-Path ([IO.Path]::GetTempPath()) 'phase4c-dual-write-test') `
    -CompanionRoot $RepoRoot -DualWriteConfig $dualConfigParts
  Assert-View 'Phase 4C OpenCode dual-write rejects manifest-owned Parts fail-closed' (
    -not $dualWriteReport.Success -and
    @($dualWriteReport.Errors | Where-Object { $_ -like '*composition-order-ownership*' }).Count -gt 0)
  $dualWriteReportMissing = New-HostSyncReport -StackId 'OpenCode' -Mode ([HostSyncMode]::DryRun)
  $dualConfigMissing = @{ InstructionsRel = 'instructions/cursor-escape-loop.md'; AgentsRel = 'AGENTS.md' }
  Invoke-OpenCodeAgentsDualWrite -Report $dualWriteReportMissing -Mode ([HostSyncMode]::DryRun) `
    -OverlayRoot (Join-Path $RepoRoot 'overlays/opencode') -LiveRoot (Join-Path ([IO.Path]::GetTempPath()) 'phase4c-dual-write-test') `
    -CompanionRoot $RepoRoot -DualWriteConfig $dualConfigMissing
  Assert-View 'Phase 4C OpenCode dual-write rejects missing composition IDs fail-closed' (
    -not $dualWriteReportMissing.Success -and
    @($dualWriteReportMissing.Errors | Where-Object { $_ -like '*composition-order-ownership*' }).Count -gt 0)

  # --- Phase 4D: Antigravity GEMINI/workflow compositions ---

  # Registry order ownership passes on current tree (covered by Phase 4C general assertion,
  # but verify Antigravity specifically).
  $phase4DFailures = @($registry.Failures | Where-Object { $_ -like 'composition-order-ownership*' -and $_ -like '*Antigravity*' })
  Assert-View 'Phase 4D Antigravity composition ownership passes on current tree' ($phase4DFailures.Count -eq 0) (($phase4DFailures | Select-Object -First 3) -join '; ')

  # Antigravity manifest: forbidden semantic fields (Parts/Footer) fail-closed.
  $phase4DAgPartsRoot = Join-Path ([IO.Path]::GetTempPath()) ("phase4d-ag-parts-" + [Guid]::NewGuid().ToString('N'))
  try {
    New-Item -ItemType Directory -Path (Join-Path $phase4DAgPartsRoot 'scripts/host-sync/manifests') -Force | Out-Null
    Copy-Item (Join-Path $RepoRoot 'scripts/host-sync/manifests' '*.psd1') (Join-Path $phase4DAgPartsRoot 'scripts/host-sync/manifests')
    $agManifestPath = Join-Path $phase4DAgPartsRoot 'scripts/host-sync/manifests/antigravity.manifest.psd1'
    $agManifestText = Get-Content -Raw $agManifestPath
    $agManifestText = $agManifestText.Replace(
      "CompositionId = 'antigravity-gemini'",
      "CompositionId = 'antigravity-gemini'`n           Parts = @('instructions/__header__.md')"
    )
    Set-Content -LiteralPath $agManifestPath -Value $agManifestText -NoNewline
    $agPartsFailures = [System.Collections.Generic.List[string]]::new()
    $freshWorkflows4D = (Get-FreshCatalogs).workflows
    & (Get-Module ProcedureRegistry) { param($Catalog,$RepoRoot,$Failures)
      Test-RegistryHostCompositionOwnership -Catalog $Catalog -RepoRoot $RepoRoot -Failures $Failures
    } $freshWorkflows4D $phase4DAgPartsRoot $agPartsFailures
    Assert-View 'Phase 4D Antigravity forbidden manifest Parts fails' (
      @($agPartsFailures | Where-Object { $_ -like 'composition-order-ownership*' }).Count -gt 0
    ) (($agPartsFailures | Select-Object -First 3) -join '; ')
  } finally {
    if (Test-Path -LiteralPath $phase4DAgPartsRoot) { Remove-Item -LiteralPath $phase4DAgPartsRoot -Recurse -Force }
  }

  # Antigravity manifest: missing CompositionId fails-closed (binding omitted).
  $phase4DAgMissingRoot = Join-Path ([IO.Path]::GetTempPath()) ("phase4d-ag-missing-" + [Guid]::NewGuid().ToString('N'))
  try {
    New-Item -ItemType Directory -Path (Join-Path $phase4DAgMissingRoot 'scripts/host-sync/manifests') -Force | Out-Null
    Copy-Item (Join-Path $RepoRoot 'scripts/host-sync/manifests' '*.psd1') (Join-Path $phase4DAgMissingRoot 'scripts/host-sync/manifests')
    $agMissingPath = Join-Path $phase4DAgMissingRoot 'scripts/host-sync/manifests/antigravity.manifest.psd1'
    $agMissingText = Get-Content -Raw $agMissingPath
    $agMissingText = $agMissingText.Replace(
      "           CompositionId = 'antigravity-skill' }",
      " }"
    )
    Set-Content -LiteralPath $agMissingPath -Value $agMissingText -NoNewline
    $agMissingFailures = [System.Collections.Generic.List[string]]::new()
    $freshWorkflowsMissing = (Get-FreshCatalogs).workflows
    & (Get-Module ProcedureRegistry) { param($Catalog,$RepoRoot,$Failures)
      Test-RegistryHostCompositionOwnership -Catalog $Catalog -RepoRoot $RepoRoot -Failures $Failures
    } $freshWorkflowsMissing $phase4DAgMissingRoot $agMissingFailures
    Assert-View 'Phase 4D Antigravity missing composition ID fails' (
      @($agMissingFailures | Where-Object { $_ -like 'composition-order-ownership*' }).Count -gt 0
    ) (($agMissingFailures | Select-Object -First 3) -join '; ')
  } finally {
    if (Test-Path -LiteralPath $phase4DAgMissingRoot) { Remove-Item -LiteralPath $phase4DAgMissingRoot -Recurse -Force }
  }

  # Antigravity manifest: unknown composition ID fails-closed.
  $phase4DAgUnknownRoot = Join-Path ([IO.Path]::GetTempPath()) ("phase4d-ag-unknown-" + [Guid]::NewGuid().ToString('N'))
  try {
    New-Item -ItemType Directory -Path (Join-Path $phase4DAgUnknownRoot 'scripts/host-sync/manifests') -Force | Out-Null
    Copy-Item (Join-Path $RepoRoot 'scripts/host-sync/manifests' '*.psd1') (Join-Path $phase4DAgUnknownRoot 'scripts/host-sync/manifests')
    $agUnknownPath = Join-Path $phase4DAgUnknownRoot 'scripts/host-sync/manifests/antigravity.manifest.psd1'
    $agUnknownText = Get-Content -Raw $agUnknownPath
    $agUnknownText = $agUnknownText.Replace(
      "CompositionId = 'antigravity-gemini'",
      "CompositionId = 'nonexistent-composition'"
    )
    Set-Content -LiteralPath $agUnknownPath -Value $agUnknownText -NoNewline
    $agUnknownFailures = [System.Collections.Generic.List[string]]::new()
    $freshWorkflowsUnknown = (Get-FreshCatalogs).workflows
    & (Get-Module ProcedureRegistry) { param($Catalog,$RepoRoot,$Failures)
      Test-RegistryHostCompositionOwnership -Catalog $Catalog -RepoRoot $RepoRoot -Failures $Failures
    } $freshWorkflowsUnknown $phase4DAgUnknownRoot $agUnknownFailures
    Assert-View 'Phase 4D Antigravity unknown composition ID fails' (
      @($agUnknownFailures | Where-Object { $_ -like 'composition-order-ownership*' }).Count -gt 0
    ) (($agUnknownFailures | Select-Object -First 3) -join '; ')
  } finally {
    if (Test-Path -LiteralPath $phase4DAgUnknownRoot) { Remove-Item -LiteralPath $phase4DAgUnknownRoot -Recurse -Force }
  }

  # Antigravity manifest: duplicate composition binding fails-closed.
  $phase4DAgDupRoot = Join-Path ([IO.Path]::GetTempPath()) ("phase4d-ag-dup-" + [Guid]::NewGuid().ToString('N'))
  try {
    New-Item -ItemType Directory -Path (Join-Path $phase4DAgDupRoot 'scripts/host-sync/manifests') -Force | Out-Null
    Copy-Item (Join-Path $RepoRoot 'scripts/host-sync/manifests' '*.psd1') (Join-Path $phase4DAgDupRoot 'scripts/host-sync/manifests')
    $agDupPath = Join-Path $phase4DAgDupRoot 'scripts/host-sync/manifests/antigravity.manifest.psd1'
    $agDupText = Get-Content -Raw $agDupPath
    # Append a second entry with the same Source|CompositionId binding.
    $agDupText = $agDupText -replace '(@\{ Source = ''base:rules/agent-invocation\.md''; Dest = ''GEMINI\.md''\r?\n\s+CompositionId = ''antigravity-gemini'' \})', "`$0`n        @{ Source = 'base:rules/agent-invocation.md'; Dest = 'GEMINI-dup.md'`n           CompositionId = 'antigravity-gemini' }"
    Set-Content -LiteralPath $agDupPath -Value $agDupText -NoNewline
    $agDupFailures = [System.Collections.Generic.List[string]]::new()
    $freshWorkflowsDup = (Get-FreshCatalogs).workflows
    & (Get-Module ProcedureRegistry) { param($Catalog,$RepoRoot,$Failures)
      Test-RegistryHostCompositionOwnership -Catalog $Catalog -RepoRoot $RepoRoot -Failures $Failures
    } $freshWorkflowsDup $phase4DAgDupRoot $agDupFailures
    Assert-View 'Phase 4D Antigravity duplicate binding fails' (
      @($agDupFailures | Where-Object { $_ -like '*duplicate*' -or $_ -like '*Duplicate*' }).Count -gt 0
    ) (($agDupFailures | Select-Object -First 3) -join '; ')
  } finally {
    if (Test-Path -LiteralPath $phase4DAgDupRoot) { Remove-Item -LiteralPath $phase4DAgDupRoot -Recurse -Force }
  }

  # Antigravity registry reference reorder fails (registry owns order; reorder triggers
  # prose-reference mismatch from the general composition inventory).
  $result4DRefs = Invoke-EdgeCase 'workflows' {
    param($c)
    $comp = @($c.workflows.compositions | Where-Object { [string]$_.id -eq 'antigravity-gemini' })[0]
    $refs = @($comp.references); $refs[0],$refs[1] = $refs[1],$refs[0]
    $comp.references = $refs
  }
  # Antigravity is runtimeOnly: registry owns order. Reordering references in
  # the registry is valid — the Generic adapter derives order from the registry.
  Assert-View 'Phase 4D Antigravity reference reorder remains valid' (
    @($result4DRefs.Failures | Where-Object { $_ -like 'composition-order-ownership*' }).Count -eq 0
  ) (($result4DRefs.Failures | Select-Object -First 3) -join '; ')

  # Byte parity: registry-derived Generic render equals the legacy manifest-owned render.
  # Build the legacy entry manually with the pre-migration Parts/Footer and compare bytes.
  $agOverlayRoot = Join-Path $RepoRoot 'overlays/antigravity'
  $agSharedRoot = 'overlays/opencode'
  $agScratch = Join-Path ([IO.Path]::GetTempPath()) ("phase4d-bytes-" + [Guid]::NewGuid().ToString('N'))
  try {
    New-Item -ItemType Directory -Path $agScratch -Force | Out-Null
    $compositionEntry = @{
      Source = 'base:rules/agent-invocation.md'
      Dest = 'GEMINI.md'
      CompositionId = 'antigravity-gemini'
    }
    $legacyEntry = @{
      Source = 'base:rules/agent-invocation.md'
      Dest = 'GEMINI.md'
      Parts = @('instructions/__header__.md')
      Footer = @('base:rules/iterative-plan-review.md', 'base:rules/iterative-code-review.md', 'footers/gemini-wiring.md')
    }
    $reportComp = New-HostSyncReport -StackId 'Antigravity' -Mode ([HostSyncMode]::DryRun)
    Copy-ManifestEntry -Report $reportComp -Mode ([HostSyncMode]::DryRun) -CompanionRoot $RepoRoot -OverlayRoot $agOverlayRoot `
      -LiveRoot $agScratch -Entry $compositionEntry -SharedRoot $agSharedRoot
    $reportLegacy = New-HostSyncReport -StackId 'Antigravity' -Mode ([HostSyncMode]::DryRun)
    Copy-ManifestEntry -Report $reportLegacy -Mode ([HostSyncMode]::DryRun) -CompanionRoot $RepoRoot -OverlayRoot $agOverlayRoot `
      -LiveRoot $agScratch -Entry $legacyEntry -SharedRoot $agSharedRoot
    $compBytes = if ($reportComp.PlannedContent.ContainsKey('GEMINI.md')) { [string]$reportComp.PlannedContent['GEMINI.md'] } else { '' }
    $legacyBytes = if ($reportLegacy.PlannedContent.ContainsKey('GEMINI.md')) { [string]$reportLegacy.PlannedContent['GEMINI.md'] } else { '' }
    Assert-View 'Phase 4D GEMINI registry render byte parity' (
      $reportComp.Success -and $reportLegacy.Success -and ($compBytes -ceq $legacyBytes)
    ) "comp=$($compBytes.Length) legacy=$($legacyBytes.Length) errors=$($reportComp.Errors -join '; ')"

    # Deterministic double render for the composition path.
    $reportComp2 = New-HostSyncReport -StackId 'Antigravity' -Mode ([HostSyncMode]::DryRun)
    Copy-ManifestEntry -Report $reportComp2 -Mode ([HostSyncMode]::DryRun) -CompanionRoot $RepoRoot -OverlayRoot $agOverlayRoot `
      -LiveRoot $agScratch -Entry $compositionEntry -SharedRoot $agSharedRoot
    $compBytes2 = if ($reportComp2.PlannedContent.ContainsKey('GEMINI.md')) { [string]$reportComp2.PlannedContent['GEMINI.md'] } else { '' }
    Assert-View 'Phase 4D GEMINI deterministic double render' ($compBytes -ceq $compBytes2)

    # Pre-commit skill entry byte parity.
    $skillCompEntry = @{
      Source = 'base:rules/pre-commit-ci-gate.md'
      Dest = 'config/skills/pre-commit-ci-gate/SKILL.md'
      CompositionId = 'antigravity-skill'
    }
    $skillLegacyEntry = @{
      Source = 'base:rules/pre-commit-ci-gate.md'
      Dest = 'config/skills/pre-commit-ci-gate/SKILL.md'
      Parts = @('shared:pre-commit-frontmatter.md')
      Footer = @('footers/pre-commit-antigravity.md')
    }
    $reportSkillComp = New-HostSyncReport -StackId 'Antigravity' -Mode ([HostSyncMode]::DryRun)
    Copy-ManifestEntry -Report $reportSkillComp -Mode ([HostSyncMode]::DryRun) -CompanionRoot $RepoRoot -OverlayRoot $agOverlayRoot `
      -LiveRoot $agScratch -Entry $skillCompEntry -SharedRoot $agSharedRoot
    $reportSkillLegacy = New-HostSyncReport -StackId 'Antigravity' -Mode ([HostSyncMode]::DryRun)
    Copy-ManifestEntry -Report $reportSkillLegacy -Mode ([HostSyncMode]::DryRun) -CompanionRoot $RepoRoot -OverlayRoot $agOverlayRoot `
      -LiveRoot $agScratch -Entry $skillLegacyEntry -SharedRoot $agSharedRoot
    $skillDest = 'config/skills/pre-commit-ci-gate/SKILL.md'
    $skillCompBytes = if ($reportSkillComp.PlannedContent.ContainsKey($skillDest)) { [string]$reportSkillComp.PlannedContent[$skillDest] } else { '' }
    $skillLegacyBytes = if ($reportSkillLegacy.PlannedContent.ContainsKey($skillDest)) { [string]$reportSkillLegacy.PlannedContent[$skillDest] } else { '' }
    Assert-View 'Phase 4D pre-commit skill registry render byte parity' (
      $reportSkillComp.Success -and $reportSkillLegacy.Success -and ($skillCompBytes -ceq $skillLegacyBytes)
    ) "comp=$($skillCompBytes.Length) legacy=$($skillLegacyBytes.Length) errors=$($reportSkillComp.Errors -join '; ')"
  } finally {
    if (Test-Path -LiteralPath $agScratch) { Remove-Item -LiteralPath $agScratch -Recurse -Force }
  }

  # Runtime helper: Get-RegistryGenericCompositionBinding fails closed on missing Source.
  $runtimeBindingThrew = $false; $runtimeBindingMsg = ''
  try {
    Get-RegistryGenericCompositionBinding -CompanionRoot $RepoRoot -CompositionId 'antigravity-gemini' -Source 'base:rules/nonexistent.md'
  } catch { $runtimeBindingThrew = $true; $runtimeBindingMsg = $_.Exception.Message }
  Assert-View 'Phase 4D generic composition binding fails on missing source' (
    $runtimeBindingThrew -and $runtimeBindingMsg -like '*composition-order-ownership*')

  # Runtime helper: Get-RegistryGenericCompositionBinding fails closed on missing composition.
  $runtimeMissingThrew = $false; $runtimeMissingMsg = ''
  try {
    Get-RegistryGenericCompositionBinding -CompanionRoot $RepoRoot -CompositionId 'nonexistent-composition' -Source 'base:rules/agent-invocation.md'
  } catch { $runtimeMissingThrew = $true; $runtimeMissingMsg = $_.Exception.Message }
  Assert-View 'Phase 4D generic composition binding fails on missing composition' (
    $runtimeMissingThrew -and $runtimeMissingMsg -like '*composition-order-ownership*' -and $runtimeMissingMsg -like '*CompositionOrderMissing*')

  # Runtime: Copy-ManifestEntry rejects CompositionId + Parts fail-closed.
  $runtimePartsEntry = @{
    Source = 'base:rules/agent-invocation.md'
    Dest = 'GEMINI.md'
    CompositionId = 'antigravity-gemini'
    Parts = @('instructions/__header__.md')
  }
  $runtimePartsScratch = Join-Path ([IO.Path]::GetTempPath()) ("phase4d-parts-reject-" + [Guid]::NewGuid().ToString('N'))
  try {
    New-Item -ItemType Directory -Path $runtimePartsScratch -Force | Out-Null
    $runtimePartsReport = New-HostSyncReport -StackId 'Antigravity' -Mode ([HostSyncMode]::DryRun)
    Copy-ManifestEntry -Report $runtimePartsReport -Mode ([HostSyncMode]::DryRun) -CompanionRoot $RepoRoot -OverlayRoot $agOverlayRoot `
      -LiveRoot $runtimePartsScratch -Entry $runtimePartsEntry -SharedRoot $agSharedRoot
    Assert-View 'Phase 4D Copy-ManifestEntry rejects CompositionId with Parts fail-closed' (
      -not $runtimePartsReport.Success -and
      @($runtimePartsReport.Errors | Where-Object { $_ -like '*composition-order-ownership*' }).Count -gt 0)
  } finally {
    if (Test-Path -LiteralPath $runtimePartsScratch) { Remove-Item -LiteralPath $runtimePartsScratch -Recurse -Force }
  }

  # Phase 3A machinery guard: the shadow slice must not change canonical skill
  # bodies or any host/runtime projection. Phase 3B replaces this guard with
  # managed-frontmatter migration checks when canonical files are regenerated.
  # Phase 2 agent parity legitimately edits agent wrappers, manifests, and
  # overlay indexes. Scope the residual Phase 3A guard to canonical and host
  # skill projections; broader source agreement remains in the registry,
  # inventory, manifest, and current-state checks.
  $sliceDrift = @(& git -C $RepoRoot status --porcelain -- skills 'overlays/*/skills')
  if ($LASTEXITCODE -ne 0) { throw "FAIL: Phase 3A drift status exited $LASTEXITCODE" }
  Assert-View 'Phase 3A leaves canonical skills and host skill projections unchanged' ($sliceDrift.Count -eq 0) (($sliceDrift | Select-Object -First 5) -join '; ')
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
  Assert-CheckerMutation 'invented missing pair fails closed at zero missing' {
    param($i) $i.missing_pairs_with_proposed_phase2 = @(
      [pscustomobject]@{ host = 'Cline'; agent = 'implementer'; proposed_phase2 = 'fresh-task-session-fallback' }
    )
  } @('MissingPairCount: expected 0, got 1')
  # The ledger mutation proves the immutable inventory declaration remains
  # row-agreement-checked; source manifest counts are separately checked as
  # current Phase 2 evidence rather than being conflated with historical render
  # output.
  Assert-CheckerMutation 'ledger destination-count mismatch fails' {
    param($i) $i.render_baselines.six_stack_ledger_entries[0].destinationCount = 99
  } @('LedgerRowAgreement: row 0')
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
  Assert-View 'markdown ambiguity row removal fails' ($LASTEXITCODE -eq 1 -and $markdownTrimmedOutput.Contains('MarkdownAmbiguityCount: expected 3, got 2')) "exit=$LASTEXITCODE"
  $markdownRenamedPath = Join-Path $checkerTemp 'renamed-ambiguity.md'
  ($markdownOriginal -replace '\| U-Cursor-Bugbot \|', '| U-Renamed-Bugbot |') | Set-Content -LiteralPath $markdownRenamedPath
  $markdownRenamedOutput = (& $checker -RepoRoot $RepoRoot -InventoryMdPath $markdownRenamedPath -AllowInaccessibleHistoricalBaseline *>&1 | Out-String)
  Assert-View 'markdown ambiguity id drift fails' ($LASTEXITCODE -eq 1 -and $markdownRenamedOutput.Contains("MarkdownAmbiguityId: row 0 expected 'U-Cursor-Bugbot', got 'U-Renamed-Bugbot'")) "exit=$LASTEXITCODE"
  $markdownNoUpdatePath = Join-Path $checkerTemp 'stale-dates.md'
  ($markdownOriginal -replace ' · \*\*Last updated:\*\* 2026-09-15', '') | Set-Content -LiteralPath $markdownNoUpdatePath
  $markdownNoUpdateOutput = (& $checker -RepoRoot $RepoRoot -InventoryMdPath $markdownNoUpdatePath -AllowInaccessibleHistoricalBaseline *>&1 | Out-String)
  Assert-View 'markdown last-updated drift fails' ($LASTEXITCODE -eq 1 -and $markdownNoUpdateOutput.Contains('MarkdownInventoryLastUpdated')) "exit=$LASTEXITCODE"
} catch { $failures++; Write-Output "FAIL: current-state checker execution: $($_.Exception.Message)" }
finally { if (Test-Path -LiteralPath $checkerTemp) { Remove-Item -LiteralPath $checkerTemp -Recurse -Force -ErrorAction SilentlyContinue } }

if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue }
Write-Output ('registry view checks: {0} passed, {1} failed' -f $pass,$failures)
exit $(if ($failures -gt 0) { 1 } else { 0 })
