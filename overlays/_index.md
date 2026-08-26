# Host overlays (recorded files)

**Last updated:** 2026-08-24

## Context

This folder holds **host-native** skill, agent, rule, and deep-workflow files recorded from a live stack. It is **not** the portable Target contract tree (repo-root bases: [`skills/`](../skills/_index.md), [`agents/`](../agents/_index.md), [`rules/`](../rules/_index.md)) and **not** the Phase 3 research import ([cursor-global-workflow](../research/imported/cursor-global-workflow/)).

Architecture: [skill source and host overlays](../docs/featureArchitecture/skill-source-and-host-overlays.md) (Approach A). **Live sync:** modular [`Sync-HostHarness.ps1`](../scripts/Sync-HostHarness.ps1) (dry-run default; `-Apply` operator-gated) — layout in [`scripts/host-sync/README.md`](../scripts/host-sync/README.md). Sync **does not create backups**; Phase 0 baselines are restore-only. **Target load path:** thin harness on host; deep procedure via absolute `{{COMPANION_ROOT}}` Reads — OpenCode procedure mirror **deleted**.

## Substance

| Host | Contents | Status |
| ---- | -------- | ------ |
| [cursor/](./cursor/_index.md) | Skills, rules, agents from live `~/.cursor`; deep procedure at repo-root [`workflow/`](../workflow/_index.md) | **Thin wrappers** — included in global pushes (`-Apply`) |
| [opencode/](./opencode/_index.md) | OpenCode harness: instructions, thin skill stubs, agent harness, specimen config | **pointer-first-4 complete** — included in global pushes; procedure mirror deleted |
| [antigravity/](./antigravity/_index.md) | Antigravity harness: GEMINI.md gate (full-replace), 11 skill stubs, 3 escape-* workflows, 3 reviewer subagent defs | **Live sync authorized** (owner ruling 2026-08-26) — included in global pushes; SOP: [antigravity-host-adapter](../docs/SOPs/antigravity-host-adapter.md) |

Live OpenCode adapter at `C:\Users\admin\.config\opencode\` synced from [overlays/opencode/](./opencode/_index.md). C6 minimum smoke rows **1–4**, **8**, **9–10**, **13**: **pass** (2026-08-20 operator post-mirror); row **14** install-time pass. See [pointer-first-4 closeout](../analysis/pointer-first-4-closeout-2026-08.md).

## Implications / open questions

1. Portable procedure edits: **Target** → repo-root bases (`workflow/`, `skills/`, `agents/`, `rules/`, FA). Overlay refresh: run [`Sync-HostHarness.ps1`](../scripts/Sync-HostHarness.ps1) when authorized — harness only, not a second authored procedure tree. OpenCode host procedure mirror **deleted** pf4; Cursor `~/.cursor/docs/workflow/` may remain transitional ([closeout](../analysis/pointer-first-4-closeout-2026-08.md)).
2. Do not invent `adapters/` at repo root for copy-out — use `scripts/host-sync/` modular adapters ([expansion recipe](../scripts/host-sync/README.md#expansion-recipe-add-a-third-stack)).
3. **Live pushes are global by default** (owner ruling 2026-08-26): `Sync-HostHarness.ps1 -Apply` targets all stacks; single-stack Apply only via the `-AllowSkew` exception path. Post-apply verification is script-authoritative for routine syncs ([policy](../scripts/host-sync/README.md#post-apply-verification-policy)) — smoke attestation belongs to first-time surfaces and machinery changes, not per-skill updates.

## Related

- [OpenCode overlay](./opencode/_index.md)
- [Cursor overlay](./cursor/_index.md)
- [Antigravity overlay](./antigravity/_index.md)
- [Host adaptation fidelity](../docs/featureArchitecture/host-adaptation-fidelity.md)
- [Skill contracts](../skills/_index.md)
- [Agent contracts](../agents/_index.md)
- [Rules index](../rules/_index.md)
- [Documenting this repo](../docs/SOPs/documenting-this-repo.md)
- [Shared workflow docs roadmap](../docs/roadmaps/shared-workflow-docs.md)
- [Companion pointer-first](../docs/roadmaps/pointer-first.md)
