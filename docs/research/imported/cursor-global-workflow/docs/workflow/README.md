> **Imported research** — Source: live `~/.cursor`; copied 2026-08-17 into cursorEscape. Status: Observed/imported (Observed interim Cursor wording; companion repo is Target contract SoT). Do not treat as Target cursorEscape design unless a Target doc cites it.
# Cursor workflow docs (canonical for agents)

**Ownership:** Process changes land here first. Repo SOPs may extend with local paths; they must not contradict this core.

Absolute root: `C:/Users/admin/.cursor/docs/workflow/`

## Docs

| Doc | Purpose |
|-----|---------|
| [discovery.md](discovery.md) | How to find repo docs (Step 0 + fallback) |
| [documentation-architecture.md](documentation-architecture.md) | Default layout when bootstrapping **new** docs |
| [phased-multi-agent.md](phased-multi-agent.md) | Large multi-phase handoffs + roadmap shape |
| [plan-agent-context.md](plan-agent-context.md) | Escalation field + Agent context headings (escalated plans only) |
| [iterative-plan-review.md](iterative-plan-review.md) | Plan → plan-reviewer loop |
| [iterative-code-review.md](iterative-code-review.md) | Per-phase Reviewer A + Bugbot loop |
| [ci-ladder.md](ci-ladder.md) | Fast/Full CI discovery for any repo |
| [review-subagent-models.md](review-subagent-models.md) | Recommended models + chat override |

## Skills

| Skill | Path |
|-------|------|
| [implementation-plan](../../skills/implementation-plan/SKILL.md) | Plan drafting + plan-reviewer loop |
| [implementation-review](../../skills/implementation-review/SKILL.md) | Per-phase Reviewer A + Bugbot |
| [composer](../../skills/composer/SKILL.md) | Phased execution conductor |
| [roadmap](../../skills/roadmap/SKILL.md) | Repo multi-phase handoff files |
| [documentation-architecture](../../skills/documentation-architecture/SKILL.md) | Bootstrap/extend repo docs layout |

## Agents

| Agent | Path |
|-------|------|
| [plan-reviewer](../../agents/plan-reviewer.md) | Adversarial plan review |
| [reviewer-a](../../agents/reviewer-a.md) | Production-readiness code review |

Repo product/architecture docs and multi-phase roadmaps live **in the repo**, not here.
