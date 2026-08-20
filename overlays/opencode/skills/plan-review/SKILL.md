---
name: plan-review
description: >-
  Iterative plan_reviewer gate (clean context, max 3 passes). Default on for
  every drafted plan — not only Escalation=yes or multi-phase roadmaps.
---

# Plan review

Gate drafted plans through `plan_reviewer` before implementation.

## When to use

**Default on** whenever a plan was drafted under `implementation-plan`. Does **not** require Escalation=yes or a multi-phase roadmap.

**When in doubt, run the plan_reviewer loop.**

**Skip only if:** truly trivial, explicit user opt-out, or Composer assigned for phased **execution** of an already-accepted plan.

## Steps

1. Parent (planner) produces **full synthesized plan** each pass — plan incomplete until skill `implementation-plan` **Incomplete until** SoT is met.
2. Task → `plan_reviewer` with **clean context** (no prior review transcripts). APPROVED requires SoT compliance.
3. Synthesize: fix blockers; Unknowns → discovery steps.
4. Repeat up to **3** passes or early APPROVED.
5. On CHANGES REQUESTED after pass 3, present outstanding items and wait for user.

**Parent incomplete until** APPROVED, or after pass 3 with outstanding blockers surfaced. Do not start implementation while CHANGES REQUESTED blockers remain (unless user opts out). Do **not** paste a second full Incomplete until enum here — load skill `implementation-plan`.

## Read when

| Doc | When |
|-----|------|
| [iterative-plan-review.md](docs/workflow/iterative-plan-review.md) | Full loop rules |
| [plan-agent-context.md](docs/workflow/plan-agent-context.md) | Escalated plan headings (not Escalation when-table) |

## Must not

- Start implementation before APPROVED (unless user opts out)
- Skip because Escalation=no or work is "just docs/eval/harness"
- Exceed 3 passes without user escalation
- Feed previous child transcripts into the next Task
- Duplicate the full Incomplete until section enum — point at skill `implementation-plan`

## Related agents

`planner`, `plan_reviewer`
