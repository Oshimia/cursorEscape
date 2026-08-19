> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/angles/custom-instructions.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this study lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/`; UUID/path coding sheets and `.local/` were **not** copied (they remain gitignored in the openBuggy source repo at `docs/analysis/reviewer-effectiveness/.local/`). Do **not** create `docs/analysis/reviewer-effectiveness/.local/` here. References to `docs/analysis/**`, `eval/scripts/`, eval closeout scans, or openBuggy-only leak-scan commands describe **openBuggy operator procedures**, not cursorEscape maintenance or Phase 2 CI.
# Custom Instructions and scope

**Last updated:** 2026-08-16  
**Status:** Phase 4 — coded sample

## Context

Do parent Custom Instructions help, or hide bugs?

## Substance

### Evidence

Not fully coded as a sheet column (no silent rubric add). Observed from parent Task prompts during coding:

- High-iter `scc-saves` parents repeatedly re-scoped to the current fix (re-check one race / identity issue).
- S08 used **natural-language Diff** plus a variant Reviewer-a envelope (no locked opener; `fingerprint_ok` false).
- Catalog website-primary slots often declare phase + “Fast CI passed” (two of those are `ci_claimed_only`).

No systematic count of “ignore unrelated dirty tree” vs missed findings.

### Analysis

Soft scope is **how** 13-iteration loops stay coherent. Risk that NL / ignore-unrelated hides bugs is **Unknown** at sample scale. S08’s incomplete envelope (missing Completion gate / CI in the Reviewer-a prompt — Observed in that subagent’s own notes) correlates with a one-shot FINDINGS ending, not a CLEAN.

### Recommendation

**Improve templates, do not ban Custom Instructions.** Require the locked Reviewer-a opener + CI gate fields; treat NL Diff as allowed on dirty trees but not as a substitute for Fast CI Observed. Confidence: **low–medium**. Sample n=15.

## Implications / open questions

1. A Custom Instructions theme field exists on the rubric launch table but was not populated in Phase 3 — fill in a follow-on, do not backfill silently into frozen finding columns.

## Sources

- [orchestration-and-review-loops.md](../../../featureArchitecture/cursor-bugbot-agent-review/orchestration-and-review-loops.md)
- [diff-and-natural-language-modes.md](../../../featureArchitecture/cursor-bugbot-agent-review/diff-and-natural-language-modes.md)
- Gitignored Phase 3 coding sheet
