# Tier 2 Finding: grill-me

**Snapshot:** Productivity; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/grill-me/SKILL.md)
- **Docs:** [grill-me.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/grill-me.md)

## Verified purpose

`grill-me` is the stateless, user-invoked front door for the same interview primitive as `grilling`, for loose ideas outside a working directory. The catalog is accurate; the docs add important boundaries: start fresh, do not use plan mode, and stop or prototype when a question cannot be settled by conversation.

## Core mechanism

Delegate all questioning to `grilling`, preserve the same frontier rounds, and leave no files. The user owns scope and decisions; the agent must expose ungrillable questions instead of guessing.

## What it does better than the local equivalent

There is no local stateless interview entry point. The source explicitly says “It writes no files and leaves no workspace behind” and distinguishes conversational decisions from questions requiring a runnable prototype ([grill-me.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/grill-me.md)). That is a useful low-ceremony option when no repository or plan artifact should be changed.

## What cursorEscape does better

cursorEscape's normal workflow is deliberately repository-centered and has a formal implementation-plan plus plan-review path. A separate stateless wrapper could bypass repository discovery, escalation decisions, and clean-context review inputs unless it is clearly limited to idea shaping. Upstream's one-line delegation also inherits the known dependency-loading fragility of the `grilling` primitive.

## Host dependency

The interview is portable. Upstream frontmatter and `Skill` tool invocation are host-specific; no tracker or filesystem is required.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 4 | Stateless conversation is host-neutral. |
| Thin-harness | 5 | It is intentionally a one-line wrapper. |
| Gate-able | 3 | Confirmation is useful, but no artifact records it. |
| Isolated-reviewable | 2 | It is human alignment, not an isolated review artifact. |

## Adaptation proposal

**Draft verdict: Reference-only.** Keep the stateless-vs-stateful distinction as a design reference for the adapted `grilling` entry point. Do not add a second local wrapper until the owner identifies a recurring no-repository use case; if that happens, it should point to the shared primitive and explicitly prohibit implementation or plan-file writes.

**Trigger to reconsider:** repeated use of cursorEscape for non-repository decisions where `grill-with-docs` would create unwanted artifacts.

## Cost + risk

Low implementation cost but high duplication risk with `grilling`. The main behavioral risk is a parallel entry point that escapes discovery or is mistaken for the repository planning gate.

## Verdict

**Reference-only (draft; owner discussion required).** The useful distinction belongs in the shared primitive; a separate local wrapper is not justified by the current repository-centered workflow.
