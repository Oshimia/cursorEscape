---
name: diagnosing-bugs
description: >-
  User-invoked diagnosis loop for bugs/regressions in already accepted or
  shipped code. Use when the owner starts a diagnosis.
---

# Diagnosing bugs (OpenCode harness)

Thin harness. Full procedure: Read `{{COMPANION_ROOT}}/skills/diagnosing-bugs/SKILL.md`.

## When to use

Owner reports a bug/regression in already accepted or shipped code; not for current-diff review.

## Read when

| Doc | When |
|-----|------|
| [SKILL.md]({{COMPANION_ROOT}}/skills/diagnosing-bugs/SKILL.md) | Full loop: red gate, minimise, ranked hypotheses, redaction, cleanup |
| [diagnosing-bugs.md]({{COMPANION_ROOT}}/workflow/diagnosing-bugs.md) | Deep procedure leaf |

## Must not

- Self-launch from review findings (owner starts diagnosis)
- Bypass implementation-review for fixes
