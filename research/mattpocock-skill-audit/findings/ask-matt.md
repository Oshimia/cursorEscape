# Tier 2 Finding: ask-matt

**Snapshot:** Engineering; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/ask-matt/SKILL.md)
- **Docs:** [ask-matt.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/ask-matt.md)
- **Companion:** [PHASE-BOUNDARIES.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/ask-matt/PHASE-BOUNDARIES.md)

## Verified purpose

`ask-matt` is a user-invoked, hand-written router that recommends a skill or sequence based on the user's situation, then stops. The catalog is accurate, but the source explicitly says it routes only the upstream promoted set and does not scan installed or local skills.

## Core mechanism

Maintain a narrative decision tree over main flow, on-ramps, vocabulary skills, standalones, and phase-boundary context choices. Return the next command and relevant human decision; do not execute it. The router is a secondary source and its own docs warn that it can lag or disagree with actual skills.

## What it does better than the local equivalent

cursorEscape's `skills/_index.md` is a static inventory, not a user-facing situation router. Upstream gives conditional routing, including when to grill, implement, diagnose, handoff, clear, or compact, and says “It recommends and stops” ([SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/ask-matt/SKILL.md)). That could improve discoverability for a growing local skill set.

## What cursorEscape does better

The local repo has stronger canonical layering and explicit always-on defaults, while upstream's hand-maintained map is vulnerable to stale names and false claims ([skills/_index.md](../../../skills/_index.md), [instruction-layering.md](../../../docs/featureArchitecture/instruction-layering.md)). A local router that is not generated or checked would become another contract needing synchronized updates whenever skills, agents, or workflow gates change.

## Host dependency

The decision tree is portable, but invocation is user-facing host syntax. It is not inherently Claude-only, though upstream slash commands and `Skill` references are.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 4 | Routing concepts are portable; command names vary. |
| Thin-harness | 3 | Router body is necessarily a maintained map, not a thin pointer. |
| Gate-able | 2 | Correctness depends on synchronized prose. |
| Isolated-reviewable | 2 | It routes work rather than producing an isolated artifact. |

## Adaptation proposal

**Draft verdict: Reference-only.** Use the phase-boundary decision concepts as an input to future local discoverability work, but do not copy a static router. Reconsider only if a generated/index-backed router can be kept accurate and host-neutral, with validation that every target exists and every gate claim points to its SoT.

**Trigger to reconsider:** recurring owner confusion over choosing among local skills that the static index cannot resolve.

## Cost + risk

Low initial cost, high ongoing upkeep risk. Staleness can route around mandatory plan/review gates, and a second narrative map duplicates `skills/_index.md`, workflow indexes, and always-on instructions.

## Verdict

**Reference-only (draft; owner discussion required).** The routing idea is useful, but a hand-maintained local copy would conflict with cursorEscape's single-SoT discipline.
