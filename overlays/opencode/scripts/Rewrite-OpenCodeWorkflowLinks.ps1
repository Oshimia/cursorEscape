<#
.SYNOPSIS
  Archived one-shot seed for Phase 3 deploy — transform companion workflow/ links
  for OpenCode host docs/workflow/ mirror (sync method A).

.DESCRIPTION
  Reads markdown from companion workflow/ and writes transformed copies to
  OpenCode docs/workflow/. Default is dry-run (report only). Re-run with -Apply
  during Phase 3 copy-out. Idempotent: second run makes no further changes.

.PARAMETER SourceDir
  Companion workflow root. Pass repo `workflow/` directly for dry-run (no COMPANION_ROOT required), e.g.
  `-SourceDir C:/path/cursorEscape/workflow`. Default: $env:COMPANION_ROOT/workflow when set.

.PARAMETER DestDir
  Host workflow mirror (default: $env:OPENCODE_HOME/docs/workflow).

.PARAMETER Apply
  Write transformed files. Without this flag, only reports pending changes.

.PARAMETER IncludeRubric
  Also transform companion FA rubric copy-out to host docs/workflow/bug-reviewer-finding-rubric.md.
  Requires RubricSourcePath or COMPANION_ROOT.

.PARAMETER RubricSourcePath
  Source rubric (default: $env:COMPANION_ROOT/docs/featureArchitecture/bug-reviewer-finding-rubric.md).

.EXAMPLE
  $env:COMPANION_ROOT = 'C:/path/cursorEscape'
  $env:OPENCODE_HOME = 'C:/Users/admin/.config/opencode'
  ./Rewrite-OpenCodeWorkflowLinks.ps1

.EXAMPLE
  ./Rewrite-OpenCodeWorkflowLinks.ps1 -SourceDir C:/path/cursorEscape/workflow -DestDir $env:TEMP/oc-wf-dryrun

.EXAMPLE
  ./Rewrite-OpenCodeWorkflowLinks.ps1 -SourceDir C:/path/cursorEscape/workflow -DestDir $env:TEMP/oc-wf-dryrun -IncludeRubric -RubricSourcePath C:/path/cursorEscape/docs/featureArchitecture/bug-reviewer-finding-rubric.md

.EXAMPLE
  ./Rewrite-OpenCodeWorkflowLinks.ps1 -Apply
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$SourceDir = $(if ($env:COMPANION_ROOT) { Join-Path $env:COMPANION_ROOT 'workflow' } else { '' }),
    [string]$DestDir = $(if ($env:OPENCODE_HOME) { Join-Path $env:OPENCODE_HOME 'docs/workflow' } else { '' }),
    [switch]$Apply,
    [switch]$IncludeRubric,
    [string]$RubricSourcePath = $(if ($env:COMPANION_ROOT) { Join-Path $env:COMPANION_ROOT 'docs/featureArchitecture/bug-reviewer-finding-rubric.md' } else { '' })
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $SourceDir -or -not (Test-Path -LiteralPath $SourceDir)) {
    throw "SourceDir not found. Pass -SourceDir (e.g. repo workflow/) or set COMPANION_ROOT."
}
if (-not $DestDir) {
    throw "DestDir not set. Set OPENCODE_HOME or pass -DestDir."
}

function Convert-WorkflowContent {
    param([string]$Content, [string]$SourceFileName)

    $out = $Content
  # Depth: companion workflow/ -> host docs/workflow/ (skills/agents at adapter root = ../../)
    $out = $out -replace '\]\(\.\./skills/', '](../../skills/'
    $out = $out -replace '\]\(\.\./agents/', '](../../agents/'
    $out = $out -replace '\]\(\.\./overlays/cursor/review-subagent-models\.md\)', '](review-subagent-models.md)'
    $out = $out -replace '\]\(_index\.md\)', '](README.md)'
  # OpenCode has no rules/ tree — strip portable rule links (grep-clean contract)
    $out = $out -replace '\[([^\]]+)\]\(\.\./rules/[^)]+\)', '$1 (portable rules/ — OpenCode uses instructions + skills)'
  # research/ is companion-resident (pointer class) — not mirrored under host docs/
    $out = $out -replace '\[([^\]]+)\]\(\.\./research/[^)]+\)', '$1 (companion-resident — read via {{COMPANION_ROOT}}/research/...)'
  # OpenCode role naming in mirrored prose (specific before general)
    $out = $out -replace 'Reviewer A or Bugbot', 'production_readiness_reviewer or bug_reviewer'
    $out = $out -replace 'Reviewer A \+ Bugbot', 'production_readiness_reviewer + bug_reviewer'
    $out = $out -replace '\+ Bugbot \(built-in\)', '+ bug_reviewer'
    $out = $out -replace 'Bugbot Custom Instructions', 'bug_reviewer Custom Instructions'
    $out = $out -replace 'Bugbot all lists', 'bug_reviewer all lists'
    $out = $out -replace 'Reviewer-a', 'production_readiness_reviewer'
    $out = $out -replace 'Reviewer A', 'production_readiness_reviewer'
    $out = $out -replace '\bBugbot\b', 'bug_reviewer'
    $out = $out -replace 'plan-reviewer', 'plan_reviewer'
    $out = $out -replace 'reviewer-a', 'production_readiness_reviewer'
    $out = $out -replace '\| Bugbot \|', '| bug_reviewer |'
    $out = $out -replace 'Cursor product subagent \(no owner-authored overlay file\)', 'OpenCode overlay agent (dual-gate leg)'
    $out = $out -replace 'Cursor-only: \[review-subagent-models\.md\]', 'See [review-subagent-models.md]'
    return $out
}

function Convert-RubricContent {
    param([string]$Content)

    $out = $Content
  # Depth: companion docs/featureArchitecture/ -> host docs/workflow/ (agents at adapter root = ../../)
    $out = $out -replace '\]\(\.\./\.\./agents/', '](../../agents/'
  # research/ and analysis/ are companion-resident (pointer class) — not mirrored under host docs/
    $out = $out -replace '\[([^\]]+)\]\(\.\./\.\./research/[^)]+\)', '$1 (companion-resident — read via {{COMPANION_ROOT}}/research/...)'
    $out = $out -replace '\[([^\]]+)\]\(\.\./\.\./analysis/[^)]+\)', '$1 (companion-resident — read via {{COMPANION_ROOT}}/analysis/...)'
  # sibling FA leaves — companion-resident; do not mirror second FA tree on host
    $out = $out -replace '\[([^\]]+)\]\(\./([^)]+)\)', '$1 (companion FA — read via {{COMPANION_ROOT}}/docs/featureArchitecture/$2)'
    return $out
}

function Write-TransformedFile {
    param(
        [string]$DestPath,
        [string]$Converted,
        [ref]$Changed,
        [ref]$Written,
        [switch]$Apply
    )

    if (-not (Test-Path -LiteralPath $DestPath)) {
        Write-Host "[$(if ($Apply) { 'write' } else { 'dry-run' })] New: $DestPath"
        $Changed.Value++
        if ($Apply) {
            $Converted | Set-Content -LiteralPath $DestPath -Encoding UTF8 -NoNewline
            $Written.Value++
        }
        return
    }

    $existing = Get-Content -LiteralPath $DestPath -Raw -Encoding UTF8
    if ($existing -ne $Converted) {
        Write-Host "[$(if ($Apply) { 'update' } else { 'dry-run' })] Changed: $DestPath"
        $Changed.Value++
        if ($Apply) {
            $Converted | Set-Content -LiteralPath $DestPath -Encoding UTF8 -NoNewline
            $Written.Value++
        }
    } else {
        Write-Host "[ok] Idempotent (no change): $DestPath"
    }
}

$files = Get-ChildItem -LiteralPath $SourceDir -Filter '*.md' -File
$changed = 0
$written = 0

if (-not (Test-Path -LiteralPath $DestDir)) {
    if ($Apply) {
        New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
    } else {
        Write-Host "[dry-run] Would create directory: $DestDir"
    }
}

foreach ($file in $files) {
    $destName = if ($file.Name -eq '_index.md') { 'README.md' } else { $file.Name }
    $destPath = Join-Path $DestDir $destName
    $raw = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
    $converted = Convert-WorkflowContent -Content $raw -SourceFileName $file.Name
    Write-TransformedFile -DestPath $destPath -Converted $converted -Changed ([ref]$changed) -Written ([ref]$written) -Apply:$Apply
}

if ($IncludeRubric) {
    if (-not $RubricSourcePath -or -not (Test-Path -LiteralPath $RubricSourcePath)) {
        throw "RubricSourcePath not found. Pass -RubricSourcePath or set COMPANION_ROOT when using -IncludeRubric."
    }
    $rubricDest = Join-Path $DestDir 'bug-reviewer-finding-rubric.md'
    $rubricRaw = Get-Content -LiteralPath $RubricSourcePath -Raw -Encoding UTF8
    $rubricConverted = Convert-RubricContent -Content $rubricRaw
    Write-TransformedFile -DestPath $rubricDest -Converted $rubricConverted -Changed ([ref]$changed) -Written ([ref]$written) -Apply:$Apply
}

Write-Host "Summary: $changed file(s) would change or did change; $written written with -Apply."
if (-not $Apply) {
    Write-Host 'Dry-run complete. Re-run with -Apply during Phase 3 deploy.'
}
