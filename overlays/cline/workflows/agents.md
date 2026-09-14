# governed agents (Cline overlay — fallback launch contract)

Cline has no governed custom-agent definitions for cursorEscape. Use a **separate fresh Cline task/session per governed leg** until attested native subtask isolation exists. Never convert a role by changing personas in an existing conversation; a reused conversation is a routing/isolation failure, not a valid governed result.

## Governed route set

| Canonical identity | First-read contract | Canonical authority | Canonical isolation | Loop/gate |
| --- | --- | --- | --- | --- |
| `planner` | `{{COMPANION_ROOT}}/agents/planner.md` | read-only | clean-context | `planning` |
| `plan_reviewer` | `{{COMPANION_ROOT}}/agents/plan_reviewer.md` | read-only | clean-context | `plan-review` |
| `implementer` | `{{COMPANION_ROOT}}/agents/implementer.md` | workspace-write | clean-context | `phase` |
| `production_readiness_reviewer` | `{{COMPANION_ROOT}}/agents/production_readiness_reviewer.md` | read-only | clean-context | `review-loop` |
| `bug_reviewer` | `{{COMPANION_ROOT}}/agents/bug_reviewer.md` | read-only | clean-context | `review-loop` |
| `repository_explorer` | `{{COMPANION_ROOT}}/agents/repository_explorer.md` | read-only | clean-context | `investigation` |
| `test_reviewer` | `{{COMPANION_ROOT}}/agents/test_reviewer.md` | read-only | clean-context | `test-review` |

Apply each role's role-specific required reading from `{{COMPANION_ROOT}}/workflow/agent-invocation.md`. The route identity is the canonical identity; no Cline label or alias replaces it.

## `implementer` fresh-task envelope

Start a new Cline task/session. Begin its payload exactly with this envelope before task-specific context:

```text
You are the `implementer` agent.
Read `{{COMPANION_ROOT}}/agents/implementer.md` before acting.
Required reading:
- {{COMPANION_ROOT}}/workflow/agent-invocation.md
- {{COMPANION_ROOT}}/agents/implementer.md

Host alias: none
Isolation: clean-context
Authority: workspace-write
Loop/gate: phase

---
<approved phase scope, repository path, constraints, and verification commands>
```

The implementer may edit only its declared workspace scope. Do not use this route for a reviewer leg; reviewer authority is read-only.

## `test_reviewer` fresh-task envelope

Close or set aside the implementation leg, then start another new Cline task/session. Begin its payload exactly with this envelope before parent-supplied test context:

```text
You are the `test_reviewer` agent.
Read `{{COMPANION_ROOT}}/agents/test_reviewer.md` before acting.
Required reading:
- {{COMPANION_ROOT}}/workflow/agent-invocation.md
- {{COMPANION_ROOT}}/agents/test_reviewer.md

Host alias: none
Isolation: clean-context
Authority: read-only
Loop/gate: test-review

---
<parent-supplied test context and changed paths>
```

The test reviewer must not edit files, install dependencies, commit, push, or rerun CI.

## Fail loud

Each fresh payload must contain the complete canonical envelope. A missing, malformed, contradictory, or unreadable envelope fails loudly in that role's native output shape. An empty response or routing placeholder is a routing failure; start another fresh task rather than accepting an inferred identity.
