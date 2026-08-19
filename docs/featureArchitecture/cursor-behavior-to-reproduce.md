# Cursor Behavior to Reproduce

**Last updated:** 2026-08-20

## Context

This document lists **Observed** Cursor behaviors worth preserving in a portable form — not a full IDE clone. Sources: imported openBuggy Cursor BugBot FA suite and live workflow imports. First recreation maps these to **OpenCode** agents/skills (optional **T3** UI). Classify each item; cite imports rather than re-paste long excerpts.

---

## Substance

### Review loop orchestration (Required to reproduce as semantics)

| Observed behavior | Source | Target mapping |
| ----------------- | ------ | -------------- |
| Parent runs Fast CI once per iteration; reviewers do not re-run CI | [orchestration-and-review-loops](../../research/imported/openBuggy/featureArchitecture/cursor-bugbot-agent-review/orchestration-and-review-loops.md) | Review-loop parent (OpenCode primary) |
| Parallel launch of both review legs | Same | **Required** — two OpenCode Task calls |
| Explicit diff scope: branch vs uncommitted | [invocation-contract](../../research/imported/openBuggy/featureArchitecture/cursor-bugbot-agent-review/invocation-contract.md) | **Desired** for bug_reviewer (prompt input) |
| Custom Instructions on bug leg; locked opener on production-readiness leg | [custom-instructions angle](../../research/imported/openBuggy/analysis/reviewer-effectiveness/angles/custom-instructions.md) | **Required** pattern |
| Empty finding lists = clean for Bugbot bar | openBuggy FA overview | bug_reviewer verdict |

### Agent navigation (Desired — not index parity)

| Observed behavior | Source | Target stance |
| ----------------- | ------ | ------------- |
| Read / Grep / Glob over workspace | [tooling-and-navigation](../../research/imported/openBuggy/featureArchitecture/cursor-bugbot-agent-review/tooling-and-navigation.md) | **Desired** via OpenCode tools |
| Follow imports and callers from changed files | Same | **Desired** — see [repository discovery](./repository-discovery-and-context.md) |
| No guarantee of whole-repo embedding | Same | **Required** — tight caps |

### Plan / review skills (Required semantics)

| Observed behavior | Source | Delta note |
| ----------------- | ------ | ---------- |
| implementation-plan → plan-reviewer loop | Live [implementation-plan](../../overlays/cursor/skills/implementation-plan/SKILL.md) | Prefer live overlay over freeze; companion repo owns Target loop semantics |
| implementation-review Fast → dual → Full | Live [implementation-review](../../overlays/cursor/skills/implementation-review/SKILL.md) | Freeze lacks Fast/Full split ([delta](../../research/imported/workflow-source-delta.md)) |
| Composer phase conductor | Live [composer](../../overlays/cursor/skills/composer/SKILL.md) | **Cursor-specific** optional |
| Thin User Rules snippets + on-demand skills (`disable-model-invocation`) + deep `docs/workflow` | Live [user-rules-snippet](../../overlays/cursor/skills/implementation-review/user-rules-snippet.md) + SKILL.md frontmatter | **Required** portable pattern — [instruction layering](./instruction-layering.md); Observed bloated agent files are **not** the agent-layer ideal |
| Isolated subagent context; parent packs invoke; no prior review transcripts | Live [plan-reviewer](../../overlays/cursor/agents/plan-reviewer.md) / [reviewer-a](../../overlays/cursor/agents/reviewer-a.md) opener lines | **Required** — [clean-context isolation](./clean-context-isolation.md) |
| Deferred pre-commit Full gate (`alwaysApply: false`) | Live [pre-commit-ci-gate.mdc](../../overlays/cursor/rules/pre-commit-ci-gate.mdc) | **Required** semantics — [pre-commit-ci-gate](../skills/pre-commit-ci-gate.md) |

### Behaviors explicitly not to reproduce

| Observed | Why not |
| -------- | ------- |
| Cursor-only `bugbot` subagent type | Use OpenCode `bug_reviewer` agent + skills |
| Require openBuggy engine for v0 | Research / optional later — [design decisions](../../review/design-decisions.md) |
| Proprietary deep links / PR bot in v0 | [ide-and-agent-integration](../../research/imported/openBuggy/featureArchitecture/ide-and-agent-integration.md) non-goals |
| Freeze eval `REVIEW_LOOP.md` unified APPROVED bar | Eval-packaging only |
| Hardcoded streaming-media npm CI gate | Domain-specific freeze artifact |

---

## Implications / open questions

1. **Unknown:** Minimum tool surface for repository_explorer to match practical Cursor navigation quality.
2. Reproduce **gates and contracts**, not Cursor UI chrome or internal index implementation.

---

## Related

- [Desired behavior vs Cursor-specific](./desired-behavior-vs-cursor-specific.md)
- [Intended workflow](./intended-workflow.md)
- [Instruction layering](./instruction-layering.md)
- [Clean context and isolation](./clean-context-isolation.md)
- [Imported BugBot FA index](../../research/imported/openBuggy/featureArchitecture/cursor-bugbot-agent-review/_index.md)
