# Host overlays (recorded files)

**Last updated:** 2026-08-20

## Context

This folder holds **host-native** skill, agent, rule, and deep-workflow files recorded from a live stack. It is **not** the portable Target contract tree (repo-root bases: [`skills/`](../skills/_index.md), [`agents/`](../agents/_index.md), [`rules/`](../rules/)) and **not** the Phase 3 research import ([cursor-global-workflow](../research/imported/cursor-global-workflow/)).

Architecture: [skill source and host overlays](../docs/featureArchitecture/skill-source-and-host-overlays.md) (Approach A). **OpenCode** host-plugged copy-out is **authorized and applied** from [overlays/opencode/](./opencode/_index.md) (Phase 3 live sync 2026-08-20; **pointer-first-4** mirror delete 2026-08-20). **Target load path:** thin harness on host; deep procedure via absolute `{{COMPANION_ROOT}}` Reads — OpenCode procedure mirror **deleted**. **Cursor** copy-out to `~/.cursor` remains manual / not repo-authorized.

## Substance

| Host | Contents | Status |
| ---- | -------- | ------ |
| [cursor/](./cursor/_index.md) | Skills, rules, agents from live `~/.cursor`; deep procedure at repo-root [`workflow/`](../workflow/_index.md) | **Thin wrappers** — spawn + Read tables; bases at repo root |
| [opencode/](./opencode/_index.md) | OpenCode harness: instructions, thin skill stubs, agent harness, specimen config | **pointer-first-4 complete** (2026-08-20); harness-only sync; procedure mirror deleted |

Live OpenCode adapter at `C:\Users\admin\.config\opencode\` synced from [overlays/opencode/](./opencode/_index.md). C6 minimum smoke rows **1–4**, **8**, **9–10**, **13**: **pass** (2026-08-20 operator post-mirror); row **14** install-time pass. See [pointer-first-4 closeout](../analysis/pointer-first-4-closeout-2026-08.md).

## Implications / open questions

1. Portable procedure edits: **Target** → repo-root bases (`workflow/`, `skills/`, `agents/`, `rules/`, FA). Overlay refresh: re-copy **harness only** when authorized — not a second authored procedure tree. OpenCode host procedure mirror **deleted** pf4; Cursor `~/.cursor/docs/workflow/` may remain transitional ([closeout](../analysis/pointer-first-4-closeout-2026-08.md)).
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
- [Companion pointer-first](../docs/roadmaps/pointer-first.md)
