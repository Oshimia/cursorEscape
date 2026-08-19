# plan-review

**Last updated:** 2026-08-20

## Context

**Target** skill concepts for iterative plan review — not a separate executable skill in live `~/.cursor` (plan gate lives in [implementation-plan](./implementation-plan.md) + [plan_reviewer](../agents/plan_reviewer.md)). Process doc: [iterative-plan-review](../../workflow/iterative-plan-review.md).

---

## Substance

### When to use (Required)

**Default on** whenever a plan was drafted under [implementation-plan](./implementation-plan.md) — before implementation starts.

Does **not** require Escalation=yes or a multi-phase roadmap. Escalation only controls Agent context scaffolding ([implementation-plan Escalation when](./implementation-plan.md#escalation-when-sole-sot)).

**When in doubt, run the plan_reviewer loop.**

**Skip only if:** truly trivial (see implementation-plan skip list), user **explicitly** opts out, or Composer is assigned for phased **execution** of an already-accepted plan.

### Workflow steps

1. Planner produces full synthesized plan each pass — plan incomplete until [implementation-plan Incomplete until](./implementation-plan.md#incomplete-until-section-sot) SoT is met
2. plan_reviewer reviews with clean context (no prior review transcript dependency); APPROVED requires SoT compliance ([plan_reviewer](../agents/plan_reviewer.md))
3. Planner synthesizes — fix blockers; Unknowns → discovery steps
4. Repeat up to **3 passes** or early APPROVED
5. Present to user on CHANGES REQUESTED with outstanding items

**Parent incomplete until** APPROVED, or after pass 3 with outstanding blockers surfaced to the user. Do not start implementation while CHANGES REQUESTED blockers remain (unless user explicitly opts out).

### Outputs

- APPROVED plan ready for implementer
- Or CHANGES REQUESTED with explicit blockers

### Must not

- Start implementation before APPROVED (unless user explicitly opts out)
- Skip the gate because Escalation=no or the work is “just docs/eval/harness”
- Exceed 3 plan-reviewer passes without owner escalation
- Compress plan review when Composer assigned for phased execution (planning already complete)
- Duplicate the full Incomplete until section enum here — point at [implementation-plan](./implementation-plan.md#incomplete-until-section-sot)

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
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
