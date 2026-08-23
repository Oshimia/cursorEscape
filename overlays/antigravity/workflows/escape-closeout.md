---
description: cursorEscape closeout gate — pre-commit CI ladder check before any local commit; commit locally, never push.
---

# escape-closeout

Run the cursorEscape **pre-commit closeout** for the current changeset. Deep procedure is companion-resident; load it via file reads — do not improvise.

1. Confirm the review loop state: dual APPROVED from `production_readiness_reviewer` + `bug_reviewer` (or an explicitly authorized skip). Dual APPROVED ≠ proven no-escape.
2. Load skill `pre-commit-ci-gate` and follow `{{COMPANION_ROOT}}/rules/pre-commit-ci-gate.md` (companion SoT) plus the CI ladder at `{{COMPANION_ROOT}}/workflow/ci-ladder.md`.
3. Run Full CI observed when Full ≠ n/a; record per-command rows. On fail: fix, then re-run the review loop (`/escape-review`) — do not commit red.
4. Stage only intended files; verify no secrets or machine paths in the diff; write a concise commit message matching repo style.
5. Local commit only — **never push** without explicit operator instruction.
