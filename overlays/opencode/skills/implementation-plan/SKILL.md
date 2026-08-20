---
name: implementation-plan
description: >-
  Draft structured implementation plans. Default on unless truly trivial or
  explicit user opt-out. Escalation when-table SoT. Then invoke plan_reviewer.
---

# Implementation plan

Draft a plan suitable for `plan_reviewer`. Do not implement product changes while planning.

## When to use

**Default on** for every change not on the skip list. **When in doubt, run the plan loop.**

Eval / harness / multi-step operational work is **not** exempt.

**Skip only if:** trivial one-place typo/copy, comment-only, formatting, cosmetic-only UI, docs-only no behavior, **or** explicit user opt-out (`skip plan review`, `skip planning`, `implement now`, `no plan gate`).

<a id="escalation"></a>

## Escalation when (sole SoT on this skill)

Place Escalation after Scope on every non-trivial plan. Specimen headings: `docs/workflow/plan-agent-context.md` (pointer only — no competing when-table).

| Escalation | When |
| ---------- | ---- |
| **yes** + `user-labeled-composer` | User says composer-level / asks Composer to **plan** |
| **yes** + `complex-or-extensive` | Multi-phase **roadmap**; cross-repo; migration/external apply; ambiguous architecture with plan-changing approaches; planner judges unusually hard |
| **no** + `n/a` | Ordinary work including ordinary multi-file doc edits or ≤3 light phases that are **not** a roadmap handoff |

If unsure Escalation=yes: ask the user. **Escalation ≠ whether plan_reviewer runs** — plan_reviewer gates every drafted plan under default-on.

## Steps

1. Load skill `discovery` (or follow its steps).
2. Draft plan: Goal, Scope, Escalation, Assumptions, Unknowns, Discovery steps, External deps, Alternative approaches (when required), Incremental execution, Verification, Architecture and docs.
3. When Escalation = yes, read `docs/workflow/plan-agent-context.md` and include Agent context blocks.
4. Invoke OpenCode agent `plan_reviewer` via Task — clean context, **full synthesized plan only**, max 3 passes.
5. Present to user after APPROVED or pass 3; wait if CHANGES REQUESTED.

### Incomplete until (section SoT)

Treat missing required sections with the **same urgency as missing Required Inputs**. The plan is **incomplete** — must **not** invoke `plan_reviewer` or present as implement-ready — **until** the bar below is met (**unless** Skip applies).

**Always required** (non-empty): Goal, Scope, Escalation, Assumptions, Unknowns **or** Discovery steps, Incremental execution, Verification.

**When-required** (explicit **N/A** OK only when truly not applicable): Alternative approaches, External dependencies, Architecture and docs; if Escalation=yes, Agent context per `docs/workflow/plan-agent-context.md` (including Inter-phase / Migration when applicable).

Do **not** invent fixed always-on line/character budgets in Success, Verification, or phase wording.

This section is the **sole SoT** for the plan section checklist. Skill `plan-review` and agent `plan_reviewer` require compliance — they must **not** paste a second full enum.

**Composer exception:** If user assigned Composer for phased *execution* of an accepted roadmap, skip plan_reviewer.

## Read when

| Doc | When |
|-----|------|
| [iterative-plan-review.md](../../docs/workflow/iterative-plan-review.md) | Plan → plan_reviewer loop |
| [plan-agent-context.md](../../docs/workflow/plan-agent-context.md) | Escalation = yes (specimen headings) |
| [phased-multi-agent.md](../../docs/workflow/phased-multi-agent.md) | Multi-phase / Composer |
| [ci-ladder.md](../../docs/workflow/ci-ladder.md) | Fast/Full notes in plan |
| [discovery.md](../../docs/workflow/discovery.md) | Finding repo docs |

## Must not

- Implement during planning (except disposable previews if Composer policy allows)
- Omit Escalation on non-trivial plans
- Treat Escalation=no as skip plan_reviewer
- Invoke plan_reviewer or present implement-ready before Incomplete until bar is met (unless Skip)
- Attach prior plan_reviewer transcripts to the next pass
- Infer opt-out from urgency
- Invent fixed always-on line/character budgets in Success / Verification

## Related agents

`planner`, `plan_reviewer`
