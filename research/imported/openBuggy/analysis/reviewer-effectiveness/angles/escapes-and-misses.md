> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/angles/escapes-and-misses.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this study lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/`; UUID/path coding sheets and `.local/` were **not** copied (they remain gitignored in the openBuggy source repo at `docs/analysis/reviewer-effectiveness/.local/`). Do **not** create `docs/analysis/reviewer-effectiveness/.local/` here. References to `docs/analysis/**`, `eval/scripts/`, eval closeout scans, or openBuggy-only leak-scan commands describe **openBuggy operator procedures**, not cursorEscape maintenance or Phase 2 CI.
# Escapes and misses

**Last updated:** 2026-08-16  
**Status:** Phase 4 census + follow-on Phase 2 deep sample

## Context

After dual-clean, does a later parent in the same alias rediscover a similar theme?

## Substance

### Evidence

Escape scan: up to **5** later dual-leg parents per alias; `theme_key` substring in later subagent text.

- **1 / 369** findings flagged `escape=True`.
- Method is **weak**: strict keys, only 5 later parents, no production incidents.
- Absence of flags is **not** proof of no escape.
- S08 never dual-cleaned in-sample.

### Follow-on (15 later parents; finding-list corpus)

[follow-on-catch-escape/results.md](../follow-on-catch-escape/results.md): **6 / 74** `escape_hit` on the reconciled rate set (all `transcript`; git `both` 0). Recoded parent excluded; dual-clean mtime anchor; later other-parent finding lists only. S01 4, S02 0, S13 2. Still **not** production incidents. n=3 parents.

### Analysis

The Phase 3 1/369 hit is noise at that matcher. Follow-on 6/74 is later-thread theme overlap (S01 and S13), still not incident proof.

### Recommendation

**Leave dual APPROVED as the loop bar; do not add a mandatory post-clean audit.** Phase 3 escape evidence is **weak** (1/369). Follow-on 6/74 is later-thread theme overlap on a small reconciled set — still **not** “escapes are common” or “escapes are rare.” Confidence: **low**. Census n=15; follow-on n=3.

## Implications / open questions

1. A single automated escape must not drive a keep/drop decision.

## Sources

- [methodology.md](../methodology.md) escape scan
- [follow-on-catch-escape/methodology.md](../follow-on-catch-escape/methodology.md)
