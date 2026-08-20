#Requires -Version 7.0
Set-StrictMode -Version Latest

function Get-HostSyncModuleRoot {
    return $PSScriptRoot
}

function Resolve-CompanionRootPath {
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )
    $resolved = [IO.Path]::GetFullPath($Path)
    return ($resolved -replace '\\', '/')
}

function Get-DefaultCompanionRoot {
    param([string]$HostSyncRoot = $PSScriptRoot)
    $scriptsRoot = Split-Path -Parent $HostSyncRoot
    return (Resolve-CompanionRootPath (Split-Path -Parent $scriptsRoot))
}

function Get-BaselinePathsFile {
    param([string]$HostSyncRoot = $PSScriptRoot)
    return (Join-Path $HostSyncRoot 'baseline-backups.paths.json')
}

function Merge-CompanionTokens {
    param(
        [Parameter(Mandatory)]
        [string] $Content,
        [Parameter(Mandatory)]
        [string] $CompanionRoot
    )
    return $Content.Replace('{{COMPANION_ROOT}}', $CompanionRoot)
}

function New-HostSyncReport {
    param(
        [Parameter(Mandatory)]
        [string] $StackId,
        [HostSyncMode] $Mode = [HostSyncMode]::DryRun
    )
    return @{
        StackId       = $StackId
        Mode          = $Mode.ToString()
        Success       = $true
        PlannedFiles  = [System.Collections.Generic.List[string]]::new()
        AppliedFiles  = [System.Collections.Generic.List[string]]::new()
        Errors        = [System.Collections.Generic.List[string]]::new()
        Warnings      = [System.Collections.Generic.List[string]]::new()
        Verifications = [System.Collections.Generic.List[string]]::new()
    }
}

function Add-SyncError {
    param(
        [hashtable] $Report,
        [string] $Message
    )
    [void]$Report.Errors.Add($Message)
    $Report.Success = $false
}

function Add-SyncWarning {
    param(
        [hashtable] $Report,
        [string] $Message
    )
    [void]$Report.Warnings.Add($Message)
}

function Assert-BaselineBackupsPresent {
    param(
        [string]$PathsFile = (Get-BaselinePathsFile),
        [string]$CompanionRoot = (Get-DefaultCompanionRoot),
        [switch]$AllowCompanionShaMismatch
    )

    if (-not (Test-Path -LiteralPath $PathsFile)) {
        throw "Phase 0 baseline gate: missing paths file: $PathsFile"
    }

    $json = Get-Content -LiteralPath $PathsFile -Raw | ConvertFrom-Json
    foreach ($prop in @('cursor', 'opencode', 'companionSha', 'created')) {
        if ($null -eq $json.$prop -or [string]::IsNullOrWhiteSpace([string]$json.$prop)) {
            throw "Phase 0 baseline gate: paths file missing required property '$prop'"
        }
    }

    foreach ($stackPath in @($json.cursor, $json.opencode)) {
        if (-not (Test-Path -LiteralPath $stackPath -PathType Container)) {
            throw "Phase 0 baseline gate: backup directory missing: $stackPath"
        }
    }

    if (-not $AllowCompanionShaMismatch) {
        try {
            $headSha = (git -C $CompanionRoot rev-parse --short HEAD 2>$null).Trim()
            if ($headSha -and $json.companionSha -ne $headSha) {
                Write-Warning "Phase 0 baseline gate: companionSha ($($json.companionSha)) differs from HEAD ($headSha) — non-blocking for Apply gate"
            }
        }
        catch {
            Write-Warning "Phase 0 baseline gate: could not compare companionSha to HEAD — $($_.Exception.Message)"
        }
    }
}

function Test-ContentHasUnmergedTokens {
    param([string]$Content)
    return ($Content -match '\{\{COMPANION_ROOT\}\}')
}

function Assert-NoPerApplyBackupArtifacts {
    param(
        [string[]]$SearchRoots = @(
            $env:USERPROFILE,
            (Join-Path $env:USERPROFILE '.config')
        )
    )
    foreach ($root in $SearchRoots) {
        if (-not (Test-Path -LiteralPath $root)) { continue }
        $hits = Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match 'host-sync-apply' }
        if ($hits) {
            throw "Per-Apply backup artifact detected (forbidden): $($hits.FullName -join ', ')"
        }
    }
}

function Get-LiveHarnessRoot {
    param(
        [Parameter(Mandatory)]
        [string] $StackId
    )
    switch ($StackId) {
        'Cursor' { return (Join-Path $env:USERPROFILE '.cursor') }
        'OpenCode' { return (Join-Path $env:USERPROFILE '.config\opencode') }
        default { throw "Unknown stack id: $StackId" }
    }
}

function Copy-ManifestEntry {
    param(
        [Parameter(Mandatory)]
        [hashtable] $Report,
        [Parameter(Mandatory)]
        [HostSyncMode] $Mode,
        [Parameter(Mandatory)]
        [string] $CompanionRoot,
        [Parameter(Mandatory)]
        [string] $OverlayRoot,
        [Parameter(Mandatory)]
        [string] $LiveRoot,
        [Parameter(Mandatory)]
        [hashtable] $Entry
    )

    $sourceRel = $Entry.Source
    $destRel = if ($Entry.Dest) { $Entry.Dest } else { $Entry.Source }
    $sourcePath = Join-Path $OverlayRoot $sourceRel
    $destPath = Join-Path $LiveRoot $destRel

    if (-not (Test-Path -LiteralPath $sourcePath)) {
        Add-SyncError -Report $Report -Message "Overlay source missing: $sourceRel"
        return
    }

    $raw = [IO.File]::ReadAllText($sourcePath)
    $merged = Merge-CompanionTokens -Content $raw -CompanionRoot $CompanionRoot

    if (Test-ContentHasUnmergedTokens -Content $merged) {
        Add-SyncError -Report $Report -Message "Unmerged tokens remain in planned output: $destRel"
        return
    }

    if ($Mode -eq [HostSyncMode]::DryRun) {
        [void]$Report.PlannedFiles.Add("$destPath <= $sourceRel (token-merged)")
        return
    }

    $destParent = Split-Path -Parent $destPath
    if ($destParent -and -not (Test-Path -LiteralPath $destParent)) {
        New-Item -ItemType Directory -Path $destParent -Force | Out-Null
    }
    [IO.File]::WriteAllText($destPath, $merged)
    [void]$Report.AppliedFiles.Add($destPath)
}

function Get-PlannedHybridRuleContent {
    param(
        [Parameter(Mandatory)]
        [string] $CompanionRoot,
        [Parameter(Mandatory)]
        [string] $RuleId
    )

    $overlayRules = Join-Path $CompanionRoot 'overlays/cursor/rules'
    $portableRules = Join-Path $CompanionRoot 'rules'
    $overlayPath = Join-Path $overlayRules "$RuleId.mdc"
    $portablePath = Join-Path $portableRules "$RuleId.md"

    if (-not (Test-Path -LiteralPath $overlayPath)) {
        throw "Hybrid overlay rule missing: $overlayPath"
    }
    if (-not (Test-Path -LiteralPath $portablePath)) {
        throw "Hybrid portable rule missing: $portablePath"
    }

    $raw = [IO.File]::ReadAllText($overlayPath)
    if ($raw -notmatch '(?s)\A(---\r?\n.*?\r?\n---\r?\n)') {
        throw "No frontmatter in $overlayPath"
    }
    $fm = $Matches[1]
    $body = [IO.File]::ReadAllText($portablePath).TrimEnd()
    $body = $body.Replace('[`../workflow/ci-ladder.md`](../workflow/ci-ladder.md)', "[ci-ladder.md]($CompanionRoot/workflow/ci-ladder.md)")
    $body = $body.Replace('[../workflow/ci-ladder.md](../workflow/ci-ladder.md)', "[ci-ladder.md]($CompanionRoot/workflow/ci-ladder.md)")
    $body = $body.Replace('](../skills/', "]($CompanionRoot/skills/")
    $body = $body.Replace('](../workflow/', "]($CompanionRoot/workflow/")

    $spawnBlock = switch ($RuleId) {
        'iterative-code-review' {
            @"
**Spawn:** ``~/.cursor/skills/implementation-review/SKILL.md``
**User Rules paste target:** ``~/.cursor/skills/implementation-review/user-rules-snippet.md``
"@
        }
        'iterative-plan-review' {
            @"
**Spawn:** ``~/.cursor/skills/implementation-plan/SKILL.md``
**User Rules paste target:** ``~/.cursor/skills/implementation-plan/user-rules-snippet.md``
"@
        }
        'pre-commit-ci-gate' {
            @"
**Detail:** ``$CompanionRoot/workflow/ci-ladder.md``
**Skill (on-demand):** ``$CompanionRoot/skills/pre-commit-ci-gate/SKILL.md`` when loaded via skill tool / companion.
"@
        }
        default { '' }
    }

    $footer = @"

---

## Cursor harness pointers (live sync)

$spawnBlock

**Companion SoT:** ``$CompanionRoot`` (absolute Reads). Transitional mirror ``~/.cursor/docs/workflow/`` is not procedure SoT.
**Deep rule leaf:** ``$CompanionRoot/rules/$RuleId.md``
"@

    return ($fm + $body + "`r`n" + $footer + "`r`n")
}

function Invoke-HybridCursorRules {
    param(
        [Parameter(Mandatory)]
        [hashtable] $Report,
        [Parameter(Mandatory)]
        [HostSyncMode] $Mode,
        [Parameter(Mandatory)]
        [string] $CompanionRoot,
        [Parameter(Mandatory)]
        [string[]] $RuleIds,
        [Parameter(Mandatory)]
        [string] $LiveRulesRoot
    )

    foreach ($ruleId in $RuleIds) {
        $planned = Get-PlannedHybridRuleContent -CompanionRoot $CompanionRoot -RuleId $ruleId
        $destPath = Join-Path $LiveRulesRoot "$ruleId.mdc"

        if (Test-ContentHasUnmergedTokens -Content $planned) {
            Add-SyncError -Report $Report -Message "Unmerged tokens in hybrid rule plan: $ruleId"
            continue
        }

        if ($Mode -eq [HostSyncMode]::DryRun) {
            [void]$Report.PlannedFiles.Add("$destPath <= hybrid($ruleId) via Write-HybridCursorRules logic")
            continue
        }
    }

    if ($Mode -eq [HostSyncMode]::Apply) {
        if (-not $Report.Success) {
            return
        }
        $scriptPath = Join-Path $CompanionRoot 'overlays/cursor/scripts/Write-HybridCursorRules.ps1'
        if (-not (Test-Path -LiteralPath $scriptPath)) {
            Add-SyncError -Report $Report -Message "Write-HybridCursorRules.ps1 missing: $scriptPath"
            return
        }
        & $scriptPath -CompanionRoot $CompanionRoot -LiveRules $LiveRulesRoot | Out-Null
        foreach ($ruleId in $RuleIds) {
            $destPath = Join-Path $LiveRulesRoot "$ruleId.mdc"
            if (-not (Test-Path -LiteralPath $destPath)) {
                Add-SyncError -Report $Report -Message "Hybrid rule not written after script invoke: $destPath"
            }
            else {
                [void]$Report.AppliedFiles.Add($destPath)
                [void]$Report.Verifications.Add("hybrid rule present: $destPath")
            }
        }
    }
}

function Test-HardExcludePathsUntouched {
    param(
        [Parameter(Mandatory)]
        [hashtable] $Report,
        [Parameter(Mandatory)]
        [string] $LiveRoot,
        [Parameter(Mandatory)]
        [string[]] $HardExcludes,
        [Parameter(Mandatory)]
        [string[]] $NeverTouch,
        [string[]] $AppliedOrPlannedDestinations
    )

    foreach ($rel in $HardExcludes) {
        $full = Join-Path $LiveRoot $rel
        foreach ($dest in $AppliedOrPlannedDestinations) {
            if ($dest -like "$full*") {
                Add-SyncError -Report $Report -Message "Hard exclude touched: $rel"
            }
        }
    }

    foreach ($rel in $NeverTouch) {
        $full = Join-Path $LiveRoot $rel
        if (-not (Test-Path -LiteralPath $full)) { continue }
        foreach ($dest in $AppliedOrPlannedDestinations) {
            if ($dest -like "$full*") {
                Add-SyncWarning -Report $Report -Message "NeverTouch path referenced in sync plan (must not delete/refresh): $rel"
            }
        }
    }
}

function Write-HostSyncReport {
    param([hashtable]$Report)

    Write-Output "=== Host sync: $($Report.StackId) ($($Report.Mode)) ==="
    Write-Output "Success: $($Report.Success)"
    if ($Report.PlannedFiles.Count -gt 0) {
        Write-Output 'PlannedFiles:'
        $Report.PlannedFiles | ForEach-Object { Write-Output "  $_" }
    }
    if ($Report.AppliedFiles.Count -gt 0) {
        Write-Output 'AppliedFiles:'
        $Report.AppliedFiles | ForEach-Object { Write-Output "  $_" }
    }
    if ($Report.Verifications.Count -gt 0) {
        Write-Output 'Verifications:'
        $Report.Verifications | ForEach-Object { Write-Output "  $_" }
    }
    if ($Report.Warnings.Count -gt 0) {
        Write-Output 'Warnings:'
        $Report.Warnings | ForEach-Object { Write-Output "  $_" }
    }
    if ($Report.Errors.Count -gt 0) {
        Write-Output 'Errors:'
        $Report.Errors | ForEach-Object { Write-Output "  $_" }
    }
}
