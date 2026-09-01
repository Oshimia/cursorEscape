---
name: implementation-review
description: >-
  Run the dual-gate review loop after implementation: Observed Fast CI,
  parallel production_readiness_reviewer + bug_reviewer (≤4 iterations per
  pressure-release block), then Full CI closeout — or reassessment / Composer
  cap-exhausted handoff. Default on unless truly trivial or explicit user opt-out.
---

# Implementation review (VS Code harness)

Thin harness. Full procedure: Read `{{COMPANION_ROOT}}/skills/implementation-review/SKILL.md`.

## When to use

**Default on** at the end of each plan phase or any completed implementation task not on the skip list. **When in doubt, run it.**

**Skip only if:** trivial one-place typo/copy, comment-only, formatting, cosmetic-only UI, docs-only no behavior, **or** explicit user opt-out.

## Steps

```text
Implement
  → ≤4× (Fast CI Observed → production_readiness_reviewer ∥ bug_reviewer → fix)
  → dual APPROVED → Full CI → complete
  → else: Renew | Focus-narrow | Terminate+user
       or Composer cap-exhausted handoff (no Full)
```

1. **Fast CI Observed** — per-command rows. Do **not** launch reviewers on fail, skipped (when Fast ≠ n/a), or claimed-only.
2. **Parallel subagent launch** — `production_readiness_reviewer` and `bug_reviewer` (agents dropdown selections, or model-initiated where toolsets allow). Reviewers run isolated with clean context; each return echoes the payload's attestation marker verbatim; an empty/fast return (< ~1s) is a routing/auth failure — fail loud, never read as "no bugs found".
3. Fix must-fix; re-run Observed Fast CI (when Fast ≠ n/a); at most **4** dual-review iterations per block — **do not launch a 5th pair**. **Auto-continue:** the block runs to dual APPROVED or iteration 4 without permission pauses.
4. **Exit:** dual APPROVED → Full CI only (never with reviewers). Iteration 4 without dual APPROVED → normal reassessment or Composer cap-exhausted handoff — **no Full**, never self-Waive (Waive = Composer-only). Then disposition deferred batchables (before Full, per companion rubric).

## VS Code notes

- Handoff buttons on `implementer` prefill reviewer prompts (`Request production_readiness_review` / `Request bug_reviewer`); use them to keep payloads clean-context.
- Reviewers are read-only via `tools` frontmatter; do not widen their toolsets to "help" a review.

## Read when

| Doc | When |
|-----|------|
| [SKILL.md]({{COMPANION_ROOT}}/skills/implementation-review/SKILL.md) | Full procedure |
| [iterative-code-review.md]({{COMPANION_ROOT}}/workflow/iterative-code-review.md) | Portable loop rules + Must not |
| [ci-ladder.md]({{COMPANION_ROOT}}/workflow/ci-ladder.md) | Fast/Full mapping |
