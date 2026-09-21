# Host Overlay Extension Architecture — Composer Roadmap

**Status:** Active — Phase 3 complete; Phase 4 next
**Plan:** `.plans/host-overlay-extension-architecture.md` (APPROVED, 3 passes)
**Escalation:** yes (`user-labeled-composer`)
**Created:** 2026-09-21
**Runtime:** VSCode Codex extension

---

## Inter-phase contracts

| Contract | Detail |
|---|---|
| Shared extend-only | `analysis/procedure-normalization-inventory-2026-09.json` — each phase adds destinations; never removes existing entries |
| Shared extend-only | `scripts/host-sync/manifests/codex.manifest.psd1` — `DestinationEntries` list is extend-only within this plan |
| Shared extend-only | CI check assertion counts increase monotonically |
| Composition boundary | `catalog/workflows.json` `codex-cursor-escape-loop` rewritten in Phase 2 only |
| Adapter boundary | `Codex.Adapter.ps1` composition logic modified in Phase 2 only; Phase 3 adds JSON-native ownership-marker validation |
| Hook contract | `hooks.json` deploys to `~/.codex/hooks.json`; stateless `subagent_reminder.ps1` deploys to `~/.codex/hooks/`; trust via `/hooks`; no `config.toml` change |
| Documentation boundary | Model-level docs in Phase 1; implementation-level in Phase 5; no undocumented changes at closeout |
| Baseline | Phase 2 updates `scripts/host-sync/baselines/codex-manifest-schema-2026-09.json` if it pins destination counts |

---

## Phase checklist

- [x] **Phase 0** — Discovery (read-only code inspection; no commit) — COMPLETE
- [x] **Phase 1** — Extension architecture documentation (docs-only; Fast CI; commit) — COMMIT 86af3ff
- [x] **Phase 2** — Codex composition restructure — COMMIT 03a90b1 (15 files, dual APPROVED, Full CI green)
- [x] **Phase 3** — Codex hooks — COMPLETE (dual APPROVED, Full CI green)
- [ ] **Phase 4** — Cross-host extension directories (12 placeholders; Fast CI; commit)
- [ ] **Phase 5** — Documentation cascade + CI closeout (docs + CI; Fast + Full CI; dual review; commit)
- [ ] **Post-Apply** — Owner: sync Apply, restart Codex, trust hooks, C1-C6 smoke

---

## Agent context — Phase 0

- **Goal:** Capture all code-inspection findings needed to unblock Phases 1-3.
- **Depends on / entry gate:** Plan accepted by user.
- **Do not touch:** Any source file; strictly read-only.
- **In scope:** Read inventory schema, validator code, Codex adapter code, registry catalogs.
- **Out of scope:** Any writes to repo or live host state; no runtime experiments.
- **Files expected:** None (findings in report output).
- **Where to read context:** `.plans/host-overlay-extension-architecture.md`; `docs/featureArchitecture/procedure-registry.md`; `scripts/host-sync/adapters/Codex.Adapter.ps1`.
- **Fast CI:** N/A (read-only).
- **Full CI:** N/A.
- **Deliverables:**
  - [ ] Inventory hooks-kind compatibility determined
  - [ ] Composed block length measured
  - [ ] Evidence paths verified
  - [ ] Adapter multi-part composition feasibility confirmed
- **Risks:** Adapter may have unexpected hard-coded single-file assumptions.

## Agent context — Phase 1

- **Goal:** Document the extension architecture before any code changes.
- **Depends on / entry gate:** Phase 0 discovery complete.
- **Do not touch:** Source code, manifests, registry catalogs.
- **In scope:** Architecture docs only.
- **Out of scope:** Any code/config change.
- **Files expected:** 3-4 architecture docs.
- **Where to read context:** Phase 0 findings; `skill-source-and-host-overlays.md`; `instruction-layering.md`.
- **Fast CI:** `Invoke-NormalizationFastCI.ps1`.
- **Full CI:** N/A.
- **Deliverables:**
  - [ ] Extension model documented
  - [ ] Codex hand-authored framing removed from docs
- **Risks:** Documentation may drift from eventual implementation.

## Agent context — Phase 2

- **Goal:** Integrate Codex into the composition pipeline.
- **Depends on / entry gate:** Phase 1 committed; Phase 0 findings available.
- **Do not touch:** Other hosts' compositions; canonical rules; live host state.
- **In scope:** `catalog/workflows.json`, `Codex.Adapter.ps1`, Codex overlay, CI check scripts.
- **Out of scope:** Hook files (Phase 3); other host overlays.
- **Files expected:** 5-8 files.
- **Where to read context:** Plan Phase 2; `OpenCode.Adapter.ps1`; `procedure-registry.md`.
- **Fast CI:** `Invoke-NormalizationFastCI.ps1`.
- **Full CI:** `Invoke-NormalizationFullCI.ps1`.
- **Deliverables:**
  - [ ] Codex composition references canonical + footer
  - [ ] Adapter composes from parts
  - [ ] Footer contains cleanup rule
  - [ ] Old `agents-block.md` deprecated/removed
  - [ ] Seven-stack parity passes
- **Risks:** Composed block content differences; adapter edge cases with multi-part composition.

## Agent context — Phase 3

- **Goal:** Add the smallest Codex lifecycle hook that reminds the agent to close finished subagents no longer needed.
- **Depends on / entry gate:** Phase 2 dual APPROVED + committed.
- **Do not touch:** Composition; other hosts; live host state.
- **In scope:** Hook overlay files, manifest, inventory, CI check scripts, and the adapter's JSON-native ownership-marker validation only.
- **Out of scope:** Adapter composition changes; agent inventory/persistent state.
- **Files expected:** 5-7 files.
- **Where to read context:** Official Codex hooks docs; `codex.manifest.psd1` current state.
- **Fast CI:** `Invoke-NormalizationFastCI.ps1`.
- **Full CI:** N/A.
- **Deliverables:**
  - [x] `hooks.json` valid and parseable
  - [x] `subagent_reminder.ps1` passes PowerShell parser with zero errors
  - [x] Manifest/inventory/check counts updated
  - [x] Bounded stdin behavior covered by CI
- **Risks:** One continuation occurs on every first main-thread `Stop`; live hook trust remains a post-Apply owner step.

## Agent context — Phase 4

- **Goal:** Create extension directories for all hosts.
- **Depends on / entry gate:** Phase 3 dual APPROVED + committed.
- **Do not touch:** Existing content files; adapter logic.
- **In scope:** Empty directories + placeholder files across all host overlays.
- **Out of scope:** Any functional content in the new directories.
- **Files expected:** 12 placeholder files (Cursor rules/ already populated with .mdc rules).
- **Where to read context:** Phase 1 docs (extension model).
- **Fast CI:** `Invoke-NormalizationFastCI.ps1`.
- **Full CI:** N/A.
- **Deliverables:**
  - [ ] Exactly 7 rules/ + 7 hooks/ directories verified (12 new placeholders; Cursor rules/ pre-existing)
- **Risks:** Sync adapter may warn on unexpected directories; verify in dry-run.

## Agent context — Phase 5

- **Goal:** Final documentation cascade and CI closeout.
- **Depends on / entry gate:** Phase 4 dual APPROVED + committed.
- **Do not touch:** Canonical sources, registry catalogs, adapter code, manifests, live host state.
- **In scope:** Overlay index files, architecture docs, README, CI scripts.
- **Out of scope:** Code changes, registry changes, adapter changes, manifest changes.
- **Files expected:** 5-8 docs.
- **Where to read context:** All prior phases.
- **Fast CI:** `Invoke-NormalizationFastCI.ps1`.
- **Full CI:** `Invoke-NormalizationFullCI.ps1`.
- **Deliverables:**
  - [ ] All docs updated
  - [ ] Full CI green
  - [ ] All-stack dry-run success
- **Risks:** Documentation may miss an edge case discovered in earlier phases; final dry-run may reveal unplanned drift.

---

## Phase 0 findings (2026-09-21)

### 1. Inventory hooks-kind compatibility

Requires schema and validator extension. Current schema (`catalog/schema/v1.json`) supports only `agents`, `rules`, `skills`, `workflows`. `ProcedureRegistry.psm1` `ValidateSet` at line 817 and expected filename map at line 5 must be extended. Minimum fields: `id` + `source` (inventory) / `id` + `body` (catalog).

### 2. Composed block length

| Content | Characters |
|---|---:|
| Four canonical rule bodies (sum) | 5,645 |
| Current hand-authored `agents-block.md` | 4,480 |
| Delta | +1,165 (+26.0%) |

With renderer separators (`\r\n\r\n`): ~5,657. Acceptable per instruction-layering doc (no fixed budget; measure by gate behavior).

### 3. Evidence paths

All 48 evidence paths across 16 `alwaysOn` entries exist. No issues.

### 4. Adapter multi-part composition feasibility

**Key finding: No adapter code change is needed.** The shared renderer (`HostSync.Core.ps1`) already supports multi-part composition via `Parts`/`Source`/`Footer`. The Codex adapter requires exactly one overlay-local `Source`; the composition binding splits `references` into Parts (before Source) and Footer (after Source).

**Simplified Phase 2 approach:**
- Parts: 4 canonical rules via `base:` refs
- Source: `overlays/codex/footers/codex-wiring.md` (overlay-local, satisfies adapter restriction)
- Footer: none needed
- Remove `instructions/agents-block.md`
- Update manifest `Source` field to `footers/codex-wiring.md`
- Update composition references in `catalog/workflows.json`
- No `Codex.Adapter.ps1` modification required

This reduces Phase 2 scope from 5-8 files to ~4-5 files.
