# Roadmap: Procedure Registry Normalization

```text
Status:              Phase 0 complete; Phase 1 complete; Phase 2A complete — planner parity committed 2026-09-13; Phase 2B complete — repository_explorer parity committed 2026-09-14; Phase 2C-native complete; Phase 2C-fallback complete — Phase 2 parity 49/49; Phase 3A complete; Phase 3B complete; Phase 3C complete; Phase 3D complete; Phase 3E complete; Phase 3F complete; Phase 3G complete; Phase 3H complete; Phase 3I complete; Phase 3J complete; Phase 3K complete; Phase 3L complete; Post-Phase 3 batchable resolution complete; Phase 4A complete; Phase 4B complete — Phase 4 remains open, 4C next
Plan review:         APPROVED, historical pass 3 of 3
Execution status:    Phase 0 complete; Phase 1 complete; Phase 2A complete; Phase 2B complete; Phase 2C-native complete; Phase 2C-fallback complete — Phase 2 parity 49/49; Phase 3A complete; Phase 3B complete; Phase 3C complete; Phase 3D complete; Phase 3E complete; Phase 3F complete; Phase 3G complete; Phase 3H complete; Phase 3I complete; Phase 3J complete; Phase 3K complete; Phase 3L complete; Post-Phase 3 batchable resolution complete; Phase 4A complete; Phase 4B complete — Phase 4 remains open, 4C next
Owner:               Repository owner
Conductor:           Composer-conducted, bounded slices
Plan source:         .plans/procedure-registry-normalization.md (historical approved-plan snapshot)
Last updated:        2026-09-16
Live Apply:          Phase 6 only, with explicit owner authorization
```

## Current execution status

Phase 0 was closed in good faith on 2026-09-11: renewed loop iteration 3 achieved dual approval, and Composer observed the Full CI set passing. A post-closeout integrated review reopened Phase 0 on 2026-09-13 because its current-state checker contract required corrections (explicit repository-root propagation and fail-closed historical-baseline behavior). The integrated correction cycle is now complete: the bounded corrections passed replacement dual review with production readiness APPROVED and the bug sweep CLEAN, and Composer observed final Fast and sole normalization Full CI before the local correction closeout commit.

Phase 1 recovery was closed in good faith on 2026-09-13: integration achieved dual approval after bounded correction loops, Composer observed the sole normalization Full CI passing, and the good-faith historical closeout commit `6fcb695` exists. The same post-closeout integrated review reopened Phase 1 on 2026-09-13 because the registry conflated frontmatter model-invocation disabling with explicit-only inventory policy. The integrated correction cycle is now complete: the bounded corrections passed replacement dual review with production readiness APPROVED and the bug sweep CLEAN, and Composer observed final Fast and sole normalization Full CI before the local correction closeout commit.

Final Composer closeout comprised observed Fast and sole normalization Full CI, the pre-commit gate, and one local correction commit; it does not authorize push or live Apply.

Phase 2A added explicit `planner` routes for Cursor and Antigravity plus Cline and Kilocode fresh-task/session fallbacks. It completed iteration 3 with production readiness APPROVED and `bug_reviewer` CLEAN, raising represented agent/host pairs from 33 to 37 of 49. Composer accepted the transparent 21-file scope deviation because the additional files were generated-ledger and route-map/index cascade required by must-fix findings; the slice remained under the 473 changed/new physical lines recorded for review. Final Fast and sole normalization Full CI passed, followed by the pre-commit gate; this roadmap row is closed by the Phase 2A slice commit that contains it.

The owner directed an efficiency-preserving recovery: retain the largely complete tree, review it in declared functional scopes, fix only review-identified defects, then run one integration reviewer pair and normalization Full CI. This exception does not authorize additional foundation expansion; the packed recovery contract governs the active recovery.

Phase 2B retained the efficiency-preserving recovery and closed through a separate bounded documentation-cascade correction. Composer-final Full CI then exposed one stale invariant: the `antigravity governed role defs under config/agents` expectation in `scripts/host-sync/Invoke-Phase2FastCI.ps1` still counted four destinations and was corrected to the manifest's five (including `repository_explorer`) in this working tree. The combined working tree now contains 21 files and 249 changed/new physical lines against baseline `1c87201`. The implementer-owned review used 2 of 4 iterations, ended with production readiness APPROVED and `bug_reviewer` CLEAN, and left no Batchable findings.

Phase 2C-native adds only the four missing native `implementer` and `test_reviewer` routes on Cursor and Antigravity, raising represented pairs to 45 of 49. After replacement dual approval, Composer reconciled the historical six-stack render ledger and its derived inventory rows through the sanctioned writer, observed Full CI, and made local closeout commit `e007976`. The subsequent Phase 2C-fallback closes the final Cline/Kilocode implementer and test_reviewer pairs through explicit fresh-task/session contracts, reaching 49 represented / 0 missing of 49.

### Phase 1 recovery gates

1. Bootstrap outside the measured changeset: preserve the exact tree as a reference patch and baseline ledger under `.local/`; reconcile every changed/new/untracked path before recovery edits.
2. Review in functional scopes: data/schema, registry engine, rendering/semantic order, then CI/docs.
3. Tie every fix to an individually identified reviewer finding. Limit status/governance edits to individually predeclared status, index, or ledger text corrections.
4. Recompute and report the full physical-line ledger after each recovery step, including untracked files.
5. Enforce a cumulative recovery delta cap of 500 changed/new physical lines against the preserved baseline; warn and stop for Composer review at 400, and hard-stop at 500.
6. Run observed Fast CI at the end of each functional scope and again after integration fixes.
7. Run one integration production/bug pair over the complete Phase 1 tree; the bug reviewer remains tightly diff-focused and time-bounded.
8. Only after integration dual approval, Composer observes `Invoke-NormalizationFullCI.ps1`, runs the pre-commit gate, and creates the local Phase 1 commit.

## Phase 0 checklist

- [x] Complete migration-surface inventory.
- [x] 7x7 governed-agent parity matrix.
- [x] Per-host restart/smoke/recovery matrix.
- [x] Stale lifecycle documentation reconciled in this changeset.
- [x] Full CI observed pass (Composer, 2026-09-11).
- [x] Post-closeout integrated-review corrections complete and Composer-corrected status recorded.
- [x] Integrated-correction replacement dual approval and Composer closeout.

## Phase 1 recovery checklist (post-closeout corrections complete; closeout pending)

- [x] Registry catalogs and schema cover the Phase 0 inventory.
- [x] Fail-closed registry validator and canonical consistency checks.
- [x] Temporary deterministic managed-view renderer/checker and resolver seams.
- [x] Sole normalization Fast/Full entry points implemented.
- [x] Functional recovery review scopes completed.
- [x] Integration production/bug pair approved.
- [x] Dual reviewer approval.
- [x] Composer-observed normalization Full CI and closeout.
- [x] Post-closeout integrated-review corrections complete and Composer-corrected status recorded.
- [x] Integrated-correction replacement dual approval and Composer closeout.

## Product decisions

1. Registry is the sole writable source for canonical machine metadata and semantic composition order.
2. Canonical Markdown remains the sole writable source for procedure prose.
3. All seven governed child agents must be represented on all seven hosts, natively or through explicit fresh-task/session fallback.
4. Host aliases may route; they never replace canonical identity.
5. Skills may have explicit host non-applicability; governed agents may not.
6. Generated files, baselines, and current-state fixtures are never hand-edited.
7. Per-slice cap: maximum 15 directly reviewed files and 1,000 changed/new physical tracked lines, including generated, inventory-derived, test, script, doc, and roadmap lines.
   There is no post-hoc hand-authored reclassification. Modified files count added plus deleted lines; new files count their full physical length. At 800 lines the implementer must stop for a Composer scope check; at 1,000 lines it must return a cap-exhausted handoff without Fast or reviewers.
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
| Registry managed views | `Test-ProcedureRegistryViews.ps1` | Phase 1+ |
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

### Phase 2A — planner parity on Cursor, Antigravity, Cline, and Kilocode

- **Status:** complete.
- **Scope:** explicit `planner` route on the four previously missing hosts only.
- **Routes:** Cursor and Antigravity native host-definition wrappers (`overlays/cursor/agents/planner.md`, `overlays/antigravity/agents/planner.md`) with manifest copy entries; Cline and Kilocode explicit fresh-task/session fallback launch contracts in `overlays/cline/workflows/plan.md` and `overlays/kilocode/workflows/plan.md` — fresh task per planning pass; a reused conversation or empty response is a planning failure, never a valid planner result.
- **Unchanged:** OpenCode, Vscode, and Codex `planner` routes; Cursor Bugbot (U-Cursor-Bugbot left untouched); no other missing pairs migrated.
- **Slice shadow comparison:** `n/a` — no deterministic canonical→host shadow-comparison machinery exists yet (first generator/shadow seam is later Phase 2/3 render work; see U-Render-Baseline-Reconciliation). This slice's parity is enforced instead by the registry catalog↔inventory contract checks, fixture evidence-path validation, and the deterministic double-rendered managed view in Fast CI.
- **Six-stack ledger:** regenerated through `Get-ExistingSixStackRenderLedger.ps1 -WriteLedger` (repeatability verified). The ledger was already stale at baseline `fae5945` — last regenerated at `6a377c0`, while `fae5945` changed `rules/iterative-code-review.md`, which feeds all six stacks — so the regeneration also repairs that pre-existing drift; inventory ledger rows are synchronized.
- **Committed OpenCode C1 mirrors:** regenerated from the current planned dual-write render after Composer Full CI exposed the same pre-existing shared-rule drift at baseline `fae5945`. This generated-artifact repair is limited to the two byte-identical portable token mirrors and does not introduce new policy wording.
- **File-count deviation for Composer scope check:** the corrected slice touches 21 files versus the 15-file per-slice cap. The four initial routes required the declared registry/inventory/manifest/wrapper/workflow surface (16 files), and must-fix review corrections added the generated ledger plus the source-facing agent/overlay indexes and host SOP route maps. Flagged here transparently for Composer triage (split, accept, or direct further correction); no hand-authored reclassification is implied.

#### Phase 2A checklist

- [x] Registry catalog and Phase 0 inventory parity matrix reconciled for the four `planner` pairs (37 represented / 12 missing).
- [x] Cursor and Antigravity native wrappers plus manifest copy entries mirrored in the inventory.
- [x] Cline and Kilocode fresh-task/session fallback contracts.
- [x] Six-stack render ledger regenerated via the sanctioned generator and synchronized with the inventory.
- [x] Ambiguity records reconciled with the parity matrix (structured pending-missing pairs; fail-closed checker added).
- [x] Observed Fast CI and `git diff --check`; slice shadow comparison recorded `n/a` with reason above.
- [x] Dual review APPROVED.
- [x] Composer Full CI, pre-commit gate, and local commit.

---

#### Phase 2A deferred batchables (closed 2026-09-13)

- [x] Shared destination-count helper `Get-StackManifestDestinationCount` exported from `scripts/normalization/ProcedureRegistry.psm1`; the current-state checker and the six-stack render ledger derive the rule from that one fail-closed function. Ledger bytes verified unchanged (no regeneration required).
- [x] Inventory dates: JSON and Markdown keep the Phase 0 snapshot date `2026-09-11` and add last-updated `2026-09-13`; the checker validates presence, ISO format, ordering, and cross-surface agreement.
- [x] Cline/Kilocode SOP/overlay wording generalized to governed child-agent legs so the planner fallback is no longer excluded; pointers stay canonical (`workflow/agent-invocation.md`, `agents/planner.md`).
- [x] Focused mutation tests cover represented/unknown pending-ambiguity pairs, ledger destination-count mismatch, `MarkdownAmbiguity*` drift, and inventory-date drift via temporary fixtures.


### Phase 2B — repository_explorer parity on Cursor, Antigravity, Cline, and Kilocode

- **Status:** complete.
- **Scope:** explicit `repository_explorer` route on the four previously missing hosts only.
- **Routes:** Cursor and Antigravity native host-definition wrappers (`overlays/cursor/agents/repository_explorer.md`, `overlays/antigravity/agents/repository_explorer.md`) with manifest copy entries; Cline and Kilocode explicit fresh-task/session fallback contracts in `overlays/cline/footers/cline-wiring.md` and `overlays/kilocode/footers/kilocode-wiring.md` — fresh task per investigation pass; a reused conversation, empty response, or routing placeholder is a routing failure, never a valid result.
- **Unchanged:** OpenCode, Vscode, and Codex `repository_explorer` routes; Cursor Bugbot and `U-Cursor-Bugbot`; no other missing pairs migrated.
- **Slice shadow comparison:** `n/a` — no deterministic canonical→host shadow-comparison machinery exists yet (see `U-Render-Baseline-Reconciliation`). Parity is enforced by the catalog↔inventory contract checks, evidence-path validation, and the deterministic six-stack render ledger.
- **Six-stack ledger:** regenerated through `Get-ExistingSixStackRenderLedger.ps1 -WriteLedger` after the two native manifest additions and the two composed-rule footer changes.
- **Closeout (2026-09-14):** Cursor and Antigravity index/SOP documentation, the Cline governed-leg index, and the overlay provenance date were synchronized in a separate bounded correction slice. Implementer-owned review iteration 2 ended with production readiness APPROVED and `bug_reviewer` CLEAN; Composer observed final Fast and sole normalization Full CI, ran the pre-commit gate, and made one local closeout commit. Composer-final Full CI later exposed the stale `antigravity governed role defs under config/agents` count in `Invoke-Phase2FastCI.ps1`; the expectation was corrected from 4 to the manifest's five governed destinations (including `repository_explorer`) with the combined working-tree counts above recomputed accordingly.
- **Checklist:**
  - [x] Four missing `repository_explorer` routes implemented without changing OpenCode, VS Code, or Codex routes.
  - [x] Registry, inventory, current-state checks, and six-stack ledger updated through sanctioned mechanisms.
  - [x] Cursor, Antigravity, Cline, Kilocode, and overlay documentation cascades synchronized.
  - [x] Implementer-owned dual review APPROVED.
  - [x] Composer Full CI, pre-commit gate, and local commit.


---


### Phase 2C-native — implementer and test_reviewer native parity on Cursor and Antigravity

- **Status:** Phase 2C-native complete — Phase 2 fallback closeout pending.
- **Scope:** four previously missing pairs only: `Cursor|implementer`, `Cursor|test_reviewer`, `Antigravity|implementer`, and `Antigravity|test_reviewer`.
- **Routes:** Cursor native wrappers with canonical route identities (`implementer`, `test_reviewer`) and writable/read-only Task spawn metadata respectively; Antigravity native `invoke_subagent` wrappers using the established subagent structure. Antigravity `test_reviewer` preserves the existing read-only tool allowlist; `implementer` records canonical workspace-write authority without runtime attestation, and live-write smoke remains pending for Phase 6.
- **Cascade:** Composer triage produced a transparent one-time 20-file integrated-scope exception under the owner's explicit finish-Phase-2 direction—not a general cap increase. It authorized five review-required cascade files plus `ProcedureRegistry.psm1` comment correction. `Invoke-Phase2FastCI.ps1` derives the exact seven governed Antigravity agent routes; the Antigravity SOP records all seven routes; the Cursor SOP records six source-ready routes with two live; the canonical agent index links the new Cursor wrappers; and the top-level overlay index records the complete seven-route Antigravity set. After dual approval, Composer ran the sanctioned ledger writer, adding the generated six-stack ledger as a 21st mechanical closeout file. Live pickup and live-write smoke remain Phase 6.
- **Unchanged:** canonical contracts, OpenCode/Vscode/Codex routes, Cline and Kilocode routes, other SOPs outside the declared Cursor/Antigravity cascades, runtime projections, skills, and live hosts. No Phase 4 work is started.
- **Representation:** 45 represented / 4 missing of 49. `U-Antigravity-Authority` is closed because neither newly represented Antigravity pair remains pending; Cline/Kilocode route acceptance remains open for the four fallback closeout pairs.
- **Deferred Batchables (explicitly not implemented):** harden `NativeManifestEntry` to require exactly one wrapper-like evidence path before selection rather than selecting the first qualifying path; add focused source-level assertions for Antigravity `implementer` workspace-write wording and the Phase 6 runtime-attestation boundary; complete the historical-ledger comment-boundary clarification without regenerating or mutating historical ledger bytes.
- **Checklist:**
  - [x] Registry, Phase 0 inventory, manifests, wrappers, indexes, and current-state invariants reconciled for the four native pairs.
  - [x] Focused tests cover binding parity, evidence/manifest agreement, Cursor authority difference, Antigravity read-only test reviewer, exact 45/4 counts, and ambiguity closure.
  - [x] Renewed-block iteration-2 replacement dual review after observed Fast CI and `git diff --check`: production readiness APPROVED and `bug_reviewer` CLEAN; both reviewers closed.
  - [x] Historical ledger and derived inventory-row reconciliation through the sanctioned writer after dual approval.
  - [x] Composer observed sole normalization Full CI PASS after the generated-ledger closeout; pre-commit gate loaded. No live Apply.
  - [x] Phase 2 fallback closeout for Cline/Kilocode `implementer` and `test_reviewer`.


---

### Phase 2C-fallback — implementer and test_reviewer closeout on Cline and Kilocode

- **Status:** Phase 2C-fallback complete — Phase 2 parity 49/49.
- **Scope:** the final four pairs only: `Cline|implementer`, `Cline|test_reviewer`, `Kilocode|implementer`, and `Kilocode|test_reviewer`.
- **Routes:** one explicit all-role `fallback-launch-contract` workflow per host at `overlays/cline/workflows/agents.md` and `overlays/kilocode/workflows/agents.md`. Every governed role uses a separate fresh task/session per leg until attested native subtask isolation exists; the workflows state exact canonical envelope identity, first-read contract, authority, isolation, and loop/gate for `implementer` (workspace-write, `phase`) and `test_reviewer` (read-only, `test-review`). Each manifest delivers its new workflow exactly once.
- **Unchanged:** canonical contracts, planner/plan_reviewer/production_readiness_reviewer/bug_reviewer/repository_explorer route evidence, other hosts, runtime projections, skills, and live hosts. No Phase 4 work is started.
- **Representation:** 49 represented / 0 missing of 49. `U-Cline-Kilocode-Routes` retains the owner-acceptance record with no pending missing pairs.
- **Checklist:**
  - [x] Registry, Phase 0 inventory, manifests, workflow routes, indexes, SOPs, and focused tests reconciled for the four fallback pairs.
  - [x] Six-stack render ledger regenerated through the sanctioned writer and derived inventory rows synchronized.
  - [x] Observed Fast CI and `git diff --check` before the iteration-1 review; rerun after must-fix edits.
  - [x] Replacement-capable dual review within four iterations: production readiness APPROVED and `bug_reviewer` CLEAN at iteration 4; both reviewers closed. Iteration 1 captured must-fix cascade findings, iteration 3 ended in a Composer time-boundary process failure without verdicts, and iteration 4 completed the final review.
  - [x] Composer observed sole normalization Full CI PASS; pre-commit gate loaded. No live Apply.

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

#### Phase 3A status — Skill renderer/frontmatter builder/shadow comparison

```text
Status:              Complete; dual review APPROVED (iteration 1 of 4, 2026-09-14)
Observed Fast:       PASS 2026-09-14 (normalization Fast CI, 100/100 view checks, git diff --check)
Changed files:       5 directly reviewed files, 454 changed/new physical lines
Composer Full CI:    PASS 2026-09-15
Review launches:     production_readiness_reviewer 1; bug_reviewer 1; both closed
Batchables open:     2 (deferred; see punch list below)
```

Phase 3A added registry-owned skill frontmatter metadata (`description` with
explicit `folded-block`/`plain-scalar` physical-line style) for all 22
registered skills, a deterministic frontmatter builder, and a fail-closed
shadow comparison wired into the registry validator and the managed-view
renderer (`skill-frontmatter-shadow.tsv` reports every skill id, match/mismatch
status, and the canonical file's observed newline pattern). Byte comparison
follows the repo render-ledger convention — UTF-8 text after CRLF-to-LF and
exactly one terminal LF — so mixed historical line endings are explicit
evidence, never silently normalized; all 22 canonical files currently match.

- [x] Registry owns description metadata; canonical name remains the registry id.
- [x] Existing `modelInvocationDisabled` and `explicitOnly` semantics unchanged.
- [x] Fail-closed schema (`additionalProperties: false`) covers description shape.
- [x] Deterministic frontmatter builder emits delimiters, metadata, and terminal LF.
- [x] Shadow comparison covers all 22 skills; mismatches report invariant + skill id.
- [x] Shadow evidence exposed through the deterministic managed-view renderer; double-render byte-identical.
- [x] No runtime wrapper, overlay, host projection, manifest, or canonical skill file changed.
- [x] Dual review APPROVED (production readiness APPROVED with Blocking, Non-blocking code/process, and blocking test/docs all None; `bug_reviewer` CLEAN).
- [x] Composer Full CI observed pass after dual approval.

Batchable (deferred) punch list for a later slice (does not block approval):

1. Plain-scalar YAML type-ambiguity hardening: reject YAML-1.1 bool/null/number-like plain-scalar descriptions (e.g. exactly `no`, `on`, `null`, `42`) before Phase 3B regeneration.
2. Add a module-side negative test for a BOM-prefixed canonical skill file (currently fails closed via `SkillFrontmatterShape`, but the edge is untested).

---

#### Phase 3B status — implementation-plan / plan-review wrapper-frontmatter enforcement

```text
Status:              Complete; dual review APPROVED (iteration 3)
Observed Fast:       PASS 2026-09-14 (normalization Fast CI, 141/141 view checks, git diff --check)
Changed files:       5 directly reviewed files, 513 changed/new physical lines (498 added, 15 removed)
Composer Full CI:    PASS 2026-09-14
Review launches:     production_readiness_reviewer: 3, bug_reviewer: 3 (dual APPROVED at iteration 3)
Batchables open:     3 deferred (UTF-16/32 BOM fixtures, wrapper-extra-metadata fixture, profile-validation helper consolidation)
```

Phase 3B is an **enforcement-first migration slice**: the registry now owns
host-wrapper frontmatter identity for exactly `implementation-plan` and
`plan-review` through explicit host frontmatter profiles under the fail-closed
schema (`additionalProperties: false`), while canonical skill frontmatter
ownership from Phase 3A is preserved. Wrapper bodies and thin host procedure
prose are untouched; host wrapper descriptions intentionally differ from
canonical descriptions and are pinned exactly per wrapper source:

- Cursor — `implementation-plan` only.
- Shared OpenCode wrapper source — both skills; also covering Antigravity and VS Code.
- Codex wrapper source — both skills.

Declared `not-applicable` hosts must show no manifest entry delivering the
skill wrapper in the relevant destination surface. Routing is derived from the
existing Phase 0 manifest inventory seam (binding source plus overlay/shared
roots) — no second routing system and no manifest duplication. The
**no-baseline-churn boundary** held: no render baselines, manifests, wrapper
bodies, or canonical skill bodies changed.

- [x] Phase 3A deferred guard closed: YAML-1.1 bool/null/number-like plain-scalar descriptions (e.g. `no`, `on`, `null`, `42`) rejected; folded-block descriptions keep working.
- [x] Module-side negative test added for a BOM-prefixed canonical skill frontmatter/body fixture failing closed.
- [x] Registry-owned host frontmatter profiles added only for the two named skills; canonical id/name ownership and canonical descriptions unchanged.
- [x] Fail-closed wrapper-frontmatter shadow check runs for every applicable binding of both skills (name, exact description, effective `disable-model-invocation`), mismatches naming host and skill id.
- [x] `not-applicable` hosts assert wrapper absence in the manifest destination surface.
- [x] Managed view exposes `skill-host-frontmatter-shadow.tsv`; deterministic double-render covered by the existing hash loop (five files).
- [x] Focused tests: profile completeness/applicability, shared-source coverage, not-applicable absence, metadata mismatch, plain-scalar hardening, BOM rejection, deterministic double-render.
- [x] Phase 3B checks are integrated into the registry/views checks; no separate CI command is needed.
- [x] Observed Fast CI (normalization Fast CI + `git diff --check`).
- [x] Dual review APPROVED (production readiness + bug sweep CLEAN).
- [x] Composer Full CI observed pass after dual approval (no live Apply).

---

#### Phase 3C status — implementation-review / composer wrapper-frontmatter enforcement

```text
Status:              Complete; dual review APPROVED (iteration 1 of 4, 2026-09-14)
Observed Fast:       PASS 2026-09-14 (normalization Fast CI, view checks, git diff --check)
Changed files:       4 directly reviewed files, 246 changed/new physical lines (238 added, 8 removed)
Composer Full CI:    PASS 2026-09-14
Review launches:     production_readiness_reviewer: 1, bug_reviewer: 1 (both closed)
Batchables open:     1 deferred (source consolidation / cross-host equality evaluation; see below)
```

Phase 3C reuses the Phase 3B enforcement-first pattern without redesign.
The registry now owns host-wrapper frontmatter identity for exactly
`implementation-review` and `composer`, and the stale Phase 3B-only
profile-scope failure wording was generalized to the governed profile set.
Canonical skill frontmatter ownership from Phase 3A is preserved; the
canonical shadow comparison still covers all 22 registered skills.

Composer-resolved policy for this slice:

- **No source consolidation.** OpenCode, Antigravity, and VS Code wrapper
  sources stay separate even where current frontmatter bytes are identical;
  authored host deltas and the no-churn boundary are preserved.
- **Ten new profile objects.** Five per-source profiles per skill (Cursor,
  OpenCode, Antigravity, Vscode, Codex) pin exact description style/content
  and effective `disable-model-invocation` from the current wrappers.
- **Cursor disable-flag asymmetry preserved exactly as on disk.** Both Cursor
  wrappers carry `disable-model-invocation: true`; the other four wrappers per
  skill do not. No wrapper was rewritten to normalize this, and Cursor
  `user-rules-snippet.md` companions are untouched.
- **No cross-host equality invariant** was added in this slice; see the
  deferred batchable below.

The no-baseline-churn boundary held: no render baselines, manifests, wrapper
bodies, canonical skill bodies, or generated files changed.

- [x] Skill-host frontmatter profile allowlist extended with exactly `implementation-review` and `composer`.
- [x] Registry-owned per-source host frontmatter profiles added for the five applicable sources per skill (ten profile objects total).
- [x] Applicability enforced: `applicable` on Cursor, OpenCode, Antigravity, Vscode, and Codex; `not-applicable` on Cline and Kilocode through the Phase 0 manifest inventory seam.
- [x] Wrapper presence/routing and exactly-one manifest delivery enforced per applicable binding; not-applicable wrapper absence asserted for Cline and Kilocode.
- [x] Exact description and effective `disable-model-invocation` byte-comparison enforced per source; Cursor disable-flag asymmetry pinned, not normalized.
- [x] Stale Phase 3B-only profile-scope failure wording generalized to the governed host-frontmatter profile set.
- [x] Canonical descriptions and canonical/wrapper bodies unchanged; canonical frontmatter shadow still 22/22 matches.
- [x] Managed-view evidence grows from 14 to 28 wrapper rows; five-file deterministic double-render preserved.
- [x] Focused tests cover both new skills: profile coverage/scope, per-source routing, description/disable comparison, wrong-source routing, profile removal, not-applicable delivery injection, missing/duplicate manifest delivery, canonical shadow, row growth, deterministic double-render.
- [x] Observed Fast CI (normalization Fast CI + `git diff --check`).
- [x] Dual review APPROVED (production readiness APPROVED with Blocking, Non-blocking code/process, and blocking test/docs all None; `bug_reviewer` CLEAN).
- [x] Composer Full CI observed pass after dual approval (no live Apply).

Batchable (deferred) punch list for a later slice (does not block approval):

1. Evaluate whether identical OpenCode/Antigravity/VS Code wrapper sources
   should eventually be consolidated or governed by a cross-host equality
   invariant. Deferred deliberately under the Phase 3C no-churn boundary; any
   such move requires manifest/wrapper changes outside this slice.

---


#### Phase 3D status — discovery / documentation-architecture wrapper-frontmatter enforcement

```text
Status:              Complete; dual review APPROVED (iteration 2 of 4, 2026-09-14)
Observed Fast:       PASS 2026-09-14 (normalization Fast CI, 181 view checks and 24 unit checks, git diff --check)
Changed files:       4 permitted files, 169 changed/new physical lines (164 added, 5 removed)
Composer Full CI:    PASS 2026-09-14
Review launches:     production_readiness_reviewer 2; bug_reviewer 2 (dual APPROVED at iteration 2; both children closed)
Batchables open:     1 new deferred (Cursor disable-flag normalization/retention evaluation); 1 carried forward from Phase 3C
```

Phase 3D reuses the Phase 3B/3C enforcement-first pattern without redesign.
The registry now owns wrapper frontmatter identity for exactly `discovery`
and `documentation-architecture`. Canonical skill descriptions and wrapper
bodies remain unchanged; no baseline, manifest, wrapper, runtime, or schema
drift is introduced.

Composer-resolved policy:

- **Enforcement first, no churn.** Add fail-closed registry profiles and
  evidence; do not rewrite wrapper prose or normalize historical sources.
- **Shared-versus-distinct sources.** `discovery` has two profile objects:
  OpenCode shared source for OpenCode/Antigravity/Vscode plus distinct Codex;
  Cursor, Cline, and Kilocode are not applicable. `documentation-architecture`
  has three profile objects: distinct Cursor, OpenCode shared source for
  OpenCode/Antigravity/Vscode, and distinct Codex; Cline and Kilocode are not
  applicable.
- **Disable asymmetry pinned.** Cursor `documentation-architecture` remains
  `disable-model-invocation: true`; the OpenCode shared source and Codex
  wrappers remain false. No wrapper is rewritten and no cross-host equality
  invariant is added in Phase 3D.
- **Deferred batchable.** During later closeout, evaluate whether the
  Cursor-only disable asymmetry should be normalized or formally retained.

- [x] Governed profile-skill allowlist extended with exactly `discovery` and `documentation-architecture`.
- [x] Five registry-owned profile objects pin exact wrapper description style/content and effective disable policy.
- [x] Applicability and manifest routing enforced through the existing Phase 0 inventory/manifest seams.
- [x] Focused tests cover shared/distinct source topology, profile removal and uncovered/wrong routing, exact description/disable comparison, not-applicable injection, missing/duplicate delivery, canonical 22/22 shadow, exact wrapper-row growth, and deterministic five-file double-render.
- [x] Observed Fast CI before review (normalization Fast CI + `git diff --check`).
- [x] Dual review APPROVED (production readiness Blocking / Non-blocking / blocking test/docs all None; `bug_reviewer` CLEAN).
- [x] Composer Full CI observed pass after dual approval (no live Apply).

#### Phase 3E status — roadmap / research wrapper-frontmatter enforcement

```text
Status:              Complete; dual review APPROVED (iteration 1 of 4, 2026-09-14)
Observed Fast:       PASS 2026-09-14 (normalization Fast CI, 201 view checks and 24 unit checks, git diff --check)
Changed files:       4 permitted files, 171 changed/new physical lines (165 added, 6 removed)
Composer Full CI:    PASS 2026-09-14
Review launches:     production_readiness_reviewer 1; bug_reviewer 1 (dual APPROVED at iteration 1; both children closed)
Batchables open:     1 expanded deferred Cursor disable evaluation; 1 carried forward from Phase 3C
```

Phase 3E reuses the Phase 3B/3C/3D enforcement-first pattern without
redesign. The registry now owns wrapper frontmatter identity for exactly
`roadmap` and `research`. Canonical skill descriptions and wrapper bodies
remain unchanged; no baseline, manifest, wrapper, runtime, or schema drift is
introduced.

Composer-resolved policy:

- **Enforcement first, no churn.** Add fail-closed registry profiles and
  evidence; do not rewrite wrapper prose or normalize historical sources.
- **Profile topology.** `roadmap` has three profile objects: distinct Cursor,
  OpenCode shared source for OpenCode/Antigravity/Vscode, and distinct Codex;
  Cline and Kilocode are not applicable. `research` has one Codex-only profile;
  the other six hosts are not applicable. This is the first Codex-only
  governed wrapper-frontmatter slice.
- **Disable asymmetry pinned.** Cursor `roadmap` remains
  `disable-model-invocation: true`; its OpenCode shared source and Codex
  wrappers remain false. Codex-only `research` remains false. No wrapper is
  rewritten and no cross-host equality invariant is added in Phase 3E.
- **No explicit-only metadata.** Neither skill has `openai.yaml` or
  explicit-only metadata; none was added.
- **Expanded deferred batchable.** During later closeout, evaluate whether
  Cursor disable asymmetry should be normalized or formally retained for
  `roadmap` alongside the existing documented Cursor disable cases.

- [x] Governed profile-skill allowlist extended with exactly `roadmap` and `research`.
- [x] Four registry-owned profile objects pin exact wrapper description style/content and effective disable policy.
- [x] Applicability and manifest routing enforced through the existing Phase 0 inventory/manifest seams.
- [x] Focused tests cover exact managed-view row growth, shared/distinct topology, roadmap three-source topology, research one-source topology, profile removal, uncovered applicable hosts, wrong-source routing, exact description/disable comparison, roadmap Cursor disable mismatch, not-applicable injection, missing/duplicate delivery, canonical 22/22 shadow, and deterministic five-file double-render.
- [x] Observed Fast CI before review (normalization Fast CI + `git diff --check`).
- [x] Dual review APPROVED (production readiness Blocking / Non-blocking / blocking test/docs all None; `bug_reviewer` CLEAN).
- [x] No Full CI is claimed by this implementation slice.

Batchable (deferred) punch list for a later slice (does not block approval):

1. Evaluate Cursor `disable-model-invocation: true` asymmetry normalization or
   formal retention for `implementation-plan`, `implementation-review`,
   `composer`, `documentation-architecture`, and `roadmap`; any change requires
   wrapper churn outside Phase 3E.
2. Carry forward the Phase 3C evaluation of whether OpenCode/Antigravity/VS
   Code shared-source topology or cross-host equality governance should change;
   `roadmap` currently follows the existing no-churn shared-source pattern.


#### Phase 3F status — bug-review-sweep / diagnosing-bugs wrapper-frontmatter enforcement

```text
Status:              Complete; dual review APPROVED (iteration 1 of 4, 2026-09-14)
Observed Fast:       PASS 2026-09-14 (normalization Fast CI, 219 view checks and 24 unit checks, git diff --check)
Changed files:       4 permitted files, 124 changed/new physical lines (118 added, 6 removed)
Composer Full CI:    PASS 2026-09-14
Review launches:     production_readiness_reviewer 1; bug_reviewer 1 (dual APPROVED at iteration 1; both children closed)
Batchables open:     No new deferred; carried forward from Phase 3E
```

Phase 3F reuses the Phase 3B/3C/3D/3E enforcement-first pattern without
redesign. The registry now owns wrapper frontmatter identity for exactly
`bug-review-sweep` and `diagnosing-bugs`. Wrapper bodies, canonical bodies,
source topology, manifests, baselines, and runtime projections remain
unchanged; no explicit-only or `openai.yaml` metadata was added.

Composer-resolved policy:

- **Enforcement first, no churn.** Add fail-closed registry profiles and
  evidence; do not rewrite wrapper prose or normalize historical sources.
- **Profile topology.** `bug-review-sweep` has one Codex-only profile; all
  other six hosts are not applicable. `diagnosing-bugs` has two profile
  objects: a shared OpenCode physical source covering OpenCode, Antigravity,
  and Vscode, and a distinct Codex source; Cursor, Cline, and Kilocode are
  not applicable. Neither skill has a Cursor wrapper.
- **Disable policy pinned.** Both wrapper profiles pin effective
  `modelInvocationDisabled: false` matching current wrappers. No cross-host
  equality invariant is added in Phase 3F.
- **No explicit-only metadata.** Neither skill has `openai.yaml` or
  explicit-only metadata; none was added.
- **No new Cursor asymmetry batchable.** Neither skill has a Cursor wrapper,
  so the deferred Cursor disable evaluation is not expanded.

- [x] Governed profile-skill allowlist extended with exactly `bug-review-sweep` and `diagnosing-bugs`.
- [x] Three registry-owned profile objects pin exact wrapper description style/content and effective disable policy.
- [x] Applicability and manifest routing enforced through the existing Phase 0 inventory/manifest seams.
- [x] Focused tests cover exact managed-view row growth (56→70), bug-review-sweep Codex-only topology, diagnosing-bugs shared/distinct topology, profile removal, uncovered applicable hosts, wrong-source routing, exact description/disable comparison, disable mismatch, not-applicable injection, missing/duplicate delivery, canonical 22/22 shadow, and deterministic five-file double-render.
- [x] Observed Fast CI before review (normalization Fast CI + `git diff --check`).
- [x] No Full CI is claimed by this implementation slice.


#### Phase 3G status — architecture-survey / codebase-design wrapper-frontmatter enforcement

```text
Status:              Complete; dual review APPROVED (iteration 1 of 4, 2026-09-14)
Observed Fast:       PASS 2026-09-14 (normalization Fast CI, 243 view checks, git diff --check)
Changed files:       4 permitted files
                     122 changed/new physical lines (115 added, 7 removed)
Review launches:     production_readiness_reviewer 1; bug_reviewer 1 (dual APPROVED at iteration 1; both children closed)
Composer Full CI:    PASS 2026-09-14
Batchables open:     No new deferred; carried forward from Phase 3E
```

Phase 3G reuses the Phase 3B/3C/3D/3E/3F enforcement-first pattern without
redesign. The registry now owns wrapper frontmatter identity for exactly
`architecture-survey` and `codebase-design`. Wrapper bodies, canonical bodies,
source topology, manifests, baselines, and runtime projections remain
unchanged; no explicit-only or `openai.yaml` metadata was added.

Composer-resolved policy:

- **Enforcement first, no churn.** Add fail-closed registry profiles and
  evidence; do not rewrite wrapper prose or normalize historical sources.
- **Profile topology.** Both skills have exactly one Codex-only profile; all
  other six hosts are not applicable. Neither skill has a Cursor or shared
  OpenCode wrapper.
- **Disable policy pinned.** Both wrapper profiles pin effective
  `modelInvocationDisabled: false` matching current wrappers. No cross-host
  equality invariant is added in Phase 3G.
- **No explicit-only metadata.** Neither skill has `openai.yaml` or
  explicit-only metadata; none was added.
- **No new Cursor asymmetry batchable.** Neither skill has a Cursor wrapper,
  so the deferred Cursor disable evaluation is not expanded.

- [x] Governed profile-skill allowlist extended with exactly `architecture-survey` and `codebase-design`.
- [x] Two registry-owned profile objects pin exact wrapper description style/content and effective disable policy.
- [x] Applicability and manifest routing enforced through the existing Phase 0 inventory/manifest seams.
- [x] Focused tests cover exact managed-view row growth (70→84), architecture-survey Codex-only topology, codebase-design Codex-only topology, profile removal, uncovered/not-applicable coverage, wrong-source routing, exact description/disable comparison, disable mismatch, not-applicable delivery injection, missing/duplicate delivery, canonical 22/22 shadow, and deterministic five-file double-render.
- [x] Observed Fast CI before review (normalization Fast CI + `git diff --check`).
- [x] No Full CI is claimed by this implementation slice.


#### Phase 3H status — domain-modeling / grilling / prototype wrapper-frontmatter enforcement

```text
Status:              Complete; dual review APPROVED (iteration 2 of 4, 2026-09-14)
Observed Fast:       PASS 2026-09-14 (normalization Fast CI, 273/273 view checks, 24/24 unit checks, git diff --check)
Changed files:       4 directly reviewed files, 79 implementation changed/new physical lines before this roadmap row
                     113 final changed/new physical lines (105 added, 8 removed)
Review launches:     production_readiness_reviewer: 2, bug_reviewer: 2 (dual APPROVED at iteration 2); all children closed
Composer Full CI:    PASS 2026-09-14
Batchables open:     No new deferred; carried forward from Phase 3E
```

Phase 3H reuses the Phase 3B–3G enforcement-first pattern without redesign. The
registry now owns wrapper frontmatter identity for exactly `domain-modeling`,
`grilling`, and `prototype`. Companion registry inventory, manifests, and current
wrapper sources establish the same topology independently for each skill: one
Codex-only applicable binding, six not-applicable hosts, canonical body
`skills/<id>/SKILL.md`, and manifest-routed wrapper
`overlays/codex/skills/<id>/SKILL.md`. Wrapper bodies, canonical bodies,
manifests, baselines, and runtime projections remain unchanged.

- [x] Three registry-owned Codex profiles pin exact wrapper plain-scalar descriptions and effective `modelInvocationDisabled: false` matching current wrappers.
- [x] Canonical folded descriptions, canonical disable policies, and explicit-only semantics remain unchanged; canonical 22/22 frontmatter shadow remains clean.
- [x] Governed profile-skill allowlist extended with exactly the three Phase 3H skills; outside-set profiles continue to fail closed.
- [x] Per-skill fail-closed tests cover profile removal, not-applicable applicability, exact Codex source routing, description and disable mismatches, not-applicable delivery injection, missing delivery, and duplicate delivery.
- [x] Managed-view evidence covers exact row growth 84→105, per-skill Codex-only applicability/absence, and deterministic five-file double render.
- [x] Observed Fast CI before review (normalization Fast CI + `git diff --check`).
- [x] No Full CI is claimed by this implementation slice.


#### Phase 3I status — tdd / resolving-merge-conflicts wrapper-frontmatter enforcement

```text
Status:              Complete; dual review APPROVED (iteration 1 of 4, 2026-09-14)
Observed Fast:       PASS 2026-09-14 (normalization Fast CI, 293/293 view checks, 24/24 unit checks, git diff --check)
Changed files:       4 directly reviewed/permitted files, 87 final changed/new physical lines (82 added, 5 removed)
Review launches:     production_readiness_reviewer: 1, bug_reviewer: 1 (dual APPROVED at iteration 1); all children closed
Composer Full CI:    PASS 2026-09-14
Batchables open:     No new deferred; carried forward from Phase 3E
```

Phase 3I reuses the Phase 3B–3H enforcement-first pattern without redesign. The
registry now owns wrapper frontmatter identity for exactly `tdd` and
`resolving-merge-conflicts`. Companion inventory, manifests, and wrappers establish
the same topology independently for each: one Codex-only applicable binding, six
not-applicable hosts, canonical body `skills/<id>/SKILL.md`, and wrapper
`overlays/codex/skills/<id>/SKILL.md`. Canonical bodies and wrapper prose remain
unchanged.

- [x] Two registry-owned Codex profiles pin exact plain-scalar wrapper descriptions and effective `modelInvocationDisabled: false`.
- [x] Governed profile allowlist extended with exactly the two Phase 3I skills; outside-set profiles continue to fail closed.
- [x] Per-skill tests cover applicability/absence, source routing, description and disable mismatches, not-applicable injection, missing/duplicate delivery, canonical 22/22 shadow, exact 105→119 row growth, and deterministic five-file double render.
- [x] Observed final Fast CI and whitespace checks; no Full CI, commit, push, or live Apply is claimed by this implementation slice.


#### Phase 3J status — teach / wait-what / wizard wrapper-frontmatter enforcement

```text
Status:              Complete; dual review APPROVED (iteration 1 of 4, 2026-09-14)
Observed Fast:       PASS 2026-09-14 (normalization Fast CI, 328/328 view checks, 24/24 unit checks, git diff --check)
Changed files:       4 directly reviewed/permitted files, 91 changed/new physical lines (83 added, 8 removed)
Review launches:     production_readiness_reviewer: 1, bug_reviewer: 1 (dual APPROVED at iteration 1); all children closed
Composer Full CI:    PASS 2026-09-14
Batchables open:     No new deferred; carried forward from Phase 3E
```

Phase 3J reuses the Phase 3B–3I enforcement-first pattern without redesign. The
registry now owns wrapper frontmatter identity for exactly `teach`, `wait-what`,
and `wizard`. Companion inventory, manifests, and current wrapper sources establish
the same topology independently for each: one Codex-only applicable binding, six
not-applicable hosts, canonical body `skills/<id>/SKILL.md`, and wrapper
`overlays/codex/skills/<id>/SKILL.md`. Canonical bodies, canonical folded
descriptions, canonical disable policies, wrapper prose, manifests, and schema
remain unchanged.

- [x] Three registry-owned Codex profiles pin exact plain-scalar wrapper descriptions and effective `modelInvocationDisabled: false` matching current wrappers.
- [x] Governed profile allowlist extended with exactly the three Phase 3J skills; outside-set profiles continue to fail closed.
- [x] Per-skill tests cover applicability/absence, source routing, description and disable mismatches, not-applicable injection, missing/duplicate delivery, canonical 22/22 shadow, exact 119→140 row growth, and deterministic five-file double render.
- [x] Observed final Fast CI and whitespace checks before the review pair; no Full CI, commit, push, or live Apply is claimed by this implementation slice.


#### Phase 3K status — opencode-headless-run / opencode-history-search wrapper-frontmatter enforcement

```text
Status:              Complete; dual review APPROVED (iteration 3 of 4, 2026-09-14)
Observed Fast:       PASS 2026-09-14 (normalization Fast CI, 360/360 view checks, 24/24 unit checks, git diff --check)
Changed files:       4 directly reviewed/permitted files
                     199 final changed/new physical lines (191 added, 8 removed)
Review launches:     production_readiness_reviewer: 3 (iteration 1 APPROVED, iteration 2 CHANGES REQUESTED, iteration 3 APPROVED); bug_reviewer: 3 (iteration 1 must-fix, iterations 2–3 CLEAN); dual APPROVED at iteration 3 of 4; all children closed
Composer Full CI:    PASS 2026-09-14
Batchables open:     No new deferred; 2 carried forward from Phases 3C and 3E
```

Phase 3K reuses the Phase 3B–3J enforcement-first pattern without redesign. The
registry now owns wrapper frontmatter identity for exactly `opencode-headless-run`
and `opencode-history-search`, the two remaining explicit-only Phase 0 skills.
Companion inventory, manifests, and current wrapper sources establish the actual
wrapper/source topology independently for each. `opencode-headless-run` has 3
profiles (Cursor / shared OpenCode+Antigravity+Vscode / Codex);
`opencode-history-search` has 5 authored per-host wrapper sources. Both pin
effective `modelInvocationDisabled: false` and remain `explicitOnly: true`.
Canonical bodies, canonical folded descriptions, wrapper prose, manifests, and
schema remain unchanged.

- [x] Registry-owned profiles pin exact wrapper descriptions and effective disable/model-invocation policy matching current wrappers.
- [x] Governed profile allowlist extended with exactly the two Phase 3K skills; all 22 catalog skills are now governed.
- [x] Per-skill tests cover explicit-only policy, applicability/absence, source routing, description and disable mismatches, wrong-source routing, not-applicable injection, missing/duplicate delivery, canonical 22/22 shadow, exact 119→154 row growth, and deterministic double render.
- [x] Observed final Fast CI and whitespace checks before the review pair; no Full CI, commit, push, or live Apply is claimed by this implementation slice.


#### Phase 3L status — blocking skill closeout guard and applicability verification

```text
Status:              Complete; dual review APPROVED (iteration 1 of 4, 2026-09-14)
Observed Fast:       PASS 2026-09-14 (normalization Fast CI, 362/362 view checks, 24/24 unit checks, git diff --check)
Changed files:       3 directly reviewed/permitted files (roadmap is the post-approval status-only cascade)
                     59 final changed/new physical lines (56 added, 3 removed)
Review launches:     production_readiness_reviewer: 1 (APPROVED); bug_reviewer: 1 (CLEAN); dual APPROVED at iteration 1 of 4; all children closed
Composer Full CI:    PASS 2026-09-14
Batchables open:     No new deferred
```

Phase 3L adds the registry-owned fail-closed Phase 3 blocking closeout guard.
Rendering and validation now require the registered catalog skill set, the
Phase 0 canonical skill inventory, and the governed host-frontmatter profile
identity set to be the same exact 22 skills. Tests prove uncovered governed
catalog and outside/non-governed identity mutations fail through
`SkillHostFrontmatterProfileGuard`. Existing Phase 3A–3K checks continue to
fail closed for uncovered applicable hosts, wrong wrapper source, missing or
duplicate delivery, invalid not-applicable injection, and wrapper description
or disable-policy mismatch.

- [x] All 22 catalog skills are governed and have registry-owned host-frontmatter coverage.
- [x] Canonical shadow coverage is exactly 22/22 matches; wrapper applicability is exactly 154 rows: 59 applicable matches, 95 explicit not-applicable, and 0 mismatch across seven hosts.
- [x] `explicitOnly` and `modelInvocationDisabled` remain separately validated; the two explicit-only skills remain invocable, while registry/inventory/schema checks preserve each policy independently.
- [x] Sanctioned temporary render reconciliation found no drift; deterministic double render passed and no generated baseline changed.
- [x] Review pair inspected the code/test diff at iteration 1; roadmap status was added only after dual approval.
- [x] Observed final Fast CI and whitespace checks after the status-only roadmap cascade; no Full CI, commit, push, or live Apply is run or claimed by Phase 3L implementation.


#### Post-Phase 3L batchable resolution

```text
Status:              Complete; docs-only governance resolution (2026-09-14)
Scope:               Two carried Phase 3 batchables formally resolved; no wrapper, canonical skill, catalog, schema, baseline, runtime projection, or test changed
Changed files:       4 directly reviewed/permitted docs files; 76 final changed/new physical lines (68 added, 8 removed)
Observed Fast:       PASS 2026-09-14 (normalization Fast CI, 362/362 view checks, 24/24 unit checks, git diff --check)
Review launches:     production_readiness_reviewer: 2, bug_reviewer: 2 (dual APPROVED at iteration 2); all children closed
Composer Full CI:    PASS 2026-09-14
Batchables open:     None; the reviewer-identified stale roadmap-index row was corrected as a Composer-only status/index correction
Phase 4:             Not started
```

**Resolution 1 — Cursor `disable-model-invocation: true` asymmetry: formally retained.** The Cursor-specific flag remains set for exactly `implementation-plan`, `implementation-review`, `composer`, `documentation-architecture`, and `roadmap`. The flag is part of Cursor skill-advertisement/load mechanics, not a license for hosts to override canonical procedure ownership. Registry profiles remain the fail-closed source of each wrapper's exact description and effective invocation metadata. Cross-host behavior remains governed by canonical procedure and registry contracts; the differing flag is an intentional host-mechanics deviation, not historical drift. Durable policy recorded in [skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md).

**Resolution 2 — OpenCode / Antigravity / VS Code shared-source topology and cross-host equality: formally retained.** The current topology is retained. Use a shared physical source only when host mechanics are genuinely identical; retain separate sources where authored host deltas exist. Equality is enforced at the governed semantic/metadata boundary by registry profiles and applicability checks, not by requiring unrelated wrapper sources to be byte-identical or by collapsing sources solely to reduce file count. Durable policy recorded in [skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md).

**Evidence summary.** The Phase 3C batchable (source consolidation / cross-host equality evaluation) and the Phase 3D/3E expanded batchable (Cursor disable-flag normalization/retention evaluation) are both closed as formal retention decisions. No source consolidation was performed; no wrapper bodies, canonical skill bodies, manifests, baselines, schema, runtime projection, or test files were changed. No Full CI, commit, push, or live Apply is claimed by this docs-only resolution.

**Phase 4 remains open.** This resolution changes no production behavior and clears no Phase 4 deliverable; the later Phase 4A machinery slice is tracked separately below.


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

#### Phase 4A — Composition machinery (no runtime switch)

- **Status:** Phase 4A complete — overall Phase 4 remains open; 4B next.
- **Boundary:** Composition renderer, semantic-order validator, and managed-boundary verifier only. No host adapter, manifest runtime, live host, canonical body, or substantive procedure text migrated.
- **Evidence:**
  - [x] Registry semantic order controls composed output order.
  - [x] Reference concatenation is deterministic from resolved registry references.
  - [x] Unresolved, duplicate, and missing references fail closed.
  - [x] Canonical body, overlay leaf, protected tree, and host projection boundaries reject composition output.
  - [x] Deterministic double render is byte-identical.
  - [x] Existing 49/49 parity and host-sync behavior unchanged.
  - [x] Implementer-owned review completed at iteration 2: production readiness APPROVED and `bug_reviewer` CLEAN; both reviewers closed.
  - [x] Three deferred Batchables recorded: composition-specific source-ingress wrapper naming, tighter reference-grammar allowlist, and renderer-level `SemanticOrderMissingId` coverage.
  - [x] Composer observed sole normalization Full CI PASS; pre-commit gate loaded. No live Apply or runtime switch.

#### Phase 4B — Always-on policy registry (Cursor, OpenCode, Codex, Antigravity)

- **Status:** Phase 4B complete — overall Phase 4 remains open; 4C next.
- **Boundary:** Registry-owned always-on declarations and fail-closed validation only. No manifest/adapter runtime migration, canonical prose change, generated baseline change, or live-host write.
- **Evidence:**
  - [x] Exactly 16 policies cover invocation, plan review, code review, and pre-commit for Cursor, OpenCode, Codex, and Antigravity.
  - [x] Host/gate uniqueness, canonical-reference resolution, surface validity, tracked evidence existence, and inventory mirroring fail closed.
  - [x] Deterministic managed-view output records the policy set without changing runtime writers.
  - [x] Existing Phase 4A behavior and 49/49 agent parity remain covered.
  - [x] Implementer-owned review completed at iteration 1: production readiness APPROVED and `bug_reviewer` CLEAN; both reviewers closed.
  - [x] Four deferred Batchables recorded: inventory-mismatch mutation tests, durable Git-tracked evidence invariant, removal of redundant test canonical-ref allowlist, and registry-level unique policy-ID enforcement.
  - [x] Composer observed sole normalization Full CI PASS; pre-commit gate loaded. No live Apply.

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
