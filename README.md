# cursorEscape

**Status:** Documentation foundation — initialization complete; runtime not started.

## What and why

**What:** cursorEscape is an **open agentic workflow companion** — portable docs and (later) replaceable runtime for plan → implement → dual review → closeout on your repositories.

**Why:** Escape Cursor lock-in without losing what works: structured plan/review loops, in-repo knowledge, evaluable workflow behavior, and **BYOK** backends you can swap.

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
| [`docs/analysis/`](docs/analysis/_index.md) | Operator studies of local workflows |
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

Application runtime, adapters, packages, and eval runners are **out of scope** for the current initialization roadmap.

## License / remote

Private-first. License and remote hosting remain TBD. See [design decisions](docs/review/design-decisions.md).
