> **Imported research** — Source: openBuggy `docs/featureArchitecture/context-retrieval.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Context Retrieval (Proposed)

**Last updated:** 2026-08-04  
**Status:** Target / proposed

## Context

Feeding “the whole repo” into a model is expensive and noisy. Quality lives in **what context is selected** for each changed region. This stage sits between diff resolution and multi-pass review ([engine](./review-engine-architecture.md)). Cursor Agent Review’s Observed navigation (callers, APIs, tests, schema, docs via Read/Grep/Glob) is characterized in [tooling-and-navigation.md](./cursor-bugbot-agent-review/tooling-and-navigation.md) — this doc remains openBuggy’s **proposed** retrieval design, not a reverse-engineered Cursor index.

---

## Substance

### Retrieval goals

For each changed file/symbol (as available):

| Signal | Why |
|--------|-----|
| Definition / nearby implementation | Understand the change itself |
| Callers / callees | Cross-file contract bugs |
| Existing tests touching the area | Test gaps and false assumptions |
| Project rules | `AGENTS.md`, `.openbuggy/`, language conventions |
| Sibling “known good” patterns | Convention drift (Greptile-style signature catches) |

### Mechanisms (proposed, incremental)

1. **v0:** changed file full text (capped) + diff hunks + root rules files  
2. **v1:** ripgrep / simple symbol search; optional tree-sitter or LSP when present  
3. **Later:** optional embedding index — only if eval proves need

### Token budget policy (proposed)

- Hard cap per pass and per review
- Prefer evidence near changed lines
- Drop low-value files (lockfiles, generated) unless explicitly included
- Never send `.env` / credential paths (align with sensitive-file holds)

### Non-goals

- Guaranteeing perfect whole-program analysis in v0
- Requiring a cloud-hosted code graph SaaS

---

## Implications / open questions

1. Measure retrieval ablations in the eval harness ([eval](./eval-harness-and-tuning.md)).
2. VS Code can later supply LSP-backed retrieval, but the engine must work headlessly without an IDE.
3. Context greed is a top failure mode — default to tight caps.
