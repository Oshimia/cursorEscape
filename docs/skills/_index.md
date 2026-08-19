# Skill Contracts

**Last updated:** 2026-08-19

## Context

Host-agnostic **Target** summaries of workflow skills. Portable contracts live in this folder. Live `~/.cursor` (imported [cursor-global-workflow](../research/imported/cursor-global-workflow/skills/)) is **Observed interim Cursor file wording** until overlay copy-out — not a second authored procedure tree. These pages avoid Cursor Task/subagent IDs.

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

### Gates / on-demand policy

| Skill | Contract | Live import |
| ----- | -------- | ----------- |
| pre-commit-ci-gate | [pre-commit-ci-gate.md](./pre-commit-ci-gate.md) | [pre-commit-ci-gate.mdc](../research/imported/cursor-global-workflow/rules/pre-commit-ci-gate.mdc) (rule, `alwaysApply: false` — not a SKILL.md) |

### Optional orchestration (Nice-to-have / Cursor-specific)

| Skill | Contract | Notes |
| ----- | -------- | ----- |
| composer | [composer.md](./composer.md) | Phased conductor — Cursor-specific |
| roadmap | [roadmap.md](./roadmap.md) | Multi-phase handoff authoring |
| documentation-architecture | [documentation-architecture.md](./documentation-architecture.md) | Bootstrap SOPs/FA layout; [SKILL.md](../research/imported/cursor-global-workflow/skills/documentation-architecture/SKILL.md) |

### Skill contract fields (Required)

Each page states: **When to use**, **Workflow steps**, **Outputs**, **Must not**, **Related roles**.

---

## Implications / open questions

1. Runtime may mirror skills under `.cursor/skills/` or host registry — contracts stay in `docs/skills/`.
2. Companion repo is **Target** contract SoT. Live `~/.cursor` is **Observed interim Cursor wording** (not a procedure SoT) until overlay copy-out. Copy-out **timing** remains **Unknown** (not authorized this phase). Not a two-way peer-sync Unknown.

---

## Related

- [Agents index](../agents/_index.md)
- [Intended workflow](../featureArchitecture/intended-workflow.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md) — skills stay on-demand; always-on stays thin
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
- [Workflow source delta](../research/imported/workflow-source-delta.md)
