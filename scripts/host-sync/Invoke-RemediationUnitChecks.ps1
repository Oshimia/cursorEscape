#Requires -Version 7.0
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
exit $(if ($failures -gt 0) { 1 } else { 0 })
