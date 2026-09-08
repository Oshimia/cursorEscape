# Codex overlay — source-only bring-up map

**Last updated:** 2026-09-08
**Status:** Phase 3 registered source-only; activated 2026-09-08 after three-client smoke (`ApplyState = Active`).
**SoT boundary:** canonical procedure remains at repository-root `skills/`, `agents/`, `workflow/`, and `rules/`. This overlay contains only Codex-native thin wrappers, invocation metadata, managed-block source, and agent wiring.
**Tokens:** `{{COMPANION_ROOT}}` is replaced with the absolute companion checkout path at render time. No rendered leaf may use a relative hop across either Codex root.

## Destination inventory

| Logical root | Planned leaves | Overlay source |
| --- | --- | --- |
| `codex-home` | `AGENTS.md` managed block; guard-only `AGENTS.override.md`; seven `agents/*.toml` agents | [instructions/agents-block.md](./instructions/agents-block.md), [agents/](./agents/) |
| `skill-root` | 23 `<skill-id>/SKILL.md` wrappers: 22 canonical skills plus generated `pre-commit-ci-gate` | [skills/](./skills/) |

The exact leaf set is pinned by `scripts/host-sync/baselines/codex-phase0-baseline-schema-2026-09.json` and mirrored by `scripts/host-sync/manifests/codex.manifest.psd1`. The manifest is registered through `scripts/host-sync/Register-StackAdapters.ps1`; orchestration dry-runs require explicit disposable roots for CI. `AGENTS.override.md` is deliberately guard-only: a non-empty live override must block Apply, so it has no generated body.

## Harness rules

- Generated standalone files carry `cursorEscape-managed:v1`; the managed `AGENTS.md` block is bounded by matching `cursorEscape-managed-block:v1` begin/end markers.
- All 23 wrappers are thin frontmatter-plus-pointer leaves. Their concise descriptions are the initial-catalog contract and must remain within the 8,000-character budget asserted by Fast CI.
- `opencode-headless-run` and `opencode-history-search` are explicit-only. Their minimal `agents/openai.yaml` metadata sets `policy.allow_implicit_invocation: false`; the metadata is overlay-only in this phase because the Phase 0 schema pins one `SKILL.md` leaf per wrapper.
- Reviewer and explorer agents use `sandbox_mode = "read-only"`. No persistent leaf pins a reasoning setting or model identity; inheritance is intentional.
- `{{COMPANION_ROOT}}` is the only authorized base for canonical procedure, contract, rule, FA, and SOP reads.

## Bring-up state

Registration exposes Codex to invalid-target help and all-stack planning. The lifecycle gate still refuses any selection containing BringUp before any selected stack writes, and a Codex preflight failure prevents every write pass. Activated 2026-09-08 after C1–C6 three-client smoke and separate owner authorization.
