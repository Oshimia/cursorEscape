---
name: architecture-survey
description: >-
  Guided read-only review that finds architecture-improvement opportunities,
  explains each issue plainly, compares solutions including the cost of doing
  nothing, and ends in an improvement plan the owner understands and agrees
  with.
disable-model-invocation: true
---

# Architecture survey

## When to use

The owner wants a guided pass over a repo or area to surface architecture-improvement opportunities and decide together what is worth addressing. Not for implementing changes, not for routine code review, not a substitute for planning.

## Workflow

The companion procedure defines the guided process: scope selection, read-only exploration, candidate cards with options and inaction costs, discussion checkpoint, explicit owner selection, then handoff of selected work to normal planning. The caller owns scope and pacing.

## Outputs

One or more Markdown candidate cards plus an agreed handoff note for selected candidates. The survey itself changes nothing: no code edits, no document mutations, no automatic plan creation.

## Read

- [Architecture survey procedure](../../workflow/architecture-survey.md)
- [Codebase-design vocabulary](../codebase-design/SKILL.md)
- [Clean context and isolation](../../docs/featureArchitecture/clean-context-isolation.md)

## Must not

Stay read-only until the owner explicitly selects candidates; silence is never consent. Never implement refactors or mutate documents during a survey. Never bypass implementation-plan: selected work enters through normal gates. Never redefine vocabulary owned by [codebase-design](../codebase-design/SKILL.md). Never emit HTML/CDN-dependent reports; Markdown only.

## Related roles

The owner decides which candidates enter planning. The agent surveys read-only, explains issues and trade-offs, and drafts comparison cards.

## Provenance

Adapted from the pinned mattpocock/skills snapshot at commit 0ab1b63: [source skill](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/improve-codebase-architecture/SKILL.md). The upstream HTML report machinery was intentionally dropped; this adaptation is Markdown-first and decision-focused.
