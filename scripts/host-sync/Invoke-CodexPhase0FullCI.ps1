#Requires -Version 7.0
<# .SYNOPSIS Non-mutating Phase 0 Full CI: restore fixture and six-stack hash ledger. #>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
& pwsh -NoProfile -File (Join-Path $root 'Invoke-CodexPhase0Checks.ps1')
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& pwsh -NoProfile -File (Join-Path $root 'Get-ExistingSixStackRenderLedger.ps1') -Verify
exit $LASTEXITCODE
