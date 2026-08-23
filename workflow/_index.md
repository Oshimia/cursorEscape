# Workflow docs (shared deep procedure)

**Last updated:** 2026-08-23

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
| [code-review-frame.md](code-review-frame.md) | Optional Standards/Spec evidence frame for the dual review gate |
| [grilling.md](grilling.md) | Pre-plan alignment interview: design tree, frontier rounds, confirmation gate |
| [diagnosing-bugs.md](diagnosing-bugs.md) | Shipped-code diagnosis loop: red gate, minimise, ranked hypotheses, redaction, cleanup |
| [research.md](research.md) | Bounded primary-source research: one question, one packed read-only child, cited artifact |
| [domain-modeling.md](domain-modeling.md) | Shared-language discipline: term challenges, scenarios, code cross-checks, three-part decision test |
| [architecture-survey.md](architecture-survey.md) | Guided read-only improvement survey: candidate cards with options and inaction costs, owner selection |
| [prototype.md](prototype.md) | Question-first throwaway prototypes: logic modules or UI variants on disposable paths with explicit disposition |
| [wizard.md](wizard.md) | Human-only procedure generation: value matrix by source/destination/sensitivity/stage, static validation only |
| [handoff.md](handoff.md) | Portable user-invoked conversation handoff: redacted artifact, references over duplication, recipient revalidation |
| [teach.md](teach.md) | Dedicated opt-in Markdown learning workspace: mission, cited resources, small lessons, retrieval records |
| [resolving-merge-conflicts.md](resolving-merge-conflicts.md) | Active merge/rebase conflict resolution: state safety, hunk-by-hunk intent tracing, verification, owner-owned finish |

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
| [research](../skills/research/SKILL.md) | Bounded cited external-research loop |
| [domain-modeling](../skills/domain-modeling/SKILL.md) | Opt-in shared-language discipline |
| [architecture-survey](../skills/architecture-survey/SKILL.md) | Guided architecture decision survey |
| [prototype](../skills/prototype/SKILL.md) | Question-first disposable prototype pattern |
| [wizard](../skills/wizard/SKILL.md) | Human-only interactive-script generation |
| [diagnosing-bugs](../skills/diagnosing-bugs/SKILL.md) | User-invoked shipped-code diagnosis loop |
| [teach](../skills/teach/SKILL.md) | Owner-invoked isolated learning workspace |
| [resolving-merge-conflicts](../skills/resolving-merge-conflicts/SKILL.md) | User-invoked conflict resolution with intent-traced hunks |

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
| `tdd-mocking.md` | `skills/tdd/SKILL.md` | via tdd skill companions (advisory) | — | — |
| `grilling.md` | `skills/grilling/SKILL.md` | planner / implementer / implementation-plan may consult (advisory) | — | — |
| `code-review-frame.md` | `skills/implementation-review/SKILL.md` | `production_readiness_reviewer`, `bug_reviewer` (opt-in framing) | review SKILL Read | — |
| `diagnosing-bugs.md` | `skills/diagnosing-bugs/SKILL.md` | planner / implementer may consult (advisory) | — | — |
| `research.md` | `skills/research/SKILL.md` | packed read-only child (clean-context isolation) | — | — |
| `domain-modeling.md` | `skills/domain-modeling/SKILL.md` | planner / implementer may consult (advisory) | — | — |
| `architecture-survey.md` | `skills/architecture-survey/SKILL.md` | `repository_explorer` may support exploration (advisory) | — | — |
| `prototype.md` | `skills/prototype/SKILL.md` | none (caller-owned build and disposition) | — | — |
| `wizard.md` | `skills/wizard/SKILL.md` | none (owner runs generated scripts) | — | — |
| `handoff.md` | none (caller-owned artifact) | composer consumes via cross-pointer | — | — |
| `teach.md` | `skills/teach/SKILL.md` | none (owner-invoked learning workspace) | — | — |
| `resolving-merge-conflicts.md` | `skills/resolving-merge-conflicts/SKILL.md` | implementer may consult during active conflict work (owner-invoked) | — | — |

Repo product/architecture docs and multi-phase roadmaps live **in the repo**, not here.
