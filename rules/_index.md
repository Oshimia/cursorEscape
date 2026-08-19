# Rules

**Last updated:** 2026-08-20

## Context

Host-agnostic **portable** always-on gate contracts at repo root. Cursor overlay **thin wrappers** (alwaysApply + pointer): [overlays/cursor/rules](../overlays/cursor/rules/).

---

## Substance

| Rule | Contract | Cursor overlay |
| ---- | -------- | -------------- |
| iterative-plan-review | [iterative-plan-review.md](./iterative-plan-review.md) | [iterative-plan-review.mdc](../overlays/cursor/rules/iterative-plan-review.mdc) |
| iterative-code-review | [iterative-code-review.md](./iterative-code-review.md) | [iterative-code-review.mdc](../overlays/cursor/rules/iterative-code-review.mdc) |
| pre-commit-ci-gate | [pre-commit-ci-gate.md](./pre-commit-ci-gate.md) | [pre-commit-ci-gate.mdc](../overlays/cursor/rules/pre-commit-ci-gate.mdc) (`alwaysApply: false`) |

---

## Related

- [Skills index](../skills/_index.md)
- [Workflow index](../workflow/_index.md)
- [Cursor overlay](../overlays/cursor/_index.md)
