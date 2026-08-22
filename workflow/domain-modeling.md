# Domain modeling (advisory)

Opt-in discipline for shared project language. Companion skill: [domain-modeling](../skills/domain-modeling/SKILL.md). Vocabulary note: **module**, **interface**, and **seam** keep their [codebase-design](../skills/codebase-design/CORE.md) meanings. Resolution routing follows the [documented alignment](grilling.md#documented-alignment) policy: existing suitable documents win via discovery; unresolved work stays in the active plan or research artifact; durable document creation requires explicit owner approval through normal gates. This page does not restate that policy.

## Challenge terms

For each contested term, write one precise canonical definition: what it means here, what it explicitly does not mean, and one sentence on why the boundary sits where it sits. One concept gets one term; two names for one concept or one name for two concepts are both defects.

## Avoided synonyms

Record the names deliberately NOT used, each with a short reason (collides with another local meaning, implies wrong mechanics, reserved by a dependency). An avoided-synonym entry prevents quiet reintroduction; it is guidance, not enforcement.

## Scenario pressure-tests

Stress each candidate definition with concrete scenarios, especially edge cases: does the definition still hold when the object is empty, concurrent, partially failed, or at scale? A definition that survives its scenarios is ready for cross-checking; one that needs exceptions appended every time is not yet canonical.

## Cross-check against code

Before canonizing, verify stated behavior against actual code paths: where the concept lives, what reads and writes it, whether documented constraints hold today. A term that describes aspirational behavior gets marked as such until the code matches.

## The three-part decision test

A resolved term or boundary becomes an ADR-style durable record only when ALL three hold: the decision is difficult to reverse, surprising without explanation, and the result of a real trade-off. Anything less stays in the glossary, plan, or conversation. This mirrors and defers to the documented-alignment policy above.

## Staleness

Glossary entries describe living systems and can rot. When a definition surfaces in later work, spot-check it against current code before relying on it; stale entries get corrected or retired rather than quietly obeyed.

## Related

- [Domain modeling skill](../skills/domain-modeling/SKILL.md)
- [Documented alignment](grilling.md#documented-alignment)
- [Codebase-design vocabulary](../skills/codebase-design/CORE.md)
- [Workflow docs index](_index.md)
