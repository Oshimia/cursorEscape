# Unresolved Architectural Questions

**Last updated:** 2026-08-19

## Context

Deliberately **Unknown** decisions — not pretend-settled — plus questions **settled** by the 2026-08 host-recreation lock-in. Archaeology snapshot at init closeout: [initialization report](./initialization-report.md). Operator study: [host recreation](../analysis/host-recreation-2026-08.md). Runtime work in this repo waits for explicit implementation phase; first recreation uses external T3 + OpenCode.

Claim label: **Unknown** unless noted otherwise.

---

## Substance

### Settled (2026-08 host lock-in)

| # | Question | Decision |
| - | -------- | -------- |
| U2 | Primary backend adapter | **OpenCode** (first attempt). **T3 Code** is the control plane (observability), not the harness. Spike still required for parallel Task honesty — see [implementation roadmap](../roadmaps/implementation-roadmap.md) R0. |
| U8 | openBuggy as default bug_reviewer transport | **Withdrawn for v0.** Bug leg = OpenCode `bug_reviewer` subagent + skills (reviewer-a pattern). openBuggy remains research / optional later. |

### Partial (2026-08-19 identity / overlay)

| # | Question | Decision |
| - | -------- | -------- |
| U3 (skill inventory) | Where is the canonical skill/adapter tree? | **This companion repo** is Target SoT. Host dirs (`~/.config/opencode`, `~/.cursor`) are **copy-out targets**. See [skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md). |
| U3 (target-repo config) | Companion config in target repo (`.cursorEscape/`) vs global? | Still **Unknown** — [workspace model](../featureArchitecture/workspace-model.md). Do not treat skill-inventory SoT as settling this. |

### Runtime and stack

| # | Question | Notes |
| - | -------- | ----- |
| U1 | Engine language (TypeScript, Python, …)? | **Unknown** — blocked until a cursorEscape runtime is authorized (not required for T3+OpenCode recreation) |
| U4 | Unified agent API schema | [backend abstraction](../featureArchitecture/backend-and-provider-abstraction.md) — OpenCode markdown agents are the v0 adapter surface |

### Workflow and discovery

| # | Question | Notes |
| - | -------- | ----- |
| U5 | Re-home repo-local `reference-docs` skill vs global discovery only? | [workflow-source-delta](../research/imported/workflow-source-delta.md) |
| U6 | Generated index tier (LSP, embeddings) for v1? | [repository discovery](../featureArchitecture/repository-discovery-and-context.md) |
| U7 | Monorepo / multi-root workspace scoping | [workspace model](../featureArchitecture/workspace-model.md) |

### Review and eval

| # | Question | Notes |
| - | -------- | ----- |
| U9 | When to invoke optional test_reviewer vs production_readiness only | [agent roles](../featureArchitecture/agent-roles-and-model-assignment.md); contract [test_reviewer.md](../agents/test_reviewer.md) — Desired triggers only; mandatory policy still **Unknown** |
| U10 | Eval harness ownership — cursorEscape repo vs AITestSuite pattern | [evaluation methodology](../featureArchitecture/evaluation-methodology.md) |

### Distribution

| # | Question | Notes |
| - | -------- | ----- |
| U11 | License and public release gate | [design decisions](./design-decisions.md) |
| U12 | Remote hosting if open-sourced | **Unknown** |
| U13 | Default model provider per role | **Unknown** (unproven) — **Desired:** ClinePass (or equivalent) when using OpenCode; see [agent roles](../featureArchitecture/agent-roles-and-model-assignment.md) |

---

## Implications / open questions

1. Target docs may cite these IDs when marking **Unknown** claims elsewhere.
2. Resolving a question requires updating the relevant Target doc + this list in the same change set.
3. Init report Q6/U2/U8 narrative is superseded by [host recreation](../analysis/host-recreation-2026-08.md) — do not treat the Phase 5 archaeology body as live adapter choice.

---

## Related

- [Design decisions](./design-decisions.md)
- [Host recreation study](../analysis/host-recreation-2026-08.md)
- [Implementation roadmap](../roadmaps/implementation-roadmap.md)
- [Initialization roadmap](../roadmaps/cursorEscape-initialization.md)
- [Skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)
