# implementation-plan

**Last updated:** 2026-08-17

## Context

**Target** skill contract. Draft structured plans before non-trivial work. Full skill: [live import](../research/imported/cursor-global-workflow/skills/implementation-plan/SKILL.md).

---

## Substance

### When to use (Required)

- Multi-file or cross-layer changes
- New modules, migrations, behavioral changes
- User assigns explicit planning
- Roadmap phase with Agent context

**May skip:** Trivial one-place copy/formatting when user or rule says so.

### Workflow steps

1. **Discovery** — [discovery](./discovery.md) Step 0 + repo indexes
2. **Draft plan** — template: goal, phases, files, risks, Escalation, Agent context per phase
3. **plan_reviewer loop** — up to 3 passes until APPROVED (**skip** when Composer is assigned for phased execution — accepted roadmap already gated)
4. **Handoff** — implementer or phase subagent

### Outputs

- Written plan (roadmap file or inline)
- Classified claims (Desired/Required/Nice-to-have/Cursor-specific/Unknown)
- Fast/Full CI notes per phase when applicable

### Must not

- Implement during planning (except disposable Na previews per Composer policy)
- Omit Escalation field on escalated plans
- Invent required doc trees without discovery

### Related roles

[planner](../agents/planner.md), [plan_reviewer](../agents/plan_reviewer.md)

---

## Implications / open questions

1. Composer exception: when user assigns Composer for phased **execution**, planning is already complete — **skip** plan_reviewer; defer to Composer QC on the accepted roadmap.

---

## Related

- [plan-review](./plan-review.md)
- [implementation-review](./implementation-review.md)
