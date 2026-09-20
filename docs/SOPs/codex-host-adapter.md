# Codex host adapter SOP

**Last updated:** 2026-09-20
**Status:** `ApplyState = Active` (activated 2026-09-08 after owner-authorized install; three-client smoke attested 2026-09-08).

## Context

This SOP operates the Codex adapter. The companion repository owns portable procedure and contracts; the [Codex overlay](../../overlays/codex/_index.md) owns only thin wrappers, invocation policy, agent wiring, and managed-install mechanics.

The specialized adapter requires two explicit absolute roots. The operator entry resolves effective roots (`CODEX_HOME` or `~/.codex`, and `~/.agents/skills`) and passes them explicitly; the adapter never infers either root. Both roots must exist, be directories, have no reparse-point ancestor, and be independent and non-nested.

## Must / must-not

**Must**

- Use `Sync-HostHarness.ps1 -Target Codex` with explicit roots for disposable dry-runs.
- Keep `AGENTS.md` as marker-bounded managed block content and preserve foreign text outside the block.
- Treat `codex-home/AGENTS.override.md` as guard-only: a non-empty file must block Apply.
- Run the all-stack preflight before any Apply write pass when `Target All` is selected.
- Obtain fresh explicit owner authorization before every live Apply.
- For re-activation after setting `ApplyState = BringUp`, obtain separate owner authorization, a current baseline, and fresh three-client C1–C6 attestation.

**Must-not**

- Never touch `config.toml`, `auth.json`, `history.jsonl`, `logs/`, `sessions/`, or `databases/`.
- Never install `agents/openai.yaml` metadata; explicit-only policy remains overlay-only until a separately reviewed seam.
- Never infer or normalize a missing Codex or skill root inside the adapter.
- Never write model, reasoning, MCP, or plugin configuration.
- Never bypass the `BringUp` lifecycle gate with an internal test resolver outside disposable CI.

## Destination inventory

| Logical root | Leaves |
| --- | --- |
| `codex-home` | Marker-bounded `AGENTS.md`; guard-only `AGENTS.override.md`; seven `agents/*.toml` roles |
| `skill-root` | 23 thin `SKILL.md` wrappers: 22 canonical skills plus generated `pre-commit-ci-gate` |

Reports use root-qualified identities (`codex-home/...`, `skill-root/...`) so same-relative names cannot be confused across roots. Standalone managed leaves carry `cursorEscape-managed:v1`; the `AGENTS.md` block uses `cursorEscape-managed-block:v1`.

## Sync commands

```powershell
# Disposable Codex-only dry-run: normative CI/test seam.
pwsh scripts/Sync-HostHarness.ps1 -Target Codex `
  -CodexRoot C:/temp/codex-home -SkillRoot C:/temp/skills

# Disposable all-stack dry-run.
pwsh scripts/Sync-HostHarness.ps1 -Target All `
  -CodexRoot C:/temp/codex-home -SkillRoot C:/temp/skills

# Operator dry-run with effective roots.
pwsh scripts/Sync-HostHarness.ps1 -Target Codex

# Live write: normative all-stack Apply with fresh explicit owner authorization.
pwsh scripts/Sync-HostHarness.ps1 -Target All -Apply
```

If any selected stack is re-armed to `BringUp`, the lifecycle gate refuses All Apply before any selected-stack write. There is no `-AllowSkew` exception for lifecycle refusal. Reactivation from `BringUp` requires separate owner authorization, a current baseline, and fresh three-client C1–C6 attestation.

## Safety and verification

- Dry-run plans 31 writable destinations and reports 32 root-qualified identities including the override guard.
- Apply preflights ownership, hard excludes, override absence, path containment, current-state hashes, and marker integrity.
- Apply is a byte-level no-op for unchanged destinations; `AppliedFiles` reports only destinations actually written.
- Writes use staged replacement and post-write hash verification. Adapter-local failure restores in-memory pre-Apply bytes and removes files created by the failed run.
- Lifecycle CI: `scripts/host-sync/Invoke-CodexLifecycleChecks.ps1` proves explicit-root Codex dry-run, all-stack dry-run, `BringUp` All-Apply refusal, Active-state Codex collision with zero selected-stack writes, and complete invalid-target output.
- Committed render baselines and deterministic double-render comparison remain regression anchors for planned renders.

The 2026-09-08 activation baseline was attested across CLI, VS Code extension, and ChatGPT desktop for plan gates, catalog behavior, isolated reviewer spawning, companion Read wiring, and end-to-end workflow behavior. A future reactivation requires a fresh equivalent attestation.

## Related

- [Host harness sync README](../../scripts/host-sync/README.md)
- [Codex overlay](../../overlays/codex/_index.md)
- [Editing companion workflow](./editing-companion-workflow.md)
- [Host adaptation fidelity](../featureArchitecture/host-adaptation-fidelity.md)
- [Skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md)
- [SOPs index](./_index.md)
