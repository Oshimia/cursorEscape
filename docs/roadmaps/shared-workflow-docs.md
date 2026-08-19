# Roadmap: Centralize the workflow manager

**Last updated:** 2026-08-20  
**Status:** Phase 6 **complete** (Composer ACCEPT 2026-08-20). Program closed. Copy-out still unauthorized.  
**Plan source:** accepted plan `shared_workflow_docs_376cecd4` (copy of Inter-phase + Agent context; do not invent scope).

## Product decisions (locked)

- Approach **A**: live Cursor extract wording at root `workflow/` + `skills/*/SKILL.md` + `agents/*.md` + `rules/*.md`; thin `overlays/cursor/` after Phase 5; fold/delete `docs/skills` and `docs/agents`.
- **B** and **C** rejected (lean contracts as SoT; hybrid bulk still in overlay).
- Live `~/.cursor` is not overwritten. Copy-out unauthorized. No `adapters/`. No OpenCode extract this program.
- Promote mechanic: **copy** overlay extract to bases; overlay stays fat until Phase 5.
- This-program review-loop cap: phase agents ≤4 dual-review iterations, then Composer triage (renew ≤4 / waive process nits / change approach). Fast/Full failures are not waivable.

## Target layout (end state)

```text
cursorEscape/
  README.md
  docs/                         # THIS REPO only (FA, SOPs, roadmaps, Roadmap.md)
  workflow/ skills/ agents/ rules/
  overlays/cursor/              # THIN after Phase 5
  research/ review/ analysis/
```

## Inter-phase contracts

- Shared extend-only hubs: `README.md`, `docs/Roadmap.md`, `docs/SOPs/documenting-this-repo.md`, overlay FA (path updates each phase).
- One authored procedure per skill/agent/workflow leaf. Overlay must Read / point at base, not paste the loop.
- In-repo links use repo-relative paths. Overlay wrappers may keep copy-out-relative paths matching live `~/.cursor` — documented on overlay index, not mixed into base files.
- Name map (index only): `plan-reviewer` → `plan_reviewer`; `reviewer-a` → `production_readiness_reviewer`; Bugbot → `bug_reviewer`.
- Unique content in short contracts merges into repo-root bases — no parallel `docs/skills/*.md` after Phase 4.
- **Promote mechanic (Phase 4):** Copy overlay extract bodies into root `skills/` / `agents/` / `rules/`. Overlay files stay fat until Phase 5 replaces them. Do not `git mv` overlay SKILL.md / agent files away in Phase 4.
- **Escalation when-table precedence (Phase 4):** Target `docs/skills/implementation-plan.md` **When** rows win. Overlay SKILL body supplies the rest. `workflow/plan-agent-context.md` points at `skills/implementation-plan/SKILL.md`. Full CI asserts one when-table in that SKILL.
- **`pre-commit-ci-gate` destination:** Target contract + overlay `.mdc` body → `rules/pre-commit-ci-gate.md`. Overlay keeps thin `.mdc`. Not a sixth SKILL.md.
- **Leaf map:** see Phase 4 Named leaf map. No extra `docs/skills` or `docs/agents` markdown leaves beyond that table.
- **Phase 2 cite contract:** After `git mv`, same-phase inbound cite repair from remaining `docs/**` and `README.md`. Do not leave hubs broken until Phase 6. Imported banners unchanged.
- **Review-loop cap (this program):** Phase subagents at most **4** dual-review iterations (Fast CI Observed → reviewer-a ∥ Bugbot → fix). Reset to 1 at phase start and after Composer renew. Spec launches to this phase’s Agent context only. Do not launch a 5th pair. If iteration 4 lacks dual APPROVED: stop, return punch list to Composer. Composer: (1) Renew ≤4 with narrowed spec; (2) Waive out-of-spec/process nits with attestation — **do not waive** Fast/Full CI failures; (3) Change approach. Dual APPROVED preferred.

## Migration / external apply order

None. Git only. No live Cursor apply.

## Checklist

- [x] Phase 1 — Architecture lock (taxonomy / Approach A / freeze inventory). **Composer waiver:** after 8 dual-review iterations (4 + renew 4), remaining Roadmap/desired-behavior/promotion-rule wording nits deferred; Fast/Full allowlist greps passed. Not a proven dual APPROVED bar.
- [x] Phase 2 — git mv research, review, analysis, overlays to root + same-phase cites. `analysis/` at repo root.
- [x] Phase 3 — Promote overlay workflow docs to `workflow/`. `review-subagent-models.md` parked on overlay. Fat SKILL `docs/workflow` links non-navigable until Phase 5.
- [x] Phase 4 — Copy skills/agents/rules; fold short contracts. Overlay fat files still in place.
- [x] Phase 5 — Thin Cursor overlay; spawn extract. SHA256 byte-identical tables retired.
- [x] Phase 6 — Cite sweep closeout. **Composer waiver:** Bugbot false-positive on deleted `docs/skills/`; Reviewer-a APPROVED; Full CI hub checks passed.

---

#### Agent context — Phase 1

- **Goal:** Architecture lock so later moves are not a second taxonomy fight.
- **Depends on / entry gate:** This plan accepted.
- **Do not touch:** Overlay file bodies; `research/imported/**` content; live `~/.cursor`.
- **In scope:** Overlay FA, instruction-layering, intended-workflow, desired-behavior-vs-cursor-specific, cursor-behavior-to-reproduce, clean-context-isolation, agent-roles-and-model-assignment; `docs/SOPs/documenting-this-repo.md`, `docs/SOPs/_index.md`, `docs/Roadmap.md`, `README.md`, `docs/review/design-decisions.md` (still under `docs/` until Phase 2). Grep inventory of Required “lean agent / docs/skills contract SoT / bloated overlay anti-pattern / no host IDs in shared contracts” **and freeze / do-not-rewrite overlay bodies** claims (documenting SOP Forbidden, overlay `_index` “bodies frozen”, design-decisions “bodies unchanged”). Update **all allowlist hits** to Approach A this phase: repo-root bases may be authored; overlay becomes thin wrappers in Phase 5 (no longer a frozen byte-identical extract). **Temporary exception (do not re-block Phase 4):** repo-root bases may contain Cursor Task / `subagent_type` / Bugbot IDs until Phase 5 extracts them — interim FA exception, not end-state. Revise design-decisions taxonomy row (openBuggy `docs/` mirror) so root `workflow/`/`skills/`/`research/` is allowed.
- **Out of scope:** `git mv`; thinning overlays; rewriting conductor Agent context in this file (Composer owns status after QC).
- **Files expected:** Taxonomy table; Approach A recorded; lean-claim inventory closed (zero remaining Required contradictions).
- **Where to read context:** this roadmap A/B/C; overlay FA promotion rule; documenting SOP.
- **Fast CI:** Hub links on touched indexes. Lean-SoT grep **allowlist only:** `docs/featureArchitecture/`, `docs/SOPs/`, `docs/Roadmap.md`, `README.md`, `docs/review/` (authored), `docs/overlays/_index.md`, `docs/overlays/cursor/_index.md`. **Do not** fail on `research/imported/**` or fat overlay SKILL/agent bodies. Hits in allowlist: rewrite. Hits in import/fat overlay: **reclassify** (ignore until Phase 5 overlay rewrite / import stays archaeology).
- **Full CI:** Same allowlist; leftover “workflow lives under overlays/cursor” as SoT gone from allowlist.
- **Deliverables:**
  - [ ] Documenting SOP kinds table
  - [ ] Approach A + rejected B/C in overlay FA (**target taxonomy** until Phase 4 lands bases — do not claim present-tense “root `skills/` is SoT” before those trees exist)
  - [ ] Lean-claim **and freeze/do-not-rewrite** inventory closed
  - [ ] Design-decisions taxonomy row revised for root deliverables
  - [ ] Dual APPROVED
- **Review loop:** Inherit **4-iteration cap**. Spec reviewers to this phase’s allowlist only.
- **Risks:** Reviewers re-litigate every “canonical” phrase — **scope reviews to Phase 1 files only**. Hit the cap → Composer, do not self-renew.

#### Agent context — Phase 2

- **Goal:** Un-cramp `docs/` by moving primary deliverable trees to root.
- **Depends on / entry gate:** Phase 1 dual APPROVED (or Composer-attested waiver per cap).
- **Do not touch:** Skill/agent/workflow **bodies**; imported file substance.
- **In scope:** `git mv docs/research → research`, `docs/review → review`, `docs/analysis → analysis`, `docs/overlays → overlays`. Same-phase inbound cite repair in `README.md`, `docs/featureArchitecture/`, `docs/SOPs/`, `docs/Roadmap.md`, `docs/roadmaps/`, `docs/skills/`, `docs/agents/` from `docs/research|review|analysis|overlays` to root paths (and fix relative `../overlays` vs `../../overlays` after the move). Keep `docs/featureArchitecture`, `docs/SOPs`, `docs/roadmaps`, `docs/Roadmap.md`.
- **Out of scope:** Promoting skills/workflow yet; rewriting import banners.
- **Files expected:** Root `research/`, `review/`, `analysis/`, `overlays/`; README directory map; authored hubs open to moved trees.
- **Where to read context:** Phase 1 taxonomy; COPY-MANIFEST (update dest prefixes only).
- **Fast CI:** Grep `docs/research`, `docs/review`, `docs/analysis`, `docs/overlays` in authored trees (`README.md`, `docs/featureArchitecture`, `docs/SOPs`, `docs/Roadmap.md`, `docs/roadmaps`, `docs/skills`, `docs/agents`) — zero remaining path cites except quoted archaeology. Exclude `research/imported/**` internal historical strings if they are quotes.
- **Full CI:** Sample imported indexes still open; sibling relative links in README (`../openBuggy`) unchanged; from README open `review/design-decisions.md` and `overlays/cursor/_index.md`.
- **Deliverables:**
  - [ ] Moves complete; hubs updated; dual APPROVED
- **Review loop:** Inherit **4-iteration cap**. Spec = moved trees + inbound cite repair only.
- **Risks:** Hundreds of relative links. Prefer systematic grep. Do not rewrite import banners. Hit the cap → Composer.

#### Agent context — Phase 3

- **Goal:** Shared deep docs at `workflow/` (not under Cursor).
- **Depends on / entry gate:** Phase 2 dual APPROVED.
- **Do not touch:** Overlay SKILL.md / agents / rules bodies (still fat until Phase 5); imported workflow copies.
- **In scope:** Move eight procedure files from `overlays/cursor/docs/workflow/` → `workflow/` (`README.md` becomes `workflow/_index.md`; seven named procedure leaves plus that index). Used-by matrix + name map on `_index.md`; delete empty `overlays/cursor/docs/`; park `review-subagent-models.md` on Cursor overlay. Fat overlay SKILL/agent bodies stay untouched. Contract: those fat files’ `docs/workflow` links are **non-navigable until Phase 5**. Phase 3 workflow leaves point at `docs/skills`/`docs/agents`; Phase 4 retargets.
- **Out of scope:** Thinning skills; path-rewriting fat overlay SKILL.md.
- **Files expected:** `workflow/_index.md` (from README) + `discovery.md`, `documentation-architecture.md`, `phased-multi-agent.md`, `plan-agent-context.md`, `iterative-plan-review.md`, `iterative-code-review.md`, `ci-ladder.md`; overlay pointer that fat extract is non-navigable for deep docs until Phase 5.
- **Where to read context:** this roadmap association model; instruction-layering Layer 3.
- **Fast CI:** Every `workflow/` leaf linked from `_index.md`.
- **Full CI:** No `overlays/cursor/docs/workflow/` except git history.
- **Deliverables:**
  - [ ] One SoT for discovery, plan/review loops, ci-ladder, plan-agent-context, phased-multi-agent, documentation-architecture procedure
  - [ ] Dual APPROVED
- **Review loop:** Inherit **4-iteration cap**. Spec = `workflow/` move + `_index` + overlay pointer; not SKILL thinning.
- **Risks:** Dual tree if overlay workflow left in place — delete after move. Hit the cap → Composer.

#### Agent context — Phase 4

- **Goal:** Root `skills/`, `agents/`, `rules/` are the repo-root bases; `docs/skills` and `docs/agents` gone.
- **Depends on / entry gate:** Phase 3 dual APPROVED. Extra: grep `workflow/` for `docs/skills` / `docs/agents` — must be retargeted this phase.
- **Do not touch:** Live `~/.cursor`; `research/imported/**` skill copies; thinning (Phase 5).
- **In scope (promote = copy):** Copy overlay `SKILL.md` bodies → `skills/<name>/SKILL.md` (overlay originals stay). Apply when-table merge rule. Same phase: rewrite all copied `skills/` and `agents/` deep-doc links from `docs/workflow/` to repo-root `workflow/` (`review-subagent-models` overlay-only). Apply named leaf map; delete `docs/skills/` and `docs/agents/` only after every row is done; retarget `workflow/` cites of `docs/skills`/`docs/agents`.
  - overlay extract `plan-reviewer.md` body → `agents/plan_reviewer.md`. Merge unique from lean, then delete lean. One file, portable name.
  - overlay extract `reviewer-a.md` body → `agents/production_readiness_reviewer.md`. Merge unique from lean, then delete lean.
  - Lean-only: `git mv` `planner.md`, `implementer.md`, `bug_reviewer.md`, `repository_explorer.md`, `test_reviewer.md` → `agents/<same>.md`.
  - Do not keep both `plan-reviewer.md` and `plan_reviewer.md` at root.
- **Named leaf map:**

  `docs/skills/`:
  - `_index.md` → rewrite as `skills/_index.md`
  - `implementation-plan.md` → merge unique into `skills/implementation-plan/SKILL.md` (when-table from this file); then delete
  - `implementation-review.md` → merge into `skills/implementation-review/SKILL.md`; then delete
  - `composer.md` → merge into `skills/composer/SKILL.md`; then delete
  - `roadmap.md` → merge into `skills/roadmap/SKILL.md`; then delete
  - `documentation-architecture.md` → merge into `skills/documentation-architecture/SKILL.md`; then delete
  - `discovery.md` → merge unique into `workflow/discovery.md`; then delete (no `skills/discovery/SKILL.md`)
  - `plan-review.md` → merge unique into `workflow/iterative-plan-review.md` + `skills/implementation-plan/SKILL.md`; then delete
  - `pre-commit-ci-gate.md` → merge into `rules/pre-commit-ci-gate.md`; then delete

  `docs/agents/`:
  - `_index.md` → rewrite as `agents/_index.md`
  - `plan_reviewer.md` → merge unique into copied overlay extract → `agents/plan_reviewer.md`; then delete lean
  - `production_readiness_reviewer.md` → merge unique into copied overlay extract → `agents/production_readiness_reviewer.md`; then delete lean
  - `planner.md`, `implementer.md`, `bug_reviewer.md`, `repository_explorer.md`, `test_reviewer.md` → `git mv` to `agents/<same>.md`

  Overlay (copy body; originals stay fat):
  - `overlays/cursor/skills/*/SKILL.md` → `skills/<name>/SKILL.md`
  - `overlays/cursor/agents/plan-reviewer.md` → `agents/plan_reviewer.md`
  - `overlays/cursor/agents/reviewer-a.md` → `agents/production_readiness_reviewer.md`
  - overlay `.mdc` bodies → `rules/*.md`; `.mdc` remain overlay until Phase 5
- **Where to read context:** overlay extract files; short contracts for merge-only; this named leaf map.
- **Out of scope:** Writing thin overlays; `git mv` of overlay skill/agent files.
- **Files expected:** Five `skills/*/SKILL.md`; seven `agents/*.md`; three `rules/*.md`; two indexes; overlay fat files still present; `docs/skills/` and `docs/agents/` gone; leaf-map rows ticked.
- **Fast CI:** Indexes list every skill/agent/rule; no `docs/skills` leftover; when-table matches Target When rows; grep `skills/` and `agents/` for `docs/workflow` — zero hits; sample SKILL.md links open to `workflow/`.
- **Full CI:** Escalation when-table exists once; `plan-agent-context` has no competing when-table; same `docs/workflow` grep on promoted bases.
- **Deliverables:**
  - [ ] Single skill tree; single agent tree; dual APPROVED
- **Review loop:** Inherit **4-iteration cap**. Spec = named leaf map + copy/promote + `docs/workflow` grep on bases; not overlay thinning.
- **Risks:** Filename clash `plan-reviewer.md` vs `plan_reviewer.md` — portable names at base. Hit the cap → Composer.

#### Agent context — Phase 5

- **Goal:** `overlays/cursor/` is actually an overlay (copy-out sized).
- **Depends on / entry gate:** Phase 4 dual APPROVED.
- **Do not touch:** Base skill/agent/workflow/rule procedure bodies except link fixes; live `~/.cursor`.
- **In scope:** Replace still-fat overlay SKILL.md / agents / .mdc with thin wrappers and extract Cursor spawn / `subagent_type` / Bugbot launch blocks out of root `skills/` and overlapping `agents/` into those wrappers (do not rephrase the loop). Keep `user-rules-snippet.md` overlay-only. Overlay `_index.md` copy-out map. Do not move `review-subagent-models.md` into `workflow/`.
- **Out of scope:** Generating files into `~/.cursor`; OpenCode wrappers.
- **Files expected:** Small overlay files only; copy-out table.
- **Where to read context:** overlay FA “what may differ per stack”; instruction-layering Cursor mappings.
- **Fast CI:** Overlay files do not contain full loop essays (spot-check vs inventory); every overlay path in the inventory exists and points at a base file. Confirm `skills/<name>/SKILL.md` → `../../workflow/...` links. Spawn-extract method: `git diff` on `skills/` and `agents/` vs Phase 4 tree; allowed hunks are only spawn/`subagent_type`/Bugbot blocks. Any other procedure-table/verdict-bar edit is a fail.
- **Full CI:** No `subagent_type` / Bugbot launch recipes in root `skills/` or `agents/` (including lean-only `agents/bug_reviewer.md`). Overlay index documents `~/.cursor/docs/workflow` vs repo `workflow/` mismatch; retire SHA256 byte-identical tables.
- **Deliverables:**
  - [ ] Thin Cursor overlay; dual APPROVED
- **Review loop:** Inherit **4-iteration cap**. Spec = thin wrappers + spawn-extract git diff hunks only.
- **Risks:** Accidental procedure edit while extracting spawn blocks. Hit the cap → Composer.

#### Agent context — Phase 6

- **Goal:** Closeout — the repo is navigable as a manager, not a `docs/` junk drawer.
- **Depends on / entry gate:** Phase 5 dual APPROVED.
- **Do not touch:** Procedure wording.
- **In scope:** Remaining cite sweep; README/Roadmap directory diagrams; documenting SOP path table final; relationship-to-siblings; FA indexes; grep leftovers `docs/overlays`, `docs/skills`, `docs/agents` (except historical quotes in init report).
- **Out of scope:** New skills; OpenCode.
- **Files expected:** Consistent hubs.
- **Where to read context:** this roadmap layout table.
- **Fast CI:** From README, reach workflow, skills, agents, rules, overlays/cursor, research, review, docs/FA without broken links.
- **Full CI:** Same + “bulk not under overlays/cursor” (overlay dir small vs `skills/`+`workflow/`+`agents/`).
- **Deliverables:**
  - [ ] Closeout QC; dual APPROVED; Full CI
- **Review loop:** Inherit **4-iteration cap**. Spec = remaining cites + hub QC; not procedure rewrites.
- **Risks:** Init report / imported banners still say old paths — imported banners stay. Hit the cap → Composer.

---

## Association model (Phase 3 `_index`)

| Workflow leaf | Base skill | Base agent(s) | Cursor overlay | Rule overlay |
| ------------- | ---------- | ------------- | -------------- | ------------ |
| `discovery.md` | (none) | `planner`, `repository_explorer` | skill Read pointers | — |
| `iterative-plan-review.md` | `skills/implementation-plan/SKILL.md` | `plan_reviewer` | overlay plan SKILL | `iterative-plan-review.mdc` |
| `iterative-code-review.md` | `skills/implementation-review/SKILL.md` | `production_readiness_reviewer`, `bug_reviewer` | review SKILL + `reviewer-a.md` | `iterative-code-review.mdc` |
| `ci-ladder.md` | `implementation-review`, `rules/pre-commit-ci-gate.md` | implementer (parent) | review skill Read | `pre-commit-ci-gate.mdc` |
| `plan-agent-context.md` | `implementation-plan` | `plan_reviewer` | plan skill Read | — |
| `phased-multi-agent.md` | `composer`, `roadmap` | planner / implementer as conductor | `composer/SKILL.md` | — |
| `documentation-architecture.md` | `documentation-architecture` | — | that SKILL.md | — |

## Thin overlay inventory (Phase 5)

| Overlay path | Wrapper contains | Points at |
| ------------ | ---------------- | --------- |
| `overlays/cursor/skills/implementation-plan/SKILL.md` | YAML, disable-model-invocation, plan-reviewer Task spawn, Read table | `skills/implementation-plan/SKILL.md`, `workflow/*` |
| `overlays/cursor/skills/implementation-review/SKILL.md` | YAML, reviewer-a + Bugbot spawn, Read table | `skills/implementation-review/SKILL.md`, `workflow/*` |
| `overlays/cursor/skills/composer/SKILL.md` | YAML, Cursor conductor notes, Read | `skills/composer/SKILL.md` |
| `overlays/cursor/skills/roadmap/SKILL.md` | YAML, Read | `skills/roadmap/SKILL.md` |
| `overlays/cursor/skills/documentation-architecture/SKILL.md` | YAML, Read | `skills/documentation-architecture/SKILL.md` |
| `overlays/cursor/skills/*/user-rules-snippet.md` | Cursor paste targets only | `rules/*.md` |
| `overlays/cursor/agents/plan-reviewer.md` | Cursor name + spawn one-pager + Read | `agents/plan_reviewer.md` |
| `overlays/cursor/agents/reviewer-a.md` | same | `agents/production_readiness_reviewer.md` |
| `overlays/cursor/rules/iterative-plan-review.mdc` | alwaysApply + pointer | `rules/iterative-plan-review.md` |
| `overlays/cursor/rules/iterative-code-review.mdc` | alwaysApply + pointer | `rules/iterative-code-review.md` |
| `overlays/cursor/rules/pre-commit-ci-gate.mdc` | alwaysApply false + pointer | `rules/pre-commit-ci-gate.md` |
| `overlays/cursor/review-subagent-models.md` | Cursor model slugs | — |
| `overlays/cursor/_index.md` | copy-out map + provenance | all of the above |

## Related

- [Roadmaps index](./_index.md)
- [Skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)
- [Documenting this repo](../SOPs/documenting-this-repo.md)
