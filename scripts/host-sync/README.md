# Host harness sync (modular layout)

**Last updated:** 2026-08-24

Modular sync distributes companion overlay harness to live host stacks. **Dry-run is the default.** Live writes require `-Apply` and a valid Phase 0 baseline gate artifact.

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
    adapters/
      Cursor.Adapter.ps1          # Invoke-StackHarnessSync for Cursor
      OpenCode.Adapter.ps1        # Invoke-StackHarnessSync for OpenCode
      Antigravity.Adapter.ps1     # REMOVED 2026-09-01 — dispatches to Generic.Adapter.ps1 (byte-identical engine)
      Generic.Adapter.ps1         # SHARED manifest-driven copy-out engine (kilo-cline bring-up); dispatch fallback for stacks without specialized adapters (currently: Antigravity, Vscode, Cline, Kilocode)
```

Each stack owns its **manifest** (what to copy, hard excludes, never-touch paths) and **adapter** (stack-specific merge: hybrid Cursor rules, OpenCode JSON + AGENTS dual-write). Shared primitives live in Core; Core does **not** branch on stack id except through the registry.

### Per-entry v2 manifest surface (overlay-remediation Phase 1–2)

CopyEntries are **v2**: each entry names its source with a class prefix, resolved by `Copy-ManifestEntry` in `HostSync.Core.ps1`.

| Class | Meaning |
| ----- | ------- |
| *(plain)* | Overlay-relative file (backward-compat for unmigrated rows) |
| `base:` | Repo-root SoT body rendered into this dest (promote-into-twin) |
| `shared:` | `SharedRoot` knob — rooted directory shared across stacks; rooted values accepted verbatim |

Entry keys beyond `Source`/`Dest`:

- **`Parts` / `Footer`** — compose the dest from ordered file references (e.g. host `__header__.md` part + `base:` body + wiring footer). Composed dests leave no second authored procedure.
- **`Substitutions`** — fail-closed: each must match **exactly once**; no-match / double-match = hard render error.
- **`PlannedContent`** — dry-run captures would-be written content (incl. dual-written mirrors) for CI asserts.
- **Goldens** — committed expected-renders under [`goldens/`](./goldens/phase2/) are the byte-exact regression anchor for composed dests.
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

**Apply coupling (all six baselines required):** `-Apply` for ANY stack fails closed until all six Phase 0 baselines exist — deliberate conservatism because Antigravity Apply wholesale-replaces `~/.gemini/GEMINI.md`, VS Code Apply writes into the shared user-level `~/.copilot`, and the 5th/6th stacks write into `~/.cline` and `~/.kilocode`. Dry-runs are unaffected. VS Code/Cline/Kilocode baselines registered 2026-09-01 (six-stack gate, owner-approved).

Gate artifact: [`baseline-backups.paths.json`](./baseline-backups.paths.json)

**Restore precedence:** Phase 0 `pre-host-sync-build` baselines → legacy archaeology only (`pre-pointer-sync`, `opencode-backup-20260820-*`, `qc-bugbot-ui-*`). No per-Apply / per-sync backup kind.

## Hard excludes (by manifest)

| Stack | Never sync |
| ----- | ---------- |
| Cursor | `skills-cursor/`; `settings.json`; delete/refresh `docs/workflow/`; thin-pointer-only `.mdc` without hybrid write |
| OpenCode | Procedure mirror re-copy; host copy-out of `review-subagent-models`; overwrite live `model` / `provider` in `opencode.json` |
| Antigravity | Credential/app-state files (`settings.json`, `config/mcp_config.json`, `oauth_creds.json`, `google_accounts.json`, `state.json`, `trustedFolders.json`, `installation_id`); never touch `antigravity/global_workflows/caveman.md` or `config/projects` |
| VS Code | Never touch VS Code-managed state: `config.json`, `ide/`, `logs/` — only `instructions/`, `skills/`, `agents/` are harness-owned |

Manifest `NeverTouch` paths (e.g. `docs/workflow`, Antigravity `caveman.md`) are left in place on the live host.

## Expansion recipe (add a third stack)

1. **Overlay:** add `overlays/<stackId>/` thin harness + `_index.md` copy-out map.
2. **Manifest:** create `manifests/<stackid>.manifest.psd1` with `StackId`, `OverlayRelativeRoot`, `LiveRelativeRoot`, `CopyEntries`, `HardExcludes`, `NeverTouch`, and stack-specific keys (e.g. `HybridRuleIds`, `JsonMerge`, `AgentsDualWrite`).
3. **Adapter:** create `adapters/<StackId>.Adapter.ps1` exporting `Invoke-StackHarnessSync` with signature `(Mode, CompanionRoot, Manifest)` — see [`HostSync.Contract.ps1`](./HostSync.Contract.ps1).
4. **Registry:** add the stack id to `Get-RegisteredStackIds` in [`Register-StackAdapters.ps1`](./Register-StackAdapters.ps1).
5. **Docs:** add or extend a host-adapter SOP; update [`editing-companion-workflow.md`](../../docs/SOPs/editing-companion-workflow.md) live-sync row; update overlay `_index`.
6. **Verify:** dry-run `-Target <StackId>` (manifest inspection), then default all-stacks dry-run; authorized global `-Apply`; host restart. Smoke attestation per the post-apply verification policy above (first-time surface only).

Do **not** add stack-specific logic to Core unless it is genuinely shared (prefer adapter + manifest).

## OpenCode JSON merge — permission key order (required)

OpenCode permission pattern maps use **last matching rule wins**. After specimen↔live merge, Core runs `Optimize-OpenCodePermissionKeyOrder` so every allow/ask/deny map emits `"*"` **first**, then named overrides.

| Failure if skipped | Correct write |
| ------------------ | ------------- |
| `"plan_reviewer": "allow"` then `"*": "deny"` → Task spawn denied | `"*": "deny"` first, then named allows |
| `"Get-ChildItem*": "allow"` then `"*": "ask"` → listing still asks | `"*": "ask"` first, then listing allows |

**Do not** drop that optimizer when editing `Merge-OpenCodeHarnessJson`. Fast CI: `Invoke-Phase2FastCI.ps1` asserts `*` is first on merged `build.task` and global `bash`.

Full write-ups: [opencode-authoring-adapter Failure modes K–M](../../docs/SOPs/opencode-authoring-adapter.md#failure-mode-k--permission-pattern--not-first-last-match-wins).

## Related

- [Host harness sync build roadmap](../../docs/roadmaps/host-harness-sync-build.md)
- [Cursor host adapter SOP](../../docs/SOPs/cursor-host-adapter.md)
- [OpenCode host adapter SOP](../../docs/SOPs/opencode-host-adapter.md)
- [OpenCode authoring adapter](../../docs/SOPs/opencode-authoring-adapter.md) — Failure modes I–M (permissions / bash / sync order)
- [Editing companion workflow](../../docs/SOPs/editing-companion-workflow.md)
