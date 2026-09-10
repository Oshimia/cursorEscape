#Requires -Version 7.0
<#
.SYNOPSIS
  Phase 2 remediation checks (per-entry v2 migration): single-source-per-Dest，
  fail-closed substitution behavior (via unit checks)， residual host markers，
  C1 gate atoms， persistent 12k rendered size， baseline byte-equality for migrated
  whole-file shares， composed-instruction surface properties.
  Exits non-zero on any failure. Read-only + scratch only (no live writes).
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8

$companionRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$hostSyncRoot = $PSScriptRoot
. (Join-Path $hostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $hostSyncRoot 'HostSync.Core.ps1')
. (Join-Path $hostSyncRoot 'Register-StackAdapters.ps1')

$failures = 0
$pass = 0
function Assert-Pass {
    param([string] $Name, [bool] $Ok, [string] $Detail = '')
    if ($Ok) { $script:pass++; Write-Output "pass: $Name" }
    else { $script:failures++; Write-Output "FAIL: $Name $Detail" }
}

$manifests = @{
    Cursor      = Get-StackManifest -StackId 'Cursor'      -HostSyncRoot $hostSyncRoot
    OpenCode    = Get-StackManifest -StackId 'OpenCode'    -HostSyncRoot $hostSyncRoot
    Antigravity = Get-StackManifest -StackId 'Antigravity' -HostSyncRoot $hostSyncRoot
    Vscode      = Get-StackManifest -StackId 'Vscode'      -HostSyncRoot $hostSyncRoot
    Cline       = Get-StackManifest -StackId 'Cline'       -HostSyncRoot $hostSyncRoot
    Kilocode    = Get-StackManifest -StackId 'Kilocode'    -HostSyncRoot $hostSyncRoot
}

# ---------- 1. Single-source-per-Dest invariant (within each manifest) ----------
foreach ($sid in @('Cursor', 'OpenCode', 'Antigravity', 'Vscode', 'Cline', 'Kilocode')) {
    $manifest = $manifests[$sid]
    $byDest = @{}
    $dupes = 0
    foreach ($entry in @($manifest.CopyEntries)) {
        $dest = if ($entry.ContainsKey('Dest') -and $entry.Dest) { [string]$entry.Dest } else { [string]$entry.Source }
        if ($byDest.ContainsKey($dest)) { $dupes++ }
        else { $byDest[$dest] = $entry.Source }
    }
    Assert-Pass "single-source-per-Dest: $sid" ($dupes -eq 0)
}

# ---------- 2. In-process dry-run render (content capture; no live writes) ----------
$companionNorm = Resolve-CompanionRootPath -Path $companionRoot
$planned = @{}
foreach ($sid in @('Antigravity', 'OpenCode', 'Cursor', 'Vscode', 'Cline', 'Kilocode')) {
    $adapterPath = Get-StackAdapterScript -StackId $sid -HostSyncRoot $hostSyncRoot
    . $adapterPath
    $report = Invoke-StackHarnessSync -Mode ([HostSyncMode]::DryRun) -CompanionRoot $companionNorm -Manifest $manifests[$sid]
    if (-not $report.Success) {
        Assert-Pass "dry-run in-process render: $sid" $false ($report.Errors -join '; ')
        continue
    }
    Assert-Pass "dry-run in-process render: $sid" $true
    $planned[$sid] = $report
}

# ---------- 3. Baseline byte-equality: rendered antigravity skill dests == committed baselines ----------
# Compare basis (remediation-checks spec, single statement): the committed render baselines
# (scripts/host-sync/render-baselines/phase2/) are THE regression surface for the relocation class —
# each baseline is the token-merged HEAD-authored overlay leaf captured at migration time.
$baselineRoot = Join-Path $hostSyncRoot 'render-baselines\phase2\antigravity'
$baselinePairs = @(
    @{ Dest = 'config/skills/discovery/SKILL.md';                    Baseline = 'overlays__antigravity__skills__discovery__SKILL.md' }
    @{ Dest = 'config/skills/implementation-plan/SKILL.md';          Baseline = 'overlays__antigravity__skills__implementation-plan__SKILL.md' }
    @{ Dest = 'config/skills/plan-review/SKILL.md';                  Baseline = 'overlays__antigravity__skills__plan-review__SKILL.md' }
    @{ Dest = 'config/skills/documentation-architecture/SKILL.md';   Baseline = 'overlays__antigravity__skills__documentation-architecture__SKILL.md' }
    @{ Dest = 'config/skills/roadmap/SKILL.md';                      Baseline = 'overlays__antigravity__skills__roadmap__SKILL.md' }
    @{ Dest = 'config/skills/diagnosing-bugs/SKILL.md';              Baseline = 'overlays__antigravity__skills__diagnosing-bugs__SKILL.md' }
    @{ Dest = 'config/skills/opencode-headless-run/SKILL.md';        Baseline = 'overlays__antigravity__skills__opencode-headless-run__SKILL.md' }
)
foreach ($pair in $baselinePairs) {
    $destKey = $pair.Dest
    $baselinePath = Join-Path $baselineRoot $pair.Baseline
    $hasContent = $planned['Antigravity'].PlannedContent.ContainsKey($destKey)
    $baselineExists = Test-Path -LiteralPath $baselinePath
    $eq = $false
    if ($hasContent -and $baselineExists) {
        $baseline = [IO.File]::ReadAllText($baselinePath)
        $rendered = $planned['Antigravity'].PlannedContent[$destKey]
        # Baselines are HEAD overlay files: they still carry {{COMPANION_ROOT}} tokens.
        # Apply the same token merge the render pipeline applies, then compare.
        $baselineMerged = Merge-CompanionTokens -Content $baseline -CompanionRoot $companionNorm
        # Normalize EOL + trailing whitespace only.
        $renderedNorm = ($rendered -replace "`r`n", "`n").TrimEnd()
        $baselineNorm = ($baselineMerged -replace "`r`n", "`n").TrimEnd()
        $eq = ($renderedNorm -eq $baselineNorm)
    }
    Assert-Pass "baseline equal (antigravity): $destKey" ($hasContent -and $baselineExists -and $eq)
}

# ---------- 4. Residual host markers ----------
$agyResidue = @()
foreach ($kv in $planned['Antigravity'].PlannedContent.GetEnumerator()) {
    if ($kv.Value -match 'OpenCode harness|Invoke OpenCode agent|via Task') { $agyResidue += $kv.Key }
}
Assert-Pass 'no residual OpenCode markers in rendered antigravity dests' ($agyResidue.Count -eq 0) (($agyResidue) -join ', ')

$ocResidue = @()
foreach ($kv in $planned['OpenCode'].PlannedContent.GetEnumerator()) {
    if ($kv.Value -match 'Antigravity harness|invoke_subagent') { $ocResidue += $kv.Key }
}
Assert-Pass 'no residual Antigravity markers in rendered opencode dests' ($ocResidue.Count -eq 0) (($ocResidue) -join ', ')

# ---------- 5. C1 gate atoms in composed gates ----------
$geminiPlanned = $null
if ($planned['Antigravity'].PlannedContent.ContainsKey('GEMINI.md')) { $geminiPlanned = $planned['Antigravity'].PlannedContent['GEMINI.md'] }
foreach ($atom in @('Default on', 'When in doubt', 'max 3 passes', '4-iteration', 'do not launch a 5th pair', 'Full CI', 'pre-commit-ci-gate', 'invoke_subagent')) {
    Assert-Pass "gate atom in composed GEMINI.md: '$atom'" ($null -ne $geminiPlanned -and $geminiPlanned.Contains($atom))
}
# Composed GEMINI wiring footprint must carry the host sections (declared-diff zone holds them).
foreach ($fp in @('Empty subagent signature', '~/.gemini/config/skills', 'injected across all workspaces')) {
    Assert-Pass "composed GEMINI wiring footprint: '$fp'" ($null -ne $geminiPlanned -and $geminiPlanned.Contains($fp))
}

$instrPlanned = $null
$instrKey = 'instructions/cursor-escape-loop.md'
if ($planned['OpenCode'].PlannedContent.ContainsKey($instrKey)) { $instrPlanned = $planned['OpenCode'].PlannedContent[$instrKey] }
foreach ($atom in @('Default on', 'When in doubt', 'max 3 passes', '4-iteration', 'do not launch a 5th pair', 'Full CI', 'pre-commit-ci-gate', 'session-injected')) {
    Assert-Pass "gate atom in composed instructions: '$atom'" ($null -ne $instrPlanned -and $instrPlanned.Contains($atom))
}
foreach ($fp in @('Empty Task signature', 'Skills to load by name', 'Shell & native tools', 'workdir', 'Git red line', 'opencode-headless-run')) {
    Assert-Pass "composed instructions wiring footprint: '$fp'" ($null -ne $instrPlanned -and $instrPlanned.Contains($fp))
}

# ---------- 6. Persistent 12k rendered-size ceiling (antigravity dests) ----------
$over12k = @()
foreach ($kv in $planned['Antigravity'].PlannedContent.GetEnumerator()) {
    if ($kv.Value.Length -ge 12000) { $over12k += ('{0} ({1})' -f $kv.Key, $kv.Value.Length) }
}
Assert-Pass 'persistent 12k rendered ceiling: antigravity' ($over12k.Count -eq 0) (($over12k) -join ', ')

# ---------- 7. Authored antigravity leaves stay authored (composer/implementation-review/history-search/agents x3) ----------
$agyOverlay = Join-Path $companionRoot 'overlays\antigravity'
foreach ($authored in @('skills\composer\SKILL.md', 'skills\implementation-review\SKILL.md', 'skills\opencode-history-search\SKILL.md',
    'agents\plan_reviewer.md', 'agents\production_readiness_reviewer.md', 'agents\bug_reviewer.md')) {
    Assert-Pass "authored leaf still present: $authored" (Test-Path -LiteralPath (Join-Path $agyOverlay $authored))
}

# ---------- 8. Migrated/composed leaves deleted from overlay ----------
foreach ($gone in @('skills\discovery\SKILL.md', 'skills\implementation-plan\SKILL.md', 'skills\plan-review\SKILL.md',
    'skills\documentation-architecture\SKILL.md', 'skills\roadmap\SKILL.md', 'skills\diagnosing-bugs\SKILL.md',
    'skills\opencode-headless-run\SKILL.md', 'skills\pre-commit-ci-gate\SKILL.md', 'GEMINI.md')) {
    Assert-Pass "migrated/composed leaf deleted from overlay: $gone" (-not (Test-Path -LiteralPath (Join-Path $agyOverlay $gone)))
}

# ---------- 9. Composed pre-commit stub: gate atoms + footer reached the render ----------
# Atom contract: composed stub = shared frontmatter + base rule + host footer. The footer
# carries the git red-line footprint + never-push/composer-commit tail (same class as the
# composed instructions wiring footer); frontmatter carries name/description for discovery.
$pcAgy = $planned['Antigravity'].PlannedContent['config/skills/pre-commit-ci-gate/SKILL.md']
Assert-Pass 'composed antigravity pre-commit stub: frontmatter description present' ($null -ne $pcAgy -and $pcAgy.Contains('description:'))
Assert-Pass 'composed antigravity pre-commit stub: git red-line footprint' ($null -ne $pcAgy -and $pcAgy.Contains('Git red line'))
Assert-Pass 'composed antigravity pre-commit stub: never-push tail' ($null -ne $pcAgy -and $pcAgy.Contains('git push'))
$pcOc = $planned['OpenCode'].PlannedContent['skills/pre-commit-ci-gate/SKILL.md']
Assert-Pass 'composed opencode pre-commit stub: frontmatter description present' ($null -ne $pcOc -and $pcOc.Contains('description:'))
Assert-Pass 'composed opencode pre-commit stub: git red-line footprint' ($null -ne $pcOc -and $pcOc.Contains('Git red line'))
Assert-Pass 'composed opencode pre-commit stub: never-push tail' ($null -ne $pcOc -and $pcOc.Contains('git push'))

# ---------- 10. AGENTS dual-write mirror planned for opencode ----------
Assert-Pass 'AGENTS dual-write mirror planned' ($planned['OpenCode'].PlannedContent.ContainsKey('AGENTS.md'))

Write-Output ('phase2 remediation checks: {0} passed, {1} failed' -f $pass, $failures)
exit $(if ($failures -gt 0) { 1 } else { 0 })
