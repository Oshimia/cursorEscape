# Workflow docs (shared deep procedure)

**Last updated:** 2026-08-20

**Ownership:** Process changes land here first. Repo SOPs may extend with local paths; they must not contradict this core.

Repo root: `workflow/` (this tree). Live Cursor install: `~/.cursor/docs/workflow/` (copy-out only — not overwritten from this repo).

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

Cursor-only: [review-subagent-models.md](../overlays/cursor/review-subagent-models.md) (recommended reviewer models; stays on overlay until Phase 5).

## Skills (interim contracts — Phase 4 retargets to root `skills/`)

| Skill | Path |
|-------|------|
| [implementation-plan](../docs/skills/implementation-plan.md) | Plan drafting + plan-reviewer loop |
| [implementation-review](../docs/skills/implementation-review.md) | Per-phase Reviewer A + Bugbot |
| [composer](../docs/skills/composer.md) | Phased execution conductor |
| [roadmap](../docs/skills/roadmap.md) | Repo multi-phase handoff files |
| [documentation-architecture](../docs/skills/documentation-architecture.md) | Bootstrap/extend repo docs layout |

## Agents (interim contracts — Phase 4 retargets to root `agents/`)

| Display name | Portable contract | Role |
|--------------|-------------------|------|
| plan-reviewer | [plan_reviewer](../docs/agents/plan_reviewer.md) | Adversarial plan review |
| reviewer-a | [production_readiness_reviewer](../docs/agents/production_readiness_reviewer.md) | Production-readiness code review |
| Bugbot | [bug_reviewer](../docs/agents/bug_reviewer.md) | Cursor product subagent (no owner-authored overlay file) |

## Used-by matrix

| Workflow leaf | Base skill | Base agent(s) | Cursor overlay | Rule overlay |
| ------------- | ---------- | ------------- | -------------- | ------------ |
| `discovery.md` | (none) | `planner`, `repository_explorer` | skill Read pointers | — |
| `iterative-plan-review.md` | `skills/implementation-plan/SKILL.md` | `plan_reviewer` | overlay plan SKILL | `iterative-plan-review.mdc` |
| `iterative-code-review.md` | `skills/implementation-review/SKILL.md` | `production_readiness_reviewer`, `bug_reviewer` | review SKILL + `reviewer-a.md` | `iterative-code-review.mdc` |
| `ci-ladder.md` | `implementation-review`, `rules/pre-commit-ci-gate.md` | implementer (parent) | review skill Read | `pre-commit-ci-gate.mdc` |
| `plan-agent-context.md` | `implementation-plan` | `plan_reviewer` | plan skill Read | — |
| `phased-multi-agent.md` | `composer`, `roadmap` | planner / implementer as conductor | `composer/SKILL.md` | — |
| `documentation-architecture.md` | `documentation-architecture` | — | that SKILL.md | — |

Repo product/architecture docs and multi-phase roadmaps live **in the repo**, not here.
