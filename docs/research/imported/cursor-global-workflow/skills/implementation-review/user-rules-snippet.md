> **Imported research** — Source: live `~/.cursor`; copied 2026-08-17 into cursorEscape. Status: Observed/imported (live canonical for Target workflow). Do not treat as Target cursorEscape design unless a Target doc cites it.
# User Rules snippet — Implementation review (paste into Customize → Rules → User Rules)

Keep lean.

```text
## Implementation review (all repos)

For non-trivial implementation (multi-file, large single-file, cross-layer, behavioral, DB/migration, new modules, or each plan phase):
1. Fast CI Observed for touched areas (per-command pass|fail|skipped|n/a rows; do not launch on fail, skipped when Fast ≠ n/a, or claimed-only). Then reviewer-a + Bugbot in parallel (Completion gate: review-loop). Locked Reviewer-a opener required. Recommended model: composer-2.5.
2. Fix must-fix findings; re-run Fast + both until dual APPROVED (Bugbot all lists None; Reviewer-a Blocking / Non-blocking / blocking test/docs None — Batchable (deferred) may remain). Per leg: count = completed+1; if count >= 9, narrow before invoke (Bugbot Custom Instructions = current-fix; Reviewer-a = narrower task summary + applicable docs) — no hard stop, no Custom Instructions on Reviewer-a.
3. Closeout = Full CI only (no reviewers). Attest per-leg launch counts + Batchable (deferred) punch list. Dual APPROVED ≠ proven ship-class catch or proven no-escape. Do not batch multiple plan phases into one review.

Skip only for truly trivial one-place typo/copy, comment-only, formatting, cosmetic-only UI, docs-only with no behavior change, or explicit user skip.
```
