# Feature Architecture Documentation

**Last updated:** 2026-08-17

## Context

This section will explain **how cursorEscape is intended to work** — Target design and workflow contracts. Unlike SOPs (how to perform a task), these documents describe system behavior and architecture.

**Status:** Phase 2 Observed imports landed under `docs/research/imported/openBuggy/featureArchitecture/` — closeout pending review loop + Full CI. Target synthesizing docs are authored in [initialization Phase 4](../roadmaps/cursorEscape-initialization.md).

## Substance

### Content boundaries

| Document type | Responsibility |
| ------------- | -------------- |
| This folder (future Target docs) | Intended workflow, backend abstraction, agent roles, evaluation methodology |
| [`../research/`](../research/_index.md) | Sourced facts and imported sibling research |
| [`../analysis/`](../analysis/_index.md) | Operator studies of local workflows |

### Observed imports (Phase 2 — openBuggy)

Imported Observed harness and proposed-engine reference slices live under [research/imported/openBuggy/featureArchitecture/](../research/imported/openBuggy/featureArchitecture/_index.md) — not Target cursorEscape design.

### Documents (Target — Phase 4)

*None yet — Phase 4 deliverables include `intended-workflow.md`, `backend-and-provider-abstraction.md`, and related Target leaves.*

---

## Implications / open questions

1. Imported Observed harness references from openBuggy are under `docs/research/imported/openBuggy/featureArchitecture/` — do not mix Observed and Target in the same doc without labels.
2. Claim taxonomy (Desired / Required / Nice-to-have / Cursor-specific / Unknown) applies from Phase 4 onward.

## Related

- [Roadmap](../Roadmap.md)
- [Design decisions](../review/design-decisions.md)
- [Imported openBuggy FA (Observed)](../research/imported/openBuggy/featureArchitecture/_index.md)
- [Initialization roadmap](../roadmaps/cursorEscape-initialization.md)
