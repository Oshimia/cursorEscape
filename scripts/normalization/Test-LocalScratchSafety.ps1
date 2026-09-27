#Requires -Version 7.4
<#.SYNOPSIS Focused fail-closed matrix for local-scratch path and scan safety.#>
param([string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'LocalScratch.psm1') -Force

$failures = [System.Collections.Generic.List[string]]::new()
function Assert-True([string]$Name, [bool]$Condition, [string]$Detail = '') {
    if ($Condition) { Write-Output "pass: $Name" }
    else { $script:failures.Add("$Name $Detail") }
}

function New-FixtureRepository {
    $root = Join-Path ([IO.Path]::GetTempPath()) ('local-scratch-safety-' + [Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path (Join-Path $root '.scratch/plans') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $root '.git/objects') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $root 'docs') -Force | Out-Null
    [IO.File]::WriteAllText((Join-Path $root '.git/objects/probe'), 'repository metadata probe')
    [IO.File]::WriteAllText((Join-Path $root '.scratch/plans/valid.md'), 'approved plan artifact')
    [IO.File]::WriteAllText((Join-Path $root '.scratch/plans/empty.md'), '')
    [IO.File]::WriteAllText((Join-Path $root 'docs/governed.md'), 'governed repository file')
    return $root
}

$fixture = New-FixtureRepository
$outside = Join-Path ([IO.Path]::GetTempPath()) ('outside-local-scratch-' + [Guid]::NewGuid().ToString('N'))
$insideJunction = Join-Path $fixture '.scratch/plans/redirected-plans'
$boundaryPlans = Join-Path $fixture '.scratch/plans'
try {
    New-Item -ItemType Directory -Path $outside -Force | Out-Null
    $outsidePlan = Join-Path $outside 'plan.md'
    [IO.File]::WriteAllText($outsidePlan, 'outside repository')

    $cases = @(
        @{ Name = 'absent artifact'; Path = (Join-Path $fixture '.scratch/plans/absent.md'); Accepted = $false; Reason = 'ArtifactAbsent' }
        @{ Name = 'empty candidate'; Path = ''; Accepted = $false; Reason = 'EmptyPath' }
        @{ Name = 'relative candidate'; Path = '.scratch/plans/valid.md'; Accepted = $false; Reason = 'RelativePath' }
        @{ Name = 'empty artifact'; Path = (Join-Path $fixture '.scratch/plans/empty.md'); Accepted = $false; Reason = 'EmptyArtifact' }
        @{ Name = 'outside workspace'; Path = $outsidePlan; Accepted = $false; Reason = 'OutsideWorkspace' }
        @{ Name = 'outside scratch plans'; Path = (Join-Path $fixture 'docs/governed.md'); Accepted = $false; Reason = 'OutsidePlansBoundary' }
        @{ Name = 'traversal escape'; Path = (Join-Path $fixture '.scratch/plans/../docs/governed.md'); Accepted = $false; Reason = 'OutsidePlansBoundary' }
    )
    foreach ($case in $cases) {
        $result = Test-LocalScratchArtifactPath -RepositoryPath $fixture -CandidatePath $case.Path
        Assert-True "path matrix: $($case.Name)" (
            -not $result.Accepted -and $result.Reason -eq $case.Reason
        ) "observed=$($result.Accepted):$($result.Reason)"
    }

    $valid = Test-LocalScratchArtifactPath -RepositoryPath $fixture -CandidatePath (Join-Path $fixture '.scratch/plans/valid.md')
    Assert-True 'path matrix: valid artifact' ($valid.Accepted -and $valid.Reason -eq 'ValidArtifact') "observed=$($valid.Reason)"

    # A junction is executable without administrator symlink privileges. Put it
    # at the plans boundary to prove every ancestor component is inspected.
    $realPlans = Join-Path $fixture '.scratch/plans-real'
    Move-Item -LiteralPath $boundaryPlans -Destination $realPlans
    New-Item -ItemType Junction -Path $boundaryPlans -Target $realPlans | Out-Null
    $boundaryReparse = Test-LocalScratchArtifactPath -RepositoryPath $fixture -CandidatePath (Join-Path $fixture '.scratch/plans/valid.md')
    Assert-True 'path matrix: boundary reparse point rejected' (
        -not $boundaryReparse.Accepted -and $boundaryReparse.Reason -eq 'ReparsePoint'
    ) "observed=$($boundaryReparse.Reason)"

    # Replace the boundary junction with a real plans directory, then prove a
    # reparse component beneath it is rejected before its redirected target is read.
    Remove-Item -LiteralPath $boundaryPlans -Force
    New-Item -ItemType Directory -Path $boundaryPlans -Force | Out-Null
    $outsideTarget = Join-Path $outside 'redirected'
    New-Item -ItemType Directory -Path $outsideTarget -Force | Out-Null
    [IO.File]::WriteAllText((Join-Path $outsideTarget 'redirected.md'), 'must not be read')
    New-Item -ItemType Junction -Path $insideJunction -Target $outsideTarget | Out-Null
    $insideReparse = Test-LocalScratchArtifactPath -RepositoryPath $fixture -CandidatePath (Join-Path $insideJunction 'redirected.md')
    Assert-True 'path matrix: reparse component inside boundary rejected' (
        -not $insideReparse.Accepted -and $insideReparse.Reason -eq 'ReparsePoint'
    ) "observed=$($insideReparse.Reason)"

    # Two scratch variants with different content must yield the same governed
    # file list, proving content is not read. The non-scratch file must remain.
    $scratchProbe = Join-Path $fixture '.scratch/probe.md'
    [IO.File]::WriteAllText($scratchProbe, 'scratch variant one')
    $filesOne = @(Get-GovernedRepositoryFiles -RepositoryRoot $fixture | ForEach-Object { $_.FullName })
    [IO.File]::WriteAllText($scratchProbe, 'scratch variant two')
    $filesTwo = @(Get-GovernedRepositoryFiles -RepositoryRoot $fixture | ForEach-Object { $_.FullName })
    Assert-True 'scan exclusion: scratch content does not affect result' (($filesOne -join '|') -eq ($filesTwo -join '|'))
    Assert-True 'scan exclusion: scratch omitted before return' (@($filesOne | Where-Object { $_ -like (Join-Path $fixture '.scratch*') }).Count -eq 0)
    Assert-True 'scan exclusion: governed file retained' (@($filesOne | Where-Object { $_ -eq (Join-Path $fixture 'docs/governed.md') }).Count -eq 1)
    Assert-True 'scan exclusion: git omitted' (@($filesOne | Where-Object { $_ -like (Join-Path $fixture '.git*') }).Count -eq 0)
    Assert-True 'scan exclusion: git probe absent from result' (@($filesOne | Where-Object { $_ -eq (Join-Path $fixture '.git/objects/probe') }).Count -eq 0)
}
finally {
    # Remove known disposable junction links before recursive fixture cleanup.
    foreach ($link in @($insideJunction, $boundaryPlans)) {
        if (Test-Path -LiteralPath $link) {
            $item = Get-Item -LiteralPath $link -Force
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                Remove-Item -LiteralPath $link -Force
            }
        }
    }
    if (Test-Path -LiteralPath $fixture) { Remove-Item -LiteralPath $fixture -Recurse -Force }
    if (Test-Path -LiteralPath $outside) { Remove-Item -LiteralPath $outside -Recurse -Force }
}

if ($failures.Count -gt 0) {
    Write-Output "FAIL: $($failures.Count) local-scratch safety case(s)"
    $failures | ForEach-Object { Write-Output "  - $_" }
    exit 1
}
Write-Output 'local-scratch safety matrix: PASS'
