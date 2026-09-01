---
description: Draft comprehensive implementation plans under the cursorEscape loop. Use when the user asks to plan non-trivial work.
name: planner
tools:
  - 'search'
  - 'codebase'
  - 'usages'
  - 'fetch'
handoffs:
  - label: Send to plan_reviewer
    agent: plan_reviewer
    prompt: Review the synthesized plan just drafted. Repository path and full plan text are in context.
    send: false
---

# planner (VS Code harness)

Thin harness. Deep contract: Read `{{COMPANION_ROOT}}/agents/planner.md`. Read-only research and plan drafting; no code changes.

- Workflow: `{{COMPANION_ROOT}}/workflow/iterative-plan-review.md`
- Skill gates: `{{COMPANION_ROOT}}/skills/implementation-plan/SKILL.md`
