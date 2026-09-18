# Antigravity overlay — harness copy-out map

**Last updated:** 2026-09-18

## Context

Antigravity-native **host overlay** at `overlays/antigravity/`. Portable procedure stays at repo-root bases (`workflow/`, `skills/`, `agents/`, `rules/`). Overlay = **thin harness only**. Live `~/.gemini` harness synced via [`Sync-HostHarness.ps1`](../../scripts/Sync-HostHarness.ps1) (`-Target Antigravity`; `-Apply` for live writes); SOP: [antigravity-host-adapter](../../docs/SOPs/antigravity-host-adapter.md); see [host-sync README](../../scripts/host-sync/README.md). Sync does **not** create backups; Phase 0 baseline is restore-only.

Owner decisions (2026-08-23): cursorEscape is the **sole SoT** — live global rules are **wholesale-replaced** by the registry-composed `antigravity-gemini` runtime gate; v1 surfaces are global skills, global workflows, subagent defs, and the composed `GEMINI.md`. Gemini CLI reads the same `GEMINI.md` path — accepted consequence.

**Host facts (Observed 2026-08-23):**

- **D1 subagents:** `invoke_subagent` spawns concurrent clean-context children (no parent-history inheritance) → parallel dual-launch parity supported. Custom subagents are **file-based**: `~/.gemini/config/agents/<name>.md` with YAML frontmatter (`name`/`description` required; `tools` allowlist — exact tool names only, misspellings hang the process). Reviewer defs ship read-only tool allowlists (edit-deny parity).
- **D3 skills:** auto-discovered into the catalog from `~/.gemini/config/skills/<id>/SKILL.md` (frontmatter `description` required, `name` defaults to folder). No registration wiring observed in `~/.gemini/config/config.json`.
- Workflows: markdown at `~/.gemini/antigravity/global_workflows/*.md`, invoked `/filename`; 12k char limit (rules too).

**Tokens:** `{{COMPANION_ROOT}}` = absolute path to this git repo. No other tokens in use. Hardcoded machine paths in harness leaves are forbidden (token merge + unmerged-token guard is the enforcement).

## Substance

| Live target (`~/.gemini/…`) | Overlay source | Notes |
| --------------------------- | -------------- | ----- |
| `GEMINI.md` | [expected-render anchor](../../scripts/host-sync/render-baselines/phase2/antigravity/overlays__antigravity__GEMINI.md) | Committed expected-render anchor for the registry-composed `antigravity-gemini` **runtime-only** destination — **full replacement** of live global rules (sole SoT); composed sync output, not an authored overlay source |
| `config/skills/<11 ids>/SKILL.md` | [skills/*/SKILL.md](./skills/) | Thin stubs mirroring the OpenCode overlay set; absolute `{{COMPANION_ROOT}}` Reads; `pre-commit-ci-gate` composed from `base:rules/pre-commit-ci-gate.md` + host footer (Phase 2) |
| `antigravity/global_workflows/escape-{plan,review,closeout}.md` | [workflows/](./workflows/) | Trajectory-level wrappers invoking companion procedures |
| `config/agents/{planner,plan_reviewer,implementer,production_readiness_reviewer,bug_reviewer,repository_explorer,test_reviewer}.md` | [agents/](./agents/) | Governed planner/implementation/investigation/reviewer legs; reviewer defs use read-only tools; `implementer` canonical authority is workspace-write but live-write smoke remains Phase 6; parallel via `invoke_subagent` |

**Deliberate exclusion:** companion `skills/` holds more ids than mirrored here (e.g. `grilling`, `tdd-*`, `wizard`, `teach`) — parity bar is the **OpenCode overlay inventory** ([opencode-host-adapter](../../docs/SOPs/opencode-host-adapter.md)); extend deliberately, not by default. 2026-08-26 owner ruling: the `opencode-*` infrastructure pair (`opencode-headless-run`, `opencode-history-search`) is **global** and must mirror on every stack. Note: `pre-commit-ci-gate` has no companion skill base — its portable SoT is [`rules/pre-commit-ci-gate.md`](../../rules/pre-commit-ci-gate.md); since Phase 2 the stub is **composed at sync time** from that rule (base: sourcing) plus the host footer, not hand-restated.

**Hard excludes / never touch:** `antigravity/global_workflows/caveman.md` (user-authored workflow — listed in both lists by design), secrets/app-state files at the `~/.gemini` root and `config/mcp_config.json`.

## Implications / open questions

1. Gate-text changes must echo here **and** in Cursor/OpenCode overlays per [editing companion workflow](../../docs/SOPs/editing-companion-workflow.md).
2. D2 (restart vs hot-reload) unresolved until operator post-Apply smoke — SOP assumes full quit + restart.
3. Workspace-level surfaces (`.agents/rules`, `.agents/skills`, project-root `AGENTS.md`) are **future scope**, not synced by v1.
4. Dependency availability: this overlay's `bug_reviewer.md` cites `{{COMPANION_ROOT}}/skills/bug-review-sweep/SKILL.md`; that canonical base is tracked, so this wrapper has no separate land/co-commit ordering constraint.

## Related

- [Antigravity host adapter SOP](../../docs/SOPs/antigravity-host-adapter.md)
- [Host sync README](../../scripts/host-sync/README.md)
- [Overlays index](../_index.md)
- [Skill source and host overlays](../../docs/featureArchitecture/skill-source-and-host-overlays.md)
- [Host adaptation fidelity](../../docs/featureArchitecture/host-adaptation-fidelity.md)
- [OpenCode overlay](../opencode/_index.md)
