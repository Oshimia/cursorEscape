# Core Vocabulary and Principles

Use these terms to describe design decisions. They are scale-agnostic: a
function, class, package, or cross-tier slice can be a module.

## Vocabulary

- **Module:** anything with an interface and an implementation.
- **Interface:** everything a caller must know to use a module correctly. It
  includes observable behavior and constraints, not only a type signature:
  invariants, ordering, errors, configuration, resource limits, and relevant
  performance characteristics.
- **Implementation:** the code and hidden decisions behind a module's
  interface. This is distinct from adapter, which names a role at a seam.
- **Depth:** the amount of useful behavior available per unit of interface a
  caller must learn. A deep module hides substantial complexity behind a
  small, understandable interface; a shallow module exposes nearly as much
  complexity as it contains.
- **Seam:** the location where behavior can be changed without editing the
  caller at that location, and where a module's interface is placed. Choosing
  a seam is separate from choosing what implementation sits behind it.
- **Adapter:** a concrete implementation that satisfies an interface at a
  seam. The word describes the role, not whether the implementation is large,
  small, real, or fake.
- **Leverage:** the value callers receive from depth: capability per unit of
  interface they learn. One implementation can repay its interface across
  many callers and tests.
- **Locality:** the value maintainers receive from depth: change, bugs,
  knowledge, and verification concentrate in one place.

## Principles

- Depth is a property of the interface, not a line-count ratio. Internal
  composition and private test seams do not make those details part of the
  external interface.
- Apply the **deletion test**: imagine deleting the module. If complexity
  disappears, it may be earning its keep; if the same complexity reappears
  across callers, it may have been a pass-through.
- Treat the **interface as the test surface**. Callers and tests cross the
  same seam and assert observable outcomes. Tests that must reach past it are
  evidence that the shape may be wrong.
- A **two-adapter seam test** asks whether at least two justified adapters
  exist, commonly a production adapter and an in-memory or other test adapter.
  One adapter alone usually describes a hypothetical seam and may only add
  indirection. This is a judgment tool, not a mandatory architecture rule.

## Judgment examples

- A `calculateDiscount(cart)` module can be deep when it hides policy and
  returns a value. A public surface that exposes every policy rule is shallow.
- A payment interface should document authorization behavior, ordering,
  retry/error modes, and idempotency, not just `charge(amount)`.
- An HTTP adapter and an in-memory adapter may justify a seam around owned
  remote behavior. A wrapper with only one unchanged implementation usually
  does not pass the deletion test.
