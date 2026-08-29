---
description: cursorEscape dual review gate - invoke the production_readiness_reviewer subagent directly via invoke_subagent per companion SoT (no restated gate text here).
---

# escape-review

Run the cursorEscape **implementation-review loop** on the current changeset: Read `{{COMPANION_ROOT}}/workflow/iterative-code-review.md` (companion SoT for pressure-release blocks, cap-exhausted handoff, and verdict bars), then:

1. Load skill `implementation-review` and follow `{{COMPANION_ROOT}}/skills/implementation-review/SKILL.md`.
2. Invoke subagent `production_readiness_reviewer` (single clean reviewer for this program; no Bugbot leg per owner program ruling) with the review-loop completion gate.
3. Iterate per the companion rule; fix must-fix findings before re-invoking the reviewer.

Never run a 5th review iteration in one block; the companion rule owns all loop-phase sequencing and cap-exhausted handoff.