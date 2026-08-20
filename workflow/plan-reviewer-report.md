# Plan reviewer report schema

**Last updated:** 2026-08-20  
**Companion-edit probe (pointer-first-4):** `pf4-visibility-marker-20260820` — author-time marker in companion SoT; optional runtime row **13** spot-check may quote this line from `{{COMPANION_ROOT}}/workflow/plan-reviewer-report.md` (not host mirror copy-out).

**Skills:** [plan-review](../skills/plan-review/SKILL.md), [implementation-plan](../skills/implementation-plan/SKILL.md). **Agent:** [plan_reviewer](../agents/plan_reviewer.md).

Deep **output specimen** for adversarial plan review. Audit duties and verdict bar live in the agent contract; load this doc when emitting review output.

## When to load

- Parent invokes `plan_reviewer` and the reviewer needs the exact report structure
- Skills or agents cite **Read when** for plan-reviewer output format
- Do **not** paste this schema into always-on rules, skill bodies, or agent system prompts — load on demand only ([instruction-layering L3](../docs/featureArchitecture/instruction-layering.md))

## Output limits

Audit every category in [plan_reviewer audit duties](../agents/plan_reviewer.md#your-audit-duties), but **emit** only the highest-severity items per cap. Apply [severity ranking](#severity-ranking) before capping.

| List                                 | Max items | Notes                                                            |
| ------------------------------------ | --------- | ---------------------------------------------------------------- |
| **Blocking findings**                | 5         | Includes unacknowledged verification gaps                        |
| **Non-blocking findings**            | 10        | Optional improvements only                                       |
| **Assumptions table**                | 5 rows    | Highest-risk only (Low confidence or critical path)              |
| **Unknowns**                         | 5         | Highest impact first                                             |
| **Areas requiring verification**     | 5         | Highest impact first                                             |
| **Unacknowledged verification gaps** | 3         | Count toward blocking cap if also listed under Blocking findings |

Already bounded: **Failure forecast** = exactly 3; **Cost challenge** = 1 short paragraph; **Architecture alignment** = 1 short paragraph.

## Severity ranking

**Blocking** (highest first):

1. Plan would fail or ship unsafe behavior if unfixed
2. Unacknowledged verification gap on critical path
3. Repo SOP post-apply / operator checklist items buried only under External dependencies (not Incremental execution or Verification)
4. Escalation omitted; Escalation **yes** missing Agent context / contracts; planning Composer signal with Escalation **no**
5. Missing required A/B/C for architectural change
6. Violates documented architecture / conventions with no justification
7. Incremental execution FAIL (big-bang step)

**Non-blocking** (highest first):

1. Cost challenge / simpler path not considered in plan
2. Failure forecast item not captured in discovery steps
3. Medium-confidence assumption without validation
4. Missing “simpler options considered” note (optional A/B/C)
5. Sequencing CONCERNS with mitigation possible
6. 4+ phases with Escalation **no** (parent should AskQuestion)

## Overflow lines (required when truncated)

After **Blocking findings** and **Non-blocking findings**, add one line each when items were omitted:

```markdown
(+N additional blocking findings omitted — themes: ...)
(+N additional non-blocking findings omitted — themes: ...)
```

Themes = short phrases (e.g. "test coverage", "migration ordering"), not full findings.

## Output format

Use this **exact** structure:

```markdown
## Verdict
APPROVED | CHANGES REQUESTED (with reason)

## Findings summary
Blocking emitted: N (max 5) | Non-blocking emitted: N (max 10)
Omitted: +X blocking, +Y non-blocking (themes: ...)

## Assumptions
| Assumption | Confidence | Evidence | Validation method |
(up to 5 highest-risk rows, or "None")

## Unknowns
(up to 5, highest impact first; write "None" if empty)

## External dependencies
(numbered list; write "None" if empty)

## Areas requiring verification
(up to 5 — what, how, when; write "None" if empty)

## Alternative approaches
(Required: yes/no. Adequate A/B/C or recommended approach? Propose alternatives if weak.)

## Cost challenge
(One short paragraph — fewer files/abstractions/dependencies? Modify existing vs new code?)

## Failure forecast
1. ...
2. ...
3. ...

## Incremental execution and safety
(PASS/FAIL/CONCERNS — risks and mitigations)

## Blocking findings
(up to 5, severity-ranked; write "None" if empty)
(+N additional blocking findings omitted — themes: ...)  ← only when truncated

## Non-blocking findings
(up to 10, severity-ranked; write "None" if empty)
(+N additional non-blocking findings omitted — themes: ...)  ← only when truncated

## Verification gaps
### Unacknowledged
(up to 3; write "None" if empty)
### Captured as discovery steps
(numbered list; write "None" if empty)

## Architecture alignment
(One short paragraph — documented patterns followed? Doc drift or parallel inventions?)
```

Do **not** add Escalation / Agent context headings to this output schema.

## Related

- [plan_reviewer](../agents/plan_reviewer.md) — audit duties, verdict bar, must-not
- [iterative-plan-review.md](iterative-plan-review.md) — plan → plan-reviewer loop
- [plan-agent-context.md](plan-agent-context.md) — Escalation field + Agent context headings (plan body, not review output)
- [implementation-plan Incomplete until](../skills/implementation-plan/SKILL.md#incomplete-until-section-sot) — plan section SoT
- [_index.md](_index.md)
