---
name: implementation-review
description: >-
  Run the dual-gate review loop after implementation: Observed Fast CI,
  parallel production_readiness_reviewer + bug_reviewer, then Full CI closeout.
  Default on unless truly trivial or explicit user opt-out.
---

# Implementation review (OpenCode harness)

Thin harness. Full procedure: Read `{{COMPANION_ROOT}}/skills/implementation-review/SKILL.md`.

## When to use

**Default on** at the end of each plan phase or any completed implementation task not on the skip list. **When in doubt, run it.**

**Skip only if:** trivial one-place typo/copy, comment-only, formatting, cosmetic-only UI, docs-only no behavior, **or** explicit user opt-out.

## Steps

```text
Implement → [Fast CI Observed → production_readiness_reviewer ∥ bug_reviewer → fix]*
  → dual APPROVED → Full CI (no reviewers) → complete
```

1. **Fast CI Observed** — per-command rows. Do **not** launch reviewers on fail, skipped (when Fast ≠ n/a), or claimed-only.
2. **Parallel Task** — `production_readiness_reviewer` and `bug_reviewer`, `Completion gate: review-loop`.
   - **production_readiness_reviewer:** locked opener — **no** Custom Instructions field.
   - **bug_reviewer:** **Custom Instructions** envelope (phase, iteration, launch count, regressions, out-of-scope).
3. Fix must-fix; re-run Observed Fast CI (when Fast ≠ n/a), then re-launch **both** until dual APPROVED.
4. Closeout = Full CI only (never with reviewers).

## Read when

| Doc | When |
|-----|------|
| [SKILL.md]({{COMPANION_ROOT}}/skills/implementation-review/SKILL.md) | Full loop procedure |
| [iterative-code-review.md]({{COMPANION_ROOT}}/workflow/iterative-code-review.md) | Loop rules, per-phase boundaries |
| [ci-ladder.md]({{COMPANION_ROOT}}/workflow/ci-ladder.md) | Fast/Full mapping |
| [review-subagent-models.md]({{COMPANION_ROOT}}/overlays/opencode/review-subagent-models.md) | Model hints (overlay leaf) |
| [discovery.md]({{COMPANION_ROOT}}/workflow/discovery.md) | Before judging architecture |

## Must not

- Launch reviewers without Observed Fast CI (when Fast ≠ n/a)
- Pair Full CI with reviewers
- Use host `docs/workflow/` as procedure SoT

## Related agents

`implementer`, `production_readiness_reviewer`, `bug_reviewer` — `{{COMPANION_ROOT}}/agents/`
