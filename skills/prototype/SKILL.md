---
name: prototype
description: >-
  Question-first throwaway code that answers one design or interaction
  question: pure logic modules or visibly distinct UI variants, built on an
  approved disposable path, answered, recorded, then discarded or explicitly
  promoted.
disable-model-invocation: true
---

# Prototype

## When to use

A design, behavior, or interaction question is blocking a decision and a small throwaway artifact would answer it faster than more discussion. Not for production features, not for exploratory code with no stated question.

## Workflow

The companion procedure defines the pattern: state the learning question first, pick the form, build on an approved disposable path, answer the question, record the answer, then dispose of the artifact. The caller owns the question, the path approval, and the disposition decision.

## Outputs

An answer to the learning question, recorded where the team keeps decisions, plus a disposable artifact whose default fate is deletion. The artifact itself is evidence, not deliverable code.

## Read

- [Prototype procedure](../../workflow/prototype.md)
- [Clean context and isolation](../../docs/featureArchitecture/clean-context-isolation.md)

## Must not

Never skip stating the learning question before building. Never place prototype artifacts in product source trees. Never import prototype code into product paths without a promotion decision through implementation-plan normal gates; promotion is a decision, never a side effect. Never leave a disposable artifact without an explicit disposition: discard, quarantine, or promote. Never redefine vocabulary owned by [codebase-design](../codebase-design/SKILL.md).

## Related roles

The owner states the learning question, approves the disposable path, and rules on disposition. The agent builds the artifact and reports what was learned.

## Provenance

Adapted from the pinned mattpocock/skills snapshot at commit 0ab1b63: [source skill](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/prototype/SKILL.md). Upstream branch and preview mechanics were replaced by disposable-path and visible-state conventions.
