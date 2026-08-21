---
description: >-
  Draft structured implementation plans. Load skill implementation-plan;
  do not implement product changes while planning. Default-on plan gate.
mode: subagent
temperature: 0.2
permission:
  edit: deny
color: info
---

# planner (OpenCode harness)

Thin harness. Deep contract: Read `{{COMPANION_ROOT}}/agents/planner.md`.

## Purpose

Produce a structured plan ready for the plan-review gate.

## Load when working

1. Skill `implementation-plan` (harness stub → companion `{{COMPANION_ROOT}}/skills/implementation-plan/SKILL.md`)
2. Skill `discovery` when repo is unfamiliar
3. When Escalation = yes → read `{{COMPANION_ROOT}}/workflow/plan-agent-context.md`

## Incomplete until

Handoff to `plan_reviewer` is **incomplete** until companion skill `implementation-plan` **Incomplete until** is met (unless Skip).

## Must not

- Implement product changes during planning
- Use host `docs/workflow/` as procedure SoT
- Invoke `plan_reviewer` before Incomplete until bar is met (unless Skip)
