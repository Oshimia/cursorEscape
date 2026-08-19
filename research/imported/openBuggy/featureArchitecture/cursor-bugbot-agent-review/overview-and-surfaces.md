> **Imported research** — Source: openBuggy `docs/featureArchitecture/cursor-bugbot-agent-review/overview-and-surfaces.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Overview and Surfaces

**Last updated:** 2026-08-04  
**Status:** Observed reference (Cursor Agent Review)

## Context

Cursor exposes more than one “Bugbot” surface. openBuggy’s replication target for agent loops is **local Agent Review**, not the hosted PR product. This doc separates those surfaces and states what this suite does and does not claim.

## Substance

### Two related products (**Observed** via research + local transcripts)

| Surface                       | What it is                                                                                                                              | Evidence in this archive                                                                                                            |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| **PR Bugbot**                 | SCM-connected PR/MR reviewer: inline comments, checks, optional `.cursor/BUGBOT.md`, effort levels, autofix via Cloud Agents, dashboard | Documented in [bugbot-product-and-api-limits.md](../../research/bugbot-product-and-api-limits.md) — **not** the focus of this suite |
| **Local Agent Review BugBot** | In-IDE / agent subagent (`subagent_type: bugbot`), often launched via `/review-bugbot` or parent Task from an iterative review skill    | **This suite** — fingerprinted subagent transcripts under the easyPeasyWebsite agent-transcripts corpus                             |

They complement each other; they are not the same deployment surface. (**Observed** community framing also appears in research Sources.)

### What local Agent Review is (**Observed**)

- A **single-shot** Cursor subagent (no `resume`; parents always launch fresh).
- Accepts a small **parent envelope** (`Full Repository Path`, `Diff`, optional fields) which the Cursor harness **expands** into a long mission prompt plus either a unified `<diff>` or a natural-language change map.
- Explores the repo with read-only tools and returns **strict XML** findings (or an empty answer = clean).
- Does **not** mutate the working tree and does **not** run the parent’s CI gate.

### Role in dual-gate loops (**Observed** in EZPZ practice)

In sibling easyPeasyWebsite iterative review practice (and the repo-agnostic `implementation-review` skill):

| Leg            | Responsibility                                                                                                                  |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **Reviewer-a** | Production-readiness: completeness, architecture/docs alignment, test gaps, process; emits Verdict APPROVED / CHANGES REQUESTED |
| **BugBot**     | Production bugs/security/logic introduced by the change set; emits XML `<bug>` list or empty answer                             |

Parents treat **both** as must-fix for the review loop. BugBot is the sharper runtime/security catcher; Reviewer-a catches ship-set / docs / process issues BugBot often ignores.

### Non-goals for this suite

- Reverse-engineering proprietary model weights or unlogged server-side critics
- Documenting PR Bugbot dashboard/autofix internals beyond research links
- Claiming openBuggy already implements BugBot parity
- Shipping Cursor skill files into this repository

### Corpus bias (**Observed**)

Almost all fingerprinted runs come from **easyPeasyWebsite** review-loop parents with `Custom Instructions` mentioning phases, Fast CI, and scope boundaries. Behavior under bare `/review-bugbot` without Custom Instructions is less sampled but uses the same mission skeleton.

## Implications / open questions

1. openBuggy should document and prioritize **Agent Review–style local loops**, not PR-bot feature parity.
2. Dual-gate design in [ide-and-agent-integration.md](../ide-and-agent-integration.md) is the correct consumer shape for this characterization.

## Sources

- [bugbot-product-and-api-limits.md](../../research/bugbot-product-and-api-limits.md)
- Parent/subagent examples in [run-catalog.md](./run-catalog.md)
- Skill: `~/.cursor/skills-cursor/review-bugbot/SKILL.md`
- Skill: `~/.cursor/skills/implementation-review/SKILL.md`
- Rule (EZPZ): `.cursor/rules/iterative-code-review.mdc` (external sibling project)
- Primary source: local Cursor agent transcript / skill text (not independently re-verified via public URL)
