# Roadmap: Companion pointer-first architecture

**Last updated:** 2026-08-20  
**Status:** **In progress** — pointer-first-0 **ACCEPT** (Composer QC 2026-08-20). Dual APPROVED not achieved after initial 4 + renew 4 review iters; **Composer waiver:** Fast/Full hub greps pass; remaining always-on `docs/workflow/` prose + sync-rule AGENTS nit deferred to **pointer-first-2** (in-scope stub rewrite). Next: pointer-first-1.  
**Plan source:** accepted plan `plan_reviewer_report_sot_e3211634` (Companion pointer-first architecture).  
**Program id:** `pointer-first` (phases **pointer-first-0 … pointer-first-4**). Do not confuse with [opencode-overlays-sot](./opencode-overlays-sot.md) phases 0–3.

## Product decisions (locked)

- cursorEscape is the **sole SoT** for skills, rules, agents, workflows, and report schemas.
- Overlays / live hosts hold **thin harness only** (advertisement, permissions, spawn, absolute `COMPANION_ROOT` / `OPENCODE_HOME` wiring, thin always-on gates).
- Deep procedure loads via **companion Reads** — **not** host `docs/workflow/` mirror as SoT.
- Bulk copy-out of procedure (opencode-overlays-sot Phase 3 Strategy A mirror) is **transitional**; **load path superseded** by this program. Harness lessons retained: Failure mode I/J, absolute instructions, C1–C6 behavior bar.
- Dual-review report schemas: deferred ticket **`pointer-first-dual-report-schemas`** (follow-on after plan_reviewer report SoT).

## Inter-phase contracts

- Shared: `{{COMPANION_ROOT}}` absolute paths; Wrong path resolution base (I/J); C1–C6 behavior; program id `pointer-first-N` in commits/status.
- Extend-only hubs: skill-source, host-adaptation-fidelity, instruction-layering, overlays indexes, opencode-host-adapter, roadmaps/_index.
- Migration: git dual APPROVED + commit per phase → live backup before OpenCode write → stubs only → restart → smoke; mirror delete only after pointer-first-4 proof.

## Phase checklist

- [x] **pointer-first-0** — FA lock + C4/SOP/C6 cascade + this roadmap + opencode-overlays-sot supersession note (Composer ACCEPT + waiver 2026-08-20)
- [ ] **pointer-first-1** — `workflow/plan-reviewer-report.md`; thin portable plan_reviewer; skills Read when
- [ ] **pointer-first-2** — OpenCode stubs + COMPANION_ROOT; skills.paths discovery; live stub sync (backup first)
- [ ] **pointer-first-3** — Cursor overlay/live companion reachability audit
- [ ] **pointer-first-4** — Smoke C6 set 1,2,3,4,8,9–10,13,14; companion-edit proof; mirror disposition; closeout

## Follow-on tickets

| Id | Owner | Notes |
| -- | ----- | ----- |
| `pointer-first-dual-report-schemas` | follow-on | Extract production_readiness / bug_reviewer output schemas to `workflow/` |

## Agent context — pointer-first-0 (FA + cascade lock)

- **Goal:** Lock pointer-first Target; cascade C4/smoke/SOP/instruction-layering; disambiguate programs.
- **Depends on / entry gate:** User accepted plan; Composer assigned.
- **Do not touch:** Live OpenCode install; skill body moves; plan file.
- **In scope:** skill-source (elevate pointer-first Required); fidelity C4 + phase disambiguation for `pointer-first`; instruction-layering L3 (no procedure mirror as SoT); overlays/_index + opencode/_index Sync vs pointer → harness-only sync; this roadmap + _index; opencode-overlays-sot supersession note; host-adapter layer map + smoke row 4 How **locked** for companion `{{COMPANION_ROOT}}/workflow/` paths; C6 minimum set cites companion paths; archive note for `Rewrite-OpenCodeWorkflowLinks.ps1` (not primary sync). Discovery 3 note: rubric stays companion FA + absolute Read; review-subagent-models stays thin overlay leaf.
- **Out of scope:** Stub rewrites; schema extract files; pointer-first-1+.
- **Files expected:** FA/SOP/roadmap/overlay indexes listed in plan Agent context.
- **Where to read context:** docs/roadmaps/pointer-first.md; accepted plan intent; skill-source; fidelity; opencode/_index (current bulk sync — wrong).
- **Fast CI:** `rg` pointer-first wording; copy-out map sync = harness-only; C4 author-time cites COMPANION_ROOT workflow; program name in fidelity disambiguation table.
- **Full CI:** Doc link integrity.
- **Deliverables:** [ ] FA locked [ ] Roadmap complete for phase 0 [ ] C4/smoke/SOP/C6 cascade locked [ ] opencode-overlays-sot superseded note
- **Risks:** Phase-number collision — always say `pointer-first-0`.

**Dirty tree note (pointer-first-0 closeout):** Deliverables `docs/roadmaps/pointer-first.md` and `overlays/opencode/AGENTS.md` exist on disk; Composer stages/commits after dual APPROVED + Full CI. Do not expand into stubs/schemas in pointer-first-0.

## Related

- [skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md)
- [host-adaptation-fidelity](../featureArchitecture/host-adaptation-fidelity.md)
- [opencode-overlays-sot](./opencode-overlays-sot.md) (historical bulk sync)
- [opencode-host-adapter](../SOPs/opencode-host-adapter.md)
