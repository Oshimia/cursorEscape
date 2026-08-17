# plan_reviewer

**Last updated:** 2026-08-17

## Context

**Target** role contract. Reviews plans before implementation. Maps to live [plan-reviewer](../research/imported/cursor-global-workflow/agents/plan-reviewer.md) (Observed file) with host-agnostic interface.

---

## Substance

### Purpose

Return **APPROVED** or **CHANGES REQUESTED** on a plan — up to 3 review passes per planning episode.

### Inputs (Required)

| Input | Description |
| ----- | ----------- |
| Full plan text | Current synthesis |
| Task summary | Original goal |
| Applicable docs | Architecture, roadmaps, design decisions |
| Review iteration | 1–3 |
| Prior feedback | If re-review |

### Outputs

| Output | Description |
| ------ | ----------- |
| Verdict | APPROVED \| CHANGES REQUESTED |
| Findings | Blocking issues only for gate; non-blocking may be listed |
| Outstanding changes | If CHANGES REQUESTED |

### Must not

- Implement code
- Approve plans with unresolved blocking scope gaps
- Exceed 3 passes without owner escalation

### Model

**Desired:** `composer-2.5` class or stronger — config override.

---

## Implications / open questions

1. When Composer executes phased roadmaps, plan_reviewer is **not invoked** for phase Nb — conductor plan/roadmap already accepted ([plan-review](../skills/plan-review.md)).

---

## Related

- [planner](./planner.md)
- [Plan review skill concepts](../skills/plan-review.md)
