# Skills

**Last updated:** 2026-08-22

## Context

Host-agnostic **portable** workflow skills at repo root. Cursor overlay: [overlays/cursor](../overlays/cursor/_index.md). OpenCode overlay: [overlays/opencode](../overlays/opencode/_index.md).

---

## Substance

### Core skills (Required)

| Skill | Procedure | Cursor overlay | OpenCode overlay |
| ----- | --------- | -------------- | ---------------- |
| implementation-plan | [implementation-plan/SKILL.md](./implementation-plan/SKILL.md) | [SKILL.md](../overlays/cursor/skills/implementation-plan/SKILL.md) | [SKILL.md](../overlays/opencode/skills/implementation-plan/SKILL.md) |
| implementation-review | [implementation-review/SKILL.md](./implementation-review/SKILL.md) | [SKILL.md](../overlays/cursor/skills/implementation-review/SKILL.md) | [SKILL.md](../overlays/opencode/skills/implementation-review/SKILL.md) |
| discovery | [discovery/SKILL.md](./discovery/SKILL.md) | — | [SKILL.md](../overlays/opencode/skills/discovery/SKILL.md) |
| plan-review | [plan-review/SKILL.md](./plan-review/SKILL.md) | — | [SKILL.md](../overlays/opencode/skills/plan-review/SKILL.md) |

### Reference skills

| Skill | Reference | Host overlays |
| ----- | --------- | ------------- |
| codebase-design | [SKILL.md](./codebase-design/SKILL.md) | — (portable reference) |
| tdd | [SKILL.md](./tdd/SKILL.md) | — (portable reference) |

### Alignment / interview skills

| Skill | Procedure | Host overlays |
| ----- | --------- | ------------- |
| grilling | [grilling/SKILL.md](./grilling/SKILL.md) | — (portable, on-demand) |
| domain-modeling | [domain-modeling/SKILL.md](./domain-modeling/SKILL.md) | — (portable, caller-loaded) |

### Diagnostic / investigation skills

| Skill | Procedure | Host overlays |
| ----- | --------- | ------------- |
| diagnosing-bugs | [diagnosing-bugs/SKILL.md](./diagnosing-bugs/SKILL.md) | [OpenCode](../overlays/opencode/skills/diagnosing-bugs/SKILL.md) |

### Research skills

| Skill | Procedure | Host overlays |
| ----- | --------- | ------------- |
| research | [research/SKILL.md](./research/SKILL.md) | — (portable, caller-loaded) |

### Survey skills

| Skill | Procedure | Host overlays |
| ----- | --------- | ------------- |
| architecture-survey | [architecture-survey/SKILL.md](./architecture-survey/SKILL.md) | — (portable, caller-loaded) |

### Prototype skills

| Skill | Procedure | Host overlays |
| ----- | --------- | ------------- |
| prototype | [prototype/SKILL.md](./prototype/SKILL.md) | — (portable, caller-loaded) |

### Generation skills

| Skill | Procedure | Host overlays |
| ----- | --------- | ------------- |
| wizard | [wizard/SKILL.md](./wizard/SKILL.md) | — (portable, caller-loaded) |

### Learning / teaching skills

| Skill | Procedure | Host overlays |
| ----- | --------- | ------------- |
| teach | [teach/SKILL.md](./teach/SKILL.md) | — (portable, caller-loaded) |

### Optional orchestration (Nice-to-have / Cursor-specific)

| Skill | Procedure | Cursor overlay | OpenCode overlay |
| ----- | --------- | -------------- | ---------------- |
| composer | [composer/SKILL.md](./composer/SKILL.md) | [SKILL.md](../overlays/cursor/skills/composer/SKILL.md) | [SKILL.md](../overlays/opencode/skills/composer/SKILL.md) |
| roadmap | [roadmap/SKILL.md](./roadmap/SKILL.md) | [SKILL.md](../overlays/cursor/skills/roadmap/SKILL.md) | [SKILL.md](../overlays/opencode/skills/roadmap/SKILL.md) |
| documentation-architecture | [documentation-architecture/SKILL.md](./documentation-architecture/SKILL.md) | [SKILL.md](../overlays/cursor/skills/documentation-architecture/SKILL.md) | [SKILL.md](../overlays/opencode/skills/documentation-architecture/SKILL.md) |

### Gates / on-demand policy (extended)

| Skill / rule | Procedure | Cursor overlay | OpenCode overlay |
| ------------ | --------- | -------------- | ---------------- |
| pre-commit-ci-gate | [rules/pre-commit-ci-gate.md](../rules/pre-commit-ci-gate.md) | [pre-commit-ci-gate.mdc](../overlays/cursor/rules/pre-commit-ci-gate.mdc) | [SKILL.md](../overlays/opencode/skills/pre-commit-ci-gate/SKILL.md) |

### Skill contract fields (Required)

Each SKILL states: **When to use**, **Workflow steps**, **Outputs**, **Must not**, **Related roles** (where applicable), with Boundary/Must not and Workflow/Workflow steps accepted as equivalent variants for reference and alignment skills

---

## Related

- [Agents index](../agents/_index.md)
- [Workflow index](../workflow/_index.md)
- [Rules](../rules/_index.md)
- [Intended workflow](../docs/featureArchitecture/intended-workflow.md)
- [Instruction layering](../docs/featureArchitecture/instruction-layering.md)
- [Cursor overlay](../overlays/cursor/_index.md)
- [OpenCode overlay](../overlays/opencode/_index.md)
- [Workflow source delta](../research/imported/workflow-source-delta.md)
