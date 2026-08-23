# Roadmap: mattpocock/skills audit and merge

**Last updated:** 2026-08-23
**Status:** **Complete** (owner closed 2026-08-23) - all triage-ranked adaptation phases (B1-B2, F1-F16) implemented through the repo's dual-review gates; I1-I6 adopt-pattern rules applied within their owning phases. No further phases planned; this roadmap is historical.
**Plan source:** accepted plan `mattpocock-skills-audit-map` (Escalation `no` / `n/a`; roadmap may restructure thin phases into Agent context without new scope).

## Product decisions (locked)

- **Full sweep:** catalog all 18 engineering + 7 productivity + 4 misc + 6 in-progress skills plus repo infra.
- **Housing:** audit map under `research/mattpocock-skill-audit/` (Observed research); handoff roadmap here.
- **Full assessment spec:** the deeper model runs the audit per [assessment-spec.md](../../research/mattpocock-skill-audit/assessment-spec.md), not ad hoc.
- **Snapshot pin:** assess `mattpocock/skills` at `0ab1b63` (2026-08-21). Do not silently track `main`.
- **Deeper-model swap:** the assessment is the next agent's job (this roadmap's P1). It may run as a Composer phase or as a prompt-level clean-session task in a more capable model. Host/model choice is the owner's call.
- **Interest areas first:** Tier 1 = wizard, writing-for-agents, code-review, improve-codebase-architecture, codebase-design, domain-modeling; then Tier 2, Tier 3, then the infra block.
- **Excluded from assessment (owner opt-out, 2026-08-21):** collaborative/team-workflow skills — `setup-matt-pocock-skills`, `triage`, `to-spec`, `to-tickets`, `wayfinder`, `to-questionnaire` (solo dev; GitHub/issue-tracker/another-human) — and non-coding `writing-beats`, `writing-fragments`, `writing-shape`. **Exception:** `teach` is assessed (owner-named, Tier 2). Git-management skills are not excluded. Full list with reasons: [index-and-priorities.md](../../research/mattpocock-skill-audit/index-and-priorities.md#excluded-from-assessment-not-to-be-assessed).
- **No contract changes during assessment:** P1–P2 touch only `research/mattpocock-skill-audit/**`. Adaptations (P3+) go through the repo's own plan → implement → dual-review → closeout bar.
- **Owner has final say on verdicts:** P1 findings are **draft until a dedicated discussion with the owner**. The owner may disagree with any verdict or recommendation; disagreements are resolved in that discussion (owner decision is binding) before P2 may suggest merge decisions.
- **Adapt, don't copy:** skills are brought into cursorEscape by **careful adaptation to this repo's workflows and conventions** — host-agnostic portable contracts, thin harness + companion procedure, overlay-only host specifics, dual-gate review, clean-context isolation, and the owner's existing plan/review loop. No wholesale copy/paste: a SKILL.md lifted verbatim from mattpocock is not an acceptable outcome. Every proposal must state how it integrates with the existing workflow and what changes from the source.

## Map (Phase 0 deliverables)

- [Catalog](../../research/mattpocock-skill-audit/catalog.md) — full-sweep inventory with pinned URLs and file sizes.
- [Index and priorities](../../research/mattpocock-skill-audit/index-and-priorities.md) — draft statuses + tiers + infra areas.
- [Assessment spec](../../research/mattpocock-skill-audit/assessment-spec.md) — the spec P1 follows.
- [Hub](../../research/mattpocock-skill-audit/_index.md) — purpose, provenance, navigation.

## Inter-phase contracts

- **Shared extend-only hubs:** `research/mattpocock-skill-audit/_index.md` (status), `research/mattpocock-skill-audit/findings/_index.md` (verdict list), this roadmap's checklist + Status line.
- **Findings output shape:** per [assessment-spec.md](../../research/mattpocock-skill-audit/assessment-spec.md) — one file per skill under `findings/<skill>.md` (or one `findings.md` with sections), plus a summary index with verdict + one-line reason per skill.
- **Snapshot pin fixed at `0ab1b63`.** Any re-fetch targets the pinned SHA. Findings note the pinned path per quote.
- **P1–P2 freeze:** no edits to `skills/`, `agents/`, `workflow/`, `rules/`, `overlays/`, `docs/featureArchitecture/`, `docs/SOPs/`, or repo-root contracts. Assessment is read-only except its own `findings/` output.
- **Verdicts feed P2 (after owner discussion):** P1 produces `Adopt | Adapt | Reference-only | Reject` per skill + infra area recommendation. These are **draft until the dedicated P1–P2 owner discussion** (see P1 agent context). The discussion record — including owner amendments — is a P1 deliverable; P2 ranks the **amended** `Adopt`/`Adapt` set only and does not re-run P1.
- **P3+ gate:** each accepted adaptation is its own phase through the repo's standard loop (implementation-plan + plan_reviewer, implementation-review dual gate, Full CI closeout). A roadmap already in P3 may adopt an accepted proposal as a new phase only via this roadmap's Status update.

## Migration / external apply order

None. Docs and repo-git only. No live host apply, no `~/.cursor`/`~/.config/opencode` changes.

## Checklist

- [x] Phase 0 — Audit map + handoff roadmap authored (this file, 2026-08-21)
- [x] Phase 1 — Assessment sweep (Tier 1 → 2 → 3, then infra block) per assessment-spec, then **owner discussion of findings/verdicts** (2026-08-21)
- [x] Phase 2 — Merge triage: rank owner-accepted proposals, decision log, define adapt phases (owner accepted 2026-08-21)
- [x] Phase 3 F1 — `codebase-design` reference implemented and dual-reviewed (2026-08-21)
- [x] Phase 3 F2 — `tdd` reference implemented; Reviewer A approved, Bugbot waived by owner (2026-08-21)
- [x] Phase 3 F3 — `grilling` interview primitive implemented and dual-reviewed (2026-08-21)
- [x] Phase 3 F4 — documented alignment in implementation-plan; Reviewer A approved, Bugbot waived by owner (2026-08-21)
- [x] Phase 3 F5 — implementer execution discipline implemented and dual-reviewed (2026-08-21)
- [x] Phase 3 F6 — code-review evidence frame implemented and dual-reviewed in parallel (2026-08-21)
- [x] Phase 3 B1 — diagnosing-bugs workflow implemented, advertised end-to-end, dual-reviewed after Renew (2026-08-21)
- [x] Phase 3 B2 — bug-review evidence leg implemented and dual-reviewed in parallel (2026-08-22)
- [x] Phase 3 F7 — bounded research capability implemented and dual-reviewed in parallel (2026-08-22)
- [x] Phase 3 F8 — domain-modeling discipline implemented and dual-reviewed in parallel (2026-08-22)
- [x] Phase 3 F9 — architecture-survey guided decision process implemented and dual-reviewed in parallel (2026-08-22)
- [x] Phase 3 F10 — prototype pattern implemented and dual-reviewed in parallel (2026-08-22)
- [x] Phase 3 F11 — wizard generation skill implemented and dual-reviewed in parallel (2026-08-22)
- [x] Phase 3 F12 — writing-for-agents rubric implemented and dual-reviewed in parallel (2026-08-22)
- [x] Phase 3 F13 - portable handoff contract implemented and dual-reviewed in parallel (2026-08-22)
- [x] Phase 3 F14 - teach dedicated workspace implemented and dual-reviewed in parallel (2026-08-22)
- [x] Phase 3 F15 - merge-conflict resolution procedure implemented and dual-reviewed in parallel (2026-08-23)
- [x] Phase 3 F16 - wait-what communication trigger implemented and dual-reviewed in parallel (2026-08-23)
- [x] Phase 3+ — Adaptation implementation, one phase per accepted proposal through the repo's own gates (all ranked phases B1-B2, F1-F16 implemented by 2026-08-23; owner closed the roadmap)

---

#### Agent context — Phase 1

- **Goal:** Run the per-skill assessment for every Tier 1–3 skill **plus `teach`** and the infra block, exactly per [assessment-spec.md](../../research/mattpocock-skill-audit/assessment-spec.md), land findings + a summary index, **then hold a dedicated discussion with the owner before any verdicts count as final**.
- **Depends on / entry gate:** This roadmap accepted (Phase 0 complete). Deeper model available for the session.
- **Suggested models (not enforced):** Primary `opencode-go/gpt-5.6-luna` for the assessment; fallback `opencode-go/deepseek-v4-pro` if the 5-hour window is hit. Recommendations only — the owner may run P1 on any model; keep findings host/model-agnostic.
- **Do not touch:** `skills/`, `agents/`, `workflow/`, `rules/`, `overlays/`, `docs/featureArchitecture/`, `docs/SOPs/`, repo-root contracts, or anything outside `research/mattpocock-skill-audit/**` except read-only context.
- **In scope:** Read `index-and-priorities.md` + `catalog.md`; read each **assessable** pinned skill's actual `SKILL.md` (and docs page) at `0ab1b63`; write `findings/<skill>.md` (or one `findings.md`) per the spec; write `findings/_index.md` summary; **discuss the findings with the owner** — present verdicts and recommendations, explicitly flag the disagreement-prone choices (Adopt/Adapt calls, tier changes, host-lock trade-offs, anything the map listed differently), and capture the owner's decisions.
- **Excluded skills (no findings block):** `setup-matt-pocock-skills`, `triage`, `to-spec`, `to-tickets`, `wayfinder`, `to-questionnaire`, `writing-beats`, `writing-fragments`, `writing-shape` — one-line note in `_index.md` only.
- **Out of scope:** Any adapt proposal implementation; ranking proposals (that is P2); editing the map's catalog/index to match findings (leave them as the Phase 0 draft; note divergences in findings).
- **Files expected:** `research/mattpocock-skill-audit/findings/<skill>.md` per skill (or combined), `research/mattpocock-skill-audit/findings/_index.md`.
- **Where to read context:** [assessment-spec.md](../../research/mattpocock-skill-audit/assessment-spec.md) (fields + verdicts + routing), [index-and-priorities.md](../../research/mattpocock-skill-audit/index-and-priorities.md) (tiers), [catalog.md](../../research/mattpocock-skill-audit/catalog.md) (URLs), local `skills/`/`agents/`/`workflow/` indexes for fit checks.
- **Fast CI:** Manual link check on the two new findings files + `_index.md`; all pinned URLs at `0ab1b63`. No suite in this repo.
- **Full CI:** n/a (docs-only) — explicit owner acknowledgment before commit.
- **Deliverables:**
  - [ ] Findings block for every Tier 1–3 skill (or explicit skip note with reason in `_index.md`)
  - [ ] Infra block: one recommendation per area from [index-and-priorities.md](../../research/mattpocock-skill-audit/index-and-priorities.md)
  - [ ] `findings/_index.md` summary with verdict + one-line reason per skill
  - [ ] **Dedicated owner discussion held** — verdicts and disagreement-prone choices presented; owner amendments captured (e.g. a `findings/discussion-record.md` noting each changed verdict and the owner's call)
  - [ ] No cursorEscape contract files modified
- **Risks:** Drift toward `main` instead of the pin; trusting README one-liners instead of `SKILL.md`; proposing host-locked mechanisms (Claude hooks, `claude --bg`, Codex yaml, issue-tracker assumptions) without flagging portability cost; treating draft verdicts as final without the owner discussion.

#### Agent context — Phase 2

- **Goal:** Convert P1 findings (as amended by the owner discussion) into a ranked merge decision log: which `Adopt`/`Adapt` proposals proceed, in what order, and what each adaptation phase builds.
- **Depends on / entry gate:** P1 summary index present **and the dedicated owner discussion completed** — verdicts accepted or amended per the discussion record. Do not start P2 on draft verdicts.
- **Do not touch:** Same P1 freeze list; also do not re-run assessments.
- **In scope:** Rank `Adopt`/`Adapt` proposals (the **amended** set from the discussion record) by leverage × fit × cost; write a decision log (could be `research/mattpocock-skill-audit/merge-triage.md`); for each accepted proposal, define its adaptation phase (name, cursorEscape artifacts touched, scope, review bar); present ranking to the owner for acceptance.
- **Out of scope:** Implementing any adaptation; expanding scope beyond P1 proposals; dropping `Reference-only`/`Reject` items silently (log them).
- **Files expected:** `research/mattpocock-skill-audit/merge-triage.md` (ranked decisions + phase definitions), Status update in this roadmap.
- **Where to read context:** `findings/_index.md` + `findings/<skill>.md`, the P1 discussion record (owner amendments), [assessment-spec.md](../../research/mattpocock-skill-audit/assessment-spec.md) routing, repo skill/agent/workflow indexes.
- **Fast CI:** Manual link check on touched docs.
- **Full CI:** n/a (docs-only) — owner acknowledgment before commit.
- **Deliverables:**
  - [ ] Ranked decision log with rationale
  - [ ] One adaptation-phase definition per accepted proposal (scope + files + review bar)
  - [ ] Owner-accepted ranking
- **Risks:** Rank inflation from interesting-but-off-loop proposals; under-flagging host-lock; overlapping proposals needing consolidation.

#### Agent context — Phase 3+

- **Goal:** Implement each accepted adaptation through cursorEscape's own loop.
- **Depends on / entry gate:** P2 ranking accepted by the owner. Each adaptation phase is its own entry gate.
- **Do not touch:** Anything outside the specific adaptation's scope; other roadmap phases' files; live host installs.
- **In scope:** Per accepted proposal: **adapt — not copy** — the skill to cursorEscape's existing workflows: author new/extended `skills/`, `agents/`, `workflow/`, or `rules/` contracts per [editing-companion-workflow](../SOPs/editing-companion-workflow.md) + [skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md), rebuilt to fit the repo's thin-harness/overlay split, escalation gates, and dual-gate review bar; add overlay wrappers where host-specific; run implementation-plan → plan_reviewer → implementation-review (dual gate) → Full CI closeout per phase. Verbatim copies of source `SKILL.md` bodies are not acceptable — each adaptation must state how it integrates with existing skills/agents/workflow docs.
- **Out of scope:** Merging multiple proposals into one phase without plan approval; pushing to remotes; live host apply.
- **Files expected:** Per-phase contract files + overlay updates + index updates, all through the repo's standard gates.
- **Where to read context:** This roadmap's P2 phase definitions; [implementation-plan](../../skills/implementation-plan/SKILL.md); [implementation-review](../../skills/implementation-review/SKILL.md); [composer](../../skills/composer/SKILL.md) if Composer-conducted.
- **Fast CI:** Per-phase, from the repo's ci-ladder.
- **Full CI:** Per-phase before commit; n/a path requires owner acknowledgment.
- **Deliverables:**
  - [ ] Each phase: dual APPROVED + Full CI pass (or documented n/a path)
  - [ ] Roadmap Status + checklist updated after each phase
- **Risks:** Over-adapting (rebuilding things the map marked Reference-only); under-adapting (copy/pasting source bodies instead of rebuilding them to fit local workflows); breaking the thin-harness/overlay split; duplication with existing skills.
