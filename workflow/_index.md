# Workflow docs (shared deep procedure)

**Last updated:** 2026-08-21

**Ownership:** Process changes land here first. Repo SOPs may extend with local paths; they must not contradict this core.

Repo root: `workflow/` (this tree). Live Cursor install: `~/.cursor/docs/workflow/` (copy-out only — not overwritten from this repo).

## Docs

| Doc | Purpose |
|-----|---------|
| [discovery.md](discovery.md) | How to find repo docs (Step 0 + fallback) |
| [documentation-architecture.md](documentation-architecture.md) | Default layout when bootstrapping **new** docs |
| [phased-multi-agent.md](phased-multi-agent.md) | Large multi-phase handoffs + roadmap shape |
| [plan-agent-context.md](plan-agent-context.md) | Escalation field + Agent context headings (escalated plans only) |
| [plan-reviewer-report.md](plan-reviewer-report.md) | Plan-reviewer output schema (limits, severity, exact report structure) |
| [iterative-plan-review.md](iterative-plan-review.md) | Plan → plan-reviewer loop |
| [iterative-code-review.md](iterative-code-review.md) | Per-phase Reviewer A + Bugbot loop |
| [ci-ladder.md](ci-ladder.md) | Fast/Full CI discovery for any repo |
| [tdd-tests.md](tdd-tests.md) | Test-first guidance: agreed seams, red-green slices, independent oracles |
| [tdd-mocking.md](tdd-mocking.md) | Mocking guidance: boundary-only doubles, fakes and in-memory adapters |
| [grilling.md](grilling.md) | Pre-plan alignment interview: design tree, frontier rounds, confirmation gate |

Cursor-only: [review-subagent-models.md](../overlays/cursor/review-subagent-models.md) (recommended reviewer models; overlay-only).

## Skills

| Skill | Path |
|-------|------|
| [discovery](../skills/discovery/SKILL.md) | Repo doc discovery (Step 0 + fallback) |
| [plan-review](../skills/plan-review/SKILL.md) | Plan → plan-reviewer loop gate |
| [implementation-plan](../skills/implementation-plan/SKILL.md) | Plan drafting + Incomplete until SoT |
| [implementation-review](../skills/implementation-review/SKILL.md) | Per-phase Reviewer A + Bugbot |
| [composer](../skills/composer/SKILL.md) | Phased execution conductor |
| [roadmap](../skills/roadmap/SKILL.md) | Repo multi-phase handoff files |
| [documentation-architecture](../skills/documentation-architecture/SKILL.md) | Bootstrap/extend repo docs layout |
| [codebase-design](../skills/codebase-design/SKILL.md) | Portable deep-module design reference |
| [tdd](../skills/tdd/SKILL.md) | Test-first reference discipline at agreed seams |
| [grilling](../skills/grilling/SKILL.md) | Pre-plan alignment interview primitive |

## Agents

| Display name | Portable contract | Role |
|--------------|-------------------|------|
| plan-reviewer | [plan_reviewer](../agents/plan_reviewer.md) | Adversarial plan review |
| reviewer-a | [production_readiness_reviewer](../agents/production_readiness_reviewer.md) | Production-readiness code review |
| Bugbot | [bug_reviewer](../agents/bug_reviewer.md) | Cursor product subagent (no owner-authored overlay file) |

## Rules

| Rule | Path |
| ---- | ---- |
| iterative-plan-review | [rules/iterative-plan-review.md](../rules/iterative-plan-review.md) |
| iterative-code-review | [rules/iterative-code-review.md](../rules/iterative-code-review.md) |
| pre-commit-ci-gate | [rules/pre-commit-ci-gate.md](../rules/pre-commit-ci-gate.md) |

## Used-by matrix

| Workflow leaf | Base skill | Base agent(s) | Cursor overlay | Rule overlay |
| ------------- | ---------- | ------------- | -------------- | ------------ |
| `discovery.md` | `skills/discovery/SKILL.md` | `planner`, `implementer`, `repository_explorer` | overlay discovery SKILL (Phase 2) | — |
| `iterative-plan-review.md` | `skills/plan-review/SKILL.md`, `skills/implementation-plan/SKILL.md` | `plan_reviewer` | overlay plan SKILL | `iterative-plan-review.mdc` |
| `plan-reviewer-report.md` | `skills/plan-review/SKILL.md`, `skills/implementation-plan/SKILL.md` | `plan_reviewer` | — | — |
| `iterative-code-review.md` | `skills/implementation-review/SKILL.md` | `production_readiness_reviewer`, `bug_reviewer` | review SKILL + `reviewer-a.md` | `iterative-code-review.mdc` |
| `ci-ladder.md` | `implementation-review`, `rules/pre-commit-ci-gate.md` | implementer (parent) | review skill Read | `pre-commit-ci-gate.mdc` |
| `plan-agent-context.md` | `implementation-plan` | `plan_reviewer` | plan skill Read | — |
| `phased-multi-agent.md` | `composer`, `roadmap` | planner / implementer as conductor | `composer/SKILL.md` | — |
| `documentation-architecture.md` | `documentation-architecture` | — | that SKILL.md | — |
| `tdd-tests.md` | `skills/tdd/SKILL.md` | implementer guidance cites directly (advisory) | — | — |
| `tdd-mocking.md` | `skills/tdd/SKILL.md` | implementer guidance cites directly (advisory) | — | — |
| `grilling.md` | `skills/grilling/SKILL.md` | planner / implementer / implementation-plan may consult (advisory) | — | — |

Repo product/architecture docs and multi-phase roadmaps live **in the repo**, not here.
