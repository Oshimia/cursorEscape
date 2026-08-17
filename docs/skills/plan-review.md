# plan-review

**Last updated:** 2026-08-17

## Context

**Target** skill concepts for iterative plan review — not a separate executable skill in live `~/.cursor` (plan gate lives in [implementation-plan](./implementation-plan.md) + [plan_reviewer](../agents/plan_reviewer.md)). Process doc: [iterative-plan-review](../research/imported/cursor-global-workflow/docs/workflow/iterative-plan-review.md).

---

## Substance

### When to use (Required)

Non-trivial plans with Escalation or multi-phase roadmaps — before implementation starts.

### Workflow steps

1. Planner produces full synthesized plan each pass
2. plan_reviewer reviews with clean context (no prior review transcript dependency)
3. Planner synthesizes — fix blockers; Unknowns → discovery steps
4. Repeat up to **3 passes** or early APPROVED
5. Present to user on CHANGES REQUESTED with outstanding items

### Outputs

- APPROVED plan ready for implementer
- Or CHANGES REQUESTED with explicit blockers

### Must not

- Start implementation before APPROVED (unless user explicitly skips)
- Exceed 3 plan-reviewer passes without escalation
- Compress plan review when Composer assigned for phased execution (planning already complete)

### Composer exception (Cursor-specific)

When Composer executes phased roadmaps, phase subagent does not re-run plan-review for Nb — conductor plan already accepted.

### Related roles

[planner](../agents/planner.md), [plan_reviewer](../agents/plan_reviewer.md)

---

## Implications / open questions

1. Distinct from implementation-review — plan gate is **before** code/docs implementation.

---

## Related

- [implementation-plan](./implementation-plan.md)
- [plan_reviewer agent](../agents/plan_reviewer.md)
