#Requires -Version 7.0
<#
.SYNOPSIS
  Full CI: inventory diff backup ≡ current live harness allowlist (Phase 0).
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$companionRoot = 'C:\Users\admin\source\repos\general-projects\cursorEscape'
$pathsFile = Join-Path $companionRoot 'scripts\host-sync\baseline-backups.paths.json'
$json = Get-Content -LiteralPath $pathsFile -Raw | ConvertFrom-Json

$cursorLive = Join-Path $env:USERPROFILE '.cursor'
$opencodeLive = Join-Path $env:USERPROFILE '.config\opencode'

$cursorAllowlist = @('skills', 'agents', 'rules', 'review-subagent-models.md', 'docs/workflow')
$opencodeAllowlist = @('instructions', 'AGENTS.md', 'skills', 'agents', 'opencode.json')

function Get-RelativePaths {
    param([string]$Root, [string[]]$Allowlist)
    $paths = [System.Collections.Generic.List[string]]::new()
    foreach ($leaf in $Allowlist) {
        $full = Join-Path $Root $leaf
        if (-not (Test-Path -LiteralPath $full)) { continue }
        if (Test-Path -LiteralPath $full -PathType Leaf) {
            $paths.Add($leaf.Replace('\', '/')) | Out-Null
        }
        else {
            Get-ChildItem -LiteralPath $full -Recurse -File | ForEach-Object {
                $rel = $_.FullName.Substring($Root.Length).TrimStart('\', '/').Replace('\', '/')
                $paths.Add($rel) | Out-Null
            }
        }
    }
    return ($paths | Sort-Object -Unique)
}

function Compare-AllowlistTrees {
    param(
        [string]$LiveRoot,
        [string]$BackupRoot,
        [string[]]$Allowlist,
        [string]$Label
    )
    $liveSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    Get-RelativePaths -Root $LiveRoot -Allowlist $Allowlist | ForEach-Object { [void]$liveSet.Add($_) }
    $backupSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    Get-RelativePaths -Root $BackupRoot -Allowlist $Allowlist | ForEach-Object { [void]$backupSet.Add($_) }

    $missingInBackup = @($liveSet | Where-Object { -not $backupSet.Contains($_) })
    $extraInBackup = @($backupSet | Where-Object { -not $liveSet.Contains($_) })

    if ($missingInBackup.Count -eq 0 -and $extraInBackup.Count -eq 0) {
        Write-Output "${Label}: pass ($($liveSet.Count) files)"
        return $true
    }

    Write-Output "${Label}: fail"
    if ($missingInBackup.Count -gt 0) {
        Write-Output "  missing in backup:"
        $missingInBackup | Select-Object -First 20 | ForEach-Object { Write-Output "    $_" }
    }
    if ($extraInBackup.Count -gt 0) {
        Write-Output "  extra in backup:"
        $extraInBackup | Select-Object -First 20 | ForEach-Object { Write-Output "    $_" }
    }
    return $false
}

$ok = $true
if (-not (Compare-AllowlistTrees -LiveRoot $cursorLive -BackupRoot $json.cursor -Allowlist $cursorAllowlist -Label 'cursor inventory-diff')) { $ok = $false }
if (-not (Compare-AllowlistTrees -LiveRoot $opencodeLive -BackupRoot $json.opencode -Allowlist $opencodeAllowlist -Label 'opencode inventory-diff')) { $ok = $false }

exit $(if ($ok) { 0 } else { 1 })
