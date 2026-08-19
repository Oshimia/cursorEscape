# Initialization Report

**Last updated:** 2026-08-19

## Context

Phase 5 closeout archaeology for cursorEscape — answers user §17 Q1–9 from the accepted initialization plan. This report is a **decisions snapshot** at init completion; the living hub remains [Roadmap](../Roadmap.md). **Do not start** tasks listed under Q9 until explicit owner go-ahead.

**SoT (2026-08-19):** Q2 status **Observed/imported (live Target)** for the `~/.cursor` import is **superseded**. Companion repo is Target contract SoT; that import is **Observed interim** Cursor wording. Do not treat Q3/Q6 body as live adapter choice.

**Prior phases:** Bootstrap (Phase 1 `ca56ca4`), openBuggy import (Phase 2 `5ab9428`), AITestSuite + live `~/.cursor` import (Phase 3 `b771ed8`), Target FA docs (Phase 4 `65a691c`).

---

## Substance

### Q1 — Relevant findings in openBuggy and AITestSuite

**openBuggy** (external Bugbot leg + research archive):

| Finding | Relevance to cursorEscape |
| ------- | ------------------------- |
| Dual-gate review is complementary — keep both legs in parallel ([recommendation](../research/imported/openBuggy/analysis/reviewer-effectiveness/synthesis/recommendation.md)) | **Required** loop shape in [intended-workflow](../featureArchitecture/intended-workflow.md) |
| Fast CI Observed before reviewers — parents must not launch on skip or claimed-only prose ([ci-gating](../research/imported/openBuggy/analysis/reviewer-effectiveness/angles/ci-gating.md)) | **Required** enforcement in live workflow import |
| Split verdict bars — Reviewer-a may APPROVED with Batchable (deferred); Bugbot requires all lists `"None"` | Live-only; freeze eval used unified bar — see [workflow-source-delta](../research/imported/workflow-source-delta.md) |
| Cursor BugBot harness characterization (full FA suite under `imported/openBuggy/featureArchitecture/cursor-bugbot-agent-review/`) | **Observed** reference for what to preserve vs escape — not runtime target |
| openBuggy CLI/MCP-first integration design ([ide-and-agent-integration](../research/imported/openBuggy/featureArchitecture/ide-and-agent-integration.md)) | Informs **bug_reviewer** adapter; engine stays external |
| Context-retrieval proposal for review evidence | **Desired** input to repo discovery — not v0 whole-repo index |

**AITestSuite** (eval packaging):

| Finding | Relevance to cursorEscape |
| ------- | ------------------------- |
| Phase 4 freeze baseline (skills, agents, rules, SOP mirrors) | **Observed/eval-packaging** — compare against live `~/.cursor`, not canonical |
| `USER_INPUT_STOPS.md`, `scoring-framework.md`, phase lessons-learned | Eval autonomy boundaries and rubric patterns for future R4 |
| Freeze hardcoded npm CI commands in `implementation-review` | **Do not copy** into cursorEscape pre-runtime CI |
| `reference-docs` skill present in freeze, absent live | Owner uses global [discovery](../research/imported/cursor-global-workflow/docs/workflow/discovery.md) — **Unknown** whether cursorEscape re-homes repo-local skill (U5) |

---

### Q2 — What research was copied and where

Full manifest: [COPY-MANIFEST](../research/imported/COPY-MANIFEST.md) (86 markdown/mdc files).

| Source | Destination | Phase | Status label |
| ------ | ----------- | ----- | ------------ |
| openBuggy `docs/` (selected FA, analysis, research, SOPs) | `docs/research/imported/openBuggy/` | 2 | Observed/imported |
| AITestSuite Phase 4 freeze + lessons + scoring | `docs/research/imported/AITestSuite/` | 3 | Observed/eval-packaging |
| Live `~/.cursor` workflow (9 docs, 3 rules, 5 skills, 2 agents) | `docs/research/imported/cursor-global-workflow/` | 3 | Observed/imported (live Target at init; **superseded 2026-08-19** → Observed interim) |
| Live vs freeze delta (authored) | `docs/research/imported/workflow-source-delta.md` | 3 | Observed freeze-vs-live archaeology (not forever Target vs companion repo) |

**Not copied:** openBuggy `eval/`; AITestSuite `review-profiles/**`, app baselines, goldens; analysis `.local/` sheets.

Sibling intent: [relationship-to-siblings](./relationship-to-siblings.md).

---

### Q3 — Core requirements

From [design-decisions](./design-decisions.md) and Phase 4 Target docs:

| Requirement | Claim |
| ----------- | ----- |
| Personal agentic workflow — plan → implement → dual review → closeout | **Required** |
| Portable repository knowledge (discovery, SOPs, FA in-repo) | **Required** |
| Evaluable workflow behavior (documented imports, deltas, methodology) | **Required** |
| Backends and models replaceable (BYOK, thin adapter) | **Required** |
| Bugbot-shaped leg delegates to **openBuggy** initially | **Required** at init; **superseded 2026-08-19** — OpenCode `bug_reviewer`; openBuggy research/optional later ([design decisions](./design-decisions.md)) |
| Docs before runtime — no pretend-settled Unknowns | **Required** |
| Not a general IDE, not monetized SaaS, private-first | **Required** non-goals |

---

### Q4 — Highest-risk technical problems

| Risk | Why it hurts | Mitigation (documented, not implemented) |
| ---- | ------------ | ---------------------------------------- |
| **Backend adapter mismatch** — Cline/OpenCode/other may not support parallel subagents, explicit diff scope, or openBuggy wire-up | Blocks honest dual-gate loop outside Cursor | R0 spike before large build ([implementation-roadmap](../roadmaps/implementation-roadmap.md)) |
| **Workflow sequencing drift** — backend-owned review vs parent-owned Fast/Full CI | Reintroduces lock-in and skip patterns openBuggy study flags | [intended-workflow](../featureArchitecture/intended-workflow.md) + live [implementation-review](../research/imported/cursor-global-workflow/skills/implementation-review/SKILL.md) |
| **Repository discovery gap** — agents invent parallel doc trees or miss CI mapping | Wrong plan/review assumptions | [repository-discovery-and-context](../featureArchitecture/repository-discovery-and-context.md), [discovery skill](../skills/discovery.md) |
| **False confidence from dual APPROVED** — not proven ship-class catch or no-escape | Operator over-trusts loop bar | Cited in openBuggy recommendation + [intended-workflow](../featureArchitecture/intended-workflow.md) |
| **Pretend-settled stack** — recording Cline/OpenCode winner without eval | Wasted implementation on wrong adapter | [preliminary-backend-landscape](../research/preliminary-backend-landscape.md) stays **Unknown** until spike |

---

### Q5 — Relevant OSS projects

| Project | Why relevant | cursorEscape stance |
| ------- | ------------ | ------------------- |
| **openBuggy** | Bug-finder review leg, structured findings, CLI/MCP, BYOK eval culture | External sibling — **not reimplemented first** |
| **Cline** | VS Code agent loop, MCP, BYOK | **Unknown** primary thin-client candidate |
| **OpenCode** | Headless multi-provider CLI | **Unknown** orchestration candidate |
| **Aider** | Fast git-centric implementer | **Nice-to-have** adjunct only — weak dual-gate |
| **Greptile / CodeRabbit** | PR review agents, JSON findings | Research comparators — hosted/latency trade-offs ([competitive-landscape](../research/imported/openBuggy/featureArchitecture/competitive-landscape.md)) |
| **Cursor** (current) | Best Observed loop | **Cursor-specific** reference only — not runtime target |

---

### Q6 — Preliminary Cline vs OpenCode

**Preliminary only — not a final decision.** See [preliminary-backend-landscape](../research/preliminary-backend-landscape.md).

| Dimension | Cline (preliminary) | OpenCode (preliminary) |
| --------- | ------------------- | ---------------------- |
| IDE coupling | Strong VS Code extension path | Weaker — CLI/headless friendly |
| Fit for thin client | High if owner stays in VS Code | High if orchestration is out-of-IDE |
| Dual parallel review | **Unknown** — needs R0 spike | **Unknown** — needs R0 spike |
| openBuggy MCP/CLI | **Unknown** | **Unknown** |
| Lock-in risk | Medium (extension host) | Lower for engine; tooling immaturity risk |

**Neither is chosen.** R0 spike must answer role parallelism, diff scope, and bug_reviewer transport before R2 workflow runner.

---

### Q7 — Proposed repository discovery and context acquisition

**Target approach** (docs contract now; runtime later):

```text
Step 0: repo-local reference-docs skill IF present (.cursor/skills/reference-docs/)
  → else global discovery fallback (AGENTS.md, README, CONTRIBUTING, .cursor/rules, docs/_index.md trees)
Step 1: identify hub (README → Roadmap → section indexes)
Step 2: load process SOPs + design-decisions for intent
Step 3: classify Observed vs Target in this repo (imports vs FA)
Step 4: map Fast/Full CI for this repo (ci-ladder; pre-runtime = link/manifest checks)
Step 5: gather change-set evidence (diff, changed files, nearby tests) — not whole-repo dump
```

| Tier | v1 minimum | Later (Unknown) |
| ---- | ---------- | ----------------- |
| **Required** | Hub walk, `_index.md` navigation, rules, changed files | — |
| **Desired** | Callers/definitions near edits ([context-retrieval](../research/imported/openBuggy/featureArchitecture/context-retrieval.md) pattern) | LSP-assisted snippets |
| **Not v0** | Full embedding index | U6 in [unresolved questions](./unresolved-architectural-questions.md) |

**repository_explorer** role explores; **implementer** consumes summarized context ([agent roles](../featureArchitecture/agent-roles-and-model-assignment.md)).

---

### Q8 — Major architectural decisions deliberately left unresolved

Canonical list: [unresolved-architectural-questions](./unresolved-architectural-questions.md) (U1–U13). Highlights:

| ID | Decision | Status |
| -- | -------- | ------ |
| U1 | Engine language | **Unknown** |
| U2 | Primary backend (Cline vs OpenCode vs other) | **Unknown** |
| U3–U4 | Config location; unified agent API schema | **Unknown** |
| U5 | Repo-local `reference-docs` vs global discovery only | **Unknown** |
| U6–U7 | Generated index tier; multi-root workspace | **Unknown** |
| U8–U10 | openBuggy transport; test_reviewer optional; eval harness ownership | **Unknown** |
| U11–U13 | License, remote hosting, default models per role | **Unknown** |

---

### Q9 — Recommended next tasks (do not start)

From [implementation-roadmap](../roadmaps/implementation-roadmap.md) — **planning only**:

1. **R0 spike** — one dogfood repo: spawn roles, parallel review, branch vs uncommitted diff scope on Cline and/or OpenCode.
2. **Resolve U2, U4 with evidence** — document chosen adapter in design-decisions if spike succeeds.
3. **R1 discovery module** — implement Q7 minimum (hub walk, changed files, rules) without embedding index.
4. **R2 workflow runner** — host-agnostic plan → implement → dual review gates aligned with [skills](../skills/_index.md) contracts.
5. **R3 openBuggy wire-up** — production path for bug_reviewer adapter.
6. **R4 eval hook** — transcript + rubric (AITestSuite patterns as reference, not port).
7. **Optional R5 thin client** — only after R3 loop is honest on Fast/Full.

**Explicit non-starters:** Cursor clone IDE; inline Bugbot engine; skipping dual-gate; starting R1+ before init closeout commit.

---

## Implications

1. This report should not be edited for living status — update [Roadmap](../Roadmap.md) and Target FA docs instead.
2. Re-import from siblings requires manifest update and explicit phase decision.
3. Initialization conductor Phase 5 deliverables land when this report, hub links, review loop, and Full CI pass — Composer QC commit follows.
4. **Superseded (2026-08):** Q6 / U2 / U8 adapter narrative — first attempt is T3 + OpenCode; openBuggy not v0 default. See [host recreation](../analysis/host-recreation-2026-08.md), [design decisions](./design-decisions.md), [unresolved questions](./unresolved-architectural-questions.md). Q1–9 body above remains the init archaeology snapshot.

---

## Related

- [Design decisions](./design-decisions.md)
- [Host recreation study](../analysis/host-recreation-2026-08.md)
- [Relationship to siblings](./relationship-to-siblings.md)
- [COPY-MANIFEST](../research/imported/COPY-MANIFEST.md)
- [Initialization roadmap](../roadmaps/cursorEscape-initialization.md)
- [Implementation roadmap](../roadmaps/implementation-roadmap.md)
