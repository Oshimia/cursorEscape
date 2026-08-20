# Host overlays (recorded files)

**Last updated:** 2026-08-20

## Context

This folder holds **host-native** skill, agent, rule, and deep-workflow files recorded from a live stack. It is **not** the portable Target contract tree (repo-root bases: [`skills/`](../skills/_index.md), [`agents/`](../agents/_index.md), [`rules/`](../rules/)) and **not** the Phase 3 research import ([cursor-global-workflow](../research/imported/cursor-global-workflow/)).

Architecture: [skill source and host overlays](../docs/featureArchitecture/skill-source-and-host-overlays.md) (Approach A). **OpenCode** host-plugged copy-out is **authorized** from [overlays/opencode/](./opencode/_index.md) (Phase 2). **Cursor** copy-out to `~/.cursor` remains manual / not repo-authorized.

## Substance

| Host | Contents | Status |
| ---- | -------- | ------ |
| [cursor/](./cursor/_index.md) | Skills, rules, agents from live `~/.cursor`; deep procedure at repo-root [`workflow/`](../workflow/_index.md) | **Thin wrappers** — spawn + Read tables; bases at repo root |
| [opencode/](./opencode/_index.md) | OpenCode harness: instructions, 8 skills, 7 agents, specimen config, workflow mirror recipe | **Phase 2 authored** — pending dual APPROVED; live sync Phase 3 |

Live OpenCode adapter remains under `C:\Users\admin\.config\opencode\` until Phase 3 operator sync.

## Implications / open questions

1. Portable procedure edits: **Target** → repo-root bases (`workflow/`, `skills/`, `agents/`, `rules/`, FA). Overlay refresh: re-copy from live when authorized — not a second authored procedure tree.
2. Do not invent `adapters/` at repo root for copy-out until that phase is authorized.

## Related

- [OpenCode overlay](./opencode/_index.md)
- [Cursor overlay](./cursor/_index.md)
- [Host adaptation fidelity](../docs/featureArchitecture/host-adaptation-fidelity.md)
- [Skill contracts](../skills/_index.md)
- [Agent contracts](../agents/_index.md)
- [Rules index](../rules/_index.md)
- [Documenting this repo](../docs/SOPs/documenting-this-repo.md)
- [Shared workflow docs roadmap](../docs/roadmaps/shared-workflow-docs.md)
