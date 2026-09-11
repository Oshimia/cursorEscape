# Roadmap: Procedure Registry Normalization

```text
Status:              Complete — Phase 0 dual-approved and Full CI passed 2026-09-11
Plan review:         APPROVED, historical pass 3 of 3
Execution status:    Phase 0 complete; Phase 1 awaits the Phase 0 closeout commit
Owner:               Repository owner
Conductor:           Composer-conducted, bounded slices
Plan source:         .plans/procedure-registry-normalization.md (historical approved-plan snapshot)
Last updated:        2026-09-11
Live Apply:          Phase 6 only, with explicit owner authorization
```

## Current execution status

Phase 0 is **complete**. Renewed loop iteration 3 achieved dual approval, and Composer observed the Full CI set passing on 2026-09-11. The local plan snapshot is immutable historical provenance, not current acceptance state. Do not infer completion from historical plan-review approval alone.

## Phase 0 checklist

- [x] Complete migration-surface inventory.
- [x] 7x7 governed-agent parity matrix.
- [x] Per-host restart/smoke/recovery matrix.
- [x] Stale lifecycle documentation reconciled in this changeset.
- [x] Full CI observed pass (Composer, 2026-09-11).

## Product decisions

1. Registry is the sole writable source for canonical machine metadata and semantic composition order.
2. Canonical Markdown remains the sole writable source for procedure prose.
3. All seven governed child agents must be represented on all seven hosts, natively or through explicit fresh-task/session fallback.
4. Host aliases may route; they never replace canonical identity.
5. Skills may have explicit host non-applicability; governed agents may not.
6. Generated files, baselines, and current-state fixtures are never hand-edited.
7. Per-slice cap: maximum 15 directly reviewed files and 1,000 hand-authored changed lines.
8. Review sequence is Fast CI → production/bug reviewer pair → fixes → Fast CI → fresh replacement reviewer pair → dual approval → Full CI → pre-commit gate → local commit.
9. No live host Apply before Phase 6.
10. Phase 6 Apply requires explicit owner authorization.

## Accepted safety notes

1. Consider `-FailFast` on the Phase 6 Apply command to stop after the first write failure rather than continuing across hosts.
2. Before Apply, record owner acknowledgment that the six existing backups are historical restore points and Codex relies on targeted committed fixtures plus the current render plan rather than a baseline directory.
3. During Phases 3 and 4, record projected reviewed-file counts before review and split any batch that would exceed the 15-file cap.
4. If Phase 6 smoke exposes a source-code defect, return it to the normal slice review/CI workflow instead of treating it only as host recovery.

## Inter-phase contracts

1. Registry schema begins at `v1`; breaking changes require replan.
2. Registry owns canonical metadata and semantic order.
3. Markdown owns procedure prose.
4. Manifest owns destination/binding and bounded host wrapper slots.
5. Managed views are generated and byte-checked.
6. Every host supports every governed agent natively or through fresh-task fallback.
7. Canonical identity is never replaced by alias.
8. Skills may have explicit host non-applicability; agents may not.
9. Each slice migrates only its listed batch.
10. Each slice has an explicit rollback path.
11. Superseded checks retire after their replacement passes Full CI.
12. Fast → reviewer pair → fixes → Fast → replacement reviewers → dual approval → Full → pre-commit gate → local commit is mandatory per slice.
13. No live Apply before Phase 6.
14. Phase 6 Apply requires explicit owner authorization.
15. `Invoke-NormalizationFullCI.ps1` is the sole Full entry point after Phase 1.

## Migration / Apply order

1. Inventory/parity/operator matrix.
2. Registry and CI foundation.
3. Canonicalize all seven agent contracts.
4. Migrate agent projections to full 7x7 parity.
5. Migrate skills in bounded batches.
6. Migrate rules/workflows/instructions.
7. Final docs/guards/baselines/roadmap.
8. Final gates, owner-authorized all-host Apply, restart, smoke, and closeout.

## Verification summary

| Verification | Command/method | When |
|---|---|---|
| Phase 0 current state | `scripts/normalization/Invoke-CurrentStateFixtureChecks.ps1` | Every Phase 0 review pass |
| Existing sync behavior | `scripts/host-sync/Invoke-RemediationUnitChecks.ps1` | Every phase |
| Tree hygiene | `git diff --check` | Every slice/closeout |
| Registry validity | `Test-ProcedureRegistry.ps1` | Phase 1+ |
| 7x7 parity | Registry/generated parity report | Phase 2A+ and Phase 6 |
| Deterministic generation | Render twice; compare hashes | Phase 2+ |
| Sole normalization Full | `Invoke-NormalizationFullCI.ps1` | Phase 1+ |
| Six-stack ledger | `Get-ExistingSixStackRenderLedger.ps1 -Verify` | Every Full |
| Drift fixtures | `Invoke-HostSyncDriftFixtureChecks.ps1` | Phase 0, migrations, closeout |
| All-host dry-run | `Sync-HostHarness.ps1 -Target All` | Before/after Apply |
| Live drift | `Test-HostHarnessDrift.ps1 -Target All -Json` | Phase 5 report, pre/post Apply |
| Live Apply | `Sync-HostHarness.ps1 -Apply -Target All` | Phase 6 only |
| Pre-commit gate | `rules/pre-commit-ci-gate.md` | Before every local commit |

## Full rationale

The approved local plan remains the full source of goals, alternatives, assumptions, unknowns, ownership rationale, phase sizing, rollback design, and review outcome. This tracked roadmap intentionally does not duplicate that plan. Read the complete historical snapshot at `.plans/procedure-registry-normalization.md`.

## Agent contexts

### Phase 0 — Inventory, parity, and operator recovery matrix

#### Agent context — Phase 0

- **Goal:** Complete inventory and all-host parity/operator baseline.
- **Entry gate:** Approved plan and clean tree.
- **Do not touch:** Live host state, protected paths, runtime projections.
- **In scope:** Analysis inventory, parity matrix, operator matrix, current-state fixtures, stale lifecycle docs.
- **Out of scope:** Registry finalization, generators, migration.
- **Files expected:**
  - `analysis/procedure-normalization-inventory-2026-09.json`
  - `analysis/procedure-normalization-inventory-2026-09.md`
  - focused fixtures/tests
  - stale README/doc reconciliation
- **Where to read context:**
  - this plan;
  - host manifests;
  - `scripts/host-sync/README.md`;
  - adapter SOPs;
  - canonical agent contracts;
  - `workflow/agent-invocation.md`.
- **Fast CI:**
  - `pwsh -NoProfile -File scripts/host-sync/Invoke-RemediationUnitChecks.ps1`
  - `git diff --check`
- **Full CI before commit:**
  - `pwsh -NoProfile -File scripts/host-sync/Invoke-Phase2FullCI.ps1`
  - `pwsh -NoProfile -File scripts/host-sync/Invoke-Phase3FullCI.ps1`
  - `pwsh -NoProfile -File scripts/host-sync/Get-ExistingSixStackRenderLedger.ps1 -Verify`
  - `pwsh -NoProfile -File scripts/host-sync/Invoke-HostSyncDriftFixtureChecks.ps1`
- **Deliverables:**
- [x] Complete inventory.
  - [x] 7x7 parity matrix.
  - [x] Per-host restart/smoke/recovery matrix.
  - [x] Lifecycle docs reconciled.
  - [x] Full CI observed pass.
- **Risks:** Misclassifying an intentional safety boundary as accidental drift.

---


### Phase 1 — Registry, managed views, validator, and sole CI orchestrators

#### Agent context — Phase 1

- **Goal:** Validated one-source metadata foundation.
- **Entry gate:** Phase 0 Full-passed and committed.
- **Do not touch:** Runtime overlays, live hosts, canonical Markdown migration.
- **In scope:** Catalog, schema, module, validator/renderer checker, two sole CI orchestrators, focused architecture note.
- **Out of scope:** Canonical managed-view migration, host migration, docs cascade.
- **Files expected:** catalog files, schema, registry module, tests/checks, Fast/Full orchestrators, focused architecture note.
- **Where to read context:** this plan; Phase 0 inventory; canonical contracts; HostSync Core.
- **Fast CI:**
  - `pwsh -NoProfile -File scripts/normalization/Invoke-NormalizationFastCI.ps1`
  - `git diff --check`
- **Full CI before commit:**
  - `pwsh -NoProfile -File scripts/normalization/Invoke-NormalizationFullCI.ps1`
- **Deliverables:**
  - [ ] Registry covers inventory items or explicitly marks `host-only`.
  - [ ] Managed-view checker works.
  - [ ] Canonical↔registry consistency check blocks migration on mismatch.
  - [ ] Sole Fast/Full orchestrators exist and pass.
  - [ ] No runtime projection changed.
- **Risks:** Registry becoming a second procedure tree.

---


### Phase 2 — Agent canonicalization and full 7x7 parity

#### Agent context — Phases 2A through 2K

- **Goal:** All seven governed agents available on all seven hosts with identical semantics.
- **Entry gate:** Phase 1 Full-passed. Each later slice depends on the prior slice being dual-approved, Full-passed, and committed.
- **Do not touch:** Skill/rule/workflow runtime surfaces, live hosts, protected paths.
- **In scope:** Only the slice's catalog fields, canonical contracts if explicitly listed, generator/tests, host projections/routes, manifests, baselines, and superseded checks.
- **Out of scope:** All later slices and other artifact classes.
- **Files expected:** exact paths recorded before review; generated files/fixtures count toward cap.
- **Where to read context:** this plan; Phase 0 parity matrix; registry schema; canonical agent contracts; affected host manifest/SOP.
- **Fast CI:**
  - `pwsh -NoProfile -File scripts/normalization/Invoke-NormalizationFastCI.ps1`
  - slice shadow comparison
  - `git diff --check`
- **Full CI before commit:**
  - `pwsh -NoProfile -File scripts/normalization/Invoke-NormalizationFullCI.ps1`
- **Deliverables:**
  - [ ] Slice parity matrix updated.
  - [ ] Canonical↔registry checks clean.
  - [ ] No canonical identity replaced by alias.
  - [ ] Host isolation/authority matches registry.
  - [ ] Fail-loud role-native behavior retained.
  - [ ] Cline/Kilocode fallbacks require fresh task/session where applicable.
  - [ ] Baseline churn limited to slice.
  - [ ] Full CI observed pass after dual approval.
- **Risks:** Missing fallback route or host format regression.

---


### Phase 3 — Skill normalization in bounded batches

#### Agent context — Phases 3A through 3L

- **Goal:** Registry-backed skill identity/frontmatter and deterministic wrappers.
- **Entry gate:** Phase 2 complete; prior skill slice dual-approved, Full-passed, and committed.
- **Do not touch:** Agent runtime projections except shared registry imports; live hosts.
- **In scope:** Listed skills only, registry fields, canonical managed frontmatter, generated wrappers, manifests, baselines, tests.
- **Out of scope:** Other skill batches, rules/workflows, Apply.
- **Files expected:** exact slice paths; generated files/fixtures count toward cap.
- **Where to read context:** this plan; Phase 0 skill inventory; canonical skill bodies; host manifests.
- **Fast CI:**
  - `pwsh -NoProfile -File scripts/normalization/Invoke-NormalizationFastCI.ps1`
  - batch shadow comparison
  - `git diff --check`
- **Full CI before commit:**
  - `pwsh -NoProfile -File scripts/normalization/Invoke-NormalizationFullCI.ps1`
- **Deliverables:**
  - [ ] Explicit-only remains explicit-only.
  - [ ] Host applicability is explicit and matches approved inventory.
  - [ ] Methodology prose is not duplicated into wrappers.
  - [ ] Generated frontmatter is byte-stable.
  - [ ] Baseline churn limited to batch.
  - [ ] Full CI observed pass after dual approval.
- **Risks:** Changing skill discovery subsets unintentionally.

---


### Phase 4 — Rules/workflows/instructions in bounded batches

#### Agent context — Phases 4A through 4G

- **Goal:** Registry-backed composition without semantic overrides.
- **Entry gate:** Phase 3 complete; prior composition slice dual-approved, Full-passed, and committed.
- **Do not touch:** Live hosts, protected paths, unrelated projections.
- **In scope:** Listed rules/workflows/instructions, registry fields, renderer/tests, manifests, generated compositions, baselines.
- **Out of scope:** Other batches; Apply.
- **Files expected:** exact slice paths; generated files/fixtures count toward cap.
- **Where to read context:** this plan; Phase 0 composition inventory; canonical rules/workflows; manifests/SOPs.
- **Fast CI:**
  - `pwsh -NoProfile -File scripts/normalization/Invoke-NormalizationFastCI.ps1`
  - composition tests
  - `git diff --check`
- **Full CI before commit:**
  - `pwsh -NoProfile -File scripts/normalization/Invoke-NormalizationFullCI.ps1`
- **Deliverables:**
  - [ ] Always-on policy is explicit in registry.
  - [ ] Semantic order comes only from registry.
  - [ ] Host aliases cannot override canonical identity.
  - [ ] Managed and owner-owned regions remain separated.
  - [ ] Deterministic double-render passes.
  - [ ] Superseded checks retired.
  - [ ] Full CI observed pass after dual approval.
- **Risks:** Changing always-on gates unintentionally.

---


### Phase 5 — Documentation, guards, baselines, and roadmap

#### Agent context — Phase 5

- **Goal:** Durable discoverable architecture and final non-live verification.
- **Entry gate:** Phase 4 dual-approved and committed.
- **Do not touch:** Live host state.
- **In scope:** Orchestrator extensions, architecture/SOP/index docs, blocking guards, baselines, roadmap.
- **Out of scope:** New behavior; Apply.
- **Files expected:** existing orchestrators, docs/indexes/SOPs, static guards, baselines, roadmap.
- **Where to read context:** this plan; CI ladder; host-sync README; documentation architecture workflow.
- **Fast CI:**
  - `pwsh -NoProfile -File scripts/normalization/Invoke-NormalizationFastCI.ps1`
  - `git diff --check`
- **Full CI before commit:**
  - `pwsh -NoProfile -File scripts/normalization/Invoke-NormalizationFullCI.ps1`
  - all-host dry-run
  - read-only drift report
- **Deliverables:**
  - [ ] One Fast and one Full path remain.
  - [ ] Blocking guards enabled for all migrated classes.
  - [ ] Docs explain canonical change flow.
  - [ ] Baselines verify.
  - [ ] Roadmap copies accepted plan.
  - [ ] Full CI observed pass after dual approval.
- **Risks:** Docs drift or obsolete checks being retained.

---


### Phase 6 — Apply, restart, smoke, recovery, and closeout

#### Agent context — Phase 6

- **Goal:** Publish normalized projections and prove all-host convergence safely.
- **Entry gate:** Phase 5 dual-approved/committed, final Full passed, pre-Apply gates clean, and owner authorization recorded.
- **Do not touch:** Authentication, sessions/history/logs/databases, protected paths, unowned host state.
- **In scope:** All-host Apply, dry-run/drift, restart/smoke, targeted owner-authorized recovery, closeout docs.
- **Out of scope:** Source refactoring, push.
- **Files expected:** closeout/roadmap docs after final technical verification.
- **Where to read context:** this plan; operator matrix; host-sync README/SOPs; baseline paths; manifests.
- **Fast CI:** pre-Apply all-host dry-run.
- **Full CI before Apply:** `Invoke-NormalizationFullCI.ps1`.
- **Deliverables:**
  - [ ] Lifecycle/baseline gates confirmed for all seven hosts.
  - [ ] Owner authorization recorded.
  - [ ] Apply observed success.
  - [ ] Post-Apply dry-run/drift clean or unowned drift explicitly reported.
  - [ ] Restart/reload and smoke matrix complete.
  - [ ] 7x7 agent parity confirmed.
  - [ ] Final docs-only verification boundary recorded.
- **Risks:** Partial Apply or owner-owned live drift requires stop/recovery, not silent retry.


## Historical plan acceptance

Historical owner-accepted option: **Accept plan + recommended safety notes**. The plan had completed three clean-context `plan_reviewer` passes: pass 1 CHANGES REQUESTED; pass 2 CHANGES REQUESTED; pass 3 APPROVED with no blocking findings. The original owner options were: 1) accept the plan plus all four reviewer recommendations; 2) accept the plan as-is; or 3) request changes. This historical record does not change current Phase 0 status.
