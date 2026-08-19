> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/coding-rubric.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this study lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/`; UUID/path coding sheets and `.local/` were **not** copied (they remain gitignored in the openBuggy source repo at `docs/analysis/reviewer-effectiveness/.local/`). Do **not** create `docs/analysis/reviewer-effectiveness/.local/` here. References to `docs/analysis/**`, `eval/scripts/`, eval closeout scans, or openBuggy-only leak-scan commands describe **openBuggy operator procedures**, not cursorEscape maintenance or Phase 2 CI.
# Coding rubric

**Last updated:** 2026-08-16  
**Status:** Phase 3 — sheet frozen; do not add silent columns. Follow-on fate/value fields: [follow-on-catch-escape/rubric.md](./follow-on-catch-escape/rubric.md)

## Context

Finding-level (and launch-level) fields for the gitignored `.local/` sheet **in the openBuggy source repo** (not copied to cursorEscape). Inter-phase contract: new fields require an amendment here in the same phase.

## Substance

### Unit of analysis

- **Parent:** one review-loop chat (phase/thread).
- **Launch:** one Reviewer-a or BugBot subagent in that parent.
- **Finding:** one Reviewer-a list item or one BugBot `<bug>` (empty XML / lists `"None"` = zero findings).

### Launch fields

| Field | Notes |
|-------|--------|
| `parent_alias` | Committed docs use this only |
| `leg` | `reviewer-a` \| `bugbot` |
| `iteration` | 1-based in parent |
| `outcome` | CLEAN / APPROVED-empty vs non-empty findings |
| `assistant_turns` | If countable |
| `fingerprint_ok` | BugBot opener / Reviewer-a opener matched locked strings; false = parent Task UUID map only |

### Finding fields

| Field | Serves |
|-------|--------|
| `class` | security / logic / docs / process / tests / `BUGBOT_RULES` / other |
| `process_tp` | **Phase 3 applied meaning (frozen):** true if the **same leg later had a CLEAN launch**. Not independently verified disappearance of this title. Catch-effectiveness treats this as an over-count heuristic. Do not recode this column. |
| `wasted_fix` | **Iteration-cost proxy only** (frozen column name). True when class ∈ {docs, process, `BUGBOT_RULES`} and the same leg later went CLEAN. **Not** “low value.” Tests are class `tests` and are **not** this flag. Docs/tests are **high value, high latency** for a solo AI-driven maintainer. |
| `overlap` | Same theme on the other leg in same or adjacent iteration |
| `escape` | Similar issue in a later parent/phase after dual-clean, or in-thread user/CI report |
| `confidence` | High / medium / low (single rater) |

### CI gating (evidence vs claim)

Do **not** treat Custom Instructions that *say* “Fast CI passed” as proof.

| Code | Meaning |
|------|---------|
| `ci_observed` | Parent transcript shows Fast CI command output / explicit pass before the reviewer Tasks |
| `ci_claimed_only` | Parent or Custom Instructions assert CI passed; no command output in transcript |
| `ci_skipped` | Reviewers launched with failing or absent Fast CI **Observed** |
| `ci_unknown` | Cannot tell |

`angles/ci-gating.md` rates use `ci_observed` and `ci_skipped` as primary; `ci_claimed_only` is a separate row.

### High-launch triage (Phase 3)

If a parent exceeds **8 launches per leg:** code every non-empty / CHANGES REQUESTED iteration plus the **first and last** CLEAN; mark middle CLEAN launches `sampled_out` (not missing). The catch+escape follow-on **does not** apply this triage on locked deep-sample parents ([follow-on-catch-escape/methodology.md](./follow-on-catch-escape/methodology.md)).

### Follow-on fields (do not mutate this sheet)

Per-finding `fate`, `value`, `implementer_response`, and follow-on escape evidence are defined in [follow-on-catch-escape/rubric.md](./follow-on-catch-escape/rubric.md) and coded only in gitignored `.local/follow-on-sheet.json` **in the openBuggy source repo**. Do not add those columns here or silently change `process_tp` / `wasted_fix`.

### Labels that are not ground truth

Original BugBot XML titles are **not** independently verified bugs. `process_tp` is a process proxy, not production confirmation.

## Implications / open questions

1. Rubber-stamp vs genuine fixes remain **Unknown** without reading the implementer diff — prefer `confidence: low` when unclear.

## Sources

- Study design: operator plan (2026-08-16)
- Loop policy: [orchestration-and-review-loops.md](../../featureArchitecture/cursor-bugbot-agent-review/orchestration-and-review-loops.md)
