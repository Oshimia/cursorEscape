> **Imported research** — Source: openBuggy `docs/featureArchitecture/cursor-bugbot-agent-review/openbuggy-replication-mapping.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# openBuggy Replication Mapping

**Last updated:** 2026-08-04  
**Status:** Observed reference (maps to proposed openBuggy targets)

## Context

Maps Cursor Agent Review **Observed** behaviors to openBuggy’s **proposed** docs. This is the bridge from characterization to implementation — it does not claim openBuggy already implements parity.

## Substance

### Behavior → target doc

| Observed Cursor Agent Review behavior                                      | openBuggy target                                                                                                                                                                 | Gap / honesty note                                                                                                                               |
| -------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| Envelope: repo path + branch/uncommitted/NL scopes                         | [diff-and-scope-model.md](../diff-and-scope-model.md), SOP [choosing-diff-scope.md](../../SOPs/choosing-diff-scope.md)                                                           | Implement explicit scopes; document git semantics Cursor leaves Unknown                                                                          |
| Harness expands mission (recall bias, introduced-by-change, no style nits) | [review-engine-architecture.md](../review-engine-architecture.md) + future prompt templates                                                                                      | Keep mission stage explicit; do not rely on chat vibes                                                                                           |
| Readonly tool loop: Read/Grep/Glob + optional git show                     | [context-retrieval.md](../context-retrieval.md)                                                                                                                                  | Retrieval should prioritize callers, tests, schema, docs                                                                                         |
| Single agent tool loop in local transcripts                                | [multi-pass-review-pipeline.md](../multi-pass-review-pipeline.md)                                                                                                                | Multi-pass is **openBuggy proposal**; do not claim it mirrors local Agent Review logs. Public Bugbot multi-pass marketing ≠ Observed local JSONL |
| XML findings; empty answer = clean                                         | [findings-schema-and-agent-contract.md](../findings-schema-and-agent-contract.md)                                                                                                | Prefer JSON envelope; preserve semantic fields                                                                                                   |
| Dual-gate with production-readiness reviewer                               | [ide-and-agent-integration.md](../ide-and-agent-integration.md), SOP [running-an-agent-review-loop-with-openBuggy.md](../../SOPs/running-an-agent-review-loop-with-openBuggy.md) | openBuggy = bug leg only                                                                                                                         |
| Parent retries + NL fallback                                               | Failure handling in engine + CLI exit codes                                                                                                                                      | Mirror [failure-modes-and-retries.md](./failure-modes-and-retries.md)                                                                            |
| No Cursor proprietary eval data                                            | [eval-harness-and-tuning.md](../eval-harness-and-tuning.md), `eval/cases/` | Committed anonymized fixtures + agent scorer; not JSONL gold |
| Product/API/billing constraints                                            | [bugbot-product-and-api-limits.md](../../research/bugbot-product-and-api-limits.md)                                                                                              | Zero Cursor Bugbot API dependency                                                                                                                |
| Design focus = local agent loop                                            | [market-gap-and-positioning.md](../market-gap-and-positioning.md)                                                                                                                | Align scope/docs with Agent Review replacement, not PR-bot clone                                                                                 |

### Severity vocabulary mapping

| BugBot (Observed)           | openBuggy proposed (`findings-schema`) | Notes                                                                                                     |
| --------------------------- | -------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `high`                      | `critical` or `high`                   | **Inferred:** map clear security/data-loss/FK breaks to `critical` when impact warrants; otherwise `high` |
| `medium`                    | `medium`                               | Default for most LOGIC/SECURITY in catalog                                                                |
| `low`                       | `low`                                  | Rare in this corpus                                                                                       |
| _(none)_                    | `info`                                 | openBuggy-only; BugBot has no `info`                                                                      |
| Categories e.g. `LOGIC_BUG` | `category` string e.g. `correctness`   | Normalize names in v0 schema; keep mapping table in code                                                  |

### Category mapping (suggested)

| BugBot category               | openBuggy `category` suggestion                     |
| ----------------------------- | --------------------------------------------------- |
| `LOGIC_BUG`                   | `correctness`                                       |
| `SECURITY_ISSUE`              | `security`                                          |
| `POTENTIAL_EDGE_CASE`         | `correctness` or `test_gap`                         |
| `PERFORMANCE_ISSUE`           | `performance`                                       |
| `COMPILATION_ERROR`           | `correctness`                                       |
| `DOCUMENTATION_ISSUE`         | `docs` (often filtered unless production-impacting) |
| `CODE_QUALITY_STYLE`          | drop by default policy                              |
| `ACCIDENTALLY_COMMITTED_CODE` | `correctness` / hygiene                             |
| `BUGBOT_RULES`                | `policy` (user-instruction violations)              |

### Replication checklist (engine v0/v1)

1. Accept scope envelope analogous to [invocation-contract.md](./invocation-contract.md)
2. Resolve diff or NL map ([diff-and-natural-language-modes.md](./diff-and-natural-language-modes.md))
3. Apply mission template ([harness-expansion-and-mission.md](./harness-expansion-and-mission.md))
4. Retrieve context + optional git probes ([tooling-and-navigation.md](./tooling-and-navigation.md))
5. Emit structured findings; empty = clean ([output-contract.md](./output-contract.md))
6. Preserve bug-first personality ([finding-personality.md](./finding-personality.md))
7. Integrate as bug leg in dual loops ([orchestration-and-review-loops.md](./orchestration-and-review-loops.md))
8. Document Unknowns honestly ([unknowns-and-non-replicables.md](./unknowns-and-non-replicables.md))

## Implications / open questions

1. When implementation starts, freeze `schema_version` after aligning severity mapping with real eval cases.
2. Do not import Cursor transcript JSONL into the eval harness as proprietary gold data.

## Sources

- This suite’s topical docs
- [findings-schema-and-agent-contract.md](../findings-schema-and-agent-contract.md)
- [eval-harness-and-tuning.md](../eval-harness-and-tuning.md)
- [run-catalog.md](./run-catalog.md)
- Primary source: local Cursor agent transcript / skill text (not independently re-verified via public URL)
