#Requires -Version 7.0
<#
.SYNOPSIS
  Read-only exact-content drift audit for all registered host-sync stacks.

.DESCRIPTION
  Renders the existing manifests through the normal adapters and compares the
  UTF-8 bytes that Apply would write with the live destination bytes. The audit
  never writes host state. JSON output is deterministic and hashes-only.
#>
[CmdletBinding()]
param(
    [string]$Target = 'All',
    [string]$CompanionRoot = '',
    [string]$HomeRoot = '',
    [string]$CodexRoot = '',
    [string]$SkillRoot = '',
    [switch]$Json
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$hostSyncRoot = $PSScriptRoot
. (Join-Path $hostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $hostSyncRoot 'HostSync.Core.ps1')
. (Join-Path $hostSyncRoot 'Register-StackAdapters.ps1')

if ([string]::IsNullOrWhiteSpace($CompanionRoot)) {
    $CompanionRoot = Get-DefaultCompanionRoot -HostSyncRoot $hostSyncRoot
}
else {
    $CompanionRoot = Resolve-CompanionRootPath -Path $CompanionRoot
}

if ([string]::IsNullOrWhiteSpace($HomeRoot)) {
    $HomeRoot = $env:USERPROFILE
}

$registeredStackIds = Get-RegisteredStackIds
$validTargets = @($registeredStackIds) + @('All')
if ($Target -notin $validTargets) {
    Write-Error "Invalid -Target '$Target'. Valid targets: $($validTargets -join ', ')"
    exit 3
}

# Use the same effective-root seam as Apply. In particular, an empty
# -CodexRoot must honor CODEX_HOME rather than assuming ~/.codex.
$effectiveCodexRoots = Resolve-HostHarnessCodexRoots -CodexRoot $CodexRoot -SkillRoot $SkillRoot
$CodexRoot = [string]$effectiveCodexRoots.CodexRoot
$SkillRoot = [string]$effectiveCodexRoots.SkillRoot

$targetIds = if ($Target -eq 'All') { @($registeredStackIds) } else { @($Target) }
$preflightReports = [System.Collections.Generic.List[object]]::new()
foreach ($stackId in $targetIds) {
    $manifest = Get-StackManifest -StackId $stackId -HostSyncRoot $hostSyncRoot
    $preflightReports.Add((Invoke-RegisteredStackAdapterSync `
        -Mode ([HostSyncMode]::DryRun) -StackId $stackId `
        -CompanionRoot $CompanionRoot -Manifest $manifest `
        -HostSyncRoot $hostSyncRoot -CodexRoots @{
            CodexRoot = $CodexRoot
            SkillRoot = $SkillRoot
        }))
}

$rows = [System.Collections.Generic.List[object]]::new()
$checked = 0

function Add-DriftRow {
    param(
        [Parameter(Mandatory)][string]$Stack,
        [Parameter(Mandatory)][string]$Identity,
        [Parameter(Mandatory)][ValidateSet('drift', 'missing', 'error')][string]$Status,
        [AllowNull()][string]$ExpectedSha256,
        [AllowNull()][string]$ActualSha256,
        [AllowNull()][string]$Error
    )

    $rows.Add([ordered]@{
        stack = $Stack
        identity = $Identity
        status = $Status
        expectedSha256 = $ExpectedSha256
        actualSha256 = $ActualSha256
        error = $Error
    })
}

function Compare-PlannedDestination {
    param(
        [Parameter(Mandatory)][string]$Stack,
        [Parameter(Mandatory)][string]$Identity,
        [Parameter(Mandatory)][string]$PlannedText,
        [Parameter(Mandatory)][string]$PhysicalPath
    )

    $script:checked++
    $expectedBytes = [Text.UTF8Encoding]::new($false).GetBytes($PlannedText)
    $expectedHash = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($expectedBytes))).ToLowerInvariant()

    if (-not (Test-Path -LiteralPath $PhysicalPath)) {
        Add-DriftRow -Stack $Stack -Identity $Identity -Status 'missing' `
            -ExpectedSha256 $expectedHash -ActualSha256 $null -Error $null
        return
    }

    try {
        $actualBytes = [IO.File]::ReadAllBytes($PhysicalPath)
        $actualHash = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($actualBytes))).ToLowerInvariant()
        if ([BitConverter]::ToString($actualBytes) -ne [BitConverter]::ToString($expectedBytes)) {
            Add-DriftRow -Stack $Stack -Identity $Identity -Status 'drift' `
                -ExpectedSha256 $expectedHash -ActualSha256 $actualHash -Error $null
        }
    }
    catch {
        Add-DriftRow -Stack $Stack -Identity $Identity -Status 'error' `
            -ExpectedSha256 $expectedHash -ActualSha256 $null -Error $_.Exception.Message
    }
}

foreach ($report in $preflightReports) {
    $stackId = [string]$report.StackId
    if (-not $report.Success) {
        $checked++
        Add-DriftRow -Stack $stackId -Identity "<stack-report>" -Status 'error' `
            -ExpectedSha256 $null -ActualSha256 $null -Error ($report.Errors -join '; ')
        continue
    }

    $manifest = Get-StackManifest -StackId $stackId -HostSyncRoot $hostSyncRoot
    if ($stackId -eq 'Codex') {
        $liveRoots = @{
            'codex-home' = [string]$report.Roots['codex-home']
            'skill-root' = [string]$report.Roots['skill-root']
        }
    }
    else {
        $liveRoot = Join-Path $HomeRoot ([string]$manifest.LiveRelativeRoot)
    }

    foreach ($planned in $report.PlannedContent.GetEnumerator()) {
        $identity = [string]$planned.Key
        $relative = $identity
        if ($stackId -eq 'Codex') {
            $parts = $identity -split '/', 2
            if (@($parts).Count -ne 2 -or -not $liveRoots.ContainsKey([string]$parts[0])) {
                $checked++
                Add-DriftRow -Stack $stackId -Identity $identity -Status 'error' `
                    -ExpectedSha256 $null -ActualSha256 $null -Error 'Invalid root-qualified Codex identity.'
                continue
            }
            $physicalPath = Join-Path $liveRoots[[string]$parts[0]] ($parts[1] -replace '/', [IO.Path]::DirectorySeparatorChar)
        }
        else {
            $physicalPath = Join-Path $liveRoot ($identity -replace '/', [IO.Path]::DirectorySeparatorChar)
        }

        # Codex exposes Apply-equivalent destination output separately: its
        # PlannedContent is the managed block, while existing targets preserve
        # owner-owned text outside that block.
        $plannedMap = if ($report.ContainsKey('PlannedOutputContent') -and
            $report.PlannedOutputContent.ContainsKey($identity)) {
            $report.PlannedOutputContent
        }
        else {
            $report.PlannedContent
        }

        Compare-PlannedDestination -Stack $stackId -Identity $identity `
            -PlannedText ([string]$plannedMap[$identity]) -PhysicalPath $physicalPath
    }

    if ($stackId -eq 'Cursor') {
        $cursorRulesRoot = Join-Path $HomeRoot ([string]$manifest.LiveRelativeRoot) 'rules'
        foreach ($ruleId in @($manifest.HybridRuleIds)) {
            $identity = "rules/$ruleId.mdc"
            $plannedText = Get-PlannedHybridRuleContent -CompanionRoot $CompanionRoot -RuleId $ruleId
            Compare-PlannedDestination -Stack $stackId -Identity $identity `
                -PlannedText $plannedText -PhysicalPath (Join-Path $cursorRulesRoot "$ruleId.mdc")
        }
    }

    if ($stackId -eq 'OpenCode' -and $report.Success -and $manifest.JsonMerge) {
        $jsonConfig = $manifest.JsonMerge
        $identity = [string]$jsonConfig.DestRel
        $jsonPath = Join-Path $liveRoot ($identity -replace '/', [IO.Path]::DirectorySeparatorChar)
        try {
            $specimenPath = Join-Path (Join-Path $CompanionRoot ([string]$manifest.OverlayRelativeRoot)) `
                ([string]$jsonConfig.SpecimenRel)
            $specimen = Resolve-OpenCodeSpecimenJson -SpecimenPath $specimenPath `
                -CompanionRoot $CompanionRoot -OpenCodeHome (Get-OpenCodeHomePath -LiveRoot $liveRoot)
            $mergedJson = Merge-OpenCodeHarnessJson -Specimen $specimen -LiveJsonPath $jsonPath `
                -PreserveTopLevelKeys @($jsonConfig.PreserveTopLevelKeys)
            Compare-PlannedDestination -Stack $stackId -Identity $identity `
                -PlannedText (($mergedJson | ConvertTo-Json -Depth 100)) -PhysicalPath $jsonPath
        }
        catch {
            $checked++
            Add-DriftRow -Stack $stackId -Identity $identity -Status 'error' `
                -ExpectedSha256 $null -ActualSha256 $null -Error $_.Exception.Message
        }
    }
}

$orderedRows = @($rows | Sort-Object -Property @{Expression='stack';Descending=$false}, @{Expression='identity';Descending=$false}, @{Expression='status';Descending=$false})
$driftCount = @($orderedRows | Where-Object status -eq 'drift').Count
$missingCount = @($orderedRows | Where-Object status -eq 'missing').Count
$errorCount = @($orderedRows | Where-Object status -eq 'error').Count
$summary = [ordered]@{
    checked = $checked
    missing = $missingCount
    drift = $driftCount
    error = $errorCount
    clean = ($missingCount -eq 0 -and $driftCount -eq 0 -and $errorCount -eq 0)
}

if ($Json) {
    [ordered]@{
        schemaVersion = 1
        kind = 'host-harness-drift-report'
        companionRoot = $CompanionRoot
        targets = $targetIds
        summary = $summary
        rows = $orderedRows
    } | ConvertTo-Json -Depth 8
}
else {
    Write-Output ("host harness drift: checked={0} missing={1} drift={2} error={3} clean={4}" -f `
        $summary.checked, $summary.missing, $summary.drift, $summary.error, $summary.clean)
    foreach ($row in $orderedRows) {
        Write-Output ("{0} {1} {2} expected={3} actual={4} {5}" -f `
            $row.status, $row.stack, $row.identity, $row.expectedSha256, $row.actualSha256, $row.error).TrimEnd()
    }
}

if ($errorCount -gt 0) {
    exit 3
}
elseif ($missingCount -gt 0 -or $driftCount -gt 0) {
    exit 2
}
exit 0
