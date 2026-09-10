---
description: cursorEscape dual review gate - invoke production_readiness_reviewer and bug_reviewer in parallel via invoke_subagent per companion SoT (no restated gate text here).
---

# escape-review

Run the cursorEscape **implementation-review loop** on the current changeset: Read `{{COMPANION_ROOT}}/workflow/iterative-code-review.md` (companion SoT for pressure-release blocks, cap-exhausted handoff, and verdict bars), then:

1. Load skill `implementation-review` and follow `{{COMPANION_ROOT}}/skills/implementation-review/SKILL.md`.
2. Launch `production_readiness_reviewer` and `bug_reviewer` in parallel via `invoke_subagent`. Begin each payload with the canonical envelope at `{{COMPANION_ROOT}}/workflow/agent-invocation.md`, followed by `---`, an attestation marker, and that role's complete scoped inputs (repository path, task summary, iteration and cumulative launch count, `Completion gate: review-loop`, parent-verified Fast CI rows, changeset scope, regressions, and out-of-scope notes).
3. Iterate per the companion rule; fix must-fix findings, re-run Observed Fast CI when applicable, and re-launch both reviewers.

Never run a 5th dual-review iteration in one block; the companion rule owns all loop-phase sequencing and cap-exhausted handoff.
