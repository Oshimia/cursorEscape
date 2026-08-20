# Roadmaps

**Last updated:** 2026-08-21

## Context

Multi-phase handoff roadmaps for cursorEscape. Each roadmap file carries **Agent context** blocks for phased execution.

## Substance

| Roadmap | Status | Purpose |
| ------- | ------ | ------- |
| [cursorEscape initialization](./cursorEscape-initialization.md) | **Complete** — initialization closeout ([initialization report](../../review/initialization-report.md)) | Bootstrap docs, import research, Target FA docs |
| [Implementation roadmap](./implementation-roadmap.md) | **Planning** — R0 T3+OpenCode live trial | External recreation first; optional later engine |
| [Centralize the workflow manager](./shared-workflow-docs.md) | **Complete** — Phases 1–6 | bases at repo root; thin Cursor overlay; `docs/` = this repo only |
| [OpenCode overlays SoT](./opencode-overlays-sot.md) | **Complete** (historical) — Phase 3 live sync 2026-08-20; **load path superseded** by [pointer-first](./pointer-first.md) | First OpenCode overlay + bulk copy-out (transitional) |
| [Companion pointer-first](./pointer-first.md) | **Complete** — pointer-first-4 closeout 2026-08-20 | Companion SoT; thin harness; procedure mirror deleted (OpenCode) |
| [Host harness sync build](./host-harness-sync-build.md) | **Complete** — Phase 3 docs + `Sync-HostHarness.ps1` operator surface | Modular sync core + Cursor/OpenCode adapters; Phase 0 baselines restore-only |

## Implications / open questions

1. Add new roadmaps to this index in the same change set as the roadmap file.
2. Conductor roadmaps are extend-only — do not delete prior phase checklists without explicit owner decision.

## Related

- [Roadmap](../Roadmap.md)
- [Design decisions](../../review/design-decisions.md)
- [Feature architecture index](../featureArchitecture/_index.md)
