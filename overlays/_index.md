# Host overlays (recorded files)

**Last updated:** 2026-09-19

## Context

This folder holds **host-native** skill, agent, rule, and deep-workflow files recorded from a live stack. It is **not** the portable Target contract tree (repo-root bases: [`skills/`](../skills/_index.md), [`agents/`](../agents/_index.md), [`rules/`](../rules/_index.md)) and **not** the Phase 3 research import ([cursor-global-workflow](../research/imported/cursor-global-workflow/)).

Architecture: [skill source and host overlays](../docs/featureArchitecture/skill-source-and-host-overlays.md) (Approach A). **Live sync:** modular [`Sync-HostHarness.ps1`](../scripts/Sync-HostHarness.ps1) (dry-run default; `-Apply` requires fresh explicit owner authorization per the [procedure registry Apply boundary](../docs/featureArchitecture/procedure-registry.md); single-stack `-AllowSkew` only as an explicitly owner-authorized recovery exception) — layout in [`scripts/host-sync/README.md`](../scripts/host-sync/README.md). Sync **does not create backups**; registered baselines are restore-only. **Target load path:** thin harness on host; deep procedure via absolute `{{COMPANION_ROOT}}` Reads — host procedure mirrors are forbidden.

## Substance

| Host | Contents | Status |
| ---- | -------- | ------ |
| [cursor/](./cursor/_index.md) | Skills, rules, agents from live `~/.cursor`; deep procedure at repo-root [`workflow/`](../workflow/_index.md) | **Thin wrappers** — included in global pushes (`-Apply`) |
| [opencode/](./opencode/_index.md) | OpenCode harness: instructions, thin skill stubs, agent harness, specimen config | **pointer-first-4 complete** — included in global pushes; procedure mirror deleted |
| [antigravity/](./antigravity/_index.md) | Antigravity harness: GEMINI.md gate (full-replace), 11 skill stubs, 3 escape-* workflows, all seven governed subagent defs (`planner`, `plan_reviewer`, `implementer`, `production_readiness_reviewer`, `bug_reviewer`, `repository_explorer`, `test_reviewer`) | Source routes included in global pushes; live Apply and runtime/live-write smoke require fresh explicit owner authorization; SOP: [antigravity-host-adapter](../docs/SOPs/antigravity-host-adapter.md) |
| [vscode/](./vscode/_index.md) | VS Code (Copilot) harness: 2 composed always-on instructions, 11 skill stubs, 8 `.agent.md` roles | Established stack using the shared generic adapter; live Apply and runtime/live-write smoke require fresh explicit owner authorization; SOP: [vscode-host-adapter](../docs/SOPs/vscode-host-adapter.md) |
| [cline/](./cline/_index.md) | Cline harness: composed always-on rule + escape trio workflows + fresh-task repository_explorer route | **Brought up 2026-09-01** — dispatches to shared Generic adapter; SOP: [cline-host-adapter](../docs/SOPs/cline-host-adapter.md) |
| [kilocode/](./kilocode/_index.md) | Kilo Code harness: composed always-on rule + escape trio (slash via auto-migration) + fresh-task repository_explorer route | **Brought up 2026-09-01** — dispatches to shared Generic adapter; SOP: [kilocode-host-adapter](../docs/SOPs/kilocode-host-adapter.md) |
| [codex/](./codex/_index.md) | OpenAI Codex harness: managed `AGENTS.md` block, seven TOML agents, 23 skill wrappers across `CODEX_HOME` + skill root | **Registered Phase 3; Active since 2026-09-08 (C1–C6 attested)** — SOP: [codex-host-adapter](../docs/SOPs/codex-host-adapter.md) |

Live OpenCode adapter at `C:\Users\admin\.config\opencode\` synced from [overlays/opencode/](./opencode/_index.md). C6 minimum smoke rows **1–4**, **8**, **9–10**, **13**: **pass** (2026-08-20 operator post-mirror); row **14** install-time pass.

## Implications / open questions

1. Portable procedure edits: **Target** → repo-root bases (`workflow/`, `skills/`, `agents/`, `rules/`, FA). Overlay refresh: run [`Sync-HostHarness.ps1`](../scripts/Sync-HostHarness.ps1) when authorized — harness only, not a second authored procedure tree. OpenCode host procedure mirror **deleted** pf4; Cursor `~/.cursor/docs/workflow/` may remain transitional.
2. Do not invent `adapters/` at repo root for copy-out — use `scripts/host-sync/` modular adapters ([expansion recipe](../scripts/host-sync/README.md#expansion-recipe-add-a-third-stack)).
3. **Apply scope:** with fresh explicit owner authorization, global targeting remains the Apply default (`Sync-HostHarness.ps1 -Apply` targets all stacks); single-stack Apply only via the `-AllowSkew` owner-authorized recovery path. Superseded rulings are not live-Apply authorization. Post-apply verification is script-authoritative for routine syncs ([policy](../scripts/host-sync/README.md#post-apply-verification-policy)) — smoke attestation belongs to first-time surfaces and machinery changes, not per-skill updates.

## Related

- [OpenCode overlay](./opencode/_index.md)
- [Cursor overlay](./cursor/_index.md)
- [Antigravity overlay](./antigravity/_index.md)
- [VS Code overlay](./vscode/_index.md)
- [Host adaptation fidelity](../docs/featureArchitecture/host-adaptation-fidelity.md)
- [Codex overlay](./codex/_index.md)
- [Skill contracts](../skills/_index.md)
- [Agent contracts](../agents/_index.md)
- [Rules index](../rules/_index.md)
- [Documenting this repo](../docs/SOPs/documenting-this-repo.md)
