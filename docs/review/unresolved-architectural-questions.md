# Unresolved Architectural Questions

**Last updated:** 2026-08-17

## Context

Deliberately **Unknown** decisions — not pretend-settled. Archaeology snapshot at init closeout: [initialization report](./initialization-report.md). Runtime work waits for explicit implementation phase.

Claim label: **Unknown** unless noted otherwise.

---

## Substance

### Runtime and stack

| # | Question | Notes |
| - | -------- | ----- |
| U1 | Engine language (TypeScript, Python, …)? | Blocked until implementation roadmap spike |
| U2 | Primary backend adapter — Cline, OpenCode, other? | [preliminary backend landscape](../research/preliminary-backend-landscape.md) |
| U3 | Companion config location — global vs `.cursorEscape/` in target repo? | [workspace model](../featureArchitecture/workspace-model.md) |
| U4 | Unified agent API schema | [backend abstraction](../featureArchitecture/backend-and-provider-abstraction.md) |

### Workflow and discovery

| # | Question | Notes |
| - | -------- | ----- |
| U5 | Re-home repo-local `reference-docs` skill vs global discovery only? | [workflow-source-delta](../research/imported/workflow-source-delta.md) |
| U6 | Generated index tier (LSP, embeddings) for v1? | [repository discovery](../featureArchitecture/repository-discovery-and-context.md) |
| U7 | Monorepo / multi-root workspace scoping | [workspace model](../featureArchitecture/workspace-model.md) |

### Review and eval

| # | Question | Notes |
| - | -------- | ----- |
| U8 | openBuggy MCP vs CLI as default bug_reviewer transport | External sibling — not reimplemented first |
| U9 | When to invoke optional test_reviewer vs production_readiness only | [agent roles](../featureArchitecture/agent-roles-and-model-assignment.md) |
| U10 | Eval harness ownership — cursorEscape repo vs AITestSuite pattern | [evaluation methodology](../featureArchitecture/evaluation-methodology.md) |

### Distribution

| # | Question | Notes |
| - | -------- | ----- |
| U11 | License and public release gate | [design decisions](./design-decisions.md) |
| U12 | Remote hosting if open-sourced | **Unknown** |
| U13 | Default model provider per role | **Unknown** — BYOK; see [agent roles](../featureArchitecture/agent-roles-and-model-assignment.md) |

---

## Implications / open questions

1. Target docs may cite these IDs when marking **Unknown** claims elsewhere.
2. Resolving a question requires updating the relevant Target doc + this list in the same change set.

---

## Related

- [Design decisions](./design-decisions.md)
- [Implementation roadmap](../roadmaps/implementation-roadmap.md)
- [Initialization roadmap](../roadmaps/cursorEscape-initialization.md)
