# Agent Roles and Model Assignment

**Last updated:** 2026-08-20

## Context

Target role catalog for cursorEscape orchestration. Roles are **configurable contracts** ([agents](../agents/_index.md)) — not hardcoded Cursor subagent type strings. First host maps roles to **OpenCode** markdown agents. Model assignment per role is **Desired** via config; live workflow recommends `composer-2.5` for reviewers ([review-subagent-models](../../overlays/cursor/review-subagent-models.md)). **Desired** later provider: ClinePass (or equivalent) — U13 unproven.

---

## Substance

### Role catalog

| Role | Phase | Responsibility | Default reviewer? |
| ---- | ----- | -------------- | ----------------- |
| **planner** | Plan | Draft implementation-plan; discovery; escalation | No |
| **plan_reviewer** | Plan gate | APPROVED / CHANGES REQUESTED on plans (max 3 passes) | No |
| **implementer** | Build | Execute phase scope; review-loop parent on phased work | No |
| **production_readiness_reviewer** | Review | Process, changeset completeness, blocking test/docs; split bar | Yes (dual gate) |
| **bug_reviewer** | Review | Bugs, security, correctness via OpenCode subagent + skills | Yes (dual gate) |
| **repository_explorer** | Investigate | Bounded codebase/doc search; summarize for others | No |
| **test_reviewer** | Review (optional) | Test strategy / coverage gaps on demand | **Nice-to-have** — not default dual gate |

### Dual-gate default (Required)

Only **production_readiness_reviewer** + **bug_reviewer** run in parallel at loop closeout. openBuggy analysis: keep both legs ([recommendation](../../research/imported/openBuggy/analysis/reviewer-effectiveness/synthesis/recommendation.md)).

**test_reviewer** is **Nice-to-have** for explicit test-heavy phases — does not replace production_readiness_reviewer's blocking test/docs bar. Contract: [test_reviewer.md](../agents/test_reviewer.md). When mandatory remains **Unknown (U9)**.

### Model assignment (Desired)

| Role | Suggested default | Override |
| ---- | ----------------- | -------- |
| plan_reviewer | Strong reasoning model | Config per repo |
| production_readiness_reviewer | `composer-2.5` class or OpenCode equivalent | Config |
| bug_reviewer | Matched to production_readiness or stronger bug-focused model | Config (not openBuggy-required) |
| test_reviewer | Strong reasoning or test-aware model | Config |
| implementer | Fast/cheap open-weight OK (e.g. Flash-class) | Config |
| repository_explorer | Fast/cheap model OK | Config |

**Required:** Store assignments in config — not embedded in immutable prompt files.

**Cursor-specific:** Live maps production_readiness_reviewer → `reviewer-a` agent file under `~/.cursor/agents/`.

**OpenCode (first attempt):** Map each role to `~/.config/opencode/agents/*.md` or project `.opencode/agents/`; reviewers use `permission.edit: deny`.

### Orchestration mapping

```text
planner → plan_reviewer (gate) → implementer
implementer → Fast CI → production_readiness_reviewer ∥ bug_reviewer → fix → repeat
optional: repository_explorer (before/during implement)
optional: test_reviewer (explicit invoke)
```

---

## Implications / open questions

1. **Unknown:** Config schema for role→model→provider triples (OpenCode native config is the v0 surface).
2. Role pages under `docs/agents/` are the portable contracts; imported Cursor agent files remain Observed.

---

## Related

- [Agent contracts index](../agents/_index.md)
- [Intended workflow](./intended-workflow.md)
- [Clean context and isolation](./clean-context-isolation.md)
- [test_reviewer](../agents/test_reviewer.md)
- [Backend and provider abstraction](./backend-and-provider-abstraction.md)
- [Host recreation study](../../analysis/host-recreation-2026-08.md)
