# OpenCode host adapter

**Last updated:** 2026-08-20

## Context

This SOP documents the **global OpenCode adapter** installed on the operator machine for R0 live trial of the cursorEscape loop. **Target SoT** is this companion repo ([skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md), [agents](../../agents/_index.md), [skills](../../skills/_index.md)). Files under `~/.config/opencode/` are the **host adapter / copy-out target**, not a second procedure tree. **OpenCode host-plugged harness copy-out is authorized and applied** from [overlays/opencode](../../overlays/opencode/_index.md) (Phase 3 live sync 2026-08-20; backup first). **Procedure mirror deleted** pointer-first-4 (2026-08-20). **C6 minimum smoke rows 1–4, 8, 9–10, 13: pass** (2026-08-20 operator post-mirror). Row **14**: install-time pass (live re-diff optional/skipped). See [pointer-first-4 closeout](../../analysis/pointer-first-4-closeout-2026-08.md).

**Install root (this machine):** `C:\Users\admin\.config\opencode\`

---

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

- `discovery`, `implementation-plan` (Escalation *when* SoT), `plan-review`, `implementation-review`, `pre-commit-ci-gate`, `composer`, `documentation-architecture`, **`roadmap`**

**Agents**

- `planner`, `plan_reviewer`, `implementer` (primary), `production_readiness_reviewer`, `bug_reviewer` (loads finding rubric), `repository_explorer`, `test_reviewer` (optional; Task permission `ask`)

**Deep docs (pointer-first Target)**

- Companion `{{COMPANION_ROOT}}/workflow/` — sole procedure SoT; harness Reads absolute paths (smoke row **4** locked How)
- Companion `{{COMPANION_ROOT}}/docs/featureArchitecture/bug-reviewer-finding-rubric.md` — rubric SoT (smoke row **8**)
- [review-subagent-models.md](../../overlays/opencode/review-subagent-models.md) — thin overlay leaf; companion overlay-Read only (not host mirror)

**Config hooks**

- **Skills inventory:** each `skills/*/SKILL.md` must include frontmatter `name` (folder id) + `description` — required for skill-tool advertisement (Observed 2026-08-19).
- `opencode.json` — `instructions`; `permission.skill: { "*": "allow" }`; `skills.paths` → global skills dir; `agent.build` / `agent.implementer` `permission.task` allowlists (+ skill allow).
- **Resolved (discovery 2026-08-19):** empty skill-tool catalog was missing `name` / path registration, not contamination. See [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md).

### Sync rule

1. Update **cursorEscape** contracts first (Target FA / agents / skills / overlay rules).
2. Re-adapt OpenCode files second — do not invent gate semantics only in `~/.config/opencode`.
3. When updating always-on gates: edit overlay `instructions/cursor-escape-loop.md`, copy the **same body** to live `instructions/` **and** `AGENTS.md` (byte-identical — required for C1); keep specimen `instructions` as `{{OPENCODE_HOME}}/…` absolute form.
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

| # | Check | How | Result |
| - | ----- | --- | ------ |
| 1 | Always-on gates visible | New session after full quit/restart. **Frozen prompt** (no tools): see [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) § C1 smoke (row 1). Pass = quotes default-on plan loop + when-in-doubt + eval/harness not exempt **from session instructions** with **zero** read/glob/grep/bash. Fail if it hunts docs or Shell-lists the adapter. | **pass** (2026-08-20 operator post-mirror) |
| 2 | Reviewers cannot edit | `@production_readiness_reviewer` or Task: attempt a write → denied / ask-blocked / **no write tool exposed** | **pass** (2026-08-20 operator — no write tool; no mutation) |
| 3 | Dual Task shape | Instruct parent to launch both reviewers in one turn → two child sessions (or document sequential fallback). Operator may use a minimal “return done” task if the host refuses empty review without a changeset. | **pass** (2026-08-20 operator — 2 parallel DONE sessions) |
| 4 | Skill paths resolve | **LOCKED (pointer-first-0):** Load skill `implementation-review`; confirm Read resolves companion `{{COMPANION_ROOT}}/workflow/iterative-code-review.md` (absolute e.g. `C:/Users/admin/source/repos/general-projects/cursorEscape/workflow/iterative-code-review.md`). **Not** host `docs/workflow/...` (mirror **deleted** pf4). | **pass** (2026-08-20 operator — companion workflow path) |
| 5 | Config parses | `opencode` starts with current `opencode.json` (no schema crash) | **pass** (2026-08-17: `opencode.json` JSON-parses; live TUI start still operator-confirm) |
| 6 | Empty-Task fail-loud | Reviewer Task completing in ≪1s with empty result treated as routing/auth failure until log shows model stream | deferred: operator habit / future probe |
| 7 | Escalation when single owner | Grep adapter: no competing “≤3 phases usually no” when-table in `plan-agent-context.md`; table lives in `implementation-plan` skill | **pass** (2026-08-18 Phase 3 adapt) |
| 8 | bug_reviewer rubric path | **LOCKED (pointer-first-0):** confirm Read resolves companion `{{COMPANION_ROOT}}/docs/featureArchitecture/bug-reviewer-finding-rubric.md` (Target SoT). Host mirror **deleted** pf4. | **pass** (2026-08-20 operator — companion FA rubric) |
| 9 | Skill-tool lists workflow skills | Clean chat (plan mode; Flash): skill tool names include `implementation-plan`, `plan-review`, `implementation-review`, `composer`, `discovery`, `documentation-architecture`, `pre-commit-ci-gate`, **`roadmap`** — not only `customize-opencode`. Prompt in [pointer-first-4 closeout](../../analysis/pointer-first-4-closeout-2026-08.md) (pointer-first Probe A). **C2:** **8** workflow skills including `roadmap` | **pass** (2026-08-20 operator — 8 + `customize-opencode`) |
| 10 | SoT load without bash approvals | Same Probe A (pointer-first): load `implementation-plan` via skill tool; thin harness may omit when-table — **pass** if Escalation first row is quoted from companion `{{COMPANION_ROOT}}/skills/implementation-plan/SKILL.md` via native Read with **zero** bash approvals for adapter discovery | **pass** (2026-08-20 operator — thin harness → companion Read) |
| 11 | Native file tools without bash approvals | Clean chat Probe **B0′/B0″** + **C** (`repository_explorer`): frozen prompts in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) | **pass** (2026-08-19); short lookups closed; see row **12** for glob-blind residual |
| 12 | Glob-blind paths without serial Shell asks | openBuggy workspace; frozen prompts in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) § Failure mode F — (a) glob `eval/runs/2026-08-17T143458Z-dsv4flash/**`; (b) absolute `read` **companion** workflow doc `{{COMPANION_ROOT}}/workflow/iterative-plan-review.md`; (c) `Test-Path` on companion path once → **0** listing approvals | **historical pass** (2026-08-19 host mirror for 12b/c; pf4 How retargeted to companion — **12b/12c re-probe not run** post-mirror) |
| 13 | Thin-plan template rejection | Clean chat; Flash; frozen prompt in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) § Thin-plan smoke (row 13) — omit Assumptions/Unknowns → invoke `plan_reviewer` → **CHANGES REQUESTED** citing those gaps | **pass** (2026-08-20 operator — CHANGES REQUESTED for Assumptions; marker spot-check not reported) |
| 14 | Copy-out map / specimen vs live `agent.*` keys | Diff [overlays/opencode/opencode.specimen.json](../../overlays/opencode/opencode.specimen.json) vs live `~/.config/opencode/opencode.json` for all `agent.*` keys; confirm [overlay copy-out map](../../overlays/opencode/_index.md) matches host-plugged paths before live sync. Record on overlay `_index` § Specimen vs live. **How frozen Phase 2.** | **pass** (install-time, Phase 3 2026-08-20): specimen vs live `agent.*` JSON diff — all six overlay keys match; `agent.implementer.permission.task.implementer` = `allow` verified on live; harness inventory **8 skills / 7 agents** (procedure mirror deleted pf4) |

**Frozen probe paths (row 12):** run id `2026-08-17T143458Z-dsv4flash` (exists on disk; gitignored). **12b Target (pf4):** `C:/Users/admin/source/repos/general-projects/cursorEscape/workflow/iterative-plan-review.md` — **not** host `docs/workflow/` (deleted).

**Frozen probe (row 13):** see [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) § Thin-plan smoke (row 13). **pass** (2026-08-20 operator post-mirror).

### C1–C6 runtime attestation (Phase 3 baseline — updated pf4)

Backup: `C:\Users\admin\.config\opencode-backup-20260820-153803` (3475 files). Phase 3 live sync: overlay copy-out + workflow transform + `opencode.json` token merge. **pointer-first-4 delta:** procedure mirror (`docs/workflow/*`, 10 leaves) **deleted** from live OpenCode; harness inventory now **8 skills / 7 agents** only.

| # | Item | Runtime evidence | Smoke |
| - | ---- | ---------------- | ----- |
| **C1** | Always-on gates inject | Absolute `instructions` + `AGENTS.md` dual-write (2026-08-20 remediation) | Row **1** **pass** (2026-08-20 operator post-mirror) |
| **C2** | Eight skills incl. `roadmap` | 8 `skills/*/SKILL.md` with matching `name` frontmatter on live host | Rows **9–10** **pass** (2026-08-20 operator) |
| **C3** | Plan→plan_reviewer; impl→dual→Full | 7 overlay agents on disk; reviewers `permission.edit: deny`; loops cite `{{COMPANION_ROOT}}/workflow/iterative-*` and companion FA rubric | Rows **2**, **3**, **13** **pass** (2026-08-20 operator); row **8** **pass**; row **14** install-time pass |
| **C4** | Deep workflow Reads on host | Hubs + smoke row **4** How cite absolute `{{COMPANION_ROOT}}/workflow/...`; harness bodies use absolute `{{COMPANION_ROOT}}/...` Reads after pointer-first-2; host procedure mirror **deleted** pf4 | Row **4** **pass** (2026-08-20 operator — companion path) |
| **C5** | Companion FA/SOP reads | `external_directory` includes `COMPANION_ROOT/**`; sample FA `read` OK; rubric = `{{COMPANION_ROOT}}/docs/featureArchitecture/bug-reviewer-finding-rubric.md` | Optional **11** prior pass; row **12** historical (12b/c not re-run post-pf4); companion read verified Phase 3 Fast CI |
| **C6** | Smoke proves behavior | This table + smoke rows — no pass on folder/skill-path presence alone. **C6 minimum set:** **1, 2, 3, 4, 8, 9–10, 13** (row **14** install-time — separate) | **pass** (2026-08-20 operator C6 minimum rows **1–4**, **8**, **9–10**, **13**). Row **14**: install-time pass (live re-diff skipped) |

**Operator next step:** Row **6** (empty-Task fail-loud) remains deferred operator habit. C6 minimum attested in [pointer-first-4 closeout](../../analysis/pointer-first-4-closeout-2026-08.md).

**Fast verification (install-time — harness-only; pointer-first-2):**

```text
agents/: planner, plan_reviewer, implementer, production_readiness_reviewer, bug_reviewer, repository_explorer, test_reviewer
skills/: discovery, implementation-plan, plan-review, implementation-review, pre-commit-ci-gate, composer, documentation-architecture, roadmap
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
6. When adding OpenCode skills/agents/rules: follow [opencode-authoring-adapter](./opencode-authoring-adapter.md) (official docs + Observed checklist). Periodically audit durable Always-run rows in `opencode.db` `permission` table (see authoring SOP).
7. Smoke **13** gate **pass** (2026-08-20 operator — Incomplete until / Assumptions). Marker spot-check not reported. **Format (pointer-first-2):** overlay [`plan_reviewer`](../../overlays/opencode/agents/plan_reviewer.md) harness cites `{{COMPANION_ROOT}}/workflow/plan-reviewer-report.md` before emit.

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
- [OpenCode overlay](../../overlays/opencode/_index.md)
- [Companion pointer-first](../roadmaps/pointer-first.md)
