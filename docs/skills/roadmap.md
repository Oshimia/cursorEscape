# roadmap

**Last updated:** 2026-08-19

## Context

**Target** optional skill for authoring multi-phase handoff roadmaps. Full Cursor skill (Observed, unchanged): [overlay SKILL.md](../../overlays/cursor/skills/roadmap/SKILL.md). Distinct from [implementation roadmap](../roadmaps/implementation-roadmap.md) (future runtime work).

---

## Substance

### When to use (Nice-to-have)

Large or multi-phase initiatives needing Agent context blocks per phase and explicit CI/deliverable gates.

### Workflow steps

1. Draft roadmap with phases, inter-phase contracts, Agent context per phase (Escalation *when* per [implementation-plan](./implementation-plan.md))
2. Run `plan_reviewer` on the drafted roadmap under default-on plan gate (Escalation ≠ whether the gate runs — see [plan-review](./plan-review.md))
3. Link from `docs/roadmaps/_index.md` and [Roadmap hub](../Roadmap.md)
4. Hand to Composer or sequential implementers

### Outputs

- Roadmap markdown with Agent context blocks per phase
- Index links from `docs/roadmaps/_index.md` and [Roadmap hub](../Roadmap.md)

### Required roadmap fields

- Last updated, Status, Escalation
- Per phase: Goal, Depends on, Do not touch, In scope, Out of scope, Where to read context, Fast CI, Full CI, Deliverables

### Must not

- Confuse conductor roadmap (initialization) with implementation roadmap (future build)
- Delete prior phase checklists without owner decision

### Related roles

[planner](../agents/planner.md), [plan_reviewer](../agents/plan_reviewer.md), [implementer](../agents/implementer.md)

---

## Implications / open questions

1. cursorEscape initialization uses this pattern in [cursorEscape-initialization.md](../roadmaps/cursorEscape-initialization.md).

---

## Related

- [composer](./composer.md)
- [implementation-plan](./implementation-plan.md)
- [Roadmaps index](../roadmaps/_index.md)
