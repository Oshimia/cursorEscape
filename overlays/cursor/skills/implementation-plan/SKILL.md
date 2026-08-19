---
name: implementation-plan
description: >-
  Draft comprehensive implementation plans for Plan mode. Covers goal, scope,
  confidence-rated assumptions, discovery steps, conditional A/B/C, incremental
  phases, and verification. Use proactively when planning any non-trivial change,
  before invoking the plan-reviewer subagent (max 3 passes per loop).
disable-model-invocation: true
---

# Implementation plan (Cursor overlay)

Thin wrapper. Full procedure: [skills/implementation-plan/SKILL.md](../../../../skills/implementation-plan/SKILL.md).

**Read when planning:**

| Doc | When |
|-----|------|
| [SKILL.md](../../../../skills/implementation-plan/SKILL.md) | Full plan procedure |
| [discovery.md](../../../../workflow/discovery.md) | Find repo docs (Step 0 + fallback) |
| [iterative-plan-review.md](../../../../workflow/iterative-plan-review.md) | Plan → plan-reviewer loop |
| [plan-agent-context.md](../../../../workflow/plan-agent-context.md) | Escalation field + Agent context when escalated |
| [phased-multi-agent.md](../../../../workflow/phased-multi-agent.md) | Multi-phase / Composer handoffs |
| [review-subagent-models.md](../../review-subagent-models.md) | Recommended `plan-reviewer` model |
| [_index.md](../../../../workflow/_index.md) | Index of all workflow docs |

Copy-out fallback: `C:/Users/admin/.cursor/docs/workflow/` (live mirror — not overwritten from this repo).

---

## Invoke plan-reviewer (Cursor Task)

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
