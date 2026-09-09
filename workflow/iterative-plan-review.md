# Iterative plan review

**Skills:** [plan-review](../skills/plan-review/SKILL.md) (loop gate), [implementation-plan](../skills/implementation-plan/SKILL.md) (draft + Incomplete until SoT). **Agent:** [plan_reviewer](../agents/plan_reviewer.md).

## When mandatory

**Default on** whenever a plan was drafted under [implementation-plan](../skills/implementation-plan/SKILL.md) — before implementation starts.

Does **not** require Escalation=yes or a multi-phase roadmap. Escalation only controls Agent context scaffolding ([implementation-plan Escalation when](../skills/implementation-plan/SKILL.md#escalation)).

Multi-file, cross-layer, behavioral, DB/migration, new patterns, external deps, or ambiguous scope. **When in doubt, run the plan_reviewer loop.**

Skip only: one-place typo/copy, comment-only, pure formatting, cosmetic-only UI, docs-only with no behavior change, user **explicit** opt-out, or Composer assigned for phased **execution** of an already-accepted plan.

**Composer exception:** When assigned as [composer](../skills/composer/SKILL.md) for execution, do not draft plans or invoke plan-reviewer. Defer phase launches until the user accepts the plan/roadmap. If the user asks Composer to **plan**, use [implementation-plan](../skills/implementation-plan/SKILL.md) with Escalation **yes** instead.

Every non-trivial plan must include the **Escalation** field (`Agent context required: yes|no`). When **yes**, include per-phase Agent context per [plan-agent-context.md](plan-agent-context.md) — not only after accept in a roadmap.

**Parent incomplete until** APPROVED, or after pass 3 with outstanding blockers surfaced to the user. Do not start implementation while CHANGES REQUESTED blockers remain (unless user explicitly opts out).

## Workflow

```text
Draft → review → synthesize (max 3) → present to user → user decides
```

1. Planner produces full synthesized plan each pass — plan incomplete until [implementation-plan Incomplete until](../skills/implementation-plan/SKILL.md#incomplete-until-section-sot) SoT is met
2. Draft with [implementation-plan](../skills/implementation-plan/SKILL.md) template — apply the [phase sizing and split gate](../skills/implementation-plan/SKILL.md#phase-sizing-and-split-gate) before naming phases (oversized/bundled phases are blocking); when the plan touches migrations/schema/RPC/deploy SOPs, lift each repo post-apply checklist item into Incremental execution or Verification (not External dependencies only)
3. Invoke [plan_reviewer](../agents/plan_reviewer.md) with clean context (full synthesized plan only). Recommended model: see [review-subagent-models.md](../overlays/cursor/review-subagent-models.md). Reviewer treats buried SOP post-apply steps as an unacknowledged verification gap
4. On `CHANGES REQUESTED`: fix blockers and unacknowledged gaps; re-invoke
5. After pass 3 or early `APPROVED`: present to user; wait if still `CHANGES REQUESTED`

## Must not

- Start implementation before APPROVED (unless user explicitly opts out)
- Skip the gate because Escalation=no or the work is “just docs/eval/harness”
- Exceed 3 plan-reviewer passes without owner escalation
- Feed previous child transcripts into the next `plan_reviewer` Task
- Duplicate the full Incomplete until section enum — point at [implementation-plan Incomplete until](../skills/implementation-plan/SKILL.md#incomplete-until-section-sot)
- Compress plan review when Composer assigned for phased execution (planning already complete)

## After acceptance

Implement one phase at a time. Each phase ends with [iterative-code-review.md](iterative-code-review.md). For escalated / Composer work, use [phased-multi-agent.md](phased-multi-agent.md) and the [roadmap](../skills/roadmap/SKILL.md) skill (copy vs restructure per Escalation — [plan-agent-context.md](plan-agent-context.md)).

## Related

- [discovery.md](discovery.md)
- [plan-agent-context.md](plan-agent-context.md)
- [iterative-code-review.md](iterative-code-review.md)
- [phased-multi-agent.md](phased-multi-agent.md)
- [review-subagent-models.md](../overlays/cursor/review-subagent-models.md)
- [plan-review](../skills/plan-review/SKILL.md)
- [implementation-plan](../skills/implementation-plan/SKILL.md)
- [composer](../skills/composer/SKILL.md)
- [_index.md](_index.md)
