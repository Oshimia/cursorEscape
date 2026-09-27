# Codex host adapter SOP

**Last updated:** 2026-09-27
**Status:** Active adapter; activated 2026-09-08 after owner-authorized install; three-client smoke attested 2026-09-08.

## Context

This SOP operates the Codex adapter. The companion repository owns portable procedure and contracts; the [Codex overlay](../../overlays/codex/_index.md) owns thin wrappers, invocation policy, agent wiring, the registry-composed managed-block footer, and source-only extension surfaces. Codex has no managed runtime hook; subagent cleanup is enforced by the always-on agent rule.

The specialized adapter requires two explicit absolute roots. The operator entry resolves effective roots (`CODEX_HOME` or `~/.codex`, and `~/.agents/skills`) and passes them explicitly; the adapter never infers either root. Both roots must exist, be directories, have no reparse-point ancestor, and be independent and non-nested.

## Must / must-not

**Must**

- Use `Sync-HostHarness.ps1 -Target Codex` with explicit roots for disposable dry-runs.
- Keep `AGENTS.md` as marker-bounded managed block content and preserve foreign text outside the block.
- Treat `codex-home/AGENTS.override.md` as guard-only: a non-empty file must block Apply.
- Run the all-stack preflight before any Apply write pass when `Target All` is selected.
- Obtain fresh explicit owner authorization before every live Apply.
- For any future machinery-changing reinstall, obtain fresh explicit owner authorization and fresh three-client C1–C6 attestation.

**Must-not**

- Never touch `config.toml`, `auth.json`, `history.jsonl`, `logs/`, `sessions/`, or `databases/`.
- Never install `agents/openai.yaml` metadata; explicit-only policy remains overlay-only until a separately reviewed seam.
- Never infer or normalize a missing Codex or skill root inside the adapter.
- Never write model, reasoning, MCP, or plugin configuration.
- Never weaken ownership, managed-block, explicit-root, or global-preflight controls in disposable CI.

## Destination inventory

| Logical root | Leaves |
| --- | --- |
| `codex-home` | Marker-bounded `AGENTS.md`; guard-only `AGENTS.override.md`; seven `agents/*.toml` roles |
| `skill-root` | 23 thin `SKILL.md` wrappers: 22 canonical skills plus generated `pre-commit-ci-gate` |

Reports use root-qualified identities (`codex-home/...`, `skill-root/...`) so same-relative names cannot be confused across roots. Standalone managed leaves carry `cursorEscape-managed:v1`; the `AGENTS.md` block uses `cursorEscape-managed-block:v1`; JSON leaves use equivalent `_ownershipMarker` and `_ownershipSource` fields.

The separate `overlays/codex/rules/` extension surface contains only `_index.md` structural reserve capacity. It is not a manifest destination and must not be treated as Codex load behavior.

The separate `overlays/codex/hooks/` extension surface is also placeholder-only. It preserves host-specific capacity but is not a manifest destination and installs no runtime hook.

Repository retirement is contract-only: Apply plans and writes manifest destinations; it does not prune unplanned legacy files. If a Codex home still contains retired `hooks.json` or `subagent_reminder.ps1`, remove those exact live artifacts separately under explicit owner authorization.

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

Apply is globally preflighted: if any selected stack fails dry-run preflight, no selected stack is written. All live Apply requires fresh explicit owner authorization.

## Safety and verification

- Dry-run plans 31 writable destinations and reports 32 root-qualified identities including the override guard.
- Apply preflights ownership, hard excludes, override absence, path containment, current-state hashes, and marker integrity.
- Apply is a byte-level no-op for unchanged destinations; `AppliedFiles` reports only destinations actually written.
- Writes use staged replacement and post-write hash verification. Adapter-local failure restores in-memory pre-Apply bytes and removes files created by the failed run.
- Lifecycle CI: `scripts/host-sync/Invoke-CodexLifecycleChecks.ps1` proves explicit-root Codex dry-run, all-stack dry-run, disposable Codex Apply, collision with zero selected-stack writes, and complete invalid-target output.
- Committed render baselines and deterministic double-render comparison remain regression anchors for planned renders.

The 2026-09-08 activation baseline was attested across CLI, VS Code extension, and ChatGPT desktop for plan gates, catalog behavior, isolated reviewer spawning, companion Read wiring, and end-to-end workflow behavior. A future machinery-changing reinstall requires a fresh equivalent attestation.

## Related

- [Host harness sync README](../../scripts/host-sync/README.md)
- [Codex overlay](../../overlays/codex/_index.md)
- [Editing companion workflow](./editing-companion-workflow.md)
- [Host adaptation fidelity](../featureArchitecture/host-adaptation-fidelity.md)
- [Skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md)
- [SOPs index](./_index.md)
