> **Imported research** — Source: openBuggy `docs/featureArchitecture/cursor-bugbot-agent-review/unknowns-and-non-replicables.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Unknowns and Non-Replicables

**Last updated:** 2026-08-04  
**Status:** Observed reference — explicit gaps

## Context

Replicating Agent Review does **not** require copying Cursor’s proprietary stack. It does require honesty about what transcripts and public docs do not reveal. Treat items here as **Unknown** unless new evidence appears.

## Substance

### Harness / git internals (**Unknown**)

| Topic                                                              | Why it matters     |
| ------------------------------------------------------------------ | ------------------ |
| Exact `git` commands for `branch changes` vs `uncommitted changes` | Scope parity       |
| Whether untracked files are included                               | Dirty-tree reviews |
| Merge-base selection edge cases (orphan branches, shallow clones)  | Wrong diffs        |
| Binary / generated file handling                                   | Noise vs misses    |
| Diff truncation / chunking before injection                        | Incomplete reviews |

### Hidden runtime (**Unknown**)

| Topic                                                | Notes                                                                                                                                                            |
| ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| System prompts beyond expanded user_query            | Not in JSONL user message                                                                                                                                        |
| Model routing / temperature / stop sequences         | Not logged                                                                                                                                                       |
| Server-side multi-pass critics or confidence filters | Public marketing mentions multi-pass ideas for Bugbot; **local Agent Review transcripts show a single agent tool loop** — do not equate the two without evidence |
| Tool allowlist enforcement                           | Only Observed tools are known used                                                                                                                               |

### Rules files and effort (**Unknown** for local Agent Review)

| Topic                                                | Evidence                                                                                                                                                                             |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `.cursor/BUGBOT.md` affecting **local** Agent Review | **Not observed** in fingerprinted mission prompts in this corpus (`rg` over mission-opener subagents found no BUGBOT.md hits). PR Bugbot product docs describe rules — see research. |
| Effort levels (light/deep) for local Agent Review    | Not observed in sampled envelopes                                                                                                                                                    |
| Autofix / Cloud Agents                               | PR/product surface — out of scope for this suite                                                                                                                                     |

### Non-goals / non-replicables (by design)

| Item                                                | Stance                                                 |
| --------------------------------------------------- | ------------------------------------------------------ |
| Proprietary BugBot weights / PR-resolution learning | Do not attempt; compete via process + retrieval + eval |
| Cursor Enterprise Bugbot API as inference API       | Not offered; research documents trigger/analytics only |
| Bit-identical XML or Cursor UI                      | openBuggy may use JSON; preserve semantics             |

### What **is** replicable from Observed evidence

- Parent envelope + Diff modes + NL fallback
- Mission personality (recall bias, production bugs, style suppression, introduced-by-change)
- Readonly tool loop with codebase navigation
- Structured findings with categories/severities and empty-clean bar
- Dual-gate orchestration with a separate production-readiness reviewer

## Implications / open questions

1. openBuggy multi-pass ([multi-pass-review-pipeline.md](../multi-pass-review-pipeline.md)) is an **openBuggy design choice**, not a proven local Agent Review mechanism from this corpus.
2. Re-verify BUGBOT.md / effort if Cursor changes Agent Review; keep this doc dated.

## Sources

- Corpus search notes: Phase 1 catalog work 2026-08-04 (mission opener fingerprint; no BUGBOT.md in those files)
- [bugbot-product-and-api-limits.md](../../research/bugbot-product-and-api-limits.md)
- [multi-pass-review-pipeline.md](../multi-pass-review-pipeline.md) (proposed openBuggy; public multi-pass claim about Bugbot is not validated as local Agent Review behavior here)
- Primary source: local Cursor agent transcript / skill text (not independently re-verified via public URL)
