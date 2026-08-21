---
name: tdd
description: >-
  Reference discipline for test-first work at agreed seams: red-green vertical
  slices, independent expected values, and boundary-only doubles. Use when a
  caller reasons about test design; it does not run tests or enforce a gate.
disable-model-invocation: true
---

# Test-Driven Development Reference

This is a portable, non-driver reference for test-first discipline: tests
placed at pre-agreed seams, one behavior per red-green slice, expected values
drawn from an independent source, and doubles only at boundaries. It supplies
shared guidance for later testing work; it does not start work, run a loop,
or produce an artifact by itself.

## When to use

Read this skill when a caller is reasoning about test design at a seam: where
a test belongs, what makes an assertion worth keeping, when a double is
appropriate, and what to do when no independent oracle exists. The caller
owns the process, scope, checkpoints, invocation, and outputs. A caller may
use one or more companion pages as guidance without adopting a fixed
sequence.

## Workflow

There is no prescribed workflow. Callers own the process, scope, checkpoints,
invocation, and any follow-up actions. TDD here is advisory guidance, not a
mandatory gate: nothing requires a failing test before every change, and a
caller may apply these pages selectively or not at all.

## Outputs

This reference produces no artifact or output by itself. Any tests, plans,
reports, or code changes belong to the calling workflow.

## Read

- [Test quality guidance](../../workflow/tdd-tests.md)
- [Mocking guidance](../../workflow/tdd-mocking.md)
- [Seam and interface vocabulary](../codebase-design/SKILL.md)

## Boundary

This reference never dispatches agents, edits code, writes or enforces tests,
imposes an approval gate, or produces artifacts. Refactoring stays in local
implementation and review work; it is not part of any loop described here,
and no step requires a red-green cycle as a gate.

## Related roles

Callers and their assigned roles own invocation, including whether tests are
written at all. This reference does not dispatch roles or agents.

## Provenance

Adapted from the pinned `mattpocock/skills` snapshot at commit `0ab1b63`:
[source skill](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/tdd/SKILL.md),
[tests](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/tdd/tests.md),
and [mocking](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/tdd/mocking.md).
