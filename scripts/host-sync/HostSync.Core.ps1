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

function Get-OpenCodeHomePath {
    param([string]$LiveRoot = '')
    if ($LiveRoot) {
        return (Resolve-CompanionRootPath -Path $LiveRoot)
    }
    return (Resolve-CompanionRootPath -Path (Join-Path $env:USERPROFILE '.config/opencode'))
}

function Merge-OpenCodeTokens {
    param(
        [Parameter(Mandatory)]
        [string] $Content,
        [Parameter(Mandatory)]
        [string] $CompanionRoot,
        [Parameter(Mandatory)]
        [string] $OpenCodeHome
    )
    $merged = Merge-CompanionTokens -Content $Content -CompanionRoot $CompanionRoot
    return $merged.Replace('{{OPENCODE_HOME}}', $OpenCodeHome)
}

function Test-ContentHasUnmergedTokens {
    param([string]$Content)
    return ($Content -match '\{\{COMPANION_ROOT\}\}|\{\{OPENCODE_HOME\}\}')
}

function ConvertTo-NestedHashtable {
    param($Node)

    if ($null -eq $Node) { return $null }
    if ($Node -is [hashtable]) {
        $ht = @{}
        foreach ($key in $Node.Keys) {
            $ht[$key] = ConvertTo-NestedHashtable -Node $Node[$key]
        }
        return $ht
    }
    if ($Node -is [System.Collections.IList] -and $Node -isnot [string]) {
        $items = New-Object object[] $Node.Count
        for ($i = 0; $i -lt $Node.Count; $i++) {
            $items[$i] = ConvertTo-NestedHashtable -Node $Node[$i]
        }
        return ,$items
    }
    if ($Node -is [pscustomobject]) {
        $ht = @{}
        foreach ($prop in $Node.PSObject.Properties) {
            $ht[$prop.Name] = ConvertTo-NestedHashtable -Node $prop.Value
        }
        return $ht
    }
    return $Node
}

function Merge-HashtablePreserve {
    param(
        [Parameter(Mandatory)]
        [hashtable] $Specimen,
        [Parameter(Mandatory)]
        [hashtable] $Live,
        [string[]] $PreserveTopLevelKeys = @()
    )

    $result = @{}

    foreach ($key in $PreserveTopLevelKeys) {
        if ($Live.ContainsKey($key)) {
            $result[$key] = $Live[$key]
        }
    }

    foreach ($key in $Specimen.Keys) {
        if ($PreserveTopLevelKeys -contains $key) { continue }

        $specVal = $Specimen[$key]
        $liveVal = if ($Live.ContainsKey($key)) { $Live[$key] } else { $null }

        if ($specVal -is [hashtable] -and $liveVal -is [hashtable]) {
            $result[$key] = Merge-HashtablePreserve -Specimen $specVal -Live $liveVal
            continue
        }

        if ($specVal -is [System.Collections.IList] -and $specVal -isnot [string]) {
            $result[$key] = $specVal
            continue
        }

        $result[$key] = $specVal
    }

    foreach ($key in $Live.Keys) {
        if ($result.ContainsKey($key)) { continue }
        if ($PreserveTopLevelKeys -contains $key) { continue }
        $result[$key] = $Live[$key]
    }

    return $result
}

function Resolve-OpenCodeSpecimenJson {
    param(
        [Parameter(Mandatory)]
        [string] $SpecimenPath,
        [Parameter(Mandatory)]
        [string] $CompanionRoot,
        [Parameter(Mandatory)]
        [string] $OpenCodeHome
    )

    if (-not (Test-Path -LiteralPath $SpecimenPath)) {
        throw "OpenCode specimen missing: $SpecimenPath"
    }

    $raw = Merge-OpenCodeTokens -Content ([IO.File]::ReadAllText($SpecimenPath)) `
        -CompanionRoot $CompanionRoot -OpenCodeHome $OpenCodeHome
    if (Test-ContentHasUnmergedTokens -Content $raw) {
        throw "Unmerged tokens remain in specimen JSON: $SpecimenPath"
    }

    return (ConvertTo-NestedHashtable -Node ($raw | ConvertFrom-Json))
}

function Get-OpenCodeInstructionsPath {
    param([hashtable]$Config)
    if (-not $Config.ContainsKey('instructions')) { return $null }
    $value = $Config['instructions']
    if ($value -is [System.Collections.IList] -and $value -isnot [string]) {
        if ($value.Count -lt 1) { return $null }
        return [string]$value[0]
    }
    return [string]$value
}

function Merge-OpenCodeHarnessJson {
    param(
        [Parameter(Mandatory)]
        [hashtable] $Specimen,
        [Parameter(Mandatory)]
        [string] $LiveJsonPath,
        [string[]] $PreserveTopLevelKeys = @('model', 'provider')
    )

    $liveHt = @{}
    if (Test-Path -LiteralPath $LiveJsonPath) {
        $liveRaw = [IO.File]::ReadAllText($LiveJsonPath)
        $liveHt = ConvertTo-NestedHashtable -Node ($liveRaw | ConvertFrom-Json)
    }

    $merged = Merge-HashtablePreserve -Specimen $Specimen -Live $liveHt -PreserveTopLevelKeys $PreserveTopLevelKeys
    return (Optimize-OpenCodePermissionKeyOrder -Node $merged)
}

function Test-IsOpenCodePermissionPatternMap {
    param($Node)

    if ($null -eq $Node) { return $false }
    $isMap = ($Node -is [hashtable]) -or ($Node -is [System.Collections.Specialized.OrderedDictionary])
    if (-not $isMap) { return $false }
    if ($Node.Count -lt 1) { return $false }

    $actions = @('allow', 'ask', 'deny')
    foreach ($value in $Node.Values) {
        if ($value -isnot [string]) { return $false }
        if ($actions -notcontains $value.ToLowerInvariant()) { return $false }
    }
    return $true
}

function Order-OpenCodePermissionPatternMap {
    param($Map)

    $ordered = [ordered]@{}
    $keys = @($Map.Keys)
    if ($keys -contains '*') {
        $ordered['*'] = $Map['*']
    }
    foreach ($key in ($keys | Where-Object { $_ -ne '*' } | Sort-Object)) {
        $ordered[$key] = $Map[$key]
    }
    return $ordered
}

function Optimize-OpenCodePermissionKeyOrder {
    param($Node)

    if ($null -eq $Node) { return $null }

    if (Test-IsOpenCodePermissionPatternMap -Node $Node) {
        return (Order-OpenCodePermissionPatternMap -Map $Node)
    }

    if (($Node -is [hashtable]) -or ($Node -is [System.Collections.Specialized.OrderedDictionary])) {
        $out = [ordered]@{}
        foreach ($key in @($Node.Keys)) {
            $out[$key] = Optimize-OpenCodePermissionKeyOrder -Node $Node[$key]
        }
        return $out
    }

    if ($Node -is [System.Collections.IList] -and $Node -isnot [string]) {
        $items = New-Object object[] $Node.Count
        for ($i = 0; $i -lt $Node.Count; $i++) {
            $items[$i] = Optimize-OpenCodePermissionKeyOrder -Node $Node[$i]
        }
        return ,$items
    }

    return $Node
}

function Get-FileSha256Hex {
    param([Parameter(Mandatory)][string]$Path)
    $bytes = [IO.File]::ReadAllBytes($Path)
    $hash = [System.Security.Cryptography.SHA256]::HashData($bytes)
    return ([BitConverter]::ToString($hash) -replace '-', '').ToLowerInvariant()
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
    foreach ($prop in @('cursor', 'opencode', 'antigravity', 'companionSha', 'created')) {
        if ($null -eq $json.$prop -or [string]::IsNullOrWhiteSpace([string]$json.$prop)) {
            throw "Phase 0 baseline gate: paths file missing required property '$prop'"
        }
    }

    foreach ($stackPath in @($json.cursor, $json.opencode, $json.antigravity)) {
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
