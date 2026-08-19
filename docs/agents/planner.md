# planner

**Last updated:** 2026-08-20

## Context

**Target** role contract. Drafts structured plans before implementation. Derived from live [implementation-plan](../overlays/cursor/skills/implementation-plan/SKILL.md) skill — host-agnostic wording. Gate policy SoT: [implementation-plan](../skills/implementation-plan.md).

---

## Substance

### Purpose

Produce an implementation plan with scope, Escalation, phases, risks, discovery steps, and CI expectations — suitable for the plan_reviewer gate.

### Inputs (Required from parent)

| Input | Description |
| ----- | ----------- |
| Task summary | What success looks like |
| Applicable docs | Repo hubs, roadmaps, FA targets |
| Constraints | Out of scope, locked decisions |
| Escalation hint | Optional parent hint for Escalation yes/no — **does not** control whether plan_reviewer runs |

### Outputs

| Output | Description |
| ------ | ----------- |
| Plan document | Scope, Escalation, phases, files, deliverables, Fast/Full CI notes |
| Discovery steps | Unknowns as explicit steps — not pretend-settled |
| Handoff | plan_reviewer invocation package (always, unless Skip applies) |

### Incomplete until

Plan handoff to [plan_reviewer](./plan_reviewer.md) is **incomplete** until [implementation-plan Incomplete until](../skills/implementation-plan.md#incomplete-until-section-sot) is met (unless Skip). Same urgency as missing Required Inputs.

### Must not

- Implement product changes during planning
- Skip discovery on unfamiliar repos
- Present Unknown claims as decided Target
- Treat Escalation=no as skip plan_reviewer
- Invoke plan_reviewer or present implement-ready before Incomplete until bar is met (unless Skip)
- Skip planning for eval/harness/operational multi-step work unless trivial or explicit user opt-out

### Model

**Desired:** Strong reasoning model — config override. No hardcoded model in contract.

---

## Implications / open questions

1. Skip planner only for truly trivial work or **explicit** user opt-out — document the skip in the parent turn.

---

## Related

- [plan_reviewer](./plan_reviewer.md)
- [implementation-plan skill](../skills/implementation-plan.md)
