#Requires -Version 7.4
<#.SYNOPSIS Sole normalization Fast CI entry point.#>
param([string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$checks = @(
  @{ Name='registry'; File=(Join-Path $PSScriptRoot 'Test-ProcedureRegistry.ps1') },
  @{ Name='views'; File=(Join-Path $PSScriptRoot 'Test-ProcedureRegistryViews.ps1') },
  @{ Name='local-scratch-safety'; File=(Join-Path $PSScriptRoot 'Test-LocalScratchSafety.ps1') },
  @{ Name='current-state'; File=(Join-Path (Join-Path $RepoRoot 'scripts/normalization') 'Invoke-CurrentStateFixtureChecks.ps1') },
  @{ Name='host-sync-units'; File=(Join-Path (Join-Path $RepoRoot 'scripts/host-sync') 'Invoke-HostSyncChecks.ps1'); Arguments=@{ Suite='Unit' } },
  @{ Name='codex-render'; File=(Join-Path (Join-Path $RepoRoot 'scripts/host-sync') 'Invoke-CodexRenderChecks.ps1') }
)
foreach ($check in $checks) {
  if ($check.Name -eq 'current-state') { & $check.File -RepoRoot $RepoRoot }
  elseif ($check.Name -in @('registry','views')) { & $check.File -RepoRoot $RepoRoot }
  elseif ($check.Name -eq 'codex-render') { & $check.File -CompanionRoot $RepoRoot }
  elseif ($check.Name -eq 'host-sync-units') { & $check.File -Suite Unit }
  else { & $check.File }
  if ($LASTEXITCODE -ne 0) { throw "FAIL: $($check.Name) exited $LASTEXITCODE" }
}
& git -C $RepoRoot diff --check
if ($LASTEXITCODE -ne 0) { throw "FAIL: git diff --check exited $LASTEXITCODE" }
Write-Output 'normalization Fast CI: PASS'
