# Host harness sync (modular layout)

**Last updated:** 2026-09-18

Modular sync distributes companion overlay harness to live host stacks. **Dry-run is the default.** Live writes require `-Apply` and a valid Phase 0 baseline gate artifact. After Phase 4 normalization, the [procedure registry](../../docs/featureArchitecture/procedure-registry.md) owns semantic composition order for all five migrated host classes (Cursor hybrid, OpenCode dual-write, Antigravity, Cline/Kilocode, Codex managed AGENTS block); manifests own destinations, host-only substitutions, and `CompositionId` bindings. The sole normalization CI entry points are [`../normalization/Invoke-NormalizationFastCI.ps1`](../normalization/Invoke-NormalizationFastCI.ps1) (Fast) and [`../normalization/Invoke-NormalizationFullCI.ps1`](../normalization/Invoke-NormalizationFullCI.ps1) (Full); the host-sync phase scripts are internally invoked by Full CI, never separate entry points.

**Entry script:** [`../Sync-HostHarness.ps1`](../Sync-HostHarness.ps1)

## Layout

```text
scripts/
  Sync-HostHarness.ps1          # operator entry (dry-run default)
  host-sync/
    HostSync.Contract.ps1       # shared types + adapter contract
    HostSync.Core.ps1             # token merge, copy, verify, gate helpers
    Register-StackAdapters.ps1    # stack registry (manifest + adapter paths)
    baseline-backups.paths.json   # Phase 0 restore paths (Apply gate only)
    manifests/
      cursor.manifest.psd1      # allowlist, excludes, hybrid rule ids
      opencode.manifest.psd1
      antigravity.manifest.psd1 # allowlist, excludes (GEMINI.md replace + skills/workflows)
      vscode.manifest.psd1      # allowlist, excludes (~/.copilot instructions/skills/agents)
      cline.manifest.psd1       # allowlist, excludes (~/.cline rules/workflows)
      kilocode.manifest.psd1    # allowlist, excludes (~/.kilocode rules/workflows)
      codex.manifest.psd1       # two-root allowlist/guards (~/.codex + ~/.agents/skills)
    adapters/
      Cursor.Adapter.ps1          # Invoke-StackHarnessSync for Cursor
      OpenCode.Adapter.ps1        # Invoke-StackHarnessSync for OpenCode
      Antigravity.Adapter.ps1     # REMOVED 2026-09-01 — dispatches to Generic.Adapter.ps1 (byte-identical engine)
      Generic.Adapter.ps1         # SHARED manifest-driven copy-out engine (kilo-cline bring-up); dispatch fallback for stacks without specialized adapters (currently: Antigravity, Vscode, Cline, Kilocode)
      Codex.Adapter.ps1           # specialized fail-closed two-root engine (explicit roots, ownership/hash preflight, staging, rollback)
```

Each stack owns its **manifest** (what to copy, hard excludes, never-touch paths) and **adapter** (stack-specific merge: hybrid Cursor rules, OpenCode JSON + AGENTS dual-write, Codex two-root install). Shared primitives live in Core; Core does **not** branch on stack id except through the registry.

### Per-entry v2 manifest surface (overlay-remediation Phase 1–2)

CopyEntries are **v2**: each entry names its source with a class prefix, resolved by `Copy-ManifestEntry` in `HostSync.Core.ps1`.

| Class | Meaning |
| ----- | ------- |
| *(plain)* | Overlay-relative file (backward-compat for unmigrated rows) |
| `base:` | Repo-root SoT body rendered into this dest (promote-into-twin) |
| `shared:` | `SharedRoot` knob — rooted directory shared across stacks; rooted values accepted verbatim |

Entry keys beyond `Source`/`Dest`:

- **`Parts` / `Footer`** — compose the dest from ordered file references (e.g. host `__header__.md` part + `base:` body + wiring footer). Composed dests leave no second authored procedure.
- **`CompositionId`** — registry-owned semantic composition (current state for all five migrated host classes). When present, the render path derives `Parts`/`Footer` from the registry composition references and **`Parts`/`Footer` are forbidden** on the same entry (`composition-order-ownership` fail-closed, enforced as a blocking guard in normalization Fast CI). The semantic order lives in `catalog/workflows.json`; the manifest owns only the destination, host-only substitutions, and the `CompositionId` binding.
- **`Substitutions`** — fail-closed: each must match **exactly once**; no-match / double-match = hard render error.
- **`PlannedContent`** — dry-run captures would-be written content (incl. dual-written mirrors) for CI asserts.
- **Expected renders** — committed expected-renders under [`render-baselines/`](./render-baselines/phase2/) are the byte-exact regression anchor for composed dests.
- **Ref resolution contract** (unit checks U17–U20): rooted/absolute refs verbatim; un-pre-resolved classed refs throw; overlay-relative refs resolve source-dir first, then `OverlayRoot` fallback.

FA recording: [skill-source-and-host-overlays](../../docs/featureArchitecture/skill-source-and-host-overlays.md#per-entry-v2-sourcing-overlay-remediation-phase-12--required).

## Operator commands

**Normative rule: live pushes are global.** This is a global skill set — a push to one stack alone strands every sibling stack carrying the same sources. The script therefore defaults to `-Target All` and **fails closed** on single-stack `-Apply` whenever the target shares manifest sources with another stack; single-stack Apply exists only as a deliberate exception via `-AllowSkew`.

```powershell
# Dry-run, all registered stacks (DEFAULT — no -Target needed)
pwsh ./scripts/Sync-HostHarness.ps1

# Live write to ALL stacks (requires Phase 0 baseline gate; does NOT create backups)
pwsh ./scripts/Sync-HostHarness.ps1 -Apply

# Stop after first stack failure
pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target All -FailFast

# Dry-run inspection of ONE manifest (read-only, always allowed)
pwsh ./scripts/Sync-HostHarness.ps1 -Target OpenCode

# EXCEPTION ONLY: single-stack live write (deliberate bring-up / scoped repair)
pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target Cursor -AllowSkew

# Disposable Codex dry-run (explicit mandatory roots; no live Codex writes)
pwsh ./scripts/Sync-HostHarness.ps1 -Target Codex -CodexRoot C:/temp/codex -SkillRoot C:/temp/skills
```

After `-Apply`: fully quit and restart the host before relying on new harness behavior. Companion repo is ongoing SoT — **sync does not create backup trees**.

### Post-apply verification policy

The sync script's built-in checks (token merge completeness, byte-exact writes, JSON key-order optimizer) are **authoritative for routine content syncs**. Neither operator nor agent re-verifies file hashes or runs smoke attestation after a routine `-Apply`. Smoke attestation (adapter SOP C-tables) applies only when:

- a surface is synced for the **first time** on a stack,
- the **sync machinery itself** changed (adapters, Core, manifests structure),
- an **always-on gate text** changed and runtime injection must be re-proven.

Per-skill / per-workflow content updates land silently; if something is wrong it surfaces at use time and is fixed as normal procedure drift.

## Phase 0 baselines (restore-only)

One-time baselines taken before building this tool. Used for **restore if Apply breaks a live host** and as a **read-only gate** on `-Apply`. Sync never writes new backup folders.

| Stack | Baseline path (this machine) |
| ----- | ---------------------------- |
| Cursor | `C:\Users\admin\.cursor-backup-pre-host-sync-build-20260821-012600` |
| OpenCode | `C:\Users\admin\.config\opencode-backup-pre-host-sync-build-20260821-012600` |
| Antigravity | `C:\Users\admin\.gemini-backup-pre-host-sync-build-20260824-064125` (registered) |
| VS Code | `C:\Users\admin\.copilot-backup-pre-vscode-bringup-20260901-120000` (registered 2026-09-01) |
| Cline | `C:\Users\admin\.cline-backup-pre-kilobringup-20260901-180000` (registered 2026-09-01) |
| Kilo Code | `C:\Users\admin\.kilocode-backup-pre-kilobringup-20260901-180000` (registered 2026-09-01) |

**Apply coupling (all six established-stack baselines required):** `-Apply` for any established stack fails closed until all six Phase 0 baselines exist — deliberate conservatism because Antigravity Apply wholesale-replaces `~/.gemini/GEMINI.md`, VS Code Apply writes into the shared user-level `~/.copilot`, and the 5th/6th stacks write into `~/.cline` and `~/.kilocode`. Dry-runs are unaffected. VS Code/Cline/Kilocode baselines registered 2026-09-01 (six-stack gate, owner-approved). Codex is governed by its own lifecycle (ApplyState = Active since 2026-09-08) but the global `-Apply` gate still requires the six-stack baseline artifact; a Codex-only baseline bypass is not implemented in the current gate.

Gate artifact: [`baseline-backups.paths.json`](./baseline-backups.paths.json)

**Restore precedence:** Phase 0 `pre-host-sync-build` baselines → legacy archaeology only (`pre-pointer-sync`, `opencode-backup-20260820-*`, `qc-bugbot-ui-*`). No per-Apply / per-sync backup kind.

**Baseline regeneration boundary:** render baselines under [`render-baselines/`](./render-baselines/) and the six-stack ledger are mechanical regression anchors generated from observed current renders. Never edit baseline or projection bytes to satisfy a stale expectation. When a render output legitimately changes: (1) regenerate the six-stack ledger with `pwsh -NoProfile -File scripts/host-sync/Get-ExistingSixStackRenderLedger.ps1 -WriteLedger`; (2) verify with `pwsh -NoProfile -File scripts/host-sync/Get-ExistingSixStackRenderLedger.ps1 -Verify`; (3) for individual expected-render files, render through the deterministic adapter path (for example, the manifest-driven dry-run `pwsh scripts/Sync-HostHarness.ps1 -Target <StackId>` to produce the planned render) or the registry renderer at `scripts/normalization/Render-ProcedureRegistry.ps1` with an explicit output root; (4) commit the regenerated artifacts in the same changeset. Direct editing of expected-render or ledger files is forbidden.

**Live Apply is Phase 6 only** per the [procedure registry Apply boundary](../../docs/featureArchitecture/procedure-registry.md#phase-6-apply-boundary). Dry-run is always allowed; `-Apply` requires explicit owner authorization. Pre-Apply gates: all-host dry-run, read-only drift report, baseline parity confirmation, and normalization Full CI.

## Hard excludes (by manifest)

| Stack | Never sync |
| ----- | ---------- |
| Cursor | `skills-cursor/`; `settings.json`; delete/refresh `docs/workflow/`; thin-pointer-only `.mdc` without hybrid write |
| OpenCode | Procedure mirror re-copy; host copy-out of `review-subagent-models`; overwrite live `model` / `provider` in `opencode.json` |
| Antigravity | Credential/app-state files (`settings.json`, `config/mcp_config.json`, `oauth_creds.json`, `google_accounts.json`, `state.json`, `trustedFolders.json`, `installation_id`); never touch `antigravity/global_workflows/caveman.md` or `config/projects` |
| VS Code | Never touch VS Code-managed state: `config.json`, `ide/`, `logs/` — only `instructions/`, `skills/`, `agents/` are harness-owned |
| Codex | Never touch `config.toml`, `auth.json`, `history.jsonl`, `logs/`, `sessions/`, or `databases/`; non-empty `AGENTS.override.md` blocks Apply |

Manifest `NeverTouch` paths (e.g. `docs/workflow`, Antigravity `caveman.md`) are left in place on the live host.

## Apply lifecycle and global preflight

`ApplyState` defaults to `Active`; the manifest value governs. `Codex` was force-held at `BringUp` through Phases 0–3 and activated 2026-09-08 after three-client smoke; setting its manifest back to `BringUp` re-arms the lifecycle gate.

For Apply, the baseline gate runs first. Then the orchestration lifecycle refuses any selection containing BringUp before any write pass. For every Active selection, it dry-run-preflights **all** selected stacks before the first write; any failure reports the complete preflight set and performs zero writes. `-FailFast` continues to mean “stop the write pass after first failure” and never abbreviates this global preflight.

## Expansion recipe (add a stack)

1. **Overlay:** add `overlays/<stackId>/` thin harness + `_index.md` copy-out map.
2. **Manifest:** create `manifests/<stackid>.manifest.psd1` with `StackId`, `OverlayRelativeRoot`, `LiveRelativeRoot`, `CopyEntries`, `HardExcludes`, `NeverTouch`, and stack-specific keys (e.g. `HybridRuleIds`, `JsonMerge`, `AgentsDualWrite`). For entries whose reference order is registry-governed, set `CompositionId` instead of `Parts`/`Footer` — the registry owns semantic order; the manifest owns destination, binding, and host-only substitutions.
3. **Adapter:** create a specialized adapter only for real host legs; otherwise dispatch to Generic. The shared contract remains `Invoke-StackHarnessSync` (specialized roots may be mandatory when the host has multiple homes) — see [`HostSync.Contract.ps1`](./HostSync.Contract.ps1).
4. **Registry:** add the stack id to `Get-RegisteredStackIds` in [`Register-StackAdapters.ps1`](./Register-StackAdapters.ps1).
5. **Docs:** add or extend a host-adapter SOP; update [`editing-companion-workflow.md`](../../docs/SOPs/editing-companion-workflow.md) live-sync row; update overlay `_index`.
6. **Verify:** dry-run `-Target <StackId>` (manifest inspection), then default all-stacks dry-run; authorized global `-Apply`; host restart. Smoke attestation per the post-apply verification policy above (first-time surface only).

Do **not** add stack-specific logic to Core unless it is genuinely shared (prefer adapter + manifest).

## Drift audit and non-mutating CI

Use the drift audit to compare the exact UTF-8 bytes Apply would write with current live bytes. It renders through the registered adapters, reads host state only, emits hashes (never content), and orders rows deterministically.

For existing Codex managed-block targets, “exact bytes” means Apply-equivalent output: the planned managed block plus owner-owned text outside that block. Committed OpenCode C1 mirrors are portable `{{COMPANION_ROOT}}` token sources; verification merges those tokens before byte-comparing the Apply plan.

`Test-HostHarnessDrift.ps1` reads host state only: it never performs live Apply and never writes host state. By contrast, the disposable fixture suite intentionally invokes adapter Apply, but only under generated temporary roots; it never touches real host homes. Fixture isolation uses a temporary `USERPROFILE` for adapters; `-HomeRoot` alone is the physical comparison root and does not override every adapter root seam.

```powershell
# Human-readable audit for all registered stacks
pwsh scripts/host-sync/Test-HostHarnessDrift.ps1

# Machine-readable audit; exit 0=clean, 2=drift/missing, 3=read/render error
pwsh scripts/host-sync/Test-HostHarnessDrift.ps1 -Json
```

The disposable fixture suite exercises clean, drift, missing, path-error, Cursor hybrid, OpenCode JSON, and Codex two-root behavior without touching real host homes. It uses temporary adapter Apply only to construct and mutate those disposable roots:

```powershell
pwsh scripts/host-sync/Invoke-HostSyncDriftFixtureChecks.ps1
```

`Invoke-HostSyncFullCI.ps1` is non-mutating. It validates exact planned C1 bytes, deterministic OpenCode JSON, model/provider preservation, inventory, and zero managed-byte changes from dry-run; it must never invoke `-Apply`.

Focused Codex suites remain internal normalization coverage: `Invoke-CodexRenderChecks.ps1` runs in Fast, while `Invoke-CodexAdapterFixtureChecks.ps1` and `Invoke-CodexLifecycleChecks.ps1` run in Full. They accept explicit `-CompanionRoot` values and use disposable roots rather than live host profiles.

## OpenCode JSON merge — canonical key order (required)

OpenCode permission pattern maps use **last matching rule wins**. After specimen↔live merge, Core runs `Optimize-OpenCodePermissionKeyOrder` so every allow/ask/deny map emits `"*"` **first**, then named overrides.

OpenCode JSON is byte-deterministic: ordinary mappings are sorted canonically (ordinal by key), recursively; arrays remain order-significant. Permission pattern maps are semantic exceptions: `"*"` is emitted first, then named patterns ordinally. This prevents PowerShell hashtable enumeration order from changing Apply bytes between runs.

| Failure if skipped | Correct write |
| ------------------ | ------------- |
| `"plan_reviewer": "allow"` then `"*": "deny"` → Task spawn denied | `"*": "deny"` first, then named allows |
| `"Get-ChildItem*": "allow"` then `"*": "ask"` → listing still asks | `"*": "ask"` first, then listing allows |

**Do not** replace that canonical ordering with raw hashtable serialization when editing `Merge-OpenCodeHarnessJson`. Focused CI: `Invoke-HostSyncChecks.ps1 -Suite DryRun` asserts `*` is first on merged `build.task` and global `bash`.

Full write-ups: [opencode-authoring-adapter Failure modes K–M](../../docs/SOPs/opencode-authoring-adapter.md#failure-mode-k--permission-pattern--not-first-last-match-wins).

## Related

- [Cursor host adapter SOP](../../docs/SOPs/cursor-host-adapter.md)
- [OpenCode host adapter SOP](../../docs/SOPs/opencode-host-adapter.md)
- [OpenCode authoring adapter](../../docs/SOPs/opencode-authoring-adapter.md) — Failure modes I–M (permissions / bash / sync order)
- [Codex host adapter SOP](../../docs/SOPs/codex-host-adapter.md)
- [Editing companion workflow](../../docs/SOPs/editing-companion-workflow.md)
