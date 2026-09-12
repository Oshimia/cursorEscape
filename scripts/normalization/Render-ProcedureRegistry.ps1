#Requires -Version 7.4
<#.SYNOPSIS Render deterministic managed views to one explicit output root.#>
param([Parameter(Mandatory)][string]$OutputRoot,[string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path,[switch]$AllowTemporaryRoot)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'ProcedureRegistry.psm1') -Force
$registry = Test-ProcedureRegistryCatalogs -RepoRoot $RepoRoot
if (-not $registry.Valid) { $registry.Failures | ForEach-Object { Write-Error "FAIL: $_" } }
$view = Write-RegistryManagedView -Catalogs $registry.Catalogs -OutputRoot $OutputRoot -RepoRoot $RepoRoot -AllowTemporaryRoot:$AllowTemporaryRoot
foreach ($name in @($view.Files.Keys)) { Write-Output "rendered: $name" }
