# Agent Roles and Model Assignment

**Last updated:** 2026-09-20

## Context

Agent roles are portable contracts in [`agents/`](../../agents/_index.md). Host overlays may provide launch mechanics, permissions, aliases, or native-agent wrappers, but they must not redefine a role's identity, isolation, authority, loop/gate, or fail-loud behavior.

Model assignment is host configuration, not prompt identity. A role remains the same architectural contract even when a different model executes it.

---

## Substance

### Role catalog (Required)

| Role | Loop position | Responsibility | Default reviewer? |
| --- | --- | --- | --- |
| `planner` | Plan | Draft the implementation plan and identify discovery or escalation needs. | No |
| `plan_reviewer` | Plan gate | Clean-context plan review, maximum three passes. | No |
| `implementer` | Implement | Execute the approved scope; on phased work, own the phase review loop. | No |
| `production_readiness_reviewer` | Dual gate | Process, architecture drift, changeset completeness, blocking tests/docs. | Yes |
| `bug_reviewer` | Dual gate | Introduced bugs, security, concurrency, and high-value correctness. | Yes |
| `repository_explorer` | Investigation | Read-only, bounded evidence search. | No |
| `test_reviewer` | Explicit review advice | Test strategy and regression-risk advice when explicitly requested. | No |

The mandatory closeout gate is only the two reviewer roles above. `test_reviewer` can supplement an explicitly test-heavy review; it does not replace the production reviewer's blocking test bar.

### Dual-gate rule (Required)

Launch `production_readiness_reviewer` and `bug_reviewer` in parallel after observed Fast CI. Repair all must-fix findings, then launch both legs again with freshly packed inputs. Neither leg alone is the review gate.

### Model assignment (Desired)

| Role | Assignment guidance |
| --- | --- |
| `plan_reviewer` | Strong reasoning model. |
| `production_readiness_reviewer` | Strong reasoning model or an equivalent role-tuned reviewer. |
| `bug_reviewer` | Match the production reviewer's capability or choose a stronger bug-focused model. |
| `implementer` | Capable coding model; speed may be preferred for tightly scoped changes. |
| `repository_explorer` | Fast, inexpensive model is usually sufficient. |
| `test_reviewer` | Strong reasoning or test-aware model. |

Assignments belong in host or repository configuration. Role Markdown stays identity-first and model-agnostic.

### Host projection

All seven registered stacks use their own launch surface, but the same catalog semantics apply:

| Host | Projection rule |
| --- | --- |
| Cursor | Native subagent/rule surfaces route through thin overlay wrappers. |
| OpenCode | Markdown agents and Task sessions carry reviewer edit denial and isolation metadata. |
| Antigravity | Overlay subagent definitions route isolated reviewer launches. |
| VS Code | Handoff or subagent surfaces receive the full invocation payload. |
| Cline | Fresh task/session boundaries are required until a host child-spawn surface is attested. |
| Kilo Code | Fresh task/session boundaries are required until subtask isolation is attested. |
| Codex | Managed TOML/agent routes and managed AGENTS identity carry the portable contract. |

### Unknown

A portable role-to-model-to-provider configuration schema is not established. Host-specific configuration remains valid while the registry owns contract semantics. Introduce a cross-host model-assignment schema only when its maintenance cost is justified by a real owner workflow.

---

## Related

- [Agent contracts index](../../agents/_index.md)
- [Intended workflow](./intended-workflow.md)
- [Clean context and isolation](./clean-context-isolation.md)
- [Instruction layering](./instruction-layering.md)
- [Skill source and host overlays](./skill-source-and-host-overlays.md)
