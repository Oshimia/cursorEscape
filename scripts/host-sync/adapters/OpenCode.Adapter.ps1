#Requires -Version 7.0
Set-StrictMode -Version Latest

function Invoke-OpenCodeAgentsDualWrite {
    param(
        [Parameter(Mandatory)]
        [hashtable] $Report,
        [Parameter(Mandatory)]
        [HostSyncMode] $Mode,
        [Parameter(Mandatory)]
        [string] $OverlayRoot,
        [Parameter(Mandatory)]
        [string] $LiveRoot,
        [Parameter(Mandatory)]
        [string] $CompanionRoot,
        [Parameter(Mandatory)]
        [hashtable] $DualWriteConfig
    )

    $instructionsRel = $DualWriteConfig.InstructionsRel
    $agentsRel = $DualWriteConfig.AgentsRel
    $sourcePath = Join-Path $OverlayRoot ($instructionsRel -replace '/', [IO.Path]::DirectorySeparatorChar)
    $instructionsDest = Join-Path $LiveRoot ($instructionsRel -replace '/', [IO.Path]::DirectorySeparatorChar)
    $agentsDest = Join-Path $LiveRoot ($agentsRel -replace '/', [IO.Path]::DirectorySeparatorChar)

    if (-not (Test-Path -LiteralPath $sourcePath)) {
        Add-SyncError -Report $Report -Message "Dual-write source missing: $instructionsRel"
        return
    }

    $merged = Merge-CompanionTokens -Content ([IO.File]::ReadAllText($sourcePath)) -CompanionRoot $CompanionRoot
    if (Test-ContentHasUnmergedTokens -Content $merged) {
        Add-SyncError -Report $Report -Message "Unmerged tokens in dual-write source: $instructionsRel"
        return
    }

    if ($Mode -eq [HostSyncMode]::DryRun) {
        [void]$Report.PlannedFiles.Add("$instructionsDest <= $instructionsRel (token-merged)")
        [void]$Report.PlannedFiles.Add("$agentsDest <= dual-write($instructionsRel)")
        [void]$Report.Verifications.Add('dry-run AGENTS dual-write planned (byte-identical to instructions)')
        return
    }

    foreach ($destPath in @($instructionsDest, $agentsDest)) {
        $destParent = Split-Path -Parent $destPath
        if ($destParent -and -not (Test-Path -LiteralPath $destParent)) {
            New-Item -ItemType Directory -Path $destParent -Force | Out-Null
        }
        [IO.File]::WriteAllText($destPath, $merged)
        [void]$Report.AppliedFiles.Add($destPath)
    }

    $instructionsHash = Get-FileSha256Hex -Path $instructionsDest
    $agentsHash = Get-FileSha256Hex -Path $agentsDest
    if ($instructionsHash -ne $agentsHash) {
        Add-SyncError -Report $Report -Message 'AGENTS.md hash mismatch vs instructions/cursor-escape-loop.md after dual-write'
    }
    else {
        [void]$Report.Verifications.Add("AGENTS hash identical to instructions: $instructionsHash")
    }
}

function Invoke-OpenCodeJsonMerge {
    param(
        [Parameter(Mandatory)]
        [hashtable] $Report,
        [Parameter(Mandatory)]
        [HostSyncMode] $Mode,
        [Parameter(Mandatory)]
        [string] $OverlayRoot,
        [Parameter(Mandatory)]
        [string] $LiveRoot,
        [Parameter(Mandatory)]
        [string] $CompanionRoot,
        [Parameter(Mandatory)]
        [string] $OpenCodeHome,
        [Parameter(Mandatory)]
        [hashtable] $JsonMergeConfig
    )

    $specimenRel = $JsonMergeConfig.SpecimenRel
    $destRel = $JsonMergeConfig.DestRel
    $preserveKeys = @($JsonMergeConfig.PreserveTopLevelKeys)
    $specimenPath = Join-Path $OverlayRoot ($specimenRel -replace '/', [IO.Path]::DirectorySeparatorChar)
    $destPath = Join-Path $LiveRoot ($destRel -replace '/', [IO.Path]::DirectorySeparatorChar)

    try {
        $specimenHt = Resolve-OpenCodeSpecimenJson -SpecimenPath $specimenPath `
            -CompanionRoot $CompanionRoot -OpenCodeHome $OpenCodeHome
    }
    catch {
        Add-SyncError -Report $Report -Message $_.Exception.Message
        return
    }

    $liveModel = $null
    $liveProvider = $null
    if (Test-Path -LiteralPath $destPath) {
        $liveBefore = ConvertTo-NestedHashtable -Node (([IO.File]::ReadAllText($destPath)) | ConvertFrom-Json)
        if ($liveBefore.ContainsKey('model')) { $liveModel = $liveBefore['model'] }
        if ($liveBefore.ContainsKey('provider')) { $liveProvider = $liveBefore['provider'] }
    }

    $mergedHt = Merge-OpenCodeHarnessJson -Specimen $specimenHt -LiveJsonPath $destPath -PreserveTopLevelKeys $preserveKeys
    $mergedJson = ($mergedHt | ConvertTo-Json -Depth 100)

    if (Test-ContentHasUnmergedTokens -Content $mergedJson) {
        Add-SyncError -Report $Report -Message "Unmerged tokens in merged opencode.json plan"
        return
    }

    $instructions = Get-OpenCodeInstructionsPath -Config $mergedHt
    if ($instructions) {
        if ($instructions -notmatch '^[A-Za-z]:/' -and $instructions -notmatch '^/') {
            Add-SyncError -Report $Report -Message "opencode.json instructions path is not absolute: $instructions"
            return
        }
        elseif ($instructions -notlike "$OpenCodeHome*") {
            Add-SyncWarning -Report $Report -Message "opencode.json instructions path may be outside OPENCODE_HOME: $instructions"
        }
    }

    if (-not $Report.Success) { return }

    if ($Mode -eq [HostSyncMode]::DryRun) {
        [void]$Report.PlannedFiles.Add("$destPath <= json-merge($specimenRel) preserve=[$($preserveKeys -join ',')]")
        if ($null -ne $liveModel) {
            [void]$Report.Verifications.Add("dry-run preserve model: $liveModel")
        }
        if ($null -ne $liveProvider) {
            [void]$Report.Verifications.Add('dry-run preserve provider: present')
        }
        return
    }

    [IO.File]::WriteAllText($destPath, $mergedJson)
    [void]$Report.AppliedFiles.Add($destPath)

    $liveAfter = ConvertTo-NestedHashtable -Node (([IO.File]::ReadAllText($destPath)) | ConvertFrom-Json)
    if ($null -ne $liveModel) {
        if (-not $liveAfter.ContainsKey('model') -or ($liveAfter['model'] -ne $liveModel)) {
            Add-SyncError -Report $Report -Message 'model was not preserved during opencode.json merge'
        }
        else {
            [void]$Report.Verifications.Add("model preserved: $liveModel")
        }
    }
    if ($null -ne $liveProvider) {
        if (-not $liveAfter.ContainsKey('provider')) {
            Add-SyncError -Report $Report -Message 'provider was not preserved during opencode.json merge'
        }
        else {
            [void]$Report.Verifications.Add('provider preserved')
        }
    }

    foreach ($agentKey in @('plan', 'build', 'implementer')) {
        $agentPath = "agent.$agentKey"
        if ($specimenHt.ContainsKey('agent') -and $specimenHt['agent'].ContainsKey($agentKey)) {
            [void]$Report.Verifications.Add("agent.* merge applied: $agentKey")
        }
    }
}

function Invoke-StackHarnessSync {
    param(
        [Parameter(Mandatory)]
        [HostSyncMode] $Mode,
        [Parameter(Mandatory)]
        [string] $CompanionRoot,
        [Parameter(Mandatory)]
        [hashtable] $Manifest
    )

    $report = New-HostSyncReport -StackId $Manifest.StackId -Mode $Mode
    $overlayRoot = Join-Path $CompanionRoot ($Manifest.OverlayRelativeRoot -replace '/', [IO.Path]::DirectorySeparatorChar)
    $liveRoot = Join-Path $env:USERPROFILE ($Manifest.LiveRelativeRoot -replace '/', [IO.Path]::DirectorySeparatorChar)
    $openCodeHome = Get-OpenCodeHomePath -LiveRoot $liveRoot

    if (-not (Test-Path -LiteralPath $overlayRoot -PathType Container)) {
        Add-SyncError -Report $report -Message "Overlay root missing: $overlayRoot"
        return $report
    }

    $dualWriteRel = $null
    if ($Manifest.AgentsDualWrite) {
        $dualWriteRel = $Manifest.AgentsDualWrite.InstructionsRel
    }

    foreach ($entry in $Manifest.CopyEntries) {
        if (-not $report.Success) { break }
        if ($dualWriteRel -and $entry.Source -eq $dualWriteRel) { continue }
        Copy-ManifestEntry -Report $report -Mode $Mode -CompanionRoot $CompanionRoot `
            -OverlayRoot $overlayRoot -LiveRoot $liveRoot -Entry $entry
    }

    if ($report.Success -and $Manifest.AgentsDualWrite) {
        Invoke-OpenCodeAgentsDualWrite -Report $report -Mode $Mode -OverlayRoot $overlayRoot `
            -LiveRoot $liveRoot -CompanionRoot $CompanionRoot -DualWriteConfig $Manifest.AgentsDualWrite
    }

    if ($report.Success -and $Manifest.JsonMerge) {
        Invoke-OpenCodeJsonMerge -Report $report -Mode $Mode -OverlayRoot $overlayRoot `
            -LiveRoot $liveRoot -CompanionRoot $CompanionRoot -OpenCodeHome $openCodeHome `
            -JsonMergeConfig $Manifest.JsonMerge
    }

    $destinations = @()
    if ($Mode -eq [HostSyncMode]::DryRun) {
        $destinations = @($report.PlannedFiles | ForEach-Object { ($_ -split ' <= ')[0] })
    }
    else {
        $destinations = @($report.AppliedFiles)
    }

    Test-HardExcludePathsUntouched -Report $report -LiveRoot $liveRoot `
        -HardExcludes $Manifest.HardExcludes -NeverTouch $Manifest.NeverTouch `
        -AppliedOrPlannedDestinations $destinations

    if ($Mode -eq [HostSyncMode]::Apply) {
        try {
            Assert-NoPerApplyBackupArtifacts
            [void]$report.Verifications.Add('no host-sync-apply backup dirs detected')
        }
        catch {
            Add-SyncError -Report $report -Message $_.Exception.Message
        }

        foreach ($applied in $report.AppliedFiles) {
            if (-not (Test-Path -LiteralPath $applied)) {
                Add-SyncError -Report $report -Message "Applied file missing after write: $applied"
                continue
            }
            if ($applied -like '*opencode.json') { continue }
            $content = [IO.File]::ReadAllText($applied)
            if (Test-ContentHasUnmergedTokens -Content $content) {
                Add-SyncError -Report $report -Message "Unmerged tokens in applied file: $applied"
            }
            else {
                [void]$report.Verifications.Add("token merge verified: $applied")
            }
        }

        $instructionsPath = Join-Path $liveRoot 'instructions/cursor-escape-loop.md'
        $agentsPath = Join-Path $liveRoot 'AGENTS.md'
        if ((Test-Path -LiteralPath $instructionsPath) -and (Test-Path -LiteralPath $agentsPath)) {
            $iHash = Get-FileSha256Hex -Path $instructionsPath
            $aHash = Get-FileSha256Hex -Path $agentsPath
            if ($iHash -ne $aHash) {
                Add-SyncError -Report $report -Message 'Post-apply AGENTS.md not byte-identical to instructions/cursor-escape-loop.md'
            }
            else {
                [void]$report.Verifications.Add("post-apply AGENTS ≡ instructions hash: $iHash")
            }
        }
    }
    else {
        foreach ($entry in $Manifest.CopyEntries) {
            if ($dualWriteRel -and $entry.Source -eq $dualWriteRel) { continue }
            $sourcePath = Join-Path $overlayRoot $entry.Source
            if (-not (Test-Path -LiteralPath $sourcePath)) { continue }
            $merged = Merge-CompanionTokens -Content ([IO.File]::ReadAllText($sourcePath)) -CompanionRoot $CompanionRoot
            if (Test-ContentHasUnmergedTokens -Content $merged) {
                Add-SyncError -Report $report -Message "Unmerged tokens in dry-run copy plan: $($entry.Source)"
            }
        }
    }

    return $report
}
