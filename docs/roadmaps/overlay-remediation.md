# Roadmap: Overlay architecture remediation (overlays carry only host differences)

**Status:** Phase 1 complete (Reviewer A APPROVED iter 2; awaiting Phase 2) · Last updated: 2026-08-28 · Conductor: Composer (assigned this thread)
**Source plan:** approved 2026-08-28 (plan-review APPROVED, fresh-loop pass 3; 6 total review passes). Copied fail-closed per roadmap skill (Escalation was **yes**).

## Product decisions (locked by owner)

| Decision | Ruling |
| -------- | ------ |
| Bug review leg | **Owner ruling this thread: `bug_reviewer` NOT run on phase work** — each phase's review loop = clean `production_readiness_reviewer` (Reviewer A) passes only. Recorded as the deliberate single-reviewer deviation for this program; NOT a portable-software default. |
| Reviewer model | No hard-coded models in agent files (portable-contract doctrine); picker default is SoT per host. |
| Model enumeration | Never enumerate model slugs anywhere in repo/docs (drift-prone) — picker default is SoT. |
| Inventory parity | OpenCode overlay inventory (11 skill stubs + 8 agent harnesses) is the authored thin-harness reference; parity bar for new stacks. `opencode-*` pair global on every stack (2026-08-26 ruling). |
| Overlay authorship doctrine | Overlays carry ONLY host differences (Promotion rule: "dual overlays of procedure is the bug"). Tier-1 condensed stubs stay authored (by design). |
| SoT relocation clause | Content-preserving mechanical SoT re-location (e.g. split/red-line sections) is permitted and declared — composition-enabling, not semantic. |
| Regression substrate | Golden expected-renders per composed dest + dry-run content-capture hook (pre-migration anchor + tag/cross-checkout machinery deleted per fresh-loop pass 2). |
| Apply norm | Global `-Apply` default; per-stack deviation only for surfaced drift with `-AllowSkew` justification recorded; OpenCode re-baseline before any OpenCode Apply. |

## Goal

The repo conforms to its own locked Promotion Rule (skill-source-and-host-overlays.md): "Same paragraph appearing in two overlays → shared; promote it. Dual overlays of procedure is the bug." Concretely: (1) the sync machinery can source copy-out content from repo-root SoT and shared overlay sources, not only each stack's overlay dir; (2) overlays/antigravity/ stops being a hand-maintained literal copy of overlays/opencode/ — stubs/agents/GEMINI derive at sync time; (3) the always-on gate body is composed from rules/ SoT (promote-into-twin) instead of hand-restated per host; (4) the latent CI drifts found in the dossier are fixed; (5) the parked VSCode overlay bring-up later inherits base: sourcing (out of scope here — follow-on consumer).

## Scope (from accepted plan — copied verbatim in intent)

- **Machinery (Phase 1):** HostSync.Core.ps1 per-entry v2 — source classes (`base:` repo-root / `shared:` SharedRoot knob / plain backward-compat) resolved in Copy-ManifestEntry (~344-387; OverlayRoot-only at ~363 today); per-entry fail-closed Substitutions (exactly-once, no-match = hard render error) + Footer/Parts file-reference concatenation via a shared Core render helper invoked from the EXISTING CopyEntries loop; skew-guard extension (Get-CrossStackSourceOverlap, Register-StackAdapters.ps1 ~44-64) at whole-leaf (Dest) granularity keyed on SOURCE + sibling stacks (not Dest strings; substitution-set aware; degeneration documented); dry-run content-capture hook (Copy-ManifestEntry dry-run gains content-emitting mode). NO DerivedSets; NO ComposedLeaves top-level key. Adapters: Cursor + Antigravity minimal pass-through; OpenCode also carries the D7 dual-write render-path change (Invoke-OpenCodeAgentsDualWrite consumes RENDERED source via shared Core helper — composed instructions leave no authored file; AGENTS≡instructions hash assert still passes; composed-entry skip-check semantics folded into D7 design).
- **Gate composition — PROMOTE-INTO-TWIN:** neutral gate prose promoted into rules/iterative-plan-review.md + rules/iterative-code-review.md (existing 12-line Cursor-inflected twins upgraded to shared neutral leaves = the SINGLE SoT for Cursor hybrid render (Get-PlannedHybridRuleContent mechanics unchanged, input text changes by design → cursor .mdc output intentionally changes; golden re-pin, NOT byte-stability), OpenCode instructions, and Antigravity GEMINI gates). Promotion = mechanical relocation with declared expansion of twins to neutral prose. Cursor .mdc post-promotion renders are the golden comparison surface.
- **Red line — WHOLESALE SECTION MOVE, gated by D9:** move the ENTIRE `### Red line (Required)` section (git + shell fs mutations together) into rules/red-line.md, shell-native-tool-policy.md referencing it; downstream git-heavy sections (Accepted risks, Residual asks) move/re-home per D9 severability audit (written go/no-go); "Instruction echo" fenced block DISPOSED in the same changeset (fourth drift-capable home eliminated). If D9 = no-go → composed gates keep a host-agnostic red-line FOOTER leaf (one shared source) instead.
- **Migration (Phase 2):** antigravity 11 stubs → mostly `shared:` rows referencing opencode authored stubs + substitution map ONLY where real host deltas exist (composer, implementation-review confirmed; roadmap path line — pin at D2); agents ×3 → host-frontmatter overlay files + body via shared: mechanism pinned at D2 (frontmatter/body split); GEMINI.md → composed (promoted-twin bodies + red-line source + host wiring footer leaf); escape-* workflows → shrink to point/spawn-only; pre-commit stubs ×2 → composed from base:rules/pre-commit-ci-gate.md; opencode instructions → composed (same mechanism; dual-write flows via D7 change); cursor user-rules-snippets ×3 (A-class) → disposition per D3.
- **Golden renders:** one committed golden expected-render per composed dest (post-migration) = THE regression surface for composed class. Byte-equality class (relocations/whole-file shares): direct diff vs shared/overlay source + dry-run content-capture hook. Per-class compare basis stated in ONE place in the remediation-checks spec.
- **CI (Phases 2–3):** D4 map = full enumeration of all 7 Invoke-Phase*.ps1 asserts WITH current line numbers, incl. VACUOUS class (hygiene sweeps walking soon-deleted files); deletion/relocation→assert-rework map; SAME-CHANGESET rule (asserts reworked in the same Phase 2 changeset as the deletions that break them); single owning phase per assert; Apply-leg scripts (Phase2FullCI) DEFERRED to Phase 4 entirely; NEW Invoke-Phase2-RemediationChecks.ps1 (golden equality, gate-atom survival incl. host-wiring tails, single-source-per-Dest, fail-closed substitution, residual-marker, PERSISTENT 12k rendered-size).
- **Docs cascade (Phase 3):** overlays/_index ×3; SOPs ×3 (antigravity count fixes, author-time specimen updates, backup-is-restore-snapshot note, SOP C-table gate-text citation reconciliation after echo disposal); FA leaves (skill-source-and-host-overlays v2 recording; permission-and-native-tool-policy red-line SoT pointer); rules/_index.md rows; scripts/host-sync/README.md (v2 per-entry manifest surface — public machinery); editing-companion-workflow.md (per-cell link repair + rows); docs/roadmaps/overlay-remediation.md (this file) + _index row + docs/Roadmap.md status rows; analysis note (migration record).
- **Out of scope:** VSCode overlay bring-up (follow-on consumer); portable SoT SEMANTIC changes (content-preserving mechanical re-location IS permitted and declared); live-tree wholesale re-sync beyond Phase 4 verification; baseline policy; multi-machine sync.

## Inter-phase contracts (from accepted plan)

- **Schema v2 (per-entry):** Source = 'base:...' | 'shared:...' | plain (overlay-relative); optional Substitutions = ordered find/replace pairs, FAIL-CLOSED exactly-once; optional Footer/Parts = file references only (never inline text); plain Source+Dest entry = today's behavior (backward compat); SharedRoot = named manifest-level knob. Single-source-per-Dest inherent. No per-key adapter dispatch — adapters pass through manifest/entry fields only.
- **Promote-into-twin:** rules/iterative-*.md become the shared neutral gate leaves; Cursor hybrid mechanics unchanged (input changes by design); OpenCode/Antigravity gates compose = promoted bodies + host wiring footer leaf. Echo block disposed in same changeset as promotion.
- **Golden-render substrate:** composed-dest class → committed golden expected-renders = regression surface (no per-line declared-diff needed; gate-atom assert retained separately). Relocation/whole-file class → equality vs source via content-capture hook. Per-class basis stated once in remediation-checks spec.
- **D9 gate:** severability go/no-go (written) BEFORE D2 pin; no-go → shared red-line FOOTER leaf fallback.
- **D2 gate:** mini-fixture proof covering EVERY field class + extraction cases (agent frontmatter/body mechanism; promo-twin concat) + fail-closed no-match + golden-render mechanics + skew-identity canonicalization — BEFORE Phase 1 entry.
- **D5 gate:** composed-gate feasibility VERDICT (promotion reproducible, atoms incl. host-wiring tails, <12k) — Phase 0/1 boundary; blocks Phase 1.
- **Single-owner-per-assert:** D4 map names exactly one owning phase per assert (expectedNine/Count-9 ambiguity resolved there).
- **Skew-guard:** source-identity + sibling awareness keyed on SOURCE; whole-leaf granularity; degeneration semantics documented in FA v2 recording.
- **Apply-leg quarantine:** Phase2FullCI (and all Apply-leg) scripts run only in Phase 4.
- **Review model:** per owner ruling — clean Reviewer A passes only (no bug_reviewer) on phase work; ≤4 iterations per pressure-release block; cap-exhausted handoff → Composer triage.

## Migration / external apply order

- Repo-side: machinery + promotion (Phase 1) → manifests+overlays+assert-rework (Phase 2) → CI retirement+docs (Phase 3). No live Apply required for Phases 1–3 correctness (dry-run derivable). Phase 4: fresh live-vs-planned comparison; per-stack Apply ONLY for surfaced drift (owner authorization; OpenCode re-baseline first); collapse to dry-run+smoke if D1 shows no drift.

## Phase checklist

- [x] **Phase 0 — ground truth + gates (read-only):** 7-script CI matrix (known-red baseline: Phase2FastCI expectedNine, Count-9); D9 severability audit (WRITTEN verdict); D2 schema mini-fixture PROOF (all field classes + extraction cases + golden mechanics); D5 feasibility VERDICT (promotion reproducible, atoms incl. host-wiring tails, <12k); D1 live-tree inventory ×3 stacks (feeds Phase 4 Apply-vs-collapse); D3 snippet disposition; D4 full CI enumeration (current line numbers, vacuous class, deletion/relocation→rework map, single-owner-per-assert); D6 unit-check home; D7 dual-write render-path design; D8 persistent-12k assert design. No repo edits (scratch only).
- [x] **Phase 1 — machinery + SoT promotion:** per-entry v2 render helper + content capture; skew-guard v2; adapters ×3 (Cursor/Antigravity pass-through; OpenCode + D7 dual-write); PROMOTED rule twins; red-line disposition per D9 (move or footer-leaf fallback); echo-block disposal; golden renders recorded (cursor .mdc post-promotion, composed gates); conditional fallback primitives only if D9/D5 reject; rules/_index.md + permission-and-native-tool-policy.md pointers. Backward compat: unmigrated entries byte-identical planned output.
- [ ] **Phase 2 — migration vs golden surfaces:** manifests ×3 (+SharedRoot, per-entry classes); antigravity differences-only; agents ×3; GEMINI composed; opencode instructions composed (dual-write flows); pre-commit stubs ×2; escape-* shrink; snippets (D3); SAME-CHANGESET assert rework per D4 map; NEW Invoke-Phase2-RemediationChecks.ps1; golden-render artifacts committed; roadmap leaf + _index row + Roadmap.md row. Apply-legs never run.
- [ ] **Phase 3 — retirements + docs cascade:** remaining D4 rows (expectedNine→11, Count-9, regex decouple — the D4 single-owner assignments); full non-Apply CI green; docs cascade per Scope; analysis note.
- [ ] **Phase 4 — live verification + Apply-legs:** fresh live-vs-planned incl. golden renders; per-stack Apply for drifted surfaces only (owner-gated; OpenCode re-baseline first); collapse to dry-run+smoke if no drift; smoke rows recorded.

## Agent context — Phase 0

- **Goal:** Ground truth + ALL design gates before any edit: CI matrix; live-tree inventory; D9 written severability verdict; D2 schema mini-fixture PROOF; D5 feasibility VERDICT; D3/D4/D6/D7/D8 decisions; golden-render substrate pin; declared-diff/golden home pin.
- **Depends on / entry gate:** approved plan + roadmap created (this file).
- **Do not touch:** any repo file (this phase records only; scratch fixtures live OUTSIDE the repo); live trees; manifests.
- **In scope:** run ALL SEVEN CI scripts (Phase0/Phase0FullCI-InventoryDiff/Phase1-2/Phase2FullCI[dry-run observation only — script performs live Apply, so observe + record WITHOUT running Apply leg OR record as deferred] /Phase3FullCI — record exact red/green per assert); D1 live-tree inventory (counts + hashes vs overlay heads, all 3 stacks); D9 full heading-map of rules/shell-native-tool-policy.md (Red line section boundaries, echo block, Accepted-risks/Residual-asks, cross-section pointers) → WRITTEN go/no-go; D2 throwaway fixture manifest + render via modified Core in scratch (all field classes, agent frontmatter/body mechanism, promo-twin concat, fail-closed no-match, golden-render mechanics) → schema pin recorded; D5 prototype render of composed gate from promoted twins + footer → feasibility verdict, atom list incl. host-wiring tails, <12k measure; D3 snippet disposition; D4 full 7-script assert enumeration with CURRENT line numbers + vacuous class + rework map + single-owner-per-assert; D6 unit-check home; D7 dual-write render-path design (incl. composed-entry skip semantics); D8 persistent-12k assert design; pre-migration authored copies of to-be-migrated files captured as diff baselines (scratch).
- **Out of scope:** fixing any red assert (owning phases); repo edits of any kind; live-tree changes.
- **Files expected:** none in repo (findings recorded in session notes + Phase 1 changeset).
- **Where to read context:** scripts/host-sync/README.md; all Invoke-Phase*.ps1; rules/shell-native-tool-policy.md; rules/iterative-*.md; rules/pre-commit-ci-gate.md; HostSync.Core.ps1; adapters; manifests; portal docs listed in plan.
- **Fast CI:** the seven scripts themselves (read-only/dry-run runs; Apply-leg observed-not-run).
- **Full CI:** n/a.
- **Deliverables:** [ ] 7-script CI matrix (exact per-assert status, current line numbers) [ ] D9 WRITTEN verdict [ ] D2 schema pin + fixture proof [ ] D5 feasibility verdict + atom list [ ] D3 disposition [ ] D4 rework map (single-owner-per-assert) [ ] D6/D7/D8 decided [ ] pre-migration authored copies captured [ ] live inventory recorded.
- **Risks:** Phase2FastCI already red (expectedNine, Count-9) — record as known-red baseline, do not mask; Phase2FullCI performs a live Apply — record as deferred-to-Phase-4, do NOT execute.

## Agent context — Phase 1

- **Goal:** Machinery + SoT promotion: per-entry v2 render helper + content capture; skew-guard v2; adapters wired (incl. D7 dual-write); promoted rule twins; red-line disposition per D9 verdict; echo disposal; golden renders recorded; conditional fallback primitives only if invoked.
- **Depends on / entry gate:** Phase 0 ALL gates closed: D2 schema proof, D9 severability verdict (or fallback), D5 feasibility verdict (promotion reproducible, <12k, atoms incl. host-wiring tails), golden-render substrate pinned.
- **Do not touch:** overlays/* bodies; live trees; CI scripts (Phase 2/3 own assert changes). RULES PERIMETER: promotion/split changes ARE in-scope this phase (declared; rules/_index + permission-FA pointer updates land with them).
- **In scope:** HostSync.Core.ps1 (render helper; source classes; fail-closed Substitutions; Footer/Parts concat; report labels; dry-run content-capture hook); Register-StackAdapters.ps1 (skew-guard identities keyed on SOURCE + sibling; canonicalization per D2); Cursor.Adapter.ps1 + Antigravity.Adapter.ps1 (minimal pass-through); OpenCode.Adapter.ps1 (pass-through PLUS D7 dual-write render path consuming rendered source); PROMOTE-INTO-TWIN: rules/iterative-plan-review.md + rules/iterative-code-review.md expanded to shared neutral gate prose; rules/red-line.md wholesale move (D9-go) or shared footer leaf (D9-no-go); shell-native-tool-policy.md edits + echo-block disposal; golden renders (cursor .mdc post-promotion; composed gates); CONDITIONAL fallback primitives (Sections/Frontmatter) ONLY if D9/D5 reject; rules/_index.md; docs/featureArchitecture/permission-and-native-tool-policy.md red-line SoT pointer.
- **Out of scope:** manifest migration (Phase 2); CI updates (Phase 2/3); overlays bodies.
- **Files expected:** HostSync.Core.ps1; Register-StackAdapters.ps1; adapters ×3; rules/iterative-plan-review.md; rules/iterative-code-review.md; rules/red-line.md (D9-go) or footer leaf (D9-no-go); shell-native-tool-policy.md; rules/_index.md; docs/featureArchitecture/permission-and-native-tool-policy.md; golden-render artifacts; unit-check script (home per D6); CONDITIONAL: fallback primitives.
- **Where to read context:** Core 344-387 + 391-457 (precedent); Register 44-64; adapters' loops; rules/* bodies; promotion-rule FA leaf; editing-companion-workflow SOP.
- **Fast CI:** dry-run -Target All; unmigrated entries byte-identical to pre-migration render (Phase 0 authored copies as baseline); MIGRATED-class entries vs golden renders (cursor .mdc post-promotion = golden surface, NOT byte-identical to pre-promotion — by design).
- **Full CI:** Phase1FastCI + Phase2FastCI existing asserts stay green EXCEPT pre-existing known-reds (expectedNine, Count-9 — single owning phase per D4 map, retire in Phase 3).
- **Deliverables:** [ ] per-entry v2 render helper + dry-run content capture [ ] adapters pass-through + D7 dual-write [ ] skew-guard v2 + unit cases (sibling flags, no-match hard error) [ ] promoted rule twins [ ] red-line disposition per D9 [ ] echo disposed [ ] golden renders recorded [ ] conditional fallback only-if-invoked [ ] rules/_index + permission-FA pointers.
- **Risks:** cursor hybrid regress (golden .mdc anchor catches); skew-guard over-flagging; adapter pass-through missing a field (unit fixture per field class); D9-no-go path leaves gate without red-line source (footer fallback pre-declared).

## Agent context — Phase 2

- **Goal:** Migrate manifests+overlays to per-entry v2; delete superseded hand-copies; rework deletion/relocation-broken asserts (same changeset); own verification script for new equivalence asserts; golden-render artifacts committed; roadmap leaf + _index row + Roadmap.md row.
- **Depends on / entry gate:** Phase 1 merged + green; D5 composed-gate size <12k confirmed (atom list defined).
- **Do not touch:** rules/, skills/, agents/, workflow/ SoT semantics; live trees; CI scripts EXCEPT (i) D4-map deletion/relocation rework in existing scripts and (ii) the NEW Phase-2-owned verification script — these two classes ARE in scope (same-changeset rule); expectedNine→11 + other Phase-3-registered retirements stay out.
- **In scope:** manifests ×3 (+SharedRoot, per-entry classes); antigravity migration (shared: rows + Substitutions per dossier deltas; agents ×3 via D2-pinned mechanism; GEMINI.md composed via promoted-twin bodies + red line + wiring footer; escape-* shrink to spawn-only; delete copied stub bodies); opencode instructions composed (dual-write flows via D7); pre-commit stubs ×2 composed from base:rules; snippets ×3 disposition (D3); golden-render artifacts committed per composed dest; deletion/relocation assert rework per D4 map; NEW Invoke-Phase2-RemediationChecks.ps1 (golden equality; atoms incl. tails; single-source-per-Dest; fail-closed substitutions; residual-marker; persistent 12k rendered-size — D8).
- **Out of scope:** opencode stub-set rewrite (Tier 1 by design); Apply-leg scripts; SoT semantics.
- **Files expected:** overlays/{opencode,antigravity,cursor}/**; manifests ×3; adapters only if D4 map implicates (keep one row reserved for OpenCode.Adapter.ps1 — D7-derived); Invoke-Phase2FastCI.ps1 + Phase1FastCI.ps1 per D4 rework rows; NEW Invoke-Phase2-RemediationChecks.ps1; golden-render artifacts; docs/roadmaps/overlay-remediation.md (this file, updated) + _index row + Roadmap.md row.
- **Where to read context:** dossier facts (session notes); promotion-rule FA leaf; antigravity _index rulings; D4 map output from Phase 0.
- **Fast CI:** expected-green = Fast suites (with in-changeset reworked asserts) + remediation-checks script green.
- **Full CI:** Phase1FullCI (dry-run leg only).
- **Deliverables:** [ ] antigravity = differences only [ ] gates composed incl. atoms [ ] pre-commit from rule [ ] snippets (D3) [ ] golden renders committed [ ] assert rework per D4 map [ ] remediation-checks green [ ] roadmap leaf + index + status rows.
- **Risks:** substitution gaps (fail-closed + residual-marker catch); composed-gate 12k (D5 gate precedes); assert-rework colliding with Phase-3 retirements (D4 single-owner map sequences).

## Agent context — Phase 3

- **Goal:** Assert retirements (D4 single-owner rows not landed in Phase 2) + docs cascade + analysis note; full non-Apply CI green.
- **Depends on / entry gate:** Phase 2 remediation-checks green; migration equivalence complete.
- **Do not touch:** derived overlay bodies; SoT semantics; live trees; Apply-leg scripts.
- **In scope:** D4-registered assert changes owned by Phase 3 (expectedNine→11, Count-9 reconcile, Phase1FullCI wording-regex decouple to structural marker, base-aware loop hardening if not landed in Phase 2, Phase3FullCI doc asserts, host-sync README v2 manifest surface); docs cascade: overlays/_index ×3; SOPs ×3 (antigravity count fixes 11-vs-9; author-time verification specimen updates; backup-is-restore-snapshot note; SOP C-table gate-text citation reconciliation after echo disposal); FA leaf v2 recording (skill-source-and-host-overlays.md: per-entry schema, fail-closed semantics, golden substrate, skew degeneration, SharedRoot naming; permission-FA pointer if not landed Phase 1); roadmap statuses; editing-companion-workflow.md (per-cell link repair + rows); analysis note (migration record + golden-render index); README.md row fix if needed.
- **Out of scope:** new feature asserts; Apply-leg scripts (Phase 4).
- **Files expected:** CI scripts per D4 Phase-3 rows; scripts/host-sync/README.md; overlays/_index ×3; docs/SOPs/*; docs/featureArchitecture/skill-source-and-host-overlays.md; docs/roadmaps/overlay-remediation.md (status); docs/SOPs/editing-companion-workflow.md; analysis note; README.md (if needed).
- **Where to read context:** D4 map; SOP authoring leaf; documentation-architecture skill.
- **Fast CI:** FULL non-Apply-leg CI green — known-reds RETIRED here.
- **Full CI:** dry-run/structural subset only; Phase2FullCI + all Apply-legs DEFERRED to Phase 4.
- **Deliverables:** [ ] known-reds retired [ ] full non-Apply CI green [ ] docs cascade incl. per-cell link repair + specimens + C-table citations [ ] analysis note.
- **Risks:** regex-coupled asserts; stale citations post-echo-disposal; Phase2FullCI home confusion (runs only Phase 4).

## Agent context — Phase 4

- **Goal:** Live verification + Apply-legs (only in this phase): fresh live-vs-planned comparison incl. golden renders; per-stack Apply for drifted surfaces only; smoke.
- **Depends on / entry gate:** Phase 3 green; operator authorization per surfaced drift set (composer surfaces drift list before requesting).
- **Do not touch:** SoT; machinery.
- **In scope:** dry-run all stacks; live vs planned (incl. golden renders); per-stack Apply ONLY for drifted surfaces (not blanket all-stacks; deviation + `-AllowSkew` justification recorded when drift is stack-local); stale-baseline handling: OpenCode re-baseline BEFORE any OpenCode Apply (restore-only doctrine; operator manual snapshot); operator VS Code/Cursor/OpenCode/Antigravity restarts after any Apply; smoke: C1 gate-quote zero-tools at least once per applied stack; skill loads by id; ONE plan-loop + dual-review cycle on one host.
- **Out of scope:** VSCode bring-up (follow-on program); wholesale re-sync beyond surfaced drift.
- **Files expected:** live trees only; possibly refreshed baseline registry (operator manual snapshot; restore-only).
- **Where to read context:** host-adapter SOPs; smoke rows from prior closeouts.
- **Fast CI:** full seven-script suite.
- **Full CI:** Phase2FullCI + Phase3FullCI incl. Apply-leg asserts.
- **Deliverables:** [ ] live==planned (or drift set explicitly re-baselined) [ ] smoke rows recorded [ ] applied-stacks list + rationale.
- **Risks:** all-hosts-at-once Apply (mitigated by per-stack scoping); stale OpenCode baseline (re-baseline first).

## Review loop per phase (owner-modified)

Clean `production_readiness_reviewer` passes only (owner ruled bug_reviewer off for this program); ≤4 iterations per pressure-release block; Fast CI Observed before reviewer launch; Full CI at closeout per ci-ladder; cap-exhausted handoff → Composer triage (Renew | Focus-narrow | Terminate | Waive-with-attestation — never waive CI failures).
