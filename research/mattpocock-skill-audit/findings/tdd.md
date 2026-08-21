# Tier 2 Finding: tdd

**Snapshot:** Engineering; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/tdd/SKILL.md)
- **Docs:** [tdd.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/tdd.md)
- **Companions:** [tests.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/tdd/tests.md), [mocking.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/tdd/mocking.md)

## Verified purpose

`tdd` is a reference discipline for behavior-first red-green vertical slices, public seams, independent expected values, and boundary-only mocks. The catalog's “red-green-refactor” wording diverges from the pinned body: refactoring was intentionally moved to code review, although the trigger still mentions the older phrase.

## Core mechanism

Agree public seams before any test, write one failing test, implement only enough to pass, and repeat one vertical slice at a time. Reject implementation-coupled, tautological, horizontal-sliced tests, and mocks around local modules. The source explicitly delegates interface-shape vocabulary to `codebase-design` and the larger build to `implement`.

## What it does better than the local equivalent

cursorEscape's implementation-review contract references tests but has no indexed, reusable TDD discipline. Upstream's rule “Test only at pre-agreed seams” and its independent-source assertion requirement prevent tests from merely encoding implementation ([SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/tdd/SKILL.md)). Its vertical-slice and boundary-mocking guidance is a concrete addition to the local implementer role.

## What cursorEscape does better

Local workflow already separates plan approval, implementation, dual review, and Full CI closeout. That is stronger than a standalone methodology for proving the overall change is ready, and local clean-context isolation prevents a test reviewer from inheriting an implementer's assumptions ([clean-context-isolation.md](../../../docs/featureArchitecture/clean-context-isolation.md)). Upstream's seam confirmation is human-facing but does not define how to handle no independent oracle, browser-test cost, or repository-specific CI.

## Host dependency

The testing principles are portable. Test runners, browser tools, mocking libraries, and Skill tool invocation are environment-dependent. No Claude-only mechanism is intrinsic.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 5 | Principles apply independently of runner. |
| Thin-harness | 5 | A short reference skill can point to test/mocking companions. |
| Gate-able | 4 | Seam confirmation and red-first are observable, though model adherence is imperfect. |
| Isolated-reviewable | 4 | Review can verify seam and test-quality rules in a child pass. |

## Adaptation proposal

**Draft verdict: Adopt.** Add a portable TDD reference skill and companions for test quality and mocking, integrate it as optional guidance in `agents/implementer`, and keep refactoring in implementation-review as local architecture does. Add a local rule for when tests are not appropriate and require explicit seam/oracle notes in plans.

**Proposed roadmap phase:** Add `skills/tdd/` with `workflow/tdd-tests.md` and `workflow/tdd-mocking.md`, then extend implementer/review indexes after owner acceptance and normal gates.

## Cost + risk

Medium cost and medium review burden. Risks are dogmatic tests for glue code, excessive human seam pauses, duplicate codebase-design vocabulary, and triggering the obsolete refactor promise. Keep it advisory where no independent oracle exists.

## Verdict

**Adopt (draft; owner discussion required).** The test-quality reference fills a real local gap and can remain host-neutral.
