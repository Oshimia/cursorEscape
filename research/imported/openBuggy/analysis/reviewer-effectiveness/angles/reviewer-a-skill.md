> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/angles/reviewer-a-skill.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this study lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/`; UUID/path coding sheets and `.local/` were **not** copied (they remain gitignored in the openBuggy source repo at `docs/analysis/reviewer-effectiveness/.local/`). Do **not** create `docs/analysis/reviewer-effectiveness/.local/` here. References to `docs/analysis/**`, `eval/scripts/`, eval closeout scans, or openBuggy-only leak-scan commands describe **openBuggy operator procedures**, not cursorEscape maintenance or Phase 2 CI.
# Reviewer-a skill

**Last updated:** 2026-08-16  
**Status:** Phase 4 — coded sample

## Context

Should the production-readiness reviewer skill change? Prose only — no operator skill-file edits in this study.

## Substance

### Evidence

- **63** coded Reviewer-a launches vs **119** BugBot (after triage); three slots had **no** coded Reviewer-a (UUID map gap).
- Findings: heavy **process** and **tests** lists. The **56%** sheet flag is an **iteration-cost proxy** (process/docs/`BUGBOT_RULES` + later CLEAN), not “tests are waste” — tests are a separate class ([time-and-waste.md](./time-and-waste.md)).
- S08 variant envelope omitted Completion gate / CI results; the subagent noted the skip-and-review tension.
- Clean signal (APPROVED + empty lists) is reachable (last Reviewer-a CLEAN on 10 parents with coded RA).

### Analysis

The skill is doing its stated job (completeness, tests, process). That job is **high value** for a solo AI-driven maintainer and **high latency** under fix-all as suites grow. Updates that would help: (1) insist on parent-supplied Completion gate + CI block; (2) label **blocking** vs **batchable** test/doc items (this-change regressions vs coverage wish-list) without dropping either from the Verdict; (3) after 8 launches, re-scope rather than grow the bullet list.

Do not merge Reviewer-a into BugBot — class mix differs ([overlap-and-redundancy.md](./overlap-and-redundancy.md)).

### Recommendation

**Improve the skill/parent contract; do not delete the leg or devalue docs/tests.** Ranked skill recs: enforce required invocation fields; distinguish blocking vs batchable ship-set items; keep Verdict bar. Apply in a later pass. Confidence: **medium**. Sample n=15, RA under-count on S03/S09/S13.

## Implications / open questions

1. `process_tp` remains a loose later-CLEAN heuristic ([catch-effectiveness.md](./catch-effectiveness.md)); docs/tests stay high-value regardless.

## Sources

- External skills (by name only): Reviewer-a; implementation-review
- [orchestration-and-review-loops.md](../../../featureArchitecture/cursor-bugbot-agent-review/orchestration-and-review-loops.md)
- [documenting-this-concept-repo.md](../../../SOPs/documenting-this-concept-repo.md)
- Gitignored Phase 3 coding sheet
