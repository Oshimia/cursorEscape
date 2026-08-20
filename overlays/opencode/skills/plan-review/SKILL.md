---
name: plan-review
description: >-
  Iterative plan_reviewer gate (clean context, max 3 passes). Default on for
  every drafted plan — not only Escalation=yes or multi-phase roadmaps.
---

# Plan review (OpenCode harness)

Thin harness. Full procedure: Read `{{COMPANION_ROOT}}/skills/plan-review/SKILL.md`.

## When to use

**Default on** whenever a plan was drafted under `implementation-plan`. Does **not** require Escalation=yes or a multi-phase roadmap.

**When in doubt, run the plan_reviewer loop.**

**Skip only if:** truly trivial, explicit user opt-out, or Composer assigned for phased **execution** of an already-accepted plan.

## Steps

1. Parent produces **full synthesized plan** each pass — plan incomplete until companion skill `implementation-plan` **Incomplete until** SoT is met.
2. Task → `plan_reviewer` with **clean context** (no prior review transcripts). APPROVED requires SoT compliance.
3. Synthesize: fix blockers; Unknowns → discovery steps.
4. Repeat up to **3** passes or early APPROVED.
5. On CHANGES REQUESTED after pass 3, present outstanding items and wait for user.

## Read when

| Doc | When |
|-----|------|
| [SKILL.md]({{COMPANION_ROOT}}/skills/plan-review/SKILL.md) | Full loop procedure |
| [iterative-plan-review.md]({{COMPANION_ROOT}}/workflow/iterative-plan-review.md) | Full loop rules + Must not |
| [plan-reviewer-report.md]({{COMPANION_ROOT}}/workflow/plan-reviewer-report.md) | Plan-reviewer output schema |
| [implementation-plan]({{COMPANION_ROOT}}/skills/implementation-plan/SKILL.md) | Draft template + **Incomplete until** SoT |

## Must not

- Start implementation before APPROVED (unless user opts out)
- Use host `docs/workflow/` as procedure SoT — companion `{{COMPANION_ROOT}}/workflow/` only
- Feed previous child transcripts into the next Task

## Related agents

`planner`, `plan_reviewer` — deep contracts at `{{COMPANION_ROOT}}/agents/`
