# Agent Role Contracts

**Last updated:** 2026-08-19

## Context

Host-agnostic **Target** contracts for cursorEscape orchestration. Portable contracts live in this folder (companion-repo **Target** SoT). Adapters map these roles to native agent types (e.g. Cursor `reviewer-a` → production_readiness_reviewer; OpenCode markdown agents for first recreation). Imported Cursor agent files under [cursor-global-workflow](../research/imported/cursor-global-workflow/agents/) are **Observed interim** snapshots of Cursor wording, not a second procedure tree.

---

## Substance

### Contract index

| Role | Contract | Phase |
| ---- | -------- | ----- |
| planner | [planner.md](./planner.md) | Plan |
| plan_reviewer | [plan_reviewer.md](./plan_reviewer.md) | Plan gate |
| implementer | [implementer.md](./implementer.md) | Build |
| production_readiness_reviewer | [production_readiness_reviewer.md](./production_readiness_reviewer.md) | Review (dual gate) |
| bug_reviewer | [bug_reviewer.md](./bug_reviewer.md) | Review (dual gate) |
| repository_explorer | [repository_explorer.md](./repository_explorer.md) | Investigate |
| test_reviewer | [test_reviewer.md](./test_reviewer.md) | Review (optional; **not** default dual gate) |

### Shared contract fields (Required)

Every role page defines:

1. **Purpose** — one paragraph
2. **Inputs** — context the parent must supply
3. **Outputs** — artifacts and verdict shape
4. **Must not** — scope boundaries
5. **Model** — config override; default suggestion only

### Verdict bars

| Role | APPROVED when |
| ---- | ------------- |
| plan_reviewer | No blocking plan issues (CHANGES REQUESTED otherwise) |
| production_readiness_reviewer | Blocking, Non-blocking (code/process), blocking test/docs = `"None"`; Batchable deferred may remain |
| bug_reviewer | Blocking, Non-blocking, Test gaps = `"None"` |
| test_reviewer | Advisory findings — not required for dual APPROVED unless user elevates ([test_reviewer](./test_reviewer.md)) |

---

## Implications / open questions

1. **Unknown:** Machine-readable schema for contracts (future).
2. Do not require Cursor Task/subagent IDs in parent prompts — use role names.
3. First host: OpenCode agents with `edit: deny` on both dual-gate reviewers — [host recreation](../analysis/host-recreation-2026-08.md).
4. Isolated child handoffs: [clean-context isolation](../featureArchitecture/clean-context-isolation.md).

---

## Related

- [Agent roles and model assignment](../featureArchitecture/agent-roles-and-model-assignment.md)
- [Skills index](../skills/_index.md)
- [Intended workflow](../featureArchitecture/intended-workflow.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md) — lean role agents; do not paste full procedures
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
- [Host recreation study](../analysis/host-recreation-2026-08.md)
