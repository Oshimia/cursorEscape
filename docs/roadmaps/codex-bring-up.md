# Codex adapter bring-up roadmap (7th sync stack)

**Status:** Accepted for Composer execution 2026-09-07. Phase 0 complete 2026-09-08 (dual APPROVED: production-readiness + bug review, 3 iterations; Observed Fast CI, subagent Full CI, Composer QC, Composer Full CI). Phase 1 complete 2026-09-08 under the owner's iterative-review waiver (implementation-only closeout; Observed Fast CI 72/72, six-stack ledger parity, Composer QC on attestation + transcripts; deferred risks recorded in the closeout). Phase 2 complete 2026-09-08 under the same waiver (specialized fail-closed two-root adapter + 43-check scratch CI; unit 22/22, remediation 69/69, ledger parity). Phase 3 complete 2026-09-08 under the same waiver (implementation-only closeout: seven-stack registration, forced BringUp, global preflight, 19-check temp-root Fast CI, docs cascade). Codex remains unapplied; `ApplyState = BringUp` until three-client smoke passes.

## Context

Add one pointer-first OpenAI Codex adapter for the local Codex CLI, VS Code extension, and ChatGPT desktop app. Canonical procedure remains under repo-root `skills/`, `agents/`, `workflow/`, and `rules/`; the Codex overlay contains host advertisement, invocation policy, agent wiring, and managed-install mechanics only.

The implementation follows the reviewed plan after its three-pass cap. The final blocker is resolved here: the original Phase 0 baseline is restore-only provenance for the initial installation. Later Applies use ownership checks plus hashes of the actual current pre-Apply state; they do not require equality with or automatically restore the original baseline.

## Product decisions

| Decision | Value |
|---|---|
| Stack identity | `Codex` / OpenAI Codex |
| Local clients | CLI + VS Code extension + ChatGPT desktop app |
| Skill root | `$HOME/.agents/skills`, independent of `CODEX_HOME` |
| Codex root | effective `CODEX_HOME`, default `~/.codex` |
| Inventory | 22 canonical skills + generated `pre-commit-ci-gate`; OpenCode tooling skills explicit-only |
| Agents | Seven canonical underscore-named TOML agents; no model/reasoning pins |
| Guidance | Managed cursorEscape block in `AGENTS.md`; non-empty `AGENTS.override.md` blocks Apply |
| Adapter shape | Specialized `Codex.Adapter.ps1`; do not generalize `Generic.Adapter.ps1` without Phase 0 evidence |
| Lifecycle | `BringUp` blocks `Target All -Apply`; activate only after runtime acceptance |
| Live writes | No Codex Apply in Phases 0–3; Phase 4 requires explicit owner authorization |
| Subagent model | GLM 5.3 Flash for Composer, phase, and reviewer subagents (owner override 2026-09-08 after Codex usage exhaustion; replaces the earlier GPT Terra High requirement) |

## Inter-phase contracts

- Canonical procedure remains only in `skills/`, `agents/`, `workflow/`, and `rules/`.
- Existing six stacks retain byte-identical normalized planned outputs.
- Codex destinations are identified by logical root plus relative path.
- Generated standalone files and managed blocks carry stable ownership markers.
- Foreign destinations and non-empty `AGENTS.override.md` fail before writes.
- `Target All -Apply` preflights every selected adapter before any write pass; adapters repeat drift-sensitive checks immediately before their writes.
- Phase 0 baseline is one-time restore-only provenance. Initial Apply verifies baseline/current equality. Later Applies use current-state ownership and hashes; baseline restoration is an explicit operator decision, never automatic.
- Adapter-local failure restores current pre-Apply bytes held in memory and removes files created by the failed run. Process-crash recovery is marker-aware reconciliation.
- Every implementation phase closes through Observed Fast CI, parallel production-readiness + bug review to dual APPROVED, subagent Full CI, Composer QC, Composer Full CI, then a local commit. Never push.

## Migration / external apply order

1. Complete Phase 0 discovery and create a narrowly scoped initial baseline after owner authorization.
2. Complete Phases 1–3 without installing the Codex harness.
3. Pass Codex and all-stack dry-runs plus the non-mutating Full suite.
4. Obtain separate owner authorization for Codex-only Apply.
5. For the initial install, prove baseline/current equality; rerun ownership, collision, and hash preflight.
6. Apply only Codex with the bring-up exception; immediately verify live/planned hashes.
7. Start fresh CLI, IDE, and desktop sessions; run C1–C6 and supplemental safety checks.
8. On failure, keep `BringUp` and reconcile from current-state evidence or explicitly selected baseline recovery.
9. On success, record attestation, set `ApplyState = Active`, run final all-stack dry-run and non-mutating Full CI.
10. On later Applies, use current-state ownership and preflight hashes; do not compare against or automatically restore the original baseline.

## Phase checklist

- [x] **Phase 0 — Discovery, seam decision, and recovery/regression baselines** (2026-09-08)
- [x] **Phase 1 — Codex overlay and manifest** (2026-09-08, owner review waiver)
- [x] **Phase 2 — Specialized adapter and safety mechanics** (2026-09-08, owner review waiver)
- [x] **Phase 3 — Registration, orchestration-wide preflight, CI, and docs** (2026-09-08, owner review waiver)
- [ ] **Phase 4 — Authorized Apply, three-client smoke, and activation**

## Agent context — Phase 0

- **Goal:** Resolve effective host surfaces, prove the specialized two-root seam, and establish narrow recovery/regression evidence.
- **Depends on / entry gate:** Accepted plan; clean worktree; owner authorization before any user-home backup write.
- **Do not touch:** `~/.codex/config.toml`, authentication, sessions, logs, databases, extension state, existing live harness content, or other host installs.
- **In scope:** D1 effective-home discovery; D2 external companion reachability; D3 skill-catalog budget; D4 reviewer sandbox boundary design; D5 two-root scratch seam; destination-level baseline recipe/artifact; normalized six-stack render hash ledger; Codex C1–C6 mapping.
- **Out of scope:** Codex overlay implementation, adapter write logic, registry changes, and live installation.
- **Files expected:** `analysis/codex-load-surface-2026-09.md`, this roadmap, narrowly scoped baseline metadata/tooling if authorized, and existing-golden/check extensions for the six-stack hash ledger.
- **Where to read context:** `workflow/discovery.md`; `scripts/host-sync/README.md`; `HostSync.Core.ps1`; existing manifests/adapters; `docs/roadmaps/vscode-bring-up.md`; `docs/featureArchitecture/host-adaptation-fidelity.md`; official OpenAI Codex skill, AGENTS, subagent, and developer-settings docs.
- **Fast CI:** Scratch two-root routing and baseline path-containment/schema checks; record each command actually run.
- **Full CI:** Restore fixture plus reproducible six-stack normalized hash comparison; no script that performs live Apply.
- **Deliverables:** Completed D1–D5 findings; selected adapter seam; initial recovery contract; unchanged C1–C6 mapping; reproducible existing-stack regression evidence.
- **Risks:** Assuming UI parity proves path parity; reading or backing up excessive private state; temporary-root tests resolving the real profile.

## Agent context — Phase 1

- **Goal:** Author a complete thin Codex overlay and two-root manifest without changing live homes.
- **Depends on / entry gate:** Phase 0 QC ACCEPT and local commit.
- **Do not touch:** Canonical procedure bodies, existing host overlays except shared indexes required in this phase, live homes, or `config.toml`.
- **In scope:** Managed AGENTS block source; 23 skill wrappers; minimal `agents/openai.yaml` metadata; seven TOML agents; ownership markers; `{{COMPANION_ROOT}}` pointers; Codex manifest; overlay index; expected renders.
- **Out of scope:** Adapter write/merge logic, registry, global Apply orchestration, and live installation.
- **Files expected:** `overlays/codex/**`, `scripts/host-sync/manifests/codex.manifest.psd1`, focused render fixtures/goldens.
- **Where to read context:** `skills/_index.md`; `agents/_index.md`; `rules/`; `workflow/`; `instruction-layering.md`; `skill-source-and-host-overlays.md`; official Codex skill/subagent docs; Phase 0 analysis.
- **Fast CI:** Parse all frontmatter/YAML/TOML; assert 23/7 inventory, required TOML fields, unique filename-matched names, reviewer read-only defaults, no model/reasoning pins, zero unresolved tokens, and zero wrong-base relative hops.
- **Full CI:** In-process Codex rendering plus existing six-stack normalized hash equality; no live Apply.
- **Deliverables:** Valid generated content for every planned Codex destination.
- **Risks:** Advertisement drift, invalid TOML quoting, unnecessary metadata, or catalog-budget pressure.

## Agent context — Phase 2

- **Goal:** Implement a fail-closed specialized adapter with safe two-root installation semantics.
- **Depends on / entry gate:** Phase 1 QC ACCEPT and local commit.
- **Do not touch:** `Generic.Adapter.ps1` semantics without demonstrated need, real user homes in tests, `config.toml`, or other host behavior.
- **In scope:** Explicit injectable Codex/skill roots; complete pre-render/preflight; root-qualified destination identities; ownership classification; managed AGENTS block; staging; current-state hash binding; in-memory rollback; per-root exclusions; malformed-marker, collision, drift, path-escape, late-failure, rollback, idempotence, and unplanned-sibling fixtures.
- **Out of scope:** Registry/docs cascade, real Apply, and plugin packaging.
- **Files expected:** `scripts/host-sync/adapters/Codex.Adapter.ps1`, focused Core helpers only when reusable and tested, `scripts/host-sync/Invoke-CodexAdapterChecks.ps1`, scratch fixtures.
- **Where to read context:** `HostSync.Core.ps1`; `HostSync.Contract.ps1`; Cursor/OpenCode specialized adapters; Phase 0 recovery contract; Phase 1 manifest.
- **Fast CI:** `Invoke-CodexAdapterChecks.ps1` against explicit temporary roots; tests must prove neither root resolves to the real profile.
- **Full CI:** Remediation unit checks, Codex adapter checks, existing remediation checks, and six-stack normalized hash equality; no live Apply.
- **Deliverables:** Dry-run/Apply behavior proven in disposable profiles, including repeated Apply and failed-run rollback.
- **Risks:** Root confusion, newline damage, partial multi-root writes, or foreign sibling deletion.

## Agent context — Phase 3

- **Goal:** Register Codex safely, add orchestration-wide preflight, update CI, and complete the documentation cascade.
- **Depends on / entry gate:** Phase 2 QC ACCEPT and local commit.
- **Do not touch:** Live user homes or unrelated host content/renders.
- **In scope:** Seventh-stack registry; `ApplyState` default Active with Codex BringUp; preflight-all-before-write orchestration; baseline gate; hardcoded stack inventories; Active-state failing-Codex zero-write fixture; Codex SOP/roadmap/status; README/index/architecture updates.
- **Out of scope:** Codex live Apply, model/MCP/plugin configuration, or smoke attestation.
- **Files expected:** `Register-StackAdapters.ps1`; `Sync-HostHarness.ps1`; applicable Core/contract/check scripts; `docs/SOPs/codex-host-adapter.md`; README, roadmap, overlay/skill/agent indexes; `skill-source-and-host-overlays.md`; `instruction-layering.md`; `host-adaptation-fidelity.md`; editing workflow SOP.
- **Where to read context:** Host-sync expansion recipe; VS Code/Kilo/Cline bring-ups; all affected indexes and architecture leaves.
- **Fast CI:** Codex dry-run; All dry-run; BringUp All-Apply refusal in temporary roots; Active Codex collision causing zero writes to every selected stack; invalid-target output.
- **Full CI:** `Invoke-RemediationUnitChecks.ps1`; `Invoke-CodexAdapterChecks.ps1`; `Invoke-Phase2-RemediationChecks.ps1`; `Invoke-Phase2FastCI.ps1`; `Invoke-Phase3FullCI.ps1`; six-stack hash comparison. Do not run live-mutating `Invoke-Phase2FullCI.ps1`.
- **Deliverables:** Documented, registered, apply-gated Codex stack ready for owner-authorized bring-up.
- **Risks:** Hardcoded six-stack assumptions, report/FailFast regressions, or preflight changing existing Apply semantics.

## Agent context — Phase 4

- **Goal:** Install Codex once with authorization, prove CLI/IDE/desktop behavior, and activate the stack.
- **Depends on / entry gate:** Phase 3 QC ACCEPT and local commit; green non-mutating Full CI; current initial baseline; explicit owner authorization for Codex-only Apply.
- **Do not touch:** `config.toml`, foreign destinations, unrelated stacks, or remotes.
- **In scope:** Initial baseline/current equality; immediate collision/hash preflight; Codex-only Apply; fresh client sessions; C1–C6; preservation, parity, idempotence, rollback, regression, and global-preflight checks; smoke records; `ApplyState` activation after pass.
- **Out of scope:** Other-host Apply and new product configuration.
- **Files expected:** Live owned Codex leaves plus roadmap/SOP status and manifest lifecycle update.
- **Where to read context:** Codex host-adapter SOP, baseline manifest, Phase 0 analysis, C1–C6 matrix.
- **Fast CI:** Immediate Codex dry-run/preflight with current hashes.
- **Full CI:** Runtime C1–C6 and supplemental S1–S7 followed by the non-mutating repository suite.
- **Deliverables:** Attested three-client adapter and Active state, or marker-aware reconciliation with BringUp retained.
- **Risks:** Client caching, divergent homes, external-path approvals, or interruption during commit.

## Verification matrix

| ID | Required behavior |
|---|---|
| C1 | Always-on plan/review gates load in fresh sessions |
| C2 | Complete skill catalog and explicit-only invocation policy work |
| C3 | Plan reviewer and dual reviewers spawn with isolation/read-only defaults |
| C4 | Deep workflow Reads resolve to the companion repository |
| C5 | Companion FA/SOP Reads work without repeated asks |
| C6 | End-to-end behavior is attested, not inferred from file presence |
| S1 | `config.toml` and foreign state remain unchanged |
| S2 | CLI, IDE, and desktop behavior agrees |
| S3 | Repeated Apply is idempotent using current-state preflight, not original-baseline equality |
| S4 | Foreign collision and live drift abort before writes |
| S5 | Failed Apply restores current pre-Apply bytes/absence; stale baseline is never auto-restored |
| S6 | Existing six-stack normalized render hashes remain equal |
| S7 | Active global Apply fails before any stack writes when Codex preflight fails |

## Composer notes

- Na: **n/a** — no visual preview surface.
- Phase 0 initial baseline and Phase 4 live Apply remain separate external gates.
- Phase and nested reviewer subagents use GLM 5.3 Flash per owner instruction (2026-09-08 override; previously GPT Terra High).
- Owner waived iterative dual review for Phases 1+ on 2026-09-08 (cost); CI gates remain mandatory. Deferred review risks: openai.yaml explicit-only metadata is overlay-only pending a Phase 2 schema decision; catalog budget measured conservatively.
- Composer commits locally after QC ACCEPT and Double Full CI; never pushes.
