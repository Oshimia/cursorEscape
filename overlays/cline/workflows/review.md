# review (Cline overlay — serial dual review, this harness)

Loop per `{{COMPANION_ROOT}}/workflow/iterative-code-review.md`.

## Steps

1. Run Observed Fast CI first (per `{{COMPANION_ROOT}}/workflow/ci-ladder.md` mapping of this repo's scripts). No reviewers on fail/skip/claimed-only.
2. Reviewer A — start a fresh Cline task/session for `production_readiness_reviewer`; do not reuse the implementation conversation. Begin its payload with the canonical envelope at `{{COMPANION_ROOT}}/workflow/agent-invocation.md`, then add `---`, an attestation marker, and all role-required scoped inputs. Return only Reviewer A's findings/verdict to the loop parent; no fixes.
3. Reviewer B — close or set aside Reviewer A's task, then start another fresh Cline task/session for `bug_reviewer`. Do not transfer Reviewer A's findings or reasoning. Begin its payload with the canonical envelope at `{{COMPANION_ROOT}}/workflow/agent-invocation.md`, then add `---`, an attestation marker, and all role-required scoped inputs. Return findings or CLEAN only.
4. In the loop parent, fix must-fix items; re-run Fast CI; then launch the next fresh Reviewer A/B task pair. Repeat ≤4 iterations/block; auto-continue — no permission pauses inside a block.
5. Dual APPROVED → Full CI only (never with reviewers). Iteration 4 without dual APPROVED → reassessment or composer cap-exhausted handoff.

**Isolation (fresh task per leg):** every reviewer pass gets a fresh Cline task/session containing only the packed scoped payload. A same-conversation persona block is not clean-context and is prohibited. Never feed prior review text into the next reviewer. A missing, malformed, contradictory, or unreadable envelope fails loudly in that reviewer's native output shape.
