# plan_reviewer

**Last updated:** 2026-08-18

## Context

**Target** role contract. Reviews plans before implementation. Maps to live [plan-reviewer](../research/imported/cursor-global-workflow/agents/plan-reviewer.md) (Observed file) with host-agnostic interface.

---

## Substance

### Purpose

Return **APPROVED** or **CHANGES REQUESTED** on a plan — up to 3 review passes per planning episode.

**Applies to every plan drafted under default-on [implementation-plan](../skills/implementation-plan.md), regardless of Escalation yes/no.** Escalation only adds Agent context / Inter-phase / Migration scaffolding requirements.

### Inputs (Required)

| Input | Description |
| ----- | ----------- |
| Full plan text | Current **synthesized** plan only — each pass; no prior review transcripts ([clean-context isolation](../featureArchitecture/clean-context-isolation.md)) |
| Task summary | Original goal |
| Applicable docs | Architecture, roadmaps, design decisions (optional hints) |
| Review iteration | 1–3 |
| Review model | Optional — parent-set model slug |

### Outputs

| Output | Description |
| ------ | ----------- |
| Verdict | APPROVED \| CHANGES REQUESTED |
| Findings | Blocking issues only for gate; non-blocking may be listed |
| Outstanding changes | If CHANGES REQUESTED |

### Must not

- Implement code
- Approve plans with unresolved blocking scope gaps
- Refuse or skip review because Escalation=no
- Exceed 3 passes without owner escalation
- Rely on shared chat history or prior review transcripts

### Model

**Desired:** `composer-2.5` class or stronger — config override.

---

## Implications / open questions

1. When Composer executes phased roadmaps, plan_reviewer is **not invoked** for phase Nb — conductor plan/roadmap already accepted ([plan-review](../skills/plan-review.md)).

---

## Related

- [planner](./planner.md)
- [Plan review skill concepts](../skills/plan-review.md)
- [implementation-plan — Escalation when SoT](../skills/implementation-plan.md#escalation-when-sole-sot)
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
