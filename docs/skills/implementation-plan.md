# implementation-plan

**Last updated:** 2026-08-20

## Context

**Target** skill contract. Draft structured plans before work. Full Cursor skill (Observed, unchanged): [overlay SKILL.md](../../overlays/cursor/skills/implementation-plan/SKILL.md). **Escalation *when* table SoT is this page** — deep `plan-agent-context` holds specimen headings only and must point here ([instruction layering](../featureArchitecture/instruction-layering.md)).

---

## Substance

### When to use (Required)

**Default on** for every change that is not on the skip list below. Run this skill → iterative [plan_reviewer](../agents/plan_reviewer.md) (max 3) before implementation.

**When in doubt, run the plan loop.**

Eval / harness / multi-step operational work is **not** exempt unless it meets Skip.

**Skip only if:**

1. Truly trivial — one-place typo/copy, comment-only, pure formatting, cosmetic-only UI, docs-only with **no** behavior change, **or**
2. User **explicitly** opts out with clear language (e.g. `skip plan review`, `skip planning`, `implement now`, `no plan gate`) — not inferred urgency

### Escalation when (sole SoT)

Place **Escalation** immediately after Scope on every non-trivial plan. Specimen field shape and Agent context headings: [plan-agent-context](../../workflow/plan-agent-context.md) (**Escalation when-triggers SoT is this skill**; that file holds specimens/headings only).

```markdown
### Escalation
- Agent context required: **yes** | **no**
- Reason: `user-labeled-composer` | `complex-or-extensive` | `n/a`
```

| Escalation | When |
| ---------- | ---- |
| **yes** + `user-labeled-composer` | User says composer-level / asks Composer to **plan** |
| **yes** + `complex-or-extensive` | Multi-phase **roadmap** (e.g. initialization roadmap); cross-repo; migration/external apply; ambiguous architecture with multiple plan-changing approaches; planner judges unusually hard |
| **no** + `n/a` | Ordinary work including ordinary multi-file doc edits or ≤3 light implementation phases that are **not** a roadmap handoff |

If unsure Escalation=yes: ask the user; do not silently escalate. Escalation **yes** requires Inter-phase contracts, Migration/external apply order (or **none**), and full Agent context blocks per [plan-agent-context](../../workflow/plan-agent-context.md).

**Escalation ≠ whether plan_reviewer runs.** plan_reviewer gates every plan drafted under default-on regardless of Escalation yes/no.

### Workflow steps

1. **Discovery** — [discovery](./discovery.md) Step 0 + repo indexes
2. **Draft plan** — fill every section per [Incomplete until](#incomplete-until-section-sot) (Goal, Scope, Escalation, Assumptions, Unknowns or Discovery, Incremental execution, Verification; when-required or **N/A**; Agent context when Escalation=yes)
3. **plan_reviewer loop** — only after Incomplete until bar is met; up to 3 passes until APPROVED (**skip** only when Composer is assigned for phased **execution** — accepted roadmap already gated — or user explicitly opted out of planning)
4. **Handoff** — implementer or phase subagent

### Incomplete until (section SoT)

Treat missing required sections with the **same urgency as missing Required Inputs**. The plan is **incomplete** — must **not** invoke [plan_reviewer](../agents/plan_reviewer.md) or present as implement-ready — **until** the bar below is met (**unless** Skip applies).

**Always required** (non-empty):

- Goal
- Scope
- Escalation
- Assumptions
- Unknowns **or** Discovery steps
- Incremental execution (phases)
- Verification

**When-required** (explicit **N/A** OK only when truly not applicable):

- Alternative approaches
- External dependencies
- Architecture and docs
- If Escalation=yes: Agent context per [plan-agent-context](../../workflow/plan-agent-context.md) (including Inter-phase / Migration when applicable)

Do **not** invent fixed always-on line/character budgets in Success, Verification, or phase wording ([instruction-layering](../featureArchitecture/instruction-layering.md)).

This section is the **sole SoT** for the plan section checklist. [plan-review](./plan-review.md) and [plan_reviewer](../agents/plan_reviewer.md) require compliance — they must **not** paste a second full enum.

### Outputs

- Written plan (roadmap file or inline)
- Classified claims (Desired/Required/Nice-to-have/Cursor-specific/Unknown)
- Fast/Full CI notes per phase when applicable

### Must not

- Implement during planning (except disposable Na previews per Composer policy)
- Omit Escalation field on non-trivial plans
- Treat Escalation=no as skip plan_reviewer
- Invoke plan_reviewer or present implement-ready before Incomplete until bar is met (unless Skip)
- Invent required doc trees without discovery
- Infer opt-out from task urgency
- Invent fixed always-on line/character budgets in Success / Verification

### Related roles

[planner](../agents/planner.md), [plan_reviewer](../agents/plan_reviewer.md)

---

## Implications / open questions

1. Composer exception: when user assigns Composer for phased **execution**, planning is already complete — **skip** plan_reviewer; defer to Composer QC on the accepted roadmap.
2. Host always-on adapters must point here for Escalation *when* and must not keep a competing “≤3 phases usually no” table.

---

## Related

- [plan-review](./plan-review.md)
- [implementation-review](./implementation-review.md)
- [plan-agent-context (gold deep doc)](../../workflow/plan-agent-context.md)
