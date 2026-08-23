---
name: implementation-review
description: >-
  Run the dual-gate review loop after implementation: Observed Fast CI,
  parallel production_readiness_reviewer + bug_reviewer (≤4 iterations per
  pressure-release block), then Full CI closeout — or reassessment / Composer
  cap-exhausted handoff. Default on unless truly trivial or explicit user opt-out.
---

# Implementation review (OpenCode harness)

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
       or Composer Nb cap-exhausted handoff (no Full)
```

1. **Fast CI Observed** — per-command rows. Do **not** launch reviewers on fail, skipped (when Fast ≠ n/a), or claimed-only.
2. **Parallel Task** — `production_readiness_reviewer` and `bug_reviewer`, `Completion gate: review-loop`.
   - **production_readiness_reviewer:** locked opener — **no** Custom Instructions field. Focus-narrow = narrower task summary + applicable docs only.
   - **bug_reviewer:** **Custom Instructions** envelope (phase, iteration 1–4 within block, cumulative launch count, regressions, out-of-scope). Focus-narrow = current-fix only.
3. Fix must-fix; re-run Observed Fast CI (when Fast ≠ n/a); at most **4** dual-review iterations per block — **do not launch a 5th pair**. **Auto-continue:** the block runs to dual APPROVED or iteration 4 without permission pauses. Each reviewer return echoes the payload's attestation marker verbatim; an empty/fast return (< ~1s) is a routing/auth failure — fail loud, never read as "no bugs found".
4. **Exit:** dual APPROVED → Full CI only (never with reviewers). Iteration 4 without dual APPROVED → normal reassessment or Composer cap-exhausted handoff — **no Full**, **no** `task-phase-complete`. Never self-Waive (Waive = Composer-only). Then disposition deferred batchables (before Full, per companion rubric).

## Read when

| Doc | When |
|-----|------|
| [SKILL.md]({{COMPANION_ROOT}}/skills/implementation-review/SKILL.md) | Full loop + pressure-release / anti-abuse |
| [iterative-code-review.md]({{COMPANION_ROOT}}/workflow/iterative-code-review.md) | Loop rules, per-phase boundaries |
| [ci-ladder.md]({{COMPANION_ROOT}}/workflow/ci-ladder.md) | Fast/Full mapping |
| [code-review-frame.md]({{COMPANION_ROOT}}/workflow/code-review-frame.md) | Optional Standards/Spec evidence frame |
| [composer/SKILL.md]({{COMPANION_ROOT}}/skills/composer/SKILL.md) | Cap-exhausted handoff schema (Composer Nb) |
| [review-subagent-models.md]({{COMPANION_ROOT}}/overlays/opencode/review-subagent-models.md) | Model hints (overlay leaf) |
| [discovery.md]({{COMPANION_ROOT}}/workflow/discovery.md) | Before judging architecture |

## Must not

- Launch reviewers without Observed Fast CI (when Fast ≠ n/a)
- Pair Full CI with reviewers
- Launch a 5th dual-review pair in the current block
- Use host `docs/workflow/` as procedure SoT

## Related agents

`implementer`, `production_readiness_reviewer`, `bug_reviewer` — `{{COMPANION_ROOT}}/agents/`
