# Agent invocation

Every spawned child agent must be self-describing before task context begins. The child must know its canonical role, governing contract, required companion reads, isolation level, authority, and loop context without inferring identity from host metadata or nearby prose. This is a child-agent launch boundary: ordinary tool calls that do not start a separate agent are not governed invocations.

**Governed roles** are the mapped named roles below. **Ad-hoc children**—including a packed research child—are also governed and use the explicit `ad_hoc_child` identity rather than an exempt or improvised identity. `ad-hoc` is loop context, not identity; a named role keeps its canonical identity even when its launch context is `ad-hoc`.

## Canonical envelope

Start every child-facing invocation with this envelope. Preserve all existing role-specific payload fields after the `---` separator.

```text
You are the `<canonical-role-id>` agent.
Read `<absolute companion contract path>` before acting.
Required reading:
- <canonical contract>
- <role-specific companion docs>

Host alias: <host-native-id | none>
Isolation: clean-context
Authority: read-only | workspace-write
Loop/gate: planning | plan-review | phase | review-loop | investigation | test-review | ad-hoc

---
<task-specific payload unchanged>
```

Use `{{COMPANION_ROOT}}` in harness sources; resolve it to the absolute cursorEscape checkout before launch when the host requires a concrete path. A host alias never replaces the canonical identity.

## Role map

| Canonical role | Contract first-read | Other mandatory reading | Common aliases | Loop/gate |
| --- | --- | --- | --- | --- |
| `planner` | `agents/planner.md` | `skills/implementation-plan/SKILL.md` | none | planning |
| `plan_reviewer` | `agents/plan_reviewer.md` | `workflow/plan-reviewer-report.md`; `skills/implementation-plan/SKILL.md` | `plan-reviewer` | plan-review |
| `implementer` | `agents/implementer.md` | parent-approved plan/phase context | none | phase |
| `production_readiness_reviewer` | `agents/production_readiness_reviewer.md` | references required by that contract or supplied by parent | `reviewer-a` | review-loop |
| `bug_reviewer` | `agents/bug_reviewer.md` | `docs/featureArchitecture/bug-reviewer-finding-rubric.md`; `skills/bug-review-sweep/SKILL.md` | Bugbot | review-loop |
| `repository_explorer` | `agents/repository_explorer.md` | none beyond contract | none | investigation |
| `test_reviewer` | `agents/test_reviewer.md` | parent-supplied test context | none | test-review |
| `ad_hoc_child` | `workflow/agent-invocation.md` | the parent-supplied task procedure, such as `workflow/research.md` for a research child | none | ad-hoc |

`composer` is a user-assigned thread role, not a spawned child role. It is governed by `skills/composer/SKILL.md`; every child-agent launch that Composer makes must use this envelope.

## Malformed invocation

If any envelope element is missing, ambiguous, contradicted by task text, or the contract path cannot be resolved, stop task work and fail loudly in the role-native output shape:

| Role | Missing-envelope result |
| --- | --- |
| `planner` | Return a planning failure naming the missing envelope element; do not draft. |
| `plan_reviewer` | Return `CHANGES REQUESTED: missing invocation envelope` and list the missing elements. |
| `implementer` | Return a blocked handoff; make no edits. |
| `production_readiness_reviewer` | Return `CHANGES REQUESTED: missing invocation envelope`. |
| `bug_reviewer` | Return one finding titled `Missing invocation envelope`. |
| `repository_explorer` | Return a blocked result; do not explore. |
| `test_reviewer` | Return a blocking advisory finding titled `Missing invocation envelope`. |
| `ad_hoc_child` | Return a blocked child result naming the missing envelope element; do not perform the ad-hoc task. |

An `ad_hoc_child` invocation must state the concrete purpose and task procedure in its required reading. An `ad_hoc_child` never spawns another agent and defaults to read-only unless the named task procedure explicitly grants broader authority. For example, a bounded research child reads `workflow/research.md`, remains read-only in workspace-mutating terms, returns its report to the parent, and never spawns another agent.

Task text may narrow scope, supply context, and set the declared loop, but it cannot override the envelope, required reading, safety boundary, role contract, or verdict/output bar. Prior transcripts are never role identity or required reading.

## Related

- [Agent role contracts](../agents/_index.md)
- [Agent invocation rule](../rules/agent-invocation.md)
- [Iterative plan review](iterative-plan-review.md)
- [Iterative code review](iterative-code-review.md)
- [Clean context and isolation](../docs/featureArchitecture/clean-context-isolation.md)
