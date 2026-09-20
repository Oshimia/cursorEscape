# Antigravity host adapter

**Last updated:** 2026-09-20

## Context

This SOP operates the Antigravity adapter. The companion repository is the Target SoT ([skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)); `~/.gemini/` is the host copy-out target, not a second procedure tree. Live sync is rendered from [overlays/antigravity](../../overlays/antigravity/_index.md) by [`Sync-HostHarness.ps1`](../../scripts/Sync-HostHarness.ps1).

The global rules surface, `~/.gemini/GEMINI.md`, is intentionally wholesale-replaced by the composed overlay gate. This also propagates the cursorEscape gates to Gemini CLI sessions; it is an accepted consequence of companion-first ownership.

**Install root:** `C:\Users\admin\.gemini\`
**Restore baseline:** registered in [`scripts/host-sync/baseline-backups.paths.json`](../../scripts/host-sync/baseline-backups.paths.json). Sync does not create backups.

## Substance

### Must / must-not

**Must:** meet [host adaptation fidelity](../featureArchitecture/host-adaptation-fidelity.md), keep all procedure bodies companion-resident, use exact native subagent tool names, and attest behavior after authorized Apply.

**Must-not:** mark the adapter complete from folder presence, paste deep procedure into wrapper bodies, ship skills without descriptions, or claim parallel-leg parity without runtime evidence.

### Layer map

| Layer | Portable contract | Antigravity adapter path |
| --- | --- | --- |
| Always-on | Thin gate composition | `GEMINI.md`, full replacement |
| Skills | [skills/](../../skills/_index.md) | `config/skills/<id>/SKILL.md`, auto-discovered |
| Workflows | Trajectory wrappers | `antigravity/global_workflows/escape-{plan,review,closeout}.md` |
| Agent routes | [agents/](../../agents/_index.md) | `config/agents/*.md`, spawned with `invoke_subagent` |

### Inventory

- **Skills (11):** `composer`, `diagnosing-bugs`, `discovery`, `documentation-architecture`, `implementation-plan`, `implementation-review`, `opencode-headless-run`, `opencode-history-search`, `plan-review`, `pre-commit-ci-gate`, and `roadmap`.
- **Workflows (3):** `/escape-plan`, `/escape-review`, and `/escape-closeout`.
- **Subagents (7):** `planner`, `repository_explorer`, `implementer`, `test_reviewer`, `production_readiness_reviewer`, `bug_reviewer`, and `plan_reviewer` routes governed by companion contracts.
- **Reviewers:** read-only tool allowlists using exact names `view_file`, `grep_search`, and `run_command`. `implementer` records canonical workspace-write authority.
- **Never synced or touched:** `antigravity/global_workflows/caveman.md`, credential/app-state files, and `config/projects`.

### Sync

```powershell
# Normative dry-run: all stacks.
pwsh ./scripts/Sync-HostHarness.ps1

# Normative live write: all stacks, with fresh explicit owner authorization.
pwsh ./scripts/Sync-HostHarness.ps1 -Apply

# Scoped dry-run inspection.
pwsh ./scripts/Sync-HostHarness.ps1 -Target Antigravity

# Scoped repair exception: requires fresh owner authorization and -AllowSkew.
pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target Antigravity -AllowSkew
```

Apply first verifies registered restore baselines and globally preflights selected stacks before any selected stack writes. Restart Antigravity after a config-time Apply.

### Verification

Run after authorized Apply and restart. Record `pass`, `fail`, or `deferred: reason` with the date and surface. No row may pass on file presence alone.

| Check | Method | Pass criterion | Result |
| --- | --- | --- | --- |
| C1 always-on gates | Clean chat with no tools | Injected gate quotes default-on plan review, when-in-doubt, and eval/harness non-exemption | Record |
| C2 skill catalog | Native skill listing and load | All eleven IDs are discoverable; `implementation-plan` loads without shell browsing | Record |
| C3 isolation and deny-edit | One parent launches both reviewer legs with `invoke_subagent` | Reviewers remain read-only; record either concurrent parity or the sequential fresh-context deviation | Record |
| C4 deep workflow Read | Load `implementation-review` | Native Read resolves companion `workflow/iterative-code-review.md` | Record |
| C5 companion access | Read a representative FA leaf | Companion read succeeds without repeated shell approval | Record |
| C6 operator loop | Run the preceding rows as one behavior suite | The loop completes from behavior evidence, not inventory | Record |

## Related

- [Antigravity overlay](../../overlays/antigravity/_index.md)
- [Host sync README](../../scripts/host-sync/README.md)
- [Host adaptation fidelity](../featureArchitecture/host-adaptation-fidelity.md)
- [Skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)
- [OpenCode host adapter](./opencode-host-adapter.md)
- [Editing companion workflow](./editing-companion-workflow.md)
