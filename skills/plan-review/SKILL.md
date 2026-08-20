---
name: plan-review
description: >-
  Iterative plan_reviewer gate (clean context, max 3 passes). Default on for
  every drafted plan — not only Escalation=yes or multi-phase roadmaps.
---

# Plan review

Gate drafted plans through [`plan_reviewer`](../../agents/plan_reviewer.md) before implementation.

## When to use

**Default on** whenever a plan was drafted under [`implementation-plan`](../implementation-plan/SKILL.md). Does **not** require Escalation=yes or a multi-phase roadmap.

**When in doubt, run the plan_reviewer loop.**

**Skip only if:** truly trivial, explicit user opt-out, or [`composer`](../composer/SKILL.md) assigned for phased **execution** of an already-accepted plan.

## Steps

1. Parent produces **full synthesized plan** each pass — plan incomplete until skill `implementation-plan` **Incomplete until** SoT is met (load that skill; do **not** paste the enum here).
2. Task → `plan_reviewer` with **clean context** (no prior review transcripts). APPROVED requires SoT compliance.
3. Synthesize: fix blockers; Unknowns → discovery steps.
4. Repeat up to **3** passes or early APPROVED.
5. After pass 3 or early APPROVED: present to user; wait if still CHANGES REQUESTED (surface outstanding blockers after pass 3).

**Parent incomplete until** APPROVED, or after pass 3 with outstanding blockers surfaced. Do not start implementation while CHANGES REQUESTED blockers remain (unless user opts out).

## Read when

| Doc | When |
|-----|------|
| [iterative-plan-review.md](../../workflow/iterative-plan-review.md) | Full loop rules + Must not |
| [plan-reviewer-report.md](../../workflow/plan-reviewer-report.md) | Plan-reviewer output schema (limits + exact report structure) |
| [plan-agent-context.md](../../workflow/plan-agent-context.md) | Escalated plan headings (not Escalation when-table) |
| [implementation-plan](../implementation-plan/SKILL.md) | Draft template + **Incomplete until** SoT |

## Must not

Full portable list: [iterative-plan-review.md](../../workflow/iterative-plan-review.md) § Must not. Do not duplicate the Incomplete until enum here.

## Related agents

[`planner`](../../agents/planner.md), [`plan_reviewer`](../../agents/plan_reviewer.md)
