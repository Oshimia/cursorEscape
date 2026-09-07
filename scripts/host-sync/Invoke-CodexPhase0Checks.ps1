#Requires -Version 7.0
<# .SYNOPSIS Scratch-only Phase 0 checks for the Codex two-root baseline seam. #>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$companionRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$schemaPath = Join-Path $PSScriptRoot 'baselines/codex-phase0-baseline-schema-2026-09.json'
$recipePath = Join-Path $PSScriptRoot 'New-CodexPhase0Baseline.ps1'
$scratch = Join-Path ([IO.Path]::GetTempPath()) ('codex-phase0-check-' + [Guid]::NewGuid().ToString('N'))
$failed = $false
function Assert-Pass { param([string]$Name, [bool]$Condition) if ($Condition) { Write-Output "pass: $Name" } else { Write-Output "FAIL: $Name"; $script:failed = $true } }
function Snapshot { param([string]$Root) $out = @{}; if (Test-Path $Root) { Get-ChildItem -LiteralPath $Root -Recurse -File | ForEach-Object { $out[$_.FullName] = [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([IO.File]::ReadAllBytes($_.FullName))) } }; return $out }
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

try {
    $codex = Join-Path $scratch 'explicit-codex-home'
    $skills = Join-Path $scratch 'explicit-agents-skills'
    $baseline = Join-Path $scratch 'baseline-output'
    $realCodex = [IO.Path]::GetFullPath((Join-Path $env:USERPROFILE '.codex')).TrimEnd([char]'\', [char]'/')
    $realSkills = [IO.Path]::GetFullPath((Join-Path $env:USERPROFILE '.agents/skills')).TrimEnd([char]'\', [char]'/')
    $codexFull = [IO.Path]::GetFullPath($codex).TrimEnd([char]'\', [char]'/')
    $skillsFull = [IO.Path]::GetFullPath($skills).TrimEnd([char]'\', [char]'/')
    if ((Test-PathWithin $codexFull $realCodex) -or (Test-PathWithin $codexFull $realSkills) `
            -or (Test-PathWithin $skillsFull $realCodex) -or (Test-PathWithin $skillsFull $realSkills)) {
        throw 'Scratch root resolved within a real Codex or skill profile root.'
    }
    Assert-NoReparseAncestor -Path $codexFull
    Assert-NoReparseAncestor -Path $skillsFull
    New-Item -ItemType Directory -Path (Join-Path $codex 'agents'), (Join-Path $skills 'discovery') -Force | Out-Null
    [IO.File]::WriteAllText((Join-Path $codex 'AGENTS.md'), 'pre-existing global guidance')
    [IO.File]::WriteAllBytes((Join-Path $codex 'AGENTS.override.md'), [byte[]]::new(0))
    [IO.File]::WriteAllText((Join-Path $codex 'agents/plan_reviewer.toml'), 'foreign = true')
    [IO.File]::WriteAllText((Join-Path $skills 'discovery/SKILL.md'), 'pre-existing wrapper')
    $beforeCodex = Snapshot $codex; $beforeSkills = Snapshot $skills
    Assert-Pass 'explicit Codex scratch root is not within real Codex profile' (-not (Test-PathWithin $codexFull $realCodex))
    Assert-Pass 'explicit skill scratch root is not within real skill profile' (-not (Test-PathWithin $skillsFull $realSkills))
    Assert-Pass 'explicit Codex scratch root is not within real skill profile' (-not (Test-PathWithin $codexFull $realSkills))
    Assert-Pass 'explicit skill scratch root is not within real Codex profile' (-not (Test-PathWithin $skillsFull $realCodex))
    $refused = $false; try { & $recipePath -CodexRoot $codex -SkillRoot $skills -BaselineRoot $baseline -BaselineSchemaPath $schemaPath | Out-Null } catch { $refused = $_.Exception.Message -match 'Owner authorization required' }
    Assert-Pass 'baseline recipe refuses without owner authorization' $refused
    Assert-Pass 'refusal created no baseline output' (-not (Test-Path -LiteralPath $baseline))
    & $recipePath -CodexRoot $codex -SkillRoot $skills -BaselineRoot $baseline -BaselineSchemaPath $schemaPath -OwnerAuthorized | Out-Null
    Assert-Pass 'authorized scratch capture writes manifest' (Test-Path -LiteralPath (Join-Path $baseline 'codex-phase0-baseline.json'))
    Assert-Pass 'capture left explicit Codex root byte-identical' ((Snapshot $codex | ConvertTo-Json -Compress) -eq ($beforeCodex | ConvertTo-Json -Compress))
    Assert-Pass 'capture left explicit skill root byte-identical' ((Snapshot $skills | ConvertTo-Json -Compress) -eq ($beforeSkills | ConvertTo-Json -Compress))
    $artifact = Get-Content -LiteralPath (Join-Path $baseline 'codex-phase0-baseline.json') -Raw | ConvertFrom-Json
    Assert-Pass 'artifact declares restore-only later-apply semantics' ($artifact.semantics -match 'later Applies use owned current state')
    Assert-Pass 'artifact records two logical roots' (($artifact.entries.logicalRoot | Sort-Object -Unique).Count -eq 2)
    Assert-Pass 'artifact captured existing AGENTS bytes' ((Test-Path -LiteralPath (Join-Path $baseline 'contents/codex-home/AGENTS.md')))
    $schema = Get-Content -LiteralPath $schemaPath -Raw | ConvertFrom-Json
    Assert-Pass 'schema contains 23 skill destinations' (@($schema.destinations | Where-Object logicalRoot -eq 'skill-root').Count -eq 23)
    Assert-Pass 'schema contains seven custom-agent destinations' (@($schema.destinations | Where-Object { $_.relativePath -like 'agents/*.toml' }).Count -eq 7)
    $stateViolations = @($schema.destinations.relativePath | Where-Object { $_ -match '(^|/)(config\.toml|auth\.json|history\.jsonl|logs?|sessions?|databases?)($|/)' })
    Assert-Pass 'schema excludes config and state' ($stateViolations.Count -eq 0)
    $zeroEntry = $artifact.entries | Where-Object { $_.relativePath -eq 'AGENTS.override.md' }
    Assert-Pass 'zero-byte source captured with correct SHA-256' ($zeroEntry.sha256 -eq 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855' -and $zeroEntry.length -eq 0)
    Assert-Pass 'zero-byte content file is empty' ((Get-Item -LiteralPath (Join-Path $baseline 'contents/codex-home/AGENTS.override.md')).Length -eq 0)
    $junctionTarget = Join-Path $scratch 'junction-target'
    $junctionLink = Join-Path $scratch 'junction-link'
    New-Item -ItemType Directory -Path $junctionTarget -Force | Out-Null
    New-Item -ItemType Junction -Path $junctionLink -Target $junctionTarget | Out-Null
    $junctionRejected = $false
    try { & $recipePath -CodexRoot (Join-Path $junctionLink 'codex') -SkillRoot $skills -BaselineRoot (Join-Path $scratch 'junction-baseline') -BaselineSchemaPath $schemaPath -OwnerAuthorized | Out-Null } catch { $junctionRejected = $_.Exception.Message -match 'Reparse point' }
    Assert-Pass 'scratch root under reparse-pointed parent is rejected' $junctionRejected
}
finally { Remove-Item -LiteralPath $scratch -Recurse -Force -ErrorAction SilentlyContinue }
exit $(if ($failed) { 1 } else { 0 })
