# Roadmap: Host harness sync build (modular Cursor + OpenCode)

**Last updated:** 2026-08-21  
**Status:** **Active** — Phase 1 QC ACCEPT (`198b02c`); Phase 2 next.  
**Plan source:** accepted plan `host_harness_sync_build_a0d9438d` (Host harness sync build), **amended** by operator 2026-08-21 (no per-sync backups).  
**Program id:** `host-harness-sync` (phases **0 … 3**).  
**Companion HEAD at roadmap create:** `fbd4724`.

## Product decisions (locked)

- Operators (and later agents when explicitly authorized) run one companion-repo script to **distribute** overlay harness to live stacks.
- Implementation is **modular**: shared sync core + one **stack adapter** per host + a **manifest** that owns allowlists/excludes/tokens.
- v1 stacks: Cursor (thin token-merged skills/agents + **hybrid** rules) and OpenCode (thin token-merged skills/agents + **AGENTS ≡ instructions** + specimen→`opencode.json` merge).
- Deep procedure stays companion SoT via absolute `COMPANION_ROOT` Reads — no procedure-mirror reintroduction.
- **Approach A** (modular plugin layout) chosen over monolithic or duplicated top-level scripts.
- Dry-run default + explicit `-Apply`; plan targets **`pwsh` 7+** only.
- Phase 0 baseline backups were a **one-time** safety net while building the sync tool (restore if Apply testing breaks live hosts).
- **Amended 2026-08-21:** `Sync-HostHarness` **does not create backups** on sync/Apply (no per-Apply / per-sync backup). After the sync tool ships, **this companion repo is SoT** and ongoing backups are **not** part of the sync workflow.

## Inter-phase contracts

- Phase 0 gate via `baseline-backups.paths.json` before any Apply (existing baselines must be present for Apply testing restore; Core **does not** write new backup trees).
- Phase 0 dual APPROVED = Fast CI + inventory-diff Full CI (no live mutation).
- **No PerApply backup kind** in Core/adapters (plan PerApply rows superseded).
- Allowlists only in manifests; Core helpers include `Assert-BaselineBackupsPresent` (read-only check of Phase 0 paths file + dirs).
- Layout under `scripts/host-sync/` + entry `scripts/Sync-HostHarness.ps1` locked in plan.
- Adapter entry signature: `Invoke-StackHarnessSync` with `Mode` DryRun|Apply, `CompanionRoot`, `Manifest` — **no** `SkipBackup` (nothing to skip).
- **`-Target All`:** continue-with-report default; optional `-FailFast`; exit non-zero if any failed.
- OpenCode: `review-subagent-models` pointer-only (not distributed as a host copy-out of deep procedure).

### Backup naming (locked — Phase 0 only)

| Kind | Folder pattern | Lifetime |
| ---- | -------------- | -------- |
| **Baseline** (Phase 0 only) | `…/.cursor-backup-pre-host-sync-build-<stamp>/` and `…/opencode-backup-pre-host-sync-build-<stamp>/` | Keep for program restore while testing Apply; **never** created by sync Apply |
| ~~Per-Apply~~ | ~~`…-host-sync-apply-<stamp>/`~~ | **Superseded** — not implemented |

**Restore precedence (locked):** Phase 0 baseline `pre-host-sync-build` → legacy (`pre-pointer-sync`, `opencode-backup-20260820-*`, `qc-bugbot-ui-*`) archaeology only.

**Phase 0 gate artifact (locked):** `scripts/host-sync/baseline-backups.paths.json` paths-only schema: `{ "cursor": "<abs>", "opencode": "<abs>", "companionSha": "<short>", "created": "<iso8601>" }`. `-Apply` exits non-zero if missing/invalid **or** either path directory missing. Dry-run skips gate. Gate does **not** imply Core creates backups.

### Hard excludes

| Stack | Never |
| ----- | ----- |
| Cursor | `skills-cursor/`; `settings.json`; delete/refresh `docs/workflow/`; thin-only `.mdc` |
| OpenCode | Procedure mirror re-copy; `review-subagent-models` host copy-out; overwrite `model`/`provider` |

## Migration / external apply order

0. Phase 0 baseline backups + paths file (**done** 2026-08-21)
1. Dry-run Phases 1–2
2. `-Apply -Target Cursor` → write → verify → **user restarts Cursor** → smoke (restore from Phase 0 baseline if broken)
3. `-Apply -Target OpenCode` → write → verify → **user restarts OpenCode** → smoke
4. Or `-Target All` (sequential; continue-with-report default; optional `-FailFast`; restart each host after its Apply before smoke)

**Owner:** agent runs `-Apply` only when user authorizes; user owns host restart + optional smoke. Sync never writes backup trees.

## Phase checklist

- [x] **Phase 0** — Baseline live harness backups + `baseline-backups.paths.json` (QC ACCEPT 2026-08-21, `f5f1661`)
- [x] **Phase 1** — Core + contract + Cursor adapter (**no** per-sync backup) (`198b02c`)
- [ ] **Phase 2** — OpenCode adapter
- [ ] **Phase 3** — Entry polish + docs (document: companion SoT; Phase 0 baselines for restore-only; sync does not backup)

## Agent context — Phase 0

- **Goal:** Create and attest harness-only baseline backups for both live stacks; write gate artifact; do not change live files.
- **Depends on / entry gate:** Plan accepted; operator authorizes live harness copy — **DONE**.
- **Do not touch:** Live harness (read/copy only); `skills-cursor/`; Cursor `settings.json`; companion beyond paths file + short attestation.
- **In scope:** Cursor `…-backup-pre-host-sync-build-<stamp>/`; OpenCode `…/opencode-backup-pre-host-sync-build-<stamp>/`; `BACKUP_MANIFEST.md` `Kind: Baseline`; `baseline-backups.paths.json`.
- **Out of scope:** Sync adapters; deleting legacy backups; per-Apply backup tooling.
- **Deliverables:**
  - [x] Cursor baseline backup + `Kind: Baseline` manifest — `C:\Users\admin\.cursor-backup-pre-host-sync-build-20260821-012600`
  - [x] OpenCode baseline backup + `Kind: Baseline` manifest — `C:\Users\admin\.config\opencode-backup-pre-host-sync-build-20260821-012600`
  - [x] `baseline-backups.paths.json` attested
  - [x] Phase 0 dual APPROVED (inventory-diff Full CI); Bugbot leg via Task UI “found no bugs” (Gate B zero-findings evidence)

**Ships:** Restorable baseline for Apply testing.

## Agent context — Phase 1

- **Goal:** Land modular core, contract, registry, cursor manifest, Cursor adapter (dry-run + apply). **Do not implement backup-on-sync.**
- **Depends on / entry gate:** Phase 0 dual APPROVED; `pwsh` discovery; Cursor allowlist discovery.
- **Do not touch:** OpenCode adapter body beyond stub; Cursor `skills-cursor`, `settings.json`, `docs/workflow` delete/refresh; thin-only rules; **do not invoke** `Write-HybridCursorRules.ps1` during DryRun (plan hybrid outputs in `PlannedFiles` only); overwrite Phase 0 baseline backups; mutate paths file except operator-approved Phase 0 fixes; **do not create** `host-sync-apply` backup trees.
- **In scope:** Core/Contract/`Register-StackAdapters.ps1`; cursor.manifest; Cursor.Adapter; entry `-Target Cursor`; `Assert-BaselineBackupsPresent` on Apply (read-only gate); token merge; copy; verify; report. No backup helpers that write new trees on Apply.
- **Out of scope:** OpenCode adapter; full SOP rewrite; per-Apply backups; `-SkipBackup` parameter.
- **Files expected:** `scripts/host-sync/*` as layout; entry stub; Core gate helper (assert only).
- **Where to read context:** cursor-host-adapter; overlays/cursor/_index; Write-HybridCursorRules.ps1; baseline-backups.paths.json; this roadmap (backup amendment).
- **Fast CI:** dry-run Cursor exits 0; no live writes; Apply without paths file → non-zero; Apply does **not** create sibling `*-host-sync-apply-*` dirs.
- **Full CI:** optional authorized Apply; token grep 0; hybrid pressure-release; smoke rows 1–2,5; failure → restore Phase 0 baseline (manual/operator).
- **Deliverables:** Core+registry+gate; Cursor manifest+adapter; dry-run/Apply/verify; gate test; **no** per-sync backup.
- **Risks:** Stack if/else in Core; DryRun hybrid write; reintroducing PerApply backup from old plan text.

**Ships:** Modular foundation + Cursor distribute (companion SoT → live, no backup step).

## Agent context — Phase 2

- **Goal:** OpenCode adapter + manifest in same registry; Core only gains shared primitives if needed.
- **Depends on / entry gate:** Phase 1 dual APPROVED; Phase 0 OpenCode baseline backup available (restore only).
- **Do not touch:** Cursor adapter behavior; procedure mirror; archived rewriter as primary; wipe model/provider; Phase 0 baseline backups; backup-on-sync.
- **In scope:** opencode.manifest; OpenCode.Adapter; registry; array-aware specimen merge; AGENTS dual-write + hash; verifies.
- **Out of scope:** Portable↔overlay agent re-diff automation; third stack; per-Apply backups.
- **Files expected:** OpenCode manifest + adapter; Merge-HashtablePreserve + adapter array rules.
- **Where to read context:** opencode-host-adapter; overlays/opencode/_index; specimen JSON.
- **Fast CI:** dry-run OpenCode and All exit 0.
- **Full CI:** authorized Apply; post-verify; C6 smoke footer; failure → Phase 0 baseline restore.
- **Deliverables:** OpenCode adapter+manifest; JSON merge preserve model/provider; AGENTS ≡ instructions.
- **Risks:** Relative instructions path; OpenCode-only logic leaking into Core.

**Ships:** Second adapter proving expansion.

## Agent context — Phase 3

- **Goal:** Document modular layout, expansion recipe, Phase 0 baselines as restore-only, **sync does not backup**, companion SoT; wire **both** `docs/SOPs/cursor-host-adapter.md` and `docs/SOPs/opencode-host-adapter.md` plus editing-companion-workflow to `Sync-HostHarness.ps1`.
- **Depends on / entry gate:** Phase 2 dual APPROVED.
- **Do not touch:** Live hosts except documented Apply examples.
- **In scope:** Entry help; Phase 0 baseline restore + sync-script rows in **cursor-host-adapter** and **opencode-host-adapter** (no fictional hub doc); editing-companion-workflow flip Cursor to `Sync-HostHarness.ps1 -Apply` (operator-gated); overlay `_index` files; README; expansion recipe; restore precedence **without** PerApply.
- **Out of scope:** Implementing Foo; User Rules paste automation; documenting per-sync backup as required.
- **Files expected:** both host-adapter SOPs; editing-companion-workflow; overlay indexes; README; entry finalize.
- **Where to read context:** `editing-companion-workflow.md`; `cursor-host-adapter.md`; `opencode-host-adapter.md`; `skill-source-and-host-overlays.md`.
- **Fast CI:** `-Target All` dry-run; help lists registry stacks.
- **Full CI:** doc links; excludes in help; editing-companion-workflow Cursor row matches script; both host-adapter SOPs cite the script + Phase 0 baseline paths as restore-only; docs state sync does not backup.
- **Deliverables:**
  - [ ] Docs + expansion recipe
  - [ ] Registry-driven targets
  - [ ] Cursor auth flip + both host-adapter SOP updates
- **Risks:** Docs imply auto-sync on every edit; citing a non-existent consolidated `host-adapters` file; docs still requiring per-Apply backup.

**Ships:** Maintainable operator surface.

## Composer notes

- Na: **n/a** (no visual sign-off surface for this program).
- Phase 0 external gate: operator authorized read/copy 2026-08-21 — **complete**.
- **Amended 2026-08-21 (operator):** Do **not** re-prompt for every `-Apply` / live-host write during this program. Phase 0 baselines + companion git are the safety net. Composer/Nb may run dry-run and authorized-program `-Apply` as needed for phase verification; still report what was Applied. User owns quit/restart after Apply for smoke.
- Composer commits locally after QC ACCEPT; never `git push`.
- **2026-08-21 amendment:** no per-sync backup in Core; Phase 0 baselines remain restore SoT for Apply testing only.

### Phase 0 baselines (attested)

| Stack | Path |
| ----- | ---- |
| Cursor | `C:\Users\admin\.cursor-backup-pre-host-sync-build-20260821-012600` |
| OpenCode | `C:\Users\admin\.config\opencode-backup-pre-host-sync-build-20260821-012600` |

Gate artifact: `scripts/host-sync/baseline-backups.paths.json` (`companionSha`: `fbd4724`).
