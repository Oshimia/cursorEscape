# Cursor overlay — copy-out map

**Last updated:** 2026-08-20  
**Status:** Phase 5 thin wrappers (gold bases at repo-root `workflow/`, `skills/`, `agents/`, `rules/`).

## Context

Thin **Cursor host overlay** for copy-out to `~/.cursor/`. Portable procedure lives at repo-root gold bases — overlay files add YAML, `disable-model-invocation`, Cursor Task spawn blocks, and copy-out-relative Read tables only.

Live `~/.cursor` is **not** overwritten from this repo. Copy-out is **not authorized** unless the owner manually syncs.

## Workflow path mismatch (copy-out)

| Location | Deep workflow docs |
| -------- | ------------------ |
| **This repo (SoT)** | [`workflow/_index.md`](../../workflow/_index.md) |
| **Live Cursor (copy-out)** | `~/.cursor/docs/workflow/` |

Overlay Read tables may cite `C:/Users/admin/.cursor/docs/workflow/` as copy-out fallback. In-repo navigation uses repo-root `workflow/`. Do not mix copy-out paths into gold base files.

## Copy-out map

| Copy to `~/.cursor/` | Overlay source | Points at (repo gold) |
| --------------------- | -------------- | --------------------- |
| `skills/implementation-plan/SKILL.md` | [skills/implementation-plan/SKILL.md](./skills/implementation-plan/SKILL.md) | [skills/implementation-plan/SKILL.md](../../skills/implementation-plan/SKILL.md), spawn + [workflow/](../../workflow/_index.md) |
| `skills/implementation-review/SKILL.md` | [skills/implementation-review/SKILL.md](./skills/implementation-review/SKILL.md) | [skills/implementation-review/SKILL.md](../../skills/implementation-review/SKILL.md), spawn + workflow |
| `skills/composer/SKILL.md` | [skills/composer/SKILL.md](./skills/composer/SKILL.md) | [skills/composer/SKILL.md](../../skills/composer/SKILL.md), Task spawn |
| `skills/roadmap/SKILL.md` | [skills/roadmap/SKILL.md](./skills/roadmap/SKILL.md) | [skills/roadmap/SKILL.md](../../skills/roadmap/SKILL.md) |
| `skills/documentation-architecture/SKILL.md` | [skills/documentation-architecture/SKILL.md](./skills/documentation-architecture/SKILL.md) | [skills/documentation-architecture/SKILL.md](../../skills/documentation-architecture/SKILL.md) |
| `skills/*/user-rules-snippet.md` | overlay only (paste targets) | [rules/](../../rules/) — not copied under repo `skills/` |
| `agents/plan-reviewer.md` | [agents/plan-reviewer.md](./agents/plan-reviewer.md) | [agents/plan_reviewer.md](../../agents/plan_reviewer.md) |
| `agents/reviewer-a.md` | [agents/reviewer-a.md](./agents/reviewer-a.md) | [agents/production_readiness_reviewer.md](../../agents/production_readiness_reviewer.md) |
| `rules/*.mdc` | [rules/](./rules/) | [rules/](../../rules/) |
| `review-subagent-models.md` | [review-subagent-models.md](./review-subagent-models.md) | overlay-only (model slugs) |

There is no owner-authored `bugbot` agent file; Bugbot is a Cursor product subagent. Spawn recipe: [implementation-review overlay SKILL](./skills/implementation-review/SKILL.md).

### Name map (index only)

| Cursor overlay | Portable base |
| -------------- | --------------- |
| `plan-reviewer` | `plan_reviewer` |
| `reviewer-a` | `production_readiness_reviewer` |
| Bugbot | `bug_reviewer` (Target contract only) |

## Skills

| Skill | Files |
| ----- | ----- |
| implementation-plan | [SKILL.md](./skills/implementation-plan/SKILL.md), [user-rules-snippet.md](./skills/implementation-plan/user-rules-snippet.md) |
| implementation-review | [SKILL.md](./skills/implementation-review/SKILL.md), [user-rules-snippet.md](./skills/implementation-review/user-rules-snippet.md) |
| composer | [SKILL.md](./skills/composer/SKILL.md), [user-rules-snippet.md](./skills/composer/user-rules-snippet.md) |
| documentation-architecture | [SKILL.md](./skills/documentation-architecture/SKILL.md) |
| roadmap | [SKILL.md](./skills/roadmap/SKILL.md) |

## Rules

| Rule | Overlay | Base |
| ---- | ------- | ---- |
| iterative-plan-review | [iterative-plan-review.mdc](./rules/iterative-plan-review.mdc) | [iterative-plan-review.md](../../rules/iterative-plan-review.md) |
| iterative-code-review | [iterative-code-review.mdc](./rules/iterative-code-review.mdc) | [iterative-code-review.md](../../rules/iterative-code-review.md) |
| pre-commit-ci-gate | [pre-commit-ci-gate.mdc](./rules/pre-commit-ci-gate.mdc) | [pre-commit-ci-gate.md](../../rules/pre-commit-ci-gate.md) |

## Agents

| Agent | Overlay | Base |
| ----- | ------- | ---- |
| plan-reviewer | [plan-reviewer.md](./agents/plan-reviewer.md) | [plan_reviewer.md](../../agents/plan_reviewer.md) |
| reviewer-a | [reviewer-a.md](./agents/reviewer-a.md) | [production_readiness_reviewer.md](../../agents/production_readiness_reviewer.md) |

## Provenance

Fat Observed extract (2026-08-20) promoted to gold bases in Phase 4. Phase 5 replaced overlay bodies with thin wrappers; **SHA256 byte-identical tables retired** (no longer a freeze target).

Refresh copy-out by re-copying from live `~/.cursor` when authorized; update this index — do not claim live install tracks git automatically.

## Related

- [Overlays index](../_index.md)
- [Skills index](../../skills/_index.md)
- [Agents index](../../agents/_index.md)
- [Workflow index](../../workflow/_index.md)
- [Skill source and host overlays](../../docs/featureArchitecture/skill-source-and-host-overlays.md)
- [Phase 3 import (bannered)](../../research/imported/cursor-global-workflow/)
