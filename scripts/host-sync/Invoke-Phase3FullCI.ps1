#Requires -Version 7.0
<#
.SYNOPSIS
  Phase 3 Full CI — doc wiring, registry targets, entry help, nested Phase 1/2 closeout checks.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$companionRoot = 'C:\Users\admin\source\repos\general-projects\cursorEscape'
$syncScript = Join-Path $companionRoot 'scripts\Sync-HostHarness.ps1'
$hostSyncRoot = Join-Path $companionRoot 'scripts\host-sync'
$hostSyncReadme = Join-Path $hostSyncRoot 'README.md'

$fail = $false

function Assert-Pass {
    param([string]$Name, [bool]$Ok)
    $status = if ($Ok) { 'pass' } else { 'fail' }
    Write-Output "${Name}: $status"
    if (-not $Ok) { $script:fail = $true }
}

function Read-RepoFile {
    param([string]$RelPath)
    return Get-Content -LiteralPath (Join-Path $companionRoot $RelPath) -Raw
}

# Fast CI re-run
& pwsh -NoProfile -File $syncScript -Target All 2>&1 | Out-Null
Assert-Pass 'dry-run All exit 0' ($LASTEXITCODE -eq 0)

$invalidOutput = & pwsh -NoProfile -File $syncScript -Target Foo 2>&1 | Out-String
Assert-Pass 'invalid Target lists registry stacks' ($invalidOutput -match 'Valid: .*All')

$entrySource = Read-RepoFile 'scripts\Sync-HostHarness.ps1'
Assert-Pass 'entry uses Get-RegisteredStackIds' ($entrySource -match 'Get-RegisteredStackIds')
Assert-Pass 'entry documents registry stacks in comment help' ($entrySource -match 'Registry stacks: Cursor, OpenCode')
Assert-Pass 'entry documents hard excludes in NOTES' ($entrySource -match 'Hard excludes \(manifest-owned\)')
Assert-Pass 'entry states sync does not backup' ($entrySource -match 'does NOT create backups')

Assert-Pass 'host-sync README exists' (Test-Path -LiteralPath $hostSyncReadme)
$hostSyncReadmeText = Get-Content -LiteralPath $hostSyncReadme -Raw
Assert-Pass 'expansion recipe present' ($hostSyncReadmeText -match 'Expansion recipe')
Assert-Pass 'README states sync does not backup' ($hostSyncReadmeText -match 'sync does not create backup')

$cursorSop = Read-RepoFile 'docs\SOPs\cursor-host-adapter.md'
$opencodeSop = Read-RepoFile 'docs\SOPs\opencode-host-adapter.md'
$editWorkflow = Read-RepoFile 'docs\SOPs\editing-companion-workflow.md'

Assert-Pass 'cursor-host-adapter cites Sync-HostHarness' ($cursorSop -match 'Sync-HostHarness\.ps1')
Assert-Pass 'cursor-host-adapter Phase 0 baseline path' ($cursorSop -match 'pre-host-sync-build-20260821-012600')
Assert-Pass 'cursor-host-adapter sync does not backup' ($cursorSop -match 'does not create backups')

Assert-Pass 'opencode-host-adapter cites Sync-HostHarness' ($opencodeSop -match 'Sync-HostHarness\.ps1')
Assert-Pass 'opencode-host-adapter Phase 0 baseline path' ($opencodeSop -match 'pre-host-sync-build-20260821-012600')
Assert-Pass 'opencode-host-adapter sync does not backup' ($opencodeSop -match 'does not create backups')

Assert-Pass 'editing-companion-workflow Cursor Apply row' ($editWorkflow -match 'Sync-HostHarness\.ps1 -Apply -Target Cursor')
Assert-Pass 'editing-companion-workflow OpenCode Apply row' ($editWorkflow -match 'Sync-HostHarness\.ps1 -Apply -Target OpenCode')
Assert-Pass 'editing-companion-workflow no backup first' ($editWorkflow -notmatch 'backup first')

$roadmap = Read-RepoFile 'docs\roadmaps\host-harness-sync-build.md'
Assert-Pass 'roadmap Phase 3 checklist complete' ($roadmap -match '\[x\] \*\*Phase 3\*\*')

# Nested prior-phase closeout (entry help assertion updated in Phase 1 Full CI)
& pwsh -NoProfile -File (Join-Path $hostSyncRoot 'Invoke-Phase1FullCI.ps1')
Assert-Pass 'Phase1 Full CI nested pass' ($LASTEXITCODE -eq 0)

exit $(if ($fail) { 1 } else { 0 })
