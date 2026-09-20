# OpenCode host adapter

**Last updated:** 2026-09-20

## Context

This SOP operates the global OpenCode adapter. The companion repository is the Target SoT for procedures, skills, agents, and rules ([skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)). `~/.config/opencode/` is a host adapter, not a second procedure tree. Live sync is rendered from [overlays/opencode](../../overlays/opencode/_index.md) by [`Sync-HostHarness.ps1`](../../scripts/Sync-HostHarness.ps1).

**Install root:** `C:\Users\admin\.config\opencode\`
**Restore baseline:** registered in [`scripts/host-sync/baseline-backups.paths.json`](../../scripts/host-sync/baseline-backups.paths.json). Sync does not create backups.

## Substance

### Must / must-not

**Must:** meet [host adaptation fidelity](../featureArchitecture/host-adaptation-fidelity.md), use companion reads for deep procedure, keep always-on gates thin, and prove runtime behavior with smoke rather than folder presence.

**Must-not:** mark the adapter complete from inventory alone; deploy Cursor's rules tree directly; ship skills without required frontmatter; allow reviewers to edit; or recreate a host `docs/workflow/` mirror.

### Layer map

| Layer | Portable contract | OpenCode adapter path |
| --- | --- | --- |
| Always-on | Gate pointers only | `instructions/cursor-escape-loop.md`, wired through an absolute `OPENCODE_HOME` path, plus byte-identical `AGENTS.md` |
| Skills | [skills/](../../skills/_index.md) | `skills/*/SKILL.md` points to companion `skills/` and `workflow/` |
| Deep workflows | [workflow/](../../workflow/_index.md) | Absolute companion Read; no host mirror |
| Role agents | [agents/](../../agents/_index.md) | `agents/*.md`; reviewers deny edit |

### Inventory

**Always-on**

- `instructions/cursor-escape-loop.md` — default-on plan review, pressure-release review loop, when-in-doubt rule, eval/harness non-exemption, and empty-Task fail-loud rule.
- `AGENTS.md` — same body as the instruction leaf for reliable C1 behavior.
- `opencode.json` — absolute instruction path, skill registration, permission map, and agent task allowlists.

**Skills**

- `composer`
- `diagnosing-bugs`
- `discovery`
- `documentation-architecture`
- `implementation-plan`
- `implementation-review`
- `opencode-headless-run`
- `opencode-history-search`
- `plan-review`
- `pre-commit-ci-gate`
- `roadmap`

**Agents**

- `planner`
- `plan_reviewer`
- `implementer`
- `production_readiness_reviewer`
- `bug_reviewer`
- `repository_explorer`
- `test_reviewer`
- `composer_conductor`

Reviewers deny edit. `bug_reviewer` reads the companion [finding rubric](../featureArchitecture/bug-reviewer-finding-rubric.md). `composer_conductor` denies wildcard tasks before named workflow allows.

### Sync

```powershell
# Normative dry-run: all stacks.
pwsh ./scripts/Sync-HostHarness.ps1

# Normative live write: all stacks, with fresh explicit owner authorization.
pwsh ./scripts/Sync-HostHarness.ps1 -Apply

# Scoped dry-run inspection.
pwsh ./scripts/Sync-HostHarness.ps1 -Target OpenCode

# Scoped repair exception: requires fresh owner authorization and -AllowSkew.
pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target OpenCode -AllowSkew
```

Apply first verifies registered restore baselines, globally preflights selected stacks, then renders and writes the manifest-owned thin harness. It merges companion and OpenCode home tokens, preserves live model/provider settings, dual-writes C1 surfaces, and never recreates a procedure mirror. Fully quit and restart OpenCode after changing config-time surfaces.

Author in the companion repository first. Use [opencode-authoring-adapter](./opencode-authoring-adapter.md) for OpenCode-specific file requirements. Manual copy into live paths is forbidden because it bypasses token merge, JSON merge, and consistency gates.

### Dual review

Use one OpenCode session with two child Tasks: `production_readiness_reviewer` and `bug_reviewer`. The parent owns Fast CI; reviewers deny edit. The split envelope uses the locked opener for production readiness and Custom Instructions for the bug reviewer. Sequential fallback is acceptable only when the host refuses parallel Tasks and the fallback is recorded.

## Smoke checklist

Run prompts from [opencode-smoke-prompts](./opencode-smoke-prompts.md). Record `pass`, `fail`, or `deferred: reason` with the date and execution surface. C6 minimum order: **1 → 9+10 → 4 → 8 → 13 → 2 → 3**.

| # | Check | Pass criterion | Result |
| --- | --- | --- | --- |
| 1 | Always-on gates | Quotes default-on plan review, when-in-doubt, and eval/harness non-exemption from session instructions with zero tool calls | Record |
| 2 | Reviewer deny-edit | Write is denied or ask-blocked; no file changes | Record |
| 3 | Dual Task shape | Two child sessions start, or sequential fallback invokes both roles | Record |
| 4 | Companion workflow Read | `implementation-review` reaches companion `workflow/iterative-code-review.md`, not a host mirror | Record |
| 5 | Config parses | OpenCode starts without schema/config errors | Record |
| 6 | Empty-Task fail-loud | Empty reviewer result is treated as routing/auth failure until a model stream is proven | Record |
| 7 | Single-owner escalation | Escalation guidance comes from companion `implementation-plan`, not a competing adapter table | Record |
| 8 | Bug-review rubric | Companion FA rubric path resolves through native Read | Record |
| 9 | Skill catalog | All 11 governed OpenCode skills are advertised | Record |
| 10 | SoT skill load | `implementation-plan` loads through thin harness and companion Read without bash | Record |
| 11 | Native file tools | Optional: short read/glob/grep work without bash approvals | Record |
| 12 | Glob-blind paths | Optional: registered paths or narrow ignores avoid broad bash fallbacks | Record |
| 13 | Thin-plan rejection | Missing Assumptions/Unknowns yields `CHANGES REQUESTED` from `plan_reviewer` | Record |
| 14 | Specimen/live map | Live agent keys match specimen; 11 skills and 8 agents; no workflow mirror | Record |
| 15 | Conductor visible | `composer_conductor` is selectable and its wildcard deny precedes named allows | Record |
| 16 | Iteration auto-continue | Review pressure-release reaches a later iteration without operator continue prompts | Record |
| 17 | Nested-session audit | Read-only DB queries show a real parent→child chain and model streams | Record |
| 18 | Headless fallback | Single-line CLI invocation reads a native-write brief and captures the verdict | Record |

Verify rows 15 and 18 in fresh CLI processes after sync. Defer Desktop-nested rows 16–17 only to the next quiescent restart window and record the reason.

## Restore

1. Fully quit OpenCode.
2. Restore only from the registered baseline identified by [`baseline-backups.paths.json`](../../scripts/host-sync/baseline-backups.paths.json).
3. Restart and run the focused smoke rows for the changed surfaces.

## Related

- [Host adaptation fidelity](../featureArchitecture/host-adaptation-fidelity.md)
- [Skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)
- [Authoring OpenCode adapter files](./opencode-authoring-adapter.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md)
- [Bug reviewer finding rubric](../featureArchitecture/bug-reviewer-finding-rubric.md)
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
- [Agent contracts](../../agents/_index.md)
- [Skill contracts](../../skills/_index.md)
- [Host harness sync README](../../scripts/host-sync/README.md)
- [OpenCode overlay](../../overlays/opencode/_index.md)
