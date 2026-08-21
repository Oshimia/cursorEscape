# Host adaptation fidelity

**Last updated:** 2026-08-20

## Context

This document is **Target** design for **complete host adaptation** — the binding bar that Cursor and OpenCode (and future stacks) must meet before an overlay or live adapter is considered **Done**. It is not implied polish: operator workflow **loops** (plan review, implementation review with Fast → dual → Full, skill ids, clean-context isolation, Incomplete-until / dual-APPROVED bars) must behave the same on every host.

**Scope:** Wiring bar, anti-patterns, checklist→verification matrix (C1–C6), doc boundaries, and phase-number disambiguation for the [OpenCode overlays SoT program](../roadmaps/opencode-overlays-sot.md) (program phases **0–3**) and [Companion pointer-first](../roadmaps/pointer-first.md) (`pointer-first-0` … `pointer-first-4`). **Out of scope here:** re-pasting Observed behavior tables ([cursor-behavior-to-reproduce](./cursor-behavior-to-reproduce.md)); always-on vs skill budget ([instruction-layering](./instruction-layering.md)); SoT vs overlay taxonomy ([skill-source-and-host-overlays](./skill-source-and-host-overlays.md)).

**Applies to:** OpenCode overlay + live adapter (Phases 2–3 of this program) **and** future **Cursor overlay refresh** — any stack that claims to run the cursorEscape loop must meet this bar, not only folder shape.

---

## Substance

### Success criterion (Required)

**Done** means the operator can run the **same loops** on Cursor and OpenCode:

| Loop element | Required parity |
| ------------ | --------------- |
| Plan | `implementation-plan` → `plan_reviewer`; Incomplete-until / section checklist enforced |
| Implement | Parent implements; isolated child context for reviewers |
| Review | Fast CI Observed (parent) → parallel production-readiness + bug legs → fix must-fix → dual APPROVED → Full CI closeout |
| Gates | Default-on unless truly trivial or explicit user opt-out; eval/harness/multi-step work **not** exempt |
| Skills | On-demand load by id; deep docs via Read when skill says so |
| Isolation | No prior review transcripts in child context; locked opener on production-readiness leg |

Host chrome (Task UI, tray restart, permission prompts) may differ. **Loop semantics must not.**

### Required adaptation vs anti-patterns

| Required adaptation | Anti-pattern (reject) |
| ------------------- | --------------------- |
| Always-on gates wired to host **load surface** that actually injects (OpenCode: **absolute** `opencode.json` → `instructions` under `OPENCODE_HOME` **plus** matching global `AGENTS.md`; Cursor: User Rules / thin `.mdc`) | Relative `instructions/…` in **global** `opencode.json` (resolved vs **project cwd** — file on disk under `~/.config/opencode` but **not** injected); gates only in `instructions/` with no `AGENTS.md`; treating skill-description “default on” quotes as C1 pass |
| Every workflow skill advertised with matching frontmatter `name` + `description` (OpenCode); on-demand invocation (Cursor: `disable-model-invocation`) | Skills on disk with **description only** — empty skill-tool catalog ([skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md)) |
| `skills.paths` or equivalent discovery roots registered (OpenCode) | Relying on default scan when catalog is empty |
| Reviewer agents `permission.edit: deny`; dual Task launch in one parent turn | Unwired stub agents; sequential-only “dual” review |
| Deep workflow docs reachable via **absolute companion** Read paths (`{{COMPANION_ROOT}}/workflow/...`, `{{COMPANION_ROOT}}/skills/...`, `{{COMPANION_ROOT}}/agents/...`, `{{COMPANION_ROOT}}/rules/...`) from thin harness (pointer-first-2); OpenCode host `docs/workflow/...` mirror **deleted** pointer-first-4 — **not** procedure SoT | Any `../../docs|skills|agents` hop authored as if relative to the markdown file (tools resolve from **config root** / cwd — see [Wrong path resolution base](#wrong-path-resolution-base-failure-class--i--j)); treating host `docs/workflow/` mirror as procedure SoT after pointer-first-0 |
| Rules → OpenCode **`instructions`** / skill deferral — **never** a Cursor-style host `rules/` tree on OpenCode | Copying `~/.cursor/rules/` shape onto OpenCode |
| Smoke + matrix attestation prove **behavior** (gates visible, catalog lists ids, reviewers denied edit) | **Done** because folders exist without load/smoke |
| One authored procedure per skill/workflow leaf; overlay = thin harness | Pasting full review loop into always-on or agent bodies |

### Wrong path resolution base (failure class — I + J)

**Class rule:** OpenCode often resolves relative paths against **project cwd** or **`OPENCODE_HOME`**, not against the markdown file that contains the link. Authoring hops that look correct in a file browser (`../../docs/...` from `skills/<id>/`, `../../skills/...` from `docs/workflow/`) silently point at the **wrong tree** at runtime.

| Mode | Smoke / bar | Author mental model (wrong) | Actual base | Broken result | Fix |
| ---- | ----------- | --------------------------- | ----------- | ------------- | --- |
| **I** | C1 / row 1 | `instructions/…` relative to config dir | **Project cwd** | Gates never inject; model quotes skill blurbs only | Absolute `{{OPENCODE_HOME}}/instructions/…` + `AGENTS.md` dual-write |
| **J** | C4 / row 4 | `../../docs/workflow/…` relative to skill file | **`OPENCODE_HOME`** | `%USERPROFILE%\docs\workflow\…` | Host-root `docs/workflow/…` in skills |
| **J (mirror)** | C4 residual | `../../skills|agents/…` relative to `docs/workflow/` file | **`OPENCODE_HOME`** (same class) | `%USERPROFILE%\skills|agents\…` | Host-root `skills/…`, `agents/…` in workflow rewrite + rubric |

**C6 trap (shared):** File present under `~/.config/opencode/...` does **not** prove the path string in harness text resolves there.

**Author-time Fast CI (all modes):**

```text
# Specimen instructions must be absolute-token form
rg -n '"instructions"' overlays/opencode/opencode.specimen.json
# Expect: {{OPENCODE_HOME}}/instructions/cursor-escape-loop.md

# Zero file-relative ../../ hops in host-plugged harness leaves (overlay author-time)
rg -n '\.\./\.\./(docs|skills|agents)/' overlays/opencode/skills overlays/opencode/agents overlays/opencode/review-subagent-models.md
# Expect: zero

# Zero positive docs/workflow/ Target cites in live harness (post-sync / pf4)
rg -n '\]\([^)]*docs/workflow/' ~/.config/opencode/skills ~/.config/opencode/agents
# Expect: zero (mirror deleted pf4)
```

**Instances:** [Failure mode I](#observed-failure-cwd-relative-global-instructions-c1--2026-08-20) · [Failure mode J](#observed-failure-skill-docsworkflow-hops-c4--2026-08-20) · authoring [I](../SOPs/opencode-authoring-adapter.md#failure-mode-i--cwd-relative-global-instructions-c1) / [J](../SOPs/opencode-authoring-adapter.md#failure-mode-j--skill-docsworkflow-hops-c4).

### Observed failure: cwd-relative global `instructions` (C1) — 2026-08-20

**Symptom (smoke row 1):** Clean chat; no-tools ask to quote always-on. Model quotes “default on” from **skill** blurbs only; states **when-in-doubt** and **eval/harness not exempt** are absent from session instructions. Operator may also see the model search FA docs or Shell-list `~/.config/opencode`.

**Root cause (Observed):** Global `~/.config/opencode/opencode.json` listed `"instructions": ["instructions/cursor-escape-loop.md"]`. OpenCode resolves that path against the **project cwd**, not the config directory. In a normal repo workspace the path does not exist → **silent non-injection**. The correct file under `~/.config/opencode/instructions/` can still exist on disk (C6 trap: presence ≠ load).

**Required fix (do not regress):**

1. Specimen + live: `instructions` = **absolute** `{{OPENCODE_HOME}}/instructions/cursor-escape-loop.md` (merged to a real absolute path on sync).
2. Dual-write the **same** gate body to `{{OPENCODE_HOME}}/AGENTS.md` (OpenCode global rules surface — applied across sessions).
3. Keep `AGENTS.md` byte-identical to `instructions/cursor-escape-loop.md` on every sync.
4. Re-attest smoke row **1** after full quit/restart — pass only if when-in-doubt + eval/harness quotes come from session text with **zero** tools.

**Authoring SoT:** [opencode-authoring-adapter](../SOPs/opencode-authoring-adapter.md) § Failure mode I. **Evidence:** [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) § C1 / Failure mode I.

### Observed failure: skill `../../docs/workflow` hops (C4) — 2026-08-20

**Symptom (smoke row 4):** Skill `implementation-review` loads; model resolves Read path `../../docs/workflow/iterative-code-review.md` to `C:\Users\admin\docs\workflow\…` (outside adapter) and cannot confirm the deep doc.

**Root cause (Observed):** Overlay skill Read tables used markdown hops `../../docs/workflow/...` as if relative to `skills/<id>/SKILL.md`. Tool/path resolution is from **`OPENCODE_HOME`** (config root). From that root, `../..` exits to the user profile → wrong tree. Agents already used correct host-relative `docs/workflow/...`.

**Required fix (do not regress):**

1. All overlay + live skill Read links / prose paths: **Target** = absolute `{{COMPANION_ROOT}}/workflow/<leaf>.md` (pointer-first-2 complete) — **zero** `../../docs/workflow/` in `overlays/opencode/skills/**`.
2. Prefer absolute `read` under `{{COMPANION_ROOT}}` when the workspace is the companion repo; host procedure mirror **deleted** on OpenCode (pointer-first-4).
3. Smoke row **4** How cites companion `{{COMPANION_ROOT}}/workflow/...` — locked in [host-adapter](../SOPs/opencode-host-adapter.md); never `../../docs/workflow/...` as the expected resolve path.
4. Fast CI: `rg` zero for `../../docs/workflow` under overlay skills.
5. **Same class — workflow mirror (2026-08-20 audit; legacy transitional):** `Rewrite-OpenCodeWorkflowLinks.ps1` emitted host-root `skills/...` and `agents/...` — **archived** after pointer-first-0; not primary sync. Overlay `review-subagent-models.md` uses absolute `{{COMPANION_ROOT}}/...` companion paths after pointer-first-2.

**Authoring SoT:** [opencode-authoring-adapter](../SOPs/opencode-authoring-adapter.md) § Failure mode J. **Class:** [Wrong path resolution base](#wrong-path-resolution-base-failure-class--i--j).

### OpenCode load-surface map (Required cite)

OpenCode loads workflow material through these surfaces only — **not** Cursor `rules/`:

| Surface | Purpose | Authoring reference |
| ------- | ------- | ------------------- |
| `instructions/*` (via `opencode.json` → `instructions` — **absolute** path) | Always-on thin gates | [opencode-authoring-adapter](../SOPs/opencode-authoring-adapter.md) § Rules and always-on; § Failure mode I |
| `AGENTS.md` (global under `OPENCODE_HOME`, byte-match instructions body) | Standing rules per OpenCode precedence — **required dual-write for C1** | Same |
| `skills/<id>/SKILL.md` | On-demand skills; **`name` + `description` required** | [opencode-authoring-adapter](../SOPs/opencode-authoring-adapter.md) § Skills |
| `agents/*.md` | Role agents; reviewers deny-edit | [opencode-authoring-adapter](../SOPs/opencode-authoring-adapter.md) § Agents |
| `opencode.json` → `skills.paths` | Explicit skill scan roots | [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) |
| `opencode.json` → `permission.skill` | Advertise/load allow | Same |
| `docs/workflow/*` (mirrored — **deleted OpenCode pf4**) | Former legacy deep-procedure mirror on OpenCode host — **removed** 2026-08-20; Cursor `~/.cursor/docs/workflow/` may remain transitional | [instruction-layering](./instruction-layering.md) Layer 3; [pointer-first-4 closeout](../../analysis/pointer-first-4-closeout-2026-08.md) — Target Reads = `{{COMPANION_ROOT}}/workflow/` |

After any config-time edit: **full quit and restart** OpenCode (no hot-reload). Parent owns Observed Fast CI; empty Task ≪1s = routing/auth failure, not “no bugs.”

### Checklist → verification matrix (C1–C6)

Phase 2 reviewers use **Author-time** columns; Phase 3 use **Runtime** + smoke. Do not mark **Done** on file presence alone (C6).

| # | Checklist item | Author-time (OpenCode overlay Phase 2) | Runtime (live sync Phase 3) | Smoke row(s) / method |
| - | -------------- | -------------------------------------- | --------------------------- | --------------------- |
| **C1** | Always-on gates inject (plan + dual-review default-on; when-in-doubt; eval/harness not exempt; Incomplete-until pointer) | Specimen `instructions` uses **absolute** `{{OPENCODE_HOME}}/instructions/cursor-escape-loop.md` (not cwd-relative); matching `AGENTS.md` dual-write; instruction file states **both** plan and implementation-review gates | New session after restart; model quotes default-on plan loop + when-in-doubt + eval/harness not exempt from always-on | **1** — [host-adapter](../SOPs/opencode-host-adapter.md) smoke § row 1 |
| **C2** | Skill catalog complete (incl. `roadmap` when in inventory) | Nine workflow skills each with frontmatter `name` matching folder id + `description`; overlay `_index` inventory lists all nine; **Phase 2 must update** [host-adapter](../SOPs/opencode-host-adapter.md) Skills inventory, row **9** How/expected catalog, and frozen Probe A in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) to **nine ids including `roadmap` and `diagnosing-bugs`** before C2 author-time can pass | Skill tool lists all nine: `implementation-plan`, `plan-review`, `implementation-review`, `composer`, `discovery`, `documentation-architecture`, `pre-commit-ci-gate`, **`roadmap`**, **`diagnosing-bugs`**; load `implementation-plan` with zero bash for SoT | **9**, **10** — **Phase 2 gate:** row 9 How + Probe A expected catalog must list **9 workflow skills including `roadmap` and `diagnosing-bugs`** (author in Phase 2; How frozen then). **Prior R0 row-9 pass (7 skills, no `roadmap`) does not satisfy C2** — re-run rows 9–10 after Phase 2 catalog update. Row 10 unchanged: load + quote Escalation row |
| **C3** | Plan→`plan_reviewer`; implement→dual review→Full / pre-commit | Overlay agents: `plan_reviewer`, `production_readiness_reviewer`, `bug_reviewer` with `permission.edit: deny`; bodies cite companion `{{COMPANION_ROOT}}/workflow/iterative-*` and FA rubric | Dual Task in one turn (two children); reviewers cannot edit; thin plan → **CHANGES REQUESTED**; rubric file exists | **13**, **3**, **2**, **8**, **14** — thin-plan smoke; dual shape; deny-edit; rubric path; row **14** copy-out map / specimen vs live `agent.*` keys ([host-adapter](../SOPs/opencode-host-adapter.md) row 14 — How frozen Phase 2) |
| **C4** | Deep workflow Reads resolve on host | Hubs + smoke row **4** How cite absolute `{{COMPANION_ROOT}}/workflow/...`. Harness skill/agent **Read when** bodies use absolute `{{COMPANION_ROOT}}/workflow|skills|agents|rules/...` after **pointer-first-2** — **zero** `../../docs/workflow/` in overlay harness. OpenCode host mirror **deleted** pointer-first-4 | `implementation-review` skill load; confirm Read resolves `{{COMPANION_ROOT}}/workflow/iterative-code-review.md` (Target How). **pass** (2026-08-20 operator post-mirror) | **4** — **pass** (2026-08-20 operator — companion path; [closeout](../../analysis/pointer-first-4-closeout-2026-08.md)) |
| **C5** | Companion FA/SOP reads without repeated asks | Specimen `external_directory` tokens for companion repo paths (e.g. `docs/featureArchitecture/**`); deny-edit under adapter tree if configured | Sample read of FA leaf (e.g. this doc) via native `read` without serial Shell listing | Optional **11**, **12** — native tools / glob-blind probes in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) |
| **C6** | Smoke proves **behavior**, not presence | N/A (runtime-only bar) | Host-adapter smoke table attests C1–C5 with `pass` / `fail` / `deferred: <reason>` — no row marked pass for “folder exists” alone. Deep-doc probes cite **companion** `{{COMPANION_ROOT}}/workflow/` paths where applicable (row **4** locked How) | **C6 minimum:** **1, 2, 3, 4, 8, 9, 10, 13** — attest in [opencode-host-adapter](../SOPs/opencode-host-adapter.md) table. Row **14** install-time (separate) |

### Doc boundary (Must)

| Doc | Owns | Must not |
| --- | ---- | -------- |
| [cursor-behavior-to-reproduce.md](./cursor-behavior-to-reproduce.md) | **Semantics** to reproduce (Observed → Target mapping) | Wiring recipes, install anti-patterns, smoke matrices |
| **host-adaptation-fidelity.md** (this page) | Wiring bar, anti-patterns, C1–C6 matrix, **Done** definition | Re-paste Observed behavior tables from cursor-behavior |
| [instruction-layering.md](./instruction-layering.md) | Always-on vs skill vs deep-doc **budget** | OpenCode smoke matrices, copy-out authorization |
| [skill-source-and-host-overlays.md](./skill-source-and-host-overlays.md) | SoT vs overlay vs copy-out **authorship** stance | Full fidelity smoke matrix (cite this FA instead) |

### Phase-number disambiguation (Required)

| Name | Phases | Meaning |
| ---- | ------ | ------- |
| **Companion pointer-first program** | **pointer-first-0 … pointer-first-4** | Lock companion SoT + thin harness; supersede procedure-mirror load path; stub/sync/mirror disposition through pointer-first-4 |
| **OpenCode overlay program** | **0–3** | Historical [opencode-overlays-sot](../roadmaps/opencode-overlays-sot.md): 0 = fidelity FA; 1 = thin discovery/plan-review skills; 2 = `overlays/opencode/` + copy-out auth flip; 3 = live sync + smoke — **load path superseded** by pointer-first |
| **Shared-workflow-docs program** | **1–6** | Completed repo-root migration ([shared-workflow-docs](../roadmaps/shared-workflow-docs.md)) |
| **cursorEscape initialization** | **0–6** | Bootstrap / Target FA ([cursorEscape-initialization](../roadmaps/cursorEscape-initialization.md)) |

When a doc says “Phase 2,” confirm **which program** before editing overlays or authorization. When a doc says “pointer-first-0,” confirm it is **not** opencode-overlays-sot Phase 0.

### Cursor refresh (Required)

Future refresh of [overlays/cursor](../../overlays/cursor/_index.md) or live `~/.cursor` copy-out must meet **this same fidelity bar**: thin wrappers only, spawn + Read tables, no second procedure tree, dual review + Fast/Full split preserved. Shape-matching Cursor folders without load verification is an anti-pattern here too.

### Host-plugged vs companion-resident (cite)

**Host-plugged (must meet C1–C6 at runtime):** `opencode.json` harness (absolute `instructions`), `AGENTS.md` + `instructions/*` (identical gate body), thin `skills/*/SKILL.md` stubs, overlay `agents/*.md` harness. OpenCode host procedure mirror **deleted** pointer-first-4 — Target deep procedure = companion `{{COMPANION_ROOT}}/workflow/` ([pointer-first-4 closeout](../../analysis/pointer-first-4-closeout-2026-08.md)). Cursor `~/.cursor/docs/workflow/` may remain transitional.

**Companion-resident (read via `external_directory` / workspace):** FA leaves, SOPs (except short excerpts in instructions), research/analysis (except required host Read targets), maintainer indexes.

---

## Implications / open questions

1. Phase 0 authors this matrix; Phase 2/3 **execute** it — reviewers must not invent new smoke methods outside this table and [opencode-host-adapter](../SOPs/opencode-host-adapter.md).
2. Empty skill-tool catalog after correct authoring = **failed adaptation**, not model preference ([skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md)).
3. Relative `instructions` paths in **global** config = **failed C1** even when the file exists under `~/.config/opencode/instructions/` ([Observed failure](#observed-failure-cwd-relative-global-instructions-c1--2026-08-20)). Same class as skill/workflow `../../` hops ([Wrong path resolution base](#wrong-path-resolution-base-failure-class--i--j)).
4. Copy-out into `~/.config/opencode` is **authorized and applied** from [overlays/opencode](../../overlays/opencode/_index.md) (Phase 3 live sync 2026-08-20; pointer-first-2 harness rewrite; pointer-first-4 mirror delete). C6 minimum smoke rows **1–4**, **8**, **9–10**, **13**: **pass** (2026-08-20 operator post-mirror). Cursor copy-out remains manual.

---

## Related

- [OpenCode overlays SoT roadmap](../roadmaps/opencode-overlays-sot.md) (historical bulk sync — load path superseded)
- [Companion pointer-first](../roadmaps/pointer-first.md)
- [Cursor behavior to reproduce](./cursor-behavior-to-reproduce.md)
- [Instruction layering](./instruction-layering.md)
- [Skill source and host overlays](./skill-source-and-host-overlays.md)
- [Intended workflow](./intended-workflow.md)
- [OpenCode host adapter](../SOPs/opencode-host-adapter.md)
- [Authoring OpenCode adapter files](../SOPs/opencode-authoring-adapter.md)
- [OpenCode skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md)
- [Feature architecture index](./_index.md)
