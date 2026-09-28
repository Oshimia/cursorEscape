# Repo documentation discovery

Used by all global workflow skills. **Never invent a required doc tree.**

## Step 0 — project-local doc-index skill (host-aware)

In the **target/active repo** (the repo you are changing — not the global adapter tree), if a project-local doc-index skill exists, **follow it** before any code change. That skill owns repo-specific indexes and paths.

| Host / layout | Step 0 path (target repo) |
| ------------- | ------------------------- |
| **Cursor** | `.cursor/skills/reference-docs/SKILL.md` |
| **OpenCode** | Same Cursor-shaped path when present, **or** `.opencode/skills/reference-docs/SKILL.md`, **or** another project skill path named in the target repo's `AGENTS.md` / README as owning doc indexes |
| **Eval freeze** | When evaluating freeze baselines (for example, archived AITestSuite packaging), follow the target repo's packaged baseline reference-docs skill; treat archived examples as external evidence, not in-repo contracts |

Do **not** substitute the global adapter's [`discovery`](../skills/discovery/SKILL.md) skill for a target repo's own reference-docs procedure. If Step 0 finds nothing, use Fallback below.

## Fallback (skip missing)

1. `AGENTS.md` / `CLAUDE.md` / root `README.md` / `CONTRIBUTING.md`
2. **When the target repo is this companion (cursorEscape):** also read [`docs/SOPs/editing-companion-workflow.md`](../docs/SOPs/editing-companion-workflow.md) before non-trivial edits to `workflow/`, `skills/`, `agents/`, `rules/`, or `overlays/` (Approach A + pointer-first cascade). Skip this step when editing a different product repo.
3. Project `.cursor/rules/**`
4. Common docs roots if present: `docs/`, `documentation/`, `referenceFiles/`, or paths named in README
5. Indexes only if present (e.g. `**/SOPs/_index.md`, `**/featureArchitecture/_index.md`, or equivalents)
6. User hints and paths listed in the active roadmap

## Workflow process (any repo)

When the repo has no process SOPs, read these workflow docs for plan/review/Composer expectations only — not for product architecture:

- [_index.md](_index.md) — full index
- [iterative-plan-review.md](iterative-plan-review.md)
- [iterative-code-review.md](iterative-code-review.md)
- [phased-multi-agent.md](phased-multi-agent.md)
- [plan-agent-context.md](plan-agent-context.md)
- [ci-ladder.md](ci-ladder.md)
- [documentation-architecture.md](documentation-architecture.md)

Repo root: `workflow/` (this file). Live Cursor copy-out: `~/.cursor/docs/workflow/`.

## Must not

- Invent required or parallel documentation trees
- Skip discovery on unfamiliar repos before non-trivial plan or implementation work

## Related skills

- [discovery](../skills/discovery/SKILL.md)
- [implementation-plan](../skills/implementation-plan/SKILL.md)
- [implementation-review](../skills/implementation-review/SKILL.md)
- [composer](../skills/composer/SKILL.md)
- [roadmap](../skills/roadmap/SKILL.md)
- [documentation-architecture](../skills/documentation-architecture/SKILL.md)

## Related agents

- [planner](../agents/planner.md)
- [implementer](../agents/implementer.md)
- [repository_explorer](../agents/repository_explorer.md)
