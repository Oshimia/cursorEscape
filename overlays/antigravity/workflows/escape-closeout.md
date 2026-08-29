---
description: cursorEscape closeout gate - pre-commit CI ladder check before any local commit; commit locally, never push.
---

# escape-closeout

Run the cursorEscape **pre-commit closeout** for the current changeset: Read `{{COMPANION_ROOT}}/rules/pre-commit-ci-gate.md` (companion SoT) plus the CI ladder at `{{COMPANION_ROOT}}/workflow/ci-ladder.md`, then:

1. Confirm the review-loop state transition named by the companion rule.
2. Run the Full CI leg observed when Full != n/a; record per-command rows.
3. Stage only intended files; verify no secrets or machine paths in the diff; write a concise commit message matching repo style.
4. Local commit only - **never push** without explicit operator instruction.