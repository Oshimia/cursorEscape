#Requires -Version 7.0
<#
.SYNOPSIS
  Phase 2 Full CI — Apply OpenCode, post-verify AGENTS/instructions + model/provider; C6 footer.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$companionRoot = 'C:\Users\admin\source\repos\general-projects\cursorEscape'
$syncScript = Join-Path $companionRoot 'scripts\Sync-HostHarness.ps1'
$hostSyncRoot = Join-Path $companionRoot 'scripts\host-sync'
$liveOpenCode = Join-Path $env:USERPROFILE '.config\opencode'
$baselineOpenCode = 'C:\Users\admin\.config\opencode-backup-pre-host-sync-build-20260821-012600'

. (Join-Path $hostSyncRoot 'HostSync.Contract.ps1')
. (Join-Path $hostSyncRoot 'HostSync.Core.ps1')

$fail = $false

function Assert-Pass {
    param([string]$Name, [bool]$Ok)
    $status = if ($Ok) { 'pass' } else { 'fail' }
    Write-Output "${Name}: $status"
    if (-not $Ok) { $script:fail = $true }
}

$liveJsonPath = Join-Path $liveOpenCode 'opencode.json'
$beforeLive = $null
if (Test-Path -LiteralPath $liveJsonPath) {
    $beforeLive = Get-Content -LiteralPath $liveJsonPath -Raw | ConvertFrom-Json
}

$dryRunOutput = & pwsh -NoProfile -File $syncScript -Target OpenCode 2>&1 | Out-String
Assert-Pass 'pre-Apply dry-run OpenCode exit 0' ($LASTEXITCODE -eq 0)
Assert-Pass 'dry-run plans json-merge' ($dryRunOutput -match 'json-merge\(opencode\.specimen\.json\)')
Assert-Pass 'dry-run plans AGENTS dual-write' ($dryRunOutput -match 'dual-write\(instructions/cursor-escape-loop\.md\)')

$applyOutput = & pwsh -NoProfile -File $syncScript -Target OpenCode -Apply 2>&1 | Out-String
Assert-Pass 'Apply OpenCode exit 0' ($LASTEXITCODE -eq 0)
Assert-Pass 'Apply reports AGENTS hash verify' ($applyOutput -match 'AGENTS hash identical|post-apply AGENTS')
Assert-Pass 'Apply reports model preserved' ($applyOutput -match 'model preserved')
Assert-Pass 'Apply reports provider preserved' ($applyOutput -match 'provider preserved')
Assert-Pass 'Apply reports no backup artifacts' ($applyOutput -match 'no host-sync-apply backup dirs detected')

$instructionsPath = Join-Path $liveOpenCode 'instructions\cursor-escape-loop.md'
$agentsPath = Join-Path $liveOpenCode 'AGENTS.md'
if ((Test-Path -LiteralPath $instructionsPath) -and (Test-Path -LiteralPath $agentsPath)) {
    $iHash = Get-FileSha256Hex -Path $instructionsPath
    $aHash = Get-FileSha256Hex -Path $agentsPath
    Assert-Pass 'post-Apply AGENTS hash identical to instructions' ($iHash -eq $aHash)
}
else {
    Assert-Pass 'post-Apply AGENTS and instructions exist' $false
}

if (Test-Path -LiteralPath $liveJsonPath) {
    $afterLive = Get-Content -LiteralPath $liveJsonPath -Raw | ConvertFrom-Json
    Assert-Pass 'post-Apply instructions path absolute' ($afterLive.instructions[0] -match '^[A-Za-z]:/')
    if ($null -ne $beforeLive -and $beforeLive.model) {
        Assert-Pass 'post-Apply model unchanged' ($afterLive.model -eq $beforeLive.model)
    }
    if ($null -ne $beforeLive -and $beforeLive.provider) {
        $providerOk = ($null -ne $afterLive.provider) -and
            ($afterLive.provider.ollama.options.baseURL -eq $beforeLive.provider.ollama.options.baseURL) -and
            ($afterLive.provider.ollama.name -eq $beforeLive.provider.ollama.name)
        Assert-Pass 'post-Apply provider unchanged' $providerOk
    }
    $agentKeys = @('plan', 'build', 'implementer')
    foreach ($k in $agentKeys) {
        $hasKey = $null -ne $afterLive.agent.$k
        Assert-Pass "post-Apply agent.$k present" $hasKey
    }
}

# C6-relevant static harness checks (automatable subset)
$skillDirs = Get-ChildItem -LiteralPath (Join-Path $liveOpenCode 'skills') -Directory -ErrorAction SilentlyContinue
Assert-Pass 'C6 harness: 9 skills on disk' ($skillDirs.Count -eq 9)

$agentFiles = Get-ChildItem -LiteralPath (Join-Path $liveOpenCode 'agents') -Filter '*.md' -File -ErrorAction SilentlyContinue
Assert-Pass 'C6 harness: 7 agents on disk' ($agentFiles.Count -eq 7)

$procMirror = Join-Path $liveOpenCode 'docs\workflow'
Assert-Pass 'C6: no procedure mirror re-synced' (-not (Test-Path -LiteralPath $procMirror))

$reviewModelsHost = Join-Path $liveOpenCode 'review-subagent-models.md'
Assert-Pass 'C6: review-subagent-models not host copy-out' (-not (Test-Path -LiteralPath $reviewModelsHost))

# Token grep on applied skill stubs
$tokenHits = 0
Get-ChildItem -LiteralPath (Join-Path $liveOpenCode 'skills') -Recurse -Filter 'SKILL.md' -File | ForEach-Object {
    $c = Get-Content -LiteralPath $_.FullName -Raw
    if ($c -match '\{\{COMPANION_ROOT\}\}|\{\{OPENCODE_HOME\}\}') { $script:tokenHits++ }
}
Assert-Pass 'post-Apply skill stubs have 0 unreplaced tokens' ($tokenHits -eq 0)

& pwsh -NoProfile -File (Join-Path $hostSyncRoot 'Invoke-Phase2FastCI.ps1')
Assert-Pass 'Phase2 Fast CI nested pass' ($LASTEXITCODE -eq 0)

Write-Output ''
Write-Output '=== Phase 0 baseline restore (if Apply broke live OpenCode) ==='
Write-Output "Baseline: $baselineOpenCode"
Write-Output 'Restore: copy baseline harness leaves back to ~/.config/opencode (instructions, AGENTS.md, skills, agents, opencode.json)'

exit $(if ($fail) { 1 } else { 0 })
