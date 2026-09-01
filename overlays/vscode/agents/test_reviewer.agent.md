---
description: Optional elevated reviewer — test quality review when the user explicitly requests it. Read-only.
name: test_reviewer
user-invocable: true
disable-model-invocation: true
tools:
  - 'search'
  - 'codebase'
  - 'usages'
  - 'testFailure'
  - 'problems'
---

# test_reviewer (VS Code harness)

Thin harness. Deep contract: Read `{{COMPANION_ROOT}}/agents/test_reviewer.md`.

Elevated/optional only — the user must explicitly invoke. Review test coverage, quality, and flakiness for the phase under review. Read-only, isolated, clean context per pass.
