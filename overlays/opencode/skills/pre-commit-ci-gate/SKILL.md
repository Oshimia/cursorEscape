---
name: pre-commit-ci-gate
description: >-
  Enforce Full CI (or explicit n/a + user ack) before git commit. On-demand
  policy — not always-on. Use before any local commit after dual APPROVED.
---

# Pre-commit CI gate

Full-before-commit policy. Load on demand when committing.

## When to use

Before any `git commit` (implementer or Composer phase commit). When Full ≠ `n/a` after dual APPROVED.

## Steps

1. If the target repo has a local pre-commit CI rule → **follow that**.
2. Else map Fast/Full via [ci-ladder.md](docs/workflow/ci-ladder.md) and project scripts.
3. Before commit: **Full** must pass — or Full = `n/a` with **explicit user acknowledgment**.
4. Never substitute Fast for Full when Full exists.
5. Never pair Full CI with dual-gate reviewer launch.

**Composer:** same Full (or n/a ack) before automatic local phase commits; never `git push`.

## Read when

| Doc | When |
|-----|------|
| [ci-ladder.md](docs/workflow/ci-ladder.md) | Discover Fast/Full for this repo |
| [iterative-code-review.md](docs/workflow/iterative-code-review.md) | Closeout vs review-loop |

## Must not

- Always-inject this into every turn
- Invent hardcoded cross-repo test suites
- Treat Fast as commit-grade when Full exists

## Related

`implementer`, skill `composer`, skill `implementation-review`
