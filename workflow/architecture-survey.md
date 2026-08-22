# Architecture survey (advisory)

A guided, read-only process for deciding where architecture improvement is worth the cost. Companion skill: [architecture-survey](../skills/architecture-survey/SKILL.md). Vocabulary note: **module**, **interface**, **seam**, **depth**, **locality** keep their [codebase-design](../skills/codebase-design/CORE.md) meanings; apply its deletion test and two-adapter seam test rather than restating them.

## Scope selection

Agree the scope before exploring: either recent-change hotspots (git history shows where churn concentrates) or an owner-named area. Agree on and record the scope statement in-conversation so cards stay inside it. Record whether network or extra tooling is off-limits for this run.

## Exploration (read-only)

Explore using read-only discovery and isolated reads per [clean context and isolation](../docs/featureArchitecture/clean-context-isolation.md); repository_explorer may support repo-internal questions. Hunt shapes that usually signal improvement opportunity: shallow modules whose interface nearly matches their implementation, pass-through layers that fail the deletion test, duplicated knowledge, misplaced responsibility, seams with only one real adapter. Every observation needs evidence: name the files and what you saw.

## Candidate cards

One card per opportunity, each containing:

- **The issue, explained plainly:** what is wrong, why it matters, and the evidence (files, symptoms).
- **Option A, address it:** sketch the approach, expected benefit in depth/locality/maintainability terms, rough effort and risk.
- **Option B, leave as-is:** the honest costs of inaction: ongoing friction per change, bug or confusion risk, how the debt compounds.
- **Alternatives considered:** briefly, including hybrids.
- **Recommendation:** clearly labeled as a recommendation, with the reasoning; the owner decides.

Prefer approaches reusing patterns already established across the codebase over novel local idioms; weigh long-term maintainability above short-term cleverness. Cards are point-in-time observations and may go stale.

## Discussion checkpoint

Walk the owner through each card. Answer questions, revise cards, add removed context. The owner then selects zero or more candidates explicitly; silence or partial agreement is not selection. Unselected cards are kept as records, not mandates.

## Handoff

Selected candidates become inputs to [implementation-plan](../skills/implementation-plan/SKILL.md) through normal gates; the survey implements nothing and approves nothing. If durable records are wanted for a decision, route them through the [documented alignment](grilling.md#documented-alignment) policy.

## Related

- [Architecture survey skill](../skills/architecture-survey/SKILL.md)
- [Codebase-design vocabulary](../skills/codebase-design/CORE.md)
- [Implementation plan](../skills/implementation-plan/SKILL.md)
- [Documented alignment](grilling.md#documented-alignment)
- [Workflow docs index](_index.md)
