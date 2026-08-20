# User Rules snippet — Implementation review (paste into Customize → Rules → User Rules)

Keep lean. Echo of companion `rules/iterative-code-review.md`.

```text
## Implementation review (all repos)

For non-trivial implementation (multi-file, large single-file, cross-layer, behavioral, DB/migration, new modules, or each plan phase):
1. Fast CI Observed for touched areas (per-command pass|fail|skipped|n/a rows; do not launch on fail, skipped when Fast ≠ n/a, or claimed-only). Then reviewer-a + Bugbot in parallel (Completion gate: review-loop). Locked Reviewer-a opener required. Recommended model: composer-2.5.
2. Fix must-fix findings within a 4-iteration pressure-release block; do not launch a 5th pair. Dual APPROVED = Bugbot all lists None; Reviewer-a Blocking / Non-blocking / blocking test/docs None — Batchable (deferred) may remain. Track cumulative per-leg launch counts. After block without dual APPROVED: normal reassessment (Renew | Focus-narrow | Terminate+user with anti-abuse) or Composer Nb cap-exhausted handoff — detail in implementation-review skill. No Custom Instructions on Reviewer-a. Waive = Composer-only.
3. Closeout = Full CI only after dual APPROVED (no reviewers). Cap handoff: no Full until Composer triage. Attest block number + cumulative launches + Batchable (deferred) punch list. Dual APPROVED ≠ proven ship-class catch or proven no-escape. Do not batch multiple plan phases into one review.

Skip only for truly trivial one-place typo/copy, comment-only, formatting, cosmetic-only UI, docs-only with no behavior change, or explicit user skip.
```
