# cursorEscape Roadmap

**Last updated:** 2026-08-17  
**Status:** Documentation foundation — runtime not started; [initialization roadmap](./roadmaps/cursorEscape-initialization.md) Phase 4 complete (pending Composer QC commit); Phase 5 next.

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
| Documentation foundation | **Phase 4 complete** — Phase 5 closeout next ([initialization roadmap](./roadmaps/cursorEscape-initialization.md)) |
| Runtime / engine / packages | **Not started** |
| Research imports (openBuggy) | **Complete** (Phase 2) |
| Research imports (AITestSuite, live `~/.cursor`) | **Complete** (Phase 3) — [workflow-source-delta](./research/imported/workflow-source-delta.md) |
| Target synthesizing architecture docs | **Complete** (Phase 4) — [feature architecture index](./featureArchitecture/_index.md) |
| Agent & skill contracts | **Complete** (Phase 4) — [agents](./agents/_index.md) · [skills](./skills/_index.md) |
| Implementation roadmap (future build) | [implementation-roadmap.md](./roadmaps/implementation-roadmap.md) |

---

## Directory structure

| Path | Purpose |
| ---- | ------- |
| [`README.md`](../README.md) | Repo entry; points here |
| [`review/`](./review/_index.md) | Project intent and design decisions |
| [`featureArchitecture/`](./featureArchitecture/_index.md) | Intended system behavior (Target) |
| [`agents/`](./agents/_index.md) | Host-agnostic role contracts |
| [`skills/`](./skills/_index.md) | Host-agnostic skill contracts |
| [`research/`](./research/_index.md) | Sourced facts and imported sibling research |
| [`SOPs/`](./SOPs/_index.md) | How maintainers and future implementers work |
| [`analysis/`](./analysis/_index.md) | Operator studies of local workflows |
| [`roadmaps/`](./roadmaps/_index.md) | Multi-phase handoff roadmaps |

**Authoring minimum for every substantive doc:** **Last updated**, **Context**, **Substance**, **Implications** (or **Implications / open questions**).

---

## Target architecture (Phase 4)

| Topic | Document |
| ----- | -------- |
| Intended workflow | [intended-workflow.md](./featureArchitecture/intended-workflow.md) |
| Portable vs Cursor-specific | [desired-behavior-vs-cursor-specific.md](./featureArchitecture/desired-behavior-vs-cursor-specific.md) |
| Cursor behaviors to preserve | [cursor-behavior-to-reproduce.md](./featureArchitecture/cursor-behavior-to-reproduce.md) |
| Backend abstraction | [backend-and-provider-abstraction.md](./featureArchitecture/backend-and-provider-abstraction.md) |
| Repository discovery | [repository-discovery-and-context.md](./featureArchitecture/repository-discovery-and-context.md) |
| Workspace model | [workspace-model.md](./featureArchitecture/workspace-model.md) |
| Agent roles | [agent-roles-and-model-assignment.md](./featureArchitecture/agent-roles-and-model-assignment.md) |
| Evaluation | [evaluation-methodology.md](./featureArchitecture/evaluation-methodology.md) |
| Backend landscape (research) | [preliminary-backend-landscape.md](./research/preliminary-backend-landscape.md) |
| Open questions | [unresolved-architectural-questions.md](./review/unresolved-architectural-questions.md) |
| Future implementation | [implementation-roadmap.md](./roadmaps/implementation-roadmap.md) |

---

## Initialization and future implementation

| Roadmap | Purpose |
| ------- | ------- |
| [cursorEscape initialization](./roadmaps/cursorEscape-initialization.md) | Bootstrap docs, import research, author Target FA docs, closeout report |
| [Implementation roadmap](./roadmaps/implementation-roadmap.md) | **Future** — runtime/engine milestones (research-first) |

---

## Implications / open questions

1. Engine language, provider defaults, and license remain **Unknown** until implementation phase — see [unresolved architectural questions](./review/unresolved-architectural-questions.md).
2. Bugbot-shaped review initially delegates to **openBuggy** as an external sibling — not reimplemented here first.
3. Keep hub docs extend-only; do not fork parallel taxonomies.

---

## Related

- [Design decisions](./review/design-decisions.md)
- [Documenting this repo (SOP)](./SOPs/documenting-this-repo.md)
- [Roadmaps index](./roadmaps/_index.md)
