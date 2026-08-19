---
name: discovery
description: >-
  Discover repository documentation hubs before non-trivial planning or
  implementation. Use before drafting plans or judging architecture alignment.
---

# Discovery

Find the target repo's docs before edits. Do not invent parallel doc trees.

## When to use

Before any non-trivial plan or implementation. First step of [`implementation-plan`](../implementation-plan/SKILL.md).

## Steps

1. **Step 0** — If a project-local doc-index skill exists in the **target/active repo**, follow it (see [discovery.md](../../workflow/discovery.md) for Cursor vs OpenCode paths).
2. **Fallback** — README, AGENTS.md, CONTRIBUTING, rules, `docs/` indexes, roadmap.
3. Record applicable paths for the plan and reviewers.
4. Note when the doc tree is sparse.

## Read when

| Doc | When |
|-----|------|
| [discovery.md](../../workflow/discovery.md) | Full discovery procedure (Step 0 + fallback + Must not) |
| [_index.md](../../workflow/_index.md) | Workflow doc index |

## Must not

Full portable list: [discovery.md](../../workflow/discovery.md) § Must not. Do not duplicate here.

## Related agents

[`planner`](../../agents/planner.md), [`implementer`](../../agents/implementer.md), [`repository_explorer`](../../agents/repository_explorer.md)
