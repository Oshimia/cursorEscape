# implementer

**Last updated:** 2026-08-19

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

### Incomplete until (phase closeout)

The phase is **incomplete** — must **not** claim phase complete, start the next phase, or hand Composer “done” as shippable — **until**:

1. Observed Fast CI when Fast ≠ `n/a` (do not launch reviewers on fail / skipped / claimed-only), **then**
2. Dual `APPROVED` (`production_readiness_reviewer` + `bug_reviewer`) per [implementation-review](../skills/implementation-review.md), **then**
3. Full CI closeout when Full ≠ `n/a`; when Full = `n/a`, dual APPROVED + explicit user ack (or Composer handoff — return closeout only, no commit)

Does **not** change the dual-review APPROVED bar — wording-only gate on phase closeout.

### Must not

- Expand scope without plan update
- Launch reviewers before Fast CI Observed (when Fast ≠ `n/a`)
- Pair Full CI with reviewer launch
- Claim phase complete / start next phase before Incomplete until predicate is met
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
