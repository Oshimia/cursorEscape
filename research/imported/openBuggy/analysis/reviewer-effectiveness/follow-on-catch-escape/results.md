> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/follow-on-catch-escape/results.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this follow-on lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/follow-on-catch-escape/`; gitignored sheets (e.g. `.local/follow-on-sheet.json`, git-roots map) remain only in the openBuggy source repo. Do **not** create `.local/` under cursorEscape `docs/analysis/`. Path and closeout guidance below describes **openBuggy operator procedures**, not cursorEscape CI.
# Follow-on results

**Last updated:** 2026-08-16  
**Status:** Phase 2 — coded reconciled slots S01, S02, S13

## Context

Formulas: [methodology.md](./methodology.md). Sheet: gitignored `.local/follow-on-sheet.json`.

**Fate:** implementer tool window after that launch’s Task. Re-raise = later same-leg finding title with ≥4 stem overlap. `gone` = edit in the window and no re-raise.

**Value:** class heuristics (logic/security/docs → would-want; coverage wish-list tests → optional-later).

Census layer remains 15 / 182 / 369.

## Substance

### Rate set

3 dual-coded parents (S01, S02, S13). **66** launches (no triage; Task counts match). **74** findings. Zero `accounts`. Parent-level: **3 / 3** last coded launch CLEAN on both legs. Intervals are wide at n=3.

S13 Reviewer-a launches are all `fingerprint_ok` false (variant opener). S01/S02 Reviewer-a used the locked opener.

**BugBot-only stratum:** none (n_findings 0). S12/S15/S09/S03 are coded in `.local/` as vignettes outside the rate-sample cap.

### Dual-leg primary catch (would-want)

| | n |
|--|--|
| would-want with coded fate | 33 |
| fate `gone` | 32 |
| **catch rate** | **32 / 33 ≈ 0.97** |
| `transformed` share | 1 / 33 ≈ 0.03 |

This is an **in-thread process rate** (parent windows almost always contain Write/StrReplace). Not independently verified production catch. Confidence: **medium** on edits; **low** on “this title was the edit.”

### Over-fix (disagree)

0 disagree findings in the rate set.

### Optional-later

41 findings (counts only).

### Escapes

**6 / 74** `escape_hit`. Evidence: `transcript` 6, `both` 0, `none` 68.

`scc-saves` git root missing; S13 git did not 4-stem-corroborate. Hits: S01 4, S02 0, S13 2.

Corpus: finding lists parsed from later-parent Reviewer-a / BugBot assistant output. Recoded parent excluded. Later parents: `mtime >` dual-clean escape anchor, cap 15.

## Implications / open questions

1. 0.97 would-want `gone` does **not** replace rank 6.
2. Escape 6/74 is later-thread theme overlap on a small n.

## Sources

- [./methodology.md](./methodology.md)
- [./sample.md](./sample.md)
- Gitignored `.local/follow-on-sheet.json`
