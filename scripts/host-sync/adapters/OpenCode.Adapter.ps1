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
    Add-SyncWarning -Report $report -Message 'OpenCode adapter is a Phase 2 stub — no sync actions performed'
    return $report
}
