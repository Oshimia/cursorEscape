> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/angles/iteration-policy.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this study lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/`; UUID/path coding sheets and `.local/` were **not** copied (they remain gitignored in the openBuggy source repo at `docs/analysis/reviewer-effectiveness/.local/`). Do **not** create `docs/analysis/reviewer-effectiveness/.local/` here. References to `docs/analysis/**`, `eval/scripts/`, eval closeout scans, or openBuggy-only leak-scan commands describe **openBuggy operator procedures**, not cursorEscape maintenance or Phase 2 CI.
# Iteration policy

**Last updated:** 2026-08-16  
**Status:** Phase 4 — coded sample

## Context

Should **high launch counts** trigger a cap, Custom Instructions change, or re-scope?

## Substance

### Evidence

Triage **must** apply when a leg exceeds 8 launches: middle CLEAN launches `sampled_out` (44 launches). Coded remainder still shows long tails:

| Pattern | Slots |
|---------|--------|
| 13 launches/leg before last CLEAN | S01, S02 (`scc-saves` high-iter) |
| 36 BugBot launches (29 coded) last CLEAN | S09 (`website-primary` iter-tail) |
| 10–14 BugBot launches | S10–S12, S14 |
| 1 launch, still FINDINGS | S08 |

Diminishing returns are **Inferred**: late BugBot iterations on S01/S02 still produced new logic titles (not only repeats) until the final CLEAN pair. S09’s tail is mostly BugBot-only in the sheet (Reviewer-a UUID gap).

### Analysis

No-pass-cap while findings remain **does** produce 10–36 launch loops. That is effective at reaching CLEAN and expensive. A trigger at **8 launches per leg** matches the triage threshold already used for coding: at that point the parent should re-scope Custom Instructions or split the phase rather than silent-continue.

New logic after iteration 8 on S01/S02 argues against a hard stop; it argues for **escalation** (narrower Diff / NL map, or phase split), not dropping the loop.

### Recommendation

**Improve:** after **8 launches on one leg**, parent must change scope (Custom Instructions or phase cut) before launching again; do not hard-cap to zero new reviews. Confidence: **medium**. Sample n=15, two extreme `scc-saves` parents + one website-primary tail.

## Implications / open questions

1. Skill text today: no pass cap while findings remain — this rec is a parent-policy overlay.

## Sources

- [coding-rubric.md](../coding-rubric.md) high-launch triage
- [orchestration-and-review-loops.md](../../../featureArchitecture/cursor-bugbot-agent-review/orchestration-and-review-loops.md)
- Gitignored Phase 3 coding sheet
