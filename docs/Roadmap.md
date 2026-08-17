# cursorEscape Roadmap

**Last updated:** 2026-08-17  
**Status:** Documentation foundation — runtime not started; [initialization roadmap](./roadmaps/cursorEscape-initialization.md) Phase 3 in progress (imports landed; closeout pending review loop + Full CI).

This repository is the owner's **open agentic workflow companion**: preserve and evolve a personal agentic loop without inseparable dependence on Cursor, a single IDE, or a single model provider.

---

## Context

cursorEscape exists to escape Cursor lock-in while keeping what works: structured plan/review loops, repository-local knowledge, and evaluable workflow behavior. Documentation follows the openBuggy taxonomy (feature architecture, SOPs, research, analysis, roadmaps) adapted for a **workspace-pointing companion** rather than a Bugbot-only engine.

Stewardship and non-goals: [design decisions](./review/design-decisions.md).

---

## Guiding principles

| Principle | Detail |
| --------- | ------ |
| **Own the workflow** | Plan, review, and agent roles are first-class artifacts — not hidden in IDE defaults. |
| **Own repository knowledge** | Discovery, context, and SOPs live in-repo and remain portable. |
| **Own evaluation** | Workflow quality is measurable; imports and deltas are documented. |
| **Backends replaceable** | Models, providers, and execution surfaces (CLI, MCP, thin IDE) swap without rewriting intent docs. |
| **Docs before runtime** | This archive prevents parallel invented architecture during future implementation. |
| **Personal workflow first** | Built for the owner's loop, not a general IDE product or commercial offering. |

---

## Current status

| Area | Status |
| ---- | ------ |
| Documentation foundation | **In progress** ([initialization roadmap](./roadmaps/cursorEscape-initialization.md)) |
| Runtime / engine / packages | **Not started** |
| Research imports (openBuggy) | **Complete** (Phase 2) — see [imported openBuggy](./research/imported/openBuggy/featureArchitecture/_index.md) and [COPY-MANIFEST](./research/imported/COPY-MANIFEST.md) |
| Research imports (AITestSuite, live `~/.cursor`) | **Imports landed** — closeout pending; see [workflow-source-delta](./research/imported/workflow-source-delta.md) and [research index](./research/_index.md) |
| Target synthesizing architecture docs | Planned Phase 4 |
| Implementation roadmap (future build) | Planned Phase 4 — not authored yet |

---

## Directory structure

| Path | Purpose |
| ---- | ------- |
| [`README.md`](../README.md) | Repo entry; points here |
| [`review/`](./review/_index.md) | Project intent and design decisions |
| [`featureArchitecture/`](./featureArchitecture/_index.md) | Intended system behavior (Target docs from Phase 4) |
| [`research/`](./research/_index.md) | Sourced facts and imported sibling research |
| [`SOPs/`](./SOPs/_index.md) | How maintainers and future implementers work |
| [`analysis/`](./analysis/_index.md) | Operator studies of local workflows |
| [`roadmaps/`](./roadmaps/_index.md) | Multi-phase handoff roadmaps |

**Authoring minimum for every substantive doc:** **Last updated**, **Context**, **Substance**, **Implications** (or **Implications / open questions**).

---

## Initialization and future implementation

| Roadmap | Purpose |
| ------- | ------- |
| [cursorEscape initialization](./roadmaps/cursorEscape-initialization.md) | Bootstrap docs, import research, author Target FA docs, closeout report |
| Implementation roadmap (`docs/roadmaps/implementation-roadmap.md`) | **Future** — runtime/engine milestones (authored in initialization Phase 4) |

---

## Implications / open questions

1. Engine language, provider defaults, and license remain TBD until an explicit implementation phase.
2. Bugbot-shaped review initially delegates to **openBuggy** as an external sibling — not reimplemented here first.
3. Keep hub docs extend-only; do not fork parallel taxonomies.

---

## Related

- [Design decisions](./review/design-decisions.md)
- [Documenting this repo (SOP)](./SOPs/documenting-this-repo.md)
- [Roadmaps index](./roadmaps/_index.md)
