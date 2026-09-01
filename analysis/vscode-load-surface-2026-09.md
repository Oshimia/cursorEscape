# VS Code load-surface discovery — Phase 0 (vscode bring-up)

**Date:** 2026-09-01
**Provenance:** official VS Code docs `code.visualstudio.com/docs/agent-customization/*` (all "Edit this page 8/26/2026" — current stable), fetch-verified in-session; machine inventory via shell. Feeds `docs/roadmaps/vscode-bring-up.md` and `overlays/vscode/_index.md`.

## Load-surface map (user-level, stable 2026-09)

| Surface | User-level path | Format | Auto-load | Slash | Docs page |
|---|---|---|---|---|---|
| Instructions | `~/.copilot/instructions/` (recursive) | `.instructions.md`, frontmatter `name`/`description`/`applyTo` | `applyTo: '**'` = always-on | manual attach | custom-instructions |
| Custom agents | `~/.copilot/agents/` | `.agent.md`, frontmatter `name`/`description`/`tools[]`/`agents[]`/`model`/`user-invocable`/`disable-model-invocation`/`handoffs` | body prepended when selected | agent dropdown | custom-agents |
| Agent skills | `~/.copilot/skills/` (`<name>/SKILL.md`, dir == `name`) | `name`/`description`/`argument-hint`/`user-invocable`/`disable-model-invocation` | description-relevance | in `/` menu | agent-skills |
| Prompt files | VS Code profile user data (`%APPDATA%\Code\User\prompts`) | `.prompt.md` | never | `/name` | prompt-files |

## Binding decisions

1. **LiveRelativeRoot = `.copilot`** (USERPROFILE-relative; `Join-Path $env:USERPROFILE` adapter construction resolves to `C:\Users\admin\.copilot`). Single root covers instructions + agents + skills.
2. **Prompt files NOT used.** Docs: "Agents running on the Agent Host don't use prompt files" — converting to skills is the documented migration. Owner-invoked skills map to `disable-model-invocation: true` (manual `/slash` only); core-loop skills run default (description-triggered). This supersedes the earlier `%APPDATA%\Code\User\prompts` decision.
3. **`applyTo: '**'` caveat** (docs): applied when creating/modifying matching files; "burns context". Thin always-on gate body only (instruction-layering).
4. **Skills name rule:** `name` must equal parent dir name; invalid chars → silent load failure (docs).
5. **Priority:** personal/user-level instructions highest, then repo, then org.

## Verification tooling (designated)

Chat **Diagnostics view** (right-click Chat view → Diagnostics): lists all loaded instruction files, prompt files, custom agents, skills + errors. Agent Debug Log: prompt-file discovery events. These are the designated Phase 4 smoke instruments (C1/C2/C6 rows).

## Machine inventory (Phase 0, 2026-09-01)

- `~/.copilot/` exists with `config.json`, `ide\` (locks), `logs\` (transient). No `instructions/`, `agents/`, or `skills/` yet — clean bring-up, no pre-existing-user-content collision on these subdirs.
- Baseline snapshot (restore-only, logs/locks excluded as held-open at snapshot time): `scripts/host-sync/baselines/vscode-baseline-2026-09-01.json` (1 file: `config.json`, SHA-256 recorded).
- Settings Scan: `chat.agent.enabled: true`, `chat.subagents.useRichRendering: true` present; no customization-location overrides set → defaults apply (`~/.copilot/*` live).

## UNKNOWNs carried forward (resolvers assigned)

1. Hot-reload of *newly added* files (docs imply watchers; not guaranteed for additions) → resolver: Diagnostics view before/after, no reload; assume full restart until proven.
2. `.agent.md` `tools` field names → resolver: Diagnostics + a probe agent echo of its own toolset (Phase 4 per-agent smoke).
3. Instructions `applyTo` auto-attach on read-only ops → resolver: C1 quote-probe in clean workspace post-restart.

## Deviations (pre-attested)

- **Subagent depth 1** (`analysis/vscode-subagent-recursion-2026-08.md`): children cannot spawn subagents. Dual review still holds: parent fans out to reviewers in one turn. Attested in C-matrix (Antigravity C3 precedent). Mitigation note: `disable-model-invocation: true` on reviewer agents blocks model-initiated subagent spawn of reviewers; user still selects them from dropdown.
- **Model assignment:** `plan_reviewer` model recommendation (`overlays/cursor/review-subagent-models.md`) is Cursor-native; VS Code agents accept `model` frontmatter — left unset (picker default) pending owner decision (U13).
