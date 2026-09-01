# review (Cline overlay — serial dual review, this harness)

Loop per `{{COMPANION_ROOT}}/workflow/iterative-code-review.md`.

## Steps

1. Run Observed Fast CI first (per `{{COMPANION_ROOT}}/workflow/ci-ladder.md` mapping of this repo's scripts). No reviewers on fail/skip/claimed-only.
2. Reviewer A — adopt the **production_readiness_reviewer** persona: read `{{COMPANION_ROOT}}/agents/production_readiness_reviewer.md`; produce its output only (no fixes).
3. Reviewer B — adopt the **bug_reviewer** persona: read `{{COMPANION_ROOT}}/agents/bug_reviewer.md` + sweep skill `{{COMPANION_ROOT}}/skills/bug-review-sweep/SKILL.md`.
4. Fix must-fix items; re-run Fast CI; repeat ≤4 iterations/block; auto-continue — no permission pauses inside a block.
5. Dual APPROVED → Full CI only (never with reviewers). Iteration 4 without dual APPROVED → reassessment or composer cap-exhausted handoff.

**Isolation (serial):** keep each persona's reasoning in its own labeled block; never mix streams; never feed prior review text into the next persona's pass.
