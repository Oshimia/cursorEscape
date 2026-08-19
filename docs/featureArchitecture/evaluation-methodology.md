# Evaluation Methodology

**Last updated:** 2026-08-20

## Context

How cursorEscape measures workflow quality over time. Pre-runtime: evaluation is **documented methodology + imported eval research** — no eval runners in this repo. AITestSuite imports are **Observed/eval-packaging**. Process-gate semantics are **Target** in companion-repo contracts ([intended-workflow](./intended-workflow.md), [skills](../../skills/_index.md)). Live `~/.cursor` import is **Observed** Cursor wording, not a second Target procedure.

---

## Substance

### What to evaluate (Required)

| Dimension | Question | Source bias |
| --------- | -------- | ----------- |
| **Loop adherence** | Fast CI Observed before reviewers? Dual parallel? Full only at closeout? | Target contracts + Observed live import + openBuggy [ci-gating](../../research/imported/openBuggy/analysis/reviewer-effectiveness/angles/ci-gating.md) |
| **Catch mix** | Logic/security vs process/docs findings by leg | openBuggy [overlap](../../research/imported/openBuggy/analysis/reviewer-effectiveness/angles/overlap-and-redundancy.md) |
| **Iteration cost** | Launches per phase; re-scope triggers | [iteration-policy](../../research/imported/openBuggy/analysis/reviewer-effectiveness/angles/iteration-policy.md) |
| **Doc quality** | Hub links, claim taxonomy, Observed ≠ Target | cursorEscape pre-runtime CI |
| **Escape rate** | Issues surviving dual APPROVED | openBuggy follow-on study — **do not** treat as proof of no-escape |

### Eval corpora (Observed — cite, do not duplicate)

| Corpus | Role | Label |
| ------ | ---- | ----- |
| AITestSuite scoring framework | Test packaging rubric | Observed/eval-packaging |
| AITestSuite REVIEW_LOOP.md | Candidate prompts | Observed — not portable process |
| openBuggy reviewer-effectiveness | Dual-gate operator study | Observed/imported |
| workflow-source-delta | Freeze-vs-live archaeology | Observed archaeology (not forever Target vs companion repo) |

### cursorEscape pre-runtime checks (Required)

| Check | Tier |
| ----- | ---- |
| Hub/index link integrity | Fast |
| Phase deliverable files exist | Fast |
| No runtime scaffolding | Full |
| Unknown claims not pretend-settled | Full (human + review) |

### Future runtime eval (Unknown)

| Item | Status |
| ---- | ------ |
| Harness repo location | **Unknown** — may stay external (AITestSuite pattern) |
| Reference transcripts per role | **Desired** |
| Automated scoring vs human rubric | **Unknown** |

### Non-goals

- Reimplement openBuggy eval tree inside cursorEscape docs phase
- Treat dual APPROVED as ship-class guarantee ([recommendation](../../research/imported/openBuggy/analysis/reviewer-effectiveness/synthesis/recommendation.md))

---

## Implications / open questions

1. Phase 5 initialization report summarizes highest-risk gaps — not start eval implementation.
2. When runtime exists, align scoring with [AITestSuite scoring-framework](../../research/imported/AITestSuite/docs/scoring-framework.md) where applicable.

---

## Related

- [Intended workflow](./intended-workflow.md)
- [Workflow source delta](../../research/imported/workflow-source-delta.md)
- [Imported openBuggy reviewer-effectiveness](../../research/imported/openBuggy/analysis/reviewer-effectiveness/_index.md)
