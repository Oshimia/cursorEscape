# TDD mocking (advisory)

Guidance for callers deciding when a test double is appropriate. Vocabulary
note: **adapter** keeps its [codebase-design](../skills/codebase-design/CORE.md)
meaning, a concrete implementation satisfying an interface at a seam; this
page uses that term and does not redefine it. Nothing here is a mandatory
gate.

## Double only at boundaries

Doubles belong at system boundaries and around external dependencies:
remote services, databases, the clock and randomness, the file system, other
processes. Do not double modules you own. Internal collaborators are part of
the observable path a caller exercises; replacing them couples the test to
composition instead of behavior, and the test then breaks when wiring changes
even though behavior has not.

```text
# boundary double: reasonable
a fake payment gateway that approves every charge

# internal double: couples to composition
a spy on the owned pricing module asserting it was called
```

## Prefer fakes, stubs, adapters, in-memory implementations

Where appropriate, prefer a small hand-written fake, a canned stub, or an
in-memory adapter over an interaction-recording mock. These satisfy the same
interface at the seam and keep the assertion on outcomes. The codebase-design
two-adapter view applies: a production adapter plus an in-memory adapter is
often the sign of a justified seam.

```text
# outcome asserted through the interface
payment = in-memory gateway that always approves
result = checkout(cart, payment)
expect result.status = "confirmed"
```

## Preserve observable behavior at the seam

Whatever stands behind the seam must still let the test observe what callers
observe. Design dependencies to be replaceable: pass them in rather than
constructing them inside the unit, and prefer specific named operations over
one generic dispatcher, so each double returns one clear shape without
conditional setup logic.

## Avoid tautological mock assertions

An assertion that a mock was called with a value computed the same way the
code computes it passes by construction. Interaction assertions are useful
only when the interaction itself is the contract at the seam, for example
that an outbound email service was handed a message; otherwise assert on
returned values and state reachable through the interface.

## When a mock destroys the only oracle

Sometimes the observable outcome depends entirely on the real dependency's
effect: a persistence round-trip proven by reading back through the
interface, a cache invalidation proven by a subsequent fetch. Replacing the
dependency there removes the only thing worth verifying, leaving a test that
asserts the mock recorded itself. In such cases use the real dependency
against a test instance, an in-memory equivalent with verified parity, or
move up to integration, smoke, or contract evidence per
[tdd-tests.md](tdd-tests.md).

## Related

- [tdd-tests.md](tdd-tests.md)
- [codebase-design](../skills/codebase-design/SKILL.md)
- [tdd](../skills/tdd/SKILL.md)
- [_index.md](_index.md)
