# Iterative plan review

**Skill:** [implementation-plan](../docs/skills/implementation-plan.md). **Agent:** [plan_reviewer](../docs/agents/plan_reviewer.md).

## When mandatory

Multi-file, cross-layer, behavioral, DB/migration, new patterns, external deps, or ambiguous scope. **When in doubt, run it.**

Skip only: one-place typo/copy, comment-only, pure formatting, cosmetic-only UI, docs-only with no behavior change, or user skip.

**Composer exception:** When assigned as [composer](../docs/skills/composer.md) for execution, do not draft plans or invoke plan-reviewer. Defer phase launches until the user accepts the plan/roadmap. If the user asks Composer to **plan**, use [implementation-plan](../docs/skills/implementation-plan.md) with Escalation **yes** instead.

Every non-trivial plan must include the **Escalation** field (`Agent context required: yes|no`). When **yes**, include per-phase Agent context per [plan-agent-context.md](plan-agent-context.md) — not only after accept in a roadmap.

## Workflow

```text
Draft → review → synthesize (max 3) → present to user → user decides
```

1. Draft with [implementation-plan](../docs/skills/implementation-plan.md) template — when the plan touches migrations/schema/RPC/deploy SOPs, lift each repo post-apply checklist item into Incremental execution or Verification (not External dependencies only)
2. Invoke [plan_reviewer](../docs/agents/plan_reviewer.md) with clean context (full synthesized plan only). Recommended model: see [review-subagent-models.md](../overlays/cursor/review-subagent-models.md). Reviewer treats buried SOP post-apply steps as an unacknowledged verification gap
3. On `CHANGES REQUESTED`: fix blockers and unacknowledged gaps; re-invoke
4. After pass 3 or early `APPROVED`: present to user; wait if still `CHANGES REQUESTED`

## After acceptance

Implement one phase at a time. Each phase ends with [iterative-code-review.md](iterative-code-review.md). For escalated / Composer work, use [phased-multi-agent.md](phased-multi-agent.md) and the [roadmap](../docs/skills/roadmap.md) skill (copy vs restructure per Escalation — [plan-agent-context.md](plan-agent-context.md)).

## Related

- [discovery.md](discovery.md)
- [plan-agent-context.md](plan-agent-context.md)
- [iterative-code-review.md](iterative-code-review.md)
- [phased-multi-agent.md](phased-multi-agent.md)
- [review-subagent-models.md](../overlays/cursor/review-subagent-models.md)
- [implementation-plan](../docs/skills/implementation-plan.md)
- [composer](../docs/skills/composer.md)
- [_index.md](_index.md)
