# Roadmaps

**Last updated:** 2026-09-01 (kilo-cline additions)

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
| [mattpocock skills audit](./mattpocock-skills-audit.md) | **Phase 0 complete** — map authored 2026-08-21; next: P1 assessment sweep | Full-sweep audit of mattpocock/skills + merge of relevant skills; map under [research/mattpocock-skill-audit](../research/mattpocock-skill-audit/_index.md) |
| [Overlay architecture remediation](./overlay-remediation.md) | **COMPLETE** (Phases 0–4; Phase 4 executed 2026-08-31 owner-delegated: drift survey → global Apply → live==planned verified, Apply-leg parity defect fixed) | Fix overlay architecture: overlays carry only host differences (per-entry v2 sourcing, promote-into-twin gate composition, golden-render regression surface, CI drift fixes) |
| [VS Code bring-up](./vscode-bring-up.md) | **Phases 0–3 complete** 2026-09-01; Phase 4 (Apply + C1–C6 smoke) pending operator authorization | 4th sync stack: `~/.copilot` user-level surface (instructions/agents/skills); closes parked vscode overlay item from overlay-remediation |
| [Kilo + Cline bring-up](./kilo-cline-bring-up.md) | **Phases 0–4a complete** 2026-09-01; Phase 4b (2 applies + smoke) pending operator authorization | 5th/6th stacks (`~/.cline`, `~/.kilocode`) + shared Generic adapter conversion (clone pattern retired) |

## Implications / open questions

1. Add new roadmaps to this index in the same change set as the roadmap file.
2. Conductor roadmaps are extend-only — do not delete prior phase checklists without explicit owner decision.

## Related

- [Roadmap](../Roadmap.md)
- [Design decisions](../../review/design-decisions.md)
- [Feature architecture index](../featureArchitecture/_index.md)
