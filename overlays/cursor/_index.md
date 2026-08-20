# Cursor overlay — copy-out map

**Last updated:** 2026-08-21  
**Status:** pointer-first live sync **applied** 2026-08-21 — thin skills/agents + hybrid rules on `~/.cursor`. Backup: `C:/Users/admin/.cursor-backup-pre-pointer-sync-20260821-002858`.

## Context

Thin **Cursor host overlay** for copy-out to `~/.cursor/`. Portable procedure lives at repo-root bases — overlay files add YAML, `disable-model-invocation`, Cursor Task spawn blocks, and **absolute companion Read tables** (`{{COMPANION_ROOT}}/…`).

**Live sync (2026-08-21):** Operator-authorized copy-out applied (skills, agents, `review-subagent-models.md`, hybrid rules). `docs/workflow/` mirror **retained** (transitional). See [cursor-host-adapter](../../docs/SOPs/cursor-host-adapter.md).

## Companion reachability (pointer-first Target)

| Location | Deep procedure load path |
| -------- | ------------------------ |
| **Companion SoT** | `{{COMPANION_ROOT}}/workflow/`, `skills/`, `agents/`, `rules/` |
| **Overlay harness (author-time)** | Read tables cite `{{COMPANION_ROOT}}/…` — **not** repo-relative hops |
| **Live Cursor (2026-08-21)** | Thin skills/agents with absolute companion Reads; **hybrid** `.mdc` rules (companion gate body); `docs/workflow/` mirror retained — **not SoT** |

On copy-out: merge `{{COMPANION_ROOT}}` → absolute path to this repo (e.g. `C:/Users/admin/source/repos/general-projects/cursorEscape`). Required when **workspace ≠ cursorEscape**.

**Rules hybrid script:** [scripts/Write-HybridCursorRules.ps1](./scripts/Write-HybridCursorRules.ps1) — do not overwrite live rules with thin-pointer-only overlay `.mdc`.

## Copy-out map

| Copy to `~/.cursor/` | Overlay source | Points at (companion base) |
| --------------------- | -------------- | -------------------------- |
| `skills/implementation-plan/SKILL.md` | [skills/implementation-plan/SKILL.md](./skills/implementation-plan/SKILL.md) | `{{COMPANION_ROOT}}/skills/implementation-plan/SKILL.md` + workflow |
| `skills/implementation-review/SKILL.md` | [skills/implementation-review/SKILL.md](./skills/implementation-review/SKILL.md) | `{{COMPANION_ROOT}}/skills/implementation-review/SKILL.md` + workflow |
| `skills/composer/SKILL.md` | [skills/composer/SKILL.md](./skills/composer/SKILL.md) | `{{COMPANION_ROOT}}/skills/composer/SKILL.md` |
| `skills/roadmap/SKILL.md` | [skills/roadmap/SKILL.md](./skills/roadmap/SKILL.md) | `{{COMPANION_ROOT}}/skills/roadmap/SKILL.md` |
| `skills/documentation-architecture/SKILL.md` | [skills/documentation-architecture/SKILL.md](./skills/documentation-architecture/SKILL.md) | `{{COMPANION_ROOT}}/skills/documentation-architecture/SKILL.md` |
| `skills/*/user-rules-snippet.md` | overlay only (paste targets) | `{{COMPANION_ROOT}}/rules/` — not copied under repo `skills/` |
| `agents/plan-reviewer.md` | [agents/plan-reviewer.md](./agents/plan-reviewer.md) | `{{COMPANION_ROOT}}/agents/plan_reviewer.md` |
| `agents/reviewer-a.md` | [agents/reviewer-a.md](./agents/reviewer-a.md) | `{{COMPANION_ROOT}}/agents/production_readiness_reviewer.md` |
| `rules/*.mdc` | [rules/](./rules/) | `{{COMPANION_ROOT}}/rules/` (+ spawn blocks to host `skills/`) |
| `review-subagent-models.md` | [review-subagent-models.md](./review-subagent-models.md) | overlay leaf; companion cites in body |

There is no owner-authored `bugbot` agent file; Bugbot is a Cursor product subagent. Spawn recipe: [implementation-review overlay SKILL](./skills/implementation-review/SKILL.md).

### Name map (index only)

| Cursor overlay | Portable base |
| -------------- | --------------- |
| `plan-reviewer` | `plan_reviewer` |
| `reviewer-a` | `production_readiness_reviewer` |
| Bugbot | `bug_reviewer` (Target contract only) |

### Skills without Cursor overlay harness (by design)

| Portable skill | Cursor overlay | Notes |
| -------------- | -------------- | ----- |
| `discovery` | — | Loaded via `{{COMPANION_ROOT}}/workflow/discovery.md` from other harness stubs |
| `plan-review` | — | Plan loop via `implementation-plan` harness |
| `pre-commit-ci-gate` | [pre-commit-ci-gate.mdc](./rules/pre-commit-ci-gate.mdc) only | Rule surface, not skill advertisement |

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
| iterative-plan-review | [iterative-plan-review.mdc](./rules/iterative-plan-review.mdc) | `{{COMPANION_ROOT}}/rules/iterative-plan-review.md` |
| iterative-code-review | [iterative-code-review.mdc](./rules/iterative-code-review.mdc) | `{{COMPANION_ROOT}}/rules/iterative-code-review.md` |
| pre-commit-ci-gate | [pre-commit-ci-gate.mdc](./rules/pre-commit-ci-gate.mdc) | `{{COMPANION_ROOT}}/rules/pre-commit-ci-gate.md` |

## Agents

| Agent | Overlay | Base |
| ----- | ------- | ---- |
| plan-reviewer | [plan-reviewer.md](./agents/plan-reviewer.md) | `{{COMPANION_ROOT}}/agents/plan_reviewer.md` |
| reviewer-a | [reviewer-a.md](./agents/reviewer-a.md) | `{{COMPANION_ROOT}}/agents/production_readiness_reviewer.md` |

## Provenance

Fat Observed extract (2026-08-20) promoted to repo-root bases in Phase 4. Phase 5 replaced overlay bodies with thin wrappers; pointer-first-3 replaced wrong-base repo-relative hops with `{{COMPANION_ROOT}}` absolute Reads.

Refresh copy-out by re-copying from [overlays/cursor](./_index.md) when authorized; merge tokens per [cursor-host-adapter](../../docs/SOPs/cursor-host-adapter.md) — do not claim live install tracks git automatically.

## Related

- [Overlays index](../_index.md)
- [Cursor host adapter SOP](../../docs/SOPs/cursor-host-adapter.md)
- [Skills index](../../skills/_index.md)
- [Agents index](../../agents/_index.md)
- [Workflow index](../../workflow/_index.md)
- [Skill source and host overlays](../../docs/featureArchitecture/skill-source-and-host-overlays.md)
- [pointer-first roadmap](../../docs/roadmaps/pointer-first.md)
