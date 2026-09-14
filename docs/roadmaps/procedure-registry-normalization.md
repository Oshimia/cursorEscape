# Roadmap: Procedure Registry Normalization

```text
Status:              Phase 0 complete; Phase 1 complete; Phase 2A complete — planner parity committed 2026-09-13; Phase 2B complete — repository_explorer parity committed 2026-09-14; Phase 3A complete; Phase 3B complete
Plan review:         APPROVED, historical pass 3 of 3
Execution status:    Phase 0 complete; Phase 1 complete; Phase 2A complete; Phase 2B complete; Phase 3A complete; Phase 3B complete
Owner:               Repository owner
Conductor:           Composer-conducted, bounded slices
Plan source:         .plans/procedure-registry-normalization.md (historical approved-plan snapshot)
Last updated:        2026-09-14
Live Apply:          Phase 6 only, with explicit owner authorization
```

## Current execution status

Phase 0 was closed in good faith on 2026-09-11: renewed loop iteration 3 achieved dual approval, and Composer observed the Full CI set passing. A post-closeout integrated review reopened Phase 0 on 2026-09-13 because its current-state checker contract required corrections (explicit repository-root propagation and fail-closed historical-baseline behavior). The integrated correction cycle is now complete: the bounded corrections passed replacement dual review with production readiness APPROVED and the bug sweep CLEAN, and Composer observed final Fast and sole normalization Full CI before the local correction closeout commit.

Phase 1 recovery was closed in good faith on 2026-09-13: integration achieved dual approval after bounded correction loops, Composer observed the sole normalization Full CI passing, and the good-faith historical closeout commit `6fcb695` exists. The same post-closeout integrated review reopened Phase 1 on 2026-09-13 because the registry conflated frontmatter model-invocation disabling with explicit-only inventory policy. The integrated correction cycle is now complete: the bounded corrections passed replacement dual review with production readiness APPROVED and the bug sweep CLEAN, and Composer observed final Fast and sole normalization Full CI before the local correction closeout commit.

Final Composer closeout comprised observed Fast and sole normalization Full CI, the pre-commit gate, and one local correction commit; it does not authorize push or live Apply.

Phase 2A added explicit `planner` routes for Cursor and Antigravity plus Cline and Kilocode fresh-task/session fallbacks. It completed iteration 3 with production readiness APPROVED and `bug_reviewer` CLEAN, raising represented agent/host pairs from 33 to 37 of 49. Composer accepted the transparent 21-file scope deviation because the additional files were generated-ledger and route-map/index cascade required by must-fix findings; the slice remained under the 473 changed/new physical lines recorded for review. Final Fast and sole normalization Full CI passed, followed by the pre-commit gate; this roadmap row is closed by the Phase 2A slice commit that contains it.

The owner directed an efficiency-preserving recovery: retain the largely complete tree, review it in declared functional scopes, fix only review-identified defects, then run one integration reviewer pair and normalization Full CI. This exception does not authorize additional foundation expansion; the packed recovery contract governs the active recovery.

Phase 2B retained the efficiency-preserving recovery and closed through a separate bounded documentation-cascade correction. Composer-final Full CI then exposed one stale invariant: the `antigravity governed role defs under config/agents` expectation in `scripts/host-sync/Invoke-Phase2FastCI.ps1` still counted four destinations and was corrected to the manifest's five (including `repository_explorer`) in this working tree. The combined working tree now contains 21 files and 249 changed/new physical lines against baseline `1c87201`. The implementer-owned review used 2 of 4 iterations, ended with production readiness APPROVED and `bug_reviewer` CLEAN, and left no Batchable findings.

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
Composer Full CI:    PASS 2026-09-14
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
