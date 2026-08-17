# Roadmap: cursorEscape initialization

**Last updated:** 2026-08-17  
**Status:** Phase 3 QC accepted — committing; Phase 4 next  
**Phase 1 commit:** `ca56ca4`  
**Phase 2 commit:** `5ab9428`  
**Escalation:** yes (`complex-or-extensive`)  
**Accepted plan:** `cursorEscape repo init` (plan-reviewer APPROVED, 2 of 3)

## Product decisions (locked)

| Decision | Choice |
|----------|--------|
| Repository name | **cursorEscape** |
| Approach | A′ — docs-first openBuggy taxonomy; three import trees; live `~/.cursor` canonical for Target workflow |
| Runtime this roadmap | **None** — documentation foundation only |
| Na preview | **Skipped** — no UI surface for docs bootstrap |
| Full CI (this repo, pre-runtime) | Hub/index link integrity + no runtime engine artifacts + phase deliverable checklist |
| Fast CI (this repo, pre-runtime) | Same link/manifest checks scoped to phase files |

## Inter-phase contracts

- Authoring minimum on substantive docs: Last updated, Context, Substance, Implications
- Section `_index.md` updated in the same change as new leaves
- Imported research: provenance banner; Observed ≠ Target
- Synthesizing docs classify claims: Desired / Required / Nice-to-have / Cursor-specific / Unknown
- No runtime code, adapters, packages, or eval runners in any phase
- Extend-only shared hubs: `README.md`, `docs/Roadmap.md`, `docs/review/design-decisions.md`, `docs/research/imported/COPY-MANIFEST.md` (from Phase 2 onward)

## Migration / external apply order

- None

## Phase checklist

- [x] Phase 1 — Bootstrap hubs
- [x] Phase 2 — Copy openBuggy research
- [x] Phase 3 — Copy AITestSuite + live `~/.cursor`; workflow-source-delta
- [ ] Phase 4 — Target synthesizing docs
- [ ] Phase 5 — Initialization report + closeout

---

#### Agent context — Phase 1

- **Goal:** Bootstrap empty repo skeleton and hub docs
- **Depends on / entry gate:** Plan accepted; this roadmap exists
- **Do not touch:** openBuggy, AITestSuite contents (read-only); no runtime code; do not start Phase 2 copies
- **In scope:** `README.md`; `docs/Roadmap.md`; `docs/review/{_index.md,design-decisions.md}`; `docs/{featureArchitecture,SOPs,research,analysis,roadmaps}/_index.md`; `docs/SOPs/documenting-this-repo.md` (adapted from openBuggy); `.gitignore` (`**/.local/`, `node_modules/`, `.env*`); `git init` if needed; link this conductor roadmap from `docs/roadmaps/_index.md`
- **Out of scope:** Research copies; deep FA leaves; Target synthesizers
- **Files expected:** hubs + indexes + documenting SOP + design-decisions + README + gitignore + roadmaps index linking this file
- **Where to read context:** `C:\Users\admin\source\repos\general-projects\openBuggy\docs\SOPs\documenting-this-concept-repo.md`; `C:\Users\admin\.cursor\docs\workflow\documentation-architecture.md`; `C:\Users\admin\.cursor\docs\workflow\discovery.md`; this roadmap
- **Fast CI:** Verify all hub/index relative links resolve; no broken paths among Phase 1 files
- **Full CI:** Same + confirm no runtime `package.json` / engine scaffolding accidentally added
- **Deliverables:**
  - [ ] Repo name/purpose stated in README
  - [ ] Roadmap hub + section indexes (including analysis)
  - [ ] Design decisions: goals, non-goals, stewardship, replaceability principle
  - [ ] Documenting SOP
  - [ ] `.gitignore` with openBuggy-like patterns
  - [ ] Git repository initialized
- **Risks:** Inventing parallel taxonomy — mitigate by mirroring openBuggy folders

---

#### Agent context — Phase 2

- **Goal:** Copy openBuggy research relevant to workflow/Cursor behavior/review loops; write provenance + relationship doc
- **Depends on / entry gate:** Phase 1 hubs exist and committed
- **Do not touch:** openBuggy `eval/`; analysis `.local/`; Composer TEMP / mining ops roadmaps (cite only); Phase 3+ imports
- **In scope:** After index-walk of openBuggy `_index.md` trees, copy into `docs/research/imported/openBuggy/` (at minimum): design-decisions; `featureArchitecture/market-gap-and-positioning.md`; `ide-and-agent-integration.md`; `context-retrieval.md`; `findings-schema-and-agent-contract.md`; `competitive-landscape.md`; full `cursor-bugbot-agent-review/**`; `SOPs/running-an-agent-review-loop-with-openBuggy.md`; `analysis/reviewer-effectiveness/**` excluding `.local/`; research `bugbot-product-and-api-limits.md`, `latency-and-api-gap.md`, `competitor-product-notes.md`; needed indexes. Write `docs/review/relationship-to-siblings.md`; create `docs/research/imported/COPY-MANIFEST.md` with provenance format and host-only link notes.
- **Out of scope:** Entire `eval/` tree; AITestSuite or `~/.cursor` copies
- **Files expected:** imported tree; relationship doc; COPY-MANIFEST
- **Where to read context:** openBuggy `docs/Roadmap.md`, FA `_index`, analysis `_index`, research `_index`, SOPs `_index`
- **Fast CI:** Manifest lists every copied file with source path; `.local` absent; hub links still resolve
- **Full CI:** Fast + no eval/cases copied
- **Deliverables:**
  - [ ] Copies landed with provenance banners
  - [ ] Manifest documenting what/why
  - [ ] Sibling relationship doc (openBuggy = external Bugbot leg + research; not reimplemented initially)
- **Risks:** Over-copying Bugbot eval ops — stick to finalized copy set from index walk

---

#### Agent context — Phase 3

- **Goal:** Import AITestSuite Phase 4 freeze + live `~/.cursor` workflow; produce source-delta note
- **Depends on / entry gate:** Phase 2 complete; **live-vs-freeze diff discovery completed** before copy lock
- **Do not touch:** `review-profiles/**`; app trees; goldens; openBuggy re-copy beyond manifest updates
- **In scope — AITestSuite allowlist only** under `tests/ez-pz-streaming-media-phase-4/` (plus suite/meta as listed):
  - `baseline/.cursor/skills/{implementation-plan,implementation-review,reference-docs}/SKILL.md`
  - `baseline/.cursor/agents/{plan-reviewer,reviewer-a}.md`
  - `baseline/.cursor/rules/{iterative-plan-review,iterative-code-review}.mdc`
  - `baseline/referenceFiles/SOPs/{iterative-plan-review,iterative-code-review,review-loop-model-profiles,reference-docs-check}.md`
  - `REVIEW_LOOP.md` — label Observed/eval-packaging
  - Suite `docs/scoring-framework.md`
  - `evaluation/USER_INPUT_STOPS.md`
  - `meta/lessons-learned.md` from Phase 2, 4, and 6 tests
- **In scope — cursor-global-workflow:**
  - All 9 files under `C:\Users\admin\.cursor\docs\workflow\`
  - rules: iterative-plan-review, iterative-code-review, pre-commit-ci-gate
  - skills: implementation-plan, implementation-review, composer, roadmap, documentation-architecture (+ co-located `user-rules-snippet.md` when present)
  - agents: plan-reviewer.md, reviewer-a.md
- **Also write:** `docs/research/imported/workflow-source-delta.md` (diff live workflow + freeze `referenceFiles/SOPs/` vs freeze `.cursor`)
- **Out of scope:** Path creep beyond allowlist
- **Files expected:** `imported/AITestSuite/...`; `imported/cursor-global-workflow/...`; delta note; updated COPY-MANIFEST
- **Where to read context:** AITestSuite README; Phase 4 paths; live `~/.cursor` trees; Phase 2 manifest
- **Fast CI:** No node_modules/baselines; allowlist respected; delta note exists
- **Full CI:** Fast + entry gate for Phase 4 (delta present)
- **Deliverables:**
  - [ ] Dual import complete
  - [ ] workflow-source-delta.md written
  - [ ] COPY-MANIFEST updated (host-only link annotations)
- **Risks:** Copying large baselines — hard path-guard

---

#### Agent context — Phase 4

- **Goal:** Author Target synthesizing architecture/workflow docs (project IP)
- **Depends on / entry gate:** Phase 3 imports + `workflow-source-delta.md` present
- **Do not touch:** Replacing imports; implementing runtime; starting Phase 5 report prematurely as substitute for FA docs
- **In scope (fixed homes):**
  - `docs/featureArchitecture/intended-workflow.md` (canonical = live; cite delta)
  - `docs/featureArchitecture/desired-behavior-vs-cursor-specific.md`
  - `docs/featureArchitecture/cursor-behavior-to-reproduce.md`
  - `docs/featureArchitecture/backend-and-provider-abstraction.md`
  - `docs/featureArchitecture/repository-discovery-and-context.md`
  - `docs/featureArchitecture/workspace-model.md`
  - `docs/featureArchitecture/agent-roles-and-model-assignment.md`
  - `docs/featureArchitecture/evaluation-methodology.md`
  - `docs/research/preliminary-backend-landscape.md`
  - `docs/review/unresolved-architectural-questions.md`
  - `docs/roadmaps/implementation-roadmap.md` (future work; research-first)
  - `docs/agents/_index.md` + role contract pages
  - `docs/skills/_index.md` + skill contract pages (host-agnostic; derive from live skills)
  - Update all `_index.md` and `docs/Roadmap.md`
- **Out of scope:** Implementing any runtime; initialization-report (Phase 5)
- **Files expected:** listed Target docs; index/Roadmap updates
- **Where to read context:** imported research; workflow-source-delta.md; this roadmap; accepted plan archaeology
- **Fast CI:** Roadmap links every major Target doc; claim taxonomy consistent; hub links resolve
- **Full CI:** Fast + no pretend-settled Unknowns
- **Deliverables:** User deliverables 2–4, 6–12 satisfied (docs exist and discoverable)
- **Risks:** Doc sprawl — one job per doc; no fake scaffolding

---

#### Agent context — Phase 5

- **Goal:** Closeout documentation quality + initialization report
- **Depends on / entry gate:** Phase 4 Target docs complete
- **Do not touch:** Starting roadmap next-implementation tasks; rewriting Phase 4 FA unless fixing Phase 5 link/report gaps
- **In scope:** `docs/review/initialization-report.md` answering §17 Q1–9: (1) relevant findings in siblings (2) what copied where (3) core requirements (4) highest-risk problems (5) relevant OSS projects (6) preliminary Cline vs OpenCode (7) proposed repo-discovery approach (8) deliberately unresolved decisions (9) recommended next tasks — **do not start them**; polish README agent discovery path; spot-check link integrity; ensure COPY-MANIFEST complete
- **Out of scope:** Executing next research/implementation tasks
- **Files expected:** initialization-report; README updates; minor index fixes if needed
- **Where to read context:** all prior phase deliverables; COPY-MANIFEST; Roadmap
- **Fast CI:** README→Roadmap alone answers what/why
- **Full CI:** Narrative README→Roadmap→design-decisions→intended-workflow→unresolved coherent; no runtime engine artifacts
- **Deliverables:**
  - [ ] Initialization report complete
  - [ ] Coherent discovery path
  - [ ] No runtime packages
- **Risks:** Report duplicates Roadmap — report = archaeology/decisions snapshot; Roadmap = living hub
