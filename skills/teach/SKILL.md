---
name: teach
description: >-
  Dedicated opt-in Markdown learning workspace: owner-named topic, cited
  high-trust resources, small single-skill lessons, retrieval and spaced
  review records. Runs in an isolated owner-selected directory; never
  loaded during ordinary coding sessions.
disable-model-invocation: true
---

# Teach

## When to use

The owner explicitly starts or resumes a dedicated learning workspace on a named topic. Not for engineering tasks; if the request is code work in a product repo it belongs to normal implementation instead.

## Workflow

The companion procedure defines workspace setup, mission confirmation with prior-knowledge assessment, resource grounding, lesson authoring, the retrieval and review loop, and exit criteria. The caller owns topic choice and confirms the mission.

## Outputs

Workspace files inside the designated root only: MISSION.md, RESOURCES.md, lessons/, LEARNING-RECORD.md. Nothing outside that root is written; the active product repo is untouched.

## Read

- [Teach procedure](../../workflow/teach.md)

## Must not

Never write outside the designated learning workspace root; never modify the active product repo or any engineering tree; never present model knowledge as sourced without verifying it against a listed resource; never author HTML lessons this phase (Markdown only); never auto-load during normal coding sessions.

## Related roles

The owner names the topic, confirms mission and prior knowledge, and completes exercises. The agent structures the workspace, grounds every claim in listed sources, keeps lessons small, and maintains the record.

## Provenance

Adapted from the pinned mattpocock/skills snapshot at commit 0ab1b63: [source skill](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/teach/SKILL.md). The upstream HTML rendering and asset pipeline were replaced by a narrow text/Markdown-first mode.
