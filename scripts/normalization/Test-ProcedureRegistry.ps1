#Requires -Version 7.4
<#.SYNOPSIS Fail-closed Phase 1 registry validity gate.#>
param([string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'ProcedureRegistry.psm1') -Force
$result = Test-ProcedureRegistryCatalogs -RepoRoot $RepoRoot
if (-not $result.Valid) { $result.Failures | ForEach-Object { Write-Error "FAIL: $_" } }
Write-Output ('registry checks: {0} catalogs valid, {1} agents, {2} skills, {3} rules, {4} workflows' -f @($result.Catalogs.Keys).Count,@($result.Catalogs.agents.items).Count,@($result.Catalogs.skills.items).Count,@($result.Catalogs.rules.items).Count,@($result.Catalogs.workflows.items).Count)
exit 0
