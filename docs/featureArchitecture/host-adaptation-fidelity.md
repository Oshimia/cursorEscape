# Host adaptation fidelity

**Last updated:** 2026-08-20

## Context

This document is **Target** design for **complete host adaptation** — the binding bar that Cursor and OpenCode (and future stacks) must meet before an overlay or live adapter is considered **Done**. It is not implied polish: operator workflow **loops** (plan review, implementation review with Fast → dual → Full, skill ids, clean-context isolation, Incomplete-until / dual-APPROVED bars) must behave the same on every host.

**Scope:** Wiring bar, anti-patterns, checklist→verification matrix (C1–C6), doc boundaries, and phase-number disambiguation for the [OpenCode overlays SoT program](../roadmaps/opencode-overlays-sot.md) (program phases **0–3**). **Out of scope here:** re-pasting Observed behavior tables ([cursor-behavior-to-reproduce](./cursor-behavior-to-reproduce.md)); always-on vs skill budget ([instruction-layering](./instruction-layering.md)); SoT vs overlay taxonomy ([skill-source-and-host-overlays](./skill-source-and-host-overlays.md)).

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
| Always-on gates wired to host **load surface** (OpenCode: `instructions` + thin `AGENTS.md` if used; Cursor: User Rules / thin `.mdc`) | Cosmetic folder tree that does not inject at runtime |
| Every workflow skill advertised with matching frontmatter `name` + `description` (OpenCode); on-demand invocation (Cursor: `disable-model-invocation`) | Skills on disk with **description only** — empty skill-tool catalog ([skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md)) |
| `skills.paths` or equivalent discovery roots registered (OpenCode) | Relying on default scan when catalog is empty |
| Reviewer agents `permission.edit: deny`; dual Task launch in one parent turn | Unwired stub agents; sequential-only “dual” review |
| Deep workflow docs reachable via **host-relative** Read paths from skills/agents | Portable `../skills/` or `../rules/` hops in overlay bodies |
| Rules → OpenCode **`instructions`** / skill deferral — **never** a Cursor-style host `rules/` tree on OpenCode | Copying `~/.cursor/rules/` shape onto OpenCode |
| Smoke + matrix attestation prove **behavior** (gates visible, catalog lists ids, reviewers denied edit) | **Done** because folders exist without load/smoke |
| One authored procedure per skill/workflow leaf; overlay = thin harness | Pasting full review loop into always-on or agent bodies |

### OpenCode load-surface map (Required cite)

OpenCode loads workflow material through these surfaces only — **not** Cursor `rules/`:

| Surface | Purpose | Authoring reference |
| ------- | ------- | ------------------- |
| `instructions/*` (via `opencode.json` → `instructions`) | Always-on thin gates | [opencode-authoring-adapter](../SOPs/opencode-authoring-adapter.md) § Rules and always-on |
| `AGENTS.md` (project / global) | Standing rules per OpenCode precedence | Same; keep thin |
| `skills/<id>/SKILL.md` | On-demand skills; **`name` + `description` required** | [opencode-authoring-adapter](../SOPs/opencode-authoring-adapter.md) § Skills |
| `agents/*.md` | Role agents; reviewers deny-edit | [opencode-authoring-adapter](../SOPs/opencode-authoring-adapter.md) § Agents |
| `opencode.json` → `skills.paths` | Explicit skill scan roots | [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) |
| `opencode.json` → `permission.skill` | Advertise/load allow | Same |
| `docs/workflow/*` (mirrored) | Deep procedure; Read on demand | [instruction-layering](./instruction-layering.md) Layer 3 |

After any config-time edit: **full quit and restart** OpenCode (no hot-reload). Parent owns Observed Fast CI; empty Task ≪1s = routing/auth failure, not “no bugs.”

### Checklist → verification matrix (C1–C6)

Phase 2 reviewers use **Author-time** columns; Phase 3 use **Runtime** + smoke. Do not mark **Done** on file presence alone (C6).

| # | Checklist item | Author-time (OpenCode overlay Phase 2) | Runtime (live sync Phase 3) | Smoke row(s) / method |
| - | -------------- | -------------------------------------- | --------------------------- | --------------------- |
| **C1** | Always-on gates inject (plan + dual-review default-on; when-in-doubt; eval/harness not exempt; Incomplete-until pointer) | `opencode.specimen.json` lists `instructions/cursor-escape-loop.md` (or equivalent); instruction file states **both** plan and implementation-review gates | New session after restart; model quotes default-on plan loop + when-in-doubt + eval/harness not exempt from always-on | **1** — [host-adapter](../SOPs/opencode-host-adapter.md) smoke § row 1 |
| **C2** | Skill catalog complete (incl. `roadmap` when in inventory) | Eight workflow skills each with frontmatter `name` matching folder id + `description`; overlay `_index` inventory lists all eight; **Phase 2 must update** [host-adapter](../SOPs/opencode-host-adapter.md) Skills inventory, row **9** How/expected catalog, and frozen Probe A in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) to **eight ids including `roadmap`** before C2 author-time can pass | Skill tool lists all eight: `implementation-plan`, `plan-review`, `implementation-review`, `composer`, `discovery`, `documentation-architecture`, `pre-commit-ci-gate`, **`roadmap`**; load `implementation-plan` with zero bash for SoT | **9**, **10** — **Phase 2 gate:** row 9 How + Probe A expected catalog must list **8 workflow skills including `roadmap`** (author in Phase 2; How frozen then). **Prior R0 row-9 pass (7 skills, no `roadmap`) does not satisfy C2** — re-run rows 9–10 after Phase 2 catalog update. Row 10 unchanged: load + quote Escalation row |
| **C3** | Plan→`plan_reviewer`; implement→dual review→Full / pre-commit | Overlay agents: `plan_reviewer`, `production_readiness_reviewer`, `bug_reviewer` with `permission.edit: deny`; bodies cite skills + `docs/workflow/iterative-*`; `bug_reviewer` → rubric path | Dual Task in one turn (two children); reviewers cannot edit; thin plan → **CHANGES REQUESTED**; rubric file exists | **13**, **3**, **2**, **8**, **14** — thin-plan smoke; dual shape; deny-edit; rubric path; row **14** copy-out map / specimen vs live `agent.*` keys ([host-adapter](../SOPs/opencode-host-adapter.md) row 14 — How frozen Phase 2) |
| **C4** | Deep workflow Reads resolve on host | Each overlay skill/agent **Read when** table uses host-relative paths only (`docs/workflow/...`); `Rewrite-OpenCodeWorkflowLinks.ps1` dry-run + idempotency; `rg` zero for `../skills/`, `../rules/`, portable repo-root hops in overlay harness | `implementation-review` skill load; confirm `docs/workflow/iterative-code-review.md` exists at mirrored path | **4** — path resolve; plus workflow `rg` on overlay tree (Phase 2 Fast CI) |
| **C5** | Companion FA/SOP reads without repeated asks | Specimen `external_directory` tokens for companion repo paths (e.g. `docs/featureArchitecture/**`); deny-edit under adapter tree if configured | Sample read of FA leaf (e.g. this doc) via native `read` without serial Shell listing | Optional **11**, **12** — native tools / glob-blind probes in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) |
| **C6** | Smoke proves **behavior**, not presence | N/A (runtime-only bar) | Host-adapter smoke table attests C1–C5 with `pass` / `fail` / `deferred: <reason>` — no row marked pass for “folder exists” alone | Minimum Phase 3 smoke set: **1, 2, 3, 4, 8, 9, 10, 13, 14** — attest in [opencode-host-adapter](../SOPs/opencode-host-adapter.md) table |

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
| **OpenCode overlay program** | **0–3** | This roadmap: 0 = fidelity FA; 1 = thin discovery/plan-review skills; 2 = `overlays/opencode/` + copy-out auth flip; 3 = live sync + smoke |
| **Shared-workflow-docs program** | **1–6** | Completed repo-root migration ([shared-workflow-docs](../roadmaps/shared-workflow-docs.md)) |
| **cursorEscape initialization** | **0–6** | Bootstrap / Target FA ([cursorEscape-initialization](../roadmaps/cursorEscape-initialization.md)) |

When a doc says “Phase 2,” confirm **which program** before editing overlays or authorization.

### Cursor refresh (Required)

Future refresh of [overlays/cursor](../../overlays/cursor/_index.md) or live `~/.cursor` copy-out must meet **this same fidelity bar**: thin wrappers only, spawn + Read tables, no second procedure tree, dual review + Fast/Full split preserved. Shape-matching Cursor folders without load verification is an anti-pattern here too.

### Host-plugged vs companion-resident (cite)

**Host-plugged (must meet C1–C6 at runtime):** `opencode.json` harness, `instructions/*`, `skills/*/SKILL.md`, overlay `agents/*.md`, mirrored `docs/workflow/*` (+ rubric + review-subagent-models).

**Companion-resident (read via `external_directory` / workspace):** FA leaves, SOPs (except short excerpts in instructions), research/analysis (except required host Read targets), maintainer indexes.

---

## Implications / open questions

1. Phase 0 authors this matrix; Phase 2/3 **execute** it — reviewers must not invent new smoke methods outside this table and [opencode-host-adapter](../SOPs/opencode-host-adapter.md).
2. Empty skill-tool catalog after correct authoring = **failed adaptation**, not model preference ([skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md)).
3. Copy-out into `~/.config/opencode` is **authorized** from [overlays/opencode](../../overlays/opencode/_index.md) (Phase 2); Phase 3 executes live sync. Cursor copy-out remains manual.

---

## Related

- [OpenCode overlays SoT roadmap](../roadmaps/opencode-overlays-sot.md)
- [Cursor behavior to reproduce](./cursor-behavior-to-reproduce.md)
- [Instruction layering](./instruction-layering.md)
- [Skill source and host overlays](./skill-source-and-host-overlays.md)
- [Intended workflow](./intended-workflow.md)
- [OpenCode host adapter](../SOPs/opencode-host-adapter.md)
- [Authoring OpenCode adapter files](../SOPs/opencode-authoring-adapter.md)
- [OpenCode skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md)
- [Feature architecture index](./_index.md)
