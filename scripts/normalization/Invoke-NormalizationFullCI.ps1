#Requires -Version 7.4
<#.SYNOPSIS Sole Phase 1+ normalization Full CI entry point; performs no Apply or live host write.#>
param([string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$normal = $PSScriptRoot; $sync = Join-Path $RepoRoot 'scripts/host-sync'
$commands = @(
  @{ Name='fast'; File=Join-Path $normal 'Invoke-NormalizationFastCI.ps1'; Arguments=@{} },
  @{ Name='host-sync-phase2-full'; File=Join-Path $sync 'Invoke-Phase2FullCI.ps1'; Arguments=@{} },
  @{ Name='host-sync-phase3-lifecycle-full'; File=Join-Path $sync 'Invoke-Phase3FullCI.ps1'; Arguments=@{} },
  @{ Name='render-ledger'; File=Join-Path $sync 'Get-ExistingSixStackRenderLedger.ps1'; Arguments=@{ Verify=$true } },
  @{ Name='drift-fixtures'; File=Join-Path $sync 'Invoke-HostSyncDriftFixtureChecks.ps1'; Arguments=@{} }
)
foreach ($command in $commands) {
  if ($command.Name -eq 'fast') { & $command.File -RepoRoot $RepoRoot } else {
    $arguments = if ($command.ContainsKey('Arguments') -and $command.Arguments) { $command.Arguments } else { @{} }
    & $command.File @arguments
  }
  if ($LASTEXITCODE -ne 0) { throw "FAIL: $($command.Name) exited $LASTEXITCODE" }
}
$temp = Join-Path ([IO.Path]::GetTempPath()) ("normalization-full-render-" + [Guid]::NewGuid().ToString('N'))
try { & (Join-Path $normal 'Render-ProcedureRegistry.ps1') -RepoRoot $RepoRoot -OutputRoot $temp -AllowTemporaryRoot | Out-Null; if ($LASTEXITCODE -ne 0) { throw "FAIL: double-render setup exited $LASTEXITCODE" } }
finally { if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force } }
Write-Output 'normalization Full CI: PASS'
