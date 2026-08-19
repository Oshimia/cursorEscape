# Workflow source delta — live `~/.cursor` vs AITestSuite Phase 4 freeze

**Last updated:** 2026-08-19

## Context

Phase 3 imports two workflow corpora: **live** `C:\Users\admin\.cursor\` (**Observed interim** Cursor wording used as the Phase 4 synthesis *input*) and **Observed** AITestSuite Phase 4 freeze (`tests/ez-pz-streaming-media-phase-4/baseline/` plus eval-packaging siblings). This note records material deltas discovered **before** copy lock so Phase 4 Target docs cite live-vs-freeze correctly. Companion-repo contracts in `docs/featureArchitecture/`, `docs/agents/`, and `docs/skills/` are **Target** SoT as of 2026-08-19 identity lock-in; this file remains freeze-vs-live archaeology — see [research index](../_index.md).

**Comparison method:** Line-level `Compare-Object` on paired artifacts (freeze `.cursor/*` vs live equivalents; freeze `referenceFiles/SOPs/*` vs live `docs/workflow/*` counterparts). Diffs are summarized by theme, not line-by-line.

---

## Substance

### Corpus roles

| Corpus | Role in cursorEscape | Label |
| ------ | -------------------- | ----- |
| Live `~/.cursor` | Owner Cursor workflow used as Phase 4 synthesis *input* (skills, rules, agents, global workflow docs) | **Observed interim** (import snapshot; not forever Target vs companion repo) |
| AITestSuite Phase 4 freeze `.cursor/` | Eval-packaging baseline frozen for streaming-media test | **Observed/eval-packaging** |
| Freeze `referenceFiles/SOPs/` | Project-scoped SOP copies inside test baseline | **Observed/eval-packaging** (paths point at baseline tree) |
| Live `~/.cursor/docs/workflow/` | Global, repo-agnostic workflow process docs | **Observed interim** (imported under `cursor-global-workflow/`) |

### CI ladder — Fast vs Full (major delta)

| Aspect | Freeze (Phase 4 baseline) | Live `~/.cursor` |
| ------ | ------------------------- | ---------------- |
| CI mapping | **Hardcoded** four commands in `implementation-review` skill: `frontend lint/test`, `backend lint/test` | **Repo-agnostic** — discover via `ci-ladder.md`, README, scripts, GHA; project `pre-commit-ci-gate` overrides Full |
| Fast tier | Not named; “CI gate” = same four commands every iteration | Explicit **Fast** vs **Full** tiers; reviewers only after **Fast** Observed |
| Full tier | Not separated from loop; final “run CI one more time” in eval `REVIEW_LOOP.md` | **Full** only at closeout after dual APPROVED; **never** paired with reviewers |
| Observed Fast CI | Not required — parent may launch reviewers on prose “CI passed” | **Required** per-command rows (`pass|fail|skipped|n/a`); no launch on skipped (when Fast ≠ n/a) or claimed-only |
| cursorEscape pre-runtime | N/A in freeze | Fast/Full = hub link integrity + manifest completeness + allowlist + delta present + no runtime scaffolding |

Freeze `implementation-review` also documents backend `.env.local` / GHA placeholder env — **domain-specific** to streaming-media baseline, not portable process.

### Composer conductor exception (live only)

Live workflow explicitly assigns **Composer** as phased conductor: phase subagent is review-loop parent; Composer does QC (closeout report + transcript audit), Full CI, and local commit (never push). Freeze baseline has no `composer` skill, no Composer carve-out in rules or `implementation-review`, and no phased-conductor SOP.

Live-only skills also include **`roadmap`** and **`documentation-architecture`** — absent from freeze `.cursor/skills/`.

### Batchable (deferred) — split verdict bars (live only)

| Reviewer | Freeze bar | Live bar |
| -------- | ---------- | -------- |
| Bugbot | Blocking, Non-blocking, Test gaps all `"None"` for APPROVED | Same |
| Reviewer-a | Same unified bar (all lists `"None"`) | **Split bar:** Blocking, Non-blocking (code/process), **blocking** test/docs must be `"None"`; **Batchable (deferred)** may remain on APPROVED |

Live `iterative-code-review` workflow doc and `implementation-review` skill document the split bar and closeout punch list for deferred items.

### Iteration narrowing (live only)

Live: per-leg launch `count = completed + 1`; when `count >= 9`, narrow scope before invoke (Bugbot Custom Instructions = current-fix; Reviewer-a = narrower task summary + applicable docs) — **no hard stop**. Freeze: “No pass cap” with full prompts each round; no narrowing guidance; no launch-count attestation in closeout.

### Pre-commit CI gate rule (live only)

Live: `pre-commit-ci-gate.mdc` — fallback Full mapping via `ci-ladder.md`; explicit user ack when Full = `n/a`; Composer same bar before auto commit. Freeze baseline: no equivalent always-applied or requestable rule file in allowlist.

### Reference-docs skill presence

| Location | Freeze | Live |
| -------- | ------ | ---- |
| `.cursor/skills/reference-docs/SKILL.md` | **Present** — repo-specific doc discovery | **Absent** — live uses `discovery.md` + `documentation-architecture` skill instead |
| SOP counterpart | `referenceFiles/SOPs/reference-docs-check.md` | `docs/workflow/discovery.md` (different scope and paths) |

Phase 4 Target synthesis should **not** assume live has `reference-docs` skill; cite freeze import when comparing eval baseline expectations.

### SOP path and content differences

Freeze process docs live under **`baseline/referenceFiles/SOPs/`** with links into baseline `.cursor/` and domain paths (`backend/`, `referenceFiles/supabase/`, etc.). Live process docs live under **`~/.cursor/docs/workflow/`** with links into global skills/agents and repo-agnostic discovery.

Paired comparisons (all **material diffs**, not byte-identical):

| Freeze SOP | Live workflow doc | Delta theme |
| ---------- | ----------------- | ----------- |
| `iterative-plan-review.md` | `iterative-plan-review.md` | Live shorter; global skill links; Composer exception |
| `iterative-code-review.md` | `iterative-code-review.md` | Live Fast/Full, split bars, Batchable deferred, Composer parent |
| `review-loop-model-profiles.md` | `review-subagent-models.md` | Renamed; live drops review-profile swap machinery |
| `reference-docs-check.md` | `discovery.md` | Live discovery Step 0 + fallback; freeze is project FA/SOP checklist |

Freeze `review-loop-model-profiles.md` references **`review-profiles/**`** swap paths — **host-only** in AITestSuite; not copied to cursorEscape (annotated in COPY-MANIFEST).

### Eval-packaging artifacts (freeze only, Observed)

- `REVIEW_LOOP.md` — candidate-facing test prompts; unified APPROVED bar; hardcoded CI gate; **not portable process**
- `evaluation/USER_INPUT_STOPS.md` — test-scoped autonomy boundaries
- `meta/lessons-learned.md` (phase 2, 4, 6) + `docs/scoring-framework.md` — scoring/eval context, not owner Target workflow

### Paired `.cursor` artifact diffs (freeze vs live)

All six directly comparable pairs differ materially: `implementation-plan`, `implementation-review`, `plan-reviewer`, `reviewer-a`, `iterative-plan-review.mdc`, `iterative-code-review.mdc`. The `reference-docs` skill is **freeze-only** (no live counterpart file).

Live-only co-located artifacts: `user-rules-snippet.md` beside `implementation-plan`, `implementation-review`, and `composer` skills.

---

## Implications / open questions

1. **Phase 4 Target** `intended-workflow.md` owns loop semantics in this repo; cite this delta when freeze eval packaging disagrees with the **Observed** live Cursor import.
2. **cursorEscape CI** is docs-only (link/manifest/allowlist) — do not copy freeze four-command npm gate into cursorEscape pre-runtime CI.
3. **review-profiles/** links in freeze SOPs and skills are host-only — COPY-MANIFEST annotates; no mirror under cursorEscape.
4. Whether to re-home a repo-local `reference-docs` skill in cursorEscape runtime is **Unknown** — live owner workflow uses global discovery + documentation-architecture instead.
5. Re-diff before major AITestSuite re-import; freeze is a point-in-time Observed snapshot.
6. “Canonical Target” in older Phase 3 prose meant live-vs-freeze for Cursor import, not forever-SoT versus this companion repo ([design decisions](../../review/design-decisions.md)).

---

## Related

- [COPY-MANIFEST](./COPY-MANIFEST.md)
- [Relationship to siblings](../../review/relationship-to-siblings.md)
- [Initialization roadmap Phase 3](../../roadmaps/cursorEscape-initialization.md)
- Imported trees: [AITestSuite](./AITestSuite/) · [cursor-global-workflow](./cursor-global-workflow/)
