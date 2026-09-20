#Requires -Version 7.0
<#
.SYNOPSIS
  Disposable fixture checks for the read-only host harness drift audit.
.DESCRIPTION
  Exercises clean, changed, missing, unreadable/path-error, path normalization,
  Cursor hybrid, OpenCode JSON ordering/malformed, and Codex dual-root cases.
  The suite never writes real host homes.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$driftScript = Join-Path $PSScriptRoot 'Test-HostHarnessDrift.ps1'
$failures = 0

function Assert-Pass {
    param([Parameter(Mandatory)][string]$Name, [Parameter(Mandatory)][bool]$Ok, [string]$Detail = '')
    $status = if ($Ok) { 'pass' } else { 'FAIL' }
    Write-Output ("drift fixture {0}: {1} {2}".TrimEnd() -f $Name, $status, $Detail)
    if (-not $Ok) { $script:failures++ }
}

function New-TemporaryFixtureRoot {
    param([Parameter(Mandatory)][string]$Prefix)
    $path = Join-Path ([IO.Path]::GetTempPath()) ($Prefix + '-' + [Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $path -Force | Out-Null
    return $path
}

function Invoke-DriftJson {
    param(
        [Parameter(Mandatory)][string]$HomeRoot,
        [string]$CodexRoot = '',
        [Parameter(Mandatory)][string]$SkillRoot,
        [Parameter(Mandatory)][string]$Target
    )
    $previousUserProfile = $env:USERPROFILE
    $env:USERPROFILE = $HomeRoot
    try {
        $arguments = @(
            '-Json', '-Target', $Target,
            '-CompanionRoot', $repoRoot,
            '-HomeRoot', $HomeRoot,
            '-SkillRoot', $SkillRoot
        )
        if (-not [string]::IsNullOrEmpty($CodexRoot)) {
            $arguments += @('-CodexRoot', $CodexRoot)
        }
        $output = & pwsh -NoProfile -File $driftScript @arguments
    }
    finally {
        $env:USERPROFILE = $previousUserProfile
    }
    [pscustomobject]@{
        ExitCode = $LASTEXITCODE
        Report = (($output -join "`n") | ConvertFrom-Json)
        Output = @($output)
    }
}

function New-PlannedFixtureFiles {
    param(
        [Parameter(Mandatory)][string]$Target,
        [Parameter(Mandatory)][string]$HomeRoot,
        [Parameter(Mandatory)][string]$CodexRoot,
        [Parameter(Mandatory)][string]$SkillRoot
    )

    $hostSyncRoot = Join-Path $repoRoot 'scripts/host-sync'
    . (Join-Path $hostSyncRoot 'HostSync.Contract.ps1')
    . (Join-Path $hostSyncRoot 'HostSync.Core.ps1')
    . (Join-Path $hostSyncRoot 'Register-StackAdapters.ps1')
    $companionRoot = Get-DefaultCompanionRoot -HostSyncRoot $hostSyncRoot
    $manifest = Get-StackManifest -StackId $Target -HostSyncRoot $hostSyncRoot
    $previousUserProfile = $env:USERPROFILE
    $env:USERPROFILE = $HomeRoot
    try {
        $report = Invoke-RegisteredStackAdapterSync -Mode ([HostSyncMode]::Apply) `
            -StackId $Target -CompanionRoot $companionRoot -Manifest $manifest `
            -HostSyncRoot $hostSyncRoot -CodexRoots @{
                CodexRoot = $CodexRoot
                SkillRoot = $SkillRoot
            }
    }
    finally {
        $env:USERPROFILE = $previousUserProfile
    }
    if (-not $report.Success) { throw "Fixture apply failed for ${Target}: $($report.Errors -join '; ')" }

    foreach ($planned in $report.PlannedContent.GetEnumerator()) {
        $identity = [string]$planned.Key
        if ($Target -eq 'Codex') {
            $parts = $identity -split '/', 2
            $root = if ($parts[0] -eq 'codex-home') { $CodexRoot } else { $SkillRoot }
            $path = Join-Path $root ($parts[1] -replace '/', [IO.Path]::DirectorySeparatorChar)
        }
        else {
            $path = Join-Path $HomeRoot (([string]$manifest.LiveRelativeRoot + '/' + $identity) -replace '/', [IO.Path]::DirectorySeparatorChar)
        }
        $parent = Split-Path -Parent $path
        if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        [IO.File]::WriteAllText($path, [string]$planned.Value, [Text.UTF8Encoding]::new($false))
    }

    if ($Target -eq 'Cursor') {
        $rulesRoot = Join-Path $HomeRoot (([string]$manifest.LiveRelativeRoot + '/rules') -replace '/', [IO.Path]::DirectorySeparatorChar)
        New-Item -ItemType Directory -Path $rulesRoot -Force | Out-Null
        foreach ($ruleId in @($manifest.HybridRuleIds)) {
            $content = Get-PlannedHybridRuleContent -CompanionRoot $companionRoot -RuleId $ruleId
            [IO.File]::WriteAllText((Join-Path $rulesRoot "$ruleId.mdc"), $content, [Text.UTF8Encoding]::new($false))
        }
    }

}

$tempRoots = [System.Collections.Generic.List[string]]::new()
function Add-TemporaryRoot {
    param([Parameter(Mandatory)][string]$Prefix)
    $path = New-TemporaryFixtureRoot -Prefix $Prefix
    $tempRoots.Add($path)
    return $path
}

try {
    # Clean Generic-stack render.
    $homeRoot = Add-TemporaryRoot 'drift-fixture-generic-home'
    $codex = Add-TemporaryRoot 'drift-fixture-generic-codex'
    $skills = Add-TemporaryRoot 'drift-fixture-generic-skills'
    New-PlannedFixtureFiles -Target Cline -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills
    $result = Invoke-DriftJson -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills -Target Cline
    Assert-Pass 'generic clean fixture' ($result.ExitCode -eq 0 -and $result.Report.summary.clean -eq $true)

    # Changed and missing exact bytes.
    $firstIdentity = @($result.Report.rows).Count
    $manifest = Import-PowerShellDataFile -LiteralPath (Join-Path $repoRoot 'scripts/host-sync/manifests/cline.manifest.psd1')
    $changedDestination = if ($manifest.CopyEntries[0].ContainsKey('Dest') -and $manifest.CopyEntries[0].Dest) {
        [string]$manifest.CopyEntries[0].Dest
    }
    else {
        [string]$manifest.CopyEntries[0].Source
    }
    $changedPath = Join-Path $homeRoot (([string]$manifest.LiveRelativeRoot + '/' + $changedDestination) -replace '/', [IO.Path]::DirectorySeparatorChar)
    [IO.File]::AppendAllText($changedPath, "`nchanged")
    $result = Invoke-DriftJson -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills -Target Cline
    Assert-Pass 'generic changed fixture' ($result.ExitCode -eq 2 -and @($result.Report.rows | Where-Object status -eq 'drift').Count -gt 0)
    Remove-Item -LiteralPath $changedPath -Force
    $result = Invoke-DriftJson -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills -Target Cline
    Assert-Pass 'generic missing fixture' ($result.ExitCode -eq 2 -and @($result.Report.rows | Where-Object status -eq 'missing').Count -gt 0)

    # Path occupied by a directory deterministically produces an error without ACL changes.
    New-Item -ItemType Directory -Path $changedPath -Force | Out-Null
    $result = Invoke-DriftJson -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills -Target Cline
    Assert-Pass 'generic path-error fixture' ($result.ExitCode -eq 3 -and @($result.Report.rows | Where-Object status -eq 'error').Count -gt 0)

    # Backslash and forward-slash companion roots agree.
    $altRepoRoot = $repoRoot -replace '\\', '/'
    $outputA = & pwsh -NoProfile -File $driftScript -Json -Target Cline -CompanionRoot $repoRoot -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills
    $exitA = $LASTEXITCODE
    $outputB = & pwsh -NoProfile -File $driftScript -Json -Target Cline -CompanionRoot $altRepoRoot -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills
    $exitB = $LASTEXITCODE
    Assert-Pass 'companion path normalization' ($exitA -eq $exitB -and (($outputA -join "`n") -eq ($outputB -join "`n")))

    # Cursor copy entries plus hybrid rules.
    $homeRoot = Add-TemporaryRoot 'drift-fixture-cursor-home'
    $codex = Add-TemporaryRoot 'drift-fixture-cursor-codex'
    $skills = Add-TemporaryRoot 'drift-fixture-cursor-skills'
    New-PlannedFixtureFiles -Target Cursor -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills
    $result = Invoke-DriftJson -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills -Target Cursor
    Assert-Pass 'cursor hybrid clean fixture' ($result.ExitCode -eq 0 -and $result.Report.summary.clean -eq $true)
    $hybridPath = Join-Path $homeRoot '.cursor/rules/iterative-plan-review.mdc'
    [IO.File]::AppendAllText($hybridPath, "`nchanged")
    $result = Invoke-DriftJson -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills -Target Cursor
    Assert-Pass 'cursor hybrid drift fixture' (
        $result.ExitCode -eq 2 -and @($result.Report.rows | Where-Object identity -eq 'rules/iterative-plan-review.mdc').Count -eq 1)

    # OpenCode exact planned JSON is clean; noncanonical JSON key order drifts; malformed JSON errors.
    $homeRoot = Add-TemporaryRoot 'drift-fixture-opencode-home'
    $codex = Add-TemporaryRoot 'drift-fixture-opencode-codex'
    $skills = Add-TemporaryRoot 'drift-fixture-opencode-skills'
    New-PlannedFixtureFiles -Target OpenCode -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills
    $result = Invoke-DriftJson -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills -Target OpenCode
    Assert-Pass 'opencode planned JSON clean fixture' ($result.ExitCode -eq 0 -and $result.Report.summary.clean -eq $true)

    # A live permission pattern lexically before "*" must still serialize after "*".
    $jsonPath = Join-Path $homeRoot '.config/opencode/opencode.json'
    $liveNode = [IO.File]::ReadAllText($jsonPath) | ConvertFrom-Json
    Add-Member -InputObject $liveNode.permission.bash -NotePropertyName '7z*' -NotePropertyValue 'allow'
    [IO.File]::WriteAllText($jsonPath, ($liveNode | ConvertTo-Json -Depth 100), [Text.UTF8Encoding]::new($false))
    $result = Invoke-DriftJson -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills -Target OpenCode
    Assert-Pass 'opencode noncanonical nested permission fixture' (
        $result.ExitCode -eq 2 -and @($result.Report.rows | Where-Object identity -eq 'opencode.json').Count -eq 1)

    # Disposable Apply canonicalizes the nested permission map, so the audit is clean again.
    New-PlannedFixtureFiles -Target OpenCode -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills
    $canonicalNode = [IO.File]::ReadAllText($jsonPath) | ConvertFrom-Json
    $bashKeys = @($canonicalNode.permission.bash.PSObject.Properties | ForEach-Object Name)
    Assert-Pass 'opencode nested permission wildcard-first fixture' (
        $bashKeys.Count -ge 2 -and $bashKeys[0] -eq '*' -and $bashKeys -contains '7z*')
    $result = Invoke-DriftJson -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills -Target OpenCode
    Assert-Pass 'opencode nested permission canonical clean fixture' (
        $result.ExitCode -eq 0 -and $result.Report.summary.clean -eq $true)

    $jsonPath = Join-Path $homeRoot '.config/opencode/opencode.json'
    $node = [IO.File]::ReadAllText($jsonPath) | ConvertFrom-Json
    $reordered = [ordered]@{}
    $properties = @($node.PSObject.Properties | Sort-Object Name)
    [array]::Reverse($properties)
    foreach ($property in $properties) {
        $reordered[$property.Name] = $property.Value
    }
    [IO.File]::WriteAllText($jsonPath, ($reordered | ConvertTo-Json -Depth 100), [Text.UTF8Encoding]::new($false))
    $result = Invoke-DriftJson -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills -Target OpenCode
    Assert-Pass 'opencode JSON ordering drift fixture' (
        $result.ExitCode -eq 2 -and @($result.Report.rows | Where-Object identity -eq 'opencode.json').Count -eq 1)

    [IO.File]::WriteAllText($jsonPath, '{bad', [Text.UTF8Encoding]::new($false))
    $result = Invoke-DriftJson -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills -Target OpenCode
    Assert-Pass 'opencode malformed JSON fixture' ($result.ExitCode -eq 3)

    # Codex identities remain root-qualified and both logical roots are audited.
    $homeRoot = Add-TemporaryRoot 'drift-fixture-codex-home'
    $codex = Add-TemporaryRoot 'drift-fixture-codex-root'
    $skills = Add-TemporaryRoot 'drift-fixture-codex-skills'
    New-PlannedFixtureFiles -Target Codex -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills
    $codexAgent = Join-Path $codex 'agents/planner.toml'
    $skillWrapper = Join-Path $skills 'composer/SKILL.md'
    $codexManagedAgent = Join-Path $codex 'AGENTS.md'

    # Owner text outside a managed block is preserved by Apply and therefore is not drift.
    [IO.File]::AppendAllText($codexManagedAgent, "`nowner-owned tail")
    $result = Invoke-DriftJson -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills -Target Codex
    Assert-Pass 'codex managed-block owner context fixture' (
        $result.ExitCode -eq 0 -and $result.Report.summary.clean -eq $true) `
        "exit=$($result.ExitCode); report=$($result.Output -join ' ')"

    [IO.File]::AppendAllText($codexAgent, "`nchanged")
    [IO.File]::AppendAllText($skillWrapper, "`nchanged")
    $result = Invoke-DriftJson -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills -Target Codex
    $identities = @($result.Report.rows | ForEach-Object identity)
    Assert-Pass 'codex dual-root drift fixture' (
        $result.ExitCode -eq 2 -and $identities -contains 'codex-home/agents/planner.toml' -and $identities -contains 'skill-root/composer/SKILL.md')

    # A change inside the managed block is drift, while the owner tail remains outside Apply ownership.
    $managedAgentText = [IO.File]::ReadAllText($codexManagedAgent)
    $endMarkerLine = [regex]::Match(
        $managedAgentText,
        '(?m)^<!--\s*cursorEscape-managed-block:v1[^\r\n]*end managed block\s*-->\s*$')
    if (-not $endMarkerLine.Success) { throw 'Codex fixture managed end marker missing.' }
    [IO.File]::WriteAllText(
        $codexManagedAgent,
        $managedAgentText.Insert($endMarkerLine.Index, "`nin-block drift`n"),
        [Text.UTF8Encoding]::new($false))
    $result = Invoke-DriftJson -HomeRoot $homeRoot -CodexRoot $codex -SkillRoot $skills -Target Codex
    $identities = @($result.Report.rows | ForEach-Object identity)
    Assert-Pass 'codex managed-block drift fixture' (
        $result.ExitCode -eq 2 -and $identities -contains 'codex-home/AGENTS.md')

    # Default Codex root resolution must use Apply's effective CODEX_HOME seam.
    $codexAlt = Add-TemporaryRoot 'drift-fixture-codex-alt-home'
    New-PlannedFixtureFiles -Target Codex -HomeRoot $homeRoot -CodexRoot $codexAlt -SkillRoot $skills
    $previousCodexHome = [Environment]::GetEnvironmentVariable('CODEX_HOME', 'Process')
    [Environment]::SetEnvironmentVariable('CODEX_HOME', $codexAlt, 'Process')
    try {
        $result = Invoke-DriftJson -HomeRoot $homeRoot -SkillRoot $skills -Target Codex
        Assert-Pass 'codex effective CODEX_HOME default clean fixture' (
            $result.ExitCode -eq 0 -and $result.Report.summary.clean -eq $true) `
            "exit=$($result.ExitCode); report=$($result.Output -join ' ')"

        [IO.File]::AppendAllText((Join-Path $codexAlt 'agents/planner.toml'), "`nchanged")
        $result = Invoke-DriftJson -HomeRoot $homeRoot -SkillRoot $skills -Target Codex
        $identities = @($result.Report.rows | ForEach-Object identity)
        Assert-Pass 'codex effective CODEX_HOME default drift fixture' (
            $result.ExitCode -eq 2 -and $identities -contains 'codex-home/agents/planner.toml') `
            "exit=$($result.ExitCode); rows=$($identities -join ',')"
    }
    finally {
        [Environment]::SetEnvironmentVariable('CODEX_HOME', $previousCodexHome, 'Process')
    }
}
finally {
    foreach ($root in $tempRoots) {
        if (Test-Path -LiteralPath $root) {
            Remove-Item -LiteralPath $root -Recurse -Force
        }
    }
}

Write-Output ("drift fixture checks: {0} failed" -f $failures)
exit $(if ($failures -gt 0) { 1 } else { 0 })
