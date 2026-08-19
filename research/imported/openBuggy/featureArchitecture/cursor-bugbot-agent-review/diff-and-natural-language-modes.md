> **Imported research** — Source: openBuggy `docs/featureArchitecture/cursor-bugbot-agent-review/diff-and-natural-language-modes.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Diff and Natural-Language Modes

**Last updated:** 2026-08-04  
**Status:** Observed reference (Cursor Agent Review)

## Context

BugBot’s correctness depends on **what change set it thinks it is reviewing**. Cursor supports a harness-computed unified diff and a natural-language fallback map. openBuggy’s [diff-and-scope-model.md](../diff-and-scope-model.md) is the **proposed** analogue — this doc is what Cursor’s Agent Review actually does in logs.

## Substance

### Mode A — Diff-injected (**Observed**)

1. Parent sets `Diff: branch changes` or `Diff: uncommitted changes` (optional `Base Branch`).
2. Parent does **not** attach the patch (**Observed** skill rule).
3. Harness expands the mission with a `<diff>…</diff>` (or equivalent) containing unified diffs with line numbers.
4. Mission instructs: only report bugs introduced by the **provided diff**; locate findings using diff line numbers.

**Inferred:** Large diffs may be truncated or chunked — truncation policy is **Unknown** (not logged clearly).

### Mode B — Natural language (**Observed**)

Triggered when:

- Parent explicitly sets `Diff: natural language` with `Change Description`, **or**
- Skill retry after empty/failed diff computation (**Observed** skill)

Mission differences:

- States the agent was **not** given a diff
- Treats the description as a **map of where to look** — may be incomplete/imprecise
- Requires reading **actual current files** before reporting
- Warns not to flag pre-existing problems in unrelated code read for context

**Observed examples:** ShareLessonModal-focused reviews under parent [673cf81a](673cf81a-41fd-424a-9276-8fda415f864d); docs-focused NL run under [117dfa71](117dfa71-0619-45f9-ab3f-bd2ebb26b8bf).

### Parent must not precompute (**Observed**)

`review-bugbot` states the review subagent computes the local diff from the repository path. Precomputing and stuffing a custom patch into the envelope is outside the supported contract (NL `Change Description` is the intentional alternative).

### Scope semantics claimed by skill (**Observed** wording; git details **Unknown**)

| Skill claim           | Detail                                                                                        |
| --------------------- | --------------------------------------------------------------------------------------------- |
| `branch changes`      | Against merge-base with default/base branch; includes committed, staged, and unstaged changes |
| `uncommitted changes` | Local working tree / dirty / not-yet-committed focus                                          |
| Base branch inference | Subagent/harness infers repo default (e.g. `main`) unless `Base Branch` provided              |

Exact `git` commands, untracked-file inclusion, and binary handling: **Unknown**.

### Comparison to openBuggy proposal

openBuggy’s proposed `branch` / `uncommitted` scopes intentionally mirror this split. Exact parity requires implementing and documenting git semantics that Cursor does not expose in transcripts.

## Implications / open questions

1. Always support an NL/change-map fallback for dirty trees and failed diffs — Agent Review depends on it in practice.
2. Do not silently mix branch and uncommitted scopes (openBuggy v0 recommendation aligns with Cursor’s explicit Diff enum).

## Sources

- Skill: `~/.cursor/skills-cursor/review-bugbot/SKILL.md`
- NL runs: subagents [17bc9f41](17bc9f41-75ba-42cd-a8c7-9e120e9ceebc), [fd935f45](fd935f45-e043-446c-8751-4fa3c4c04465), [1eb3505a](1eb3505a-7a9a-4c3c-816c-3961a549e46c)
- Diff runs: [a08f99f3](a08f99f3-6233-40c4-85b8-4132655e6feb), [9a4010dc](9a4010dc-8716-4962-95c1-0a9c092ad659), [d143b0d4](d143b0d4-0e23-440b-bea8-60468341bafd)
- Primary source: local Cursor agent transcript / skill text (not independently re-verified via public URL)
