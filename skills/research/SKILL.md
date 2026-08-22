---
name: research
description: >-
  Bounded primary-source research producing one cited Markdown artifact under
  research/. One question, one packed read-only child, claim-level citations
  with freshness labels. Output is Observed evidence, not contract source of
  truth.
disable-model-invocation: true
---

# Research

## When to use

A decision or plan needs external facts from primary sources: official documentation, specifications, first-party vendor announcements. For repo-internal questions use [repository_explorer](../../agents/repository_explorer.md) instead. Trivial lookups answered from already-cited sources do not need a new run.

## Workflow

The companion procedure defines the bounded loop; the caller owns the question, the scope, and the interpretation. Exactly one packed read-only child runs per question; it never re-delegates.

## Outputs

Exactly one cited Markdown artifact under research/, plus the artifact path returned to the caller. The parent interprets the artifact; the artifact itself is Observed evidence and never contract source of truth.

## Read

- [Research procedure](../../workflow/research.md)
- [Clean context and isolation](../../docs/featureArchitecture/clean-context-isolation.md)

## Must not

Never re-delegate or spawn further agents inside the research child. Never treat research output as contract SoT or cite it as implementation authority. Never run an unbounded or multi-question batch. Never present unavailable sources as verified; report them as unknowns.

## Related roles

The parent scopes the question, packs the child, and interprets results. The read-only research child fetches, reads, and cites.

## Provenance

Adapted from the pinned mattpocock/skills snapshot at commit 0ab1b63: [source skill](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/research/SKILL.md).
