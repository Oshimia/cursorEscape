# Cursor host adapter

**Last updated:** 2026-09-20

## Context

This SOP operates the global Cursor adapter. The companion repository is the Target SoT for skills, agents, workflows, and rules ([skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)). `~/.cursor/` is a host adapter, not a second procedure tree.

**Install root:** `C:\Users\admin\.cursor\`
**Companion root:** `C:\Users\admin\source\repos\general-projects\cursorEscape`
**Restore baseline:** registered in [`scripts/host-sync/baseline-backups.paths.json`](../../scripts/host-sync/baseline-backups.paths.json). Sync does not create backups.

## Substance

### Must / must-not

**Must:** meet the [host adaptation fidelity](../featureArchitecture/host-adaptation-fidelity.md) behavior bar; use hybrid rules with injectable gate bodies; cite absolute companion paths; and prove C1/C2 behavior after restart.

**Must-not:** use relative file-depth hops in harness leaves; treat a host `docs/workflow/` mirror as procedure SoT; mark the adapter complete from inventory alone; or replace live rules with thin-pointer-only `.mdc` files.

### Layer map

| Layer | Portable contract | Cursor adapter path |
| --- | --- | --- |
| Always-on | Gate semantics in portable `rules/` | Hybrid `rules/*.mdc`: overlay frontmatter + companion gate body + spawn pointers; optional User Rules snippets |
| Skills | [skills/](../../skills/_index.md) | Thin `SKILL.md` stubs and User Rules snippets under `skills/<id>/` |
| Deep workflows | [workflow/](../../workflow/_index.md) | Absolute companion Read |
| Role agents | [agents/](../../agents/_index.md) | Thin `agents/*.md` spawn routes |
| Model hints | Overlay leaf only | `review-subagent-models.md` |

### Inventory

**Skills:** `implementation-plan`, `implementation-review`, `composer`, `roadmap`, `documentation-architecture`, `opencode-headless-run`, and `opencode-history-search`; each skill directory may also carry a User Rules snippet.

**Discovery paths by design:** `discovery` and `plan-review` remain companion workflow or skill reads rather than duplicate Cursor wrappers. `pre-commit-ci-gate` is represented by the hybrid rule.

**Agents:** `planner`, `plan-reviewer`, `reviewer-a`, `repository_explorer`, `implementer`, and `test_reviewer`.

**Hybrid rules:** `agent-invocation`, `iterative-plan-review`, `iterative-code-review`, and `pre-commit-ci-gate`.

`settings.json`, `skills-cursor/`, and `docs/workflow/` are excluded or never touched by the manifest. The live host has no procedure mirror.

### Sync

```powershell
# Normative dry-run: all stacks.
pwsh ./scripts/Sync-HostHarness.ps1

# Normative live write: all stacks, with fresh explicit owner authorization.
pwsh ./scripts/Sync-HostHarness.ps1 -Apply

# Scoped dry-run inspection.
pwsh ./scripts/Sync-HostHarness.ps1 -Target Cursor

# Scoped repair exception: requires fresh owner authorization and -AllowSkew.
pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target Cursor -AllowSkew
```

Apply first verifies registered restore baselines, globally preflights selected stacks, then copies the manifest-owned thin harness, merges `{{COMPANION_ROOT}}` to the absolute companion path, and renders hybrid rules from registry-owned compositions. It does not copy a procedure mirror. Fully quit and restart Cursor before runtime verification.

### Verification

Run after authorized Apply and a full restart. Record `pass`, `fail`, or `deferred: reason` with date and surface.

| Check | Method | Pass criterion | Result |
| --- | --- | --- | --- |
| C1 hybrid gates | Clean chat with no tools | Injected rules quote default-on plan review, when-in-doubt, pressure-release limit, and eval/harness non-exemption | Record |
| C2 companion reachability | Load `implementation-review` | Read resolves under companion `skills/` or `workflow/`, not the host adapter | Record |
| Different workspace | Optional: open an unrelated folder | Skill Read still resolves the absolute companion path | Record |
| User Rules integration | Install snippets from synced skill directories | Rules appear in Cursor settings and do not duplicate full procedure bodies | Record |
| Wrong-base hop audit | Search synced harness for `../../../../` | Zero matches | Record |
| Restore readiness | Confirm the registered baseline exists | Baseline and restore instructions are discoverable | Record |

Routine post-push hash checks are forbidden; built-in sync checks are authoritative. Smoke belongs to first-time surfaces and machinery changes.

## Restore

1. Fully quit Cursor.
2. Restore only from the registered baseline identified by [`baseline-backups.paths.json`](../../scripts/host-sync/baseline-backups.paths.json).
3. Restart and run the focused verification rows for the changed surfaces.

## Related

- [Host harness sync README](../../scripts/host-sync/README.md)
- [Cursor overlay copy-out map](../../overlays/cursor/_index.md)
- [Editing companion workflow](./editing-companion-workflow.md)
- [OpenCode host adapter](./opencode-host-adapter.md)
- [Host adaptation fidelity](../featureArchitecture/host-adaptation-fidelity.md)
