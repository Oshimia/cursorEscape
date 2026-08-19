> **Imported research** — Source: openBuggy `docs/featureArchitecture/cursor-bugbot-agent-review/tooling-and-navigation.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Tooling and Navigation

**Last updated:** 2026-08-04  
**Status:** Observed reference (Cursor Agent Review)

## Context

BugBot is not a single-shot “read the diff only” classifier. In transcripts it runs a **multi-turn tool loop** to verify findings against surrounding code. This is central to replicating Agent Review quality.

## Substance

### Tools actually used (**Observed**)

| Tool      | Role                                                                             | Frequency                                    |
| --------- | -------------------------------------------------------------------------------- | -------------------------------------------- |
| **Read**  | Open changed files and related call sites                                        | Primary — nearly every run                   |
| **Grep**  | Find callers, symbols, grants, tests, related strings                            | Very common                                  |
| **Glob**  | Locate related paths (e.g. verify-grants SQL, sibling docs)                      | Common on multi-file/schema work             |
| **Shell** | Occasional `git show` / `git diff` / path filters to compare pre-change behavior | Occasional verification, not primary scoping |

### Tools / actions not observed as typical

| Action                    | Notes                                                       |
| ------------------------- | ----------------------------------------------------------- |
| Write / StrReplace        | Mission forbids modifying files; runs appear readonly       |
| Running CI / test suites  | Parents run CI; Custom Instructions often say not to re-run |
| Spawning nested subagents | Not observed in BugBot legs                                 |
| Web search / SCM API      | Not observed in sampled local Agent Review runs             |

### Typical sequence (**Observed**)

1. Parallel **Read** of files named in the diff or NL description  
2. **Grep** / further **Read** for callers, RPCs, tests, schema, feature docs  
3. Optional **Shell git** to confirm “introduced by this change” vs pre-existing  
4. Short reasoning, then XML-only final answer  

### Exploration habits (**Observed**)

BugBot routinely pulls context beyond the patch hunk:

- **Callers / mount points** (UI modal → shell / atoms)
- **Downstream APIs** (frontend action → backend route)
- **Prior migrations / schema dumps / grants**
- **Tests and fixtures**
- **Feature architecture / SOP docs** to check intent vs code
- **Cross-layer consistency** (FE allows → BE persists → SQL grants)

### Run size (**Observed** ranges from catalog)

| Intensity    | Approx assistant turns | Typical context                               |
| ------------ | ---------------------- | --------------------------------------------- |
| Light–medium | ~7–13                  | Focused UI or single migration + docs         |
| Heavy        | ~17–29                 | Cross-stack auth/SQL/UI or large phase review |

Tool call counts roughly track turn count (often ~10–40 tool uses on heavier runs). Exact counts vary; see [run-catalog.md](./run-catalog.md).

### Adversarial / confidence tooling (**Unknown** as a separate stage)

Transcripts do **not** show a second “critic” agent or explicit confidence scores. Filtering appears to happen inside the same agent’s reasoning under mission rules (recall bias + introduced-by-change + ignore style). Any server-side merge is **Unknown**.

## Implications / open questions

1. openBuggy’s [context-retrieval.md](../context-retrieval.md) should treat callers/tests/schema/docs as first-class retrieval targets — matching Observed behavior.
2. Allow optional git history probes for “introduced by this change” verification without making git the only scope source.

## Sources

- Tool traces: [17bc9f41](17bc9f41-75ba-42cd-a8c7-9e120e9ceebc) (Read/Grep), [a08f99f3](a08f99f3-6233-40c4-85b8-4132655e6feb) (Read/Grep/Glob), [0f9826dd](0f9826dd-d110-4c9c-ad1f-fb31179481a8) (Shell `git show`), [d143b0d4](d143b0d4-0e23-440b-bea8-60468341bafd), [70b0d3ea](70b0d3ea-22e2-4c99-8abf-fc70721ad3d6)
- Parents: [673cf81a](673cf81a-41fd-424a-9276-8fda415f864d), [33ebcc6d](33ebcc6d-cba2-40cd-82cb-63b734d47da5), [c5d86381](c5d86381-0609-4b7f-8296-09dec84bb5e8)
- Primary source: local Cursor agent transcript / skill text (not independently re-verified via public URL)
