---
name: discovery
description: >-
  Discover repository documentation hubs before non-trivial planning or
  implementation. Use before drafting plans or judging architecture alignment.
---

# Discovery

Find the target repo's docs before edits. Do not invent parallel doc trees.

## When to use

Before any non-trivial plan or implementation. First step of `implementation-plan`.

## Steps

1. **Step 0** — If `.cursor/skills/reference-docs/SKILL.md` (or host equivalent) exists in the target repo, follow it.
2. **Fallback** — README, AGENTS.md, CONTRIBUTING, `.cursor/rules`, `docs/` indexes, Roadmap.
3. Record applicable paths for the plan and reviewers.
4. Note when the doc tree is sparse.

## Read when

| Doc | When |
|-----|------|
| [discovery.md](../../docs/workflow/discovery.md) | Full discovery procedure |
| [README.md](../../docs/workflow/README.md) | Workflow doc index |

## Must not

- Invent required parallel documentation trees
- Skip discovery on unfamiliar repos
- Treat `docs/research/imported/` Observed paths as Target product homes

## Related agents

`planner`, `implementer`, `repository_explorer`
