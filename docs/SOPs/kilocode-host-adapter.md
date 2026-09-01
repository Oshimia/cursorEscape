# Kilo Code host adapter — global `~/.kilocode` inventory & sync

**Last updated:** 2026-09-01
**Status:** brought up 2026-09-01 (6th stack; shared `Generic.Adapter.ps1` dispatch — no per-stack adapter file). Apply gated on all-six Phase 0 baselines.

## Context

Kilo Code VS Code extension (`kilocode.kilo-code-7.5.6`, Kilo CLI-platform rebuild) harness sync from [overlays/kilocode/](../../overlays/kilocode/_index.md). Surface map (docs-verified): [analysis/cline-kilo-probes-2026-09.md](../../analysis/cline-kilo-probes-2026-09.md). Baseline (restore-only): `C:/Users/admin/.kilocode-backup-pre-kilobringup-20260901-180000` (registered). Sync does **not** create backups.

## Sync commands

```powershell
pwsh ./scripts/Sync-HostHarness.ps1 -Target Kilocode          # dry-run
pwsh ./scripts/Sync-HostHarness.ps1 -Target Kilocode -AllowSkew -Apply   # bring-up/live write (operator-gated)
pwsh ./scripts/Sync-HostHarness.ps1 -Apply                    # global (normative)
```

## Layer map

| Live surface | Content | SoT |
| --- | ------- | --- |
| `~/.kilocode/rules/cursor-escape-loop.md` | composed always-on rule (auto-included by compat loader; no toggles) | [overlays/kilocode](../../overlays/kilocode/_index.md) |
| `~/.kilocode/workflows/{plan,review,closeout}.md` | plan/review/closeout workflows (auto-migrated to `/` commands at startup) | overlays/kilocode/workflows |

## Deviations (attested)

| # | Deviation | Evidence |
| --- | --------- | -------- |
| 1 | Subagents are first-class NEW in this platform; depth/behavior unproven — verify at smoke before conductor reliance | kilo.ai custom-subagents docs |
| 2 | Reviewer read-only is instruction-level (mode-defs / custom-modes out of scope) | kilo.ai custom-modes docs |
| 3 | All discovered rules concatenate always-on (no toggle; global-first; project precedence on conflict) | kilo.ai custom-rules "Rule Loading Order" |
| 4 | `kilo.jsonc` new-model config (global `~/.config/kilo`) is out-of-scope — future-migration leg only, owner-decided | kilo.ai custom-rules migration note |
| 5 | Kilo globalStorage (`state.vscdb`, `settings/mcp_settings.json`) never touched | manifest surface design |

## Risks

- **Extension auto-update / platform shifts** — legacy `.kilocode/workflows` auto-migration behavior may change; re-verify `/escape-plan` slash on upgrade (row: re-verify on upgrade).
- **Workflows slash commands only register after a session start** — post-Apply, start/refresh a Kilo session; missing `/escape-plan` = discovery failure, fail loud.
- New-model `kilo.jsonc` merge leg would be a machinery change — do not author without owner decision (documented in SOP).
