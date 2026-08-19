> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/angles/bugbot-process.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this study lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/`; UUID/path coding sheets and `.local/` were **not** copied (they remain gitignored in the openBuggy source repo at `docs/analysis/reviewer-effectiveness/.local/`). Do **not** create `docs/analysis/reviewer-effectiveness/.local/` here. References to `docs/analysis/**`, `eval/scripts/`, eval closeout scans, or openBuggy-only leak-scan commands describe **openBuggy operator procedures**, not cursorEscape maintenance or Phase 2 CI.
# BugBot process

**Last updated:** 2026-08-16  
**Status:** Phase 4 — coded sample

## Context

When and how parents should **launch** local Agent Review BugBot. Not model internals, not PR Bugbot, not eval scores.

## Substance

### Evidence

- **119** coded BugBot launches; iteration-cost proxy **10%** vs **56%** on Reviewer-a (process/docs/`BUGBOT_RULES` + later CLEAN — not a value ranking; tests are a separate class).
- Class mix: logic 113 of 369 findings overall, mostly this leg; security 5; `BUGBOT_RULES` 10.
- Long tails (13 and 36 launches) still reached last-coded CLEAN on those slots.
- Fingerprint opener matched on essentially all BugBot files (`fingerprint_ok` false only on the S08 Reviewer-a variant).

### Analysis

Launching BugBot **in parallel every iteration** is costly on tails but is the source of logic/security signal. Gating BugBot behind a CLEAN Reviewer-a would have missed BugBot-only slots S03/S09/S13 (RA not coded) and would delay logic catches on S01/S02.

`BUGBOT_RULES` volume is small (10) — not the main **iteration-cost** story (Reviewer-a process/test **volume** is).

### Recommendation

**Keep always-parallel BugBot on dual-gate phases.** Combine with the 8-launch **re-scope** trigger ([iteration-policy.md](./iteration-policy.md)), not a skip of BugBot. NL Diff remains allowed when the tree is dirty. Confidence: **medium**. Sample n=15.

## Implications / open questions

1. openBuggy remains the proposed long-term bug-finder; this rec is for the **current Cursor loop** only.

## Sources

- [invocation-contract.md](../../../featureArchitecture/cursor-bugbot-agent-review/invocation-contract.md)
- [orchestration-and-review-loops.md](../../../featureArchitecture/cursor-bugbot-agent-review/orchestration-and-review-loops.md)
- Gitignored Phase 3 coding sheet
