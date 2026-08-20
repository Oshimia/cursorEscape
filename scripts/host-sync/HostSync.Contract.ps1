#Requires -Version 7.0
Set-StrictMode -Version Latest

enum HostSyncMode {
    DryRun
    Apply
}

# Adapter contract (no SkipBackup — sync does not create backups):
#   function Invoke-StackHarnessSync {
#     param(
#       [HostSyncMode] $Mode,
#       [string] $CompanionRoot,
#       [hashtable] $Manifest
#     )
#   }
# Returns a hashtable sync report (StackId, Success, PlannedFiles, AppliedFiles, Errors, Warnings, Verifications).
