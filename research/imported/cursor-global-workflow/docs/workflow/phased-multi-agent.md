> **Imported research** — Source: live `~/.cursor`; copied 2026-08-17 into cursorEscape. Status: Observed/imported (Observed interim Cursor wording; companion repo is Target contract SoT). Do not treat as Target cursorEscape design unless a Target doc cites it.
# Phased multi-agent plans (large & complex)

**Skills:** [implementation-plan](../../skills/implementation-plan/SKILL.md) (draft), [roadmap](../../skills/roadmap/SKILL.md) (repo handoff file), [composer](../../skills/composer/SKILL.md) (optional conductor).

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

Resolve via the [roadmap](../../skills/roadmap/SKILL.md) skill — **never** assume a fixed folder name. Default when no convention: `docs/roadmaps/<feature>.md`. See [discovery.md](discovery.md).

## Required roadmap sections

Same schema as escalated plans — see [plan-agent-context.md](plan-agent-context.md). Do not maintain a second heading list here.

| Escalation was | Roadmap behavior |
|----------------|------------------|
| **yes** | **Copy** contracts + Agent context from the accepted plan. Fail-closed if missing/stub. Never invent scope. |
| **no** | Optional for Composer later: **may restructure** thin Incremental execution into Agent context headings **without adding new scope**. |

## Composer

When the user assigns [composer](../../skills/composer/SKILL.md), follow that skill’s phase lifecycle. Composer multi-phase **requires** a repo roadmap file. Composer verifies subagent process via transcripts (Nb, nested reviewers, and its own Na/migration work) before advancing each phase.

If the user asks Composer to **plan**, stay in Plan mode / [implementation-plan](../../skills/implementation-plan/SKILL.md) with Escalation **yes** — Composer does not draft plans while conducting.

Without Composer, one clean-context agent per phase still ends with the [implementation-review](../../skills/implementation-review/SKILL.md) loop before the next phase.

## Related

**Workflow docs:** [plan-agent-context.md](plan-agent-context.md), [iterative-plan-review.md](iterative-plan-review.md), [iterative-code-review.md](iterative-code-review.md), [discovery.md](discovery.md), [ci-ladder.md](ci-ladder.md), [documentation-architecture.md](documentation-architecture.md), [README.md](README.md)

**Skills / agents:** [implementation-plan](../../skills/implementation-plan/SKILL.md), [roadmap](../../skills/roadmap/SKILL.md), [composer](../../skills/composer/SKILL.md), [implementation-review](../../skills/implementation-review/SKILL.md), [plan-reviewer](../../agents/plan-reviewer.md), [reviewer-a](../../agents/reviewer-a.md)
