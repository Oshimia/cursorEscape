---
description: cursorEscape dual review gate — Observed Fast CI, then parallel production_readiness_reviewer + bug_reviewer subagents (≤4 iterations per block), Full CI closeout.
---

# escape-review

Run the cursorEscape **implementation-review loop** on the current changeset. Deep procedure is companion-resident; load it via file reads — do not improvise.

1. Load skill `implementation-review` and follow `{{COMPANION_ROOT}}/skills/implementation-review/SKILL.md`.
2. Run **Fast CI Observed** — per-command pass|fail|skipped|n/a rows. Do not launch reviewers on fail, skipped (when Fast ≠ n/a), or claimed-only results.
3. Launch **both** subagents in parallel via `invoke_subagent`: `production_readiness_reviewer` (locked opener — no Custom Instructions envelope) and `bug_reviewer` (Custom Instructions allowed; must follow `{{COMPANION_ROOT}}/docs/featureArchitecture/bug-reviewer-finding-rubric.md`). Pack all Inputs; isolated clean-context children; never attach prior transcripts.
4. Fix must-fix within a 4-iteration pressure-release block; re-run Observed Fast CI; re-launch both. Never launch a 5th pair. Auto-continue to dual APPROVED or iteration 4.
5. Dual APPROVED → Full CI only (no reviewers). Empty/fast reviewer returns (< ~1s) are routing failures — fail loud, never "no bugs found."
