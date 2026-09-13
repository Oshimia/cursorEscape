# Procedure normalization inventory — 2026-09

**Phase:** 0 · **Status:** implementation-under-review · **Schema:** v2 · **Snapshot date:** 2026-09-11 · **Last updated:** 2026-09-13

This is a read-only current-state snapshot. It identifies evidence and policy; it does not authorize migration or Apply. The snapshot date is the original Phase 0 capture; the last-updated date records later reconciliation edits only.

## Representation terms

| Term | Meaning |
|---|---|
| `native-definition` | A host-loaded definition artifact exists. Launch mechanism is recorded separately. |
| `generated-native-projection` | A deterministically generated host-native artifact is deployed as the representation. Launch mechanism is recorded separately. |
| `fallback-launch-contract` | An explicit fresh-task/session launch contract exists instead of a host definition artifact. |
| `missing` | No current representation exists. Phase 2 proposes the recorded route. |

## Parity totals

| Metric | Count |
|---|---:|
| Total pairs | 49 |
| Represented | 37 |
| Missing | 12 |

| Host | native-definition | generated-native-projection | fallback-launch-contract | missing |
|---|---:|---:|---:|---:|
| Cursor | 3 | 0 | 1 | 3 |
| OpenCode | 7 | 0 | 0 | 0 |
| Antigravity | 4 | 0 | 0 | 3 |
| Vscode | 7 | 0 | 0 | 0 |
| Cline | 0 | 0 | 4 | 3 |
| Kilocode | 0 | 0 | 4 | 3 |
| Codex | 0 | 7 | 0 | 0 |

## Missing pairs and Phase 2 proposals

| Host | Agent | Proposal |
|---|---|---|
| Cursor | `implementer` | `native` |
| Cursor | `repository_explorer` | `native` |
| Cursor | `test_reviewer` | `native` |
| Antigravity | `implementer` | `native` |
| Antigravity | `repository_explorer` | `native` |
| Antigravity | `test_reviewer` | `native` |
| Cline | `implementer` | `fresh-task-session-fallback` |
| Cline | `repository_explorer` | `fresh-task-session-fallback` |
| Cline | `test_reviewer` | `fresh-task-session-fallback` |
| Kilocode | `implementer` | `fresh-task-session-fallback` |
| Kilocode | `repository_explorer` | `fresh-task-session-fallback` |
| Kilocode | `test_reviewer` | `fresh-task-session-fallback` |

Notable route facts: `planner` is now represented on all seven hosts — Cursor and Antigravity as native host-definition wrappers (`overlays/cursor/agents/planner.md`, `overlays/antigravity/agents/planner.md`); Cline and Kilocode as fresh-task/session fallback contracts in `workflows/plan.md` (fresh task per pass; a reused conversation or empty response is a planning failure, never a valid planner result). Cursor built-in Bugbot remains `fallback-launch-contract`; Phase 2 may retain it only if the canonical envelope and clean-context isolation are explicit. OpenCode `implementer` is a primary-mode definition with Task/routing delegation to isolated child agents, not a subagent mode. Cline and Kilocode `plan_reviewer` fallback evidence points to `workflows/plan.md` (the planning-gate workflow). OpenCode host authority is derived from agent frontmatter plus `overlays/opencode/opencode.specimen.json`; configured `bash` behavior is ask with an explicit read-oriented allowlist, not denied.

## Manifest summary

| Host | Manifest | Binding model | Copy/Destination entries | HardExcludes | NeverTouch | HybridRuleIds |
|---|---|---|---:|---:|---:|---:|
| Cursor | `scripts/host-sync/manifests/cursor.manifest.psd1` | `single-root` | 14 | 2 | 1 | 4 |
| OpenCode | `scripts/host-sync/manifests/opencode.manifest.psd1` | `single-root` | 19 | 2 | 1 | 0 |
| Antigravity | `scripts/host-sync/manifests/antigravity.manifest.psd1` | `single-root` | 19 | 8 | 2 | 0 |
| Vscode | `scripts/host-sync/manifests/vscode.manifest.psd1` | `single-root` | 21 | 2 | 3 | 0 |
| Cline | `scripts/host-sync/manifests/cline.manifest.psd1` | `single-root` | 4 | 4 | 7 | 0 |
| Kilocode | `scripts/host-sync/manifests/kilocode.manifest.psd1` | `single-root` | 4 | 1 | 1 | 0 |
| Codex | `scripts/host-sync/manifests/codex.manifest.psd1` | `codex-two-logical-roots` | 32 | 6 | 6 | 0 |

OpenCode records dual-write instructions plus `AGENTS.md`, JSON merge with preserved top-level keys, and an explicitly empty `HybridRuleIds` list; other non-Cursor manifests omit the field and normalize to an empty list. Codex has two independent logical roots, no single `LiveRelativeRoot` or `SharedRoot`, ApplyState `Active`, ownership/block markers, an 8,000-character catalog budget, and two explicit-only OpenAI metadata files. Cursor, like Codex, omits `SharedRoot`; the inventory records that absence as null rather than inferring a default.

## Skills

There are **22 canonical skills** plus **1 generated rule wrapper**, for 23 advertised Codex wrappers. Explicit-only: `opencode-headless-run`, `opencode-history-search`. Machine-readable source and per-host applicability are in `skills_inventory`.

## Rules, workflows, and compositions

- Canonical rules: **6** (`rules/`).
- Canonical workflows: **23** (`workflow/`).
- Manifest rule/workflow/instruction compositions: **8**, each with source, destination, parts/footer, semantic order, and host in JSON. Every manifest composition is represented in the inventory and every inventory composition maps to a manifest entry.

## Baselines

The six historical restore directories cover Cursor, OpenCode, Antigravity, Vscode, Cline, and Kilocode only. Codex uses `scripts/host-sync/render-baselines/codex-phase1/render-plan.json`, 31 rendered destinations, and 13 physical fixture leaves under `fixtures/`. The six-stack ledger records six exact destination-count/hash rows. Paths and counts are authoritative in JSON.

## Operator matrix

| Host | Adapter evidence | Restart / reload | Representative smoke | Recovery |
|---|---|---|---|---|
| Cursor | `scripts/host-sync/manifests/cursor.manifest.psd1; scripts/host-sync/adapters/Cursor.Adapter.ps1` | Restart Cursor IDE after Apply; hybrid rules are scanned on workspace open. | Open clean workspace; verify plan-review default-on gate from .cursor/rules/agent-invocation.mdc; invoke subagent_type plan-reviewer via Task. | Operator (restore from baseline backup; re-run Sync-HostHarness.ps1 dry-run to verify). |
| OpenCode | `scripts/host-sync/manifests/opencode.manifest.psd1; scripts/host-sync/adapters/OpenCode.Adapter.ps1` | Restart OpenCode CLI/extension after Apply; instructions and agents are loaded on session start. | Run `opencode` in clean terminal; verify always-on gate from AGENTS.md; invoke planner agent via Task. | Operator (restore from baseline backup; re-run dry-run to verify). |
| Antigravity | `scripts/host-sync/manifests/antigravity.manifest.psd1; scripts/host-sync/adapters/Generic.Adapter.ps1` | Restart Antigravity app after Apply; GEMINI.md is read at session start. | Launch Antigravity; verify GEMINI.md always-on gate; invoke plan_reviewer subagent via invoke_subagent. | Operator (restore GEMINI.md from baseline backup). |
| Vscode | `scripts/host-sync/manifests/vscode.manifest.psd1; scripts/host-sync/adapters/Generic.Adapter.ps1` | Restart VS Code after Apply; instructions are loaded on Copilot chat open. | Open VS Code Copilot chat; verify cursor-escape-loop instructions; invoke planner agent. | Operator (restore from baseline backup). |
| Cline | `scripts/host-sync/manifests/cline.manifest.psd1; scripts/host-sync/adapters/Generic.Adapter.ps1` | Reload VS Code window after Apply; rules are scanned on Cline tab activation. | Open Cline tab; verify cursor-escape-loop rule; start fresh task with canonical envelope for plan_reviewer. | Operator (restore from baseline backup). |
| Kilocode | `scripts/host-sync/manifests/kilocode.manifest.psd1; scripts/host-sync/adapters/Generic.Adapter.ps1` | Reload VS Code window after Apply; rules auto-included on startup via legacy-compat loader. | Open Kilo Code tab; verify cursor-escape-loop rule; start fresh task with canonical envelope. | Operator (restore from baseline backup). |
| Codex | `scripts/host-sync/manifests/codex.manifest.psd1; scripts/host-sync/adapters/Codex.Adapter.ps1` | Restart Codex CLI / VS Code extension / ChatGPT desktop after Apply; agents loaded at session start. | Run `codex` CLI in clean terminal; verify AGENTS.md managed block; invoke planner via Codex custom-agent mechanism. | Operator (Codex has no baseline directory; committed fixtures in render-baselines/codex-phase1/ provide the expected content for manual restore). |

## Ambiguities requiring owner confirmation

| ID | Question |
|---|---|
| U-Cursor-Bugbot | Retain built-in Bugbot fallback only with explicit canonical envelope and isolation, or add a native definition in Phase 2? |
| U-Cline-Kilocode-Routes | Phase 2 proposes fresh-task/session fallback for all missing Cline/Kilocode roles. Confirm operator/task workflow acceptance. |
| U-Antigravity-Authority | Confirm the Antigravity subagent mechanism can express workspace-write for `implementer` when migrated. |
| U-Render-Baseline-Reconciliation | Identify mechanical baseline changes after generators exist; cannot be derived safely until Phase 2. |
