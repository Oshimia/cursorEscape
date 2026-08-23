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
    adapters/
      Cursor.Adapter.ps1          # Invoke-StackHarnessSync for Cursor
      OpenCode.Adapter.ps1        # Invoke-StackHarnessSync for OpenCode
      Antigravity.Adapter.ps1     # Invoke-StackHarnessSync for Antigravity
```

Each stack owns its **manifest** (what to copy, hard excludes, never-touch paths) and **adapter** (stack-specific merge: hybrid Cursor rules, OpenCode JSON + AGENTS dual-write). Shared primitives live in Core; Core does **not** branch on stack id except through the registry.

## Operator commands

```powershell
# Dry-run one stack (default)
pwsh ./scripts/Sync-HostHarness.ps1 -Target Cursor
pwsh ./scripts/Sync-HostHarness.ps1 -Target OpenCode
pwsh ./scripts/Sync-HostHarness.ps1 -Target Antigravity

# Dry-run all registered stacks (continue-with-report)
pwsh ./scripts/Sync-HostHarness.ps1 -Target All

# Live write (requires Phase 0 baseline gate; does NOT create backups)
pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target Cursor
pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target OpenCode
pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target Antigravity
pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target All

# Stop after first stack failure when syncing All
pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target All -FailFast
```

After `-Apply`: fully quit and restart the host before smoke. Companion repo is ongoing SoT — **sync does not create backup trees**.

## Phase 0 baselines (restore-only)

One-time baselines taken before building this tool. Used for **restore if Apply breaks a live host** and as a **read-only gate** on `-Apply`. Sync never writes new backup folders.

| Stack | Baseline path (this machine) |
| ----- | ---------------------------- |
| Cursor | `C:\Users\admin\.cursor-backup-pre-host-sync-build-20260821-012600` |
| OpenCode | `C:\Users\admin\.config\opencode-backup-pre-host-sync-build-20260821-012600` |
| Antigravity | **Pending** — operator to take a restore-only baseline of `~/.gemini` and set the `antigravity` property in [`baseline-backups.paths.json`](./baseline-backups.paths.json) |

**Apply coupling (all three baselines required):** `-Apply` for ANY stack fails closed until all three Phase 0 baselines exist. Until the Antigravity baseline is taken, `-Apply -Target Cursor/OpenCode` also fails — deliberate conservatism because Antigravity Apply wholesale-replaces `~/.gemini/GEMINI.md`. Dry-runs are unaffected.

Gate artifact: [`baseline-backups.paths.json`](./baseline-backups.paths.json)

**Restore precedence:** Phase 0 `pre-host-sync-build` baselines → legacy archaeology only (`pre-pointer-sync`, `opencode-backup-20260820-*`, `qc-bugbot-ui-*`). No per-Apply / per-sync backup kind.

## Hard excludes (by manifest)

| Stack | Never sync |
| ----- | ---------- |
| Cursor | `skills-cursor/`; `settings.json`; delete/refresh `docs/workflow/`; thin-pointer-only `.mdc` without hybrid write |
| OpenCode | Procedure mirror re-copy; host copy-out of `review-subagent-models`; overwrite live `model` / `provider` in `opencode.json` |
| Antigravity | Credential/app-state files (`settings.json`, `config/mcp_config.json`, `oauth_creds.json`, `google_accounts.json`, `state.json`, `trustedFolders.json`, `installation_id`); never touch `antigravity/global_workflows/caveman.md` or `config/projects` |

Manifest `NeverTouch` paths (e.g. `docs/workflow`, Antigravity `caveman.md`) are left in place on the live host.

## Expansion recipe (add a third stack)

1. **Overlay:** add `overlays/<stackId>/` thin harness + `_index.md` copy-out map.
2. **Manifest:** create `manifests/<stackid>.manifest.psd1` with `StackId`, `OverlayRelativeRoot`, `LiveRelativeRoot`, `CopyEntries`, `HardExcludes`, `NeverTouch`, and stack-specific keys (e.g. `HybridRuleIds`, `JsonMerge`, `AgentsDualWrite`).
3. **Adapter:** create `adapters/<StackId>.Adapter.ps1` exporting `Invoke-StackHarnessSync` with signature `(Mode, CompanionRoot, Manifest)` — see [`HostSync.Contract.ps1`](./HostSync.Contract.ps1).
4. **Registry:** add the stack id to `Get-RegisteredStackIds` in [`Register-StackAdapters.ps1`](./Register-StackAdapters.ps1).
5. **Docs:** add or extend a host-adapter SOP; update [`editing-companion-workflow.md`](../../docs/SOPs/editing-companion-workflow.md) live-sync row; update overlay `_index`.
6. **Verify:** dry-run `-Target <StackId>` then `-Target All`; authorized `-Apply` + host restart + smoke per that stack's SOP.

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
