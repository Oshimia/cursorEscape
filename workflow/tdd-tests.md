# TDD test quality (advisory)

Guidance for callers who write tests test-first. Vocabulary note: **seam**,
**interface**, and **test surface** keep their
[codebase-design](../skills/codebase-design/CORE.md) meanings; this page uses
those terms and does not redefine them. Nothing here is a mandatory gate;
callers choose what applies to the change at hand.

## Agree the seams first

Before writing any test, name the public seams under test and confirm them
with the owner of the change. Testing effort then lands on critical paths and
complex logic instead of spreading across every edge case. Tests cross the
same seam callers do and assert observable outcomes; a test that must reach
past the interface is evidence the shape may be wrong. When the interface
itself is in question, consult codebase-design rather than inventing local
terms.

## One behavior at a time

Work in vertical slices: one behavior, one failing test, then just enough
implementation to pass it. Do not write every test up front, then all of the
implementation. Bulk tests verify imagined behavior: they pin the shape of
things before the implementation has taught you anything, and they go
insensitive to real changes. Each slice responds to what the previous slice
revealed.

## Independent expected values

An assertion is worth keeping only if its expected value comes from an
independent source: a worked literal, a spec example, a known-good result.
If the test recomputes the expectation the way the code does, it passes by
construction and can never disagree with the code.

```text
# tautological: expectation restates the mechanism
expected = sum of item prices, computed in the test
expect total(items) = expected

# independent oracle: a worked literal from the spec
expect total(two items priced 10 and 5) = 15
```

## Reject these patterns

- **Implementation-coupled:** mocks internal collaborators, calls private
  members, or verifies through a side channel instead of the interface. The
  tell: the test breaks under refactoring while behavior is unchanged.
- **Tautological:** the expected value is derived the same way the code
  derives it, so the assertion cannot fail for the right reason.
- **Horizontal slice:** all tests written before any implementation. Prefer
  vertical slices that trace one behavior end to end.

```text
# coupled to internals
checkout called the payment gateway exactly once with total 15

# reads as a capability at the seam
a valid cart checks out and the result is confirmed
```

## When no independent oracle exists

Glue code, browser automation, and thin integration cases often have no
useful independent oracle; forcing one produces tautology. In those cases an
alternative may serve better: an end-to-end integration check, a smoke test,
a contract test against a documented agreement, a reviewed snapshot, or manual
evidence attached to the change. Which alternative applies is chosen by
judgment per case; none is mandatory, and skipping automated tests entirely
is allowed where nothing observable is worth asserting.

## Refactoring stays out of the loop

Improving structure after green belongs to local review work
([iterative-code-review.md](iterative-code-review.md)), not to the
test-first slice. A failing test never gates a refactor.

## Related

- [tdd-mocking.md](tdd-mocking.md)
- [codebase-design](../skills/codebase-design/SKILL.md)
- [tdd](../skills/tdd/SKILL.md)
- [_index.md](_index.md)
