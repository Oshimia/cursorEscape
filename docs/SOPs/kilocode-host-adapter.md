# Kilo Code host adapter — global `~/.kilocode` inventory & sync

**Last updated:** 2026-09-20
**Status:** established stack using shared `Generic.Adapter.ps1`; no Kilo Code-specific adapter file. Live Apply requires registered restore baselines and fresh explicit owner authorization.

## Context

Kilo Code VS Code extension (`kilocode.kilo-code-7.5.6`, Kilo CLI-platform rebuild) harness sync from [overlays/kilocode/](../../overlays/kilocode/_index.md). Surface map is docs-verified. Baseline (restore-only): `C:/Users/admin/.kilocode-backup-pre-kilobringup-20260901-180000` (registered). Sync does **not** create backups.

## Sync commands

```powershell
pwsh ./scripts/Sync-HostHarness.ps1 -Target Kilocode          # dry-run
# Scoped repair only: fresh owner authorization plus -AllowSkew.
pwsh ./scripts/Sync-HostHarness.ps1 -Target Kilocode -AllowSkew -Apply
pwsh ./scripts/Sync-HostHarness.ps1 -Apply                    # global (normative)
```

## Layer map

| Live surface | Content | SoT |
| --- | ------- | --- |
| `~/.kilocode/rules/cursor-escape-loop.md` | composed always-on rule (auto-included by compat loader; no toggles) | [overlays/kilocode](../../overlays/kilocode/_index.md) |
| `~/.kilocode/workflows/{plan,review,closeout,agents}.md` | plan/review/closeout workflows plus all-seven governed-agent fallback route (auto-migrated to `/` commands at startup) | overlays/kilocode/workflows |

## Deviations (attested)

| # | Deviation | Evidence |
| --- | --------- | -------- |
| 1 | Subagents are first-class NEW in this platform; depth/behavior unproven — governed child-agent legs use separate fresh task/session until smoke-attested. `workflows/agents.md` gives all seven canonical routes; `implementer` is workspace-write and `test_reviewer` is read-only. | kilo.ai custom-subagents docs; [canonical invocation](../../workflow/agent-invocation.md); [governed fallback routes](../../overlays/kilocode/workflows/agents.md) |
| 2 | Reviewer read-only is instruction-level (mode-defs / custom-modes out of scope) | kilo.ai custom-modes docs |
| 3 | All discovered rules concatenate always-on (no toggle; global-first; project precedence on conflict) | kilo.ai custom-rules "Rule Loading Order" |
| 4 | `kilo.jsonc` new-model config (global `~/.config/kilo`) is out-of-scope — future-migration leg only, owner-decided | kilo.ai custom-rules migration note |
| 5 | Kilo globalStorage (`state.vscdb`, `settings/mcp_settings.json`) never touched | manifest surface design |

## Risks

- **Extension auto-update / platform shifts** — legacy `.kilocode/workflows` auto-migration behavior may change; re-verify `/escape-plan` slash on upgrade (row: re-verify on upgrade).
- **Workflows slash commands only register after a session start** — post-Apply, start/refresh a Kilo session; missing `/escape-plan` = discovery failure, fail loud.
- New-model `kilo.jsonc` merge leg would be a machinery change — do not author without owner decision (documented in SOP).
