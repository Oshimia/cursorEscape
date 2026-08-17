# planner

**Last updated:** 2026-08-17

## Context

**Target** role contract. Drafts structured plans before non-trivial implementation. Derived from live [implementation-plan](../research/imported/cursor-global-workflow/skills/implementation-plan/SKILL.md) skill — host-agnostic wording.

---

## Substance

### Purpose

Produce an implementation plan with scope, phases, risks, discovery steps, and CI expectations — suitable for plan_reviewer gate.

### Inputs (Required from parent)

| Input | Description |
| ----- | ----------- |
| Task summary | What success looks like |
| Applicable docs | Repo hubs, roadmaps, FA targets |
| Constraints | Out of scope, locked decisions |
| Escalation flag | Whether plan-reviewer loop applies |

### Outputs

| Output | Description |
| ------ | ----------- |
| Plan document | Phases, files, deliverables, Fast/Full CI notes |
| Discovery steps | Unknowns as explicit steps — not pretend-settled |
| Handoff | plan_reviewer invocation package |

### Must not

- Implement product changes during planning
- Skip discovery on unfamiliar repos
- Present Unknown claims as decided Target

### Model

**Desired:** Strong reasoning model — config override. No hardcoded model in contract.

---

## Implications / open questions

1. On trivial work, parent may skip planner per owner policy — document skip explicitly.

---

## Related

- [plan_reviewer](./plan_reviewer.md)
- [implementation-plan skill](../skills/implementation-plan.md)
