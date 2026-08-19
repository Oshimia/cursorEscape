> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/methodology.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this study lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/`; UUID/path coding sheets and `.local/` were **not** copied (they remain gitignored in the openBuggy source repo at `docs/analysis/reviewer-effectiveness/.local/`). Do **not** create `docs/analysis/reviewer-effectiveness/.local/` here. References to `docs/analysis/**`, `eval/scripts/`, eval closeout scans, or openBuggy-only leak-scan commands describe **openBuggy operator procedures**, not cursorEscape maintenance or Phase 2 CI.
# Methodology

**Last updated:** 2026-08-16  
**Status:** Parent study Phases 1–5 complete (sheet frozen). Fingerprints and dual-leg predicate in this file still apply. Catch/escape measurement follow-on: [follow-on-catch-escape/methodology.md](./follow-on-catch-escape/methodology.md).

## Context

How this study counts runs, what it excludes, and how committed docs stay free of secrets. Parent-study coding used [coding-rubric.md](./coding-rubric.md). New fate/value coding uses the follow-on rubric, not silent columns here.

## Substance

### Claim legend

| Label | Meaning |
|-------|---------|
| **Observed** | Seen in fingerprinted transcripts or cited skill text |
| **Inferred** | Interpretation of Observed evidence |
| **Unknown** | Not in available logs |

### UUID barrier

**In openBuggy (source repo):** committed files under `docs/analysis/` must not contain parent/subagent UUIDs, absolute machine paths, home-directory skill paths, or product/customer strings. Those live only in gitignored `docs/analysis/reviewer-effectiveness/.local/` in the openBuggy source repo — **not copied to cursorEscape**; do not create that path here. Published text uses project **aliases** (same bar as [eval-cross-repo-mining-inventory.md](../../featureArchitecture/eval-cross-repo-mining-inventory.md), uncopied in this import mirror). Name external skills in prose without operator filesystem paths.

### website-primary vs eval mining SOP

[cross-repo-bugbot-mining.md](../../SOPs/cross-repo-bugbot-mining.md) says do not re-search `website-primary` for **new eval cases** (already harvested `bb-01`…`bb-18`). **This study still reads those transcripts.** That exclusion is eval-fixture growth, not a ban on analysis.

**Exclude from this study:** `openbuggy-meta`, TEMP `openbuggy-eval-*` workspaces, unmapped cloud project IDs.

### BugBot fingerprint (locked, inherited)

A BugBot run counts only if **all** hold ([run-catalog.md](../../featureArchitecture/cursor-bugbot-agent-review/run-catalog.md)):

1. Parent Task uses `description: "Bugbot"` and `subagent_type: "bugbot"` (when parent metadata exists), **and**
2. Subagent first user message contains `You are reviewing local code changes for bugs`

Do not count prose mentions of BugBot (e.g. plan-reviewer discussing the skill).

### Reviewer-a fingerprint (locked)

A Reviewer-a run counts only if **all** hold:

1. Parent Task uses `subagent_type: "reviewer-a"` (when parent metadata exists), **and**
2. Subagent first user message contains `Use the reviewer-a subagent to review this implementation.`

Task `description` varies and is **not** a fingerprint. Do not count plan-reviewer or prose mentions of Reviewer-a.

**Phase 3:** if the opener is missing but the parent Task UUID maps to the subagent file, still code the launch with `fingerprint_ok` false (Observed variant envelope). Do not classify other subagents by Verdict-like prose.

**Observed** opener_only analog: parent JSONL missing (website-primary / accounts `no_parent_jsonl` rows) — those parents are out of the dual-leg pool.

### Dual-leg parent predicate (applied at freeze)

**Pool / main sample:** parent metadata shows ≥1 `reviewer-a` Task **and** ≥1 `bugbot` Task, and parent year is **2026**.

Census **2026-08-16** on `website-primary`, `scc-saves`, `accounts`: **53** dual-leg 2026 parents in pool; **15** locked in [corpus-and-sample.md](./corpus-and-sample.md). Explicit one-leg **skips** are not a second pool path; if a locked parent shows a skip of a later iteration, code it under iteration/process angles.

### Recency

Main rates: parent chats dated **2026** in the current `implementation-review` dual-gate era. Older parents are **Contrast** only — do not mix into main percentages.

### Docs-only CI waiver (openBuggy source repo only)

**In openBuggy:** degraded suite is `python -m pytest eval/scripts/test_*.py` ([composer-subagent-temp-isolation.md](../../roadmaps/composer-subagent-temp-isolation.md), uncopied). **This study does not touch `eval/scripts/`.** Fast/Full for analysis markdown phases in openBuggy is **`n/a`**. Dual review still runs. Optional pytest is hygiene, not a gate.

**In cursorEscape:** no `eval/scripts/` tree; Phase 2 closeout uses hub link integrity + COPY-MANIFEST checks — not openBuggy leak scans or pytest below.

Full **surrogate for openBuggy analysis phase closeout:** documenting SOP + leak scan (`rg` for UUID-shaped strings, Windows user-profile prefixes, and `.jsonl` under openBuggy `docs/analysis/**` excluding `.local/`). **Not applicable to cursorEscape import maintenance.**

### Eval harness is not an outcome

Do not use `eval/cases/` expected XML or scorer nets as “the loop works.” Those fixtures are circular with historical BugBot output.

### Escape scan (Phase 3)

For each locked parent, inspect **up to 5** later dual-leg parents in the **same alias** (later parent-file mtime) for theme overlap with issues that were CLEAN in the sampled parent. Do not read the entire website-primary tree.

**Follow-on catch+escape** ([follow-on-catch-escape/methodology.md](./follow-on-catch-escape/methodology.md)) supersedes this window **for that study only**: up to **15 other** later dual-leg parent files per recoded parent (the recoded parent JSONL is never in that scan); git is corroboration only. Phase 3 rates in this parent study still used the 5-parent scan.

## Implications / open questions

1. Dual-leg requires parent transcript files; roots without parent metadata stay out of the main sample.
2. Census launch counts used for stratification are volume hints, not coded findings.

## Sources

- [cross-repo-bugbot-mining.md](../../SOPs/cross-repo-bugbot-mining.md)
- [run-catalog.md](../../featureArchitecture/cursor-bugbot-agent-review/run-catalog.md)
- [orchestration-and-review-loops.md](../../featureArchitecture/cursor-bugbot-agent-review/orchestration-and-review-loops.md)
- Primary source: local Cursor agent transcript / skill text (not independently re-verified via public URL)
