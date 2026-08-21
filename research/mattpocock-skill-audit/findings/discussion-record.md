# Owner Discussion Record

**Date:** 2026-08-21
**Scope:** Tier 1 assessment findings
**Snapshot:** `mattpocock/skills` commit `0ab1b63a410a03d3627979a109c8695de27af954`

## Decisions

| Skill | Owner decision | Integration direction |
|---|---|---|
| `wizard` | Accept `Adapt` | Preserve the source/destination/sensitivity/stage map, concrete safety criteria, and ephemeral-by-default handling. Rebuild as a portable human-only procedure with host overlays. |
| `writing-for-agents` | Accept `Adapt` | Merge the context-load, pointer, pruning, and completion-criteria heuristics into the existing documentation workflow. |
| `code-review` | Accept `Adapt` | Treat Standards-vs-Spec separation as a valuable iteration of the existing review loop, not as a second independent gate. Preserve local dual-review, CI, isolation, and recursion protections. |
| `improve-codebase-architecture` | Accept `Adapt` | Build a local process skill focused on finding improvement opportunities, explaining the issue, comparing options and trade-offs, and reaching an owner-understood improvement plan. Do not copy the upstream report shape or automatically mutate domain records. |
| `codebase-design` | Accept `Adopt` | Bring in the portable deep-module vocabulary, deletion test, seam reasoning, and design alternatives as a local non-driver reference adapted to cursorEscape terminology. |
| `domain-modeling` | Accept `Adapt` | Use existing glossary/design-decision documents when suitable; otherwise keep results in the active plan first. Create a durable context or decision document only when explicitly justified by complexity or long-term value. |

## Domain-modeling maintenance policy

- The procedure is opt-in and planning/discovery-oriented, not always-on.
- It challenges terminology, tests concepts with scenarios, cross-checks code, and identifies avoided synonyms.
- It does not require a root `CONTEXT.md` or a new ADR tree.
- It does not write durable artifacts automatically during ordinary reviews.
- Existing repository documents remain authoritative when they are suitable.
- The active plan or research artifact is the default fallback for unresolved or temporary modeling work.
- Durable documents require explicit owner approval and a clear maintenance benefit.
- ADR-style records are reserved for decisions that are difficult to reverse, surprising without explanation, and based on a meaningful trade-off.

## Process decision

The owner explicitly waived the implementation review loop for this documentation-only audit. Findings remain subject to the assessment evidence and owner discussion, but not the code-oriented dual-review loop.

## Remaining owner decisions

| Skill or area | Owner decision |
|---|---|
| `ask-matt` | Reference-only. |
| `claude-handoff` | Reference-only. |
| `diagnosing-bugs` | Adopt as a user-invoked workflow for bugs in already accepted or shipped code. Keep it separate from the mandatory always-on `bug_reviewer` change-review leg. Evaluate selected evidence-first improvements for that leg separately, without changing its purpose. |
| `git-guardrails-claude-code` | Reject. |
| `grill-me` | Reference-only. |
| `grilling` | Adapt as a reusable alignment primitive. |
| `grill-with-docs` | Adapt as a precursor within the implementation-plan process. |
| `handoff` | Thin Adapt only; occasional harness transition use does not justify bloat. |
| `implement` | Thin Adapt only. |
| `loop-me` | Reference-only. |
| `migrate-to-shoehorn` | Reject. |
| `prototype` | Adapt as a broad, formalized, repository-agnostic prototyping pattern based on the existing EZPZ precedent. |
| `research` | Adapt. |
| `resolving-merge-conflicts` | Adapt. |
| `scaffold-exercises` | Reject. |
| `setup-pre-commit` | Reject as a source skill; lint/test standards remain a possible separate local concern. |
| `setup-ts-deep-modules` | Reject as a setup skill; retain useful design-vocabulary distinctions as reference. |
| `tdd` | Adopt. |
| `teach` | Adopt as a distinct dedicated-session workflow with an isolated learning workspace, not as part of normal coding workflows. |
| `wait-what` | Adapt. |
| Infrastructure | Accept the recommendations in `findings/infra.md`. |

## Bug-review diagnosis boundary

The owner confirmed that `bug_reviewer` may perform opportunistic reproduction or inspection when it is strictly read-only, requires no file modification, and does not materially increase review time. It must not install dependencies, mutate databases or services, write generated artifacts, edit instrumentation, or run a full diagnosis loop. The default remains evidence from the diff and existing workspace; cheap reproduction is an optimization, not a gate.

The recommended OpenBuggy contract is an optional structured follow-up object rather than a boolean:

```json
"follow_up": {
  "type": "none" | "diagnosis",
  "reason": "...",
  "evidence_needed": "..."
}
```

`follow_up.type = "diagnosis"` signals that the finding or symptom needs the separate user-invoked diagnosis workflow. It does not silently launch that workflow, weaken the change-review finding bar, or replace the parent implementation loop. The change-review profile remains the mandatory read-only diff-review leg; the diagnosis profile owns reproduction, minimization, hypotheses, instrumentation, regression proof, and cleanup.

## Status

Tier 1 owner discussion is complete. These amended decisions are the input to merge triage; no adaptation implementation is authorized by this record.
