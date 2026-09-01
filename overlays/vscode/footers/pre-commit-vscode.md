## VS Code harness pointers (pre-commit)

Thin harness. Full procedure: Read `{{COMPANION_ROOT}}/rules/pre-commit-ci-gate.md`.

Before any `git commit` after dual APPROVED — including when Full = `n/a` (then require explicit user acknowledgment per companion rule). Map Fast/Full via `{{COMPANION_ROOT}}/workflow/ci-ladder.md` and project scripts. Never pair Full CI with dual-gate reviewer launch.

Git red line: read/discovery git (status, log, diff, show, rev-parse, ls-files, blame, branch listings) is pre-allowed. Mutating verbs (add, commit, push, merge, rebase, reset, checkout) always prompt — the pre-commit gate is the only sanctioned path to a local commit, after dual APPROVED + Full CI (or explicit n/a acknowledgment); never `git push`.

**Related:** `implementer` agent, skill `composer`, skill `implementation-review` (all at `{{COMPANION_ROOT}}`).
