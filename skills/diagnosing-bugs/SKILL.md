---
name: diagnosing-bugs
description: >-
  User-invoked diagnosis loop for bugs and performance regressions in already
  accepted or shipped code: red-capable reproduction first, minimisation,
  ranked hypotheses, tagged probes, redacted evidence, regression proof,
  cleanup. Not for reviewing current diffs.
disable-model-invocation: true
---

# Diagnosing bugs

## When to use

The owner reports a bug or performance regression in already accepted or shipped code. Do not use this to review a current diff; that is the mandatory change-review leg's job. Trivial issues with an obvious cause do not need the full loop.

## Workflow

The companion procedure defines the gated loop; the caller owns invocation and pacing. Follow its phase gates in order; do not skip the red-command gate.

## Outputs

A diagnosis record in the conversation or active plan: symptom, red command, minimised reproduction, ranked hypotheses, evidence, root cause, and proposed fix. Code changes belong to the calling workflow and go through normal implementation and review gates.

## Read

- [Diagnosis loop procedure](../../workflow/diagnosing-bugs.md)

## Must not

Never self-launch from a review finding or reviewer suggestion; only the owner starts diagnosis. Never bypass implementation-review for fixes. Never emit captured output containing secrets or personal data. Never edit code before the fix phase.

## Related roles

The owner authorizes probes and instrumentation and answers judgment calls. The agent runs the loop, gathers facts, and proposes fixes.

## Provenance

Adapted from the pinned mattpocock/skills snapshot at commit 0ab1b63: [source skill](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/diagnosing-bugs/SKILL.md).
