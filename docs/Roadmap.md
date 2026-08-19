# cursorEscape Roadmap

**Last updated:** 2026-08-20  
**Status:** Documentation foundation — initialization complete; runtime not started. First recreation: **T3 Code + OpenCode** (external). Identity: **skill/workflow manager across stacks** (not machines).

This repository is the owner's **skill and workflow manager**: preserve and evolve personal agentic skills and the plan → implement → dual review loop, and apply them across stacks without inseparable dependence on Cursor, a single IDE, or a single model provider. Analog: Theo `fleet` ([Observed](./research/theo-fleet-skill-management.md)). Non-goal: multi-machine sync.

---

## Context

cursorEscape exists to **own the skill inventory and the loop** that work for the owner, then run them on replaceable hosts — escape Cursor lock-in without losing structured plan/review, repository-local knowledge, or evaluable workflow behavior. Documentation follows the openBuggy taxonomy (feature architecture, SOPs, research, analysis, roadmaps) adapted for a **workspace-pointing companion**, not a Bugbot-only engine. Live `~/.cursor` import is a **Phase 3 archaeology** snapshot; current Cursor workflow files: [overlays/cursor](./overlays/cursor/_index.md). This repo is **Target** contract SoT. Stack variation: [skill source and host overlays](./featureArchitecture/skill-source-and-host-overlays.md).

**First host attempt:** T3 Code (control plane) + OpenCode (harness); ClinePass **Desired** later; skill-based `bug_reviewer`. Operator study: [host recreation](./analysis/host-recreation-2026-08.md).

Stewardship and non-goals: [design decisions](./review/design-decisions.md).

---

## Guiding principles

| Principle | Detail |
| --------- | ------ |
| **Own the workflow** | Plan, review, and agent roles are first-class artifacts — not hidden in IDE defaults. |
| **Own the skill inventory** | Skills, agents, and gates live in this git repo (Theo `fleet` analog across **stacks**, not machines). |
| **Own repository knowledge** | Discovery, context, and SOPs live in-repo and remain portable. |
| **Own evaluation** | Workflow quality is measurable; imports and deltas are documented. |
| **Backends replaceable** | Models, providers, and execution surfaces (CLI, MCP, thin IDE, T3) swap without rewriting intent docs. |
| **Docs before runtime** | This archive prevents parallel invented architecture; recreation uses external hosts first. |
| **Personal workflow first** | Built for the owner's loop, not a general IDE product or commercial offering. |

---

## Current status

| Area | Status |
| ---- | ------ |
| Documentation foundation | **Phase 5 closeout** — pending Composer QC commit ([initialization report](./review/initialization-report.md)) |
| First host lock-in | **T3 + OpenCode** — [host recreation](./analysis/host-recreation-2026-08.md); U2 settled, U8 withdrawn |
| Runtime / engine / packages | **Not started** (recreation is external) |
| Research imports (openBuggy) | **Complete** (Phase 2) — research only, not v0 bug transport |
| Research imports (AITestSuite, live `~/.cursor`) | **Complete** (Phase 3) — [workflow-source-delta](./research/imported/workflow-source-delta.md) |
| Target synthesizing architecture docs | **Complete** (Phase 4) — [feature architecture index](./featureArchitecture/_index.md) |
| Agent & skill contracts | **Complete** (Phase 4) — [agents](./agents/_index.md) · [skills](./skills/_index.md) |
| Implementation roadmap | [implementation-roadmap.md](./roadmaps/implementation-roadmap.md) — R0 dogfood |
| Skill-manager identity | **Phase 1 committed** (`9c104b1`). **Phase 2 overlay FA landed.** **Cursor workflow overlay extract** — [docs/overlays/cursor](./overlays/cursor/_index.md). |

---

## Directory structure

| Path | Purpose |
| ---- | ------- |
| [`README.md`](../README.md) | Repo entry; points here |
| [`review/`](./review/_index.md) | Project intent and design decisions |
| [`featureArchitecture/`](./featureArchitecture/_index.md) | Intended system behavior (Target) |
| [`agents/`](./agents/_index.md) | Host-agnostic role contracts |
| [`skills/`](./skills/_index.md) | Host-agnostic skill contracts |
| [`overlays/`](./overlays/_index.md) | Host-native recorded files (Cursor workflow extract) |
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
| Instruction layering | [instruction-layering.md](./featureArchitecture/instruction-layering.md) |
| Clean-context isolation | [clean-context-isolation.md](./featureArchitecture/clean-context-isolation.md) |
| Portable vs Cursor-specific | [desired-behavior-vs-cursor-specific.md](./featureArchitecture/desired-behavior-vs-cursor-specific.md) |
| Cursor behaviors to preserve | [cursor-behavior-to-reproduce.md](./featureArchitecture/cursor-behavior-to-reproduce.md) |
| Backend abstraction | [backend-and-provider-abstraction.md](./featureArchitecture/backend-and-provider-abstraction.md) |
| Repository discovery | [repository-discovery-and-context.md](./featureArchitecture/repository-discovery-and-context.md) |
| Workspace model | [workspace-model.md](./featureArchitecture/workspace-model.md) |
| Skill source and host overlays | [skill-source-and-host-overlays.md](./featureArchitecture/skill-source-and-host-overlays.md) |
| Agent roles | [agent-roles-and-model-assignment.md](./featureArchitecture/agent-roles-and-model-assignment.md) |
| Evaluation | [evaluation-methodology.md](./featureArchitecture/evaluation-methodology.md) |
| Backend landscape | [preliminary-backend-landscape.md](./research/preliminary-backend-landscape.md) |
| Host recreation study | [host-recreation-2026-08.md](./analysis/host-recreation-2026-08.md) |
| Open questions | [unresolved-architectural-questions.md](./review/unresolved-architectural-questions.md) |
| Future implementation | [implementation-roadmap.md](./roadmaps/implementation-roadmap.md) |

---

## Initialization and future implementation

| Roadmap | Purpose |
| ------- | ------- |
| [cursorEscape initialization](./roadmaps/cursorEscape-initialization.md) | Bootstrap docs, import research, author Target FA docs, closeout report |
| [Implementation roadmap](./roadmaps/implementation-roadmap.md) | R0 T3+OpenCode dogfood; optional later engine |

---

## Implications / open questions

1. Engine language and license remain **Unknown**; U2/U8 settled — see [unresolved architectural questions](./review/unresolved-architectural-questions.md).
2. Bugbot-shaped review uses OpenCode `bug_reviewer` + skills; openBuggy is research / optional later.
3. Keep hub docs extend-only; do not fork parallel taxonomies.
4. Multi-machine skill sync remains a **non-goal**. Overlay architecture must not create two authored review procedures.
5. Overlay FA ([skill-source-and-host-overlays](./featureArchitecture/skill-source-and-host-overlays.md)) is the SoT for shared procedure vs additive host overlays. Do not fork two authored review procedures.

---

## Related

- [Relationship to siblings](./review/relationship-to-siblings.md) — openBuggy, AITestSuite, live `~/.cursor`
- [Design decisions](./review/design-decisions.md)
- [Host recreation study](./analysis/host-recreation-2026-08.md)
- [Documenting this repo (SOP)](./SOPs/documenting-this-repo.md)
- [Roadmaps index](./roadmaps/_index.md)
- [Theo fleet skill management (Observed)](./research/theo-fleet-skill-management.md)
