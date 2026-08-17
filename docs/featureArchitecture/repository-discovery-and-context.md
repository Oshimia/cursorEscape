# Repository Discovery and Context

**Last updated:** 2026-08-17

## Context

Investigation area for **what information an agent needs** to work in a repository — not how to reverse-engineer Cursor's internal index. Target stance: portable discovery + bounded context retrieval.

---

## Substance

### Discovery questions (Required framing)

Before plan or implement:

| Question | Why |
| -------- | --- |
| Where is the doc hub? | Avoid inventing parallel trees ([discovery](../skills/discovery.md)) |
| What process SOPs exist? | Plan/review expectations |
| What is Target vs Observed in this repo? | Prevent mixing harness imports with product intent |
| What CI commands apply? | Fast/Full mapping ([ci-ladder](../research/imported/cursor-global-workflow/docs/workflow/ci-ladder.md)) |
| What is out of scope for this task? | Phase boundaries on roadmaps |

### Context for implementation (Desired)

Per change set, agents should gather **evidence**, not whole-repo dumps:

| Signal | Label | Reference |
| ------ | ----- | --------- |
| Changed files + diff hunks | **Required** | Universal |
| Nearby definitions / callers | **Desired** | [openBuggy context-retrieval](../research/imported/openBuggy/featureArchitecture/context-retrieval.md) (Observed proposal) |
| Tests touching area | **Desired** | Same |
| `AGENTS.md`, README, section `_index.md` | **Required** when present | [discovery](../skills/discovery.md) |
| Project rules / design decisions | **Required** for intent changes | cursorEscape `docs/review/` |
| Embedding index of entire repo | **Not a v0 goal** | Token/cost control |

### Ownership alternatives (Unknown — research-first)

| Approach | Trade-off |
| -------- | --------- |
| **Repo-local docs only** | Portable; requires discipline |
| **Global owner skills** (`~/.cursor`) + repo discovery fallback | Matches current Cursor practice |
| **Generated index** (tree-sitter, LSP, embeddings) | Higher fidelity; build cost |
| **Host-provided index** (Cursor, IDE) | Convenient; lock-in risk |

cursorEscape **Required:** Own repository knowledge in-repo ([design decisions](../review/design-decisions.md)). **Unknown:** Which generated index tier (if any) ships in v1 runtime.

### Non-goals

- Reproduce Cursor proprietary codebase index (**Cursor-specific**, not Required)
- Guarantee whole-program analysis in v0 (**Unknown** feasibility)

---

## Implications / open questions

1. Phase 5 initialization report will propose a concrete repo-discovery approach — not start implementation.
2. repository_explorer role explores; implementer consumes summarized context ([agent roles](./agent-roles-and-model-assignment.md)).

---

## Related

- [Workspace model](./workspace-model.md)
- [Discovery skill contract](../skills/discovery.md)
- [Cursor behavior to reproduce](./cursor-behavior-to-reproduce.md)
