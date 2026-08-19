# Host overlays (recorded files)

**Last updated:** 2026-08-20

## Context

This folder holds **host-native** skill, agent, rule, and deep-workflow files recorded from a live stack. It is **not** the portable Target contract tree ([docs/skills](../skills/_index.md), [docs/agents](../agents/_index.md)) and **not** the Phase 3 research import ([cursor-global-workflow](../research/imported/cursor-global-workflow/)).

Architecture: [skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md). Copy-out **into** host config dirs is still **not** authorized.

## Substance

| Host | Contents | Status |
| ---- | -------- | ------ |
| [cursor/](./cursor/_index.md) | Verbatim skills, rules, agents, and `docs/workflow` from live `~/.cursor` | **Observed** extract; bodies frozen |

OpenCode overlay files are **not** in this tree. Live adapter remains under `C:\Users\admin\.config\opencode\` ([opencode-host-adapter](../SOPs/opencode-host-adapter.md)).

## Implications / open questions

1. Do not rewrite overlay bodies to match portable contracts. Procedure changes go to Target contracts first; overlay refresh is a later re-copy or authored thin wrapper.
2. Do not invent `adapters/` at repo root for copy-out until that phase is authorized.

## Related

- [Cursor overlay](./cursor/_index.md)
- [Skill contracts](../skills/_index.md)
- [Agent contracts](../agents/_index.md)
- [Documenting this repo](../SOPs/documenting-this-repo.md)
