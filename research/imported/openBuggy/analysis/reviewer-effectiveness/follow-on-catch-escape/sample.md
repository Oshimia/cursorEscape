> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/follow-on-catch-escape/sample.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this follow-on lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/follow-on-catch-escape/`; gitignored sheets (e.g. `.local/follow-on-sheet.json`, git-roots map) remain only in the openBuggy source repo. Do **not** create `.local/` under cursorEscape `docs/analysis/`. Path and closeout guidance below describes **openBuggy operator procedures**, not cursorEscape CI.
# Follow-on sample (slot lock)

**Last updated:** 2026-08-16  
**Status:** Phase 2 — dual-leg rates = Task-reconciled slots only

## Context

UUID map in gitignored `.local/`. Zero `accounts` in the rate set. A slot enters **dual-leg rates** only when coded Reviewer-a + BugBot launch counts **equal** parent Task counts and both legs end CLEAN.

## Substance

### In dual-leg rates (reconciled)

| Slot | Alias | Tasks RA/BB | Coded RA/BB | Launches | Findings |
|------|-------|-------------|-------------|----------|----------|
| S01 | `scc-saves` | 13 / 13 | 13 / 13 | 26 | 25 |
| S02 | `scc-saves` | 13 / 13 | 13 / 13 | 26 | 36 |
| S13 | `website-primary` | 7 / 7 | 7 / 7 | 14 | 13 |

S13 is the gap pick (S09 failed reconciliation; S03 skipped to avoid three `scc-saves`). **66 launches**, **74 findings**. Last coded launch CLEAN on both legs: **3 / 3**.

### Recovered but not in rates

| Slot | Why out |
|------|---------|
| S12 | Parent Tasks 16 RA + 15 BB vs coded 12 + 14 |
| S15 | Parent Tasks 7 RA + 8 BB vs coded 5 + 8 |
| S09 | Parent Tasks 34 RA + 37 BB vs coded 7 + 36 (partial RA files) |
| S03 | Reconciled, but unused (would triple `scc-saves` after S01/S02) |

S08 remains out of catch rates. 6th slot unused (S12/S15 failed **reconciliation**, not dual-clean).

Variant Reviewer-a openers (`Completion gate: review-loop` / `Full Repository Path` without the BugBot bug-review sentence) are coded with `fingerprint_ok` false.

## Implications / open questions

1. Website-primary default picks (S12, S15) did not reconcile; the WP rate slot is recovered **S13**.
2. Catalog-overlap escape inflation is weaker with S13 than it would have been with S12.

## Sources

- [../corpus-and-sample.md](../corpus-and-sample.md)
- [./methodology.md](./methodology.md)
- Gitignored `.local/follow-on-sheet.json`
