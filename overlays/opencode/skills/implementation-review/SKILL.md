---
name: implementation-review
description: >-
  Run the dual-gate review loop after implementation: Observed Fast CI,
  parallel production_readiness_reviewer + bug_reviewer, then Full CI closeout.
  Default on unless truly trivial or explicit user opt-out.
---

# Implementation review

Orchestrate dual review after implementation. Parent owns CI. Reviewers are isolated children.

## When to use

**Default on** at the end of each plan phase or any completed implementation task not on the skip list. **When in doubt, run it.**

Eval / harness / multi-step operational work that changed behavior or process artifacts is **not** exempt.

**Skip only if:** trivial one-place typo/copy, comment-only, formatting, cosmetic-only UI, docs-only no behavior, **or** explicit user opt-out (`skip review`, `no dual review`).

## Steps

```text
Implement → [Fast CI Observed → production_readiness_reviewer ∥ bug_reviewer → fix]*
  → dual APPROVED → Full CI (no reviewers) → complete
```

1. **Fast CI Observed** — per-command `pass|fail|skipped|n/a` rows. Do **not** launch reviewers on fail, skipped (when Fast ≠ n/a), or claimed-only prose.
2. **Parallel Task** — launch **both** `production_readiness_reviewer` and `bug_reviewer` in **one** OpenCode session (two Task calls in one turn when possible). `Completion gate: review-loop`. Pack full Inputs; clean context; **no** prior review transcripts.
3. **production_readiness_reviewer** — locked opener; no Custom Instructions field; re-scope via narrower task summary + applicable docs.
4. **bug_reviewer** — Custom Instructions envelope (phase, iteration, launch count, regressions, out-of-scope).
5. Fix **all** must-fix from either leg; re-run Observed Fast CI (when Fast ≠ n/a), then re-launch **both** after each fix batch.
6. **APPROVED bars** — bug_reviewer: Blocking, Non-blocking, Test gaps = `"None"`. production_readiness: Blocking, Non-blocking, blocking test/docs = `"None"`; Batchable (deferred) may remain.
7. After dual APPROVED: **Full CI only** (never with reviewers). Load `pre-commit-ci-gate` before commit. When Full = `n/a`, need explicit user ack (Composer: ack is conductor's gate).

Per leg: if launch count ≥ 9, narrow scope before invoke — no hard stop.

## Read when

| Doc | When |
|-----|------|
| [iterative-code-review.md](../../docs/workflow/iterative-code-review.md) | Loop rules, per-phase boundaries |
| [ci-ladder.md](../../docs/workflow/ci-ladder.md) | Fast/Full mapping |
| [review-subagent-models.md](../../docs/workflow/review-subagent-models.md) | Model hints |
| [discovery.md](../../docs/workflow/discovery.md) | Before judging architecture |

## Must not

- Launch reviewers without Observed Fast CI (when Fast ≠ n/a)
- Pair Full CI with reviewers
- Use two T3 worktrees for the two review legs (same checkout)
- Treat dual APPROVED as proven no-escape
- Batch multiple plan phases into one review

## Related agents

`implementer`, `production_readiness_reviewer`, `bug_reviewer`
