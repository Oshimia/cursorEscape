# VS Code host adapter SOP

**Last updated:** 2026-09-20
**Stack:** `Vscode` · **Live root:** `~/.copilot/` · **Surface:** Copilot user-level instructions, agents, and skills · **Adapter:** shared `Generic.Adapter.ps1`

## Must / Must-not

**Must**

- Sync via `pwsh scripts\Sync-HostHarness.ps1 -Target Vscode` for scoped dry-run. Global dry-run is the normative default. Live Apply requires registered restore baselines and fresh explicit owner authorization.
- Full VS Code restart after any Apply before trusting discovery.
- Verify via chat **Diagnostics view** (right-click Chat → Diagnostics) — loaded instructions/agents/skills + errors are listed there.

**Must-not**

- Never touch `~/.copilot/config.json`, `ide/`, `logs/` (manifest `NeverTouch`).
- Never copy `review-subagent-models.md` or overlay `_index.md` to the host.
- Never author loop procedure in the overlay (Forbidden list); deep procedure stays companion-resident via `{{COMPANION_ROOT}}` absolute Reads.
- Never treat an empty skill/agent catalog in Diagnostics as success — fail loud.

## Inventory (synced)

| Surface | Dests |
|---|---|
| instructions (always-on) | `instructions/cursor-escape-loop.instructions.md`, `instructions/pre-commit-gate.instructions.md` (2 composed files) |
| skills (11) | `skills/<id>/SKILL.md` — parity bar ids incl. `composer`, `implementation-review`, `opencode-history-search` (vscode-authored deltas) |
| agents (8) | `agents/<role>.agent.md` — reviewers read-only via `tools` arrays; `plan_reviewer`/reviewer agents `disable-model-invocation: true` |

## Verification (C1–C6)

After an authorized Apply, fully restart VS Code, then verify in this order: snapshot-diff with `-Target Vscode`, C1 quote-probe in a clean workspace, C2 catalog discovery, C4/C5 companion paths and tokens, and C6 operator loop. Use the [host adaptation fidelity](../featureArchitecture/host-adaptation-fidelity.md) matrix. Empty diagnostics are failures, not success.

## Sync commands

```powershell
pwsh scripts\Sync-HostHarness.ps1 -Target Vscode                 # dry-run (safe)
# Scoped repair only: fresh owner authorization plus -AllowSkew.
pwsh scripts\Sync-HostHarness.ps1 -Target Vscode -AllowSkew -Apply
pwsh scripts\Sync-HostHarness.ps1                                # normative -Target All dry-run
# Normative live write with fresh explicit owner authorization.
pwsh scripts\Sync-HostHarness.ps1 -Apply
```

## Risks / notes

- **Subagent depth 1** — reviewer fan-out parent-side (attested deviation, Antigravity C3 precedent).
- **Seven-stack fan-out** — portable procedure edits fan out across every governed host through the editing-companion cascade.
- **Baseline restore** — pre-bringup baseline dir is restore-only if an Apply damages pre-existing content.
- **Generic adapter** — this stack intentionally shares the generic adapter rather than maintaining a clone.
