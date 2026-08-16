> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/angles/overlap-and-redundancy.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this study lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/`; UUID/path coding sheets and `.local/` were **not** copied (they remain gitignored in the openBuggy source repo at `docs/analysis/reviewer-effectiveness/.local/`). Do **not** create `docs/analysis/reviewer-effectiveness/.local/` here. References to `docs/analysis/**`, `eval/scripts/`, eval closeout scans, or openBuggy-only leak-scan commands describe **openBuggy operator procedures**, not cursorEscape maintenance or Phase 2 CI.
# Overlap and redundancy

**Last updated:** 2026-08-16  
**Status:** Phase 4 — coded sample

## Context

What does Reviewer-a uniquely catch versus BugBot versus both?

## Substance

### Evidence

Automated `overlap` (same `theme_key`, other leg, ±1 iteration) fired on **2 / 369** findings — the matcher is **too strict** (titles rarely share eight normalized tokens). Do not use that rate.

Class split is the usable Observed signal:

| Class | Count | Typical leg |
|-------|-------|-------------|
| process | 143 | Reviewer-a |
| tests | 92 | Reviewer-a |
| logic | 113 | BugBot |
| `BUGBOT_RULES` | 10 | BugBot |
| security | 5 | BugBot |
| docs | 5 | mixed / Reviewer-a |

Launch mix after triage: BugBot 119, Reviewer-a 63. Three slots lack coded Reviewer-a (map gap).

### Analysis

The legs are **complementary by class**, not redundant by title-overlap (unmeasured). Dropping Reviewer-a would drop most process/test findings; dropping BugBot would drop most logic/security. Keep both. Docs/tests are high value, high latency — bound **when** they re-block, not whether they count ([time-and-waste.md](./time-and-waste.md)).

### Recommendation

**Leave both legs in the dual-gate.** Manage Reviewer-a **latency** (blocking vs batchable), not whether the leg runs. Confidence: **medium** on complementarity; **low** on quantitative overlap. Sample n=15.

## Implications / open questions

1. A later pass could fuzzy-match titles; do not amend the frozen rubric silently.

## Sources

- Gitignored Phase 3 coding sheet
- [orchestration-and-review-loops.md](../../../featureArchitecture/cursor-bugbot-agent-review/orchestration-and-review-loops.md)
