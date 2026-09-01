# Cline host adapter — global `~/.cline` inventory & sync

**Last updated:** 2026-09-01
**Status:** brought up 2026-09-01 (5th stack; shared `Generic.Adapter.ps1` dispatch — no per-stack adapter file). Apply gated on all-six Phase 0 baselines.

## Context

Cline VS Code extension (`saoudrizwan.claude-dev`) harness sync from [overlays/cline/](../../overlays/cline/_index.md). Surface map (docs-verified): [analysis/cline-kilo-probes-2026-09.md](../../analysis/cline-kilo-probes-2026-09.md). Baseline (restore-only): `C:/Users/admin/.cline-backup-pre-kilobringup-20260901-180000` (registered). Sync does **not** create backups.

## Sync commands

```powershell
pwsh ./scripts/Sync-HostHarness.ps1 -Target Cline          # dry-run
pwsh ./scripts/Sync-HostHarness.ps1 -Target Cline -AllowSkew -Apply   # bring-up/live write (operator-gated)
pwsh ./scripts/Sync-HostHarness.ps1 -Apply                 # global (normative)
```

## Layer map

| Live surface | Content | SoT |
| --- | ------- | --- |
| `~/.cline/rules/cursor-escape-loop.md` | composed always-on rule (header + 3 gate bodies + wiring) | [overlays/cline](../../overlays/cline/_index.md) |
| `~/.cline/data/workflows/{plan,review,closeout}.md` | plan/review/closeout workflows (serial review adaptation) | overlays/cline/workflows |
| `~/.cline/data/workflows/<11 pointer workflows>` | parity set | `shared:` sources |

## Deviations (attested)

| # | Deviation | Evidence |
| --- | --------- | -------- |
| 1 | Serial in-chat dual review; no nested subagent spawn | [cline-cli-subagent orchestration](../../analysis/cline-cli-subagent-orchestration-2026-08.md) |
| 2 | Rules toggle-able by user (gates discover-default-ON but can be toggled OFF) | Cline rules docs (toggle semantics) |
| 3 | Skills rendered as named `.md` workflows (no SKILL.md-dir contract) | Cline workflows docs |
| 4 | `cline_mcp_settings.json` + `~/.cline/data/{sessions,db,cache,workspaces}` never touched | manifest NeverTouch |

## Risks

- **Cline auto-update** may shift scan paths — re-verify Rules panel discovery after extension upgrade (row: re-verify on upgrade).
- **Rules-toggle OFF** silently removes gates — SOP pointer: confirm Rules panel state before loop-critical steps (fail loud).
- **Compat paths** (`~/Documents/Cline/Rules`) are scanned too — keep empty to avoid double-load duplication.
