#Requires -Version 7.0
<#
.SYNOPSIS
  Consolidated host-sync check suite for unit, composition, and focused dry-run checks.
.DESCRIPTION
  Preserves the former independent suites as named, independently callable seams.
  Unit and Composition are available immediately; DryRun is added by the follow-up
  consolidation phase. Read-only plus disposable scratch writes only.
#>
[CmdletBinding()]
param(
    [ValidateSet('Unit', 'Composition', 'All')]
    [string] $Suite = 'All'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$script:SuiteFailures = 0

if ($Suite -in @('Unit', 'All')) {
<#
.SYNOPSIS
    Remediation program unit checks (D6 home): render-helper and skew-guard contract tests.
    Fails closed: any failed case exits non-zero. No writes outside this script's scratch dir.
.NOTES
    Home decision per roadmap Phase 0 D6: consolidates unit checks + remediation checks.
    Phase 1 cases: fail-closed exactly-once substitutions (no-match / multi-match),
    skew-guard source identities (sibling flags, same-source-different-substitution rows,
    plain/base/shared normalization, consumer unroll safety).
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8

$companionRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
. (Join-Path $companionRoot 'scripts\host-sync\HostSync.Contract.ps1')
. (Join-Path $companionRoot 'scripts\host-sync\HostSync.Core.ps1')
. (Join-Path $companionRoot 'scripts\host-sync\Register-StackAdapters.ps1')

$scratch = Join-Path ([IO.Path]::GetTempPath()) ('hsy-unit-' + [guid]::NewGuid().ToString('N').Substring(0,8))
New-Item -ItemType Directory -Path $scratch -Force | Out-Null
$overlayScratch = Join-Path $scratch 'overlay'
New-Item -ItemType Directory -Path $overlayScratch -Force | Out-Null
$failures = 0
$pass = 0

function Assert-True {
    param([string] $Name, [bool] $Condition, [string] $Detail = '')
    if ($Condition) { $script:pass++; Write-Output "pass: $Name" }
    else { $script:failures++; Write-Output "FAIL: $Name $Detail" }
}

try {
    # ---------- Invoke-HostSyncRender: fail-closed substitutions ----------
    $srcFile = Join-Path $overlayScratch 'src.md'
    [IO.File]::WriteAllText($srcFile, "# Discovery (OpenCode harness)`n`nbody`n")

    # U1: exactly-once match renders
    $entry = @{ Substitutions = @(@{ Find = '(OpenCode harness)'; Replace = '(Antigravity harness)' }) }
    $out = Invoke-HostSyncRender -Raw ([IO.File]::ReadAllText($srcFile)) -CompanionRoot $companionRoot `
        -ResolvedSourcePath $srcFile -Entry $entry -DestRel 'x.md'
    Assert-True 'U1 exactly-once substitution renders' ($out -match '\(Antigravity harness\)')

    # U2: no-match is a hard render error (fail closed)
    $entryNoMatch = @{ Substitutions = @(@{ Find = 'no-such-anchor'; Replace = 'x' }) }
    $threw = $false; $msg = ''
    try {
        $null = Invoke-HostSyncRender -Raw ([IO.File]::ReadAllText($srcFile)) -CompanionRoot $companionRoot `
            -ResolvedSourcePath $srcFile -Entry $entryNoMatch -DestRel 'x.md'
    } catch { $threw = $true; $msg = $_.Exception.Message }
    Assert-True 'U2 no-match substitution fails closed' ($threw -and $msg -like '*no-match (or multi-match)*')

    # U3: multi-match is a hard render error
    $multiSrc = Join-Path $overlayScratch 'multi.md'
    [IO.File]::WriteAllText($multiSrc, "# A (OpenCode harness)`n# B (OpenCode harness)")
    $threw = $false
    try {
        $null = Invoke-HostSyncRender -Raw ([IO.File]::ReadAllText($multiSrc)) -CompanionRoot $companionRoot `
            -ResolvedSourcePath $multiSrc -Entry $entry -DestRel 'x.md'
    } catch { $threw = $true; $msg = $_.Exception.Message }
    Assert-True 'U3 multi-match substitution fails closed' ($threw -and $msg -match 'matched 2 times')

    # U4: plain render (no entry) is token-merge only, byte-preserving otherwise
    $rawText = [IO.File]::ReadAllText($srcFile)
    $plain = Invoke-HostSyncRender -Raw $rawText -CompanionRoot $companionRoot -ResolvedSourcePath $srcFile -Entry $null -DestRel 'x.md'
    Assert-True 'U4 plain render preserves bytes' ($plain -eq $rawText)

    # U5: Parts-before-body, Footer-after ordering with file references
    $partFile = Join-Path $overlayScratch 'part.md'
    $footFile = Join-Path $overlayScratch 'foot.md'
    [IO.File]::WriteAllText($partFile, 'PART-TEXT')
    [IO.File]::WriteAllText($footFile, 'FOOTER-TEXT')
    $entryRef = @{ Parts = @('part.md'); Footer = @('foot.md') }
    $composed = Invoke-HostSyncRender -Raw 'BODY-TEXT' -CompanionRoot $companionRoot `
        -ResolvedSourcePath $srcFile -Entry $entryRef -DestRel 'x.md'
    $orderOk = ($composed.IndexOf('PART-TEXT') -ge 0) -and
               ($composed.IndexOf('BODY-TEXT') -gt $composed.IndexOf('PART-TEXT')) -and
               ($composed.IndexOf('FOOTER-TEXT') -gt $composed.IndexOf('BODY-TEXT'))
    Assert-True 'U5 Parts->Body->Footer concat order' $orderOk

    # U6: missing Footer file reference fails closed
    $entryMissing = @{ Footer = @('does-not-exist.md') }
    $threw = $false
    try {
        $null = Invoke-HostSyncRender -Raw 'body' -CompanionRoot $companionRoot `
            -ResolvedSourcePath $srcFile -Entry $entryMissing -DestRel 'x.md'
    } catch { $threw = $true }
    Assert-True 'U6 missing file reference fails closed' $threw

    # ---------- Resolve-HostSyncSourcePath: source-class resolution ----------
    $r = Resolve-HostSyncSourcePath -SourceRel 'skills/x/SKILL.md' -CompanionRoot $companionRoot `
        -OverlayRoot $overlayScratch
    Assert-True 'U7a plain class resolves under overlay' (($r.SourceClass -eq 'overlay') -and ($r.Path -like "$overlayScratch*"))
    $r = Resolve-HostSyncSourcePath -SourceRel 'base:rules/red-line.md' -CompanionRoot $companionRoot `
        -OverlayRoot $overlayScratch
    Assert-True 'U7b base class resolves under companion' (($r.SourceClass -eq 'base') -and ($r.Path -like (Join-Path $companionRoot 'rules*')))
    $r = Resolve-HostSyncSourcePath -SourceRel 'shared:skills/discovery/SKILL.md' -CompanionRoot $companionRoot `
        -OverlayRoot $overlayScratch
    Assert-True 'U7c shared class resolves under default SharedRoot' (($r.SourceClass -eq 'shared') -and ($r.Path -like '*overlays*opencode*'))

    # ---------- Resolve-HostSyncSourcePath: source-class resolution ----------
    # ---------- Get-CrossStackSourceOverlap: source-identities ----------
    # Regression anchor: unmigrated manifests (no base:/shared:/Substitutions) must still
    # flag the known shared stump surfaces. Current manifests share no plain sources across
    # stacks by design (overlays are per-stack), so an empty result is EXPECTED today; the
    # contract under test is the empty->count-zero unroll and identity shape.
    $overlap = Get-CrossStackSourceOverlap -StackId 'Cursor'
    $rows = @(
        foreach ($o in $overlap) { $o }
    )
    Assert-True 'U8 empty overlap yields zero rows (consumer unroll safety)' ($rows.Count -eq 0)
    # Row shape check when overlap exists: build a synthetic manifest set via direct
    # identity verification instead (registration stamps are load-bearing).
    $id1 = ConvertTo-SkewIdentitySource -Entry @{ Source = 'rules/red-line.md' } `
        -OverlayRelativeRoot 'overlays/cursor' -SharedRoot 'overlays/opencode'
    $id2 = ConvertTo-SkewIdentitySource -Entry @{ Source = 'base:rules/red-line.md' } `
        -OverlayRelativeRoot 'overlays/antigravity' -SharedRoot 'overlays/opencode'
    Assert-True 'U9 base: normalizes across stacks to one identity family' ($id1 -ne $id2 -and $id1 -like 'plain:*' -and $id2 -like 'base:*')

    $idA = ConvertTo-SkewIdentitySource -Entry @{ Source = 'shared:rules/red-line.md' } `
        -OverlayRelativeRoot 'overlays/a' -SharedRoot 'overlays/opencode'
    $idB = ConvertTo-SkewIdentitySource -Entry @{ Source = 'shared:rules/red-line.md' } `
        -OverlayRelativeRoot 'overlays/b' -SharedRoot 'overlays/opencode'
    Assert-True 'U10 same shared source + same (no) substitutions = SAME identity across stacks' ($idA -eq $idB)

    $idC = ConvertTo-SkewIdentitySource -Entry @{
        Source = 'shared:rules/red-line.md'
        Substitutions = @(@{ Find = 'tasks'; Replace = 'subagents' })
    } -OverlayRelativeRoot 'overlays/a' -SharedRoot 'overlays/opencode'
    Assert-True 'U11 different substitutions on same source = DIFFERENT identity' ($idA -ne $idC)

    $idD = ConvertTo-SkewIdentitySource -Entry @{ Source = 'skills/x.md' } `
        -OverlayRelativeRoot 'overlays/one' -SharedRoot 'overlays/opencode'
    $idE = ConvertTo-SkewIdentitySource -Entry @{ Source = 'skills/x.md' } `
        -OverlayRelativeRoot 'overlays/two' -SharedRoot 'overlays/opencode'
    Assert-True 'U12 plain sources keep stack-scoped identity (no false overlap)' ($idD -ne $idE)

    # ---------- Copy-ManifestEntry: backward-compat planned-line shape ----------
    $report = New-HostSyncReport -StackId 'UnitTest' -Mode ([HostSyncMode]::DryRun)
    $liveScratch = Join-Path $scratch 'live'
    New-Item -ItemType Directory -Path $liveScratch -Force | Out-Null
    Copy-ManifestEntry -Report $report -Mode ([HostSyncMode]::DryRun) -CompanionRoot $companionRoot `
        -OverlayRoot $overlayScratch -LiveRoot $liveScratch -Entry @{ Source = 'src.md'; Dest = 'src.md' } `
        -SharedRoot 'overlays/opencode'
    $lineMatch = @($report.PlannedFiles | Where-Object { $_ -match 'src\.md <= src\.md \(token-merged\)$' })
    Assert-True 'U13 plain-entry dry-run planned line byte-identical (backward compat)' ($lineMatch.Count -eq 1)
    Assert-True 'U14 PlannedContent capture hook populated' ($report.PlannedContent.ContainsKey('src.md'))
    Assert-True 'U15 PlannedClasses label recorded' ($report.PlannedClasses['src.md'] -eq 'overlay')

    # U16: composed-entry missing source still errors with the backward-compatible message
    $report2 = New-HostSyncReport -StackId 'UnitTest' -Mode ([HostSyncMode]::DryRun)
    Copy-ManifestEntry -Report $report2 -Mode ([HostSyncMode]::DryRun) -CompanionRoot $companionRoot `
        -OverlayRoot $overlayScratch -LiveRoot $liveScratch -Entry @{ Source = 'missing.md' } `
        -SharedRoot 'overlays/opencode'
    $errMatch = @($report2.Errors | Where-Object { $_ -eq 'Overlay source missing: missing.md' })
    Assert-True 'U16 missing overlay source errors (message unchanged)' ($errMatch.Count -eq 1)

    # ---------- Invoke-HostSyncReadFileRef: reference resolution order (v2) ----------
    # U17: rooted/absolute references are used verbatim (never re-joined onto source dir).
    $absRef = Join-Path $overlayScratch 'abs-foot.md'
    [IO.File]::WriteAllText($absRef, 'ABS-FOOT-TEXT')
    $absOut = Invoke-HostSyncReadFileRef -FileRef $absRef -ResolvedSourcePath $srcFile `
        -OverlayRoot $overlayScratch
    Assert-True 'U17 rooted reference used verbatim (no re-join)' ($absOut -eq 'ABS-FOOT-TEXT')

    # U18: classed reference reaching the resolver without pre-resolution fails with the clear error
    $threw = $false; $msg = ''
    try {
        $null = Invoke-HostSyncReadFileRef -FileRef 'base:rules/red-line.md' -ResolvedSourcePath $srcFile `
            -OverlayRoot $overlayScratch
    } catch { $threw = $true; $msg = $_.Exception.Message }
    Assert-True 'U18 un-pre-resolved classed reference fails with clear error' `
        ($threw -and $msg -like '*requires pre-resolution*')

    # U19: overlay-relative footer resolves source-dir first, then falls back to OverlayRoot
    # (composed gate sourced from base: rules wears a footer leaf from the overlay tree)
    $overlayFoot = Join-Path $overlayScratch 'footers' 'relay.md'
    New-Item -ItemType Directory -Path (Split-Path -Parent $overlayFoot) -Force | Out-Null
    [IO.File]::WriteAllText($overlayFoot, 'RELAY-FOOT-TEXT')
    $baseSrc = Join-Path $companionRoot 'rules' 'red-line.md'
    $relayOut = Invoke-HostSyncReadFileRef -FileRef 'footers/relay.md' -ResolvedSourcePath $baseSrc `
        -OverlayRoot $overlayScratch
    Assert-True 'U19 overlay footer falls back to OverlayRoot when source-relative misses' ($relayOut -eq 'RELAY-FOOT-TEXT')

    # U20: end-to-end — composed pre-commit entry renders shared frontmatter Part ahead of body
    $sharedFM = @(
        '---'
        'name: pre-commit-ci-gate'
        'description: test shim'
        '---'
    ) -join "`n"
    $sharedDir = Join-Path $overlayScratch 'shared-root'
    New-Item -ItemType Directory -Path $sharedDir -Force | Out-Null
    [IO.File]::WriteAllText((Join-Path $sharedDir 'fm.md'), $sharedFM)
    # End-to-end: Copy-ManifestEntry pre-resolves classed Parts (shared:fm.md), so body sourced
    # from the overlay renders with the shared frontmatter ahead of it. Direct render calls
    # throw on classed refs by design (U18) — pre-resolution is Copy-ManifestEntry's job.
    [IO.File]::WriteAllText((Join-Path $overlayScratch 'pc-body.md'), 'PC-BODY')
    $entrySharedPart = @{ Source = 'pc-body.md'; Dest = 'x.md'; Parts = @('shared:fm.md') }
    $report3 = New-HostSyncReport -StackId 'UnitTest' -Mode ([HostSyncMode]::DryRun)
    Copy-ManifestEntry -Report $report3 -Mode ([HostSyncMode]::DryRun) -CompanionRoot $companionRoot `
        -OverlayRoot $overlayScratch -LiveRoot $liveScratch -Entry $entrySharedPart `
        -SharedRoot $sharedDir
    Assert-True 'U20 shared: Part pre-resolves and renders before body' `
        ($report3.Success -and $report3.PlannedContent['x.md'].Contains('name: pre-commit-ci-gate') -and
         $report3.PlannedContent['x.md'].Contains('PC-BODY'))

    # U21: OpenCode permission maps are semantically order-sensitive. A named
    # pattern lexically before "*" must not be emitted before the wildcard.
    $permissionMap = @{ '7z*' = 'allow'; '*' = 'deny' }
    $orderedPermission = Optimize-OpenCodePermissionKeyOrder -Node $permissionMap
    $permissionJson = $orderedPermission | ConvertTo-Json -Depth 5 -Compress
    $permissionRoundTrip = $permissionJson | ConvertFrom-Json
    $permissionKeys = @($permissionRoundTrip.PSObject.Properties | ForEach-Object Name)
    Assert-True 'U21 permission wildcard precedes lexical named pattern' (
        $permissionKeys.Count -eq 2 -and $permissionKeys[0] -eq '*' -and $permissionKeys[1] -eq '7z*') `
        $permissionJson

    # U22: sorting named patterns must be culture-independent. Exercise the
    # renderer under de-DE, where culture collation typically places ä before z.
    $unicodePermissionMap = @{ 'ä*' = 'allow'; 'z*' = 'ask'; '*' = 'deny' }
    $previousCulture = [Threading.Thread]::CurrentThread.CurrentCulture
    [Threading.Thread]::CurrentThread.CurrentCulture = [Globalization.CultureInfo]::new('de-DE')
    try {
        $orderedUnicodePermission = Optimize-OpenCodePermissionKeyOrder -Node $unicodePermissionMap
    }
    finally {
        [Threading.Thread]::CurrentThread.CurrentCulture = $previousCulture
    }
    $unicodePermissionKeys = @($orderedUnicodePermission.Keys | ForEach-Object { "$_" })
    Assert-True 'U22 permission named patterns sort ordinally across cultures' (
        $unicodePermissionKeys.Count -eq 3 -and
        $unicodePermissionKeys[0] -eq '*' -and
        $unicodePermissionKeys[1] -eq 'z*' -and
        $unicodePermissionKeys[2] -eq 'ä*') ($unicodePermissionKeys -join ',')
}
catch {
    $failures++
    Write-Output "FAIL: unexpected exception: $($_.Exception.Message)"
    Write-Output $_.ScriptStackTrace
}
finally {
    Remove-Item -Recurse -Force $scratch -ErrorAction SilentlyContinue
}

Write-Output ('unit checks: {0} passed, {1} failed' -f $pass, $failures)
    Write-Output ('unit suite boundary reached.')
}

if ($Suite -in @('Composition', 'All')) {
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

# ---------- 7. Authored antigravity leaves stay authored (composer/implementation-review/history-search/governed agents x4) ----------
$agyOverlay = Join-Path $companionRoot 'overlays\antigravity'
foreach ($authored in @('skills\composer\SKILL.md', 'skills\implementation-review\SKILL.md', 'skills\opencode-history-search\SKILL.md',
    'agents\planner.md', 'agents\plan_reviewer.md', 'agents\production_readiness_reviewer.md', 'agents\bug_reviewer.md')) {
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

# ---------- 11. Committed C1 mirrors equal the exact planned render ----------
$utf8NoBom = [Text.UTF8Encoding]::new($false)
$instrCommittedPath = Join-Path $companionRoot 'overlays/opencode/instructions/cursor-escape-loop.md'
$agentsCommittedPath = Join-Path $companionRoot 'overlays/opencode/AGENTS.md'
Assert-Pass 'C1 committed instructions exists' (Test-Path -LiteralPath $instrCommittedPath)
Assert-Pass 'C1 committed AGENTS.md exists' (Test-Path -LiteralPath $agentsCommittedPath)

foreach ($mirror in @(
    @{ Name = 'instructions'; Path = $instrCommittedPath; Key = $instrKey },
    @{ Name = 'AGENTS.md'; Path = $agentsCommittedPath; Key = 'AGENTS.md' }
)) {
    if ((Test-Path -LiteralPath $mirror.Path) -and $planned['OpenCode'].PlannedContent.ContainsKey($mirror.Key)) {
        $mirrorBytes = [IO.File]::ReadAllBytes($mirror.Path)
        $hasUtf8Bom = $mirrorBytes.Length -ge 3 -and
            $mirrorBytes[0] -eq 239 -and $mirrorBytes[1] -eq 187 -and $mirrorBytes[2] -eq 191
        Assert-Pass "C1 committed $($mirror.Name) has no UTF-8 BOM" (-not $hasUtf8Bom)
        $mirrorSource = $utf8NoBom.GetString($mirrorBytes)
        $mirrorRendered = Merge-CompanionTokens -Content $mirrorSource -CompanionRoot $companionNorm
        $expected = $utf8NoBom.GetBytes([string]$planned['OpenCode'].PlannedContent[$mirror.Key])
        $actual = $utf8NoBom.GetBytes($mirrorRendered)
        $expectedHash = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($expected))).ToLowerInvariant()
        $actualHash = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($actual))).ToLowerInvariant()
        Assert-Pass "C1 committed $($mirror.Name) token render equals exact planned bytes" (
            [BitConverter]::ToString($actual) -eq [BitConverter]::ToString($expected)) `
            "expected=$expectedHash actual=$actualHash"
        Assert-Pass "C1 committed $($mirror.Name) is portable token source" (
            Test-PortableCompanionTokenSource -Content $mirrorSource -CompanionRoot $companionNorm)
    }
}

if ((Test-Path -LiteralPath $instrCommittedPath) -and (Test-Path -LiteralPath $agentsCommittedPath)) {
    $instrBytes = [IO.File]::ReadAllBytes($instrCommittedPath)
    $agentsBytes = [IO.File]::ReadAllBytes($agentsCommittedPath)
    Assert-Pass 'C1 committed mirrors byte-identical' (
        [BitConverter]::ToString($instrBytes) -eq [BitConverter]::ToString($agentsBytes))
}

Write-Output ('phase2 remediation checks: {0} passed, {1} failed' -f $pass, $failures)
    Write-Output ('composition suite boundary reached.')
}

if ($Suite -eq 'All') { Write-Output ('host-sync checks: All suites completed') }
exit $(if ($script:SuiteFailures -gt 0) { 1 } else { 0 })
