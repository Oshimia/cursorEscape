# cursorEscape

**Status:** shared-workflow-docs **Phase 6 complete**; OpenCode overlays SoT **Phase 3 live sync complete** (2026-08-20; Desktop runtime smoke deferred operator). Runtime not started. First recreation: **T3 Code + OpenCode**.

## What and why

**What:** cursorEscape is the owner's **skill and workflow manager** — a git home for personal agentic skills, agent roles, and gates (plan → implement → dual review → closeout), applied across **stacks** (Cursor, OpenCode; T3 as control plane). Analogous to Theo's T3 `fleet` repo ([Observed](research/theo-fleet-skill-management.md)), except this is **not** multi-machine sync.

**Why:** Keep workflows that work, evolve them in-repo, and escape Cursor lock-in without rewriting intent for each host. In-repo knowledge stays portable; behavior stays evaluable; backends stay **BYOK** and swappable. repo-root contracts (Approach A: [`workflow/`](workflow/_index.md), [`skills/`](skills/_index.md), [`agents/`](agents/_index.md), [`rules/`](rules/_index.md)) are **Target** SoT. Host overlays: [overlays/cursor](overlays/cursor/_index.md) (thin Cursor wrappers) and [overlays/opencode](overlays/opencode/_index.md) (OpenCode harness — **host-plugged copy-out authorized and applied** 2026-08-20; Desktop runtime smoke deferred operator). Live `~/.cursor` / `~/.config/opencode` remain operator installs. Stack variation: [skill source and host overlays](docs/featureArchitecture/skill-source-and-host-overlays.md).

**First host attempt:** [T3 Code](https://t3.codes/) (control plane) + [OpenCode](https://opencode.ai/) (harness); ClinePass **Desired** later; skill-based `bug_reviewer`. Study: [host recreation](analysis/host-recreation-2026-08.md).

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
| [`overlays/`](overlays/_index.md) | Host-native overlays — [Cursor](overlays/cursor/_index.md) thin wrappers; [OpenCode](overlays/opencode/_index.md) harness (copy-out applied 2026-08-20) |
| [`research/`](research/_index.md) | Sourced facts and imported sibling research |
| [`docs/SOPs/`](docs/SOPs/_index.md) | Procedures for maintainers and future implementers |
| [`analysis/`](analysis/_index.md) | Operator studies ([host recreation](analysis/host-recreation-2026-08.md)) |
| [`docs/roadmaps/`](docs/roadmaps/_index.md) | Multi-phase handoff roadmaps (including [initialization](docs/roadmaps/cursorEscape-initialization.md)) |

## Repository layout

```text
cursorEscape/
  README.md
  workflow/ skills/ agents/ rules/
  docs/                         # FA, SOPs, roadmaps, Roadmap.md
  overlays/cursor/              # thin Cursor wrappers
  overlays/opencode/            # OpenCode harness (copy-out applied 2026-08-20)
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
