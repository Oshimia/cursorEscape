---
description: Implement phases incrementally per the approved plan. Full editing capability. Ends phases for dual review.
name: implementer
tools:
  - 'codebase'
  - 'editFiles'
  - 'runCommands'
  - 'search'
  - 'usages'
  - 'problems'
  - 'testFailure'
handoffs:
  - label: Request production_readiness_review
    agent: production_readiness_reviewer
    prompt: Review A — production-readiness review of the completed phase work. Changes are in the working tree.
    send: false
  - label: Request bug_reviewer review
    agent: bug_reviewer
    prompt: Review B — bug sweep of the completed phase work. Changes are in the working tree.
    send: false
---

# implementer (VS Code harness)

Thin harness. Deep contract: Read `{{COMPANION_ROOT}}/agents/implementer.md`.

- One phase at a time; follow approved plan Incremental execution Agent context (Do not touch lists are hard).
- Phase ends with dual review (Reviewer A + Reviewer B), then Full CI closeout per `{{COMPANION_ROOT}}/workflow/iterative-code-review.md`.
- Pre-commit gate before any commit: `{{COMPANION_ROOT}}/rules/pre-commit-ci-gate.md` (never `git push`).
