> **Imported research** — Source: openBuggy `docs/featureArchitecture/cursor-bugbot-agent-review/failure-modes-and-retries.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Failure Modes and Retries

**Last updated:** 2026-08-04  
**Status:** Observed reference (Cursor Agent Review)

## Context

Agent Review is useful only if parents know how to recover from empty diffs, bad invocations, and noisy re-reviews. This doc captures skill-defined retries and Observed failure classes.

## Substance

### Skill retry policy (**Observed** — `review-bugbot`)

| Failure class                                              | Parent action                                                                            |
| ---------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| Incorrect invocation (missing path/Diff, wrong shape/type) | Correct and **retry once** immediately                                                   |
| Could not compute diff / empty diff metadata               | **Retry once** with `Diff: natural language` + `Change Description` (omit `Base Branch`) |
| Any other subagent failure                                 | Retry **once** with the same prompt shape                                                |
| Same failure after retry                                   | **Stop**; tell user review could not complete with short error — do not keep retrying    |

### Empty / no-diff outcome (**Observed** — skill)

If BugBot reports no diff / empty diff: parent tells the user in one sentence there was nothing to review. This is distinct from a successful clean review (`<answer></answer>`).

### Clean vs incomplete (**Observed**)

| Signal                      | Meaning                                                            |
| --------------------------- | ------------------------------------------------------------------ |
| `<answer></answer>`         | Successful run; no bugs reported                                   |
| Findings XML                | Successful run; bugs to fix                                        |
| Subagent error / no XML     | Failed run — apply retry policy                                    |
| Parent summarizer confusion | **Inferred** risk if parents expect Reviewer-a Verdict from BugBot |

### Flip-flop / instability after fixes (**Inferred** + research)

- **Observed:** Re-reviews often go clean after targeted fixes (catalog iter-2 cleans).
- **Research/community:** Reports of reviewers flip-flopping after fixes (see [community-benchmarks-and-opinions.md](../../research/community-benchmarks-and-opinions.md)).
- Mitigation used in practice: tighter Custom Instructions (“focus on X; ignore Y”), fresh single-shot launch, Fast CI before each iteration.

### Scope mistakes (**Observed** risk)

Dirty trees with unrelated changes cause false attention unless Custom Instructions or NL `Change Description` constrain the map. Parents in EZPZ threads routinely list ignore lists for other phases’ files.

### Diff truncation / oversized changesets (**Unknown** mechanism)

Behavior under huge branch diffs is not clearly logged. Symptoms to watch for when implementing openBuggy: missing files in context, shallow reviews, timeouts.

## Implications / open questions

1. openBuggy CLI should expose explicit exit codes for engine error vs findings vs clean (already proposed in findings schema).
2. Document NL fallback as a first-class operator path, not an embarrassment path.

## Sources

- Skill: `~/.cursor/skills-cursor/review-bugbot/SKILL.md`
- Clean re-reviews: [fd935f45](fd935f45-e043-446c-8751-4fa3c4c04465), [cb6112e5](cb6112e5-6900-4695-8d97-1a3cfa372aab), [0f9826dd](0f9826dd-d110-4c9c-ad1f-fb31179481a8)
- Research: [community-benchmarks-and-opinions.md](../../research/community-benchmarks-and-opinions.md)
- Primary source: local Cursor agent transcript / skill text (not independently re-verified via public URL)
