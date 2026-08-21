---
name: codebase-design
description: >-
  Reference vocabulary for reasoning about deep modules, interfaces, seams,
  test surfaces, and alternative designs. Use when a caller needs design
  language, not a new workflow or automatic refactoring.
disable-model-invocation: true
---

# Codebase Design Reference

This is a portable, non-driver reference for discussing deep modules: useful
behavior behind a small interface, placed at a deliberate seam and testable
through that interface. It supplies shared vocabulary for later design and
testing work; it does not start work, choose a checkpoint, or produce an
artifact by itself.

## When to use

Read this skill when a caller is reasoning about module shape, a seam, test
surface, deepening, or competing interface designs. The caller owns the
process, scope, checkpoints, invocation, and outputs. A caller may use one or
more companion pages as guidance without adopting a fixed sequence.

## Workflow

There is no prescribed workflow. Callers own the process, scope, checkpoints,
invocation, and any follow-up actions; this reference only supplies design
vocabulary and guidance.

## Outputs

This reference produces no artifact or output by itself. Any notes, plans,
reports, or code changes belong to the calling workflow.

## Read

- [Core vocabulary and principles](CORE.md)
- [Deepening guidance](DEEPENING.md)
- [Design alternatives](DESIGN-IT-TWICE.md)

## Boundary

This reference never dispatches agents, edits code, performs refactoring,
creates design records, or imposes an approval gate. Any isolated-agent
comparison described by a companion is advisory guidance: the calling
workflow owns whether and how to invoke it, and must pack the needed inputs
without relying on prior child transcripts.

## Related roles

Callers and their assigned roles own invocation, including any isolated-agent
comparison. This reference does not dispatch roles or agents.

## Provenance

Adapted from the pinned `mattpocock/skills` snapshot at commit `0ab1b63`:
[source skill](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/codebase-design/SKILL.md),
[deepening](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/codebase-design/DEEPENING.md),
and [design-it-twice](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/codebase-design/DESIGN-IT-TWICE.md).
