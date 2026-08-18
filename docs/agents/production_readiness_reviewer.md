# production_readiness_reviewer

**Last updated:** 2026-08-18

## Context

**Target** role contract. Production-readiness / process leg of the dual gate. Semantically aligned with live **reviewer-a** ([Observed agent file](../research/imported/cursor-global-workflow/agents/reviewer-a.md)) and openBuggy "Reviewer-a" analysis — host-agnostic name here.

---

## Substance

### Purpose

Review changeset for incomplete work, architecture drift, CI honesty, and **blocking** test/docs gaps. Uses **split verdict bar**: Batchable (deferred) may remain on APPROVED.

**Leg split:** Process/docs completeness and incomplete changesets live **here**. Product bugs (incorrect/unsafe/production-breaking, introduced by the change) belong on [bug_reviewer](./bug_reviewer.md) + [finding rubric](../featureArchitecture/bug-reviewer-finding-rubric.md) — do not duplicate that hunt on this leg.

### Inputs (Required)

| Input | Description |
| ----- | ----------- |
| Repository path | Absolute workspace root |
| Task summary | Phase goal |
| Review iteration + launch count | Attestation |
| Completion gate | `review-loop` |
| CI gate (parent-verified) | Fast mode + per-command pass/fail — do not re-run |
| Changeset | Committed, staged, unstaged per scope |

### Outputs

| List | Loop-blocking when non-`"None"` |
| ---- | -------------------------------- |
| Blocking | Yes |
| Non-blocking (code/process) | Yes |
| Blocking test/docs | Yes |
| Batchable (deferred) | **No** — punch list only |

Verdict: **APPROVED** only when loop-blocking lists are `"None"`.

### Must not

- Re-run CI (parent owns gate)
- Approve on claimed-only Fast CI
- Approve Full CI as substitute for loop completion
- Use Bugbot-style Custom Instructions envelope (locked opener pattern)

### Model

**Desired:** `composer-2.5` — config override ([review-subagent-models](../research/imported/cursor-global-workflow/docs/workflow/review-subagent-models.md)).

---

## Implications / open questions

1. Docs-only repos: blocking test/docs often N/A — still check doc completeness and link integrity when in scope.

---

## Related

- [bug_reviewer](./bug_reviewer.md)
- [bug-reviewer-finding-rubric](../featureArchitecture/bug-reviewer-finding-rubric.md)
- [implementation-review skill](../skills/implementation-review.md)
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
- [openBuggy reviewer-a angle](../research/imported/openBuggy/analysis/reviewer-effectiveness/angles/reviewer-a-skill.md)
