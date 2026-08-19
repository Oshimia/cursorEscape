> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/angles/ci-gating.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this study lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/`; UUID/path coding sheets and `.local/` were **not** copied (they remain gitignored in the openBuggy source repo at `docs/analysis/reviewer-effectiveness/.local/`). Do **not** create `docs/analysis/reviewer-effectiveness/.local/` here. References to `docs/analysis/**`, `eval/scripts/`, eval closeout scans, or openBuggy-only leak-scan commands describe **openBuggy operator procedures**, not cursorEscape maintenance or Phase 2 CI.
# CI gating

**Last updated:** 2026-08-16  
**Status:** Phase 4 — coded sample

## Context

Is **Fast CI before reviewers** followed? Codes distinguish Observed command output from Custom Instructions claims ([coding-rubric.md](../coding-rubric.md)).

## Substance

### Evidence

Per **parent** (n=15), not per launch:

| Code | Parents |
|------|---------|
| `ci_observed` | 11 |
| `ci_claimed_only` | 2 (S10, S11) |
| `ci_skipped` | 2 (S02, S06) |

`ci_skipped` means fail-like CI language **and** reviewer Tasks in the same parent transcript (heuristic). `ci_unknown` did not appear in this sample.

Rates for the angle: primary = observed 11 + skipped 2.

### Analysis

Most sampled parents **show a test command** near the review loop (**11/15**). Two website-primary catalog slots only **claim** Fast CI. Two parents (`scc-saves` high-iter S02, `accounts` S06) look like reviewers ran in a failing/messy CI context — worth parent-skill tightening, not proof the skill is ignored everywhere.

### Recommendation

**Improve parent enforcement:** do not launch reviewers on `ci_skipped`; treat `ci_claimed_only` as insufficient for the gate. Leave the skill rule (no review if Fast CI fails) **stable**. Confidence: **medium**. Sample n=15 parents.

## Implications / open questions

1. Heuristic may mis-label Full-CI-then-review as skip; spot-check S02/S06 in a follow-on.

## Sources

- [coding-rubric.md](../coding-rubric.md)
- [orchestration-and-review-loops.md](../../../featureArchitecture/cursor-bugbot-agent-review/orchestration-and-review-loops.md)
- Gitignored Phase 3 coding sheet
