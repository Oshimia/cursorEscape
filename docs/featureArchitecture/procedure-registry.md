# Procedure registry

**Last updated:** 2026-09-16

## Context

The semantic registry is the sole writable source for machine metadata (agent identity, aliases, required reading, authority/isolation, loop/gate, fail-loud behavior, host representation, skill applicability, composition references, and semantic composition order). Canonical Markdown remains the sole source for procedure prose; manifests remain the sole source for destination/binding. Phases 2–4 migrated all seven hosts, 22 skills, 6 rules, 23 workflows, and all five ownership classes (Cursor hybrid compositions, OpenCode dual-write, Antigravity, Cline/Kilocode, Codex managed AGENTS block) to registry-owned composition-order semantics. Every migrated class has a blocking guard wired into the sole normalization Fast path.

## Substance

### Ownership model

Registry catalogs own machine identity, aliases, required reading, authority/isolation, loop/gate policy, fail-loud behavior, host representation, skill explicit-only policy, composition references, and semantic order. Markdown owns prose; manifests own destination/binding; overlays own host-only leaves and safety boundaries; baselines own byte-exact regression anchors. Skill entries keep two distinct booleans: `modelInvocationDisabled` mirrors the canonical skill frontmatter `disable-model-invocation` flag, while `explicitOnly` must exactly match Phase 0 inventory `explicit_only` (currently only `opencode-headless-run` and `opencode-history-search`).

Host-mechanics deviations (including the retained Cursor `disable-model-invocation: true` asymmetry) and shared-source topology governance are documented in [skill-source-and-host-overlays](./skill-source-and-host-overlays.md); registry profiles enforce the fail-closed boundary.

### Canonical source flow

To **change** an existing governed entity (same ID, same kind):

1. **Prose change:** edit the canonical Markdown body under `workflow/`, `skills/`, `agents/`, or `rules/`. Host projections composed via `CompositionId` update automatically at render time; hand-authored thin wrappers that mirror prose must also be edited in the same changeset (see [editing-companion-workflow](../SOPs/editing-companion-workflow.md)).
2. **Machine metadata change** (identity, aliases, authority, composition order, host representation): edit the registry catalog under `catalog/`. The deterministic renderer derives host projections; manifests own only destinations and host-only substitutions.
3. **Verify:** run the sole normalization Fast CI and `git diff --check`.

To **add** a new governed entity, the Phase 0 inventory must also be updated because the validator enforces exact inventory coverage per kind:

1. **Canonical body/frontmatter:** create the Markdown source under the relevant base directory.
2. **Phase 0 inventory:** update `analysis/procedure-normalization-inventory-2026-09.json` — add the entity's `parity_matrix` row (for agents), skill inventory row, or rule/workflow inventory row with its canonical source path and evidence fields. The registry validator compares every catalog entry against this inventory; a missing inventory row fails Fast CI.
3. **Registry catalog:** add the entry under `catalog/agents.json`, `catalog/skills.json`, or `catalog/rules.json (for rules) or catalog/workflows.json (for workflows/compositions)` with identity, aliases, required reading, authority/isolation, loop/gate, fail-loud behavior, and host representation fields matching the inventory.
4. **Composition or host route (if applicable):** add the composition to `catalog/workflows.json`, bind it in the relevant manifest via `CompositionId` (never `Parts`/`Footer` for registry-governed order), and register any host-only leaves.
5. **Verify:** run the sole normalization Fast CI and `git diff --check`; then run the sole Full CI for a baseline check.

**Live Apply is Phase 6 only.** No normalization or review step writes to live hosts. `Sync-HostHarness.ps1 -Apply` remains the exclusive Phase 6 operator action, gated on owner authorization.

### Fail-closed boundary

`ProcedureRegistry.psm1` validates schema/version, exact Phase 0 inventory coverage, IDs, canonical identity and first-read contract, required reading, aliases, authority/isolation, loop/gate, fail-loud behavior, host representation, route identity, launch mechanism and evidence, both skill booleans (`modelInvocationDisabled` against frontmatter; `explicitOnly` against inventory), explicit skill applicability, rules/workflow canonical sources, one-to-one composition coverage, duplicate-free semantic order, and path containment. Schema items are closed to their declared ownership fields; skill registry entries reject destination metadata because manifests own bindings. Any ambiguity fails rather than falling back to host metadata. Historical baseline directories fail closed when absent or inaccessible; the checker's explicit sandbox opt-out waives inaccessibility only, and absence always fails.

### Blocking guard coverage

Every migrated ownership class has a blocking guard enforced in the sole Fast CI path, except baseline parity which is Full-only:

| Class | Guard | Enforcement point |
|-------|-------|-------------------|
| Cursor hybrid compositions | `Test-RegistryHostCompositionOwnership` | `Test-RegistryCatalog` → `Test-ProcedureRegistry.ps1` → Fast CI |
| OpenCode dual-write | same (Parts/Footer forbidden; composition IDs required) | same |
| Antigravity | same (`Copy-ManifestEntry` runtime rejection for forbidden fields) | same + writer preflight |
| Cline/Kilocode | same (Parts/Footer forbidden; composition IDs required) | same + writer preflight |
| Codex managed AGENTS block | same (writer-side Parts/unknown/divergent rejection) | same + Codex adapter writer checks |
| Source ingress | `Get-RegistrySkillSourceRaw` BOM/missing fail-closed; `CanonicalSourceContract` | same |
| Generated-file boundaries | `Test-RegistryCompositionOutputBoundary` + `Test-RegistryOutputRoot` | `Write-RegistryManagedView` (fail-closed at write time) |
| Deterministic rendering | double-render hash comparison (49 rows + composition rows) | `Test-ProcedureRegistryViews.ps1` → Fast CI |

Full CI additionally enforces baseline parity:

| Class | Guard | Gate |
|-------|-------|------|
| Baseline parity | `Get-ExistingSixStackRenderLedger.ps1 -Verify` (2 independent renders, 6 entries) | Full CI only |

### Superseded-check audit

Phase 4G audited Phase 4C–4F checks and found none superseded: all `Add-SyncWarning` calls validate independent behavior (pressure-release wording, NeverTouch paths, OpenCode instructions-path advisory), and the current-state fixture checker's composition resolution validates Phase 0 inventory alignment (a different invariant from registry ownership). The Phase 2 fallback binding parity and Phase 3A machinery guard are current-state safety checks, not transition-only. The registry-level guard (`Test-RegistryHostCompositionOwnership`) is the sole durable blocking path for composition-order ownership and does not duplicate existing checks.

### Baseline regeneration and verification

Baselines are mechanical regression anchors generated from observed current renders. Never edit baseline or projection bytes to satisfy a stale expectation. When a render output legitimately changes, regenerate the six-stack ledger with `pwsh -NoProfile -File scripts/host-sync/Get-ExistingSixStackRenderLedger.ps1 -WriteLedger`, then verify with `pwsh -NoProfile -File scripts/host-sync/Get-ExistingSixStackRenderLedger.ps1 -Verify`, and commit the updated artifact in the same changeset. Baseline parity is enforced only in the Full CI path; the Fast path validates current state but does not re-anchor bytes.

### Renderer and CI

`Render-ProcedureRegistry.ps1` renders repository-owned explicit output roots; the sole Full CI disposable render passes an explicit temporary-root ownership switch, and the public renderer rejects temporary roots without it. Output roots are segment-checked so exact protected/source roots and the OS temporary root itself fail closed. `Test-ProcedureRegistryViews.ps1` double-renders, checks the public render seam, compares hashes, checks 49 host-agent rows, renders composition rows through `semanticOrder`, exercises resolver seams, and tests fail-closed edges. CI threads one repository root through normalization checks; it never writes committed managed views or live hosts.

### CI gates

| Gate | Script | Scope |
|------|--------|-------|
| Fast | `Invoke-NormalizationFastCI.ps1` | Registry validity + views (676 checks) + current-state + unit checks (24) + focused Codex overlay checks + tracked hygiene + `git diff --check` |
| Full | `Invoke-NormalizationFullCI.ps1` | Fast + Phase 2 Full + focused Codex adapter checks + Phase 3 lifecycle Full + baseline ledger verify + drift fixtures + double-render |

Exactly one Fast and one Full entry point exist. Host-sync phase scripts are internal to Full CI, never separate entry points.

### Phase 6 Apply boundary

Normalization CI and documentation are non-live. Precedence rule for every Apply surface: **dry-run is always allowed; live Apply requires explicit Phase 6 owner authorization; all-host (`-Target All`) Apply is normative; single-stack `-AllowSkew` is only an explicitly owner-authorized recovery exception.** Phase 6 is the exclusive boundary for any `Sync-HostHarness.ps1 -Apply` invocation. Pre-Apply gates include: all-host dry-run, read-only drift report (`Test-HostHarnessDrift.ps1 -Target All -Json`), baseline parity confirmation, and normalization Full CI. Post-Apply gates include: dry-run/drift re-check, 7x7 parity confirmation, restart/reload, and host-specific smoke matrix.

## Implications / open questions

1. Live Apply remains Phase 6; no normalization gate performs a host write.
2. Destination metadata must remain manifest-owned; registry entries reject it.
3. Hand-authored overlay thin wrappers (launch mechanics, permissions, host-specific wiring) are outside registry-generated compositions and still require same-changeset manual edits when their text changes.
