#Requires -Version 7.4
<#.SYNOPSIS Sole Phase 1+ normalization Fast CI entry point.#>
param([string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$checks = @(
  @{ Name='registry'; File=(Join-Path $PSScriptRoot 'Test-ProcedureRegistry.ps1') },
  @{ Name='views'; File=(Join-Path $PSScriptRoot 'Test-ProcedureRegistryViews.ps1') },
  @{ Name='phase0-current-state'; File=(Join-Path (Join-Path $RepoRoot 'scripts/normalization') 'Invoke-CurrentStateFixtureChecks.ps1') },
  @{ Name='host-sync-units'; File=(Join-Path (Join-Path $RepoRoot 'scripts/host-sync') 'Invoke-RemediationUnitChecks.ps1') }
)
foreach ($check in $checks) {
  if ($check.Name -in @('registry','views')) { & $check.File -RepoRoot $RepoRoot } else { & $check.File }
  if ($LASTEXITCODE -ne 0) { throw "FAIL: $($check.Name) exited $LASTEXITCODE" }
}
$retiredFixtureTerm = [string]::Join('', [char]0x67, [char]0x6F, [char]0x6C, [char]0x64, [char]0x65, [char]0x6E)
$tracked = & git -C $RepoRoot grep -n -I -i -w $retiredFixtureTerm -- .
if ($LASTEXITCODE -notin @(0,1)) { throw "FAIL: tracked hygiene grep exited $LASTEXITCODE" }
if ($LASTEXITCODE -eq 0) { throw "FAIL: tracked retired fixture term found: $($tracked -join '; ')" }
& git -C $RepoRoot diff --check
if ($LASTEXITCODE -ne 0) { throw "FAIL: git diff --check exited $LASTEXITCODE" }
Write-Output 'normalization Fast CI: PASS'
