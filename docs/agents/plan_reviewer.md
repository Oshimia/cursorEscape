# plan_reviewer

**Last updated:** 2026-08-19

## Context

**Target** role contract. Reviews plans before implementation. Maps to live [plan-reviewer](../../overlays/cursor/agents/plan-reviewer.md) (Observed overlay file) with host-agnostic interface.

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

### APPROVED section checklist

**Sole SoT** for which sections are required: [implementation-plan Incomplete until](../skills/implementation-plan.md#incomplete-until-section-sot). This agent **requires compliance** — do **not** paste a second full enum here.

**APPROVED** only when Escalation is present and every always-required SoT section is non-empty, and every when-required section is non-empty or labeled **N/A** when truly not applicable. Treat gaps with the **same urgency as missing Required Inputs**.

Otherwise return **CHANGES REQUESTED** listing the missing/empty sections (and any other blockers). Do not soft-approve thin plans that omit Assumptions, Unknowns/Discovery, etc.

### Must not

- Implement code
- Approve plans with unresolved blocking scope gaps or SoT section gaps
- Soft-approve when required sections are empty or missing (missing-Inputs urgency)
- Refuse or skip review because Escalation=no
- Exceed 3 passes without owner escalation
- Rely on shared chat history or prior review transcripts
- Invent a second full section checklist that diverges from implementation-plan Incomplete until

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
