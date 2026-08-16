> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/corpus-and-sample.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this study lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/`; UUID/path coding sheets and `.local/` were **not** copied (they remain gitignored in the openBuggy source repo at `docs/analysis/reviewer-effectiveness/.local/`). Do **not** create `docs/analysis/reviewer-effectiveness/.local/` here. References to `docs/analysis/**`, `eval/scripts/`, eval closeout scans, or openBuggy-only leak-scan commands describe **openBuggy operator procedures**, not cursorEscape maintenance or Phase 2 CI.
# Corpus and sample

**Last updated:** 2026-08-16  
**Status:** Phase 3 — finding-level coding complete (funnel below)

## Context

Alias-only funnel from machine-local transcripts. **In openBuggy:** UUID index in gitignored `.local/sample-index.md` (source repo only; not in cursorEscape).

Starting BugBot volume (eval mining census **2026-08-15**, not dual-leg): [eval-cross-repo-mining-inventory.md](../../featureArchitecture/eval-cross-repo-mining-inventory.md).

## Substance

### Dual-leg predicate (applied)

A parent is in the **pool** when parent metadata shows ≥1 `reviewer-a` Task **and** ≥1 `bugbot` Task. Recency: parent year **2026**. Census aliases: `website-primary`, `scc-saves`, `accounts`. Explicit one-leg skips are **not** a second pool path.

### Census 2026-08-16 (pool, not sample)

| Alias | Parents with metadata | Dual-leg 2026 |
|-------|----------------------|---------------|
| `website-primary` | 165 | 45 |
| `scc-saves` | 4 | 4 |
| `accounts` | 56 | 4 |
| **Pool** | — | **53** |

`website-primary` is in scope for this analysis (eval “do not re-mine” does not apply).

### Locked sample (15 slots)

Stratified: all dual-leg `scc-saves` and `accounts` in the pool, plus seven `website-primary` parents (one iteration tail, five catalog-overlap themes, one mid). Slot IDs map to UUIDs only in `.local/`.

| Slot | Alias | Stratum |
|------|-------|---------|
| S01 | `scc-saves` | high-iter |
| S02 | `scc-saves` | high-iter |
| S03 | `scc-saves` | mid |
| S04 | `scc-saves` | small |
| S05 | `accounts` | multi |
| S06 | `accounts` | ra-heavy |
| S07 | `accounts` | mid |
| S08 | `accounts` | thin-dual |
| S09 | `website-primary` | iter-tail |
| S10 | `website-primary` | catalog-inbox |
| S11 | `website-primary` | catalog-open-access |
| S12 | `website-primary` | catalog-lesson |
| S13 | `website-primary` | catalog-docs-nl |
| S14 | `website-primary` | catalog-roles |
| S15 | `website-primary` | mid |

Phase 3 applies high-launch **triage** to every locked slot that exceeds 8 launches on either leg ([coding-rubric.md](./coding-rubric.md)) — not only S01/S02/S09.

### Funnel (Phase 3)

| Stage | Count |
|-------|-------|
| Pool parents | 53 |
| Sampled parents | 15 |
| Launches coded (fingerprinted Reviewer-a / BugBot after triage) | 182 |
| Launches `sampled_out` (triage) | 44 |
| Findings coded | 369 |
| Unscorable (unparseable reviewer outcome) | 4 |

Other subagents in the same parents (implementer / plan-reviewer / etc.) are **out of scope** (168 files) and are not in the funnel.

CI codes on the 15 parents: `ci_observed` 11, `ci_claimed_only` 2, `ci_skipped` 2.

Three slots (S03, S09, S13) have BugBot-coded launches only: parent metadata still showed both Task types (dual-leg pool), but Reviewer-a subagent files were not UUID-linked. Do not treat those slots as intentional one-leg skips.

Variant envelopes (missing mission opener, parent Task UUID still maps) are coded with `fingerprint_ok` false — one launch in this sample (S08 Reviewer-a).

### Contrast (not in main rates)

None yet. Older-era parents were not mixed in; the 2026 dual-leg pool was large enough (53 ≥ 12).

## Implications / open questions

1. Thin-dual S08 is included so skip/under-loop behavior is visible; it will not dominate rates.
2. Catalog-overlap slots are for later-thread follow-up, not because eval fixtures are ground truth. Deep-sample slot lock for catch/escape recode: [follow-on-catch-escape/sample.md](./follow-on-catch-escape/sample.md).

## Sources

- Gitignored Phase 2 census (operator `.local/` only)
- [eval-cross-repo-mining-inventory.md](../../featureArchitecture/eval-cross-repo-mining-inventory.md)
- [cross-repo-bugbot-mining.md](../../SOPs/cross-repo-bugbot-mining.md)
- [methodology.md](./methodology.md)
