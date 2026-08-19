# Skills

**Last updated:** 2026-08-20

## Context

Host-agnostic **gold-standard** workflow skills at repo root. Portable procedure lives in `skills/*/SKILL.md`. Cursor overlay extract (Observed, fat until Phase 5): [overlays/cursor](../overlays/cursor/_index.md). The 2026-08-17 bannered copy remains under [cursor-global-workflow](../research/imported/cursor-global-workflow/skills/) (archaeology).

---

## Substance

### Core skills (Required)

| Skill | Procedure | Cursor overlay SKILL |
| ----- | --------- | -------------------- |
| implementation-plan | [implementation-plan/SKILL.md](./implementation-plan/SKILL.md) | [SKILL.md](../overlays/cursor/skills/implementation-plan/SKILL.md) |
| implementation-review | [implementation-review/SKILL.md](./implementation-review/SKILL.md) | [SKILL.md](../overlays/cursor/skills/implementation-review/SKILL.md) |
| discovery | [workflow/discovery.md](../workflow/discovery.md) | (no SKILL.md — workflow procedure) |
| plan-review (concepts) | [workflow/iterative-plan-review.md](../workflow/iterative-plan-review.md) | overlay plan SKILL |

### Gates / on-demand policy

| Skill / rule | Procedure | Live import |
| ------------ | --------- | ----------- |
| pre-commit-ci-gate | [rules/pre-commit-ci-gate.md](../rules/pre-commit-ci-gate.md) | [pre-commit-ci-gate.mdc](../overlays/cursor/rules/pre-commit-ci-gate.mdc) (`alwaysApply: false`) |

### Optional orchestration (Nice-to-have / Cursor-specific)

| Skill | Procedure | Notes |
| ----- | --------- | ----- |
| composer | [composer/SKILL.md](./composer/SKILL.md) | Phased conductor — Cursor-specific |
| roadmap | [roadmap/SKILL.md](./roadmap/SKILL.md) | Multi-phase handoff authoring |
| documentation-architecture | [documentation-architecture/SKILL.md](./documentation-architecture/SKILL.md) | Bootstrap SOPs/FA layout |

### Skill contract fields (Required)

Each SKILL states: **When to use**, **Workflow steps**, **Outputs**, **Must not**, **Related roles** (where applicable).

---

## Related

- [Agents index](../agents/_index.md)
- [Workflow index](../workflow/_index.md)
- [Rules](../rules/)
- [Intended workflow](../docs/featureArchitecture/intended-workflow.md)
- [Instruction layering](../docs/featureArchitecture/instruction-layering.md)
- [Cursor overlay](../overlays/cursor/_index.md)
- [Workflow source delta](../research/imported/workflow-source-delta.md)
