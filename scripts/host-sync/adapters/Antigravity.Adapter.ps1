#Requires -Version 7.0
Set-StrictMode -Version Latest

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

    if (-not (Test-Path -LiteralPath $overlayRoot -PathType Container)) {
        Add-SyncError -Report $report -Message "Overlay root missing: $overlayRoot"
        return $report
    }

    $sharedRoot = 'overlays/opencode'
    if ($Manifest.ContainsKey('SharedRoot') -and -not [string]::IsNullOrWhiteSpace([string]$Manifest.SharedRoot)) {
        $sharedRoot = [string]$Manifest.SharedRoot
    }

    foreach ($entry in $Manifest.CopyEntries) {
        if (-not $report.Success) { break }
        Copy-ManifestEntry -Report $report -Mode $Mode -CompanionRoot $CompanionRoot `
            -OverlayRoot $overlayRoot -LiveRoot $liveRoot -Entry $entry -SharedRoot $sharedRoot
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
            $content = [IO.File]::ReadAllText($applied)
            if (Test-ContentHasUnmergedTokens -Content $content) {
                Add-SyncError -Report $report -Message "Unmerged tokens in applied file: $applied"
            }
            else {
                [void]$report.Verifications.Add("token merge verified: $applied")
            }
        }
    }

    return $report
}
