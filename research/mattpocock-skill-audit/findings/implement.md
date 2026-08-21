# Tier 2 Finding: implement

**Snapshot:** Engineering; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/implement/SKILL.md)
- **Docs:** [implement.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/implement.md)

## Verified purpose

`implement` builds a decided spec, ticket, or conversation plan, drives TDD at pre-agreed seams, typechecks and tests during the run, runs a final full suite and code review, then commits. The catalog is accurate, but the docs reveal a major limitation: the source review is run before commit against a diff shape that can be empty.

## Core mechanism

One invocation handles one vertical ticket: read the work, identify seams, run red-green slices, run targeted and full checks, review, and commit. It deliberately “never reopens the plan,” making the upstream decision/build boundary explicit.

## What it does better than the local equivalent

The local `implementer` role and implementation-review skill provide the same general stage, but upstream gives the operator a compact one-ticket rhythm and explicit refusal to redesign settled work ([implement.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/implement.md)). Its “one run covers one ticket” rule and repeated targeted checks are concrete context-hygiene guidance that local phase work can use.

## What cursorEscape does better

cursorEscape separates implementation from the dual production-readiness and bug-review loop, requires isolated reviewer children, caps pressure-release iterations, and runs Full CI only after dual approval ([agents/_index.md](../../../agents/_index.md), [clean-context-isolation.md](../../../docs/featureArchitecture/clean-context-isolation.md)). Upstream's mandatory commit conflicts with user control and its own docs identify the pre-commit review-diff bug. Local policy must also handle docs-only or no-suite repositories explicitly.

## Host dependency

The stage concept is portable, but upstream assumes slash skills, a test suite, a current branch, and a commit-capable harness. Tracker references and `/code-review` are ecosystem-specific; the commit behavior is not safe as a universal host contract.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 3 | Build loop is portable; invocation, tracker, and commit assumptions are not. |
| Thin-harness | 4 | Short trigger can delegate to existing implementer procedure. |
| Gate-able | 4 | Targeted checks and review stages are clear, but upstream ordering is flawed. |
| Isolated-reviewable | 2 | Its self-review is not the local isolated dual gate. |

## Adaptation proposal

**Draft verdict: Adapt.** Adopt the one-ticket, one-vertical-slice discipline as guidance for the existing `agents/implementer` and `skills/implementation-review`, but do not add a competing build loop. Remove mandatory commit, route review through the local dual gate, require Observed Fast CI before reviewers, and run Full CI only at closeout. Preserve the plan boundary while allowing local escalation and docs-only paths.

**Proposed roadmap phase:** Extend `agents/implementer.md` and the implementation workflow with one-ticket/context hygiene guidance; touch the related indexes and host echoes only after owner acceptance and the normal gates.

## Cost + risk

Low-medium authoring cost, high regression risk if a second loop is added. Main risks are duplicate gates, premature commits, reviewing an uncommitted diff incorrectly, and forcing test-suite assumptions onto repositories without one.

## Verdict

**Adapt (draft; owner discussion required).** Reuse the sizing and stage discipline, not the upstream implementation driver or commit policy.
