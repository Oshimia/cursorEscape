> **Imported research** — Source: live `~/.cursor`; copied 2026-08-17 into cursorEscape. Status: Observed/imported (Observed interim Cursor wording; companion repo is Target contract SoT). Do not treat as Target cursorEscape design unless a Target doc cites it.
# Iterative plan review

**Skill:** [implementation-plan](../../skills/implementation-plan/SKILL.md). **Agent:** [plan-reviewer](../../agents/plan-reviewer.md).

## When mandatory

Multi-file, cross-layer, behavioral, DB/migration, new patterns, external deps, or ambiguous scope. **When in doubt, run it.**

Skip only: one-place typo/copy, comment-only, pure formatting, cosmetic-only UI, docs-only with no behavior change, or user skip.

**Composer exception:** When assigned as [composer](../../skills/composer/SKILL.md) for execution, do not draft plans or invoke plan-reviewer. Defer phase launches until the user accepts the plan/roadmap. If the user asks Composer to **plan**, use [implementation-plan](../../skills/implementation-plan/SKILL.md) with Escalation **yes** instead.

Every non-trivial plan must include the **Escalation** field (`Agent context required: yes|no`). When **yes**, include per-phase Agent context per [plan-agent-context.md](plan-agent-context.md) — not only after accept in a roadmap.

## Workflow

```text
Draft → review → synthesize (max 3) → present to user → user decides
```

1. Draft with [implementation-plan](../../skills/implementation-plan/SKILL.md) template — when the plan touches migrations/schema/RPC/deploy SOPs, lift each repo post-apply checklist item into Incremental execution or Verification (not External dependencies only)
2. Invoke [plan-reviewer](../../agents/plan-reviewer.md) with clean context (full synthesized plan only). Recommended model: see [review-subagent-models.md](review-subagent-models.md). Reviewer treats buried SOP post-apply steps as an unacknowledged verification gap
3. On `CHANGES REQUESTED`: fix blockers and unacknowledged gaps; re-invoke
4. After pass 3 or early `APPROVED`: present to user; wait if still `CHANGES REQUESTED`

## After acceptance

Implement one phase at a time. Each phase ends with [iterative-code-review.md](iterative-code-review.md). For escalated / Composer work, use [phased-multi-agent.md](phased-multi-agent.md) and the [roadmap](../../skills/roadmap/SKILL.md) skill (copy vs restructure per Escalation — [plan-agent-context.md](plan-agent-context.md)).

## Related

- [discovery.md](discovery.md)
- [plan-agent-context.md](plan-agent-context.md)
- [iterative-code-review.md](iterative-code-review.md)
- [phased-multi-agent.md](phased-multi-agent.md)
- [review-subagent-models.md](review-subagent-models.md)
- [implementation-plan](../../skills/implementation-plan/SKILL.md)
- [composer](../../skills/composer/SKILL.md)
- [README.md](README.md)
