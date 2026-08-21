# Diagnosis loop (advisory)

Advisory procedure for a gated loop that finds root causes in already accepted or shipped code. Companion skill: [diagnosing-bugs](../skills/diagnosing-bugs/SKILL.md).

Vocabulary note: **seam** and **interface** keep their [codebase design](../skills/codebase-design/CORE.md) meanings.

## Gate 1: go red first

Before any hypothesis work, establish one command that reproduces the symptom on demand and fails or misbehaves visibly: a failing test where a test seam exists, otherwise a CLI or HTTP replay, a captured trace, a minimal harness script, bisection across history, or lastly a short human-in-the-loop script the owner runs. Order by cost and reliability for the repository at hand; no single toolchain is assumed. No red command, no next gate: speculation without reproducible evidence is out of scope.

## Gate 2: minimise

Reduce the reproduction to the smallest input, state, and steps that still show the symptom. A minimal reproduction separates the bug from its surroundings and usually points at the boundary it crosses.

## Gate 3: ranked hypotheses

Write three to five falsifiable hypotheses about the cause, each with the observation that would confirm or refute it, ranked by likelihood and cost to test. Hypotheses come after red, never before.

## Gate 4: probe one variable at a time

Test hypotheses with the cheapest decisive probe first, changing exactly one thing per probe. Any temporary instrumentation added to source is tagged (for example a consistent comment marker) and recorded so Gate 6 can remove every piece.

## Redaction before anything leaves context

Captured output often contains secrets, tokens, or personal data. Redact such material before any log excerpt, trace, or request payload enters the conversation, a plan, or a finding. When in doubt about a fragment, summarize it instead of quoting it.

## Gate 5: fix and prove

Implement the fix, then prove it with a regression test at the correct public seam when one exists. If no correct seam exists, document why rather than forcing a contrived test surface. Route the fix through the normal implementation and review loop; diagnosis never approves or closes its own changes.

## Gate 6: clean up

Remove every tagged instrumentation piece and any scratch artifacts, then re-run the red command to confirm the symptom is gone and the cleanup changed nothing else.

## Subordination and launch

Only the owner starts a diagnosis run. Review findings may suggest one; nothing launches automatically. This loop is subordinate to the standard pipeline: it feeds a proposed fix into implementation-plan / implementation-review rather than replacing them.

## Related

- [Diagnosing bugs skill](../skills/diagnosing-bugs/SKILL.md)
- [TDD test quality](tdd-tests.md)
- [Workflow docs index](_index.md)
