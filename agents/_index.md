# Agent Role Contracts

**Last updated:** 2026-08-20

## Context

Host-agnostic **portable** agent contracts at repo root. Portable contracts live in `agents/*.md`. Cursor overlay **thin wrappers** (spawn one-pagers + Read): [overlays/cursor/agents](../overlays/cursor/agents/). The 2026-08-17 bannered copy remains under [cursor-global-workflow/agents](../research/imported/cursor-global-workflow/agents/) (archaeology). These pages use host-agnostic role names, not Cursor Task IDs as the contract identity.

---

## Substance

### Contract index

| Role | Contract | Phase | Cursor overlay (thin wrapper) |
| ---- | -------- | ----- | ------------------------- |
| planner | [planner.md](./planner.md) | Plan | (no Cursor agent file) |
| plan_reviewer | [plan_reviewer.md](./plan_reviewer.md) | Plan gate | [plan-reviewer.md](../overlays/cursor/agents/plan-reviewer.md) |
| implementer | [implementer.md](./implementer.md) | Build | (no Cursor agent file) |
| production_readiness_reviewer | [production_readiness_reviewer.md](./production_readiness_reviewer.md) | Review (dual gate) | [reviewer-a.md](../overlays/cursor/agents/reviewer-a.md) |
| bug_reviewer | [bug_reviewer.md](./bug_reviewer.md) | Review (dual gate) | Cursor product Bugbot (no owner file) |
| repository_explorer | [repository_explorer.md](./repository_explorer.md) | Investigate | (no Cursor agent file) |
| test_reviewer | [test_reviewer.md](./test_reviewer.md) | Review (optional; **not** default dual gate) | (no Cursor agent file) |

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

## Related

- [Agent roles and model assignment](../docs/featureArchitecture/agent-roles-and-model-assignment.md)
- [Skills index](../skills/_index.md)
- [Rules index](../rules/_index.md)
- [Workflow index](../workflow/_index.md)
- [Intended workflow](../docs/featureArchitecture/intended-workflow.md)
- [Instruction layering](../docs/featureArchitecture/instruction-layering.md)
- [Clean context and isolation](../docs/featureArchitecture/clean-context-isolation.md)
- [Cursor overlay](../overlays/cursor/_index.md)
- [Host recreation study](../analysis/host-recreation-2026-08.md)
