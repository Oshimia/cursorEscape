# VS Code host adapter SOP

**Stack:** `Vscode` · **Live root:** `~/.copilot/` · **Surface:** Copilot user-level instructions/agents/skills (docs-verified 2026-09-01 — [load-surface map](../analysis/vscode-load-surface-2026-09.md))

## Must / Must-not

**Must**

- Sync via `pwsh scripts\Sync-HostHarness.ps1 -Target Vscode` (dry-run default). First Apply was single-stack `-AllowSkew` (bring-up exception) with **operator authorization**; converge to normative `-Target All`.
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

Deferred smoke table: [roadmap](../roadmaps/vscode-bring-up.md) (fill on Phase 4). Post-Apply order: restart → snapshot-diff (`-Target Vscode` dry-run vs live) → C1 quote-probe in clean workspace → C2 catalog → C4/C5 hash/token → C6 operator loop.

## Sync commands

```powershell
pwsh scripts\Sync-HostHarness.ps1 -Target Vscode                 # dry-run (safe)
pwsh scripts\Sync-HostHarness.ps1 -Target Vscode -AllowSkew -Apply   # bring-up exception; operator-gated
pwsh scripts\Sync-HostHarness.ps1                                # normative -Target All dry-run
```

## Risks / notes

- **Subagent depth 1** — reviewer fan-out parent-side (attested deviation, Antigravity C3 precedent).
- **4-stack fan-out** — every procedure edit now fans out to 4 host surfaces during the editing-companion cascade; golden/check upkeep multiplies accordingly.
- **Baseline restore** — pre-bringup baseline dir is restore-only if an Apply damages pre-existing content.
- **Future note** — if a 5th stack arrives, propose a shared generic adapter to the owner instead of a 4th/5th clone (cost note, 2026-09-01 review).
