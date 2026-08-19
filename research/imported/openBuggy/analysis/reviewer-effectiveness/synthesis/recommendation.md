> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/synthesis/recommendation.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this study lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/`; UUID/path coding sheets and `.local/` were **not** copied (they remain gitignored in the openBuggy source repo at `docs/analysis/reviewer-effectiveness/.local/`). Do **not** create `docs/analysis/reviewer-effectiveness/.local/` here. References to `docs/analysis/**`, `eval/scripts/`, eval closeout scans, or openBuggy-only leak-scan commands describe **openBuggy operator procedures**, not cursorEscape maintenance or Phase 2 CI.
# Ranked recommendation

**Last updated:** 2026-08-16  
**Status:** Phase 5 synthesis

## Context

Cross-angle keep / tune / drop for the 2026 dual-gate loop. Each item cites angle docs. Sample: 15 parents, 182 coded launches, 369 findings ([corpus-and-sample.md](../corpus-and-sample.md)).

## Substance

### Ranked actions

1. **Keep both legs in parallel** — class mix is complementary (logic/security vs process/tests). Do not drop Reviewer-a or BugBot from the dual-gate. ([overlap-and-redundancy.md](../angles/overlap-and-redundancy.md), [bugbot-process.md](../angles/bugbot-process.md))
2. **Re-scope after 8 launches on one leg** — change Custom Instructions or split the phase; do not hard-stop reviews (late logic still appeared on long `scc-saves` loops). ([iteration-policy.md](../angles/iteration-policy.md))
3. **Keep docs and tests first-class; manage loop latency, not “waste.”** The 56% `wasted_fix` figure is an iteration-cost proxy (process/docs/`BUGBOT_RULES` + later CLEAN). Tests are not in that flag. Split **blocking** (this-change regressions / docs that would mislead the next agent) vs **batchable** (coverage wish-list, polish) so long suites do not stall every dual-gate. Do not drop Reviewer-a. ([time-and-waste.md](../angles/time-and-waste.md), [reviewer-a-skill.md](../angles/reviewer-a-skill.md))
4. **Enforce Fast CI Observed before reviewers** — 11/15 observed, 2 claimed-only, 2 skipped-heuristic. Skill rule stays; parents must not launch on skip. ([ci-gating.md](../angles/ci-gating.md))
5. **Require the locked Reviewer-a opener + CI/Completion fields** — variant envelope on S08 correlated with a one-shot FINDINGS ending. ([custom-instructions.md](../angles/custom-instructions.md))
6. **Do not treat later-CLEAN, dual APPROVED, or follow-on 0.97 would-want `gone` as proven ship-class catch or proven no-escape** — Phase 3 TP over-counts (346/369); follow-on fate is an edit-window process rate on n=3 (32/33). Escapes: Phase 3 1/369; follow-on 6/74 later-thread overlap. Keep the loop; do not add a mandatory post-clean audit. ([catch-effectiveness.md](../angles/catch-effectiveness.md), [escapes-and-misses.md](../angles/escapes-and-misses.md), [follow-on-catch-escape/results.md](../follow-on-catch-escape/results.md))

### Confidence and sample limits

- Pool 53 dual-leg 2026 parents; sample 15; 44 launches `sampled_out`; 4 unparseable outcomes.
- Follow-on catch/escape: 3 Task-reconciled parents (S01/S02/S13); S03/S09 recovered as vignettes; S13 now in rates (Phase 3 sheet still showed the UUID gap).
- Single rater; `process_tp` / `wasted_fix` (iteration-cost proxy) / `overlap` / `escape` are proxies. Docs and tests are high value, high latency.

### Follow-on (measurement landed)

Catch/escape rates used in rank 6: [follow-on-catch-escape/_index.md](../follow-on-catch-escape/_index.md). Remaining out of this study: skill-file edits.

## Implications / open questions

1. Rank 3 vs rank 1: keep the leg; treat docs/tests as valuable; bound **when** they re-block the loop.

## Sources

- All `../angles/*.md`
- [methodology.md](../methodology.md)
- [follow-on-catch-escape/results.md](../follow-on-catch-escape/results.md)
