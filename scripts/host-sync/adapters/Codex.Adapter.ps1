#Requires -Version 7.0
Set-StrictMode -Version Latest

function Assert-CodexNoReparseAncestor {
    param([Parameter(Mandatory)][string] $Path)

    $full = [IO.Path]::GetFullPath($Path).TrimEnd([char]'\', [char]'/')
    $rootPath = [IO.Path]::GetPathRoot($full)
    $current = $full
    while ($current -and $current.Length -gt $rootPath.Length) {
        if (Test-Path -LiteralPath $current) {
            $item = Get-Item -LiteralPath $current -Force
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw "Reparse point detected in Codex root ancestor chain: $current"
            }
        }
        $parent = [IO.Path]::GetDirectoryName($current)
        if (-not $parent -or $parent -eq $current) { break }
        $current = $parent
    }
}

function Resolve-CodexExplicitRoot {
    param(
        [Parameter(Mandatory)][string] $Path,
        [Parameter(Mandatory)][string] $LogicalRoot
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        throw "Missing explicit $LogicalRoot root. Codex never infers either root."
    }
    $full = [IO.Path]::GetFullPath($Path).TrimEnd([char]'\', [char]'/')
    if (-not (Test-Path -LiteralPath $full -PathType Container)) {
        throw "Explicit $LogicalRoot root does not exist or is not a directory: $full"
    }
    Assert-CodexNoReparseAncestor -Path $full
    return $full
}

function Get-CodexNormalizedRelative {
    param([Parameter(Mandatory)][string] $RelativePath)

    $value = ([string]$RelativePath).Trim().Replace('\', '/')
    if ([string]::IsNullOrWhiteSpace($value)) { throw 'Codex destination relative path is empty.' }
    if ($value -match '^(?:[A-Za-z]:|//|\\{2}|/)' -or $value -match '(^|/)\.\.(/|$)' -or $value -match '[\0]') {
        throw "Codex destination path escapes its logical root or is rooted: '$RelativePath'"
    }
    $segments = @($value -split '/' | Where-Object { $_ -and $_ -ne '.' })
    if ($segments.Count -eq 0) { throw "Codex destination relative path is empty: '$RelativePath'" }
    if ($segments.Count -ne @($value -split '/').Count) {
        throw "Codex destination relative path contains an unexpected empty segment: '$RelativePath'"
    }
    return ($segments -join '/')
}

function Get-CodexRootQualifiedIdentity {
    param(
        [Parameter(Mandatory)][string] $LogicalRoot,
        [Parameter(Mandatory)][string] $RelativePath
    )
    return "$LogicalRoot/$RelativePath"
}

function Assert-CodexPathWithinRoot {
    param(
        [Parameter(Mandatory)][string] $Root,
        [Parameter(Mandatory)][string] $RelativePath,
        [Parameter(Mandatory)][string] $Identity
    )

    $rootFull = [IO.Path]::GetFullPath($Root).TrimEnd([char]'\', [char]'/')
    $candidate = [IO.Path]::GetFullPath((Join-Path $rootFull ($RelativePath.Replace('/', [IO.Path]::DirectorySeparatorChar))))
    $rootPrefix = $rootFull.TrimEnd([char]'\', [char]'/') + [IO.Path]::DirectorySeparatorChar
    if (-not $candidate.StartsWith($rootPrefix, [StringComparison]::OrdinalIgnoreCase) -or $candidate -eq $rootFull) {
        throw "Codex destination path escapes explicit root: $Identity -> $candidate"
    }
    return $candidate
}

function Get-CodexMarkerRegex {
    param(
        [Parameter(Mandatory)][string] $Marker,
        [Parameter(Mandatory)][string] $Kind,
        [string] $Id = ''
    )

    if ($Kind -eq 'begin') {
        return '(?m)^<!--\s*' + [regex]::Escape($Marker) + '\s+id="' + [regex]::Escape($Id) + '"[^\r\n]*begin managed block\s*-->\s*$'
    }
    return '(?m)^<!--\s*' + [regex]::Escape($Marker) + '\s+id="' + [regex]::Escape($Id) + '"[^\r\n]*end managed block\s*-->\s*$'
}

function Assert-CodexPlannedManagedBlock {
    param(
        [Parameter(Mandatory)][string] $Content,
        [Parameter(Mandatory)][string] $Marker,
        [Parameter(Mandatory)][string] $Identity
    )

    $beginMatches = [regex]::Matches($Content, '<!--\s*' + [regex]::Escape($Marker) + '\s+id="(?<id>[^"]+)"[^\r\n]*begin managed block\s*-->')
    $endMatches = [regex]::Matches($Content, '<!--\s*' + [regex]::Escape($Marker) + '\s+id="(?<id>[^"]+)"[^\r\n]*end managed block\s*-->')
    if ($beginMatches.Count -ne 1 -or $endMatches.Count -ne 1) {
        throw "Planned managed AGENTS block must contain exactly one begin and end marker: $Identity"
    }
    $id = $beginMatches[0].Groups['id'].Value
    if ($beginMatches[0].Groups['id'].Value -ne $endMatches[0].Groups['id'].Value -or [string]::IsNullOrWhiteSpace($id)) {
        throw "Planned managed AGENTS block marker ids do not match: $Identity"
    }
    if ($Content.IndexOf($beginMatches[0].Value, [StringComparison]::Ordinal) -ge $Content.IndexOf($endMatches[0].Value, [StringComparison]::Ordinal)) {
        throw "Planned managed AGENTS block markers are reversed: $Identity"
    }
    return $id
}

function ConvertTo-CodexManagedBlockRender {
    param(
        [Parameter(Mandatory)][string] $Current,
        [Parameter(Mandatory)][string] $PlannedBlock,
        [Parameter(Mandatory)][string] $BlockId,
        [Parameter(Mandatory)][string] $Marker,
        [Parameter(Mandatory)][string] $Identity
    )

    $beginRegex = Get-CodexMarkerRegex -Marker $Marker -Kind 'begin' -Id $BlockId
    $endRegex = Get-CodexMarkerRegex -Marker $Marker -Kind 'end' -Id $BlockId
    $begin = [regex]::Match($Current, $beginRegex)
    $end = [regex]::Match($Current, $endRegex)
    if (-not $begin.Success -or -not $end.Success -or $begin.Index -ge $end.Index) {
        throw "Current managed AGENTS block markers are malformed: $Identity"
    }
    if ([regex]::Matches($Current, '<!--\s*' + [regex]::Escape($Marker) + '\s+id="').Count -ne 2) {
        throw "Current AGENTS.md contains extra or malformed managed markers: $Identity"
    }
    return ($Current.Substring(0, $begin.Index) + $PlannedBlock + $Current.Substring($end.Index + $end.Length))
}

function Get-CodexStandaloneMarkerCount {
    param(
        [Parameter(Mandatory)][string] $Content,
        [Parameter(Mandatory)][string] $Marker,
        [Parameter(Mandatory)][string] $Source
    )

    $pattern = '(?m)^(?:<!--|#)\s*' + [regex]::Escape($Marker) + '\s+source="' + [regex]::Escape($Source) + '"\s*(?:;.*)?$'
    return [regex]::Matches($Content, $pattern).Count
}

function Assert-CodexExclusions {
    param(
        [Parameter(Mandatory)][hashtable] $Manifest,
        [Parameter(Mandatory)][string] $Identity
    )

    foreach ($exclusion in @($Manifest.HardExcludes)) {
        $parts = ([string]$exclusion) -split ':', 2
        if ($parts.Count -ne 2 -or [string]::IsNullOrWhiteSpace($parts[0]) -or [string]::IsNullOrWhiteSpace($parts[1])) {
            throw "Invalid Codex hard exclusion (expected logical-root:relative-path): '$exclusion'"
        }
        $exRoot = $parts[0].Trim()
        $exRel = Get-CodexNormalizedRelative -RelativePath $parts[1].Trim()
        $identityRoot = if ($Identity -match '^([^/]+)/') { $Matches[1] } else { '' }
        $identityRel = if ($identityRoot -and $Identity.Length -gt $identityRoot.Length + 1) { $Identity.Substring($identityRoot.Length + 1) } else { '' }
        if ($identityRoot -eq $exRoot -and ($identityRel -eq $exRel -or $identityRel.StartsWith($exRel + '/', [StringComparison]::OrdinalIgnoreCase))) {
            throw "Codex hard-excluded destination planned: $Identity"
        }
    }
}

function New-CodexInstallPlan {
    param(
        [Parameter(Mandatory)][hashtable] $Manifest,
        [Parameter(Mandatory)][string] $CompanionRoot,
        [Parameter(Mandatory)][string] $OverlayRoot,
        [Parameter(Mandatory)][hashtable] $RootMap
    )

    $seen = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $plans = [System.Collections.Generic.List[hashtable]]::new()
    $overlayFull = [IO.Path]::GetFullPath($OverlayRoot).TrimEnd([char]'\', [char]'/')
    foreach ($entry in @($Manifest.DestinationEntries)) {
        if (-not ($entry -is [hashtable])) { throw 'Codex DestinationEntries must contain hashtables.' }
        foreach ($required in @('LogicalRoot', 'Dest', 'Role')) {
            if (-not $entry.ContainsKey($required) -or [string]::IsNullOrWhiteSpace([string]$entry[$required])) {
                throw "Codex destination entry missing required field '$required'."
            }
        }
        $logicalRoot = [string]$entry.LogicalRoot
        if (-not $RootMap.ContainsKey($logicalRoot)) { throw "Unknown Codex logical root: $logicalRoot" }
        $rel = Get-CodexNormalizedRelative -RelativePath ([string]$entry.Dest)
        $identity = Get-CodexRootQualifiedIdentity -LogicalRoot $logicalRoot -RelativePath $rel
        Assert-CodexExclusions -Manifest $Manifest -Identity $identity
        if ($seen.ContainsKey($identity)) {
            throw "Duplicate Codex destination identity: $identity (also $($seen[$identity]))"
        }
        $seen[$identity] = if ($entry.ContainsKey('Source')) { [string]$entry.Source } else { '' }

        $guardOnly = ($entry.ContainsKey('GuardOnly') -and $entry.GuardOnly)
        $sourceRel = ''
        $sourcePath = ''
        $plannedContent = ''
        $plannedHash = '<none>'
        $plannedBytes = $null

        if ($guardOnly) {
            if ($entry.ContainsKey('Source') -and -not [string]::IsNullOrWhiteSpace([string]$entry.Source)) {
                throw "Guard-only Codex destination must not declare a Source: $identity"
            }
        }
        else {
            if (-not $entry.ContainsKey('Source') -or [string]::IsNullOrWhiteSpace([string]$entry.Source)) {
                throw "Non-guard Codex destination missing Source: $identity"
            }
            $sourceRel = [string]$entry.Source
            if ($sourceRel -match '^\s*(?:base|shared):') {
                throw "Codex adapter permits overlay-local sources only: $identity -> $sourceRel"
            }
            $sourcePath = Join-Path $overlayFull ($sourceRel.Replace('/', [IO.Path]::DirectorySeparatorChar))
            $sourceFull = [IO.Path]::GetFullPath($sourcePath)
            $overlayPrefix = $overlayFull + [IO.Path]::DirectorySeparatorChar
            if (-not $sourceFull.StartsWith($overlayPrefix, [StringComparison]::OrdinalIgnoreCase)) {
                throw "Codex overlay source escapes overlay root: $identity -> $sourceFull"
            }
            if (-not (Test-Path -LiteralPath $sourceFull -PathType Leaf)) {
                throw "Codex render source missing: $identity -> $sourceRel"
            }
            $sourceItem = Get-Item -LiteralPath $sourceFull -Force
            if (($sourceItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw "Codex overlay source is a reparse point: $identity -> $sourceFull"
            }
            $raw = [IO.File]::ReadAllText($sourceFull)
            $renderEntry = $entry
            try {
                $resolvedEntry = Resolve-HostSyncEntryRefs -Entry $renderEntry -CompanionRoot $CompanionRoot `
                    -OverlayRoot $overlayFull -SharedRoot 'unused'
                $plannedContent = Invoke-HostSyncRender -Raw $raw -CompanionRoot $CompanionRoot `
                    -ResolvedSourcePath $sourceFull -Entry $resolvedEntry -DestRel $identity `
                    -OverlayRoot $overlayFull -SourceClass 'overlay'
            }
            catch {
                throw "Codex render failed for ${identity}: $($_.Exception.Message)"
            }
            if (Test-ContentHasUnmergedTokens -Content $plannedContent) {
                throw "Unmerged tokens in Codex planned output: $identity"
            }
            $plannedBytes = [Text.UTF8Encoding]::new($false).GetBytes($plannedContent)
            $plannedHash = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($plannedBytes))).ToLowerInvariant()
        }

        $physicalPath = Assert-CodexPathWithinRoot -Root $RootMap[$logicalRoot] -RelativePath $rel -Identity $identity
        $exists = Test-Path -LiteralPath $physicalPath -PathType Leaf
        $directoryExists = Test-Path -LiteralPath $physicalPath -PathType Container
        if ($directoryExists) { throw "Codex destination collision: path is a directory: $identity -> $physicalPath" }
        $item = if ($exists) { Get-Item -LiteralPath $physicalPath -Force } else { $null }
        if (($null -ne $item) -and (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)) {
            throw "Codex destination collision: file is a reparse point: $identity -> $physicalPath"
        }
        $currentBytes = if ($exists) { [IO.File]::ReadAllBytes($physicalPath) } else { $null }
        $currentHash = if ($exists) {
            ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($currentBytes))).ToLowerInvariant()
        } else { '<absent>' }

        [void]$plans.Add(@{
            Identity = $identity
            LogicalRoot = $logicalRoot
            RelativePath = $rel
            PhysicalPath = $physicalPath
            Source = $sourceRel
            Role = [string]$entry.Role
            GuardOnly = $guardOnly
            PlannedContent = $plannedContent
            PlannedBytes = $plannedBytes
            PlannedHash = $plannedHash
            Exists = $exists
            CurrentBytes = $currentBytes
            CurrentHash = $currentHash
            Write = (-not $guardOnly)
            Classification = if (-not $exists) { 'absent' } elseif ($guardOnly) { 'guard' } else { 'owned-or-foreign' }
            Drift = $false
            ManagedBlockId = ''
        })
    }

    foreach ($logicalRoot in @($Manifest.LogicalRoots)) {
        if (-not $RootMap.ContainsKey([string]$logicalRoot)) {
            throw "Manifest logical root has no explicit physical root: $logicalRoot"
        }
    }
    foreach ($logicalRoot in $RootMap.Keys) {
        if (@($Manifest.LogicalRoots) -notcontains $logicalRoot) {
            throw "Explicit root has no manifest logical root: $logicalRoot"
        }
    }
    return $plans
}

function Assert-CodexOwnershipAndOverrides {
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][System.Collections.Generic.List[hashtable]] $Plans,
        [Parameter(Mandatory)][hashtable] $Manifest
    )

    foreach ($plan in $Plans) {
        if ($plan.GuardOnly) {
            if ($plan.Exists -and $plan.CurrentBytes.Length -gt 0) {
                throw "Non-empty Codex guard file blocks Apply before writes: $($plan.Identity)"
            }
            $plan.Classification = if ($plan.Exists) { 'owned-empty-guard' } else { 'absent-guard' }
            continue
        }

        if (-not $plan.Exists) {
            $plan.Classification = 'absent-owned'
            $plan.OutputContent = $plan.PlannedContent
            $plan.OutputBytes = $plan.PlannedBytes
            $plan.OutputHash = $plan.PlannedHash
            if ($plan.Role -eq 'managed-block-target') {
                continue
            }
            continue
        }

        $current = [Text.UTF8Encoding]::new($false, $true).GetString($plan.CurrentBytes)
        if ($plan.Role -eq 'managed-block-target') {
            $id = Assert-CodexPlannedManagedBlock -Content $plan.PlannedContent -Marker $Manifest.ManagedBlockMarker -Identity $plan.Identity
            $beginCount = [regex]::Matches($current, '<!--\s*' + [regex]::Escape($Manifest.ManagedBlockMarker) + '\s+id="').Count
            if ($beginCount -eq 0) {
                throw "Foreign Codex managed block target (missing managed markers): $($plan.Identity)"
            }
            $planOutput = ConvertTo-CodexManagedBlockRender -Current $current -PlannedBlock $plan.PlannedContent `
                -BlockId $id -Marker $Manifest.ManagedBlockMarker -Identity $plan.Identity
            $plan.OutputContent = $planOutput
            $plan.ManagedBlockId = $id
            $plan.Classification = 'owned-managed-block'
        }
        else {
            $source = ($Manifest.OverlayRelativeRoot + '/' + $plan.Source) -replace '\\', '/'
            $count = Get-CodexStandaloneMarkerCount -Content $current -Marker $Manifest.OwnershipMarker -Source $source
            if ($count -ne 1) {
                throw "Foreign or malformed Codex destination ownership marker ($count expected-source matches): $($plan.Identity)"
            }
            $plan.OutputContent = $plan.PlannedContent
            $plan.Classification = 'owned-standalone'
        }

        if (Test-ContentHasUnmergedTokens -Content $plan.OutputContent) {
            throw "Unmerged tokens after Codex ownership render: $($plan.Identity)"
        }
        $outputBytes = [Text.UTF8Encoding]::new($false).GetBytes([string]$plan.OutputContent)
        $plan.OutputBytes = $outputBytes
        $plan.OutputHash = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($outputBytes))).ToLowerInvariant()
        if ($plan.CurrentHash -ne $plan.OutputHash) {
            $plan.Drift = $true
        }
    }
}

function Add-CodexPlanReportRows {
    param(
        [Parameter(Mandatory)][hashtable] $Report,
        [Parameter(Mandatory)][AllowEmptyCollection()][System.Collections.Generic.List[hashtable]] $Plans
    )

    foreach ($plan in $Plans) {
        [void]$Report.Destinations.Add($plan.Identity)
        $Report.CurrentState[$plan.Identity] = @{
            Exists = $plan.Exists
            Hash = $plan.CurrentHash
            Classification = $plan.Classification
        }
        if ($plan.GuardOnly) {
            [void]$Report.Verifications.Add("guard preflight passed: $($plan.Identity) ($($plan.CurrentHash))")
            continue
        }
        if ($plan.Drift) {
            Add-SyncWarning -Report $Report -Message "owned current-state drift selected for planned update: $($plan.Identity)"
        }
        if (-not $Report.PlannedContent.ContainsKey($plan.Identity)) {
            $Report.PlannedContent[$plan.Identity] = $plan.PlannedContent
            $Report.PlannedClasses[$plan.Identity] = 'overlay'
        }
        $sourceText = if ($plan.Source) { $plan.Source } else { '<managed-block>' }
        [void]$Report.PlannedFiles.Add("$($plan.Identity) <= $sourceText (current-hash=$($plan.CurrentHash))")
    }
}

function New-CodexDirectory {
    param(
        [Parameter(Mandatory)][string] $Path,
        [System.Collections.Generic.List[string]] $CreatedDirectories
    )

    if (Test-Path -LiteralPath $Path) { return }
    $ancestors = [System.Collections.Generic.List[string]]::new()
    $current = $Path
    while (-not (Test-Path -LiteralPath $current)) {
        [void]$ancestors.Add($current)
        $parent = [IO.Path]::GetDirectoryName($current)
        if (-not $parent -or $parent -eq $current) { break }
        $current = $parent
    }
    foreach ($directory in @($ancestors)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }
    foreach ($directory in @($ancestors)) {
        if (Test-Path -LiteralPath $directory) { [void]$CreatedDirectories.Add($directory) }
    }
}

function Invoke-CodexRollback {
    param(
        [Parameter(Mandatory)][hashtable] $RunState,
        [Parameter(Mandatory)][string] $Reason
    )

    foreach ($temp in $RunState.TempFiles) {
        if (Test-Path -LiteralPath $temp) { [IO.File]::Delete($temp) }
    }
    foreach ($identity in $RunState.CreatedFiles) {
        $path = $RunState.Paths[$identity]
        if (Test-Path -LiteralPath $path -PathType Leaf) { [IO.File]::Delete($path) }
    }
    foreach ($identity in @($RunState.Originals.Keys)) {
        [IO.File]::WriteAllBytes($RunState.Paths[$identity], $RunState.Originals[$identity])
    }
    foreach ($directory in $RunState.CreatedDirectories) {
        if (Test-Path -LiteralPath $directory -PathType Container) {
            $children = Get-ChildItem -LiteralPath $directory -Force
            if (@($children).Count -eq 0) { [IO.Directory]::Delete($directory, $false) }
        }
    }
    return "Codex adapter-local rollback complete: $Reason"
}

function Invoke-CodexWritePass {
    param(
        [Parameter(Mandatory)][hashtable] $Report,
        [Parameter(Mandatory)][AllowEmptyCollection()][System.Collections.Generic.List[hashtable]] $Plans,
        [int] $FailAfterWrites = -1,
        [string] $FailureMessage = 'injected Codex late-write failure'
    )

    $runState = @{
        Originals = [System.Collections.Generic.Dictionary[string, byte[]]]::new()
        CreatedFiles = [System.Collections.Generic.List[string]]::new()
        CreatedDirectories = [System.Collections.Generic.List[string]]::new()
        TempFiles = [System.Collections.Generic.List[string]]::new()
        Paths = @{}
        WriteCount = 0
    }
    foreach ($plan in $Plans) { $runState.Paths[$plan.Identity] = $plan.PhysicalPath }

    try {
        foreach ($plan in $Plans) {
            if ($FailAfterWrites -ge 0 -and $runState.WriteCount -ge $FailAfterWrites) {
                throw $FailureMessage
            }
            if (-not $plan.Write) { continue }

            $currentHash = if ($plan.Exists) {
                ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([IO.File]::ReadAllBytes($plan.PhysicalPath)))).ToLowerInvariant()
            } else { '<absent>' }
            if ($currentHash -ne $plan.CurrentHash) {
                throw "Codex current-state hash changed after preflight: $($plan.Identity) ($($plan.CurrentHash) -> $currentHash)"
            }

            New-CodexDirectory -Path ([IO.Path]::GetDirectoryName($plan.PhysicalPath)) -CreatedDirectories $runState.CreatedDirectories
            $temp = Join-Path ([IO.Path]::GetDirectoryName($plan.PhysicalPath)) ('.' + [IO.Path]::GetFileName($plan.PhysicalPath) + '.hostsync-' + [Guid]::NewGuid().ToString('N') + '.tmp')
            [void]$runState.TempFiles.Add($temp)
            [IO.File]::WriteAllBytes($temp, [byte[]]$plan.OutputBytes)

            if ($plan.Exists) {
                if (-not $runState.Originals.ContainsKey($plan.Identity)) {
                    $runState.Originals[$plan.Identity] = $plan.CurrentBytes
                }
            }
            else {
                [void]$runState.CreatedFiles.Add($plan.Identity)
            }
            [IO.File]::Move($temp, $plan.PhysicalPath, $true)
            [void]$runState.TempFiles.Remove($temp)
            $runState.WriteCount++

            $writtenHash = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([IO.File]::ReadAllBytes($plan.PhysicalPath)))).ToLowerInvariant()
            if ($writtenHash -ne $plan.OutputHash) {
                throw "Codex staged write hash mismatch: $($plan.Identity)"
            }
        }

        if ($FailAfterWrites -eq $runState.WriteCount -and $FailAfterWrites -ge 0) {
            throw $FailureMessage
        }

        foreach ($plan in $Plans) {
            if ($plan.GuardOnly) {
                $guardHash = if ($plan.Exists) {
                    ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([IO.File]::ReadAllBytes($plan.PhysicalPath)))).ToLowerInvariant()
                } else { '<absent>' }
                if ($guardHash -ne $plan.CurrentHash) { throw "Codex guard changed during write pass: $($plan.Identity)" }
                continue
            }
            $finalHash = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([IO.File]::ReadAllBytes($plan.PhysicalPath)))).ToLowerInvariant()
            if ($finalHash -ne $plan.OutputHash) { throw "Codex post-write hash mismatch: $($plan.Identity)" }
            [void]$Report.Verifications.Add("planned-hash verified: $($plan.Identity)=$finalHash")
        }
    }
    catch {
        $reason = $_.Exception.Message
        $rollbackMessage = Invoke-CodexRollback -RunState $runState -Reason $reason
        Add-SyncError -Report $Report -Message $reason
        [void]$Report.Verifications.Add($rollbackMessage)
        return $false
    }
    return $true
}

function Invoke-StackHarnessSync {
    param(
        [Parameter(Mandatory)]
        [HostSyncMode] $Mode,
        [Parameter(Mandatory)]
        [string] $CompanionRoot,
        [Parameter(Mandatory)]
        [hashtable] $Manifest,
        [Parameter(Mandatory)]
        [string] $CodexRoot,
        [Parameter(Mandatory)]
        [string] $SkillRoot,
        [int] $FailAfterWrites = -1,
        [string] $FailureMessage = 'injected Codex late-write failure'
    )

    $report = New-HostSyncReport -StackId $Manifest.StackId -Mode $Mode
    $report.Roots = @{}
    $report.Destinations = [System.Collections.Generic.List[string]]::new()
    $report.CurrentState = @{}

    try {
        foreach ($required in @('StackId', 'OverlayRelativeRoot', 'LogicalRoots', 'DestinationEntries', 'OwnershipMarker', 'ManagedBlockMarker', 'HardExcludes')) {
            if (-not $Manifest.ContainsKey($required)) { throw "Codex manifest missing required key: $required" }
        }
        $companion = [IO.Path]::GetFullPath($CompanionRoot).TrimEnd([char]'\', [char]'/')
        $overlay = [IO.Path]::GetFullPath((Join-Path $companion ([string]$Manifest.OverlayRelativeRoot))).TrimEnd([char]'\', [char]'/')
        $companionPrefix = $companion + [IO.Path]::DirectorySeparatorChar
        if (-not $overlay.StartsWith($companionPrefix, [StringComparison]::OrdinalIgnoreCase)) {
            throw "Codex overlay root escapes companion root: $overlay"
        }
        if (-not (Test-Path -LiteralPath $overlay -PathType Container)) { throw "Codex overlay root missing: $overlay" }
        Assert-CodexNoReparseAncestor -Path $overlay

        $codexFull = Resolve-CodexExplicitRoot -Path $CodexRoot -LogicalRoot 'codex-home'
        $skillFull = Resolve-CodexExplicitRoot -Path $SkillRoot -LogicalRoot 'skill-root'
        $codexPrefix = $codexFull.TrimEnd([char]'\', [char]'/') + [IO.Path]::DirectorySeparatorChar
        $skillPrefix = $skillFull.TrimEnd([char]'\', [char]'/') + [IO.Path]::DirectorySeparatorChar
        if ($codexFull -eq $skillFull -or $codexPrefix.StartsWith($skillPrefix, [StringComparison]::OrdinalIgnoreCase) -or $skillPrefix.StartsWith($codexPrefix, [StringComparison]::OrdinalIgnoreCase)) {
            throw 'Explicit codex-home and skill-root must be independent, non-nested roots.'
        }
        $report.Roots['codex-home'] = $codexFull
        $report.Roots['skill-root'] = $skillFull

        $plans = New-CodexInstallPlan -Manifest $Manifest -CompanionRoot $companion -OverlayRoot $overlay -RootMap @{
            'codex-home' = $codexFull
            'skill-root' = $skillFull
        }
        Assert-CodexOwnershipAndOverrides -Plans $plans -Manifest $Manifest
        Add-CodexPlanReportRows -Report $report -Plans $plans

        if ($Mode -eq [HostSyncMode]::DryRun) {
            [void]$report.Verifications.Add('dry-run completed without creating directories or files')
            return $report
        }

        $ok = Invoke-CodexWritePass -Report $report -Plans $plans -FailAfterWrites $FailAfterWrites -FailureMessage $FailureMessage
        if (-not $ok) { return $report }

        foreach ($plan in @($plans | Where-Object { -not $_.GuardOnly })) {
            [void]$report.AppliedFiles.Add($plan.Identity)
        }
        [void]$report.Verifications.Add("current-state hash binding completed for $($plans.Count) destinations")
        return $report
    }
    catch {
        Add-SyncError -Report $report -Message $_.Exception.Message
        return $report
    }
}
