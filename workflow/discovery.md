# Repo documentation discovery

Used by all global workflow skills. **Never invent a required doc tree.**

## Step 0 — local reference-docs skill

If `.cursor/skills/reference-docs/SKILL.md` exists in the active repo, **follow it** before any code change. That skill owns repo-specific indexes and paths.

## Fallback (skip missing)

1. `AGENTS.md` / `CLAUDE.md` / root `README.md` / `CONTRIBUTING.md`
2. Project `.cursor/rules/**`
3. Common docs roots if present: `docs/`, `documentation/`, `referenceFiles/`, or paths named in README
4. Indexes only if present (e.g. `**/SOPs/_index.md`, `**/featureArchitecture/_index.md`, or equivalents)
5. User hints and paths listed in the active roadmap

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

## Related skills

- [implementation-plan](../docs/skills/implementation-plan.md)
- [implementation-review](../docs/skills/implementation-review.md)
- [composer](../docs/skills/composer.md)
- [roadmap](../docs/skills/roadmap.md)
- [documentation-architecture](../docs/skills/documentation-architecture.md)
