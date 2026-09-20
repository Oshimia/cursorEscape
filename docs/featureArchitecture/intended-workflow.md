# Intended Workflow

**Last updated:** 2026-09-20

## Context

cursorEscape defines the owner's portable agentic loop: discover, plan, implement, review, verify, and close out. The normative procedures live in [`workflow/`](../../workflow/_index.md), [`skills/`](../../skills/_index.md), [`agents/`](../../agents/_index.md), and [`rules/`](../../rules/_index.md). This page owns the architectural relationship among those gates; it does not duplicate their step-by-step procedures.

The same loop applies across all seven registered host stacks. Host-specific launch and wiring mechanics belong to [`skill-source-and-host-overlays.md`](./skill-source-and-host-overlays.md) and [`host-adaptation-fidelity.md`](./host-adaptation-fidelity.md).

---

## Substance

### Workspace and review scope (Required)

| Term | Meaning |
| --- | --- |
| **Companion repo** | This cursorEscape repository, which owns portable workflow IP and registry metadata. |
| **Target workspace** | The repository being operated on. It may be cursorEscape itself or another project. |
| **Uncommitted scope** | The current working-tree delta against the checkout base. |
| **Branch scope** | The committed delta against an explicitly named base branch. |

**Required:** Every implementation and review invoke states whether its evidence is uncommitted or branch-based. Reviewers share the same checkout and evidence boundary as the implementer; they do not reconstruct scope from chat history.

Monorepo and multi-root support is not silently generalized. If a task cannot be expressed as one target workspace and one explicit diff scope, the parent must narrow the task or obtain an owner decision before implementation.

### End-to-end loop (Required)

```text
Discover repository documentation
  → Plan with implementation-plan and plan_reviewer
  → Owner approval preview when visual sign-off is documented or explicitly requested
  → Implement
  → Fast CI observed
  → production_readiness_reviewer ∥ bug_reviewer
  → Fix must-fix findings and repeat review as needed
  → Dual APPROVED
  → Full CI closeout without reviewers
  → Local commit; never push unless separately requested by the owner
```

| Stage | Owner | Rule |
| --- | --- | --- |
| Discovery | Parent or implementer | Run repository-documentation discovery before non-trivial edits. |
| Plan gate | Planner and `plan_reviewer` | Default on. Skip only for a truly trivial case or explicit owner opt-out; when in doubt, run the plan loop. |
| Owner approval preview | Composer | Required when visual sign-off is documented or explicitly requested. |
| Fast CI | Review-loop parent | Observe a passing run before launching reviewers. Never launch on failure, an inapplicable claim without explicit `n/a`, or prose-only evidence. |
| Dual review | Both reviewer legs in parallel | Default on for non-trivial work. Repair every must-fix finding and rerun both legs. |
| Full CI | Parent | Run once after dual APPROVED. Do not pair Full CI with reviewer launches. |
| Closeout | Parent or Composer | Preserve evidence, state residual deferred work, and commit locally only after the applicable CI gate. |

### Dual-gate review (Required)

| Leg | Responsibility |
| --- | --- |
| `production_readiness_reviewer` | Process, architecture drift, incomplete changesets, blocking tests, and blocking documentation. May approve with explicitly batchable deferred work. |
| `bug_reviewer` | Introduced bugs, security, concurrency, and high-value correctness. Reports findings or CLEAN; it never emits blocking/non-blocking or test-gap scaffolding. |

**Required:** At most four dual-review iterations per pressure-release block. At the cap, return a cap-exhausted handoff for owner or Composer triage rather than silently narrowing scope. The production reviewer owns verdict tiers and may approve with explicitly batchable deferred work; the bug leg contributes findings-vs-CLEAN under [`bug-reviewer-finding-rubric.md`](./bug-reviewer-finding-rubric.md), and any reportable bug prevents dual APPROVED.

### CI architecture (Required)

For this repository, the registry owns machine metadata and the two normalization entry points own integrity:

| Gate | Entry point | Position |
| --- | --- | --- |
| Fast CI | `scripts/normalization/Invoke-NormalizationFastCI.ps1` | Before every reviewer pass. |
| Full CI | `scripts/normalization/Invoke-NormalizationFullCI.ps1` | After dual APPROVED, before closeout. |

For another target repository, discover and run the target's own Fast/Full ladder through [`workflow/ci-ladder.md`](../../workflow/ci-ladder.md). Do not assume cursorEscape's normalization scripts apply to another project.

### Phased multi-agent work (Optional)

Composer may conduct a roadmap in implementation phases. Composer owns phase checkpoints and QC; an implementation subagent owns the phase's implementation and review loop. The review bar is unchanged: Fast CI first, both reviewer legs, dual APPROVED, then Full CI closeout. Cap exhaustion returns to Composer with enough evidence to renew, narrow, terminate, waive, or restart from a known checkpoint.

### Non-ownership

cursorEscape does not own host products, model providers, source-control remotes, or a general IDE. It defines portable contracts, registry-owned projections, and verification for the owner's workflow.

---

## Implications

1. Review verdicts are evidence-bound to the stated workspace and diff scope.
2. Host launch mechanics may differ, but plan, dual-review, isolation, CI-order, and closeout gates may not.
3. Local commits are the normal boundary; pushing remains a separate owner-directed action.

---

## Related

- [Agent roles and model assignment](./agent-roles-and-model-assignment.md)
- [Instruction layering](./instruction-layering.md)
- [Clean context and isolation](./clean-context-isolation.md)
- [bug-reviewer finding rubric](./bug-reviewer-finding-rubric.md)
- [Procedure registry](./procedure-registry.md)
- [Implementation review skill](../../skills/implementation-review/SKILL.md)
- [Composer skill](../../skills/composer/SKILL.md)
