#Requires -Version 7.0
<#
.SYNOPSIS
  Scratch-only Phase 1 checks for the source-only Codex overlay and two-root manifest.

.DESCRIPTION
  This check never reads or writes a real Codex home or skill home. Rendering is
  in-process against explicit roots; materialized evidence lives only in a fresh
  temporary scratch root. -WriteGolden refreshes the committed Phase 1 goldens.
#>
[CmdletBinding()]
param(
    [string] $CompanionRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)),
    [switch] $WriteGolden
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$companionRoot = [IO.Path]::GetFullPath((Resolve-Path $CompanionRoot).Path)
$hostSyncRoot = $PSScriptRoot
$overlayRoot = Join-Path $companionRoot 'overlays/codex'
$manifestPath = Join-Path $hostSyncRoot 'manifests/codex.manifest.psd1'
$schemaPath = Join-Path $hostSyncRoot 'baselines/codex-phase0-baseline-schema-2026-09.json'
$goldenRoot = Join-Path $hostSyncRoot 'goldens/codex-phase1'
$fixtureCompanion = 'C:/codex-phase1-fixture/companion'
$marker = 'cursorEscape-managed:v1'
$blockMarker = 'cursorEscape-managed-block:v1'
$managedBlockId = 'codex-cursor-escape-loop'
$failed = $false

function Assert-Pass {
    param([string] $Name, [bool] $Condition)
    if ($Condition) { Write-Output "pass: $Name" }
    else { Write-Output "FAIL: $Name"; $script:failed = $true }
}

function Test-PathWithin {
    param(
        [Parameter(Mandatory)][string] $Child,
        [Parameter(Mandatory)][string] $Parent
    )
    $childFull = [IO.Path]::GetFullPath($Child).TrimEnd([char]'\', [char]'/') + [IO.Path]::DirectorySeparatorChar
    $parentFull = [IO.Path]::GetFullPath($Parent).TrimEnd([char]'\', [char]'/') + [IO.Path]::DirectorySeparatorChar
    return $childFull.StartsWith($parentFull, [StringComparison]::OrdinalIgnoreCase)
}

function Assert-NoReparseAncestor {
    param([Parameter(Mandatory)][string] $Path)
    $full = [IO.Path]::GetFullPath($Path).TrimEnd([char]'\', [char]'/')
    $rootPath = [IO.Path]::GetPathRoot($full)
    $current = $full
    while ($current -and $current.Length -gt $rootPath.Length) {
        if (Test-Path -LiteralPath $current) {
            $item = Get-Item -LiteralPath $current -Force
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                throw "Reparse point detected in ancestor chain: $current"
            }
        }
        $parent = [IO.Path]::GetDirectoryName($current)
        if (-not $parent -or $parent -eq $current) { break }
        $current = $parent
    }
}

function Get-NormalizedSha256 {
    param([Parameter(Mandatory)][string] $Content)
    $normalized = (($Content -replace "`r`n", "`n").TrimEnd("`r", "`n")) + "`n"
    $bytes = [Text.UTF8Encoding]::new($false).GetBytes($normalized)
    return ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($bytes))).ToLowerInvariant()
}

function Merge-CodexCompanionToken {
    param(
        [Parameter(Mandatory)][string] $Content,
        [Parameter(Mandatory)][string] $CompanionPath
    )
    return $Content.Replace('{{COMPANION_ROOT}}', $CompanionPath)
}

function Get-CodexRenderPlan {
    param(
        [Parameter(Mandatory)][hashtable] $Manifest,
        [Parameter(Mandatory)][string] $OverlayPath,
        [Parameter(Mandatory)][string] $CompanionPath
    )
    $rows = [System.Collections.Generic.List[hashtable]]::new()
    foreach ($entry in $Manifest.DestinationEntries) {
        if ($entry.ContainsKey('GuardOnly') -and $entry.GuardOnly) { continue }
        $sourceRel = [string]$entry.Source
        $destRel = [string]$entry.Dest
        $sourcePath = Join-Path $OverlayPath ($sourceRel -replace '/', [IO.Path]::DirectorySeparatorChar)
        if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
            throw "Codex render source missing: $sourceRel"
        }
        $raw = [IO.File]::ReadAllText($sourcePath)
        $merged = Merge-CodexCompanionToken -Content $raw -CompanionPath $CompanionPath
        [void]$rows.Add(@{
            Destination = "$([string]$entry.LogicalRoot)/$destRel"
            LogicalRoot = [string]$entry.LogicalRoot
            Role = [string]$entry.Role
            Source = $sourceRel
            Content = $merged
        })
    }
    return $rows
}

function Get-CodexFrontmatter {
    param([Parameter(Mandatory)][string] $Content)
    $match = [regex]::Match($Content, '\A---\r?\n(?<frontmatter>.*?)\r?\n---(?:\r?\n|\z)', [Text.RegularExpressions.RegexOptions]::Singleline)
    if (-not $match.Success) { return $null }
    $fm = $match.Groups['frontmatter'].Value
    $name = [regex]::Match($fm, '(?m)^name:\s*(?<value>.+?)\s*$').Groups['value'].Value.Trim('"', "'")
    $description = [regex]::Match($fm, '(?m)^description:\s*(?<value>.+?)\s*$').Groups['value'].Value.Trim('"', "'")
    return @{ Name = $name; Description = $description }
}

function ConvertFrom-CodexTomlSubset {
    param([Parameter(Mandatory)][string] $Content)
    $result = @{}
    $lines = [string[]]($Content -split "\r?\n")
    for ($index = 0; $index -lt $lines.Count; $index++) {
        $line = $lines[$index].Trim()
        if (-not $line -or $line.StartsWith('#')) { continue }
        $single = [regex]::Match($line, '^(?<key>[A-Za-z0-9_-]+)\s*=\s*"(?<value>(?:\\.|[^"])*)"\s*$')
        if ($single.Success) {
            if ($result.ContainsKey($single.Groups['key'].Value)) { throw "Duplicate TOML key: $($single.Groups['key'].Value)" }
            $invalidEscape = [regex]::Match($single.Groups['value'].Value, '\\(?![btnfr"\\/]|u[0-9a-fA-F]{4}|U[0-9a-fA-F]{8})')
            if ($invalidEscape.Success) { throw "Invalid TOML basic-string escape at or near: $($invalidEscape.Value)" }
            $result[$single.Groups['key'].Value] = $single.Groups['value'].Value.Replace('\"', '"').Replace('\\', '\')
            continue
        }
        $boolean = [regex]::Match($line, '^(?<key>[A-Za-z0-9_-]+)\s*=\s*(?<value>true|false)\s*$')
        if ($boolean.Success) {
            if ($result.ContainsKey($boolean.Groups['key'].Value)) { throw "Duplicate TOML key: $($boolean.Groups['key'].Value)" }
            $result[$boolean.Groups['key'].Value] = ($boolean.Groups['value'].Value -eq 'true')
            continue
        }
        $multiline = [regex]::Match($line, '^(?<key>[A-Za-z0-9_-]+)\s*=\s*"""\s*$')
        if ($multiline.Success) {
            if ($result.ContainsKey($multiline.Groups['key'].Value)) { throw "Duplicate TOML key: $($multiline.Groups['key'].Value)" }
            $body = [System.Collections.Generic.List[string]]::new()
            $index++
            while ($index -lt $lines.Count -and $lines[$index].Trim() -ne '"""') {
                [void]$body.Add($lines[$index])
                $index++
            }
            if ($index -ge $lines.Count) { throw "Unterminated TOML multiline string: $($multiline.Groups['key'].Value)" }
            $value = (($body -join "`n") + "`n")
            $invalidEscape = [regex]::Match($value, '\\(?![btnfr"\\/]|u[0-9a-fA-F]{4}|U[0-9a-fA-F]{8})')
            if ($invalidEscape.Success) { throw "Invalid TOML basic-string escape at or near: $($invalidEscape.Value)" }
            $result[$multiline.Groups['key'].Value] = $value
            continue
        }
        throw "Unsupported Codex TOML subset line: $line"
    }
    return $result
}

function ConvertFrom-CodexOpenAiYamlSubset {
    param([Parameter(Mandatory)][string] $Content)
    $result = @{}
    $currentKey = ''
    foreach ($line in ($Content -split "\r?\n")) {
        if (-not $line.Trim() -or $line.Trim().StartsWith('#')) { continue }
        if ($line -match '^([A-Za-z0-9_-]+):\s*$') {
            $currentKey = $Matches[1]
            $result[$currentKey] = @{}
            continue
        }
        if ($line -match '^\s{2}([A-Za-z0-9_-]+):\s*(?<value>.+?)\s*$' -and $currentKey) {
            $value = $Matches['value']
            if ($value -eq 'true' -or $value -eq 'false') { $value = ($value -eq 'true') }
            elseif ($value -match '^-?\d+$') { $value = [int]$value }
            else { $value = $value.Trim('"', "'") }
            $result[$currentKey][$Matches[1]] = $value
            continue
        }
        throw "Unsupported Codex OpenAI YAML subset line: $line"
    }
    return $result
}

function New-CodexGoldenArtifact {
    param([Parameter(Mandatory)][System.Collections.Generic.List[hashtable]] $Rows)
    $sorted = [object[]]@($Rows | Sort-Object -Property Destination)
    $entries = @(foreach ($row in $sorted) {
        [ordered]@{
            destination = $row.Destination
            logicalRoot = $row.LogicalRoot
            role = $row.Role
            sha256 = Get-NormalizedSha256 $row.Content
        }
    })
    return [ordered]@{
        schemaVersion = 1
        kind = 'codex-phase1-normalized-render-hash-golden'
        normalization = 'UTF-8 SHA-256 after CRLF-to-LF and exactly one terminal LF; explicit fixture roots; no live host state'
        fixtureCompanionRoot = $fixtureCompanion
        entries = $entries
    }
}

function Test-CodexGoldenEqual {
    param($Expected, $Actual)
    if ($Expected.schemaVersion -ne $Actual.schemaVersion -or $Expected.kind -ne $Actual.kind -or
        $Expected.normalization -ne $Actual.normalization -or $Expected.fixtureCompanionRoot -ne $Actual.fixtureCompanionRoot) { return $false }
    if (@($Expected.entries).Count -ne @($Actual.entries).Count) { return $false }
    for ($index = 0; $index -lt @($Expected.entries).Count; $index++) {
        $left = $Expected.entries[$index]
        $right = $Actual.entries[$index]
        if ($left.destination -ne $right.destination -or $left.logicalRoot -ne $right.logicalRoot -or
            $left.role -ne $right.role -or $left.sha256 -ne $right.sha256) { return $false }
    }
    return $true
}

$realCodexRoot = [IO.Path]::GetFullPath((Join-Path $env:USERPROFILE '.codex')).TrimEnd([char]'\', [char]'/')
$realSkillRoot = [IO.Path]::GetFullPath((Join-Path $env:USERPROFILE '.agents/skills')).TrimEnd([char]'\', [char]'/')
$effectiveCodexRoot = if ([string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
    $realCodexRoot
} else {
    [IO.Path]::GetFullPath($env:CODEX_HOME).TrimEnd([char]'\', [char]'/')
}
if ((Test-PathWithin $effectiveCodexRoot $realSkillRoot) -or (Test-PathWithin $realSkillRoot $effectiveCodexRoot)) {
    throw 'Effective CODEX_HOME and the real skill root must remain independent.'
}
$scratch = Join-Path ([IO.Path]::GetTempPath()) ('codex-phase1-check-' + [Guid]::NewGuid().ToString('N'))
$scratchFull = [IO.Path]::GetFullPath($scratch).TrimEnd([char]'\', [char]'/')
Assert-NoReparseAncestor -Path $scratchFull
if ((Test-PathWithin $scratchFull $effectiveCodexRoot) -or (Test-PathWithin $scratchFull $realSkillRoot) -or
    (Test-PathWithin $effectiveCodexRoot $scratchFull) -or (Test-PathWithin $realSkillRoot $scratchFull)) {
    throw 'Scratch root overlaps the effective Codex home or real skill home.'
}
try {
    New-Item -ItemType Directory -Path (Join-Path $scratch 'renders') -Force | Out-Null
    [IO.File]::WriteAllText((Join-Path $scratch 'scratch-owner'), 'Codex Phase 1 scratch evidence', [Text.UTF8Encoding]::new($false))

    Assert-Pass 'scratch root is outside the effective CODEX_HOME' (-not (Test-PathWithin $scratchFull $effectiveCodexRoot))
    Assert-Pass 'scratch root is outside real skill home' (-not (Test-PathWithin $scratchFull $realSkillRoot))
    Assert-Pass 'effective CODEX_HOME is outside scratch root' (-not (Test-PathWithin $effectiveCodexRoot $scratchFull))
    Assert-Pass 'real skill home is outside scratch root' (-not (Test-PathWithin $realSkillRoot $scratchFull))

    $manifest = Import-PowerShellDataFile -LiteralPath $manifestPath
    $schema = Get-Content -LiteralPath $schemaPath -Raw | ConvertFrom-Json
    Assert-Pass 'manifest declares Codex stack and two logical roots' ($manifest.StackId -eq 'Codex' -and @($manifest.LogicalRoots).Count -eq 2 -and (@($manifest.LogicalRoots) -contains 'codex-home') -and (@($manifest.LogicalRoots) -contains 'skill-root'))

    $expectedSet = @($schema.destinations | ForEach-Object { "$($_.logicalRoot)|$($_.relativePath)|$($_.role)" }) | Sort-Object
    $actualSet = @($manifest.DestinationEntries | ForEach-Object { "$($_.LogicalRoot)|$($_.Dest)|$($_.Role)" }) | Sort-Object
    Assert-Pass 'manifest destination and role triples exactly match Phase 0 schema' (($expectedSet -join "`n") -eq ($actualSet -join "`n"))
    $expectedHardExcludes = @(
        'codex-home:config.toml'
        'codex-home:auth.json'
        'codex-home:history.jsonl'
        'codex-home:logs'
        'codex-home:sessions'
        'codex-home:databases'
    ) | Sort-Object
    $expectedNeverTouch = @(
        'codex-home:config.toml'
        'codex-home:auth.json'
        'codex-home:history.jsonl'
        'codex-home:logs'
        'codex-home:sessions'
        'codex-home:databases'
    ) | Sort-Object
    Assert-Pass 'private-state HardExcludes are exact' ((@($manifest.HardExcludes) | Sort-Object) -join "`n" -eq ($expectedHardExcludes -join "`n"))
    Assert-Pass 'private-state NeverTouch is exact' ((@($manifest.NeverTouch) | Sort-Object) -join "`n" -eq ($expectedNeverTouch -join "`n"))
    $exclusionHits = @(
        foreach ($entry in $manifest.DestinationEntries) {
            $destinationKey = "$($entry.LogicalRoot):$($entry.Dest)"
            foreach ($exclude in @($manifest.HardExcludes) + @($manifest.NeverTouch)) {
                if ($destinationKey -eq $exclude -or $destinationKey -like "$exclude/*") { $destinationKey }
            }
        }
    )
    Assert-Pass 'no destination falls beneath an excluded or never-touch path' ($exclusionHits.Count -eq 0)
    Assert-Pass 'manifest has 23 skill destinations' (@($manifest.DestinationEntries | Where-Object LogicalRoot -eq 'skill-root').Count -eq 23)
    Assert-Pass 'manifest has seven TOML agent destinations' (@($manifest.DestinationEntries | Where-Object { $_.LogicalRoot -eq 'codex-home' -and $_.Dest -like 'agents/*.toml' }).Count -eq 7)
    $guard = @($manifest.DestinationEntries | Where-Object { $_.LogicalRoot -eq 'codex-home' -and $_.Dest -eq 'AGENTS.override.md' })
    Assert-Pass 'override destination is guard-only with no generated body' (@($guard).Count -eq 1 -and $guard[0].ContainsKey('GuardOnly') -and $guard[0].GuardOnly -eq $true -and (-not $guard[0].Contains('Source')))

    $sourceRows = Get-CodexRenderPlan -Manifest $manifest -OverlayPath $overlayRoot -CompanionPath 'PRERENDER'
    Assert-Pass 'all non-guard destinations have render sources' ($sourceRows.Count -eq 31)

    $wrapperEntries = @($manifest.DestinationEntries | Where-Object { $_.LogicalRoot -eq 'skill-root' })
    $catalog = [System.Collections.Generic.List[hashtable]]::new()
    foreach ($entry in $wrapperEntries) {
        $sourcePath = Join-Path $overlayRoot (($entry.Source -replace '/', [IO.Path]::DirectorySeparatorChar))
        $raw = [IO.File]::ReadAllText($sourcePath)
        $frontmatter = Get-CodexFrontmatter $raw
        $skillId = [IO.Path]::GetFileName((Split-Path -Parent ([string]$entry.Dest)))
        Assert-Pass "skill frontmatter parses for $skillId" ($null -ne $frontmatter -and $frontmatter.Name -eq $skillId -and $frontmatter.Description)
        [void]$catalog.Add(@{ Id = $skillId; Name = $frontmatter.Name; Description = $frontmatter.Description; Raw = $raw })
    }
    Assert-Pass 'skill names are inventory-unique' ((@($catalog.Name) | Sort-Object -Unique).Count -eq 23)

    $agentEntries = @($manifest.DestinationEntries | Where-Object { $_.LogicalRoot -eq 'codex-home' -and $_.Dest -like 'agents/*.toml' })
    $agentNames = [System.Collections.Generic.List[string]]::new()
    foreach ($entry in $agentEntries) {
        $sourcePath = Join-Path $overlayRoot (($entry.Source -replace '/', [IO.Path]::DirectorySeparatorChar))
        $toml = ConvertFrom-CodexTomlSubset ([IO.File]::ReadAllText($sourcePath))
        $fileName = [IO.Path]::GetFileNameWithoutExtension([string]$entry.Dest)
        $requiredOk = $toml.ContainsKey('name') -and $toml.ContainsKey('description') -and $toml.ContainsKey('developer_instructions')
        $allowedOk = @($toml.Keys | Where-Object { $_ -notin @('name', 'description', 'developer_instructions', 'sandbox_mode') }).Count -eq 0
        Assert-Pass "TOML parses with required fields for $fileName" ($requiredOk -and $allowedOk -and $toml.name -eq $fileName -and $toml.description -and $toml.developer_instructions)
        [void]$agentNames.Add([string]$toml.name)
    }
    Assert-Pass 'agent names are filename-matched and unique' ((@($agentNames) | Sort-Object -Unique).Count -eq 7)

    $readOnlyExpected = @('plan_reviewer', 'production_readiness_reviewer', 'bug_reviewer', 'repository_explorer', 'test_reviewer')
    foreach ($entry in $agentEntries) {
        $fileName = [IO.Path]::GetFileNameWithoutExtension([string]$entry.Dest)
        $toml = ConvertFrom-CodexTomlSubset ([IO.File]::ReadAllText((Join-Path $overlayRoot (($entry.Source -replace '/', [IO.Path]::DirectorySeparatorChar)))))
        if ($readOnlyExpected -contains $fileName) {
            Assert-Pass "read-only reviewer default for $fileName" ($toml.sandbox_mode -eq 'read-only')
        }
    }
    Assert-Pass 'implementer retains bounded workspace-write' ((ConvertFrom-CodexTomlSubset ([IO.File]::ReadAllText((Join-Path $overlayRoot 'agents/implementer.toml')))).sandbox_mode -eq 'workspace-write')

    $pinPattern = '(?m)^\s*(?:model|model_reasoning_effort|reasoning_effort)\s*[=:]\s*["'']?[A-Za-z0-9_.-]+'
    $pinnedFiles = @(
        Get-ChildItem $overlayRoot -Recurse -File -Include *.toml, *.yaml, *.md | ForEach-Object {
            if ($_.FullName -notmatch '\\_index\.md$' -and ([IO.File]::ReadAllText($_.FullName) -match $pinPattern)) { $_ }
        }
    )
    Assert-Pass 'no persistent model or reasoning pins' ($pinnedFiles.Count -eq 0)

    $markerPattern = "($([regex]::Escape($marker))|$([regex]::Escape($blockMarker)))"
    $markerMisses = @(
        @($sourceRows | Where-Object { $_.Content -notmatch $markerPattern } | ForEach-Object Destination) +
        @($catalog | Where-Object { $_.Raw -notmatch $markerPattern } | ForEach-Object Id)
    )
    Assert-Pass 'stable ownership marker is present on every generated leaf' ($markerMisses.Count -eq 0)
    $agentsSource = [IO.File]::ReadAllText((Join-Path $overlayRoot 'instructions/agents-block.md'))
    $beginCount = ([regex]::Matches($agentsSource, [regex]::Escape("<!-- $blockMarker id=`"$managedBlockId`"") + '[^\r\n]*begin managed block -->')).Count
    $endCount = ([regex]::Matches($agentsSource, [regex]::Escape("<!-- $blockMarker id=`"$managedBlockId`"; end managed block -->"))).Count
    Assert-Pass 'managed AGENTS block has one stable begin/end pair' ($beginCount -eq 1 -and $endCount -eq 1 -and $agentsSource.IndexOf("begin managed block") -lt $agentsSource.IndexOf("end managed block"))

    $functionalPlan = Get-CodexRenderPlan -Manifest $manifest -OverlayPath $overlayRoot -CompanionPath $companionRoot
    $unresolved = @($functionalPlan | Where-Object { $_.Content -match '\{\{|\}\}' } | ForEach-Object Destination)
    Assert-Pass 'zero unresolved companion tokens after render' ($unresolved.Count -eq 0)
    $relativeHops = @($functionalPlan | Where-Object { $_.Content -match '(\.\./|\.\.\\)' } | ForEach-Object Destination)
    Assert-Pass 'zero wrong-base relative hops in rendered leaves' ($relativeHops.Count -eq 0)
    $badLinks = @($functionalPlan | Where-Object { $_.Content -match '\]\((?!#|C:/|https?://)[^)]+\)' } | ForEach-Object Destination)
    Assert-Pass 'markdown links are absolute or anchors only' ($badLinks.Count -eq 0)

    $pointerMisses = [System.Collections.Generic.List[string]]::new()
    foreach ($row in ($functionalPlan | Where-Object { $_.LogicalRoot -eq 'skill-root' })) {
        $pointerCount = ([regex]::Matches($row.Content, [regex]::Escape($companionRoot) + '/[A-Za-z0-9_./-]+')).Count
        if ($pointerCount -ne 1) { [void]$pointerMisses.Add("$($row.Destination) has $pointerCount canonical pointer(s)") }
    }
    foreach ($row in $functionalPlan) {
        foreach ($match in [regex]::Matches($row.Content, [regex]::Escape($companionRoot) + '/[A-Za-z0-9_./-]+')) {
            $pointer = $match.Value
            if (-not (Test-Path -LiteralPath $pointer) -or -not (Test-PathWithin $pointer $companionRoot)) {
                [void]$pointerMisses.Add("$($row.Destination) -> $pointer")
            }
        }
    }
    Assert-Pass 'rendered companion pointers resolve inside the source checkout' ($pointerMisses.Count -eq 0)

    foreach ($row in $functionalPlan) {
        $safeName = $row.Destination -replace '[^A-Za-z0-9_.-]', '_'
        [IO.File]::WriteAllText((Join-Path $scratch 'renders' $safeName), $row.Content, [Text.UTF8Encoding]::new($false))
    }
    Assert-Pass 'render evidence materialized only beneath scratch root' ((Test-PathWithin ([IO.Path]::GetFullPath((Join-Path $scratch 'renders'))) $scratchFull))

    $descriptionBudget = (($catalog | ForEach-Object { $_.Description.Length } | Measure-Object -Sum).Sum)
    $catalogBudget = (($catalog | ForEach-Object { $_.Name.Length + $_.Description.Length } | Measure-Object -Sum).Sum)
    Assert-Pass "skill description catalog budget <= 8000 ($descriptionBudget)" ($descriptionBudget -le 8000)
    Assert-Pass "conservative name+description catalog budget <= 8000 ($catalogBudget)" ($catalogBudget -le 8000)
    Assert-Pass 'explicit-only wrapper descriptions are front-loaded' ((@($catalog | Where-Object { $_.Id -like 'opencode-*' -and $_.Description -notlike 'Explicit-only*' }).Count) -eq 0)

    foreach ($metadata in $manifest.OverlayOnlySkillMetadata) {
        $yamlPath = Join-Path $overlayRoot (($metadata.RelativePath -replace '/', [IO.Path]::DirectorySeparatorChar))
        $yaml = ConvertFrom-CodexOpenAiYamlSubset ([IO.File]::ReadAllText($yamlPath))
        Assert-Pass "minimal explicit-only metadata for $($metadata.SkillId)" ($yaml.policy.allow_implicit_invocation -eq $false -and $yaml.Keys.Count -eq 1)
        Assert-Pass "explicit-only metadata ownership marker for $($metadata.SkillId)" (([IO.File]::ReadAllText($yamlPath)) -match [regex]::Escape($marker))
    }
    $explicitOnlyDestinations = @($wrapperEntries | Where-Object Role -eq 'generated-skill-wrapper-explicit-only' | ForEach-Object { [IO.Path]::GetFileName(([IO.Path]::GetDirectoryName([string]$_.Dest))) } | Sort-Object)
    $metadataIds = @($manifest.OverlayOnlySkillMetadata | ForEach-Object SkillId | Sort-Object)
    $allMetadataFiles = @(Get-ChildItem $overlayRoot -Recurse -Filter openai.yaml | ForEach-Object { $_.FullName })
    Assert-Pass 'explicit-only metadata set is exactly declared and discoverable' (
        $explicitOnlyDestinations.Count -eq 2 -and $metadataIds.Count -eq 2 -and
        (($explicitOnlyDestinations -join '|') -eq ($metadataIds -join '|')) -and
        $allMetadataFiles.Count -eq 2)
    Assert-Pass 'ownership marker constants match manifest declarations' ($manifest.OwnershipMarker -eq $marker -and $manifest.ManagedBlockMarker -eq $blockMarker)

    $agentsRender = ($functionalPlan | Where-Object Destination -eq 'codex-home/AGENTS.md').Content
    Assert-Pass 'AGENTS render retains always-on gates and explicit-only policy' (
        $agentsRender.Contains('**Default on**') -and
        $agentsRender.Contains('When in doubt, run the plan loop') -and
        $agentsRender.Contains('Eval, harness, and multi-step operational work') -and
        $agentsRender.Contains('opencode-headless-run') -and
        $agentsRender.Contains('opencode-history-search') -and
        $agentsRender.Contains('explicit-only') -and
        $agentsRender.Contains($blockMarker))

    $fixturePlan = Get-CodexRenderPlan -Manifest $manifest -OverlayPath $overlayRoot -CompanionPath $fixtureCompanion
    $focusedDestinations = @(
        'codex-home/AGENTS.md'
        'codex-home/agents/planner.toml'
        'codex-home/agents/plan_reviewer.toml'
        'codex-home/agents/implementer.toml'
        'codex-home/agents/production_readiness_reviewer.toml'
        'codex-home/agents/bug_reviewer.toml'
        'codex-home/agents/repository_explorer.toml'
        'codex-home/agents/test_reviewer.toml'
        'skill-root/implementation-plan/SKILL.md'
        'skill-root/opencode-headless-run/SKILL.md'
        'skill-root/pre-commit-ci-gate/SKILL.md'
    )
    $actualGolden = New-CodexGoldenArtifact -Rows $fixturePlan
    $goldenPath = Join-Path $goldenRoot 'render-plan.json'
    if ($WriteGolden) {
        New-Item -ItemType Directory -Path $goldenRoot -Force | Out-Null
        [IO.File]::WriteAllText($goldenPath, ($actualGolden | ConvertTo-Json -Depth 6), [Text.UTF8Encoding]::new($false))
        $fixtureTextRoot = Join-Path $goldenRoot 'fixtures'
        New-Item -ItemType Directory -Path $fixtureTextRoot -Force | Out-Null
        foreach ($destination in $focusedDestinations) {
            $row = $fixturePlan | Where-Object Destination -eq $destination
            $relative = $destination -replace '^[^/]+/', ''
            $target = Join-Path $fixtureTextRoot ($relative -replace '/', [IO.Path]::DirectorySeparatorChar)
            New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
            [IO.File]::WriteAllText($target, $row.Content, [Text.UTF8Encoding]::new($false))
        }
        foreach ($metadata in $manifest.OverlayOnlySkillMetadata) {
            $sourcePath = Join-Path $overlayRoot (($metadata.RelativePath -replace '/', [IO.Path]::DirectorySeparatorChar))
            $target = Join-Path $fixtureTextRoot (($metadata.RelativePath -replace '/', [IO.Path]::DirectorySeparatorChar))
            New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
            [IO.File]::WriteAllText($target, [IO.File]::ReadAllText($sourcePath), [Text.UTF8Encoding]::new($false))
        }
    }
    if (Test-Path -LiteralPath $goldenPath) {
        $expectedGolden = Get-Content -LiteralPath $goldenPath -Raw | ConvertFrom-Json
        Assert-Pass 'normalized render golden matches all 31 destinations' (Test-CodexGoldenEqual $expectedGolden $actualGolden)
        $fixtureMisses = [System.Collections.Generic.List[string]]::new()
        $fixtureTextRoot = Join-Path $goldenRoot 'fixtures'
        foreach ($metadata in $manifest.OverlayOnlySkillMetadata) {
            $fixturePath = Join-Path $fixtureTextRoot (($metadata.RelativePath -replace '/', [IO.Path]::DirectorySeparatorChar))
            $sourcePath = Join-Path $overlayRoot (($metadata.RelativePath -replace '/', [IO.Path]::DirectorySeparatorChar))
            if (-not (Test-Path $fixturePath) -or ([IO.File]::ReadAllText($fixturePath)) -ne ([IO.File]::ReadAllText($sourcePath))) {
                [void]$fixtureMisses.Add($metadata.RelativePath)
            }
        }
        foreach ($row in ($fixturePlan | Where-Object { $focusedDestinations -contains $_.Destination })) {
            $fixturePath = Join-Path $fixtureTextRoot (($row.Destination -replace '^[^/]+/', '' -replace '/', [IO.Path]::DirectorySeparatorChar))
            if (-not (Test-Path $fixturePath) -or ([IO.File]::ReadAllText($fixturePath)) -ne $row.Content) {
                [void]$fixtureMisses.Add($row.Destination)
            }
        }
        Assert-Pass 'focused fixture bytes match the synthetic render plan' ($fixtureMisses.Count -eq 0)
        $fixtureFileCount = @(Get-ChildItem $fixtureTextRoot -Recurse -File).Count
        Assert-Pass 'focused fixture inventory has no orphans' ($fixtureFileCount -eq 13)
    }
    else {
        Assert-Pass 'normalized render golden exists' $false
    }
}
finally {
    Remove-Item -LiteralPath $scratch -Recurse -Force -ErrorAction SilentlyContinue
}

exit $(if ($failed) { 1 } else { 0 })
