# Hybrid live Cursor .mdc: overlay frontmatter + companion rules body + spawn pointers.
param(
  [string]$CompanionRoot = 'C:/Users/admin/source/repos/general-projects/cursorEscape',
  [string]$LiveRules = (Join-Path $env:USERPROFILE '.cursor\rules')
)

$ErrorActionPreference = 'Stop'
$overlayRules = Join-Path $CompanionRoot 'overlays\cursor\rules'
$portableRules = Join-Path $CompanionRoot 'rules'

function Get-Frontmatter([string]$path) {
  $raw = [IO.File]::ReadAllText($path)
  if ($raw -match '(?s)\A(---\r?\n.*?\r?\n---\r?\n)') { return $Matches[1] }
  throw "No frontmatter in $path"
}

function Write-Hybrid([string]$id, [string]$spawnBlock) {
  $overlayPath = Join-Path $overlayRules "$id.mdc"
  $portablePath = Join-Path $portableRules "$id.md"
  $fm = Get-Frontmatter $overlayPath
  $body = [IO.File]::ReadAllText($portablePath).TrimEnd()
  # Rewrite relative companion links only — never substring-replace already-absolute paths
  # (a blind replace of "workflow/ci-ladder.md" doubles COMPANION_ROOT).
  $body = $body.Replace('[`../workflow/ci-ladder.md`](../workflow/ci-ladder.md)', "[ci-ladder.md]($CompanionRoot/workflow/ci-ladder.md)")
  $body = $body.Replace('[../workflow/ci-ladder.md](../workflow/ci-ladder.md)', "[ci-ladder.md]($CompanionRoot/workflow/ci-ladder.md)")
  $body = $body.Replace('](../skills/', "]($CompanionRoot/skills/")
  $body = $body.Replace('](../workflow/', "]($CompanionRoot/workflow/")

  $footer = @"

---

## Cursor harness pointers (live sync)

$spawnBlock

**Companion SoT:** ``$CompanionRoot`` (absolute Reads). Transitional mirror ``~/.cursor/docs/workflow/`` is not procedure SoT.
**Deep rule leaf:** ``$CompanionRoot/rules/$id.md``
"@

  $out = $fm + $body + "`r`n" + $footer + "`r`n"
  $dst = Join-Path $LiveRules "$id.mdc"
  if (-not (Test-Path $LiveRules)) { New-Item -ItemType Directory -Path $LiveRules -Force | Out-Null }
  [IO.File]::WriteAllText($dst, $out)
  Write-Output "wrote $dst"
}

Write-Hybrid 'iterative-code-review' @"
**Spawn:** ``~/.cursor/skills/implementation-review/SKILL.md``
**User Rules paste target:** ``~/.cursor/skills/implementation-review/user-rules-snippet.md``
"@

Write-Hybrid 'iterative-plan-review' @"
**Spawn:** ``~/.cursor/skills/implementation-plan/SKILL.md``
**User Rules paste target:** ``~/.cursor/skills/implementation-plan/user-rules-snippet.md``
"@

Write-Hybrid 'pre-commit-ci-gate' @"
**Detail:** ``$CompanionRoot/workflow/ci-ladder.md``
**Skill (on-demand):** ``$CompanionRoot/skills/pre-commit-ci-gate/SKILL.md`` when loaded via skill tool / companion.
"@

Write-Output 'done'
