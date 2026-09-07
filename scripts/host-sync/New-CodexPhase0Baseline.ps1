#Requires -Version 7.0
<#
.SYNOPSIS
  Creates a narrowly scoped, restore-only Codex Phase 0 baseline after owner authorization.

.DESCRIPTION
  This is deliberately not part of Sync-HostHarness and must never be invoked by CI.
  It reads only the future Codex destinations enumerated in the checked-in schema,
  writes a new baseline artifact at the caller-supplied destination, and never edits
  either source root. The original baseline is initial-install provenance only; later
  Applies use owned current state and pre-Apply hashes, never baseline equality.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $CodexRoot,

    [Parameter(Mandatory)]
    [string] $SkillRoot,

    [Parameter(Mandatory)]
    [string] $BaselineRoot,

    [Parameter()]
    [string] $BaselineSchemaPath = (Join-Path $PSScriptRoot 'baselines/codex-phase0-baseline-schema-2026-09.json'),

    [switch] $OwnerAuthorized
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Resolve-AbsolutePath {
    param([Parameter(Mandatory)][string] $Path)
    return [IO.Path]::GetFullPath($Path).TrimEnd([char]'\', [char]'/')
}

function Test-PathWithin {
    param(
        [Parameter(Mandatory)][string] $Child,
        [Parameter(Mandatory)][string] $Parent
    )
    $childFull = (Resolve-AbsolutePath $Child) + [IO.Path]::DirectorySeparatorChar
    $parentFull = (Resolve-AbsolutePath $Parent) + [IO.Path]::DirectorySeparatorChar
    return $childFull.StartsWith($parentFull, [StringComparison]::OrdinalIgnoreCase)
}

function Get-Sha256 {
    param([Parameter(Mandatory)][AllowEmptyCollection()][byte[]] $Bytes)
    return ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($Bytes))).ToLowerInvariant()
}

function Assert-NoReparseComponent {
    param(
        [Parameter(Mandatory)][string] $Root,
        [Parameter(Mandatory)][string] $Target
    )
    $rootFull = Resolve-AbsolutePath $Root
    $targetFull = Resolve-AbsolutePath $Target
    if (-not (Test-PathWithin $targetFull $rootFull)) {
        throw "Resolved target escaped its declared root: $targetFull"
    }
    if (Test-Path -LiteralPath $rootFull) {
        $rootItem = Get-Item -LiteralPath $rootFull -Force
        if ($rootItem.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            throw "Source root is a reparse point: $rootFull"
        }
    }
    $relative = if ($targetFull.Length -gt $rootFull.Length) { $targetFull.Substring($rootFull.Length).TrimStart([char]'\', [char]'/') } else { '' }
    $segments = @($relative -split '[\\/]' | Where-Object { $_ })
    $current = $rootFull
    foreach ($segment in $segments) {
        $current = Join-Path $current $segment
        if (Test-Path -LiteralPath $current) {
            $item = Get-Item -LiteralPath $current -Force
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                throw "Reparse point detected in path component: $current"
            }
        }
    }
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

if (-not $OwnerAuthorized) {
    throw 'Owner authorization required: this recipe can capture user-home baseline bytes only after explicit approval.'
}

$codexRootFull = Resolve-AbsolutePath $CodexRoot
$skillRootFull = Resolve-AbsolutePath $SkillRoot
$baselineRootFull = Resolve-AbsolutePath $BaselineRoot
$realCodexRoot = Resolve-AbsolutePath (Join-Path $env:USERPROFILE '.codex')
$realSkillRoot = Resolve-AbsolutePath (Join-Path $env:USERPROFILE '.agents/skills')

Assert-NoReparseComponent -Root $codexRootFull -Target $codexRootFull
Assert-NoReparseComponent -Root $skillRootFull -Target $skillRootFull
Assert-NoReparseAncestor -Path $codexRootFull
Assert-NoReparseAncestor -Path $skillRootFull
Assert-NoReparseAncestor -Path $baselineRootFull

if ($codexRootFull -eq $skillRootFull -or (Test-PathWithin $codexRootFull $skillRootFull) -or (Test-PathWithin $skillRootFull $codexRootFull)) {
    throw 'CodexRoot and SkillRoot must be distinct, non-nested roots.'
}
if ((Test-PathWithin $baselineRootFull $codexRootFull) -or (Test-PathWithin $baselineRootFull $skillRootFull)) {
    throw 'BaselineRoot must not be inside either source root.'
}
if (Test-Path -LiteralPath $baselineRootFull) {
    throw "BaselineRoot already exists; refusing to overwrite baseline provenance: $baselineRootFull"
}
if (-not (Test-Path -LiteralPath $BaselineSchemaPath -PathType Leaf)) {
    throw "Baseline schema missing: $BaselineSchemaPath"
}

$schema = Get-Content -LiteralPath $BaselineSchemaPath -Raw | ConvertFrom-Json -AsHashtable
if ($schema.schemaVersion -ne 1 -or @($schema.destinations).Count -lt 1) {
    throw 'Baseline schema is invalid: expected schemaVersion 1 with destination entries.'
}

New-Item -ItemType Directory -Path $baselineRootFull -ErrorAction Stop | Out-Null
try {
    $records = [System.Collections.Generic.List[hashtable]]::new()

    foreach ($destination in @($schema.destinations)) {
        $logicalRoot = [string]$destination.logicalRoot
        $relativePath = [string]$destination.relativePath
        if ($logicalRoot -notin @('codex-home', 'skill-root') -or [string]::IsNullOrWhiteSpace($relativePath)) {
            throw 'Baseline schema contains an invalid destination identity.'
        }
        if ([IO.Path]::IsPathRooted($relativePath) -or $relativePath -match '(^|[\\/])\.\.([\\/]|$)') {
            throw "Baseline schema destination escapes its logical root: $relativePath"
        }

        $sourceRoot = if ($logicalRoot -eq 'codex-home') { $codexRootFull } else { $skillRootFull }
        $sourcePath = Join-Path $sourceRoot ($relativePath -replace '/', [IO.Path]::DirectorySeparatorChar)
        if (-not (Test-PathWithin $sourcePath $sourceRoot)) {
            throw "Resolved source escaped its logical root: $sourcePath"
        }
        Assert-NoReparseComponent -Root $sourceRoot -Target $sourcePath

        $record = [ordered]@{
            logicalRoot = $logicalRoot
            relativePath = $relativePath
            role = [string]$destination.role
            present = (Test-Path -LiteralPath $sourcePath -PathType Leaf)
            length = $null
            sha256 = $null
            contentPath = $null
        }
        if ($record.present) {
            # Read the source bytes exactly once so length and hash always describe
            # the same snapshot that is persisted into the baseline.
            $sourceBytes = [IO.File]::ReadAllBytes($sourcePath)
            $contentPath = Join-Path $baselineRootFull (Join-Path 'contents' (Join-Path $logicalRoot $relativePath))
            $contentParent = Split-Path -Parent $contentPath
            New-Item -ItemType Directory -Path $contentParent -Force | Out-Null
            [IO.File]::WriteAllBytes($contentPath, $sourceBytes)
            $record.length = $sourceBytes.LongLength
            $record.sha256 = Get-Sha256 $sourceBytes
            $record.contentPath = ('contents/{0}/{1}' -f $logicalRoot, $relativePath.Replace('\\', '/'))
        }
        [void]$records.Add($record)
    }

    $artifact = [ordered]@{
        schemaVersion = 1
        kind = 'codex-phase0-initial-baseline'
        createdUtc = [DateTime]::UtcNow.ToString('o')
        sourceRoots = [ordered]@{
            codexHome = $codexRootFull
            skillRoot = $skillRootFull
            realProfileRoots = [ordered]@{
                codexHome = ($codexRootFull -eq $realCodexRoot)
                skillRoot = ($skillRootFull -eq $realSkillRoot)
            }
        }
        semantics = 'restore-only provenance for initial install; later Applies use owned current state and pre-Apply hashes, never original-baseline equality or automatic restoration'
        entries = @($records)
    }
    [IO.File]::WriteAllText((Join-Path $baselineRootFull 'codex-phase0-baseline.json'), ($artifact | ConvertTo-Json -Depth 8), [Text.UTF8Encoding]::new($false))
}
catch {
    Remove-Item -LiteralPath $baselineRootFull -Recurse -Force -ErrorAction SilentlyContinue
    throw
}
Write-Output "baseline created: $baselineRootFull"
