# Phased multi-agent plans (large & complex)

**Skills:** [implementation-plan](../docs/skills/implementation-plan.md) (draft), [roadmap](../docs/skills/roadmap.md) (repo handoff file), [composer](../docs/skills/composer.md) (optional conductor).

**In-plan Agent context** is required when the plan’s **Escalation** sets `Agent context required: **yes**` (user-labeled composer-level, or unusually complex / extensive). Typical ≤3-phase work stays on the light Incremental execution template. Full Escalation field, required headings, and dummy example: [plan-agent-context.md](plan-agent-context.md).

## Workflow

```text
Draft plan (Escalation yes → Agent context in plan; no → light Incremental execution)
  → plan-reviewer → user accepts
  → roadmap: Escalation yes → copy from plan; Escalation no → may restructure bullets (no new scope)
  → Phase N (Composer or clean-context agent) → review → commit
  → Phase N+1 …
```

## Roadmap location

Resolve via the [roadmap](../docs/skills/roadmap.md) skill — **never** assume a fixed folder name. Default when no convention: `docs/roadmaps/<feature>.md`. See [discovery.md](discovery.md).

## Required roadmap sections

Same schema as escalated plans — see [plan-agent-context.md](plan-agent-context.md). Do not maintain a second heading list here.

| Escalation was | Roadmap behavior |
|----------------|------------------|
| **yes** | **Copy** contracts + Agent context from the accepted plan. Fail-closed if missing/stub. Never invent scope. |
| **no** | Optional for Composer later: **may restructure** thin Incremental execution into Agent context headings **without adding new scope**. |

## Composer

When the user assigns [composer](../docs/skills/composer.md), follow that skill’s phase lifecycle. Composer multi-phase **requires** a repo roadmap file. Composer verifies subagent process via transcripts (Nb, nested reviewers, and its own Na/migration work) before advancing each phase.

If the user asks Composer to **plan**, stay in Plan mode / [implementation-plan](../docs/skills/implementation-plan.md) with Escalation **yes** — Composer does not draft plans while conducting.

Without Composer, one clean-context agent per phase still ends with the [implementation-review](../docs/skills/implementation-review.md) loop before the next phase.

## Related

**Workflow docs:** [plan-agent-context.md](plan-agent-context.md), [iterative-plan-review.md](iterative-plan-review.md), [iterative-code-review.md](iterative-code-review.md), [discovery.md](discovery.md), [ci-ladder.md](ci-ladder.md), [documentation-architecture.md](documentation-architecture.md), [_index.md](_index.md)

**Skills / agents:** [implementation-plan](../docs/skills/implementation-plan.md), [roadmap](../docs/skills/roadmap.md), [composer](../docs/skills/composer.md), [implementation-review](../docs/skills/implementation-review.md), [plan_reviewer](../docs/agents/plan_reviewer.md), [production_readiness_reviewer](../docs/agents/production_readiness_reviewer.md)
