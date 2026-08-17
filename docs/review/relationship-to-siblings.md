# Relationship to Sibling Repositories

**Last updated:** 2026-08-17

## Context

cursorEscape is a **docs-first companion** for escaping Cursor lock-in. It does not replace sibling archives; it imports selected research with provenance and authors Target synthesizing docs in later phases. This document is **Target** cursorEscape intent about how siblings relate — not a sync contract.

---

## Substance

### Sibling map

| Sibling | Role relative to cursorEscape | Sync? |
| ------- | ------------------------------- | ----- |
| **openBuggy** | External Bugbot leg + market/harness **research** archive; eval fixtures and Bugbot benchmark ops | **No sync** — one-time import under `docs/research/imported/openBuggy/` with [COPY-MANIFEST](../research/imported/COPY-MANIFEST.md) |
| **AITestSuite** | Eval packaging for plan/review workflow (frozen baselines, scoring framework, USER_INPUT_STOPS) | **No sync** — Phase 3 import only; Observed/eval-packaging label |
| **Live `~/.cursor`** | Canonical **Target workflow** for the owner's Cursor loop (skills, rules, agents, workflow docs) | **No sync** — Phase 3 import + `workflow-source-delta.md`; live remains canonical |

### openBuggy (imported in Phase 2)

- **What we took:** Workflow-gap narrative, proposed engine slices relevant to dual-gate loops, full Cursor BugBot Observed FA suite, reviewer-effectiveness analysis (no `.local/`), product/API research, and the agent-review-loop SOP.
- **What we did not take:** `eval/` tree, mining ops roadmaps as imports, analysis `.local/` coding sheets, runtime code.
- **How to use imports:** Treat as **Observed/imported** openBuggy characterization. cursorEscape **Target** design lives in `docs/review/design-decisions.md` and Phase 4+ `docs/featureArchitecture/` synthesizers — cite imports; do not merge without claim classification.

### AITestSuite (imported in Phase 3)

- **What we took:** Phase 4 freeze `.cursor/` workflow slice (skills, agents, rules), freeze `referenceFiles/SOPs/` process docs, eval-packaging `REVIEW_LOOP.md`, `USER_INPUT_STOPS.md`, phase lessons-learned (phases 2, 4, 6), and suite `scoring-framework.md`. **Hard excludes:** `review-profiles/**`, baselines' app trees, `evaluation/reference/**`.
- **What we did not take:** Full baselines, review-profile swap machinery, runtime eval runners as imports.
- **How to use imports:** Label **Observed/eval-packaging** for test-scoped prompts and freeze baseline. **Live `~/.cursor`** import is Observed snapshot of canonical Target — cite [workflow-source-delta](../research/imported/workflow-source-delta.md) when freeze disagrees with live.

### Live `~/.cursor` (imported in Phase 3)

- **What we took:** All nine `docs/workflow/` files, three rules (including `pre-commit-ci-gate`), five skills (+ co-located `user-rules-snippet.md` where present), and two agents — mirrored under `imported/cursor-global-workflow/`.
- **Canonical:** Live tree remains owner Target; import is dated snapshot for cursorEscape archaeology and Phase 4 synthesis.

### Replaceability principle

cursorEscape intends to **own** workflow contracts, repo knowledge, and evaluation methodology while keeping backends and models swappable. Siblings remain **reference and packaging** sources, not upstream dependencies with automatic merge.

---

## Implications / open questions

1. License and remote hosting for cursorEscape remain TBD; sibling licenses do not automatically apply to Target docs here.
2. Re-import from openBuggy requires manifest update and explicit phase decision — no standing sync job.
3. When runtime appears in a future branch, this file should gain concrete API/package boundaries per sibling.

---

## Related

- [Design decisions](./design-decisions.md)
- [COPY-MANIFEST](../research/imported/COPY-MANIFEST.md)
- [Initialization roadmap](../roadmaps/cursorEscape-initialization.md)
- [Imported openBuggy FA index](../research/imported/openBuggy/featureArchitecture/_index.md)
