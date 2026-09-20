# Clean Context and Isolation

**Last updated:** 2026-09-20

## Context

Review and plan gates require clean child context. A new persona in the same long conversation is not isolation. Parents synthesize task inputs; children verify from evidence, not accumulated reviewer reasoning.

This page owns the architecture of isolation. [`workflow/agent-invocation.md`](../../workflow/agent-invocation.md) owns the mandatory invocation envelope, and role contracts own their inputs and outputs.

---

## Substance

### Isolated work (Required)

| Work | Isolation |
| --- | --- |
| `plan_reviewer` | Clean child context receiving the full synthesized plan. |
| `production_readiness_reviewer` | Clean child context receiving scope, evidence, and current-fix summary. |
| `bug_reviewer` | Clean child context receiving scope, evidence, and current-fix summary. |
| `repository_explorer` | Read-only child or fresh task bounded to one question. |
| Ad-hoc child | Clean task with explicit purpose, scope, output format, and applicable docs. |
| Composer implementation phase | Child implementer owns the phase review loop; Composer later audits closeout evidence. |

The prior child transcript is never an input. On re-review, the parent sends updated artifacts or a narrower task summary plus applicable documents.

### Parent duties (Required)

1. Begin every custom-agent launch with the canonical invocation envelope and role contract.
2. Pack all required inputs after the envelope; metadata or chat position never establishes identity or scope.
3. Observe Fast CI before the dual gate and keep reviewer and CI responsibilities separate.
4. Run Full CI only after dual APPROVED and without launching reviewers.
5. Close or reuse agent threads deliberately; a finished child is not review memory for another child.

### Dual-gate envelopes (Required)

| Leg | Envelope rule |
| --- | --- |
| `production_readiness_reviewer` | Locked role opener. Re-scope by replacing the task summary and evidence, not by injecting prior review reasoning. |
| `bug_reviewer` | May receive Custom Instructions for iteration count, known regressions, out-of-scope topics, and clean-fix signals. |

Both legs receive the same declared diff scope and checkout evidence.

### Completion versus closeout (Required)

| Gate | Reviewers | Meaning |
| --- | --- | --- |
| Review-loop completion | Yes | Fast CI has passed; both reviewer legs evaluate the changeset. |
| Closeout | No | Full CI runs after dual APPROVED; reviewers are not closeout actors. |

A reviewer receiving a closeout gate should reject it rather than reinterpret the request.

### Composer transcript audit (Required when Composer is active)

Composer may audit reports and transcripts to verify process honesty: correct actor, observed CI, packed inputs, review iterations, and close boundaries. That audit informs Composer's next orchestration decision; it is not pasted into another reviewer as prior reasoning.

### Anti-patterns (Required)

| Anti-pattern | Why rejected |
| --- | --- |
| “Reviewer mode” in a long chat | No clean context and no reproducible inputs. |
| Attaching the previous review transcript | Converts review into accumulated persuasion. |
| Asking a reviewer to “just re-check” from memory | Hides the current changeset and evidence boundary. |
| Pairing Full CI with reviewers | Blurs completion review and closeout. |
| Using Composer QC as reviewer context | Confuses orchestration audit with review evidence. |

### Host mapping (Required)

| Host | Isolation requirement |
| --- | --- |
| Cursor | Clean Task/subagent context. |
| OpenCode | Task or agent child session; reviewer edit permissions deny writes. |
| Antigravity | Clean `invoke_subagent` context with read-only reviewer definitions. |
| VS Code | Depth-one custom-agent handoff or subagent with a fillable payload. |
| Cline | Separate fresh task/session per reviewer leg until child-spawn isolation is attested. |
| Kilo Code | Separate fresh task/session per reviewer leg until subtask isolation is attested. |
| Codex | Managed agent route from its registered TOML contract. |
| Portable floor | Same evidence, canonical identity, packed inputs, and no prior transcript. |

---

## Implications

1. Isolation is a contract boundary, not a UI preference.
2. A host cannot claim parity while reviewers inherit prior reasoning.
3. Parents own synthesis and thread hygiene; children own evidence-based findings.

---

## Related

- [Intended workflow](./intended-workflow.md)
- [Agent roles and model assignment](./agent-roles-and-model-assignment.md)
- [Instruction layering](./instruction-layering.md)
- [Agent invocation contract](../../workflow/agent-invocation.md)
- [Implementation review skill](../../skills/implementation-review/SKILL.md)
