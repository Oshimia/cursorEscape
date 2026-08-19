# Skill Contracts

**Last updated:** 2026-08-20

## Context

Host-agnostic **Target** summaries of workflow skills. Portable contracts live in this folder. Current Cursor workflow files (unchanged bodies) live under [overlays/cursor](../../overlays/cursor/_index.md) (**Observed** extract). The 2026-08-17 bannered copy remains under [cursor-global-workflow](../../research/imported/cursor-global-workflow/skills/) (archaeology). These pages avoid Cursor Task/subagent IDs.

AITestSuite freeze includes a **reference-docs** skill — live owner workflow uses [discovery](./discovery.md) instead ([workflow-source-delta](../../research/imported/workflow-source-delta.md)).

---

## Substance

### Core skills (Required)

| Skill | Contract | Deep procedure / overlay SKILL |
| ----- | -------- | ------------------------------ |
| implementation-plan | [implementation-plan.md](./implementation-plan.md) | [SKILL.md](../../overlays/cursor/skills/implementation-plan/SKILL.md) |
| implementation-review | [implementation-review.md](./implementation-review.md) | [SKILL.md](../../overlays/cursor/skills/implementation-review/SKILL.md) |
| discovery | [discovery.md](./discovery.md) | [workflow/discovery.md](../../workflow/discovery.md) |
| plan-review (concepts) | [plan-review.md](./plan-review.md) | [workflow/iterative-plan-review.md](../../workflow/iterative-plan-review.md) |

### Gates / on-demand policy

| Skill | Contract | Live import |
| ----- | -------- | ----------- |
| pre-commit-ci-gate | [pre-commit-ci-gate.md](./pre-commit-ci-gate.md) | [pre-commit-ci-gate.mdc](../../overlays/cursor/rules/pre-commit-ci-gate.mdc) (rule, `alwaysApply: false` — not a SKILL.md) |

### Optional orchestration (Nice-to-have / Cursor-specific)

| Skill | Contract | Notes |
| ----- | -------- | ----- |
| composer | [composer.md](./composer.md) | Phased conductor — Cursor-specific; [SKILL.md](../../overlays/cursor/skills/composer/SKILL.md) |
| roadmap | [roadmap.md](./roadmap.md) | Multi-phase handoff authoring; [SKILL.md](../../overlays/cursor/skills/roadmap/SKILL.md) |
| documentation-architecture | [documentation-architecture.md](./documentation-architecture.md) | Bootstrap SOPs/FA layout; [SKILL.md](../../overlays/cursor/skills/documentation-architecture/SKILL.md) |

### Skill contract fields (Required)

Each page states: **When to use**, **Workflow steps**, **Outputs**, **Must not**, **Related roles**.

---

## Implications / open questions

1. Runtime may mirror skills under a host registry — portable contracts stay in `docs/skills/`. Do not treat repo-root `.cursor/skills` as this archive's layout.
2. Companion repo is **Target** contract SoT. Cursor-native files: [overlays/cursor](../../overlays/cursor/_index.md) (**Observed**, frozen). Live `~/.cursor/skills` is still the running Cursor install. Copy-out **timing** remains **Unknown**.

---

## Related

- [Agents index](../agents/_index.md)
- [Intended workflow](../featureArchitecture/intended-workflow.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md) — skills stay on-demand; always-on stays thin
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
- [Cursor overlay skills](../../overlays/cursor/_index.md)
- [Workflow source delta](../../research/imported/workflow-source-delta.md)
