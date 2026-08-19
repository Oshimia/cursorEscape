# Relationship to Sibling Repositories

**Last updated:** 2026-08-20

## Context

cursorEscape is the owner's **skill/workflow manager** (docs-first until copy-out). It does not replace sibling archives; it imports selected research with provenance and authors **Target** synthesizing docs under `docs/featureArchitecture/`, `docs/agents/`, and `docs/skills/` (Phase 4 complete). This document is **Target** cursorEscape intent about how siblings relate — not a sync contract. First recreation uses external **T3 Code + OpenCode**, not sibling runtimes ([host recreation](../analysis/host-recreation-2026-08.md)).

---

## Substance

### Sibling map

| Sibling | Role relative to cursorEscape | Sync? |
| ------- | ------------------------------- | ----- |
| **openBuggy** | Market/harness **research** archive; BugBot characterization; optional later bug engine — **not** a v0 runtime dependency | **No sync** — one-time import under `docs/research/imported/openBuggy/` with [COPY-MANIFEST](../research/imported/COPY-MANIFEST.md) |
| **AITestSuite** | Eval packaging for plan/review workflow (frozen baselines, scoring framework, USER_INPUT_STOPS) | **No sync** — Phase 3 import only; Observed/eval-packaging label |
| **Live `~/.cursor`** | **Observed** Cursor loop. Skills, rules, agents, and `docs/workflow` extracted to [docs/overlays/cursor](../overlays/cursor/_index.md) (verbatim). Companion repo is **Target** contract SoT. | **No sync** — overlay extract is a dated copy; live install still loads `~/.cursor` |

### openBuggy (imported in Phase 2)

- **What we took:** Workflow-gap narrative, proposed engine slices relevant to dual-gate loops, full Cursor BugBot Observed FA suite, reviewer-effectiveness analysis (no `.local/`), product/API research, and the agent-review-loop SOP.
- **What we did not take:** `eval/` tree, mining ops roadmaps as imports, analysis `.local/` coding sheets, runtime code.
- **How to use imports:** Treat as **Observed/imported** openBuggy characterization. v0 **bug_reviewer** is an OpenCode subagent + skills (reviewer-a pattern) — cite openBuggy for personality/eval research, not as Required transport. Target design: [design-decisions](./design-decisions.md), [featureArchitecture](../featureArchitecture/_index.md), [agents](../agents/_index.md), [skills](../skills/_index.md).

### AITestSuite (imported in Phase 3)

- **What we took:** Phase 4 freeze `.cursor/` workflow slice (skills, agents, rules), freeze `referenceFiles/SOPs/` process docs, eval-packaging `REVIEW_LOOP.md`, `USER_INPUT_STOPS.md`, phase lessons-learned (phases 2, 4, 6), and suite `scoring-framework.md`. **Hard excludes:** `review-profiles/**`, baselines' app trees, `evaluation/reference/**`.
- **What we did not take:** Full baselines, review-profile swap machinery, runtime eval runners as imports.
- **How to use imports:** Label **Observed/eval-packaging** for test-scoped prompts and freeze baseline. **Live `~/.cursor`** import is an Observed snapshot of Cursor wording — cite [workflow-source-delta](../research/imported/workflow-source-delta.md) when freeze disagrees with live. Companion-repo contracts are Target.

### Live `~/.cursor` (imported in Phase 3)

- **What we took:** All nine `docs/workflow/` files, three rules (including `pre-commit-ci-gate`), five skills (+ co-located `user-rules-snippet.md` where present), and two agents — mirrored under `imported/cursor-global-workflow/`.
- **Cursor file reference (Observed):** [docs/overlays/cursor](../overlays/cursor/_index.md) (2026-08-20, byte-identical to live at extract: skills, rules, agents, `docs/workflow`). Phase 3 import under `imported/cursor-global-workflow/` remains a bannered 2026-08-17 snapshot. Recreation maps **Target** contracts in this repo to OpenCode.

### Replaceability principle

cursorEscape intends to **own** workflow contracts, repo knowledge, and evaluation methodology while keeping backends and models swappable. Siblings remain **reference and packaging** sources, not upstream dependencies with automatic merge. External hosts (T3, OpenCode) are adapters, not siblings in this map.

---

## Implications / open questions

1. License and remote hosting for cursorEscape remain TBD; sibling licenses do not automatically apply to Target docs here.
2. Re-import from openBuggy requires manifest update and explicit phase decision — no standing sync job.
3. openBuggy is **not** wired as default bug_reviewer (U8 withdrawn) — optional later only.
4. Live `~/.cursor` is **Observed interim** Cursor wording; companion-repo contracts are Target.

---

## Related

- [Design decisions](./design-decisions.md)
- [Host recreation study](../analysis/host-recreation-2026-08.md)
- [Feature architecture index](../featureArchitecture/_index.md)
- [Agent contracts](../agents/_index.md)
- [Skill contracts](../skills/_index.md)
- [COPY-MANIFEST](../research/imported/COPY-MANIFEST.md)
- [Initialization roadmap](../roadmaps/cursorEscape-initialization.md)
- [Theo fleet skill management (Observed)](../research/theo-fleet-skill-management.md)
- [Imported openBuggy FA index](../research/imported/openBuggy/featureArchitecture/_index.md)
