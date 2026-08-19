> **Imported research** — Source: openBuggy `docs/featureArchitecture/cursor-bugbot-agent-review/orchestration-and-review-loops.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Orchestration and Review Loops

**Last updated:** 2026-08-04  
**Status:** Observed reference (Cursor Agent Review)

## Context

Standalone `/review-bugbot` exists, but the high-value pattern in the evidence corpus is **BugBot as one leg of a dual-reviewer iterative loop**. This doc describes how parents orchestrate that loop.

## Substance

### Loop shape (**Observed** — `implementation-review` + EZPZ `iterative-code-review` rule)

```text
Implement phase
  → Fast CI (parent only)
  → Parallel: Reviewer-a ∥ BugBot   (Completion gate: review-loop)
  → Fix ALL findings from either side
  → Repeat until both clean under policy
  → Full CI closeout (no reviewers)
```

Hard rules (**Observed** skill):

- Do not launch reviewers if Fast CI fails
- Never pair Full CI with a reviewer launch
- After dual APPROVED with empty finding lists, do not re-launch reviewers unless code changed
- No pass cap while findings remain — keep fixing and re-reviewing

### How BugBot is launched inside the loop (**Observed**)

From `implementation-review` “Invoke Bugbot”:

- `subagent_type: bugbot`, `description: "Bugbot"`, `readonly: true`, `run_in_background: false`
- Recommended model: `composer-2.5`
- Envelope: `Full Repository Path` + `Diff: branch changes | uncommitted changes` + `Custom Instructions` (phase, iteration, regressions, scope, CI already passed)

Parents often also use NL mode when the tree is dirty with unrelated changes (**Observed** in Share modal threads).

### Reviewer-a vs BugBot (**Observed**)

| Dimension    | BugBot                                        | Reviewer-a                                                                          |
| ------------ | --------------------------------------------- | ----------------------------------------------------------------------------------- |
| Output       | XML `<answer><bug>…` or empty                 | Markdown Verdict APPROVED / CHANGES REQUESTED + Blocking / Non-blocking / Test gaps |
| Focus        | Introduced production bugs / security / logic | Completeness, docs, tests, architecture, process, plus bugs                         |
| Clean signal | Empty `<answer></answer>`                     | All lists literally `"None"` + APPROVED                                             |
| Resume       | Single-shot; fresh each iteration             | Fresh each iteration (same parent pattern)                                          |

**Inferred:** Skill text that BugBot “must use the same verdict bar” is a **parent policy** overlay — BugBot’s native format does not emit that bar.

### Custom Instructions as soft scoping (**Observed**)

Parents use Custom Instructions to:

- Focus on the current phase’s files/concerns
- Ignore unrelated dirty-tree work from other threads
- Re-check a specific prior finding after a fix
- Declare “fresh review” after large fix batches

This is how Agent Review stays usable on large dirty worktrees without requiring a perfectly clean git state.

### Re-review after fixes (**Observed**)

Always a **new** BugBot subagent (no resume). Same or updated Custom Instructions. Catalog shows both “still finds bugs” and “clean” second iterations.

## Implications / open questions

1. openBuggy should remain the **bug-finder leg only**; keep production-readiness as a separate agent/schema ([ide-and-agent-integration.md](../ide-and-agent-integration.md)).
2. Parent orchestrators (skills) own CI gating — the review engine must not require running CI itself.

## Sources

- Skill: `~/.cursor/skills/implementation-review/SKILL.md`
- Rule (EZPZ): `.cursor/rules/iterative-code-review.mdc`
- Skill: `~/.cursor/skills-cursor/review-bugbot/SKILL.md`
- Loop parents: [429a3195](429a3195-9a20-492c-bff3-a1bfc9e4ad85), [673cf81a](673cf81a-41fd-424a-9276-8fda415f864d), [c5d86381](c5d86381-0609-4b7f-8296-09dec84bb5e8), [0f2d8107](0f2d8107-991d-4907-9c4d-2d4bdedf1b20)
- Primary source: local Cursor agent transcript / skill text (not independently re-verified via public URL)
