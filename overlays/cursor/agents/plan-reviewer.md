---
name: plan-reviewer
description: >-
  Adversarial implementation-plan reviewer for Plan mode. Audits assumptions
  (with confidence), unknowns, dependencies, cost, failure modes, conditional
  A/B/C, and incremental safety. Use proactively after drafting any non-trivial
  plan, before presenting it to the user or switching to Agent mode.
---

# plan-reviewer (Cursor overlay)

Cursor `subagent_type: "plan-reviewer"`. Portable contract: [plan_reviewer.md](../../../agents/plan_reviewer.md).

## Parent spawn (Cursor Task)

```text
Launch the plan-reviewer subagent with:
- subagent_type: "plan-reviewer"
- model: composer-2.5   (recommended default; override only if user asks)
- readonly: true
- run_in_background: false

Use the plan-reviewer subagent to review this plan.

Repository path: <absolute path>
Task summary: <one paragraph>
Review pass: <1|2|3> of 3
Review model: <model slug used for this launch>
Plan under review:
<full plan text>
```

Also see [implementation-plan overlay SKILL](../skills/implementation-plan/SKILL.md) and [review-subagent-models.md](../review-subagent-models.md).
