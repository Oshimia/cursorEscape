# Grilling interview (advisory)

Advisory procedure for a user-triggered design interview. It produces alignment, not artifacts. Companion skill: [grilling](../skills/grilling/SKILL.md).

## The design tree

Before asking anything, build an explicit design tree: a written list of topics, and under each topic the open questions whose answers would change the shape of the outcome. Topics come from what the owner asked about; questions are the specific unknowns beneath them. The tree is shared with the owner so the interview stays inspectable: at any moment both parties can see which questions exist and which remain open.

## Frontier recomputation

After each answer, recompute the unresolved frontier, meaning the set of questions still open. An answer can close its own question, open new ones, or make previously listed questions moot; update the tree and the frontier before anything else is asked. Nothing counts as settled merely because it was discussed once; only an answer recorded against the tree closes a frontier entry.

## Rounds

Ask in rounds. One round contains every question on the current frontier that is prerequisite-independent of the others, asked together so the owner can answer them in one sitting. Questions whose phrasing or relevance depends on pending answers are deferred to a later round, once the questions they depend on have closed. There is no numeric cap on rounds; rounds end when the frontier is empty or the owner ends the interview.

## Facts versus decisions

Facts and decisions have different owners. Repository facts (what code exists, how a pathway behaves, which conventions apply) are gathered by the agent, never asked of the owner. Gather them through read-only discovery per [repo documentation discovery](../workflow/discovery.md), or through an isolated child with a fully packed input message per [clean context and isolation](../docs/featureArchitecture/clean-context-isolation.md). Decisions (goals, trade-offs, naming, scope, acceptable risk) belong to the owner alone and are never resolved by research or inference.

## Recommendations

Recommendations are allowed and often useful, but they are always labeled as recommendations. A recommendation names a preferred option and says why; it does not close its question. Only the owner's answer closes a frontier entry.

## Confirmation gate

When the frontier becomes empty, summarize the shared understanding back to the owner and stop. Take no action, produce no artifacts, and start no downstream procedure until the owner confirms the summary. Confirmation is explicit: silence, partial agreement, or a new question reopening the frontier all mean the interview continues or pauses.

## Scope and bypass

Trivial work bypasses this loop entirely. If a request has no meaningful open questions, say so and skip the interview rather than manufacturing questions to justify rounds.

## Subordination

This loop is subordinate to the standard pipeline. Its output feeds a future plan; it never replaces implementation-plan drafting or plan review.

## Related

- [Grilling skill](../skills/grilling/SKILL.md)
- [Repo documentation discovery](discovery.md)
- [Workflow docs index](_index.md)
