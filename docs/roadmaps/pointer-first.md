# Roadmap: Companion pointer-first architecture

**Last updated:** 2026-08-20  
**Status:** **Complete** — pointer-first-4 closeout (2026-08-20). pf3 `cdda0fd`; pf2 `fec0c75`; pf1 `6cdb1c5`; pf0 `0078420`. C6 minimum smoke **pass** (2026-08-20 operator post-mirror) per [closeout note](../../analysis/pointer-first-4-closeout-2026-08.md).
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
- [x] **pointer-first-1** — `workflow/plan-reviewer-report.md`; thin portable plan_reviewer; skills Read when
- [x] **pointer-first-2** — OpenCode stubs + COMPANION_ROOT; skills.paths discovery; live stub sync (backup first) — Probe A deferred (operator restart)
- [x] **pointer-first-3** — Cursor overlay/live companion reachability audit
- [x] **pointer-first-4** — Smoke C6 minimum 1,2,3,4,8,9–10,13 + install-time 14; companion-edit proof; mirror disposition; closeout ([closeout note](../../analysis/pointer-first-4-closeout-2026-08.md))

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

## Agent context — pointer-first-1 (deep schemas)

- **Goal:** Report schemas in `workflow/`; portable agents/skills thin + Read when.
- **Depends on / entry gate:** pointer-first-0 commit `0078420` (Composer ACCEPT + waiver).
- **Do not touch:** Live OpenCode; overlay stub blast (except Read when cites if needed later); plan file under `.cursor/plans`.
- **In scope:** `workflow/plan-reviewer-report.md`; thin `agents/plan_reviewer.md`; **defer** production_readiness/bug_reviewer schema extract to ticket `pointer-first-dual-report-schemas`; skills plan-review + implementation-plan Read when; workflow/_index.
- **Out of scope:** Dual-review schema extract this phase (ticketed defer); pointer-first-2+.
- **Files expected:** plan-reviewer-report.md; thinned plan_reviewer; skill Read rows; index.
- **Where to read context:** portable plan_reviewer pre-extract Output format (now in `workflow/plan-reviewer-report.md`); instruction-layering L3/L4; this roadmap.
- **Fast CI:** No full Output format specimen inside `agents/plan_reviewer.md`.
- **Full CI:** Doc-link integrity for `workflow/plan-reviewer-report.md` + `_index` + skill Read rows.
- **Deliverables:** [x] plan_reviewer report SoT [x] dual-review deferred ticket named on roadmap [x] skills point at deep doc
- **Risks:** Over-thin agent — keep purpose/inputs/must-not.

## Agent context — pointer-first-2 (OpenCode stubs)

- **Goal:** OpenCode overlay+live = thin harness + COMPANION_ROOT Reads; mirror not load path.
- **Depends on / entry gate:** pointer-first-1 commit `6cdb1c5`.
- **Do not touch:** Cursor overlay except shared FA cites; plan file; deleting live `docs/workflow/` yet; Cline.
- **In scope:** Stub rewrite all 8 overlay skills + 7 agents (priority: plan-review, implementation-plan, plan_reviewer — then remaining same phase); always-on absolute COMPANION_ROOT for workflow cites; specimen external_directory + skills.paths discovery; remove mirror from copy-out map; **live backup → stub sync → restart**; record skills.paths probe in analysis note.
- **Out of scope:** Mirror delete (pointer-first-4); Cursor audit (pointer-first-3).
- **Files expected:** overlays/opencode/** stubs; specimen; _index; live stubs under `~/.config/opencode`; analysis note for skills.paths probe.
- **Where to read context:** Failure mode I/J; skill-binding discovery; pointer-first-0 FA; this roadmap.
- **Fast CI:** Short bodies; zero wrong-base hops; COMPANION_ROOT absolute/token Reads.
- **Full CI:** Probe A 8 skills after restart (or document blocked if restart/operator gate).
- **Deliverables:** [ ] Stubs [ ] Map without mirror SoT [ ] Live stub sync [ ] skills.paths discovery recorded [ ] Backup path attested
- **Risks:** Empty skill catalog — keep host stubs with `name` until companion skills.paths Observed.
- **Migration:** Backup live `C:/Users/admin/.config/opencode` before any write. Sync stubs only (not procedure mirror). Do not delete live `docs/workflow/`.

## Agent context — pointer-first-3 (Cursor audit)

- **Goal:** Confirm Cursor thin wrappers + companion reachability when workspace ≠ cursorEscape.
- **Depends on / entry gate:** pointer-first-2 commit `fec0c75`.
- **Do not touch:** plan file under `.cursor/plans`; live OpenCode unless documenting only.
- **In scope:** Audit `overlays/cursor` vs portable `skills/`/`agents/`/`workflow/`; SOP note for live `~/.cursor` pointers; fix only **blocking** gaps (C1/C2 fail). Audit table in [analysis/cursor-pointer-first-3-audit-2026-08.md](../../analysis/cursor-pointer-first-3-audit-2026-08.md).
- **Out of scope:** Full live Cursor reinstall if non-blocking fat history; OpenCode live; deleting mirrors.
- **Files expected:** `overlays/cursor/**` harness `{{COMPANION_ROOT}}` rewrites; `docs/SOPs/cursor-host-adapter.md`; audit note; `overlays/cursor/_index.md`.
- **Where to read context:** [overlays/cursor/_index.md](../../overlays/cursor/_index.md); [host-adaptation-fidelity](../featureArchitecture/host-adaptation-fidelity.md) Wrong path resolution base; pointer-first-2 probe note.
- **Fast CI:** Zero wrong-base hops in `overlays/cursor`; `{{COMPANION_ROOT}}` in harness Read tables; `rg` clean.
- **Full CI:** Doc link integrity for new SOP + audit + overlay index.
- **Deliverables:** [ ] Audit table [ ] Blocking gaps fixed (COMPANION_ROOT hops) [ ] Live gaps deferred with reason [ ] cursor-host-adapter SOP
- **Risks:** Historical fat `~/.cursor` — document, don't require full rewrite unless C1/C2 fail.

## Agent context — pointer-first-4 (smoke closeout)

- **Goal:** Prove companion-edit visibility without copy-out; dispose procedure mirror; close program.
- **Depends on / entry gate:** pointer-first-3 commit `cdda0fd`.
- **In scope:** Smoke C6 minimum **1, 2, 3, 4, 8, 9–10, 13** + install-time row **14**; companion-edit marker in `workflow/plan-reviewer-report.md`; author-time harness grep; live `OPENCODE_HOME/docs/workflow/` mirror delete; overlay `_index` + host-adapter updates; [closeout note](../../analysis/pointer-first-4-closeout-2026-08.md).
- **Out of scope:** Re-authoring stubs; plan file; Cursor live fat-skill sync.
- **Deliverables:** [x] Author-time harness SoT greps [x] Companion-edit marker [x] Mirror deleted (OpenCode) [x] Closeout note + operator runbook [x] Runtime post-mirror smoke (C6 minimum pass 2026-08-20)
- **Fast CI:** Zero positive harness Target cites to host `docs/workflow/`; zero `../../` hops in `overlays/opencode` + `overlays/cursor`; companion `COMPANION_ROOT` Reads in harness.
- **Full CI:** Doc link integrity for closeout note + updated SOPs/indexes.

## Related

- [skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md)
- [host-adaptation-fidelity](../featureArchitecture/host-adaptation-fidelity.md)
- [opencode-overlays-sot](./opencode-overlays-sot.md) (historical bulk sync)
- [opencode-host-adapter](../SOPs/opencode-host-adapter.md)
