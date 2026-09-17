# cursorEscape

**Status:** shared-workflow-docs **Phase 6 complete**; [pointer-first](docs/roadmaps/pointer-first.md) **complete** (pointer-first-4, 2026-08-20). **Host harness sync** modular entry [`scripts/Sync-HostHarness.ps1`](scripts/Sync-HostHarness.ps1) — dry-run default; `-Apply` is Phase 6 only with explicit owner authorization per the [procedure registry Apply boundary](docs/featureArchitecture/procedure-registry.md#phase-6-apply-boundary); all seven stacks (Cursor, OpenCode, Antigravity, VS Code, Cline, Kilo Code, Codex) are registered, and the seventh `Codex` stack is activated `Active` for registration and harness CI ([layout](scripts/host-sync/README.md)). Sync does **not** create backups; Phase 0 baselines restore-only. Runtime smoke attestation is per-stack.

## What and why

**What:** cursorEscape is the owner's **skill and workflow manager** — a git home for personal agentic skills, agent roles, and gates (plan → implement → dual review → closeout), applied across **stacks** (Cursor, OpenCode, Antigravity, VS Code, Cline, Kilo Code, Codex)

**Why:** Keep workflows that work, evolve them in-repo, and escape Cursor lock-in without rewriting intent for each host. In-repo knowledge stays portable; behavior stays evaluable; backends stay **BYOK** and swappable. repo-root contracts (Approach A: [`workflow/`](workflow/_index.md), [`skills/`](skills/_index.md), [`agents/`](agents/_index.md), [`rules/`](rules/_index.md)) are **Target** SoT; the [procedure registry](docs/featureArchitecture/procedure-registry.md) owns machine metadata and semantic composition order. Host overlays (thin harness): [Cursor](overlays/cursor/_index.md), [OpenCode](overlays/opencode/_index.md), [Antigravity](overlays/antigravity/_index.md), [VS Code](overlays/vscode/_index.md), [Cline](overlays/cline/_index.md), [Kilo Code](overlays/kilocode/_index.md), [Codex](overlays/codex/_index.md). Live Apply: Phase 6 only with owner authorization. Load path: [pointer-first](docs/roadmaps/pointer-first.md). Stack variation: [skill source and host overlays](docs/featureArchitecture/skill-source-and-host-overlays.md).



**Start here:** **[docs/Roadmap.md](docs/Roadmap.md)** — vision, principles, status, and directory map. Initialization archaeology: [initialization report](review/initialization-report.md).

## Documentation hub

| Path | Purpose |
| ---- | ------- |
| [`workflow/`](workflow/_index.md) | Shared deep procedure (plan/review loops, discovery, CI ladder) |
| [`skills/`](skills/_index.md) | Host-agnostic workflow skill contracts |
| [`agents/`](agents/_index.md) | Host-agnostic agent role contracts |
| [`rules/`](rules/_index.md) | Always-on gate contracts |
| [`docs/Roadmap.md`](docs/Roadmap.md) | Vision, principles, status, and directory map |
| [`review/`](review/_index.md) | Project intent and [design decisions](review/design-decisions.md) |
| [`docs/featureArchitecture/`](docs/featureArchitecture/_index.md) | How the system is intended to work (Target) |
| [`overlays/`](overlays/_index.md) | Host-native overlays — sync via [`Sync-HostHarness.ps1`](scripts/Sync-HostHarness.ps1) |
| [`scripts/host-sync/`](scripts/host-sync/README.md) | Modular sync core, manifests, adapters, expansion recipe |
| [`research/`](research/_index.md) | Sourced facts and imported sibling research |
| [`docs/SOPs/`](docs/SOPs/_index.md) | Procedures for maintainers and future implementers |
| [`analysis/`](analysis/_index.md) | Operator studies ([host recreation](analysis/host-recreation-2026-08.md)) |
| [`docs/roadmaps/`](docs/roadmaps/_index.md) | Multi-phase handoff roadmaps (including [initialization](docs/roadmaps/cursorEscape-initialization.md)) |

**For agents editing this repo:** Before changing portable loops, gates, skills, agents, or overlays, read [editing companion workflow](docs/SOPs/editing-companion-workflow.md) (same-changeset cascade) and [skill source and host overlays](docs/featureArchitecture/skill-source-and-host-overlays.md).

## Repository layout

```text
cursorEscape/
  README.md
  workflow/ skills/ agents/ rules/
  scripts/Sync-HostHarness.ps1    # distribute overlay harness (dry-run default)
  scripts/host-sync/              # modular sync core + adapters
  docs/                           # FA, SOPs, roadmaps, Roadmap.md
  overlays/                       # registered host overlays, incl. codex/
  research/ review/ analysis/
```

Application runtime, adapters, packages, and eval runners are **out of scope** until an authorized implementation phase. Recreation uses external T3 + OpenCode.

## Related repositories

Sibling archives (local relative links; **no standing sync**):

| Sibling | Role |
| ------- | ---- |
| [openBuggy](../openBuggy/README.md) | Research/eval archive — not v0 bug_reviewer default |
| [AITestSuite](../AITestSuite/README.md) | Frozen plan/review eval packaging |

Longer map: [relationship to siblings](review/relationship-to-siblings.md).

## License / remote

Private-first. License and remote hosting remain TBD. See [design decisions](review/design-decisions.md).
