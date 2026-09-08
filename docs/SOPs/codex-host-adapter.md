# Codex host adapter SOP

**Stack:** `Codex` · **Logical roots:** effective `CODEX_HOME` (default `~/.codex`) + `~/.agents/skills` · **Surface:** managed `AGENTS.md` block, seven TOML agents, 23 skill wrappers

**Status:** registered Phase 3 2026-09-08; `ApplyState = Active` (activated 2026-09-08 after owner-authorized install; three-client smoke attested 2026-09-08: CLI, VS Code extension, ChatGPT desktop).

## Context

Codex is the seventh registered sync stack. Canonical procedure remains at repository-root [`skills/`](../../skills/_index.md), [`agents/`](../../agents/_index.md), [`workflow/`](../../workflow/_index.md), and [`rules/`](../../rules/_index.md). The Codex overlay contains only thin wrappers, invocation policy, agent wiring, and managed-install mechanics ([overlays/codex](../../overlays/codex/_index.md)).

The specialized adapter requires two explicit absolute roots. The operator entry resolves effective roots (`CODEX_HOME` or `~/.codex`, and `~/.agents/skills`) and passes them explicitly; the adapter never infers either root. The roots must exist, be directories, have no reparse-point ancestor, and be independent/non-nested.

## Must / Must-not

**Must**

- Use `Sync-HostHarness.ps1 -Target Codex` with explicit roots for disposable dry-runs.
- Keep `AGENTS.md` as marker-bounded managed block content; preserve foreign text outside the block.
- Treat `codex-home/AGENTS.override.md` as guard-only: a non-empty file must block Apply.
- Run the all-stack preflight before any Apply write pass when `Target All` is selected.
- Obtain separate owner authorization, a current Phase 4 baseline, three-client C1–C6 attestation, and a lifecycle activation decision before Codex Apply.

**Must-not**

- Never touch `config.toml`, `auth.json`, `history.jsonl`, `logs/`, `sessions/`, or `databases/`.
- Never install `agents/openai.yaml` metadata; explicit-only policy remains overlay-only until a separately reviewed seam.
- Never infer or normalize a missing Codex/skill root inside the adapter.
- Never write model, reasoning, MCP, or plugin configuration.
- Never bypass the `BringUp` lifecycle gate with an internal test resolver outside disposable CI.

## Destination inventory

| Logical root | Leaves |
| --- | --- |
| `codex-home` | marker-bounded `AGENTS.md`; guard-only `AGENTS.override.md`; seven `agents/*.toml` roles |
| `skill-root` | 23 thin `SKILL.md` wrappers: 22 canonical skills plus generated `pre-commit-ci-gate` |

The report uses root-qualified identities (`codex-home/...`, `skill-root/...`) so same-relative names cannot be confused across roots. Standalone managed leaves carry `cursorEscape-managed:v1`; the `AGENTS.md` block uses `cursorEscape-managed-block:v1`.

## Sync commands

```powershell
# Dry-run with explicit disposable roots (normative CI/test seam)
pwsh scripts/Sync-HostHarness.ps1 -Target Codex `
  -CodexRoot C:/temp/codex-home -SkillRoot C:/temp/skills

# Normative all-stack dry-run in disposable home fixtures
pwsh scripts/Sync-HostHarness.ps1 -Target All `
  -CodexRoot C:/temp/codex-home -SkillRoot C:/temp/skills

# Owner entry with effective roots on the eventual host
pwsh scripts/Sync-HostHarness.ps1 -Target Codex

# BringUp gate: zero selected-stack writes (re-arm with `ApplyState = BringUp`)
pwsh scripts/Sync-HostHarness.ps1 -Target All -Apply
```

There is no `-AllowSkew` exception for lifecycle refusal. Phase 4 will use a separate Codex-only bring-up authorization rather than an ordinary global Apply.

## Safety and verification

- Dry-run plans 31 writable destinations and reports 32 root-qualified identities including the override guard.
- Apply preflights ownership, hard excludes, override absence, path containment, current-state hashes, and marker integrity.
- Writes go through staged replacement; post-write hashes are verified. Adapter-local failure restores in-memory pre-Apply bytes and removes files created by the failed run.
- Fast CI: `scripts/host-sync/Invoke-CodexPhase3Checks.ps1` proves explicit-root Codex dry-run, all-stack dry-run, BringUp All-Apply refusal, Active-state Codex collision with zero selected-stack writes, and complete invalid-target output.
- Existing six-stack ledger parity remains the regression anchor for established planned renders; Codex is intentionally not in that ledger.

## Runtime acceptance (Phase 4)

C1–C6 runtime evidence is **not** inferred from registration or dry-run success. A future clean CLI, VS Code extension, and ChatGPT desktop session must attest plan gates, catalog behavior, isolated reviewer spawning, companion Read wiring, and end-to-end workflow behavior before `ApplyState` activation. See [host adaptation fidelity](../featureArchitecture/host-adaptation-fidelity.md).
