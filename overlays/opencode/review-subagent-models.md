Review subagents ([plan_reviewer]({{COMPANION_ROOT}}/agents/plan_reviewer.md), [production_readiness_reviewer]({{COMPANION_ROOT}}/agents/production_readiness_reviewer.md), [bug_reviewer]({{COMPANION_ROOT}}/agents/bug_reviewer.md)) launched via Task **inherit the session's default model** — there is no per-Task `model` parameter on OpenCode (observed), and no profile swap system.

Routing problems surface as:

- **Empty/fast tasks** (< ~1s, empty result) — routing/auth failure; fail loud.
- **Shallow reviews** — wrong model class; treat review output with proportionate suspicion and re-run after a host-level fix.

The operator fixes model routing at the host level. The conductor agent (`composer_conductor`) carries no `model:` pin for portability; the operator may pin it author-time locally.

## Related

- [iterative-plan-review.md]({{COMPANION_ROOT}}/workflow/iterative-plan-review.md)
- [iterative-code-review.md]({{COMPANION_ROOT}}/workflow/iterative-code-review.md)
- [implementation-plan]({{COMPANION_ROOT}}/skills/implementation-plan/SKILL.md)
- [implementation-review]({{COMPANION_ROOT}}/skills/implementation-review/SKILL.md)
- [composer]({{COMPANION_ROOT}}/skills/composer/SKILL.md)
- [_index.md]({{COMPANION_ROOT}}/workflow/_index.md)
