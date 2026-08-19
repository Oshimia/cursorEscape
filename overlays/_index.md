# Host overlays (recorded files)

**Last updated:** 2026-08-20

## Context

This folder holds **host-native** skill, agent, rule, and deep-workflow files recorded from a live stack. It is **not** the portable Target contract tree (gold bases: [`skills/`](../skills/_index.md), [`agents/`](../agents/_index.md), [`rules/`](../rules/)) and **not** the Phase 3 research import ([cursor-global-workflow](../research/imported/cursor-global-workflow/)).

Architecture: [skill source and host overlays](../docs/featureArchitecture/skill-source-and-host-overlays.md) (Approach A). Copy-out **into** host config dirs is still **not authorized**.

## Substance

| Host | Contents | Status |
| ---- | -------- | ------ |
| [cursor/](./cursor/_index.md) | Skills, rules, agents from live `~/.cursor`; deep procedure at repo-root [`workflow/`](../workflow/_index.md) | **Thin wrappers** — spawn + Read tables; gold bases at repo root |

OpenCode overlay files are **not** in this tree. Live adapter remains under `C:\Users\admin\.config\opencode\` ([opencode-host-adapter](../docs/SOPs/opencode-host-adapter.md)).

## Implications / open questions

1. Portable procedure edits: **Target** → gold bases (`workflow/`, `skills/`, `agents/`, `rules/`, FA). Overlay refresh: re-copy from live when authorized — not a second authored procedure tree.
2. Do not invent `adapters/` at repo root for copy-out until that phase is authorized.

## Related

- [Cursor overlay](./cursor/_index.md)
- [Skill contracts](../skills/_index.md)
- [Agent contracts](../agents/_index.md)
- [Documenting this repo](../docs/SOPs/documenting-this-repo.md)
- [Shared workflow docs roadmap](../docs/roadmaps/shared-workflow-docs.md)
