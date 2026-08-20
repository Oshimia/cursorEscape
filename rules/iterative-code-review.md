# Iterative code review (mandatory)

**Note:** `alwaysApply` is true after EZPZ cutover. Prefer User Rules snippets for reliable enforcement across Cursor versions.

Unless the change is **truly trivial** (typo/copy in one place, comment-only, pure formatting, cosmetic-only UI, docs-only with no behavior change, or user explicitly skips):

**Multi-phase plans:** full loop at the end of **each** phase — dual `APPROVED` before the next phase.

**Single-phase or ad-hoc:** once before declaring complete.

**Composer exception:** When the user assigns `composer` for phased execution, the Composer thread does **not** implement Nb or run the review loop. The **phase subagent** is the review-loop parent. Composer may create disposable Na previews, update roadmap status after QC, and perform closeout QC **or** cap-exhausted handoff triage (Renew | Focus-narrow | Terminate | Waive) per the `composer` skill. Waive = Composer-only.

1. **Implement** the current phase (or full scope if single-phase)
2. **Review loop** — Fast CI Observed → `reviewer-a` + Bugbot in parallel (`Completion gate: review-loop`); reset review iteration to 1 per phase and after each Renew/Focus-narrow. Do not launch on fail, skipped (Fast ≠ n/a), or claimed-only. Use the locked Reviewer-a opener (no Bugbot-style Custom Instructions envelope). **Pressure release:** at most **4** dual-review iterations per block; do not launch a 5th pair. Then normal parent reassessment (Renew | Focus-narrow | Terminate+user with anti-abuse) or Composer Nb cap-exhausted handoff — detail in `implementation-review` skill. Track cumulative per-leg launch counts for the phase. No Custom Instructions on Reviewer-a.
3. **Fix must-fix findings**; repeat within the block until dual `APPROVED` (Bugbot all lists `"None"`; Reviewer-a Blocking / Non-blocking / blocking test/docs `"None"` — **Batchable (deferred)** may remain) or hit the 4-iteration cap
4. **Closeout** — Full CI after dual `APPROVED` (no reviewers). If Full fails, fix and re-run Full only. Attest block number + cumulative launch counts + Batchable (deferred) punch list; dual APPROVED ≠ proven ship-class catch or proven no-escape. Cap handoff: no Full until Composer triage.
5. **Stop** — do not launch reviewers again after dual `APPROVED` unless code changed

**When in doubt, run the loop.** Detail: `implementation-review` skill and [`../workflow/ci-ladder.md`](../workflow/ci-ladder.md).
