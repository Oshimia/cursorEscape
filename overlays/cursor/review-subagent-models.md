# Review subagent models

**Recommended default** for plan-reviewer ([plan_reviewer](../../docs/agents/plan_reviewer.md)), reviewer-a ([production_readiness_reviewer](../../docs/agents/production_readiness_reviewer.md)), and Bugbot: `composer-2.5`.

Override anytime via chat or the Task `model` parameter. There is **no** profile swap system — do not look for `.cursor/review-profiles/` or swap scripts.

## Related

- [iterative-plan-review.md](../../workflow/iterative-plan-review.md)
- [iterative-code-review.md](../../workflow/iterative-code-review.md)
- [implementation-plan](../../docs/skills/implementation-plan.md)
- [implementation-review](../../docs/skills/implementation-review.md)
- [composer](../../docs/skills/composer.md)
- [workflow index](../../workflow/_index.md)
