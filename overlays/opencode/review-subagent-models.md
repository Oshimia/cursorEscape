**Recommended default** for [plan_reviewer](agents/plan_reviewer.md), [production_readiness_reviewer](agents/production_readiness_reviewer.md), and [bug_reviewer](agents/bug_reviewer.md): `composer-2.5`.

Override anytime via chat or the Task `model` parameter. There is **no** profile swap system — do not look for `.cursor/review-profiles/` or swap scripts.

Paths below are relative to the OpenCode config root (`OPENCODE_HOME`), not this file.

## Related

- [iterative-plan-review.md](docs/workflow/iterative-plan-review.md)
- [iterative-code-review.md](docs/workflow/iterative-code-review.md)
- [implementation-plan](skills/implementation-plan/SKILL.md)
- [implementation-review](skills/implementation-review/SKILL.md)
- [composer](skills/composer/SKILL.md)
- [README.md](docs/workflow/README.md)
