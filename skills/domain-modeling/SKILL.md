---
name: domain-modeling
description: >-
  Opt-in discipline for sharpening a project's shared language: challenge
  ambiguous terms into canonical definitions, record avoided synonyms,
  pressure-test with scenarios, cross-check code, and route resolutions per
  the documented-alignment policy.
disable-model-invocation: true
---

# Domain modeling

## When to use

Terminology drift is visible (competing names for one concept, one name meaning two things), a boundary is ambiguous, or a plan needs shared language before drafting. Owner- or parent-triggered; never ambient. Trivial naming choices do not need the full discipline.

## Workflow

The companion procedure defines the challenge loop; the caller owns scope and pacing. Every resolution routes through the documented-alignment policy referenced below.

## Outputs

Resolutions land where the ratified policy directs: an existing suitable glossary or design-decision document when discovery finds one; otherwise the active plan or research artifact. Creating a durable document happens only with explicit owner approval. This skill produces nothing by itself.

## Read

- [Domain modeling procedure](../../workflow/domain-modeling.md)
- [Documented alignment policy](../../workflow/grilling.md#documented-alignment)

## Must not

Never create root CONTEXT.md, docs/adr/, or any durable tree by default. Never mutate durable documents during ordinary reviews or interviews without explicit owner approval. Never treat glossary entries as implementation specifications. Never redefine vocabulary owned by [codebase-design](../codebase-design/SKILL.md).

## Related roles

The owner approves durable writes and arbitrates disputed terms. The agent challenges definitions, runs scenario tests, and cross-checks code claims.

## Provenance

Adapted from the pinned mattpocock/skills snapshot at commit 0ab1b63: [source skill](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/domain-modeling/SKILL.md).
