> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/follow-on-catch-escape/_index.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this follow-on lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/follow-on-catch-escape/`; gitignored sheets (e.g. `.local/follow-on-sheet.json`, git-roots map) remain only in the openBuggy source repo. Do **not** create `.local/` under cursorEscape `docs/analysis/`. Path and closeout guidance below describes **openBuggy operator procedures**, not cursorEscape CI.
# Catch + escape follow-on

**Last updated:** 2026-08-16  
**Status:** Phase 3 — rates layered into catch/escape angles and rank 6

## Context

Follow-on to [reviewer-effectiveness](../_index.md). Replaces the Phase 3 `process_tp` heuristic (later CLEAN on the same leg) with **per-finding fate** from implementer turns in the parent, plus operator **value** labels. Escape scan uses a **15-parent** later-thread window; git is **corroboration only**. This is not eval scoring.

**In openBuggy:** UUID/path sheets stay in gitignored `.local/` (`follow-on-sheet.json`) in the source repo — **not copied to cursorEscape**. Committed prose uses slot aliases only.

## Substance

### Reading order

1. [methodology.md](./methodology.md) — census override, catch-rate formulas, escape window, git skip  
2. [rubric.md](./rubric.md) — fate / value / implementer fields and worked examples  
3. [sample.md](./sample.md) — Task-reconciled rate slots S01, S02, S13 (S12/S15/S09 unreconciled; S03 reconciled-but-excluded)  
4. [results.md](./results.md) — deep-sample rates (Phase 2)

Parent study: [coding-rubric.md](../coding-rubric.md) (Phase 3 sheet frozen; pointer only).

### Locked choices

- Recode **Task-reconciled** CLEAN-arc parents from the 15-slot sample (Phase 1 aimed at 4–6; Phase 2 rates are **3**: S01, S02, S13). Extra recovered slots stay **vignettes**, not in rates.
- Fate is **implementer-trace adjudication**, not fuzzy title match.
- Fuzzy match is for **escape themes only**.
- Docs and tests stay **high value**.
- Phase 3 funnel (15 / 182 / 369) remains the census layer; follow-on rates are labeled as this deep sample.

## Implications / open questions

1. Dual-leg rates use Task-reconciled slots only (S01, S02, S13). S12/S15/S09 are unreconciled vignettes; S03 is reconciled but excluded (would triple `scc-saves`).
2. Rate set has **zero `accounts` parents**.

## Sources

- Parent study: [../_index.md](../_index.md)
- [documenting-this-concept-repo.md](../../../SOPs/documenting-this-concept-repo.md)
