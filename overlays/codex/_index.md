# Codex overlay — active composed harness map

**Last updated:** 2026-09-22
**Status:** Active (`ApplyState = Active`); activated 2026-09-08 after owner-authorized three-client smoke.
**SoT boundary:** canonical procedure remains at repository-root `skills/`, `agents/`, `workflow/`, and `rules/`. This overlay contains Codex-native thin wrappers, invocation metadata, agent wiring, the registry-composed managed-block footer, lifecycle hook wiring, and source-only extension surfaces.
**Tokens:** `{{COMPANION_ROOT}}` is replaced with the absolute companion checkout path at render time. No rendered leaf may use a relative hop across either Codex root.

## Destination inventory

| Logical root | Deployed leaves | Overlay source |
| --- | --- | --- |
| `codex-home` | `AGENTS.md` marker-bounded managed block composed from canonical rules plus [footers/codex-wiring.md](./footers/codex-wiring.md); guard-only `AGENTS.override.md`; seven `agents/*.toml` agents; stateless `hooks.json` plus [hooks/subagent_reminder.ps1](./hooks/subagent_reminder.ps1) | [agents/](./agents/), [footers/](./footers/), [hooks/](./hooks/) |
| `skill-root` | 23 `<skill-id>/SKILL.md` wrappers: 22 canonical skills plus generated `pre-commit-ci-gate` | [skills/](./skills/) |

The exact deployed leaf set is pinned by `scripts/host-sync/baselines/codex-manifest-schema-2026-09.json` and mirrored by `scripts/host-sync/manifests/codex.manifest.psd1`. The manifest is registered through `scripts/host-sync/Register-StackAdapters.ps1`; orchestration dry-runs require explicit disposable roots for CI. `AGENTS.override.md` is deliberately guard-only: a non-empty live override must block Apply, so it has no generated body. The Codex `rules/` surface is separate source-only structure and is not in that deployed destination set.

## Extension surfaces

Codex has both registered overlay extension surfaces: [rules/](./rules/) contains only the `_index.md` placeholder, and [hooks/](./hooks/) contains the managed `subagent_reminder.ps1`. The rules placeholder reserves host-specific capacity without creating a host load surface; the hook is active only when its manifest-bound deployment is synchronized and trusted through Codex. CI pins this surface alongside the six other registered stacks' `rules/` and `hooks/` surfaces.

## Harness rules

- Generated standalone files carry `cursorEscape-managed:v1`; the managed `AGENTS.md` block is bounded by matching `cursorEscape-managed-block:v1` begin/end markers.
- The managed `AGENTS.md` block is registry-composed from the four canonical gates plus the Codex wiring footer; its cleanup instruction remains part of the composed output.
- All 23 wrappers are thin frontmatter-plus-pointer leaves. Their concise descriptions are the initial-catalog contract and must remain within the 8,000-character budget asserted by Fast CI.
- `opencode-headless-run` and `opencode-history-search` are explicit-only. Their minimal `agents/openai.yaml` metadata sets `policy.allow_implicit_invocation: false`; the metadata is overlay-only in this phase because the Phase 0 schema pins one `SKILL.md` leaf per wrapper.
- Reviewer and explorer agents use `sandbox_mode = "read-only"`. No persistent leaf pins a reasoning setting or model identity; inheritance is intentional.
- `{{COMPANION_ROOT}}` is the only authorized base for canonical procedure, contract, rule, FA, and SOP reads.

## Bring-up state

Registration exposes Codex to invalid-target help and all-stack planning. The lifecycle gate still refuses any selection containing BringUp before any selected stack writes, and a Codex preflight failure prevents every write pass. Activated 2026-09-08 after C1–C6 three-client smoke and separate owner authorization.
