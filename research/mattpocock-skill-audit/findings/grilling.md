# Tier 2 Finding: grilling

**Snapshot:** Productivity; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/grilling/SKILL.md)
- **Docs:** [grilling.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/grilling.md)

## Verified purpose

`grilling` interviews the user about a plan, decision, or idea until the design tree has no unresolved frontier. The catalog is accurate, but the actual contract is more specific: ask all prerequisite-independent questions in a round, provide recommendations, wait for answers, and do not act until the user confirms shared understanding.

## Core mechanism

Maintain a design tree and recompute its frontier after each user answer. Facts are gathered by the agent or a sub-agent; decisions remain with the user. The fixed question format and explicit confirmation gate make the interview inspectable rather than an open-ended clarification loop.

## What it does better than the local equivalent

There is no direct local interview skill. The source says, “Ask the whole frontier in one round,” while deferring dependent questions to later rounds ([SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/grilling/SKILL.md)). That gives pre-plan alignment a stronger structure than starting directly with a drafted plan, and its facts-versus-decisions split prevents asking the owner for repository facts the agent can inspect ([grilling.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/grilling.md)).

## What cursorEscape does better

cursorEscape already has an explicit plan artifact, a plan-review gate, and isolated `plan_reviewer` children. Those contracts define inputs, outputs, must-not boundaries, and re-review behavior ([skills/_index.md](../../../skills/_index.md), [agents/_index.md](../../../agents/_index.md), [clean-context-isolation.md](../../../docs/featureArchitecture/clean-context-isolation.md)). Upstream grilling has no equivalent review-agent contract, and a model-invoked interview can add latency or silently decide to act if its confirmation gate is not reinforced.

## Host dependency

The mechanism is portable and user-facing. Upstream invocation metadata and the `Skill` tool are harness-specific, and sub-agent dispatch requires a host mapping, but the tree, frontier, round, and confirmation concepts do not require Claude Code or a tracker.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 4 | Interview contract is portable; invocation and child dispatch need overlays. |
| Thin-harness | 5 | A short skill can point to a companion procedure. |
| Gate-able | 4 | Frontier-empty plus owner-confirmation is a useful pre-plan gate. |
| Isolated-reviewable | 3 | Human interview is not a reviewer child; fact research can be isolated. |

## Adaptation proposal

**Draft verdict: Adapt.** Rebuild the primitive as an optional pre-plan alignment skill, not as a replacement for `implementation-plan` or `plan_reviewer`. Define portable round/frontier/facts/decisions/confirmation rules in a companion, require the parent to provide repository context, and map child fact-finding to the existing clean-context contract. Do not copy upstream emoji formatting or host invocation metadata as required behavior.

**Proposed roadmap phase:** Add `skills/grilling/` and a companion workflow for the interview primitive; touch the skills/workflow indexes and plan-entry guidance only after owner acceptance and the normal plan/review gates.

## Cost + risk

Medium authoring cost and medium behavioral-validation burden. Main risks are duplicate questioning before plans, excessive rounds, and accidental action without confirmation. It must remain optional so trivial work and already-settled plans do not pay the cost.

## Verdict

**Adapt (draft; owner discussion required).** The frontier-based human alignment loop fills a local pre-plan gap, but must be bounded and subordinate to the existing plan gate.
