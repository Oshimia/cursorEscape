#Requires -Version 7.4
<#.SYNOPSIS Narrow fail-closed helpers for local-scratch CI safety.#>
Set-StrictMode -Version Latest

function Get-LocalScratchPathComparison {
    if ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Windows)) {
        return [StringComparison]::OrdinalIgnoreCase
    }
    return [StringComparison]::Ordinal
}

function Test-LocalScratchArtifactPath {
    <#
      Executes the plan_reviewer artifact-path predicate without following
      reparse points. It inspects path metadata only until every component has
      passed boundary and reparse checks, then checks the real plan file.
    #>
    param(
        [Parameter(Mandatory)][string] $RepositoryPath,
        [AllowEmptyString()][AllowNull()][string] $CandidatePath
    )

    function New-Result([bool]$Accepted, [string]$Reason) {
        [pscustomobject]@{ Accepted = $Accepted; Reason = $Reason }
    }

    if ([string]::IsNullOrWhiteSpace($CandidatePath)) { return New-Result $false 'EmptyPath' }
    if (-not [IO.Path]::IsPathRooted($CandidatePath)) { return New-Result $false 'RelativePath' }

    $repositoryFull = [IO.Path]::GetFullPath($RepositoryPath).TrimEnd([char]'\', [char]'/')
    $candidateFull = [IO.Path]::GetFullPath($CandidatePath)
    $comparison = Get-LocalScratchPathComparison
    $repositoryPrefix = $repositoryFull + [IO.Path]::DirectorySeparatorChar
    if (-not $candidateFull.StartsWith($repositoryPrefix, $comparison)) { return New-Result $false 'OutsideWorkspace' }

    $plansRoot = [IO.Path]::GetFullPath((Join-Path $repositoryFull '.scratch/plans'))
    $plansPrefix = $plansRoot.TrimEnd([char]'\', [char]'/') + [IO.Path]::DirectorySeparatorChar
    if (-not $candidateFull.StartsWith($plansPrefix, $comparison)) { return New-Result $false 'OutsidePlansBoundary' }

    $relative = $candidateFull.Substring($repositoryPrefix.Length)
    $segments = @($relative -split '[\\/]' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    $probe = $repositoryFull
    foreach ($segment in $segments) {
        $probe = Join-Path $probe $segment
        if (-not ([IO.Directory]::Exists($probe) -or [IO.File]::Exists($probe))) {
            return New-Result $false 'ArtifactAbsent'
        }
        $item = Get-Item -LiteralPath $probe -Force -ErrorAction Stop
        if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            return New-Result $false 'ReparsePoint'
        }
    }

    $file = [IO.FileInfo]::new($candidateFull)
    if (-not $file.Exists) { return New-Result $false 'ArtifactAbsent' }
    if ($file.Length -le 0) { return New-Result $false 'EmptyArtifact' }
    $stream = $null
    try {
        $stream = [IO.File]::Open($candidateFull, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    }
    catch {
        return New-Result $false 'UnreadableArtifact'
    }
    finally {
        if ($null -ne $stream) { $stream.Dispose() }
    }
    return New-Result $true 'ValidArtifact'
}

function Get-GovernedRepositoryFiles {
    <# Enumerates repository file metadata while omitting .git and .scratch
       before descending. It never opens file contents. #>
    param([Parameter(Mandatory)][string] $RepositoryRoot)

    $rootFull = [IO.Path]::GetFullPath((Resolve-Path -LiteralPath $RepositoryRoot -ErrorAction Stop).ProviderPath)
    $comparison = Get-LocalScratchPathComparison
    $excluded = @(
        [IO.Path]::GetFullPath((Join-Path $rootFull '.git')),
        [IO.Path]::GetFullPath((Join-Path $rootFull '.scratch'))
    )
    $files = [System.Collections.Generic.List[IO.FileInfo]]::new()
    $pending = [System.Collections.Generic.Queue[string]]::new()
    $pending.Enqueue($rootFull)
    while ($pending.Count -gt 0) {
        $current = $pending.Dequeue()
        foreach ($directory in [IO.Directory]::EnumerateDirectories($current)) {
            $directoryFull = [IO.Path]::GetFullPath($directory)
            if (@($excluded | Where-Object { $directoryFull.Equals($_, $comparison) }).Count -gt 0) { continue }
            $pending.Enqueue($directoryFull)
        }
        foreach ($file in [IO.Directory]::EnumerateFiles($current)) {
            $files.Add([IO.FileInfo]::new($file))
        }
    }
    return $files
}

Export-ModuleMember -Function @('Test-LocalScratchArtifactPath', 'Get-GovernedRepositoryFiles')
