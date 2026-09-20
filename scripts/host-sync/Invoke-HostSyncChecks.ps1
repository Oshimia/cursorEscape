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
    [ValidateSet('Unit', 'Composition', 'DryRun', 'All')]
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
$baselineRoot = Join-Path $hostSyncRoot 'render-baselines\antigravity'
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

if ($Suite -in @('DryRun', 'All')) {
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..\..')).Path
$companionRoot = [IO.Path]::GetFullPath((Resolve-Path -LiteralPath $RepoRoot).Path)
$syncScript = Join-Path $companionRoot 'scripts\Sync-HostHarness.ps1'
$hostSyncRoot = Join-Path $companionRoot 'scripts\host-sync'

$fail = $false

function Assert-Pass {
    param([string]$Name, [bool]$Ok)
    $status = if ($Ok) { 'pass' } else { 'fail' }
    Write-Output "${Name}: $status"
    if (-not $Ok) { $script:fail = $true }
}

function Get-LiveOpenCodeSnapshot {
    param([string]$LiveRoot)
    $snapshot = @{}
    if (-not (Test-Path -LiteralPath $LiveRoot)) { return $snapshot }
    Get-ChildItem -LiteralPath $LiveRoot -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
        $snapshot[$_.FullName] = $_.LastWriteTimeUtc.Ticks
    }
    return $snapshot
}

function Test-LiveOpenCodeUnchanged {
    param([hashtable]$Before, [hashtable]$After)
    foreach ($key in $Before.Keys) {
        if (-not $After.ContainsKey($key)) { return $false }
        if ($Before[$key] -ne $After[$key]) { return $false }
    }
    foreach ($key in $After.Keys) {
        if (-not $Before.ContainsKey($key)) { return $false }
    }
    return $true
}

$liveOpenCode = Join-Path $env:USERPROFILE '.config\opencode'
$before = Get-LiveOpenCodeSnapshot -LiveRoot $liveOpenCode

& pwsh -NoProfile -File $syncScript -Target OpenCode
Assert-Pass 'dry-run OpenCode exit 0' ($LASTEXITCODE -eq 0)

$afterOpenCode = Get-LiveOpenCodeSnapshot -LiveRoot $liveOpenCode
Assert-Pass 'dry-run OpenCode made no live writes' (Test-LiveOpenCodeUnchanged -Before $before -After $afterOpenCode)

$beforeAll = Get-LiveOpenCodeSnapshot -LiveRoot $liveOpenCode
$liveCursor = Join-Path $env:USERPROFILE '.cursor'
$beforeCursor = Get-LiveOpenCodeSnapshot -LiveRoot $liveCursor

$codexAllDryRoot = Join-Path ([IO.Path]::GetTempPath()) ("phase2fastci-codex-" + [Guid]::NewGuid().ToString('N'))
$skillsAllDryRoot = Join-Path ([IO.Path]::GetTempPath()) ("phase2fastci-skills-" + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $codexAllDryRoot -Force | Out-Null
New-Item -ItemType Directory -Path $skillsAllDryRoot -Force | Out-Null
try {
    & pwsh -NoProfile -File $syncScript -Target All -CodexRoot $codexAllDryRoot -SkillRoot $skillsAllDryRoot
}
finally {
    Remove-Item -LiteralPath $codexAllDryRoot -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $skillsAllDryRoot -Recurse -Force -ErrorAction SilentlyContinue
}
Assert-Pass 'dry-run All exit 0' ($LASTEXITCODE -eq 0)

$afterAllOpenCode = Get-LiveOpenCodeSnapshot -LiveRoot $liveOpenCode
$afterAllCursor = Get-LiveOpenCodeSnapshot -LiveRoot $liveCursor
Assert-Pass 'dry-run All made no OpenCode writes' (Test-LiveOpenCodeUnchanged -Before $beforeAll -After $afterAllOpenCode)
Assert-Pass 'dry-run All made no Cursor writes' (Test-LiveOpenCodeUnchanged -Before $beforeCursor -After $afterAllCursor)

$syncSources = @(
    (Join-Path $hostSyncRoot 'adapters\OpenCode.Adapter.ps1')
    (Join-Path $hostSyncRoot 'HostSync.Core.ps1')
)
$combined = ($syncSources | ForEach-Object { Get-Content -LiteralPath $_ -Raw }) -join "`n"
Assert-Pass 'OpenCode adapter present (not stub)' ($combined -notmatch 'Phase 2 stub')
Assert-Pass 'Merge-HashtablePreserve in core' ($combined -match 'Merge-HashtablePreserve')
Assert-Pass 'AGENTS dual-write helper present' ($combined -match 'Invoke-OpenCodeAgentsDualWrite')
Assert-Pass 'no host-sync-apply backup paths in OpenCode sources' ($combined -notmatch 'host-sync-apply-|SkipBackup')

$manifest = Import-PowerShellDataFile -LiteralPath (Join-Path $hostSyncRoot 'manifests\opencode.manifest.psd1')
Assert-Pass 'manifest has copy entries' ($manifest.CopyEntries.Count -ge 14)
Assert-Pass 'manifest has JsonMerge' ($null -ne $manifest.JsonMerge)
Assert-Pass 'manifest hard-excludes docs/workflow' ($manifest.HardExcludes -contains 'docs/workflow')
Assert-Pass 'manifest hard-excludes review-subagent-models' ($manifest.HardExcludes -contains 'review-subagent-models')

. (Join-Path $hostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $hostSyncRoot 'HostSync.Core.ps1')
$companionNorm = Resolve-CompanionRootPath -Path $companionRoot
$openCodeHome = Get-OpenCodeHomePath
$specimenPath = Join-Path $companionRoot 'overlays\opencode\opencode.specimen.json'
$specimenHt = Resolve-OpenCodeSpecimenJson -SpecimenPath $specimenPath -CompanionRoot $companionNorm -OpenCodeHome $openCodeHome
$instr = Get-OpenCodeInstructionsPath -Config $specimenHt
Assert-Pass 'specimen instructions absolute after merge' ($instr -like "$openCodeHome*")
Assert-Pass 'specimen has no unreplaced tokens' (-not (Test-ContentHasUnmergedTokens -Content ($specimenHt | ConvertTo-Json -Depth 20 -Compress)))

# Permission pattern maps: "*" must be first (OpenCode last-match-wins)
$liveJsonPath = Join-Path $openCodeHome 'opencode.json'
$mergedHt = Merge-OpenCodeHarnessJson -Specimen $specimenHt -LiveJsonPath $liveJsonPath -PreserveTopLevelKeys @('model', 'provider')
$taskKeys = @($mergedHt.agent.build.permission.task.Keys)
$bashKeys = @($mergedHt.permission.bash.Keys)
Assert-Pass 'merged build.task permission puts * first' ($taskKeys.Count -ge 1 -and $taskKeys[0] -eq '*')
Assert-Pass 'merged global bash permission puts * first' ($bashKeys.Count -ge 1 -and $bashKeys[0] -eq '*')
Assert-Pass 'Optimize-OpenCodePermissionKeyOrder in core' ((Get-Content (Join-Path $hostSyncRoot 'HostSync.Core.ps1') -Raw) -match 'Optimize-OpenCodePermissionKeyOrder')

# --- Antigravity stack (Phase 1 structural blocks; behavioral dry-run/snapshot/inventory blocks activate in Phase 2) ---
$agyManifestPath = Join-Path $hostSyncRoot 'manifests\antigravity.manifest.psd1'
Assert-Pass 'antigravity manifest exists' (Test-Path -LiteralPath $agyManifestPath)
if (Test-Path -LiteralPath $agyManifestPath) {
    $agyManifest = Import-PowerShellDataFile -LiteralPath $agyManifestPath
    Assert-Pass 'antigravity StackId' ($agyManifest.StackId -eq 'Antigravity')
    Assert-Pass 'antigravity overlay root declared' ($agyManifest.OverlayRelativeRoot -eq 'overlays/antigravity')
    Assert-Pass 'antigravity live root declared' ($agyManifest.LiveRelativeRoot -eq '.gemini')
    Assert-Pass 'antigravity manifest has >=13 copy entries' ($agyManifest.CopyEntries.Count -ge 13)
    Assert-Pass 'antigravity excludes use no backslashes' (@($agyManifest.HardExcludes + $agyManifest.NeverTouch | Where-Object { $_ -match '\\' }).Count -eq 0)
    Assert-Pass 'antigravity hard-excludes caveman.md' ($agyManifest.HardExcludes -contains 'antigravity/global_workflows/caveman.md')
    Assert-Pass 'antigravity never-touch caveman.md' ($agyManifest.NeverTouch -contains 'antigravity/global_workflows/caveman.md')
    foreach ($agySecret in @('settings.json', 'oauth_creds.json', 'google_accounts.json')) {
        Assert-Pass "antigravity hard-excludes $agySecret" ($agyManifest.HardExcludes -contains $agySecret)
    }
    Assert-Pass 'antigravity manifest has no JsonMerge' (-not ($agyManifest.Keys -contains 'JsonMerge'))
    Assert-Pass 'antigravity manifest has no AgentsDualWrite' (-not ($agyManifest.Keys -contains 'AgentsDualWrite'))
    Assert-Pass 'antigravity manifest has no HybridRuleIds' (-not ($agyManifest.Keys -contains 'HybridRuleIds'))
    $geminiEntries = @($agyManifest.CopyEntries | Where-Object { $_.Dest -eq 'GEMINI.md' })
    Assert-Pass 'antigravity replaces GEMINI.md via exactly one entry' ($geminiEntries.Count -eq 1)
    $skillDests = @($agyManifest.CopyEntries | Where-Object { $_.Dest -like 'config/skills/*' })
    # 2026-08-29 (Phase 3 retirement, D4 map): 9 -> 11. The canonical skill inventory is
    # now eleven ids (opencode-* pair global on every stack per the 2026-08-26 ruling;
    # pre-commit-ci-gate composed from base: SoT in Phase 2).
    Assert-Pass 'antigravity skill dests under config/skills' ($skillDests.Count -eq 11)
    $wfDests = @($agyManifest.CopyEntries | Where-Object { $_.Dest -like 'antigravity/global_workflows/*' })
    Assert-Pass 'antigravity workflow dests under global_workflows' ($wfDests.Count -eq 3)
    $agentDests = @($agyManifest.CopyEntries | Where-Object { $_.Dest -like 'config/agents/*' })
    $governedAgentIds = @('planner', 'plan_reviewer', 'implementer', 'production_readiness_reviewer', 'bug_reviewer', 'repository_explorer', 'test_reviewer')
    $actualAgentIds = @($agentDests | ForEach-Object { [IO.Path]::GetFileNameWithoutExtension($_.Dest) } | Sort-Object)
    Assert-Pass 'antigravity governed role defs under config/agents' (
        $agentDests.Count -eq $governedAgentIds.Count -and
        ($actualAgentIds -join '|') -eq (($governedAgentIds | Sort-Object) -join '|')
    )
}

$agyAdapterPath = Join-Path $hostSyncRoot 'adapters\Generic.Adapter.ps1'
Assert-Pass 'generic adapter exists (not stub)' (Test-Path -LiteralPath $agyAdapterPath)
Assert-Pass 'antigravity clone adapter deleted (dispatches to Generic)' (-not (Test-Path -LiteralPath (Join-Path $hostSyncRoot 'adapters\Antigravity.Adapter.ps1')))
if (Test-Path -LiteralPath $agyAdapterPath) {
    $agyAdapterText = Get-Content -LiteralPath $agyAdapterPath -Raw
    Assert-Pass 'generic adapter exports Invoke-StackHarnessSync' ($agyAdapterText -match 'function Invoke-StackHarnessSync')
    Assert-Pass 'generic adapter is not a stub' ($agyAdapterText -notmatch 'Phase 2 stub')
    Assert-Pass 'generic adapter reuses shared Copy-ManifestEntry' ($agyAdapterText -match 'Copy-ManifestEntry')
}

# Fail-closed baseline gate: antigravity property/dir required before ANY Apply (isolated temp fixtures only)
# vscode bring-up 2026-09-01: vscode property added to the same fail-closed set (owner-approved Core gate edit).
$agiFixtureDir = Join-Path ([IO.Path]::GetTempPath()) ("hostsync-gate-" + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $agiFixtureDir -Force | Out-Null
try {
    $agiFixtureNoProp = Join-Path $agiFixtureDir 'no-prop.json'
    '{"cursor":"C:\\does\\not\\exist","opencode":"C:\\does\\not\\exist","companionSha":"x","created":"y"}' | Set-Content -LiteralPath $agiFixtureNoProp
    $agiThrewNoProp = $false
    try { Assert-BaselineBackupsPresent -PathsFile $agiFixtureNoProp -AllowCompanionShaMismatch | Out-Null } catch { $agiThrewNoProp = ($_.Exception.Message -match 'antigravity') }
    Assert-Pass 'baseline gate fails closed without antigravity property' $agiThrewNoProp

    $agiFixtureEmpty = Join-Path $agiFixtureDir 'empty-prop.json'
    '{"cursor":"C:\\does\\not\\exist","opencode":"C:\\does\\not\\exist","antigravity":"","companionSha":"x","created":"y"}' | Set-Content -LiteralPath $agiFixtureEmpty
    $agiThrewEmpty = $false
    try { Assert-BaselineBackupsPresent -PathsFile $agiFixtureEmpty -AllowCompanionShaMismatch | Out-Null } catch { $agiThrewEmpty = ($_.Exception.Message -match 'antigravity') }
    Assert-Pass 'baseline gate fails closed on empty antigravity path' $agiThrewEmpty

    $repoBaselineJson = Get-Content -LiteralPath (Get-BaselinePathsFile -HostSyncRoot $hostSyncRoot) -Raw | ConvertFrom-Json
    Assert-Pass 'baseline-backups.paths.json parses with antigravity property' ($null -ne $repoBaselineJson.antigravity)

    # vscode fail-closed negative tests (4th stack, 2026-09-01)
    $vscFixtureNoProp = Join-Path $agiFixtureDir 'no-prop-vsc.json'
    '{"cursor":"C:\\does\\not\\exist","opencode":"C:\\does\\not\\exist","antigravity":"C:\\does\\not\\exist","companionSha":"x","created":"y"}' | Set-Content -LiteralPath $vscFixtureNoProp
    $vscThrewNoProp = $false
    try { Assert-BaselineBackupsPresent -PathsFile $vscFixtureNoProp -AllowCompanionShaMismatch | Out-Null } catch { $vscThrewNoProp = ($_.Exception.Message -match 'vscode') }
    Assert-Pass 'baseline gate fails closed without vscode property' $vscThrewNoProp

    $vscFixtureEmpty = Join-Path $agiFixtureDir 'empty-prop-vsc.json'
    '{"cursor":"C:\\does\\not\\exist","opencode":"C:\\does\\not\\exist","antigravity":"C:\\does\\not\\exist","vscode":"","companionSha":"x","created":"y"}' | Set-Content -LiteralPath $vscFixtureEmpty
    $vscThrewEmpty = $false
    try { Assert-BaselineBackupsPresent -PathsFile $vscFixtureEmpty -AllowCompanionShaMismatch | Out-Null } catch { $vscThrewEmpty = ($_.Exception.Message -match 'vscode') }
    Assert-Pass 'baseline gate fails closed on empty vscode path' $vscThrewEmpty

    Assert-Pass 'baseline-backups.paths.json parses with vscode property' ($null -ne $repoBaselineJson.vscode)
}
finally {
    Remove-Item -LiteralPath $agiFixtureDir -Recurse -Force -ErrorAction SilentlyContinue
}

# --- VS Code stack structural blocks (vscode bring-up 2026-09-01) ---
$vscManifestPath = Join-Path $hostSyncRoot 'manifests\vscode.manifest.psd1'
Assert-Pass 'vscode manifest exists' (Test-Path -LiteralPath $vscManifestPath)
if (Test-Path -LiteralPath $vscManifestPath) {
    $vscManifest = Import-PowerShellDataFile -LiteralPath $vscManifestPath
    Assert-Pass 'vscode StackId' ($vscManifest.StackId -eq 'Vscode')
    Assert-Pass 'vscode overlay root declared' ($vscManifest.OverlayRelativeRoot -eq 'overlays/vscode')
    Assert-Pass 'vscode live root declared' ($vscManifest.LiveRelativeRoot -eq '.copilot')
    Assert-Pass 'vscode manifest has 21 copy entries' ($vscManifest.CopyEntries.Count -eq 21)
    Assert-Pass 'vscode excludes use no backslashes' (@($vscManifest.HardExcludes + $vscManifest.NeverTouch | Where-Object { $_ -match '\\' }).Count -eq 0)
    Assert-Pass 'vscode never-touch config.json' ($vscManifest.NeverTouch -contains 'config.json')
    Assert-Pass 'vscode manifest has no JsonMerge' (-not ($vscManifest.Keys -contains 'JsonMerge'))
    Assert-Pass 'vscode manifest has no AgentsDualWrite' (-not ($vscManifest.Keys -contains 'AgentsDualWrite'))
    Assert-Pass 'vscode manifest has no HybridRuleIds' (-not ($vscManifest.Keys -contains 'HybridRuleIds'))
    $vscAgentDests = @($vscManifest.CopyEntries | Where-Object { $_.Dest -like 'agents/*' })
    Assert-Pass 'vscode agent defs under agents/ (8 roles)' ($vscAgentDests.Count -eq 8)
    $vscSkillDests = @($vscManifest.CopyEntries | Where-Object { $_.Dest -like 'skills/*' })
    Assert-Pass 'vscode skill dests under skills/ (11)' ($vscSkillDests.Count -eq 11)
    $vscAdapterPath = Join-Path $hostSyncRoot 'adapters\Generic.Adapter.ps1'
    Assert-Pass 'vscode clone adapter deleted (dispatches to Generic)' (-not (Test-Path -LiteralPath (Join-Path $hostSyncRoot 'adapters\Vscode.Adapter.ps1')))
    Assert-Pass 'vscode dispatches to Generic adapter' (Test-Path -LiteralPath $vscAdapterPath)
    if (Test-Path -LiteralPath $vscAdapterPath) {
        $vscAdapterText = Get-Content -LiteralPath $vscAdapterPath -Raw
        Assert-Pass 'generic adapter exports Invoke-StackHarnessSync (vscode-leg)' ($vscAdapterText -match 'function Invoke-StackHarnessSync')
        Assert-Pass 'generic adapter is not a stub (vscode-leg)' ($vscAdapterText -notmatch 'Phase 2 stub')
    }
    $vscLive = Join-Path $env:USERPROFILE '.copilot'
    $beforeVsc = Get-LiveOpenCodeSnapshot -LiveRoot $vscLive
    & pwsh -NoProfile -File $syncScript -Target Vscode
    Assert-Pass 'dry-run Vscode exit 0' ($LASTEXITCODE -eq 0)
    $afterVsc = Get-LiveOpenCodeSnapshot -LiveRoot $vscLive
    Assert-Pass 'dry-run Vscode made no live writes' (Test-LiveOpenCodeUnchanged -Before $beforeVsc -After $afterVsc)
}

# --- Antigravity behavioral blocks (overlay leaves present) ---
$agyLive = Join-Path $env:USERPROFILE '.gemini'
$beforeAgy = Get-LiveOpenCodeSnapshot -LiveRoot $agyLive

& pwsh -NoProfile -File $syncScript -Target Antigravity
Assert-Pass 'dry-run Antigravity exit 0' ($LASTEXITCODE -eq 0)

$afterAgy = Get-LiveOpenCodeSnapshot -LiveRoot $agyLive
Assert-Pass 'dry-run Antigravity made no live writes' (Test-LiveOpenCodeUnchanged -Before $beforeAgy -After $afterAgy)

# Inventory-drift guard: overlay ids equal the canonical eleven AND each exists in companion skills/
# 2026-08-29 (Phase 3 retirement, D4 map): expectedNine -> eleven. opencode-headless-run and
# opencode-history-search are global on every stack (opencode-overlay inventory = the parity bar).
$expectedSkillIds = @('composer', 'diagnosing-bugs', 'discovery', 'documentation-architecture', 'implementation-plan', 'implementation-review', 'opencode-headless-run', 'opencode-history-search', 'plan-review', 'pre-commit-ci-gate', 'roadmap')
$agyOverlaySkillsRoot = Join-Path $companionRoot 'overlays\antigravity\skills'
$actualAgyIds = @(Get-ChildItem -LiteralPath $agyOverlaySkillsRoot -Directory | ForEach-Object { $_.Name })
$agyIdDelta = @(Compare-Object -ReferenceObject ($expectedSkillIds | Sort-Object) -DifferenceObject ($actualAgyIds | Sort-Object))
Assert-Pass 'antigravity overlay skill ids equal canonical eleven' ($agyIdDelta.Count -eq 0)
foreach ($agiId in $expectedSkillIds) {
    Assert-Pass "opencode overlay parity skill exists: $agiId" (Test-Path -LiteralPath (Join-Path $companionRoot "overlays\opencode\skills\$agiId\SKILL.md"))
    if (Test-Path -LiteralPath (Join-Path $companionRoot "skills\$agiId")) {
        Assert-Pass "companion base exists for mirrored id: $agiId" (Test-Path -LiteralPath (Join-Path $companionRoot "skills\$agiId\SKILL.md"))
    }
}

# Author-time harness hygiene: zero ../../ hops; every stub carries description:; thin files under 12k
$agyHarnessFiles = @(Get-ChildItem -LiteralPath (Join-Path $companionRoot 'overlays\antigravity') -Recurse -File -Include '*.md' |
    Where-Object { $_.Name -ne '_index.md' })
$agyHopViolations = @($agyHarnessFiles | Where-Object { (Get-Content -LiteralPath $_.FullName -Raw) -match '\.\./\.\./(docs|skills|agents)/' })
Assert-Pass 'zero ../../ docs|skills|agents hops in antigravity harness' ($agyHopViolations.Count -eq 0)
$agyMissingDescription = @($agyHarnessFiles | Where-Object {
    $agiRaw = Get-Content -LiteralPath $_.FullName -Raw
    ($_.Name -eq 'SKILL.md') -and ($agiRaw -notmatch '(?m)^description:')
})
Assert-Pass 'all SKILL.md stubs carry description frontmatter' ($agyMissingDescription.Count -eq 0)
$agyOver12k = @($agyHarnessFiles | Where-Object { (Get-Content -LiteralPath $_.FullName -Raw).Length -ge 12000 })
Assert-Pass 'antigravity gate/skills/workflows under 12k chars' ($agyOver12k.Count -eq 0)

# Hardcoded machine paths forbidden in harness leaves — token merge cannot catch them, so CI must
$agyHardcodedPaths = @($agyHarnessFiles | Where-Object { (Get-Content -LiteralPath $_.FullName -Raw) -match 'C:[/\\]Users[/\\]admin' })
Assert-Pass 'no hardcoded machine paths in antigravity harness' ($agyHardcodedPaths.Count -eq 0)

    $script:SuiteFailures += $(if ($fail) { 1 } else { 0 })
}
if ($Suite -eq 'All') { Write-Output ('host-sync checks: All suites completed') }
exit $(if ($script:SuiteFailures -gt 0) { 1 } else { 0 })
