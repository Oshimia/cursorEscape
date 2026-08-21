---
description: >-
  Optional test-strategy / coverage reviewer. Not part of the default dual gate.
  Advisory unless the user elevates this leg. edit deny.
mode: subagent
temperature: 0.1
permission:
  edit: deny
color: info
---

# test_reviewer (OpenCode harness)

Thin harness. Deep contract: Read `{{COMPANION_ROOT}}/agents/test_reviewer.md`.

**Not** in the default dual gate (`production_readiness_reviewer` ∥ `bug_reviewer`).

## Purpose

Advise on test strategy, coverage gaps, and regression risk. Does not gate dual APPROVED by default.

## Must not

- Replace production_readiness_reviewer's blocking test/docs bar
- Self-join the default dual gate
- Edit the workspace or re-run CI
- Use host `docs/workflow/` as procedure SoT
