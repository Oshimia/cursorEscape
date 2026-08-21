---
name: implementation-plan
description: >-
  Draft structured implementation plans. Default on unless truly trivial or
  explicit user opt-out. Escalation when-table SoT. Then invoke plan_reviewer.
---

# Implementation plan (OpenCode harness)

Thin harness. Full procedure: Read `{{COMPANION_ROOT}}/skills/implementation-plan/SKILL.md`.

## When to use

**Default on** for every change not on the skip list. **When in doubt, run the plan loop.**

**Skip only if:** trivial one-place typo/copy, comment-only, formatting, cosmetic-only UI, docs-only no behavior, **or** explicit user opt-out.

## Escalation when (sole SoT)

Place Escalation after Scope on every non-trivial plan. Specimen headings: `{{COMPANION_ROOT}}/workflow/plan-agent-context.md` (pointer only — full when-table in companion skill).

**Escalation ≠ whether plan_reviewer runs** — plan_reviewer gates every drafted plan under default-on.

## Steps

1. Load companion skill `discovery` or follow `{{COMPANION_ROOT}}/workflow/discovery.md` Step 0 / fallback.
2. Optional: pre-plan alignment via skill `grilling`; skip when settled or trivial; deep rules in companion.
3. Draft plan per companion skill template (Goal, Scope, Escalation, Assumptions, Unknowns, Discovery steps, Incremental execution, Verification).
4. When Escalation = yes, read `{{COMPANION_ROOT}}/workflow/plan-agent-context.md`.
5. Invoke OpenCode agent `plan_reviewer` via Task — clean context, **full synthesized plan only**, max 3 passes.
6. Present to user after APPROVED or pass 3; wait if CHANGES REQUESTED.

### Incomplete until (section SoT)

**Sole SoT:** companion skill `implementation-plan` **Incomplete until** section. Do **not** paste the enum here — Read `{{COMPANION_ROOT}}/skills/implementation-plan/SKILL.md`.

**Composer exception:** If user assigned Composer for phased *execution* of an accepted roadmap, skip plan_reviewer.

## Read when

| Doc | When |
|-----|------|
| [SKILL.md]({{COMPANION_ROOT}}/skills/implementation-plan/SKILL.md) | Full plan procedure + Incomplete until SoT |
| [iterative-plan-review.md]({{COMPANION_ROOT}}/workflow/iterative-plan-review.md) | Plan → plan_reviewer loop |
| [plan-agent-context.md]({{COMPANION_ROOT}}/workflow/plan-agent-context.md) | Escalation = yes |
| [phased-multi-agent.md]({{COMPANION_ROOT}}/workflow/phased-multi-agent.md) | Multi-phase / Composer |
| [ci-ladder.md]({{COMPANION_ROOT}}/workflow/ci-ladder.md) | Fast/Full notes in plan |
| [discovery.md]({{COMPANION_ROOT}}/workflow/discovery.md) | Finding repo docs |

## Must not

- Implement during planning
- Use host `docs/workflow/` as procedure SoT
- Invoke plan_reviewer before Incomplete until bar is met (unless Skip)

## Related agents

`planner`, `plan_reviewer` — deep contracts at `{{COMPANION_ROOT}}/agents/`
