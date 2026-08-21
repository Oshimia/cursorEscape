# Tier 2 Finding: diagnosing-bugs

**Snapshot:** Engineering; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/diagnosing-bugs/SKILL.md)
- **Docs:** [diagnosing-bugs.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/diagnosing-bugs.md)

## Verified purpose

This skill diagnoses hard bugs and performance regressions through six gated phases: build a red-capable feedback loop, reproduce/minimise, rank falsifiable hypotheses, instrument, fix with a regression test, and clean up. The catalog is accurate, with the important verified emphasis that no hypothesis phase opens before one named command has already gone red on the exact symptom.

## Core mechanism

Treat the feedback loop as the product. Prefer a failing test, then HTTP/CLI/browser replay, captured trace, minimal harness, fuzz, bisection, differential, and finally a human-in-the-loop script. Require 3-5 ranked predictions before probes, tag debug logs, redact captured output, and document when no correct regression-test seam exists.

## What it does better than the local equivalent

The local `bug_reviewer` is part of the mandatory always-on dual review loop after every non-insignificant code change. Its purpose is to find newly introduced correctness, security, concurrency, and test-gap defects in the current diff; it is not a runtime diagnosis workflow. `diagnosing-bugs` addresses a different gap: finding and resolving bugs in already accepted or shipped code. Upstream's “No red-capable command, no Phase 2” gate and explicit minimisation criteria prevent code-reading speculation ([SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/diagnosing-bugs/SKILL.md)). Its hypothesis predictions, one-variable probes, tagged cleanup, and correct-seam escape hatch form a complete operational loop absent from the local index.

## What cursorEscape does better

cursorEscape has a stronger mandatory change-review loop: `bug_reviewer` runs in parallel with production-readiness review after Fast CI for every non-insignificant change, and its bug-finder leg remains focused on defects introduced by that changeset ([clean-context-isolation.md](../../../docs/featureArchitecture/clean-context-isolation.md), [agents/_index.md](../../../agents/_index.md), and the sibling openBuggy loop design at `C:\Users\admin\source\repos\general-projects\openBuggy\docs\featureArchitecture\cursor-bugbot-agent-review\orchestration-and-review-loops.md`). That loop must not absorb the full diagnosis process. Instead, selected diagnosis improvements such as evidence-first reproduction, minimisation, falsifiable hypotheses, and redaction can strengthen the bug-finder leg where they improve changed-code review without turning it into a runtime investigation. Upstream is model-invoked and can over-fire on simple questions; its docs also disclose unimplemented redaction and no checkpoint before applying a fix. Those concerns require local invocation thresholds, secret handling, and the normal implementation/review gates.

## Host dependency

The diagnosis method is portable across tests, HTTP, CLI, browser, and replay tools. The shipped Bash HITL template and tool-specific repros are host-dependent. Runtime access, network, and temporary instrumentation require explicit local permissions.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 4 | Ladder is tool-neutral, with Bash as one fallback. |
| Thin-harness | 4 | The phases belong in a companion, not always-on text. |
| Gate-able | 5 | Every transition has a concrete evidence gate. |
| Isolated-reviewable | 4 | Diagnosis can be a read/write phase followed by isolated review; secrets need care. |

## Adaptation proposal

**Draft verdict: Adopt.** Rebuild the diagnostic loop as a user-invoked skill specifically for already accepted or shipped-code bugs and runtime/performance regressions. Retain the red-capable-loop gate, minimisation, falsifiable hypotheses, tagged instrumentation, regression test, and cleanup. Replace Bash-only HITL assumptions with portable repro choices, make redaction mandatory before output leaves the parent, and route any code changes through `implementer` plus the mandatory dual review rather than self-closing. Separately evaluate the evidence-first and minimisation techniques for narrowly scoped improvements to `bug_reviewer`; do not merge the two purposes or make the always-on review loop perform full diagnosis.

**Proposed roadmap phase:** Add `skills/diagnosing-bugs/` with a companion workflow and optional diagnostic-agent role; touch the bug-review/implementation handoff indexes after owner acceptance and the normal gates.

## Cost + risk

Medium-high cost and high safety/review burden. Risks include secrets in logs/HARs, destructive instrumentation, model over-triggering, long repro loops, and overlap with `bug_reviewer`. Keep diagnosis runtime-focused and leave diff findings to the existing reviewer.

## Verdict

**Adopt (owner accepted; discussion amended).** This is a distinct, user-invoked, evidence-first capability for bugs in already accepted or shipped code. Its evidence-first techniques may also inform a separate, narrowly scoped improvement to the always-on `bug_reviewer` leg without changing that leg's purpose.
