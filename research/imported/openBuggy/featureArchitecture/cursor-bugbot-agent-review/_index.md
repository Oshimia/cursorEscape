> **Imported research** — Source: openBuggy `docs/featureArchitecture/cursor-bugbot-agent-review/_index.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Cursor Agent Review BugBot (Observed Reference)

**Last updated:** 2026-08-16  
**Status:** Observed reference (Cursor local Agent Review) — not openBuggy runtime

## Context

This directory characterizes how **Cursor’s local Agent Review BugBot** (`subagent_type: bugbot`) is invoked and behaves, based on machine-local agent transcripts and Cursor skill/system text. It is a **replication reference** for openBuggy’s future harness — not a description of an implemented openBuggy engine, and not a substitute for [product/API research](../../research/bugbot-product-and-api-limits.md).

openBuggy’s **proposed** engine docs remain siblings under [`../_index.md`](../_index.md) and stay labeled Target / proposed.

## Claim legend

| Label        | Meaning                                                                                     |
| ------------ | ------------------------------------------------------------------------------------------- |
| **Observed** | Seen in fingerprinted BugBot subagent transcripts and/or Cursor skill text cited in Sources |
| **Inferred** | Reasonable interpretation of Observed evidence; may be incomplete                           |
| **Unknown**  | Not revealed in available logs; do not treat as fact for replication                        |

## Evidence corpus (machine-local)

| Field                                 | Value                                                                                                                        |
| ------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| Primary corpus                        | Cursor agent transcripts for the **easyPeasyWebsite** project                                                                |
| Typical path (this authoring machine) | `C:\Users\admin\.cursor\projects\c-Users-admin-source-repos-EZPZ-easyPeasyWebsite\agent-transcripts\`                        |
| Portability                           | **Not in openBuggy git.** Clones cannot re-verify Observed rows unless they have the same transcript tree or a future export |
| **Anonymized eval corpus**            | Publishable fixtures: [`../../../eval/cases/`](../../../eval/cases/README.md) (ground truth derived from catalog runs, not raw JSONL) |
| Fingerprint                           | See [run-catalog.md](./run-catalog.md)                                                                                       |

## Standardized Sources format

Prefer this shape in every suite doc:

```text
- Parent chat: <uuid> (cite without .jsonl)
- Subagent: <uuid>
- Skill: ~/.cursor/skills-cursor/review-bugbot/SKILL.md (or other absolute/external path)
- Date: <if known from transcript timestamp>
```

For non-URL observational sources, mark:  
`Primary source: local Cursor agent transcript / skill text (not independently re-verified via public URL).`

## Reading order

1. [overview-and-surfaces.md](./overview-and-surfaces.md) — what this is / is not  
2. [invocation-contract.md](./invocation-contract.md) — how parents launch BugBot  
3. [harness-expansion-and-mission.md](./harness-expansion-and-mission.md) — expanded mission prompt  
4. [diff-and-natural-language-modes.md](./diff-and-natural-language-modes.md) — diff vs NL  
5. [tooling-and-navigation.md](./tooling-and-navigation.md) — tools and exploration  
6. [output-contract.md](./output-contract.md) — XML findings schema  
7. [finding-personality.md](./finding-personality.md) — what it reports vs ignores  
8. [orchestration-and-review-loops.md](./orchestration-and-review-loops.md) — dual-gate parent loops  
9. [failure-modes-and-retries.md](./failure-modes-and-retries.md) — retries and NL fallback  
10. [unknowns-and-non-replicables.md](./unknowns-and-non-replicables.md) — gaps  
11. [run-catalog.md](./run-catalog.md) — evidence appendix  
12. [openbuggy-replication-mapping.md](./openbuggy-replication-mapping.md) — map to openBuggy proposals  

## Documents

| Doc                                                                        | Purpose                                   |
| -------------------------------------------------------------------------- | ----------------------------------------- |
| [overview-and-surfaces.md](./overview-and-surfaces.md)                     | Agent Review vs PR Bugbot; dual-gate role |
| [invocation-contract.md](./invocation-contract.md)                         | Parent Task envelope                      |
| [harness-expansion-and-mission.md](./harness-expansion-and-mission.md)     | Mission bias and expansion                |
| [diff-and-natural-language-modes.md](./diff-and-natural-language-modes.md) | Diff injection vs NL map                  |
| [tooling-and-navigation.md](./tooling-and-navigation.md)                   | Tool use and codebase navigation          |
| [output-contract.md](./output-contract.md)                                 | XML schema and clean bar                  |
| [finding-personality.md](./finding-personality.md)                         | Bug classes and suppressions              |
| [orchestration-and-review-loops.md](./orchestration-and-review-loops.md)   | Reviewer-a + BugBot loops                 |
| [failure-modes-and-retries.md](./failure-modes-and-retries.md)             | Failures and skill retries                |
| [unknowns-and-non-replicables.md](./unknowns-and-non-replicables.md)       | Explicit unknowns                         |
| [run-catalog.md](./run-catalog.md)                                         | Fingerprinted run table                   |
| [openbuggy-replication-mapping.md](./openbuggy-replication-mapping.md)     | Replication map                           |

## Implications / open questions

1. openBuggy should treat this suite as **behavioral requirements + known unknowns**, not as a copy of Cursor internals.
2. When a public export of anonymized catalog rows is desired, add an SOP for redaction and update the corpus path note here.

## Sources

- This suite’s topical docs and [run-catalog.md](./run-catalog.md)
- [Bugbot product and API limits (research)](../../research/bugbot-product-and-api-limits.md)
- Skill: `~/.cursor/skills-cursor/review-bugbot/SKILL.md`
- Skill: `~/.cursor/skills/implementation-review/SKILL.md`
- [Reviewer-a / BugBot effectiveness (analysis)](../../analysis/reviewer-effectiveness/_index.md) — live-loop study; not this Observed harness suite
