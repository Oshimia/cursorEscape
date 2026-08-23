---
name: wait-what
description: >-
  User-invoked communication repair: when the owner says the last explanation
  did not land, re-pitch it by naming what failed and adding the missing
  premise in a simplified technical register, using locally discovered shared
  vocabulary when a glossary exists. Never model-invoked; never invents a
  glossary.
disable-model-invocation: true
---

# Wait-what

## When to use

The owner explicitly signals that the last explanation did not land and asks for a re-pitch. Not for general writing advice, not for code review feedback, and never fired unprompted because the agent guesses the owner is confused.

## Workflow

The companion procedure defines the trigger semantics and re-pitch loop: identify what did not land, add the missing premise rather than truncating further, use the simplified technical register, and ground shared vocabulary through local discovery with an explicit no-glossary fallback. One re-pitch per invocation; the loop ends on owner confirmation or redirect.

## Outputs

A conversational re-pitch only. No files are created or modified.

## Read

- [Wait-what procedure](../../workflow/wait-what.md)

## Must not

Never fire without an explicit owner signal; never become ambient-loaded or model-invoked; never bluntly truncate when the real failure is a missing premise; never invent, reference, or require a glossary or context-file convention that does not exist in the repo; never write durable artifacts as part of a re-pitch.

## Related roles

The owner owns invocation and confirms comprehension. The agent identifies the failed premise, re-pitches once in plain language, and hands control back.

## Provenance

Adapted from the pinned mattpocock/skills snapshot at commit 0ab1b63: [source skill](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/wait-what/SKILL.md). The upstream single-paragraph body (three instructions) was rebuilt as a gated procedure: its assumed `CONTEXT.md`/`CONTEXT-MAP.md` lookup became local discovery routing with an explicit no-glossary fallback, and its `agents/openai.yaml` invocation metadata became `disable-model-invocation: true` frontmatter. The ASD-STE100 reference is retained as an adapted writing discipline, not imported as a standard.
