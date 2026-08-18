# Desired Behavior vs Cursor-Specific

**Last updated:** 2026-08-18

## Context

cursorEscape separates **portable workflow intent** (Desired / Required) from **Cursor IDE mechanics** (Cursor-specific). Target contracts in [agents](../agents/_index.md) and [skills](../skills/_index.md) use host-agnostic wording; first recreation adapter is **OpenCode** (with optional **T3 Code** control plane) — see [host recreation](../analysis/host-recreation-2026-08.md).

---

## Substance

### Claim taxonomy (Required)

| Label | Meaning |
| ----- | ------- |
| **Required** | Must hold for cursorEscape to meet intent |
| **Desired** | Strong default; may yield with documented trade-off |
| **Nice-to-have** | Improves loop quality; not blocking |
| **Cursor-specific** | Tied to Cursor Desktop, Task/subagent IDs, or proprietary Bugbot |
| **Unknown** | Deliberately unsettled — see [unresolved questions](../review/unresolved-architectural-questions.md) |

### Portable (Desired / Required)

| Behavior | Label | Notes |
| -------- | ----- | ----- |
| Plan + plan_reviewer before implementation | **Required** | Default on unless truly trivial or **explicit** user opt-out; eval/harness not exempt ([implementation-plan](../skills/implementation-plan.md)) |
| plan_reviewer gate on drafted plans | **Required** | Up to 3 passes regardless of Escalation; **skip** when Composer executes accepted roadmap ([plan-review](../skills/plan-review.md)) |
| Fast CI Observed before dual review | **Required** | Per-command rows; no claimed-only launch |
| Parallel production_readiness_reviewer + bug_reviewer | **Required** | Complementary legs ([openBuggy synthesis](../research/imported/openBuggy/analysis/reviewer-effectiveness/synthesis/recommendation.md)) |
| Fix all must-fix from either leg | **Required** | Re-launch both after each batch |
| Full CI only after dual APPROVED | **Required** when Full ≠ `n/a` | When Full = `n/a`, dual APPROVED + explicit user ack before commit; never pair Full with reviewers |
| Split Reviewer-a bar (Batchable deferred OK) | **Required** | Live workflow; not freeze unified bar |
| Repository doc discovery before edits | **Required** | [discovery](../skills/discovery.md) |
| Thin always-on gates; on-demand skills / deep docs / lean agents | **Required** | [instruction layering](./instruction-layering.md) |
| Isolated child review handoffs (no prior review transcripts) | **Required** | [clean-context isolation](./clean-context-isolation.md) |
| Full CI before commit when Full ≠ `n/a` (on-demand policy) | **Required** | [pre-commit-ci-gate](../skills/pre-commit-ci-gate.md) |
| BYOK model keys | **Required** | [design decisions](../review/design-decisions.md) |
| Replaceable backends and models | **Required** | [backend abstraction](./backend-and-provider-abstraction.md) |
| First host: OpenCode + T3 control plane | **Desired** | [design decisions](../review/design-decisions.md) |
| ClinePass (or equivalent) as OpenCode provider | **Desired** | Later; U13 unproven |
| Role + model assignment via config | **Desired** | Not hardcoded in prompts ([agent roles](./agent-roles-and-model-assignment.md)) |
| Iteration narrowing after many launches | **Nice-to-have** | Live guidance at count ≥ 9 |

### Cursor-specific (map, do not hard-require)

| Cursor surface | Portable equivalent |
| -------------- | ------------------- |
| `Task` tool / `subagent_type: reviewer-a` | **production_readiness_reviewer** role contract (OpenCode subagent) |
| `subagent_type: bugbot` | **bug_reviewer** OpenCode subagent + skills — not openBuggy-required |
| `subagent_type: plan-reviewer` | **plan_reviewer** |
| Composer thread + phase subagents | Orchestrator with phase handoff + QC parent |
| `~/.cursor/skills/` paths | OpenCode skill dirs / host skill registry |
| Cursor rules (`.mdc` alwaysApply) + User Rules snippets | Thin always-on host instructions ([instruction layering](./instruction-layering.md)) |
| `disable-model-invocation` on skills | Host on-demand skill load (do not always-inject) |
| `alwaysApply: false` pre-commit rule | On-demand Full-before-commit ([pre-commit-ci-gate](../skills/pre-commit-ci-gate.md)) |
| Task clean-context subagents | Isolated child handoffs ([clean-context isolation](./clean-context-isolation.md)) |
| Progress timeline (`UpdateCurrentStep`) | **Nice-to-have** UX; not a workflow gate |

### Deliberately not Cursor goals

| Item | Label |
| ---- | ----- |
| Reproduce Cursor's proprietary index | **Unknown** as v0 goal — see [repository discovery](./repository-discovery-and-context.md) |
| Lock to Cursor subscription for review | **Required** non-goal per [design decisions](../review/design-decisions.md) |
| Require VS Code | **Required** non-goal — T3 or thin client acceptable |

---

## Implications / open questions

1. OpenCode adapters must preserve gate semantics without Cursor Task/subagent IDs.
2. Whether future cursorEscape ships host always-on snippet files (vs documenting the pattern only) is a **later** packaging question — see [instruction layering](./instruction-layering.md).

---

## Related

- [Cursor behavior to reproduce](./cursor-behavior-to-reproduce.md)
- [Intended workflow](./intended-workflow.md)
- [Instruction layering](./instruction-layering.md)
- [Clean context and isolation](./clean-context-isolation.md)
- [Host recreation study](../analysis/host-recreation-2026-08.md)
- [Agent role contracts](../agents/_index.md)
