> **Imported research** — Source: AITestSuite `tests\ez-pz-streaming-media-phase-4\baseline\referenceFiles\SOPs\reference-docs-check.md`; copied 2026-08-17 into cursorEscape. Status: Observed/eval-packaging. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Reference documentation check

**Purpose:** Ensure every code change follows documented SOPs and feature architecture — no parallel inventions, no silent doc drift.

| Artifact | Role |
|----------|------|
| [.cursor/skills/reference-docs/SKILL.md](../../.cursor/skills/reference-docs/SKILL.md) | Parent workflow — indexes, doc selection, implementation, doc updates |
| [.cursor/rules/reference-docs-check.mdc](../../.cursor/rules/reference-docs-check.mdc) | Mandatory trigger for every conversation |

---

## Scope

This applies to **every conversation** — planning, implementation, debugging, review, and refactors. There are **no exceptions** for urgency, size of change, or bug-fix context.

All agents **must** use and follow `referenceFiles/SOPs/` and `referenceFiles/featureArchitecture/` when writing or recommending code for this repository.

Before any code change, follow the [reference-docs skill](../../.cursor/skills/reference-docs/SKILL.md).

---

## When documentation is missing or incomplete

- **Stop and consult the user** before implementing a new pattern, workflow, or feature area.
- **Create or update** the appropriate SOP (how-to) or feature architecture doc (why/how it works).
- **Link it** from the relevant `_index.md` in the **same change set** as the code.
- Do not ship undocumented architecture.

---

## When to update existing docs

Update documentation in the same change set when you:

- Introduce a new pattern, hook, or workflow
- Change behavior that contradicts or extends an existing doc
- Add or modify APIs, state flows, permissions, or database strategies covered in these folders

Do not silently diverge from documented architecture.

---

## Applies even when

- The task is a one-line fix or hotfix
- The user did not mention documentation
- You are only refactoring or adding tests
- You are in Plan mode (plans must reference relevant SOPs/architecture docs)

Question-only replies should still align recommendations with documented project patterns.

---

## Quick pointers (non-exhaustive)

| Area | Start here |
|------|------------|
| Reference docs workflow | [reference-docs skill](../../.cursor/skills/reference-docs/SKILL.md), [reference-docs-check SOP](./reference-docs-check.md), [reference-docs-check rule](../../.cursor/rules/reference-docs-check.mdc) |
| Content block editors | [adding-content-block-types.md](./adding-content-block-types.md), [debounced-content-block-editor-state.md](./debounced-content-block-editor-state.md) |
| Theming / CSS variables | [theme-builder-variables.md](../featureArchitecture/theme-builder-variables.md), [theme-settings rule](../../.cursor/rules/theme-settings.mdc) |
| Database / Supabase | [supabase-migrations.md](./supabase-migrations.md), [risk-assessment-for-database-changes.md](./risk-assessment-for-database-changes.md) |
| Testing | [unit-testing-policy.md](./unit-testing-policy.md), [testing-strategy.md](../featureArchitecture/testing-strategy.md) |
| Planning / implementation plans | [implementation-plan skill](../../.cursor/skills/implementation-plan/SKILL.md), [plan-reviewer agent](../../.cursor/agents/plan-reviewer.md), [iterative-plan-review.md](./iterative-plan-review.md) |
| Non-trivial / multi-file work | [implementation-review skill](../../.cursor/skills/implementation-review/SKILL.md), [reviewer-a agent](../../.cursor/agents/reviewer-a.md), [iterative-code-review.md](./iterative-code-review.md) — per plan phase on multi-phase work |
| Review subagent models / profile swap | [review-loop-model-profiles.md](./review-loop-model-profiles.md) |
| ESLint / React Compiler | [frontend-eslint-warning-baseline.md](./frontend-eslint-warning-baseline.md) |

The indexes remain the source of truth; use this table only as an entry ramp.

---

## Related

- [SOPs index](./_index.md)
- [Feature architecture index](../featureArchitecture/_index.md)
- [Iterative plan review](./iterative-plan-review.md)
- [Iterative code review](./iterative-code-review.md)
