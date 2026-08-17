# implementer

**Last updated:** 2026-08-17

## Context

**Target** role contract. Executes approved plan scope — code, docs, or both. On multi-phase roadmaps, the phase subagent is typically the implementer **and** review-loop parent.

---

## Substance

### Purpose

Deliver the phase changeset; run discovery; invoke review loop at phase end per [implementation-review](../skills/implementation-review.md).

### Inputs (Required)

| Input | Description |
| ----- | ----------- |
| Approved plan / phase context | Scope, files, deliverables |
| Workspace root | Target repository path |
| Do-not-touch list | Explicit boundaries |
| CI mapping | Fast/Full commands or `n/a` |

### Outputs

| Output | Description |
| ------ | ----------- |
| Changeset | All files for the phase |
| Closeout report | After dual APPROVED + Full CI when Full ≠ `n/a`; when Full = `n/a`, after dual APPROVED only (user ack at Composer if conducting) |
| CI Observed block | Per-command rows for review loop |

### Must not

- Expand scope without plan update
- Launch reviewers before Fast CI Observed (when Fast ≠ `n/a`)
- Pair Full CI with reviewer launch
- Commit without Full CI pass when Full ≠ `n/a`
- When Full = `n/a` and **not** under Composer: commit only after dual APPROVED + explicit user acknowledgment
- **`git commit` or `git push` when Composer conducts the phase** — phase subagent returns closeout report only; Composer runs second Full CI when Full ≠ `n/a` (or user ack when Full = `n/a`) then local commit after QC ([composer](../skills/composer.md))

### Model

Operator preference — config override.

---

## Implications / open questions

1. **Cursor-specific:** Phase subagent under Composer — same contract, different spawn mechanism.

---

## Related

- [production_readiness_reviewer](./production_readiness_reviewer.md)
- [bug_reviewer](./bug_reviewer.md)
- [implementer phase parent duties](../featureArchitecture/intended-workflow.md)
