# OpenCode host adapter

**Last updated:** 2026-08-23

## Context

This SOP documents the **global OpenCode adapter** installed on the operator machine for R0 live trial of the cursorEscape loop. **Target SoT** is this companion repo ([skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md), [agents](../../agents/_index.md), [skills](../../skills/_index.md)). Files under `~/.config/opencode/` are the **host adapter / copy-out target**, not a second procedure tree. Live sync via [`Sync-HostHarness.ps1`](../../scripts/Sync-HostHarness.ps1) from [overlays/opencode](../../overlays/opencode/_index.md). **Procedure mirror deleted** pointer-first-4 (2026-08-20). **C6 minimum smoke rows 1–4, 8, 9–10, 13: pass** (2026-08-21 post–`Sync-HostHarness`). Row **14**: **pass** (2026-08-21). Paste runbook: [opencode-smoke-prompts](./opencode-smoke-prompts.md). See also [pointer-first-4 closeout](../../analysis/pointer-first-4-closeout-2026-08.md).

**Install root (this machine):** `C:\Users\admin\.config\opencode\`

**Phase 0 baseline (restore-only):** `C:\Users\admin\.config\opencode-backup-pre-host-sync-build-20260821-012600` — see `BACKUP_MANIFEST.md` in that folder (`Kind: Baseline`). Gate artifact: [`scripts/host-sync/baseline-backups.paths.json`](../../scripts/host-sync/baseline-backups.paths.json). **Sync does not create backups** — baselines are for restore if Apply testing breaks the live harness.

**Legacy backup (archaeology):** `C:\Users\admin\.config\opencode-backup-20260820-153803` — superseded by Phase 0 baseline for restore precedence.

## Substance

### Must / Must-not (host adaptation fidelity)

**Must:** Meet [host-adaptation-fidelity](../featureArchitecture/host-adaptation-fidelity.md) — same operator loops as Cursor; C1–C6 matrix at runtime; smoke proves behavior, not folder presence.

**Must-not:** Mark adapter **Done** on inventory alone; deploy Cursor `rules/` tree on OpenCode; ship skills without `name` frontmatter; skip dual Task review or deny-edit on reviewers.

### Layer map

| Layer | Portable contract | OpenCode adapter path (pointer-first Target) |
| ----- | ----------------- | -------------------------------------------- |
| Always-on (thin) | Gate pointers only | `instructions/cursor-escape-loop.md` (wired via `opencode.json` → `instructions` — **absolute** `{{OPENCODE_HOME}}/…`) + matching `AGENTS.md` |
| Skills (on-demand) | [skills/](../../skills/_index.md) — thin harness stubs | `skills/*/SKILL.md` → Read `{{COMPANION_ROOT}}/skills/…` and `{{COMPANION_ROOT}}/workflow/…` |
| Deep workflow docs | Companion [workflow/](../../workflow/_index.md) at `{{COMPANION_ROOT}}/workflow/*.md` | **Absolute companion Read** (locked smoke row **4** How). Host `docs/workflow/*` mirror **deleted** pointer-first-4 ([closeout](../../analysis/pointer-first-4-closeout-2026-08.md)) |
| Role agents | [agents/](../../agents/_index.md) — thin harness | `agents/*.md` (`permission.edit: deny` on reviewers) |

### Inventory

**Always-on**

- `instructions/cursor-escape-loop.md` — default-on plan + dual review; Incomplete until / template-fidelity pointer; when in doubt; eval/harness not exempt; empty-Task fail-loud note
- `AGENTS.md` — same body as `instructions/cursor-escape-loop.md` (global rules surface; required for reliable C1)
- `opencode.json` → `instructions` — **absolute** path under `OPENCODE_HOME` (cwd-relative paths do not load from global config)

**Skills**

- `discovery`, `implementation-plan` (Escalation *when* SoT), `plan-review`, `implementation-review`, `pre-commit-ci-gate`, `composer`, `documentation-architecture`, **`roadmap`**, `diagnosing-bugs`

**Agents**

- `planner`, `plan_reviewer`, `implementer` (primary), `production_readiness_reviewer`, `bug_reviewer` (loads finding rubric), `repository_explorer`, `test_reviewer` (optional; Task permission `ask`), `composer_conductor` (primary; Composer thread agent — task allowlist `"*": deny` first, then workflow subagents)

**Deep docs (pointer-first Target)**

- Companion `{{COMPANION_ROOT}}/workflow/` — sole procedure SoT; harness Reads absolute paths (smoke row **4** locked How)
- Companion `{{COMPANION_ROOT}}/docs/featureArchitecture/bug-reviewer-finding-rubric.md` — rubric SoT (smoke row **8**)
- [review-subagent-models.md](../../overlays/opencode/review-subagent-models.md) — thin overlay leaf; companion overlay-Read only (not host mirror)

**Config hooks**

- **Skills inventory:** each `skills/*/SKILL.md` must include frontmatter `name` (folder id) + `description` — required for skill-tool advertisement (Observed 2026-08-19).
- `opencode.json` — `instructions`; `permission.skill: { "*": "allow" }`; `skills.paths` → global skills dir; `agent.build` / `agent.implementer` `permission.task` allowlists (+ skill allow).
- **Resolved (discovery 2026-08-19):** empty skill-tool catalog was missing `name` / path registration, not contamination. See [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md).

### Live sync (Sync-HostHarness)

Operator entry: [`scripts/Sync-HostHarness.ps1`](../../scripts/Sync-HostHarness.ps1). Modular layout + expansion recipe: [`scripts/host-sync/README.md`](../../scripts/host-sync/README.md).

```powershell
# Dry-run (default) — no live writes
pwsh ./scripts/Sync-HostHarness.ps1 -Target OpenCode

# Live write — requires Phase 0 baseline gate; does NOT create backup trees
pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target OpenCode

# All registered stacks (Cursor then OpenCode; continue-with-report)
pwsh ./scripts/Sync-HostHarness.ps1 -Target All
pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target All
```

On `-Apply`, the script:

1. Asserts Phase 0 baseline paths exist — read-only gate only.
2. Copies thin harness from [`overlays/opencode`](../../overlays/opencode/_index.md) per [`opencode.manifest.psd1`](../../scripts/host-sync/manifests/opencode.manifest.psd1).
3. Merges `{{COMPANION_ROOT}}` / `{{OPENCODE_HOME}}` tokens; preserves live `model` / `provider` in `opencode.json`.
4. Dual-writes always-on gates to `instructions/cursor-escape-loop.md` and `AGENTS.md` (byte-identical — C1).
5. Does **not** bulk re-copy procedure mirror (`docs/workflow/` — `NeverTouch` / hard exclude); `review-subagent-models` stays companion overlay-Read only.

After Apply: fully quit and restart OpenCode before smoke.

### Sync rule (authoring order)

1. Update **cursorEscape** contracts first (Target FA / agents / skills / overlay rules).
2. Re-adapt OpenCode files second — do not invent gate semantics only in `~/.config/opencode`.
3. When updating always-on gates: edit overlay `instructions/cursor-escape-loop.md`, then deploy with `pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target OpenCode` (adapter dual-writes byte-identical `instructions/` and `AGENTS.md` — C1). Manual copy to live paths is **not recommended** (bypasses token merge and JSON specimen merge).
4. Do **not** commit `~/.config/opencode` into this git repo (secrets, machine paths, provider plugins). Copy-out later still excludes secrets.
5. After saving changes to `opencode.json`, an agent file, a skill, `instructions`, `AGENTS.md`, or other config-time file: **quit and restart OpenCode** (no hot-reload — DSV4F Observed).

### Dual review on OpenCode

- **One** OpenCode session; **two** Task children (`production_readiness_reviewer` ∥ `bug_reviewer`).
- Not two T3 worktrees.
- Parent owns Observed Fast CI; reviewers `edit: deny`.
- Split envelope: locked opener on production_readiness; Custom Instructions on bug_reviewer.
- `bug_reviewer` follows companion Target rubric at `{{COMPANION_ROOT}}/docs/featureArchitecture/bug-reviewer-finding-rubric.md` (host procedure mirror **deleted** pf4).

### Smoke checklist (R0)

Record results when running live checks. Expected: `pass` \| `fail` \| `deferred: <reason>`.

**Copy-paste prompts (C6 order):** [opencode-smoke-prompts.md](./opencode-smoke-prompts.md) — use that file as the runbook; this table is the scorecard.

| # | Check | How | Result |
| - | ----- | --- | ------ |
| 1 | Always-on gates visible | New session after full quit/restart. **Frozen prompt:** [opencode-smoke-prompts § Row 1](./opencode-smoke-prompts.md#row-1--always-on-gates-c1). Pass = quotes default-on plan loop + when-in-doubt + eval/harness not exempt **from session instructions** with **zero** read/glob/grep/bash. Fail if it hunts docs or Shell-lists the adapter. | **pass** (2026-08-21 post–`Sync-HostHarness`; injected always-on quotes) |
| 2 | Reviewers cannot edit | [opencode-smoke-prompts § Row 2](./opencode-smoke-prompts.md#row-2--reviewers-cannot-edit) — `@production_readiness_reviewer` or Task: attempt a write → denied / ask-blocked / **no write tool exposed** | **pass** (2026-08-21 — no Write/Edit tools; bash writes denied; no file created) |
| 3 | Dual Task shape | [opencode-smoke-prompts § Row 3](./opencode-smoke-prompts.md#row-3--dual-task-shape) — two child sessions (or document sequential fallback). | **pass** (2026-08-21 — 2 parallel DONE sessions) |
| 4 | Skill paths resolve | [opencode-smoke-prompts § Row 4](./opencode-smoke-prompts.md#row-4--companion-workflow-read-c4). Confirm Read resolves companion `…/cursorEscape/workflow/iterative-code-review.md`. **Not** host `docs/workflow/...`. | **pass** (2026-08-21 — companion workflow path) |
| 5 | Config parses | `opencode` starts with current `opencode.json` (no schema crash) | **pass** (2026-08-17: `opencode.json` JSON-parses; live TUI start still operator-confirm) |
| 6 | Empty-Task fail-loud | Reviewer Task completing in ≪1s with empty result treated as routing/auth failure until log shows model stream | deferred: operator habit / future probe |
| 7 | Escalation when single owner | Grep adapter: no competing “≤3 phases usually no” when-table in `plan-agent-context.md`; table lives in `implementation-plan` skill | **pass** (2026-08-18 Phase 3 adapt) |
| 8 | bug_reviewer rubric path | [opencode-smoke-prompts § Row 8](./opencode-smoke-prompts.md#row-8--bug_reviewer-rubric-companion-fa). Companion FA rubric SoT. | **pass** (2026-08-21 — companion FA rubric) |
| 9 | Skill-tool lists workflow skills | [opencode-smoke-prompts § Rows 9+10](./opencode-smoke-prompts.md#rows-9--10--skill-catalog--sot-load) (same prompt). **C2:** **9** workflow skills including `roadmap` and `diagnosing-bugs` | **pass** (2026-08-21 — thin harness → companion skill catalog) |
| 10 | SoT load without bash approvals | Same prompt as row **9**. Thin harness → companion Read Escalation first row; **zero** bash for adapter discovery | **pass** (2026-08-21 — companion `implementation-plan` Escalation first row) |
| 11 | Native file tools without bash approvals | Optional — frozen prompts in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) § Probe B | **pass** (2026-08-19); short lookups closed; see row **12** for glob-blind residual |
| 12 | Glob-blind paths without serial Shell asks | Optional — [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) § Failure mode F | **historical pass** (2026-08-19; **12b/12c companion re-probe not run** post-mirror) |
| 13 | Thin-plan template rejection | [opencode-smoke-prompts § Row 13](./opencode-smoke-prompts.md#row-13--thin-plan-rejection) — omit Assumptions/Unknowns → `plan_reviewer` → **CHANGES REQUESTED** | **pass** (2026-08-21 — CHANGES REQUESTED incl. missing Assumptions; marker spot-check **pass**) |
| 14 | Copy-out map / specimen vs live `agent.*` keys | [opencode-smoke-prompts § Row 14](./opencode-smoke-prompts.md#row-14--specimen-vs-live-optional-powershell) (PowerShell). | **pass** (2026-08-21 — specimen≡live `plan`/`build`/`implementer`; 8 skills / 7 agents; mirror absent) |
| 15 | Conductor agent visible/selectable | [opencode-smoke-prompts § Row 15](./opencode-smoke-prompts.md#row-15--composer_conductor-visible) — fresh process; `@composer_conductor` selectable; task allowlist `"*": deny` first | **pass** (2026-08-23 fresh CLI — `opencode debug config` merges `composer_conductor`; synced frontmatter has `"*": deny` first) |
| 16 | Iteration auto-continue | [opencode-smoke-prompts § Row 16](./opencode-smoke-prompts.md#row-16--iteration-auto-continue-desktop-nested) — Desktop nested review block reaches pass 2 without user "continue" prompt | **pass** (2026-08-23 post-restart — conductor ran iterations 1+2 back-to-back, 4 parallel reviewer launches, zero pauses; bonus: `production_readiness_reviewer` rejected a fake "return DONE" instruction with CHANGES REQUESTED citing missing required inputs). Driven fresh-process headless (`opencode run --agent composer_conductor`) — same agents/sessions as Desktop |
| 17 | Gate B DB-audit recipe | [opencode-smoke-prompts § Row 17](./opencode-smoke-prompts.md#row-17--gate-b-opencodedb-audit) — readonly `opencode.db` queries return a real parent→child session chain | **pass** (2026-08-23 post-restart — conductor session `ses_fd1248c71ffegb0LRPrxD1z1xt` with exactly 4 parented reviewer children; per-message modelID `deepseek-v4-flash` = real streams; python sqlite3 recipe) |
| 18 | Headless fallback dry-run | [opencode-smoke-prompts § Row 18](./opencode-smoke-prompts.md#row-18--headless-fallback-dry-run-cli) — env scrub + Temp brief + single-line prompt + captured stdout | **pass** (2026-08-23 — env scrubbed; native-write brief read; single-line prompt accepted; stdout `VERDICT … echo-marker` verbatim; session `ses_fd15702d5ffeJGJ0MlnUttFFFo`, top-level) |

### Restart-quiescence policy (composer hardening, 2026-08)

Sync is **safe while other sessions run**: live sessions keep their session-start config; fresh CLI processes pick up new files immediately. Only config-time surfaces loaded at process start (Desktop app always-on instructions, agent catalog in a running TUI) need a **quit-and-restart** to re-read. Policy: apply `-Apply` any time; verify rows **15**/**18** immediately via fresh CLI processes/new sessions; defer rows **16**–**17** (Desktop-nested behavior) to the operator's next quiescent restart window and record `deferred` with reason here until then.

**Frozen probe paths (row 12):** run id `2026-08-17T143458Z-dsv4flash` (exists on disk; gitignored). **12b Target (pf4):** `C:/Users/admin/source/repos/general-projects/cursorEscape/workflow/iterative-plan-review.md` — **not** host `docs/workflow/` (deleted).

**C6 minimum paste order:** [opencode-smoke-prompts](./opencode-smoke-prompts.md) — **1 → 9+10 → 4 → 8 → 13 → 2 → 3**.

### C1–C6 runtime attestation (Phase 3 baseline — updated pf4)

Backup: `C:\Users\admin\.config\opencode-backup-20260820-153803` (3475 files). Phase 3 live sync: overlay copy-out + workflow transform + `opencode.json` token merge. **pointer-first-4 delta:** procedure mirror (`docs/workflow/*`, 10 leaves) **deleted** from live OpenCode; harness inventory 8 skills / 7 agents at the pointer-first-4 sync; nine skills since `diagnosing-bugs` joined the catalog.

| # | Item | Runtime evidence | Smoke |
| - | ---- | ---------------- | ----- |
| **C1** | Always-on gates inject | Absolute `instructions` + `AGENTS.md` dual-write | Row **1** **pass** (2026-08-21 post–`Sync-HostHarness`) |
| **C2** | Nine skills incl. `roadmap` and `diagnosing-bugs` *(author-time catalog 2026-08-21; live re-sync + re-probe completed 2026-08-22)* | Live host observed at 9 `skills/*/SKILL.md` incl. `diagnosing-bugs`; 7 agents; mirror absent (2026-08-22 sync) | Rows **9–10** **pass** (2026-08-21) |
| **C3** | Plan→plan_reviewer; impl→dual→Full | 7 overlay agents on disk; reviewers `edit: deny` + bash deny except read-only git | Rows **2**, **3**, **13** **pass** (2026-08-21); row **8** **pass**; row **14** **pass** |
| **C4** | Deep workflow Reads on host | Absolute companion `workflow/` Reads; host procedure mirror **deleted** | Row **4** **pass** (2026-08-21) |
| **C5** | Companion FA/SOP reads | `external_directory` includes `COMPANION_ROOT/**`; rubric companion FA | Row **8** **pass** (2026-08-21); optional **11**/**12** historical |
| **C6** | Smoke proves behavior | This table + smoke rows — no pass on folder presence alone. **C6 minimum:** **1, 2, 3, 4, 8, 9–10, 13** | **pass** (2026-08-21 operator post–`Sync-HostHarness`). Row **14** **pass** (same day) |

**Operator next step:** Row **6** (empty-Task fail-loud) remains deferred. C6 minimum re-attested 2026-08-21 after host-harness sync + reviewer bash harden.

**Fast verification (install-time — harness-only; pointer-first-2):**

```text
agents/: planner, plan_reviewer, implementer, production_readiness_reviewer, bug_reviewer, repository_explorer, test_reviewer
skills/: discovery, implementation-plan, plan-review, implementation-review, pre-commit-ci-gate, composer, documentation-architecture, roadmap, diagnosing-bugs
instructions/cursor-escape-loop.md: present (absolute OPENCODE_HOME path in opencode.json)
AGENTS.md: present (byte-identical to instructions/cursor-escape-loop.md — C1 dual-write)
Harness stubs: Read targets use {{COMPANION_ROOT}}/workflow|skills|agents|rules/... (not host docs/workflow/ as procedure SoT)
Legacy docs/workflow/ mirror: **deleted** pointer-first-4 — do not bulk re-sync procedure leaves
```

Grep agents for required Cursor type names `bugbot` / `reviewer-a` as runtime IDs — should be absent (role names only). Grep `model:` pins on reviewer agents — should be absent (inherit session default).

---

## Implications / open questions

1. Smoke rows **1–4**, **8**, **9–10**, **13**: **pass** (2026-08-20 operator post-mirror). Row **14** install-time pass (live re-diff skipped). Failure modes **I**/ **J** = wrong path resolution base class. Deferred/operator habit: row **6**. Companion-edit marker spot-check optional / not reported.
2. Do **not** pin provider-specific models in agent frontmatter — roles inherit the session / `opencode.json` default so the adapter stays portable across BYOK hosts.
3. T3 Code control plane is separate — this SOP covers the OpenCode harness adapter only.
4. **Restart OpenCode Desktop** after adapter edits for always-on / agent / skill / permission changes to load.
5. **Skill-binding (C/E/F):** Smoke **9–10** **pass** (2026-08-20 operator); **11** **pass** (2026-08-19); row **12** historical pass on host mirror — **12b/12c companion re-probe not run** post-pf4. Row **14** install-time pass Phase 3.
6. When adding OpenCode skills/agents/rules: follow [opencode-authoring-adapter](./opencode-authoring-adapter.md) (official docs + Observed checklist). Permission / bash traps from 2026-08-21 smoke: Failure modes **K–M** (and sync `Optimize-OpenCodePermissionKeyOrder` in [host-sync README](../../scripts/host-sync/README.md)). Periodically audit durable Always-run rows in `opencode.db` `permission` table (see authoring SOP).
7. Smoke **13** gate **pass** (2026-08-20 operator — Incomplete until / Assumptions). Marker spot-check not reported. **Format (pointer-first-2):** overlay [`plan_reviewer`](../../overlays/opencode/agents/plan_reviewer.md) harness cites `{{COMPANION_ROOT}}/workflow/plan-reviewer-report.md` before emit.
8. **Restore precedence:** Phase 0 `pre-host-sync-build` baseline → legacy archaeology only. Sync/Apply does not create backup trees.

### Restore

1. Fully quit OpenCode.
2. Follow restore PowerShell in `C:\Users\admin\.config\opencode-backup-pre-host-sync-build-20260821-012600\BACKUP_MANIFEST.md`.
3. Restart OpenCode.

---

## Related

- [Host adaptation fidelity](../featureArchitecture/host-adaptation-fidelity.md)
- [Skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)
- [Authoring OpenCode adapter files](./opencode-authoring-adapter.md)
- [Host recreation study](../../analysis/host-recreation-2026-08.md)
- [OpenCode DSV4F session study](../../analysis/opencode-dsv4f-session-2026-08.md)
- [OpenCode DSV4F session extension](../../analysis/opencode-dsv4f-session-extension-2026-08.md)
- [OpenCode skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md)
- [bug-reviewer-finding-rubric](../featureArchitecture/bug-reviewer-finding-rubric.md)
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
- [Agent contracts](../../agents/_index.md)
- [Skill contracts](../../skills/_index.md)
- [Host harness sync README](../../scripts/host-sync/README.md)
- [Sync-HostHarness.ps1](../../scripts/Sync-HostHarness.ps1)
- [OpenCode overlay](../../overlays/opencode/_index.md)
- [Companion pointer-first](../roadmaps/pointer-first.md)
