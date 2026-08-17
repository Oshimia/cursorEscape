> **Imported research** — Source: live `~/.cursor`; copied 2026-08-17 into cursorEscape. Status: Observed/imported (live canonical for Target workflow). Do not treat as Target cursorEscape design unless a Target doc cites it.
---
name: roadmap
description: >-
  Create or update multi-phase handoff roadmaps as repository documentation
  (not under ~/.cursor). Resolves path via local convention or defaults to
  docs/roadmaps/<feature>.md. Use for large/complex phased work, Composer
  handoffs, or when restructuring an approved plan into per-phase Agent context.
disable-model-invocation: true
---

# Roadmap (repo multi-phase handoff)

Roadmaps are **repo documentation**. Never write them under `~/.cursor`.

**Read when authoring roadmaps:**

| Doc | When |
|-----|------|
| [plan-agent-context.md](../../docs/workflow/plan-agent-context.md) | Escalation dual path + Agent context headings |
| [phased-multi-agent.md](../../docs/workflow/phased-multi-agent.md) | When to use, Composer handoff |
| [discovery.md](../../docs/workflow/discovery.md) | Find existing docs / roadmap conventions |
| [documentation-architecture.md](../../docs/workflow/documentation-architecture.md) | Default `docs/roadmaps/` layout when bootstrapping |
| [README.md](../../docs/workflow/README.md) | Index of all workflow docs |

Absolute fallback: `C:/Users/admin/.cursor/docs/workflow/`.

## When to use

- Escalation **yes** plans (copy Agent context into the repo after accept)
- User assigns [`composer`](../composer/SKILL.md) for multi-phase execution (**required**)
- Escalation **no** plans that later need Composer: restructure thin Incremental execution into Agent context (**no new scope**)

Without Composer, a roadmap is **recommended** for large/complex work; ad-hoc chat-only multi-phase is allowed when the user skips.

## Location resolution (in order)

1. Path from local `reference-docs` skill, project rules, or an **existing** roadmap folder convention
2. Else if a docs root exists (`docs/`, `documentation/`, `referenceFiles/`, …) → `<that-root>/roadmaps/<feature>.md` (or keep an existing equivalent folder name if the repo already uses one)
3. Else → **`docs/roadmaps/<feature>.md`** (create folders as needed)

Do not hard-code any one repo’s folder name as a global requirement. See [discovery.md](../../docs/workflow/discovery.md).

## Copy vs restructure (from accepted plan Escalation)

| Escalation was | Behavior |
|----------------|----------|
| **yes** | **Copy** Inter-phase contracts + Agent context from the accepted plan. **Fail-closed** if contexts are missing or stub. **Never invent** scope, files, or CI commands that were not in the plan. |
| **no** | **May restructure** thin Incremental execution bullets into Agent context headings (schema in [plan-agent-context.md](../../docs/workflow/plan-agent-context.md)) **without adding new scope**. Do not invent new phases, files, or behaviors. |

If Composer is assigned and Escalation was **yes** but Agent context is missing/stub in the plan: **do not invent** — fail and send back to planning (`implementation-plan` + plan-reviewer).

## Required contents

| Section | Purpose |
|---------|---------|
| Status / last updated | Conductor and agents share state |
| Product decisions | Locked user choices |
| Inter-phase contracts | Must not drift silently |
| Migration / external apply order | When the repo has user-apply gates |
| Agent context — Phase N | Per phase — headings in [plan-agent-context.md](../../docs/workflow/plan-agent-context.md) |

Title example: `# Roadmap: <Human-readable feature name>`.

Optional: mirror todos in `.cursor/plans/`; keep in sync when the roadmap changes.

## Updates

- After each phase QC accept: update Status / checklist
- Contract changes: update Inter-phase contracts + affected Agent context in the **same** changeset

---

## Related

**Skills:** [`composer`](../composer/SKILL.md), [`implementation-plan`](../implementation-plan/SKILL.md), [`implementation-review`](../implementation-review/SKILL.md), [`documentation-architecture`](../documentation-architecture/SKILL.md)

**Workflow docs:** [plan-agent-context.md](../../docs/workflow/plan-agent-context.md), [phased-multi-agent.md](../../docs/workflow/phased-multi-agent.md), [discovery.md](../../docs/workflow/discovery.md), [documentation-architecture.md](../../docs/workflow/documentation-architecture.md), [iterative-code-review.md](../../docs/workflow/iterative-code-review.md), [README.md](../../docs/workflow/README.md)
