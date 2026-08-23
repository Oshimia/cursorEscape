# Standard Operating Procedures (SOPs)

**Last updated:** 2026-08-24

## Context

This index lists repeatable procedures for maintaining cursorEscape documentation and for operating the workflow **once a runtime exists**. Until then, runtime SOPs are conceptual targets.

**Path rule:** In-repo links use repo paths. External sibling projects (openBuggy, AITestSuite, live `~/.cursor`) may be cited in prose, imported under `research/imported/`, or recorded as host-native files under `overlays/` (thin wrappers) — do not copy their trees to repo-root `.cursor/`.

## Substance

### Documentation hygiene

* [Editing companion workflow](./editing-companion-workflow.md) — **agent entry:** where portable loop/gate edits land (Approach A + pointer-first cascade)
* [Documenting this repo](./documenting-this-repo.md) — how to add/update docs, indexes, and Last updated dates

### Host adapters

* [OpenCode host adapter](./opencode-host-adapter.md) — global `~/.config/opencode` inventory; [`Sync-HostHarness.ps1`](../../scripts/Sync-HostHarness.ps1); R0 smoke checklist
* [OpenCode smoke prompts](./opencode-smoke-prompts.md) — **copy-paste runbook** (C6 order); scorecard stays on host-adapter
* [Cursor host adapter](./cursor-host-adapter.md) — global `~/.cursor` inventory; [`Sync-HostHarness.ps1`](../../scripts/Sync-HostHarness.ps1); hybrid rules
* [Antigravity host adapter](./antigravity-host-adapter.md) — global `~/.gemini` inventory; GEMINI.md full-replace; skills/workflows/subagent defs; C1–C6 smoke rows deferred pre-Apply
* [Host harness sync README](../../scripts/host-sync/README.md) — modular layout, Phase 0 restore-only baselines, expansion recipe
* [Authoring OpenCode adapter files](./opencode-authoring-adapter.md) — how to write skills, agents, rules/instructions, and config (cites OpenCode docs; includes skill `name`/`description` requirements)

### Future runtime operations (conceptual)

*Additional runtime ops SOPs follow the implementation roadmap. Workflow contracts live under [agents](../../agents/_index.md) and [skills](../../skills/_index.md).*

## Implications / open questions

1. Extend this index when new SOP leaves land; never add a leaf without updating `_index.md` in the same change.
2. Observed vs Target labeling rules live in [documenting-this-repo.md](./documenting-this-repo.md).

## Related

* [Editing companion workflow](./editing-companion-workflow.md)
* [Roadmap](../Roadmap.md)
* [Design decisions](../../review/design-decisions.md)
* [Feature architecture index](../featureArchitecture/_index.md)
* [Overlays](../../overlays/_index.md)
* [Initialization roadmap](../roadmaps/cursorEscape-initialization.md)
