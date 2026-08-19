# Standard Operating Procedures (SOPs)

**Last updated:** 2026-08-20

## Context

This index lists repeatable procedures for maintaining cursorEscape documentation and for operating the workflow **once a runtime exists**. Until then, runtime SOPs are conceptual targets.

**Path rule:** In-repo links use repo paths. External sibling projects (openBuggy, AITestSuite, live `~/.cursor`) may be cited in prose, imported under `research/imported/`, or recorded as host-native files under `overlays/` (thin wrappers) — do not copy their trees to repo-root `.cursor/`.

## Substance

### Documentation hygiene

* [Documenting this repo](./documenting-this-repo.md) — how to add/update docs, indexes, and Last updated dates

### Host adapters

* [OpenCode host adapter](./opencode-host-adapter.md) — global `~/.config/opencode` inventory; sync rule; R0 smoke checklist
* [Authoring OpenCode adapter files](./opencode-authoring-adapter.md) — how to write skills, agents, rules/instructions, and config (cites OpenCode docs; includes skill `name`/`description` requirements)

### Future runtime operations (conceptual)

*Additional runtime ops SOPs follow the implementation roadmap. Workflow contracts live under [agents](../../agents/_index.md) and [skills](../../skills/_index.md).*

## Implications / open questions

1. Extend this index when new SOP leaves land; never add a leaf without updating `_index.md` in the same change.
2. Observed vs Target labeling rules live in [documenting-this-repo.md](./documenting-this-repo.md).

## Related

* [Roadmap](../Roadmap.md)
* [Design decisions](../../review/design-decisions.md)
* [Feature architecture index](../featureArchitecture/_index.md)
* [Overlays](../../overlays/_index.md)
* [Initialization roadmap](../roadmaps/cursorEscape-initialization.md)
