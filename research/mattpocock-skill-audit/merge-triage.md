# Phase 2 Merge Triage

**Status:** Owner accepted 2026-08-21. Phase 3 implementation begins with F1 `codebase-design reference`.

**Snapshot:** `mattpocock/skills` commit `0ab1b63`.

## Decision Rule

This ranking applies only to the owner-accepted `Adopt` and `Adapt` proposals in [discussion-record.md](findings/discussion-record.md). Scores are `leverage x fit x cost`, each from 1 (low) to 5 (high), where cost is scored as low implementation cost. Rank is the resulting priority adjusted for dependencies, centrality, and overlap, so it is not simply a descending sort of the product. The product is a prioritization aid, not an implementation authorization. Every Phase 3+ item still needs the repository's plan, plan review, implementation, dual review, and Full CI closeout unless an owner-approved policy says otherwise.

The two bug proposals are intentionally separate:

- `B1` is user-invoked diagnosis for bugs in already accepted or shipped code.
- `B2` is a narrowly scoped evidence improvement to the always-on `bug_reviewer` change-review leg. It is not diagnosis and must not change that leg's purpose.

## Ranked Decisions

| Rank | ID | Proposal | Verdict | L x F x C | Decision and overlap/consolidation note |
|---:|---|---|---|---:|---|
| 1 | F1 | `codebase-design` reference | Adopt | 5 x 5 x 4 = 100 | Build first as shared vocabulary. It is a non-driver dependency for architecture survey and TDD, not a second process. |
| 2 | F2 | `tdd` reference | Adopt | 5 x 5 x 3 = 75 | Add seam, red-green, vertical-slice, oracle, and mocking guidance. Reuse F1 vocabulary and existing implementation/review gates. |
| 3 | F3 | `grilling` alignment primitive | Adapt | 4 x 4 x 3 = 48 | Add the optional frontier interview before planning. It remains subordinate to `implementation-plan`; it does not replace `plan_reviewer`. |
| 4 | F4 | `grill-with-docs` plan precursor | Adapt | 4 x 4 x 2 = 32 | Fold into the implementation-plan path, building on F3 and the domain-modeling policy. Do not create a second interview wrapper or automatic ADR tree. |
| 5 | F5 | `implement` thin adaptation | Adapt | 4 x 5 x 4 = 80 | Although its product ranks with the foundation work, implement after F2 so one-ticket vertical slices become guidance for the existing implementer, not a competing loop. |
| 6 | F6 | `code-review` evidence frame | Adapt | 5 x 3 x 2 = 30 | Extend the existing dual gate only. Standards-vs-Spec is an optional report frame, not a third reviewer or default gate. |
| 7 | B1 | User-invoked `diagnosing-bugs` | Adopt | 5 x 4 x 2 = 40 | Separate runtime diagnosis workflow. It may hand code changes back to the normal implementation and review loop. |
| 8 | B2 | Bug-review evidence improvements | Adapt | 4 x 4 x 3 = 48 | Separate from B1. Add only cheap, read-only reproduction/inspection, minimisation, or evidence framing to `bug_reviewer`; preserve the mandatory diff-review purpose. |
| 9 | F7 | `research` cited artifact | Adapt | 4 x 4 x 3 = 48 | Add bounded primary-source research as a read-only child artifact. It complements repository exploration and cannot recursively delegate. |
| 10 | F8 | `domain-modeling` procedure | Adapt | 4 x 4 x 2 = 32 | Use suitable existing glossary/design-decision documents; otherwise use the active plan or research artifact. Durable documents require explicit owner approval. |
| 11 | F9 | Architecture improvement survey | Adapt | 4 x 3 x 2 = 24 | Read-only Markdown-first survey, deletion test, candidate card, and owner checkpoint. Consolidate its design vocabulary with F1 and route selected work to planning. |
| 12 | F10 | `prototype` pattern | Adapt | 4 x 4 x 3 = 48 | Formalize the broad, repository-agnostic question-first pattern using the existing EZPZ precedent. Disposable artifacts and promoted decisions need explicit boundaries. |
| 13 | F11 | `wizard` human-only procedure | Adapt | 4 x 3 x 2 = 24 | Keep stage/value/safety mapping and static validation, but use a portable contract and overlays instead of the Bash/GitHub template. |
| 14 | F12 | `writing-for-agents` rubric | Adapt | 4 x 5 x 4 = 80 | Extend the existing documentation workflow. Do not import upstream publishing, router, or model metadata mechanics. |
| 15 | F13 | `handoff` thin portability contract | Adapt | 3 x 4 x 4 = 48 | Extend Composer's handoff documentation, not Composer's cap-specific procedure. Distinguish user portability from cap-exhausted QC. |
| 16 | F14 | `teach` dedicated workflow | Adopt | 3 x 3 x 2 = 18 | Build as an isolated learning workspace, not normal coding and not an active product-repo writer. Start text/Markdown-first; HTML is optional. |
| 17 | F15 | `resolving-merge-conflicts` | Adapt | 3 x 5 x 3 = 45 | Small Git procedure with intent-traced hunks and verification. Preserve user-authorized abort and local commit/CI authority. |
| 18 | F16 | `wait-what` | Adapt | 2 x 5 x 5 = 50 | Thin user-invoked communication trigger. Reuse local discovery and provide a no-glossary fallback; no new glossary. |
| 19 | I1 | Thin authoring format | Adopt-pattern | 3 x 5 x 4 = 60 | Apply pointer-first `SKILL.md` plus companion discipline to future phases. This is a format rule, not imported upstream infrastructure. |
| 20 | I2 | User vs model invocation | Adopt-pattern | 4 x 5 x 4 = 80 | Define portable on-demand intent and express it through host overlays; do not copy `openai.yaml` policy. |
| 21 | I3 | Context/ADR discipline | Adopt-pattern | 4 x 4 x 3 = 48 | Use existing local decision/document SoT and the owner policy from F8. No default `CONTEXT.md` or ADR tree. |
| 22 | I4 | Human-facing docs pages | Adopt-pattern | 2 x 4 x 3 = 24 | Consider an approved local human-facing docs home for promoted skills only. No new pages are authorized by this triage. |
| 23 | I5 | House style | Adopt-pattern | 2 x 5 x 5 = 50 | Apply no-em-dash and comprehension guidance to new audit/phase prose only; no broad cleanup. |
| 24 | I6 | Out-of-scope discipline | Adopt-pattern | 3 x 5 x 5 = 75 | Continue putting non-goals in the owning roadmap/SOP/architecture artifact; do not create a parallel `.out-of-scope/` tree by default. |

The numeric order is intentionally not a strict implementation queue: the shared foundations and central loop items have dependencies. The phase registry below is authoritative for dependencies and consolidation.

## Adaptation Phase Registry

**Shared review bar:** each phase must pass an approved implementation plan, isolated plan review where required, implementation review's observed Fast CI and dual reviewer gate, and Full CI closeout. The phase-specific bar below adds the source-specific safety condition. No phase authorizes live host installation, pushing, or automatic commits.

| ID and phase name | Goal and cursorEscape artifacts touched | Scope and what changes from mattpocock | Dependencies | Review bar |
|---|---|---|---|---|
| F1 `codebase-design reference` | Add `skills/codebase-design/`, deepening/design-it-twice companions, and relevant indexes/pointers. | Portable deep-module vocabulary, deletion test, seam reasoning, and alternatives. Non-driver reference; local terms and isolated dispatch replace upstream routing and named tools. | None. | Shared bar plus terminology collision check and proof no caller is made an automatic refactoring driver. |
| F2 `tdd reference` | Add `skills/tdd/`, `workflow/tdd-tests.md`, `workflow/tdd-mocking.md`, and implementer/review index pointers. | Public-seam red-green vertical slices, independent expected values, boundary mocks, and explicit no-oracle exception. Refactoring stays in local review rather than the source trigger. | F1 vocabulary. | Shared bar plus tests show seam/oracle guidance is advisory where testing is inappropriate and does not add a gate. |
| F3 `grilling precursor` | Add `skills/grilling/` and a companion workflow; add plan-entry guidance/index pointers. | Optional frontier/facts/decisions/confirmation rounds before a plan. Repository facts may be isolated; owner decisions remain with the owner. No source emoji, host metadata, or action before confirmation. | Existing `implementation-plan`; may use F1 vocabulary. | Shared bar plus confirmation and frontier-empty checks; prove trivial work can bypass it. |
| F4 `grill-with-docs in implementation-plan` | Extend `skills/implementation-plan/` and its companion guidance; touch only relevant indexes and local decision-document pointers. | Make documented alignment part of the plan precursor, using F3 and F8 rules. Existing suitable documents win; unresolved work stays in the active plan. No blind two-skill delegation, automatic writes, root `CONTEXT.md`, or new ADR tree. | F3, F8 policy, existing plan gate. | Shared bar plus owner-authorized write test, failed-write report, and no durable artifact without explicit justification. |
| F5 `implement thin guidance` | Extend `agents/implementer.md` and implementation workflow/index pointers. | One ticket, one vertical slice, targeted checks, and no plan reopening. Remove mandatory commit and upstream self-review; local Fast CI, dual review, Full CI, escalation, and docs-only paths remain authoritative. | F2; existing implementation-review. | Shared bar plus prove no competing build loop, no premature commit, and correct non-empty review diff. |
| F6 `code-review evidence frame` | Extend `skills/implementation-review/` and both reviewer contracts, plus focused workflow documentation. | Optional fixed-point preflight and separate Standards/Spec evidence when a spec exists. Child recursion is prohibited. No third reviewer, no changed default dual-gate count, and no inferred spec. | Existing dual gate; F1/F2 may inform evidence. | Shared bar plus recursion test, fixed-point/non-empty-diff check, citation check, and separate-axis aggregation review. |
| B1 `diagnosing-bugs workflow` | Add `skills/diagnosing-bugs/` and companion workflow; add handoff/index pointers. | User-invoked diagnosis for accepted/shipped bugs and regressions: red loop, minimisation, ranked hypotheses, probes/instrumentation, regression proof, redaction, cleanup. Portable repro ladder replaces Bash-only assumptions; fixes return to normal implementation/review. | Existing implementer and dual gate; may consume B2 follow-up signal. | Shared bar for code changes plus explicit red-command gate, secret-redaction, cleanup, and no silent launch from review. |
| B2 `bug-review evidence leg` | Extend the local bug-review contract and its documentation/index pointers. | Cheap, read-only opportunistic reproduction or inspection only when it does not materially increase review time. It may use evidence-first/minimisation techniques, but never installs, mutates services/databases, writes artifacts, edits instrumentation, or runs full diagnosis. | Existing bug-review contract; OpenBuggy design dependency. | Shared bar plus read-only/time-bound boundary tests and a structured `follow_up` object: `none` or `diagnosis`. `diagnosis` signals, but does not launch, B1. Do not edit OpenBuggy. |
| F7 `bounded research` | Add `skills/research/`, `workflow/research.md`, report schema, and agent/index entries. | One bounded question, one packed read-only child, primary-source claim citations, freshness labels, and one artifact under `research/`. Parent interprets; child cannot re-delegate; output is not contract SoT. | Existing clean-context isolation and research convention. | Shared bar plus nested-delegation prohibition, source/citation/freshness checks, and bounded-output check. |
| F8 `domain-modeling fallback` | Extend local documentation/decision-review guidance and indexes only; no new durable tree by default. | Challenge terms, scenarios, code claims, avoided synonyms, and three ADR criteria. Existing glossary/design-decision docs are preferred; active plan/research is fallback. Durable context/decision docs need owner approval and maintenance benefit. | Existing docs and plan; informs F4. | Shared bar plus artifact-location and write-authorization review; prove ordinary reviews do not mutate durable domain docs. |
| F9 `architecture survey` | Add a standalone survey skill/workflow and optional host renderer pointers; integrate existing `repository_explorer` and plan entry. | Read-only recent-history survey, deletion test, deep-module options, Markdown candidate card, owner selection, then plan handoff. Markdown is canonical; HTML/CDN/browser behavior is optional overlay only. No automatic domain-record mutation. | F1; existing `repository_explorer`, `implementation-plan`. | Shared bar plus read-only mutation check, offline Markdown check, candidate-card completeness, and stop-at-selection check. |
| F10 `repository-agnostic prototype` | Add `skills/prototype/`, companion workflow, cleanup/decision-capture guidance, and only required host-overlay pointers. | Question-first disposable logic/UI prototypes, visible state, and distinct variants where relevant. Existing EZPZ precedent is generalized; source branch/preview mechanics become owner-approved disposable paths, and promoted decisions use the normal plan/review loop. | Existing plan/review; optional F1 vocabulary. | Shared bar plus disposable-path, cleanup, no-production-import, and decision-capture checks. |
| F11 `human-only wizard` | Add `skills/wizard/`, portable companion, host-overlay adapter note, and indexes. | Preserve source/destination/sensitivity/stage mapping, confirmations, ephemeral handling, and static validation. Replace Bash/GitHub template with portable contract and overlays; never run generated interactive procedures in-agent. | Existing host overlay model and safety rules. | Shared bar plus static syntax/value-routing/secret checks and proof no interactive execution or trusted destination assumption. |
| F12 `agent-documentation rubric` | Extend `skills/documentation-architecture/` and companion workflow/indexes. | Context-load, pointer disclosure, information hierarchy, completion criteria, leading words, and no-op pruning. Apply locally; omit upstream site publishing, router, and model-assignment metadata. | Existing documentation architecture. | Shared bar plus pointer/context-load and completion-criteria examples; no unrelated prose cleanup. |
| F13 `portable handoff` | Extend Composer handoff documentation and add `workflow/handoff.md` schema/pointer; touch indexes only as needed. | User-invoked redacted handoff with references, provenance, suggested skills, explicit destination, and recipient revalidation. Durable caller path is preferred; temp output is overlay-only. Do not duplicate Composer cap handoff. | Existing Composer and clean-context isolation. | Shared bar plus redaction, provenance, destination, and non-duplication checks. |
| F14 `teach dedicated workspace` | Add isolated `skills/teach/` contract, companion workspace formats, and neutral host note/index pointers. | Mission, source-grounded resources/citations, small lessons, retrieval/review records, and workspace boundaries. Start text/Markdown-first; optional HTML later. Never write active product repo by default and never load in normal coding. | Existing isolation and research/source conventions. | Shared bar plus workspace-boundary, citation, lesson exit/review, path-resolution, and non-coding invocation checks. |
| F15 `merge-conflict procedure` | Add a Git-specific skill or workflow and index pointers. | Trace each hunk to intent, verify, and finish. Read local SOPs; permit explicitly user-authorized abort where required; never commit on behalf of the user. | Existing Git and CI/commit gates. | Shared bar plus merge-state safety, user-change preservation, intent evidence, and destructive-command checks. |
| F16 `wait-what trigger` | Add a thin user-invoked skill/companion and host advertisement pointers. | Re-pitch by adding missing premise and using local vocabulary when present. Local discovery replaces assumed `CONTEXT.md`; no-glossary fallback is explicit; no model invocation or new glossary. | Existing communication and discovery rules. | Shared bar plus explicit invocation and no-context fallback checks. |
| I1 `thin authoring format` | Apply to future phase artifacts, `skills/_index.md`, and approved companion indexes as part of their owning phases. | Pointer-sized harness plus deep companion; preserve local SoT. Do not import upstream `agents/openai.yaml`. | Existing pointer-first architecture. | Shared bar plus pointer-size/context disclosure and single-SoT checks. |
| I2 `invocation intent` | Add portable trigger wording in accepted skill contracts and host overlay mappings. | Explicit user/model invocation intent, with host-specific encoding in overlays. No shared OpenAI policy YAML. | Existing instruction-layering and overlays. | Shared bar plus invocation-mode and accidental ambient-load checks. |
| I3 `context/ADR discipline` | Apply to F4/F8 documentation and existing decision-document pointers. | Preserve glossary-vs-decision distinction and three ADR tests using existing local homes. No automatic `CONTEXT.md`/ADR scaffolding. | F8 and existing design-decision SoT. | Shared bar plus no-parallel-tree and owner-write checks. |
| I4 `human-facing docs pattern` | Future approved promoted-skill docs home and links from the skill index; no artifact created in this phase. | Use orientation, reach-for, success-signal, and fit guidance where needed. Do not create pages for rejected/reference-only items. | Owner-approved docs home; F12. | Shared bar plus source-of-truth and no-unapproved-tree checks. |
| I5 `house style` | New audit and future phase prose only. | Apply the upstream no-em-dash/comprehension discipline prospectively; no broad cleanup. | Existing repo writing constraints. | Shared bar plus focused docs lint/check; no unrelated edits. |
| I6 `out-of-scope discipline` | Owning roadmaps/SOPs/architecture docs for future phases; no new tree by default. | Keep explicit non-goals at the artifact's SoT. Do not add `.out-of-scope/` or a parallel boundary system unless a later recurring need gets owner approval. | Existing roadmap/SOP conventions. | Shared bar plus scope-boundary review and no parallel SoT check. |

## Explicit Consolidations

- F1 supplies vocabulary to F2 and F9. It does not own either workflow.
- F3 is the reusable interview primitive. F4 is its documented, plan-specific wrapper and also uses F8. `grill-me` remains reference-only rather than becoming a third wrapper.
- F5 reuses the existing implementer and implementation-review loop. It does not absorb TDD, diagnosis, or commits.
- F6 is an optional evidence frame inside the existing dual gate. B2 is a separate, narrowly scoped bug-review evidence change. Neither creates a third review leg.
- B1 owns full diagnosis. B2 may emit the structured OpenBuggy `follow_up` shape, but OpenBuggy's already-written future design is a cross-repo dependency only; OpenBuggy is not edited here.
- F8 owns domain artifact policy. F4 may invoke it, but neither creates a root `CONTEXT.md` nor an ADR tree by default.
- F9 stops at an owner-understood improvement plan and therefore does not duplicate implementation planning.
- F13 extends Composer's user-facing portability without replacing or duplicating its phase-cap handoff.
- I1-I6 are cross-cutting patterns applied by the relevant accepted phases, not a second infrastructure/distribution project.

## Non-Selected Decisions

These items remain logged and are not ranked as implementation proposals.

| Item | Owner decision | Reason not selected |
|---|---|---|
| `ask-matt` | Reference-only | A hand-maintained router duplicates the skills index and can drift around gates. Reconsider only for a generated, validated, index-backed router. |
| `claude-handoff` | Reference-only | Composer already owns phase handoff; `claude --bg` is host-specific. |
| `grill-me` | Reference-only | Preserve the stateless interview distinction as a pattern; a second wrapper would duplicate F3. |
| `loop-me` | Reference-only | A new `workflows/` planning system would compete with roadmap and plan ownership. |
| `git-guardrails-claude-code` | Reject | Claude hook mechanics are host-specific and cannot become a shared Git policy. |
| `setup-pre-commit` | Reject as a source skill | Husky/Node setup is product-specific; lint/test standards can remain a separate local concern. |
| `migrate-to-shoehorn` | Reject | TypeScript migration has no meaningful cursorEscape application. |
| `scaffold-exercises` | Reject | Upstream course layout and CLI are unrelated. |
| `setup-ts-deep-modules` | Reject as a setup skill | Dependency-cruiser enforcement belongs in a TypeScript product repository; its design vocabulary is retained as reference through F1. |
| Infrastructure: ask-matt router | Reject | Keep the static index as the inventory SoT. |
| Infrastructure: distribution | Reject | Keep `Sync-HostHarness` and overlays; do not add plugin packaging, changesets, or a second symlink distributor. |

The owner-excluded skills are not selected or reassessed: `setup-matt-pocock-skills`, `triage`, `to-spec`, `to-tickets`, `wayfinder`, `to-questionnaire`, `writing-beats`, `writing-fragments`, and `writing-shape`.

## Acceptance State

The owner accepted this ranking on 2026-08-21. No adaptation is authorized outside the phase registry; each Phase 3+ adaptation still requires its own approved plan, implementation review, and Full CI closeout.
