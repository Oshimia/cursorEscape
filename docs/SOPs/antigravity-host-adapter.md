# Antigravity host adapter

**Last updated:** 2026-08-24

## Context

This SOP documents the **Antigravity adapter** for the owner's agentic stack. **Target SoT** is the companion repo ([skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md)). Files under `~/.gemini/` are the **host copy-out target**, not a second procedure tree. Live sync via [`Sync-HostHarness.ps1`](../../scripts/Sync-HostHarness.ps1) from [overlays/antigravity](../../overlays/antigravity/_index.md). **Live sync status: deferred** — capability shipped, dry-run verified; `-Apply` awaits operator Phase 0 baseline.

Owner decisions (2026-08-23): cursorEscape is **sole SoT**; live global rules (`~/.gemini/GEMINI.md`) are **wholesale-replaced** by the overlay gate; v1 surfaces = global skills + global workflows + reviewer subagent defs + GEMINI.md.

**Install root (this machine):** `C:\Users\admin\.gemini\`

**Phase 0 baseline (restore-only):** **pending operator action** — take a restore-only copy of `~/.gemini` (e.g. `%USERPROFILE%\.gemini-backup-pre-host-sync-build-<timestamp>`), then set its path in [`scripts/host-sync/baseline-backups.paths.json`](../../scripts/host-sync/baseline-backups.paths.json) under `antigravity`. Until then `-Apply` fails closed for **all** stacks (deliberate coupling — see [host-sync README](../../scripts/host-sync/README.md)); dry-runs are unaffected.

## Substance

### Must / Must-not (host adaptation fidelity)

**Must:** Meet [host-adaptation-fidelity](../featureArchitecture/host-adaptation-fidelity.md) — same operator loops as Cursor/OpenCode; C1–C6 attested at runtime post-Apply; deviations attested explicitly, never silent.

**Must-not:** Mark adapter Done on folder presence; paste deep procedure into overlay bodies; ship skills without `description` frontmatter; claim parallel-leg parity if native subagent spawn proves non-parallel at smoke time.

### Layer map

| Layer | Portable contract | Antigravity adapter path |
| ----- | ----------------- | ------------------------ |
| Always-on (thin) | Gate pointers only | `GEMINI.md` (global rules surface — injected across all workspaces; **full replacement**) |
| Skills (on-demand) | [skills/](../../skills/_index.md) thin stubs | `config/skills/<id>/SKILL.md` → Read `{{COMPANION_ROOT}}/skills|workflow/…` (auto-discovered catalog) |
| Workflows | Trajectory wrappers | `antigravity/global_workflows/escape-{plan,review,closeout}.md` → `/escape-*` slash commands |
| Reviewer legs | [agents/](../../agents/_index.md) contracts | `config/agents/{plan_reviewer,production_readiness_reviewer,bug_reviewer}.md` — read-only tool allowlists (edit-deny parity); spawned via `invoke_subagent`, concurrent clean-context children |

### Inventory

- **Always-on:** `GEMINI.md` — default-on plan + dual review; when-in-doubt; eval/harness not exempt; Incomplete-until pointer.
- **Skills (9):** `discovery`, `implementation-plan`, `plan-review`, `implementation-review`, `pre-commit-ci-gate`, `composer`, `documentation-architecture`, `roadmap`, `diagnosing-bugs` (parity bar = OpenCode overlay inventory; `pre-commit-ci-gate` has no companion skill base — SoT is [`rules/pre-commit-ci-gate.md`](../../rules/pre-commit-ci-gate.md)).
- **Workflows (3):** `/escape-plan`, `/escape-review`, `/escape-closeout`.
- **Subagents (3):** reviewer legs with read-only tool lists (`view_file`, `grep_search`, `run_command`); exact tool names only — misspellings hang subagents (known upstream issue).
- **Never synced / never touched:** `antigravity/global_workflows/caveman.md`; credential/app-state files (`settings.json`, `config/mcp_config.json`, `oauth_creds.json`, `google_accounts.json`, `state.json`, `trustedFolders.json`, `installation_id`); `config/projects`.

### Live sync (Sync-HostHarness)

```powershell
# Dry-run (default) — no live writes
pwsh ./scripts/Sync-HostHarness.ps1 -Target Antigravity

# Live write — requires Phase 0 baseline gate (ALL stacks' baselines present)
pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target Antigravity
```

### Risks / notes

1. **Gemini CLI shares `~/.gemini/GEMINI.md`.** Full replacement propagates the cursorEscape gate to Gemini CLI sessions too — owner-accepted consequence of sole-SoT (2026-08-23).
2. **All-three-baseline Apply coupling:** until the `~/.gemini` baseline exists and its path fills the `antigravity` property, `-Apply -Target Cursor/OpenCode` also fails closed. Deliberate conservatism.
3. **Gemini CLI tolerance of additive subtrees** (`config/skills/**`, `config/agents/**`) — accepted risk; post-Apply smoke catches anomalies.
4. **Deliberate skill-set exclusion:** only nine ids mirrored; extend deliberately per parity bar, not by default.
5. **Commit ordering:** this stack's `bug_reviewer.md` harness cites `{{COMPANION_ROOT}}/skills/bug-review-sweep/SKILL.md` — currently untracked owner work; land or co-commit it before/with this overlay's commit ([overlay _index implication #4](../../overlays/antigravity/_index.md)).

### Smoke table (C1–C6 mapped)

Rows run **after authorized `-Apply` + full quit/restart** (restart assumed required for harness pickup — D2 assumption frozen 2026-08-23; revisit if operator observes hot-reload). No row may pass on file presence alone.

| # | Checklist item | Method (post-Apply) | Status |
| - | -------------- | ------------------- | ------ |
| C1 | Always-on gates inject | Clean chat, zero tools: model quotes default-on plan loop + when-in-doubt + eval/harness not exempt from session text | deferred: awaiting operator Apply |
| C2 | Skill catalog complete | Skill listing shows all nine ids; load `implementation-plan` without shell browsing | deferred: awaiting operator Apply |
| C3 | Dual review honors isolation + deny-edit | Parent launches both reviewer subagents in one turn via `invoke_subagent`; reviewers cannot edit (read-only tools). Expected value: parity attestation if concurrent spawn confirmed; otherwise `deviation: sequential fresh-context fallback per owner decision 2026-08-23; parallel-leg parity not met` | deferred: awaiting operator Apply |
| C4 | Deep workflow Reads resolve | Load `implementation-review`; confirm Read resolves `{{COMPANION_ROOT}}/workflow/iterative-code-review.md` | deferred: awaiting operator Apply |
| C5 | Companion docs readable without repeated asks | Sample FA leaf read via native file-read without serial shell listing | deferred: awaiting operator Apply |
| C6 | Behavior, not presence | All rows above attest behavior with pass/fail/deferred; no presence-only passes | n/a until rows 1–5 run |

Operator checklist (post-baseline): take baseline → fill `antigravity` path → `-Apply -Target Antigravity` → full quit + restart → run rows above → record statuses here.

## Related

- [Antigravity overlay](../../overlays/antigravity/_index.md)
- [Host sync README](../../scripts/host-sync/README.md)
- [Host adaptation fidelity](../featureArchitecture/host-adaptation-fidelity.md)
- [Skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)
- [OpenCode host adapter](./opencode-host-adapter.md)
- [Editing companion workflow](./editing-companion-workflow.md)
