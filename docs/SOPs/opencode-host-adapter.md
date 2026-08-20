# OpenCode host adapter

**Last updated:** 2026-08-20

## Context

This SOP documents the **global OpenCode adapter** installed on the operator machine for R0 live trial of the cursorEscape loop. **Target SoT** is this companion repo ([skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md), [agents](../../agents/_index.md), [skills](../../skills/_index.md)). Files under `~/.config/opencode/` are the **host adapter / copy-out target**, not a second procedure tree. **OpenCode host-plugged harness copy-out is authorized and applied** from [overlays/opencode](../../overlays/opencode/_index.md) (Phase 3 live sync 2026-08-20; backup first). Runtime smoke rows **1–4**, **9–10**, **13** **pass** (2026-08-20) per smoke table below.

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
| Deep workflow docs | Companion [workflow/](../../workflow/_index.md) at `{{COMPANION_ROOT}}/workflow/*.md` | **Absolute companion Read** (locked smoke row **4** How). Legacy host `docs/workflow/*` mirror is transitional only — not SoT ([pointer-first](../roadmaps/pointer-first.md)) |
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
- Legacy host `docs/workflow/` — transitional mirror from Phase 3; rubric Target = `{{COMPANION_ROOT}}/docs/featureArchitecture/bug-reviewer-finding-rubric.md` (not host mirror SoT)
- [review-subagent-models.md](../../overlays/opencode/review-subagent-models.md) — thin overlay leaf under `overlays/opencode/` (not companion `workflow/`)

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
- `bug_reviewer` follows companion Target rubric at `{{COMPANION_ROOT}}/docs/featureArchitecture/bug-reviewer-finding-rubric.md` (legacy host `docs/workflow/bug-reviewer-finding-rubric.md` transitional only).

### Smoke checklist (R0)

Record results when running live checks. Expected: `pass` \| `fail` \| `deferred: <reason>`.

| # | Check | How | Result |
| - | ----- | --- | ------ |
| 1 | Always-on gates visible | New session after full quit/restart. **Frozen prompt** (no tools): see [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) § C1 smoke (row 1). Pass = quotes default-on plan loop + when-in-doubt + eval/harness not exempt **from session instructions** with **zero** read/glob/grep/bash. Fail if it hunts docs or Shell-lists the adapter. | **pass** (2026-08-20 re-probe after Failure mode I fix): quoted default-on + when-in-doubt + eval/harness from session-injected always-on |
| 2 | Reviewers cannot edit | `@production_readiness_reviewer` or Task: attempt a write → denied / ask-blocked | **pass** (2026-08-20): parent refused write — reviewer is edit-deny / read-only (C3) |
| 3 | Dual Task shape | Instruct parent to launch both reviewers in one turn → two child sessions (or document sequential fallback). Operator may use a minimal “return done” task if the host refuses empty review without a changeset. | **pass** (2026-08-20): dual children both returned done (minimal probe after refuse-without-changeset) |
| 4 | Skill paths resolve | **LOCKED (pointer-first-0):** Load skill `implementation-review`; confirm Read resolves companion `{{COMPANION_ROOT}}/workflow/iterative-code-review.md` (absolute e.g. `C:/Users/admin/source/repos/general-projects/cursorEscape/workflow/iterative-code-review.md`). **Not** host `docs/workflow/...` as Target SoT; **not** `../../docs/workflow/...` (Failure mode J). Legacy mirror pass on host disk is transitional only until pointer-first-4. | **pass** (2026-08-20 historical re-probe on legacy mirror path; **Target How locked** to companion path for pointer-first-2+ stub rewrite) |
| 5 | Config parses | `opencode` starts with current `opencode.json` (no schema crash) | **pass** (2026-08-17: `opencode.json` JSON-parses; live TUI start still operator-confirm) |
| 6 | Empty-Task fail-loud | Reviewer Task completing in ≪1s with empty result treated as routing/auth failure until log shows model stream | deferred: operator habit / future probe |
| 7 | Escalation when single owner | Grep adapter: no competing “≤3 phases usually no” when-table in `plan-agent-context.md`; table lives in `implementation-plan` skill | **pass** (2026-08-18 Phase 3 adapt) |
| 8 | bug_reviewer rubric path | **LOCKED (pointer-first-0):** `agents/bug_reviewer.md` harness cites rubric; confirm Read resolves companion `{{COMPANION_ROOT}}/docs/featureArchitecture/bug-reviewer-finding-rubric.md` (Target SoT — e.g. `C:/Users/admin/source/repos/general-projects/cursorEscape/docs/featureArchitecture/bug-reviewer-finding-rubric.md`). Legacy host `docs/workflow/bug-reviewer-finding-rubric.md` pass only while mirror transitional; no `model:` pin | **pass** (2026-08-20 historical probe on legacy mirror path; **Target How locked** to companion FA for pointer-first-2 harness rewrite) |
| 9 | Skill-tool lists workflow skills | Clean chat (openBuggy; plan mode; Flash): skill tool names include `implementation-plan`, `plan-review`, `implementation-review`, `composer`, `discovery`, `documentation-architecture`, `pre-commit-ci-gate`, **`roadmap`** — not only `customize-opencode`. Prompt frozen in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md). **C2 bar (Phase 2+):** expected catalog = **8 workflow skills including `roadmap`** — update this row’s How + Probe A when overlay ships; **How frozen Phase 2; re-probe row 9 after Phase 3 live sync** | **pass** (2026-08-20): listed 8 workflow skills + `customize-opencode` (incl. `roadmap`) |
| 10 | SoT load without bash approvals | Same Probe A: load `implementation-plan` via skill tool with **zero** bash approvals for that SoT load | **pass** (2026-08-20): loaded `implementation-plan`; Escalation first row `yes` + `user-labeled-composer` |
| 11 | Native file tools without bash approvals | Clean chat Probe **B0′/B0″** + **C** (`repository_explorer`): frozen prompts in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) | **pass** (2026-08-19); short lookups closed; see row **12** for glob-blind residual |
| 12 | Glob-blind paths without serial Shell asks | openBuggy workspace; frozen prompts in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) § Failure mode F — (a) glob `eval/runs/2026-08-17T143458Z-dsv4flash/**`; (b) absolute `read` adapter workflow doc; (c) `Test-Path` once → **0** listing approvals | **pass** (2026-08-19): 12a non-empty glob; 12b Skill line quoted; 12c `Test-Path` → True |
| 13 | Thin-plan template rejection | Clean chat; Flash; frozen prompt in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) § Thin-plan smoke (row 13) — omit Assumptions/Unknowns → invoke `plan_reviewer` → **CHANGES REQUESTED** citing those gaps | **pass** (2026-08-20): CHANGES REQUESTED; blocking Missing Assumptions (+ Architecture and docs unlabeled; SOP compliance). **Format note:** OpenCode overlay `plan_reviewer` Outputs are thin vs companion L3 [`workflow/plan-reviewer-report.md`](../../workflow/plan-reviewer-report.md) (output limits, severity, overflow, exact report structure) — portable [`agents/plan_reviewer.md`](../../agents/plan_reviewer.md) is thinned and **Read when** points at that leaf; gate bar met; overlay report shape not parity until pointer-first-2 (see Implications). |
| 14 | Copy-out map / specimen vs live `agent.*` keys | Diff [overlays/opencode/opencode.specimen.json](../../overlays/opencode/opencode.specimen.json) vs live `~/.config/opencode/opencode.json` for all `agent.*` keys; confirm [overlay copy-out map](../../overlays/opencode/_index.md) matches host-plugged paths before live sync. Record on overlay `_index` § Specimen vs live. **How frozen Phase 2.** | **pass** (Phase 3 2026-08-20): specimen vs live `agent.*` JSON diff — all six overlay keys match (`agent.plan`, `agent.build.permission.{skill,bash,task}`, `agent.implementer.{mode,permission.task}`); `agent.implementer.permission.task.implementer` = `allow` verified on live; overlay `_index` § Specimen vs live updated; copy-out map inventory zero drift (8 skills / 7 agents / 10 workflow leaves) |

**Frozen probe paths (row 12):** run id `2026-08-17T143458Z-dsv4flash` (exists on disk; gitignored). Adapter doc: `C:/Users/admin/.config/opencode/docs/workflow/iterative-plan-review.md`.

**Frozen probe (row 13):** see [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) § Thin-plan smoke (row 13). **pass** (2026-08-20).

### C1–C6 runtime attestation (Phase 3 — 2026-08-20)

Backup: `C:\Users\admin\.config\opencode-backup-20260820-153803` (3475 files). Live sync: overlay copy-out + workflow transform + `opencode.json` token merge (`COMPANION_ROOT`, `OPENCODE_HOME` resolved; `model`/`provider` preserved; `implementer.task.implementer` = `allow`). Inventory drift: zero extra/missing host-plugged leaves; `node_modules` preserved.

| # | Item | Runtime evidence | Smoke |
| - | ---- | ---------------- | ----- |
| **C1** | Always-on gates inject | Absolute `instructions` + `AGENTS.md` dual-write (2026-08-20 remediation) | Row **1** **pass** (re-probe after Failure mode I) |
| **C2** | Eight skills incl. `roadmap` | 8 `skills/*/SKILL.md` with matching `name` frontmatter on live host | Rows **9–10** **pass** (2026-08-20 Probe A) |
| **C3** | Plan→plan_reviewer; impl→dual→Full | 7 overlay agents on disk; reviewers `permission.edit: deny` in agent frontmatter; loops cited in bodies | Rows **2**, **3**, **13** **pass**; row **8** pass; row **14** pass. **Open:** overlay `plan_reviewer` report shape thinner than companion L3 [`workflow/plan-reviewer-report.md`](../../workflow/plan-reviewer-report.md) until pointer-first-2 |
| **C4** | Deep workflow Reads on host | Hubs + smoke row **4** How cite absolute `{{COMPANION_ROOT}}/workflow/...` (Target); harness bodies still transitional host-root `docs/workflow/...` until pointer-first-2 | Row **4** — companion How locked; historical pass on legacy mirror path |
| **C5** | Companion FA/SOP reads | `external_directory` includes `COMPANION_ROOT/**`; sample FA `read` OK; rubric = `{{COMPANION_ROOT}}/docs/featureArchitecture/bug-reviewer-finding-rubric.md` | Optional 11–12 prior pass; companion read verified Phase 3 Fast CI |
| **C6** | Smoke proves behavior | This table + smoke rows — no pass on folder/skill-path presence alone. Minimum set **1, 2, 3, 4, 8, 9–10, 13, 14** — row **4** How locked to `{{COMPANION_ROOT}}/workflow/`; rubric probe uses companion FA path | Minimum set **1, 2, 3, 4, 8, 9–10, 13, 14** — install-time **8** (content grep), **14** (`agent.*` key diff) pass; row **4** Target = companion path |

**Operator next step:** After pointer-first-2 stub rewrite, re-probe row **4** on absolute companion `{{COMPANION_ROOT}}/workflow/iterative-code-review.md`. Row **6** (empty-Task fail-loud) remains deferred operator habit.

**Fast verification (install-time):**

```text
agents/: planner, plan_reviewer, implementer, production_readiness_reviewer, bug_reviewer, repository_explorer, test_reviewer
skills/: discovery, implementation-plan, plan-review, implementation-review, pre-commit-ci-gate, composer, documentation-architecture, roadmap
docs/workflow/: present (incl. bug-reviewer-finding-rubric.md, plan-agent-context.md)
instructions/cursor-escape-loop.md: present
AGENTS.md: present (byte-identical to instructions/cursor-escape-loop.md — C1 dual-write)
```

Grep agents for required Cursor type names `bugbot` / `reviewer-a` as runtime IDs — should be absent (role names only). Grep `model:` pins on reviewer agents — should be absent (inherit session default).

---

## Implications / open questions

1. Smoke rows **1–4**, **9–10**, **13** **pass** (2026-08-20). Failure modes **I**/ **J** = wrong path resolution base class. Rows **8**, **14** **pass** install-time. Deferred/operator habit: row **6**.
2. Do **not** pin provider-specific models in agent frontmatter — roles inherit the session / `opencode.json` default so the adapter stays portable across BYOK hosts.
3. T3 Code control plane is separate — this SOP covers the OpenCode harness adapter only.
4. **Restart OpenCode Desktop** after adapter edits for always-on / agent / skill / permission changes to load.
5. **Skill-binding (C/E/F):** Smoke **9–12** **pass** (row 9–10 2026-08-20 eight-skill catalog; 11–12 prior). Row **14** **pass** Phase 3.
6. When adding OpenCode skills/agents/rules: follow [opencode-authoring-adapter](./opencode-authoring-adapter.md) (official docs + Observed checklist). Periodically audit durable Always-run rows in `opencode.db` `permission` table (see authoring SOP).
7. Smoke **13** gate **pass** (Incomplete until). **Format fidelity gap (Observed):** OpenCode overlay [`plan_reviewer`](../../overlays/opencode/agents/plan_reviewer.md) **Outputs** only require Verdict + Blocking + outstanding changes. Companion L3 SoT [`workflow/plan-reviewer-report.md`](../../workflow/plan-reviewer-report.md) holds output limits, severity ranking, overflow lines, and exact report structure (Findings summary, Assumptions table, Unknowns, External dependencies, Areas requiring verification, A/B/C, Cost challenge, Failure forecast, Incremental execution, Verification gaps, Architecture alignment, caps/overflow). Portable [`agents/plan_reviewer.md`](../../agents/plan_reviewer.md) is thinned and **Read when** points at that leaf — do **not** paste the schema into the agent body. Short OpenCode overlay reports are primarily **thin overlay authoring** (pointer-first-2 scope), not smoke failure — weak models amplify the gap. Restore parity via explicit `{{COMPANION_ROOT}}/workflow/plan-reviewer-report.md` Read in the overlay harness when operator expects full review shape.

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
