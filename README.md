# cursorEscape

**Status:** Active skill-and-workflow manager. **Host harness sync** modular entry [`scripts/Sync-HostHarness.ps1`](scripts/Sync-HostHarness.ps1) — dry-run default; live `-Apply` requires explicit owner authorization per the [procedure registry Apply boundary](docs/featureArchitecture/procedure-registry.md). All seven stacks (Cursor, OpenCode, Antigravity, VS Code, Cline, Kilo Code, Codex) are registered; the seventh `Codex` stack is activated `Active` for registration and harness CI ([layout](scripts/host-sync/README.md)). Sync does **not** create backups; registered baselines are restore-only. Runtime smoke attestation is per-stack.

## What and why

**What:** cursorEscape is the owner's **skill and workflow manager** — a git home for personal agentic skills, agent roles, and gates (plan → implement → dual review → closeout), applied across **stacks** (Cursor, OpenCode, Antigravity, VS Code, Cline, Kilo Code, Codex).

**Why:** Keep workflows that work, evolve them in-repo, and escape Cursor lock-in without rewriting intent for each host. In-repo knowledge stays portable; behavior stays evaluable; backends stay **BYOK** and swappable. Repo-root contracts (Approach A: [`workflow/`](workflow/_index.md), [`skills/`](skills/_index.md), [`agents/`](agents/_index.md), [`rules/`](rules/_index.md)) are **Target** SoT; the [procedure registry](docs/featureArchitecture/procedure-registry.md) owns machine metadata and semantic composition order. Host overlays (thin harness): [Cursor](overlays/cursor/_index.md), [OpenCode](overlays/opencode/_index.md), [Antigravity](overlays/antigravity/_index.md), [VS Code](overlays/vscode/_index.md), [Cline](overlays/cline/_index.md), [Kilo Code](overlays/kilocode/_index.md), [Codex](overlays/codex/_index.md). Load path is companion-first: read repo-root contracts directly. Stack variation: [skill source and host overlays](docs/featureArchitecture/skill-source-and-host-overlays.md).

**Start here:** [docs/featureArchitecture/_index.md](docs/featureArchitecture/_index.md) — how the system is intended to work (Target). Procedures and gates: [workflow/_index.md](workflow/_index.md). Machine metadata and Apply boundary: [procedure registry](docs/featureArchitecture/procedure-registry.md).

## Documentation hub

| Path | Purpose |
| ---- | ------- |
| [`workflow/`](workflow/_index.md) | Shared deep procedure (plan/review loops, discovery, CI ladder) |
| [`skills/`](skills/_index.md) | Host-agnostic workflow skill contracts |
| [`agents/`](agents/_index.md) | Host-agnostic agent role contracts |
| [`rules/`](rules/_index.md) | Always-on gate contracts |
| [`docs/featureArchitecture/`](docs/featureArchitecture/_index.md) | How the system is intended to work (Target) |
| [`docs/SOPs/`](docs/SOPs/_index.md) | Procedures for maintainers and future implementers |
| [`overlays/`](overlays/_index.md) | Host-native overlays — sync via [`Sync-HostHarness.ps1`](scripts/Sync-HostHarness.ps1) |
| [`scripts/host-sync/`](scripts/host-sync/README.md) | Modular sync core, manifests, adapters, expansion recipe |

## Normalization CI

| Gate | Entry point |
| ---- | ----------- |
| Fast | [`scripts/normalization/Invoke-NormalizationFastCI.ps1`](scripts/normalization/Invoke-NormalizationFastCI.ps1) |
| Full | [`scripts/normalization/Invoke-NormalizationFullCI.ps1`](scripts/normalization/Invoke-NormalizationFullCI.ps1) |

Exactly one Fast and one Full entry point exist; host-sync phase scripts are internal to Full CI.

**For agents editing this repo:** Before changing portable loops, gates, skills, agents, or overlays, read [editing companion workflow](docs/SOPs/editing-companion-workflow.md) (same-changeset cascade) and [skill source and host overlays](docs/featureArchitecture/skill-source-and-host-overlays.md).

## Repository layout

```text
cursorEscape/
  README.md
  workflow/ skills/ agents/ rules/
  scripts/Sync-HostHarness.ps1    # distribute overlay harness (dry-run default)
  scripts/host-sync/              # modular sync core + adapters
  docs/                           # feature architecture and SOPs
  overlays/                       # registered host overlays, incl. codex/
```

cursorEscape is not a hosted runtime or general IDE. Its current production surface is portable contracts plus registry-owned host harness sync across the seven registered stacks. Models and providers remain owner-controlled BYOK configuration; live Apply remains separately authorized.

## Related repositories

Sibling archives (local relative links; **no standing sync**):

| Sibling | Role |
| ------- | ---- |
| [openBuggy](../openBuggy/README.md) | Research/eval archive — not v0 bug_reviewer default |
| [AITestSuite](../AITestSuite/README.md) | Frozen plan/review eval packaging |

Durable boundary decisions: [project decisions and open questions](docs/featureArchitecture/project-decisions-and-open-questions.md).

## License / remote

Private-first. License and remote hosting remain TBD. See [project decisions](docs/featureArchitecture/project-decisions-and-open-questions.md).
