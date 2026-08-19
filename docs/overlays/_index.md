# Host overlays (recorded files)

**Last updated:** 2026-08-20

## Context

This folder holds **host-native** skill, agent, rule, and deep-workflow files recorded from a live stack. It is **not** the portable Target contract tree (gold bases: `skills/`, `agents/`, `rules/` — interim: [docs/skills](../skills/_index.md), [docs/agents](../agents/_index.md)) and **not** the Phase 3 research import ([cursor-global-workflow](../research/imported/cursor-global-workflow/)).

Architecture: [skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md) (Approach A). Copy-out **into** host config dirs is still **not authorized**.

## Substance

| Host | Contents | Status |
| ---- | -------- | ------ |
| [cursor/](./cursor/_index.md) | Skills, rules, agents, and `docs/workflow` from live `~/.cursor` | **Observed** fat interim extract; **thin wrappers** in Phase 5 |

OpenCode overlay files are **not** in this tree. Live adapter remains under `C:\Users\admin\.config\opencode\` ([opencode-host-adapter](../SOPs/opencode-host-adapter.md)).

## Implications / open questions

1. Portable procedure edits: **Target** → gold bases; **interim (Phases 1–4)** → `docs/skills/`, `docs/agents/`, FA, or overlay index ([overlay FA](../featureArchitecture/skill-source-and-host-overlays.md) promotion rule). Overlay refresh: re-copy from live, or thin-wrapper rewrite in Phase 5 — not a second authored procedure tree.
2. Do not invent `adapters/` at repo root for copy-out until that phase is authorized.

## Related

- [Cursor overlay](./cursor/_index.md)
- [Skill contracts](../skills/_index.md)
- [Agent contracts](../agents/_index.md)
- [Documenting this repo](../SOPs/documenting-this-repo.md)
- [Shared workflow docs roadmap](../roadmaps/shared-workflow-docs.md)
