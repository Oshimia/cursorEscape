# Deepening Guidance

Use this page to classify dependencies before considering whether several
shallow modules could become one deeper module. It is advisory reasoning, not
an enforcement rule or a refactoring instruction.

## Dependency categories

1. **In-process:** pure computation or in-memory state with no I/O. These are
   often straightforward to combine and test through the resulting interface.
2. **Locally substitutable:** dependencies with a credible local stand-in,
   such as an in-memory filesystem or test database. A private seam can use
   that stand-in without exposing it through the external interface.
3. **Remote but owned:** services controlled by the same organization. A port
   can hold the interface at the seam, with transport-specific and in-memory
   adapters behind it.
4. **True external:** third-party services. Inject an interface that captures
   the behavior the module needs and use a mock or other test adapter where
   appropriate.

## What to consider

For each category, ask whether the proposed interface gets smaller while
preserving the behavior callers need. Prefer designs that increase leverage
without making interface constraints harder to understand. Prefer locality
when a change, bug, or verification concern can be kept in one module.

Keep internal seams private when they are only implementation or test aids.
Do not expose them merely because a test uses them. Revisit the two-adapter
seam test before introducing a public port, and use the deletion test to
detect pass-through layers.

When deepening, replace tests of discarded shallow details with tests through
the resulting interface. Assert observable behavior and constraints so the
tests can survive internal refactoring; do not require this approach where a
caller-owned workflow has established that no independent oracle exists.
