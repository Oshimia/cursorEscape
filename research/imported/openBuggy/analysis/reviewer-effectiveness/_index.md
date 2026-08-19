> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/_index.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this study lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/`; UUID/path coding sheets and `.local/` were **not** copied (they remain gitignored in the openBuggy source repo at `docs/analysis/reviewer-effectiveness/.local/`). Do **not** create `docs/analysis/reviewer-effectiveness/.local/` here. References to `docs/analysis/**`, `eval/scripts/`, eval closeout scans, or openBuggy-only leak-scan commands describe **openBuggy operator procedures**, not cursorEscape maintenance or Phase 2 CI.
# Reviewer-a / BugBot effectiveness (2026 dual-gate)

**Last updated:** 2026-08-16  
**Status:** Phases 1–5 complete — see ranked recommendation. Catch/escape follow-on: [follow-on-catch-escape/_index.md](./follow-on-catch-escape/_index.md) (Phase 3 layered into angles)

## Context

Decision-grade study of the owner’s **current** local dual-reviewer loop (`implementation-review`: Fast CI → parallel Reviewer-a ∥ BugBot → fix-all → re-review). Answers whether the loop usually catches issues, how **iteration cost** falls by class (docs/tests are high value, high latency — not waste), whether high launch counts should trigger a response, and whether Reviewer-a or BugBot **process** should change.

This is **not** the eval harness (openBuggy `eval/` was not copied). This study codes live parent transcripts. **In openBuggy**, UUID/path sheets stay in gitignored `.local/` under `docs/analysis/reviewer-effectiveness/` — **not copied to cursorEscape**; do not create that path here.

## Substance

### Recency

Main rates: **2026 / current dual-gate** parents only. Older loops may appear as labeled Contrast.

### Reading order

1. [methodology.md](./methodology.md) — fingerprints, dual-leg predicate, CI waiver, UUID barrier  
2. [coding-rubric.md](./coding-rubric.md) — finding-level fields  
3. [corpus-and-sample.md](./corpus-and-sample.md) — pool vs sample funnel (aliases)  
4. Angle papers (Evidence → Analysis → Recommendation each):
   - [catch-effectiveness.md](./angles/catch-effectiveness.md)
   - [time-and-waste.md](./angles/time-and-waste.md) — iteration cost by class (docs/tests high value)
   - [iteration-policy.md](./angles/iteration-policy.md)
   - [overlap-and-redundancy.md](./angles/overlap-and-redundancy.md)
   - [escapes-and-misses.md](./angles/escapes-and-misses.md)
   - [ci-gating.md](./angles/ci-gating.md)
   - [custom-instructions.md](./angles/custom-instructions.md)
   - [reviewer-a-skill.md](./angles/reviewer-a-skill.md)
   - [bugbot-process.md](./angles/bugbot-process.md)
5. [synthesis/recommendation.md](./synthesis/recommendation.md) — ranked keep/tune/drop  
6. [synthesis/vignettes.md](./synthesis/vignettes.md) — anonymized stories  
7. [follow-on-catch-escape/_index.md](./follow-on-catch-escape/_index.md) — per-finding fate / value / later-parent escapes (**Phase 3:** layered into catch/escape angles)  

### Ranked recommendation (summary)

1. Keep both legs in parallel.  
2. Re-scope after 8 launches on one leg (no hard stop).  
3. Keep docs/tests first-class; split blocking vs batchable so long suites do not stall every iteration. Keep BugBot for logic/security.  
4. Require Observed Fast CI; do not launch on skip.  
5. Require locked Reviewer-a invocation fields.  
6. Do not treat CLEAN or follow-on 0.97 `gone` as proven ship-class catch.

Full list and caveats: [synthesis/recommendation.md](./synthesis/recommendation.md).

## Implications / open questions

1. Phase 3 sheet still lists S03/S09/S13 as BugBot-only; follow-on recovered files — S13 is in rates, S03/S09 are vignettes ([follow-on-catch-escape/sample.md](./follow-on-catch-escape/sample.md)).
2. `process_tp` remains the census over-count; follow-on **would-want** catch is 32/33 `gone` (not 32/33 of all 74 findings) — see [catch-effectiveness.md](./angles/catch-effectiveness.md) and [escapes-and-misses.md](./angles/escapes-and-misses.md).

## Sources

- Study design: operator plan (2026-08-16)
- Transcript map: [cross-repo-bugbot-mining.md](../../SOPs/cross-repo-bugbot-mining.md), [eval-cross-repo-mining-inventory.md](../../featureArchitecture/eval-cross-repo-mining-inventory.md)
- Loop shape: [orchestration-and-review-loops.md](../../featureArchitecture/cursor-bugbot-agent-review/orchestration-and-review-loops.md)
- Primary source: local Cursor agent transcripts (not independently re-verified via public URL)
