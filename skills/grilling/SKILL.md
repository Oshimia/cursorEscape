---
name: grilling
description: >-
  Structured interview that resolves a design tree's open questions before
  planning or deciding; user-triggered, never ambient.
disable-model-invocation: true
---

# Grilling

## When to use

Owner requests a structured interview before planning or deciding. Trivial or already-settled work should skip it.

## Workflow

No prescribed artifact. The companion procedure defines the loop; the caller owns invocation.

## Outputs

None by itself. Conclusions live in the conversation or a later plan unless the owner approves artifacts through normal gates.

## Read

- [Grilling interview procedure](../../workflow/grilling.md)

## Must not

Never act, edit files, replace implementation-plan or plan_reviewer, or proceed past owner confirmation.

## Related roles

The owner answers decisions. The agent may gather repository facts via read-only discovery or isolated read-only children per clean-context isolation.

## Provenance

Adapted from the pinned mattpocock/skills snapshot at commit 0ab1b63: [source skill](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/grilling/SKILL.md).
