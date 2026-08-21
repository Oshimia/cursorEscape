# Tier 1 Finding: code-review

**Snapshot:** Engineering; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/code-review/SKILL.md)
- **Docs:** [code-review.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/code-review.md)

## Verified purpose

`code-review` reviews a non-empty three-dot diff from a user-supplied fixed point on two deliberately separate axes: Standards and Spec. Each axis runs in a parallel sub-agent and the report preserves the two reports rather than producing one blended rank. The catalog description is accurate, but the source also requires ref/spec discovery and a fixed Fowler smell baseline.

## Core mechanism

Resolve the fixed point, capture `git diff <fixed-point>...HEAD` and commit list, locate the originating spec and standards, then run Standards and Spec sub-agents in parallel. Standards checks repository rules plus twelve labelled Fowler smell heuristics; Spec checks missing, extra, and incorrectly implemented requirements. Aggregate under separate headings with a worst issue per axis.

## What it does better than the local equivalent

It gives “built right” and “right thing” distinct evidence paths and explicitly refuses to let one pass hide the other ([code-review.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/code-review.md)). The fixed-point/non-empty-diff preflight and requirement that every finding cite a standard, smell+hunk, or spec line make the output more auditable than an undifferentiated review. The portable idea is complementary to the local dual gate, not a replacement.

## What cursorEscape does better

cursorEscape already separates production-readiness and bug review as a mandatory dual gate, with explicit blocking lists and clean-context isolation ([agents/_index.md](../../../agents/_index.md), [clean-context-isolation.md](../../../docs/featureArchitecture/clean-context-isolation.md)). Its parent-only Fast CI gate, pressure-release cap, and Full CI closeout are stronger operational contracts than the upstream skill's aggregation step ([implementation-review/SKILL.md](../../../skills/implementation-review/SKILL.md)). The upstream docs also disclose a serious recursive-delegation bug: sub-agents can invoke `/code-review` and fan out to dozens of agents ([code-review.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/code-review.md)).

## Host dependency

The diff/spec concepts are portable, but upstream lookup assumes its `docs/agents/issue-tracker.md` and its sub-agent tool vocabulary. It is not inherently Claude-only, yet the shipped recursive-delegation risk and unspecified task API make direct copying unsafe. Local review roles and host overlays already solve invocation routing.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 4 | Fixed-point Git and two evidence axes are portable; issue lookup and task spawning need local mapping. |
| Thin-harness | 3 | The axis procedure is useful, but must sit behind local review contracts rather than add another default harness. |
| Gate-able | 5 | Preflight and finding citation rules are concrete; local CI/dual verdicts can own completion. |
| Isolated-reviewable | 4 | Parallel axis isolation is good, but recursive invocation must be explicitly prohibited. |

## Adaptation proposal

**Draft verdict: Adapt.** Do not add a second default review gate. Extend the local production-readiness/bug-review procedure with an optional Standards-vs-Spec evidence frame when a fixed point and originating spec exist. Map Standards to repository docs plus explicitly labelled smells, map Spec to the supplied plan/spec, and preserve independent child sessions. Add a hard child instruction not to invoke the review skill or spawn further reviewers. Local Fast CI, blocking-list verdicts, cap, and Full CI remain authoritative; when no spec exists, report that rather than infer requirements.

**Proposed roadmap phase:** Extend `skills/implementation-review/` and the two reviewer contracts with an optional two-axis report mode, fixed-point preflight, citation requirements, and recursion guard; add focused workflow documentation without changing the default dual-gate count.

## Cost + risk

Medium authoring and high review burden because this touches the central review contract. Main risks are duplicate findings across the existing two reviewers, scope confusion between Standards and production readiness, and reviewer fan-out. Keep it opt-in and define precedence/aggregation before implementation.

## Verdict

**Adapt (draft; owner discussion required).** The evidence separation is valuable, but wholesale adoption would duplicate and weaken the existing dual-gate lifecycle.
