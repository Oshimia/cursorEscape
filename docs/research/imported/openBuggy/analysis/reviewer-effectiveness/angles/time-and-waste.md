> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/angles/time-and-waste.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this study lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/`; UUID/path coding sheets and `.local/` were **not** copied (they remain gitignored in the openBuggy source repo at `docs/analysis/reviewer-effectiveness/.local/`). Do **not** create `docs/analysis/reviewer-effectiveness/.local/` here. References to `docs/analysis/**`, `eval/scripts/`, eval closeout scans, or openBuggy-only leak-scan commands describe **openBuggy operator procedures**, not cursorEscape maintenance or Phase 2 CI.
# Time and iteration cost

**Last updated:** 2026-08-16  
**Status:** Phase 4 — coded sample; language corrected after operator review (tests/docs are high value)

## Context

Does the loop **disproportionately consume iterations** on some finding classes? This is **latency under fix-all**, not a claim that documentation or tests are low-value catches.

For this operator (solo, AI does most coding): keeping docs aligned is how later agents stay consistent; tests are the regression net. Long suites make **when** those findings block the next review the real cost.

## Substance

### Evidence

Frozen sheet column `wasted_fix` is an **iteration-cost proxy**: class ∈ {docs, process, `BUGBOT_RULES`} **and** that leg later went CLEAN. It is **not** a human nit judgment and **not** “should not have been fixed.”

- **Tests are class `tests` and are not counted in `wasted_fix`.** They still add loop time because each bullet is fix-all → CI → re-review.
- Proxy rates: **145 / 369** findings (`39%`); Reviewer-a **131 / 235** (`56%`); BugBot **14 / 134** (`10%`).
- Launch volume after triage: BugBot **119**, Reviewer-a **63**. Reviewer-a lists are long (process + tests); that volume, not worthlessness, drives extra iterations.
- S08 never reached CLEAN, so its findings are not in the proxy even when they look like test gaps.

Class mix (value, not waste): process 143, logic 113, tests 92, `BUGBOT_RULES` 10, security 5, docs 5.

### Analysis

**High value, high latency:** Reviewer-a docs/process/test findings are the ship-set job. Under fix-all they lengthen the loop, especially as pytest/Full suites grow.

**Asymmetric latency vs BugBot:** BugBot is mostly logic and rarely hits the proxy. That means BugBot iterations are cheaper *per finding class*, not that Reviewer-a catches should be dropped.

**Operator overlay:** Prefer **blocking vs batchable by latency**, not by class-as-waste. Blocking: tests/docs that would mislead the next agent or miss a regression for *this* change. Batchable: coverage wish-list or prose polish that can wait for Full CI / a later pass so the dual-gate does not wait on a slow suite.

### Recommendation

**Keep Reviewer-a; keep docs and tests first-class.** Do not drop the leg or treat the 56% proxy as “nits.” Tune **when** findings re-block the loop (split blocking vs batchable; 8-launch re-scope in [iteration-policy.md](./iteration-policy.md)). Leave BugBot fix-all for logic/security. Confidence: **medium**. Sample n=15.

## Implications / open questions

1. The frozen column remains `wasted_fix`; committed prose must say **iteration cost**. A later study may rename the field.
2. Overlap matcher is near-zero — cost comparison is by class volume, not duplicate titles ([overlap-and-redundancy.md](./overlap-and-redundancy.md)).

## Sources

- Gitignored Phase 3 coding sheet
- [coding-rubric.md](../coding-rubric.md)
- Operator review 2026-08-16 (solo / AI-coding / docs+tests valued; long test loops slow)
