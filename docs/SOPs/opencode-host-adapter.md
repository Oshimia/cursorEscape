# OpenCode host adapter

**Last updated:** 2026-08-20

## Context

This SOP documents the **global OpenCode adapter** installed on the operator machine for R0 live trial of the cursorEscape loop. **Target SoT** is this companion repo ([skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md), [agents](../../agents/_index.md), [skills](../../skills/_index.md)). Files under `~/.config/opencode/` are the **host adapter / copy-out target**, not a second procedure tree. **OpenCode host-plugged copy-out is authorized and applied** from [overlays/opencode](../../overlays/opencode/_index.md) (Phase 3 live sync 2026-08-20; backup first). Desktop runtime smoke deferred operator — see smoke table below.

**Install root (this machine):** `C:\Users\admin\.config\opencode\`

---

## Substance

### Must / Must-not (host adaptation fidelity)

**Must:** Meet [host-adaptation-fidelity](../featureArchitecture/host-adaptation-fidelity.md) — same operator loops as Cursor; C1–C6 matrix at runtime; smoke proves behavior, not folder presence.

**Must-not:** Mark adapter **Done** on inventory alone; deploy Cursor `rules/` tree on OpenCode; ship skills without `name` frontmatter; skip dual Task review or deny-edit on reviewers.

### Layer map

| Layer | Portable contract | OpenCode adapter path |
| ----- | ----------------- | --------------------- |
| Always-on (thin) | Gate pointers only | `instructions/cursor-escape-loop.md` (wired via `opencode.json` → `instructions`) |
| Skills (on-demand) | [skills/](../../skills/_index.md) | `skills/*/SKILL.md` |
| Deep workflow docs | Imported/adapted procedures | `docs/workflow/*.md` (incl. `bug-reviewer-finding-rubric.md`, `plan-agent-context.md`) |
| Role agents | [agents/](../../agents/_index.md) | `agents/*.md` (`permission.edit: deny` on reviewers) |

### Inventory

**Always-on**

- `instructions/cursor-escape-loop.md` — default-on plan + dual review; Incomplete until / template-fidelity pointer; when in doubt; eval/harness not exempt; empty-Task fail-loud note

**Skills**

- `discovery`, `implementation-plan` (Escalation *when* SoT), `plan-review`, `implementation-review`, `pre-commit-ci-gate`, `composer`, `documentation-architecture`, **`roadmap`**

**Agents**

- `planner`, `plan_reviewer`, `implementer` (primary), `production_readiness_reviewer`, `bug_reviewer` (loads finding rubric), `repository_explorer`, `test_reviewer` (optional; Task permission `ask`)

**Deep docs**

- `docs/workflow/` — discovery, iterative-plan-review, iterative-code-review, ci-ladder, plan-agent-context (specimen + pointer), phased-multi-agent, review-subagent-models, documentation-architecture, bug-reviewer-finding-rubric, README

**Config hooks**

- **Skills inventory:** each `skills/*/SKILL.md` must include frontmatter `name` (folder id) + `description` — required for skill-tool advertisement (Observed 2026-08-19).
- `opencode.json` — `instructions`; `permission.skill: { "*": "allow" }`; `skills.paths` → global skills dir; `agent.build` / `agent.implementer` `permission.task` allowlists (+ skill allow).
- **Resolved (discovery 2026-08-19):** empty skill-tool catalog was missing `name` / path registration, not contamination. See [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md).

### Sync rule

1. Update **cursorEscape** contracts first (Target FA / agents / skills / overlay rules).
2. Re-adapt OpenCode files second — do not invent gate semantics only in `~/.config/opencode`.
3. Do **not** commit `~/.config/opencode` into this git repo (secrets, machine paths, provider plugins). Copy-out later still excludes secrets.
4. After saving changes to `opencode.json`, an agent file, a skill, instructions, or other config-time file: **quit and restart OpenCode** (no hot-reload — DSV4F Observed).

### Dual review on OpenCode

- **One** OpenCode session; **two** Task children (`production_readiness_reviewer` ∥ `bug_reviewer`).
- Not two T3 worktrees.
- Parent owns Observed Fast CI; reviewers `edit: deny`.
- Split envelope: locked opener on production_readiness; Custom Instructions on bug_reviewer.
- `bug_reviewer` follows `docs/workflow/bug-reviewer-finding-rubric.md`.

### Smoke checklist (R0)

Record results when running live checks. Expected: `pass` \| `fail` \| `deferred: <reason>`.

| # | Check | How | Result |
| - | ----- | --- | ------ |
| 1 | Always-on gates visible | New session; ask model to quote default-on plan loop + when-in-doubt + eval/harness not exempt from always-on | deferred: operator — Phase 3 sync complete; restart OpenCode Desktop then probe (C1) |
| 2 | Reviewers cannot edit | `@production_readiness_reviewer` or Task: attempt a write → denied / ask-blocked | deferred: operator — Phase 3 sync complete; restart OpenCode Desktop then probe (C3) |
| 3 | Dual Task shape | Instruct parent to launch both reviewers in one turn → two child sessions (or document sequential fallback) | deferred: operator — Phase 3 sync complete; restart OpenCode Desktop then probe (C3) |
| 4 | Skill paths resolve | Load skill `implementation-review`; confirm `../../docs/workflow/iterative-code-review.md` exists on disk | deferred: operator — mirrored path on disk + hop greps zero (Phase 3 Fast CI); skill-tool load per How after restart (C4 runtime) |
| 5 | Config parses | `opencode` starts with current `opencode.json` (no schema crash) | **pass** (2026-08-17: `opencode.json` JSON-parses; live TUI start still operator-confirm) |
| 6 | Empty-Task fail-loud | Reviewer Task completing in ≪1s with empty result treated as routing/auth failure until log shows model stream | deferred: operator habit / future probe |
| 7 | Escalation when single owner | Grep adapter: no competing “≤3 phases usually no” when-table in `plan-agent-context.md`; table lives in `implementation-plan` skill | **pass** (2026-08-18 Phase 3 adapt) |
| 8 | bug_reviewer rubric path | `agents/bug_reviewer.md` references `docs/workflow/bug-reviewer-finding-rubric.md`; file exists; no `model:` pin | **pass** (Phase 3 Fast CI 2026-08-20: rubric on disk; agent cites path; no `model:` pin) |
| 9 | Skill-tool lists workflow skills | Clean chat (openBuggy; plan mode; Flash): skill tool names include `implementation-plan`, `plan-review`, `implementation-review`, `composer`, `discovery`, `documentation-architecture`, `pre-commit-ci-gate`, **`roadmap`** — not only `customize-opencode`. Prompt frozen in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md). **C2 bar (Phase 2+):** expected catalog = **8 workflow skills including `roadmap`** — update this row’s How + Probe A when overlay ships; **How frozen Phase 2; re-probe row 9 after Phase 3 live sync** | deferred: operator — Phase 3 overlay sync on disk (8 skills with `name`); restart OpenCode Desktop then re-probe Probe A for C2 runtime |
| 10 | SoT load without bash approvals | Same Probe A: load `implementation-plan` via skill tool with **zero bash approvals** for that SoT load | deferred: operator — re-probe with row 9 after restart (C2) |
| 11 | Native file tools without bash approvals | Clean chat Probe **B0′/B0″** + **C** (`repository_explorer`): frozen prompts in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) | **pass** (2026-08-19); short lookups closed; see row **12** for glob-blind residual |
| 12 | Glob-blind paths without serial Shell asks | openBuggy workspace; frozen prompts in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) § Failure mode F — (a) glob `eval/runs/2026-08-17T143458Z-dsv4flash/**`; (b) absolute `read` adapter workflow doc; (c) `Test-Path` once → **0** listing approvals | **pass** (2026-08-19): 12a non-empty glob; 12b Skill line quoted; 12c `Test-Path` → True |
| 13 | Thin-plan template rejection | Clean chat; Flash; frozen prompt in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) § Thin-plan smoke (row 13) — omit Assumptions/Unknowns → invoke `plan_reviewer` → **CHANGES REQUESTED** citing those gaps | deferred: operator — prior pass 2026-08-19; re-probe after Phase 3 restart if overlay agents changed materially (C3) |
| 14 | Copy-out map / specimen vs live `agent.*` keys | Diff [overlays/opencode/opencode.specimen.json](../../overlays/opencode/opencode.specimen.json) vs live `~/.config/opencode/opencode.json` for all `agent.*` keys; confirm [overlay copy-out map](../../overlays/opencode/_index.md) matches host-plugged paths before live sync. Record on overlay `_index` § Specimen vs live. **How frozen Phase 2.** | **pass** (Phase 3 2026-08-20): specimen vs live `agent.*` JSON diff — all six overlay keys match (`agent.plan`, `agent.build.permission.{skill,bash,task}`, `agent.implementer.{mode,permission.task}`); `agent.implementer.permission.task.implementer` = `allow` verified on live; overlay `_index` § Specimen vs live updated; copy-out map inventory zero drift (8 skills / 7 agents / 10 workflow leaves) |

**Frozen probe paths (row 12):** run id `2026-08-17T143458Z-dsv4flash` (exists on disk; gitignored). Adapter doc: `C:/Users/admin/.config/opencode/docs/workflow/iterative-plan-review.md`.

**Frozen probe (row 13):** see [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) § Thin-plan smoke (row 13). Prior **pass** 2026-08-19; deferred re-probe after Phase 3 restart.

### C1–C6 runtime attestation (Phase 3 — 2026-08-20)

Backup: `C:\Users\admin\.config\opencode-backup-20260820-153803` (3475 files). Live sync: overlay copy-out + workflow transform + `opencode.json` token merge (`COMPANION_ROOT`, `OPENCODE_HOME` resolved; `model`/`provider` preserved; `implementer.task.implementer` = `allow`). Inventory drift: zero extra/missing host-plugged leaves; `node_modules` preserved.

| # | Item | Runtime evidence | Smoke |
| - | ---- | ---------------- | ----- |
| **C1** | Always-on gates inject | `instructions/cursor-escape-loop.md` on disk; wired in `opencode.json` | Row **1** deferred: operator (restart + probe) |
| **C2** | Eight skills incl. `roadmap` | 8 `skills/*/SKILL.md` with matching `name` frontmatter on live host | Rows **9–10** deferred: operator (Desktop skill-tool probe) |
| **C3** | Plan→plan_reviewer; impl→dual→Full | 7 overlay agents on disk; reviewers `permission.edit: deny` in agent frontmatter; loops cited in bodies | Rows **2, 3, 13** deferred operator; row **8** pass (agent cites rubric + no `model:` pin); row **14** pass (specimen vs live `agent.*` key diff — see smoke row 14 Result) |
| **C4** | Deep workflow Reads on host | 10 workflow leaves on disk; hop greps zero (install-time); skill-tool load deferred | Row **4** deferred: operator (path verified; load probe after restart) |
| **C5** | Companion FA reads | `external_directory` includes `COMPANION_ROOT/**`; sample FA `read` OK | Optional 11–12 prior pass; companion read verified Phase 3 Fast CI |
| **C6** | Smoke proves behavior | This table + smoke rows — no pass on folder/skill-path presence alone | Minimum set **1, 2, 3, 4, 8, 9–10, 13, 14** — install-time **8** (content grep), **14** (`agent.*` key diff) pass; runtime rows deferred operator |

**Operator next step:** Full quit + restart OpenCode Desktop; run deferred rows **1, 2, 3, 4, 9, 10, 13** to close C1–C4/C2/C3 runtime bars.

**Fast verification (install-time):**

```text
agents/: planner, plan_reviewer, implementer, production_readiness_reviewer, bug_reviewer, repository_explorer, test_reviewer
skills/: discovery, implementation-plan, plan-review, implementation-review, pre-commit-ci-gate, composer, documentation-architecture, roadmap
docs/workflow/: present (incl. bug-reviewer-finding-rubric.md, plan-agent-context.md)
instructions/cursor-escape-loop.md: present
```

Grep agents for required Cursor type names `bugbot` / `reviewer-a` as runtime IDs — should be absent (role names only). Grep `model:` pins on reviewer agents — should be absent (inherit session default).

---

## Implications / open questions

1. Smoke rows 1–4, 9–10, 13 need live Desktop probes after restart (Phase 3 sync complete 2026-08-20). Rows **8**, **14** **pass** on install-time evidence per How (row **8**: agent cites rubric + no `model:` pin; row **14**: specimen vs live `agent.*` key diff). Row **9** does not attest C2 until operator re-probes eight-skill catalog post-restart.
2. Do **not** pin provider-specific models in agent frontmatter — roles inherit the session / `opencode.json` default so the adapter stays portable across BYOK hosts.
3. T3 Code control plane is separate — this SOP covers the OpenCode harness adapter only.
4. **Restart OpenCode Desktop** after adapter edits for always-on / agent / skill / permission changes to load.
5. **Skill-binding (C/E/F):** Smoke **11–12** **pass** (2026-08-19). Row **9** C2 runtime deferred until operator re-probes post–Phase 3 restart. Row **14** **pass** Phase 3 (specimen vs live `agent.*` JSON diff + `implementer.task` allow — not presence-only).
6. When adding OpenCode skills/agents/rules: follow [opencode-authoring-adapter](./opencode-authoring-adapter.md) (official docs + Observed checklist). Periodically audit durable Always-run rows in `opencode.db` `permission` table (see authoring SOP).
7. Smoke **13** (thin-plan Incomplete until): prior **pass** 2026-08-19; deferred re-probe after Phase 3 restart if overlay agents changed materially.

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
