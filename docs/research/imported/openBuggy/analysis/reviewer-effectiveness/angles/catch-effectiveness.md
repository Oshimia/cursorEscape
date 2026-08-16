> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/angles/catch-effectiveness.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this study lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/`; UUID/path coding sheets and `.local/` were **not** copied (they remain gitignored in the openBuggy source repo at `docs/analysis/reviewer-effectiveness/.local/`). Do **not** create `docs/analysis/reviewer-effectiveness/.local/` here. References to `docs/analysis/**`, `eval/scripts/`, eval closeout scans, or openBuggy-only leak-scan commands describe **openBuggy operator procedures**, not cursorEscape maintenance or Phase 2 CI.
# Catch effectiveness

**Last updated:** 2026-08-16  
**Status:** Phase 4 census + follow-on Phase 2 deep sample

## Context

Does the 2026 dual-gate loop **usually** catch issues that then get fixed in-thread? Complements [escapes-and-misses.md](./escapes-and-misses.md) and [time-and-waste.md](./time-and-waste.md).

## Substance

### Evidence

From the Phase 3 sheet ([corpus-and-sample.md](../corpus-and-sample.md) funnel): **182** coded launches, **369** findings, **15** parents.

- **122** launches had ≥1 finding; **56** were CLEAN (plus 4 unparseable outcomes).
- **12 / 15** parents ended their last **coded** BugBot launch CLEAN; **10 / 12** parents with coded Reviewer-a ended last Reviewer-a CLEAN. S08 (thin-dual) ended FINDINGS on both legs. S03/S09/S13 had no coded Reviewer-a launches (UUID map gap — not a proven skip).
- Class mix: process 143, logic 113, tests 92, `BUGBOT_RULES` 10, security 5, docs 5, other 1.
- `process_tp=True` on **346 / 369** findings. That flag means **the same leg later had a CLEAN launch**, not that this title was independently verified or even the one that disappeared. It **over-counts** true positives.

Security findings were rare (5) but present. Logic is the main BugBot class; process/tests dominate Reviewer-a.

### Follow-on deep sample (not a replacement funnel)

[follow-on-catch-escape/results.md](../follow-on-catch-escape/results.md): **3** Task-reconciled parents (S01, S02, S13), **66** launches, **74** findings. Would-want catch: **32 / 33 ≈ 0.97** `gone` (implementer tool window + no 4-stem re-raise). `transformed` 1/33. Zero `accounts`. S13 Reviewer-a used variant openers (`fingerprint_ok` false).

That 0.97 is still an **in-thread process rate** (windows almost always contain edits). It does **not** independently verify production bugs. n=3 → wide intervals. Unreconciled S12/S15/S09 and reconciled-but-excluded S03 stay vignettes.

### Analysis

The loop **usually produces findings and then a later CLEAN** on long parents (S01, S02, S05, S09–S12, S14–S15). That is consistent with “keep iterating until clean,” not with a measured production catch rate.

The TP heuristic is too loose for a strong “usually catches real bugs” claim. What **is** Observed: empty-XML / lists-None CLEANs exist after batches of logic findings on BugBot, and Reviewer-a often files process/test lists that also eventually go CLEAN.

### Recommendation

**Mixed / leave the loop in place; do not treat CLEAN or 0.97 would-want `gone` as proof of ship-class catch.** Docs/test CLEANs remain valuable. Confidence: **medium** on “the loop iterates to CLEAN and usually edits after findings”; **low** on independently verified production bugs. Census n=15; follow-on rate n=3.

## Implications / open questions

1. Phase 3 `process_tp` stays frozen; follow-on fate lives in [follow-on-catch-escape/](../follow-on-catch-escape/_index.md).

## Sources

- Gitignored Phase 3 coding sheet
- [coding-rubric.md](../coding-rubric.md)
- [corpus-and-sample.md](../corpus-and-sample.md)
- [follow-on-catch-escape/results.md](../follow-on-catch-escape/results.md)
