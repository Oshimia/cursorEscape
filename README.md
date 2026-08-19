# cursorEscape

**Status:** Documentation foundation — initialization complete; runtime not started. First recreation: **T3 Code + OpenCode**.

## What and why

**What:** cursorEscape is the owner's **skill and workflow manager** — a git home for personal agentic skills, agent roles, and gates (plan → implement → dual review → closeout), applied across **stacks** (Cursor, OpenCode; T3 as control plane). Analogous to Theo's T3 `fleet` repo ([Observed](docs/research/theo-fleet-skill-management.md)), except this is **not** multi-machine sync.

**Why:** Keep workflows that work, evolve them in-repo, and escape Cursor lock-in without rewriting intent for each host. In-repo knowledge stays portable; behavior stays evaluable; backends stay **BYOK** and swappable. This repo is **Target** SoT for contracts; live `~/.cursor` is **Observed interim Cursor wording**. Stack variation: [skill source and host overlays](docs/featureArchitecture/skill-source-and-host-overlays.md).

**First host attempt:** [T3 Code](https://t3.codes/) (control plane) + [OpenCode](https://opencode.ai/) (harness); ClinePass **Desired** later; skill-based `bug_reviewer`. Study: [host recreation](docs/analysis/host-recreation-2026-08.md).

**Start here:** **[docs/Roadmap.md](docs/Roadmap.md)** — vision, principles, status, and directory map. Initialization archaeology: [initialization report](docs/review/initialization-report.md).

## Documentation hub

| Path | Purpose |
| ---- | ------- |
| [`docs/Roadmap.md`](docs/Roadmap.md) | Vision, principles, status, and directory map |
| [`docs/review/`](docs/review/_index.md) | Project intent and [design decisions](docs/review/design-decisions.md) |
| [`docs/featureArchitecture/`](docs/featureArchitecture/_index.md) | How the system is intended to work (Target) |
| [`docs/agents/`](docs/agents/_index.md) | Host-agnostic agent role contracts |
| [`docs/skills/`](docs/skills/_index.md) | Host-agnostic workflow skill contracts |
| [`docs/research/`](docs/research/_index.md) | Sourced facts and imported sibling research |
| [`docs/SOPs/`](docs/SOPs/_index.md) | Procedures for maintainers and future implementers |
| [`docs/analysis/`](docs/analysis/_index.md) | Operator studies ([host recreation](docs/analysis/host-recreation-2026-08.md)) |
| [`docs/roadmaps/`](docs/roadmaps/_index.md) | Multi-phase handoff roadmaps (including [initialization](docs/roadmaps/cursorEscape-initialization.md)) |

## Repository layout

```text
cursorEscape/
  README.md
  .gitignore
  docs/
    Roadmap.md
    review/
    featureArchitecture/
    agents/
    skills/
    research/
    SOPs/
    analysis/
    roadmaps/
```

Application runtime, adapters, packages, and eval runners are **out of scope** until an authorized implementation phase. Recreation uses external T3 + OpenCode.

## Related repositories

Sibling archives (local relative links; **no standing sync**):

| Sibling | Role |
| ------- | ---- |
| [openBuggy](../openBuggy/README.md) | Research/eval archive — not v0 bug_reviewer default |
| [AITestSuite](../AITestSuite/README.md) | Frozen plan/review eval packaging |

Longer map: [relationship to siblings](docs/review/relationship-to-siblings.md).

## License / remote

Private-first. License and remote hosting remain TBD. See [design decisions](docs/review/design-decisions.md).
