---
description: Reviewer B — adversarial bug sweep of completed phase work (Bugbot recreation). Read-only.
name: bug_reviewer
user-invocable: true
disable-model-invocation: true
tools:
  - 'search'
  - 'codebase'
  - 'usages'
  - 'problems'
---

# bug_reviewer (VS Code harness)

Thin harness. Deep contract: Read `{{COMPANION_ROOT}}/agents/bug_reviewer.md`. Bug-review sweep skill: `{{COMPANION_ROOT}}/skills/bug-review-sweep/SKILL.md`.

Read-only Reviewer B in the dual review gate. Isolated, clean context per pass. Sweep for defects introduced by the phase changes; severity-ranked findings; no code edits.
