---
name: pre-commit-ci-gate
description: >-
  Enforce Full CI (or explicit n/a + user ack) before git commit. On-demand
  policy — not always-on. Use before any local commit after dual APPROVED.
---

# Pre-commit CI gate (OpenCode harness)

Thin harness. Full procedure: Read `{{COMPANION_ROOT}}/rules/pre-commit-ci-gate.md`.

## When to use

Before any `git commit` after dual APPROVED — including when Full = `n/a` (then require explicit user acknowledgment per companion rule).

## Steps

1. Read companion rule `{{COMPANION_ROOT}}/rules/pre-commit-ci-gate.md` for Full-before-commit policy.
2. Map Fast/Full via `{{COMPANION_ROOT}}/workflow/ci-ladder.md` and project scripts.
3. Full must pass — or Full = `n/a` with **explicit user acknowledgment**.
4. Never pair Full CI with dual-gate reviewer launch.

## Read when

| Doc | When |
|-----|------|
| [pre-commit-ci-gate.md]({{COMPANION_ROOT}}/rules/pre-commit-ci-gate.md) | Full policy (companion SoT) |
| [ci-ladder.md]({{COMPANION_ROOT}}/workflow/ci-ladder.md) | Discover Fast/Full for this repo |
| [iterative-code-review.md]({{COMPANION_ROOT}}/workflow/iterative-code-review.md) | Closeout vs review-loop |

## Must not

- Always-inject into every turn
- Substitute Fast for Full when Full exists
- Use host `docs/workflow/` as procedure SoT

## Related

`implementer`, skill `composer`, skill `implementation-review`
