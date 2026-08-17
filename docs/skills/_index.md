# Skill Contracts

**Last updated:** 2026-08-17

## Context

Host-agnostic **Target** summaries of workflow skills. Canonical full text lives in live `~/.cursor` (imported [cursor-global-workflow](../research/imported/cursor-global-workflow/skills/)); these pages define portable contracts without hard dependency on Cursor Task/subagent IDs.

AITestSuite freeze includes a **reference-docs** skill — live owner workflow uses [discovery](./discovery.md) instead ([workflow-source-delta](../research/imported/workflow-source-delta.md)).

---

## Substance

### Core skills (Required)

| Skill | Contract | Live import |
| ----- | -------- | ----------- |
| implementation-plan | [implementation-plan.md](./implementation-plan.md) | [SKILL.md](../research/imported/cursor-global-workflow/skills/implementation-plan/SKILL.md) |
| implementation-review | [implementation-review.md](./implementation-review.md) | [SKILL.md](../research/imported/cursor-global-workflow/skills/implementation-review/SKILL.md) |
| discovery | [discovery.md](./discovery.md) | [discovery.md](../research/imported/cursor-global-workflow/docs/workflow/discovery.md) |
| plan-review (concepts) | [plan-review.md](./plan-review.md) | [iterative-plan-review](../research/imported/cursor-global-workflow/docs/workflow/iterative-plan-review.md) |

### Optional orchestration (Nice-to-have / Cursor-specific)

| Skill | Contract | Notes |
| ----- | -------- | ----- |
| composer | [composer.md](./composer.md) | Phased conductor — Cursor-specific |
| roadmap | [roadmap.md](./roadmap.md) | Multi-phase handoff authoring |
| documentation-architecture | — | Cite live import only; no separate contract page in Phase 4 |

### Skill contract fields (Required)

Each page states: **When to use**, **Workflow steps**, **Outputs**, **Must not**, **Related roles**.

---

## Implications / open questions

1. Runtime may mirror skills under `.cursor/skills/` or host registry — contracts stay in `docs/skills/`.
2. **Unknown:** Versioning/sync between live `~/.cursor` and cursorEscape repo.

---

## Related

- [Agents index](../agents/_index.md)
- [Intended workflow](../featureArchitecture/intended-workflow.md)
- [Workflow source delta](../research/imported/workflow-source-delta.md)
