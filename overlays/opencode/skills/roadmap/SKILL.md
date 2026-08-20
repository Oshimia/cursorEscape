---
name: roadmap
description: >-
  Create or update multi-phase handoff roadmaps as repository documentation
  (not under ~/.config/opencode). Resolves path via local convention or defaults
  to docs/roadmaps/<feature>.md. Use for large/complex phased work, Composer
  handoffs, or when restructuring an approved plan into per-phase Agent context.
---

# Roadmap (repo multi-phase handoff)

Roadmaps are **repo documentation**. Never write them under the OpenCode adapter tree.

## When to use

- Escalation **yes** plans (copy Agent context into the repo after accept)
- User assigns `composer` for multi-phase execution (**required**)
- Escalation **no** plans that later need Composer: restructure thin Incremental execution into Agent context (**no new scope**)

## Steps

1. Resolve path per deep doc (local convention → `docs/roadmaps/<feature>.md`).
2. Copy vs restructure per accepted plan Escalation (see deep doc).
3. Include Inter-phase contracts + per-phase Agent context headings.
4. Update status after each phase QC accept.

## Read when

| Doc | When |
|-----|------|
| [plan-agent-context.md](docs/workflow/plan-agent-context.md) | Escalation dual path + Agent context headings |
| [phased-multi-agent.md](docs/workflow/phased-multi-agent.md) | When to use, Composer handoff |
| [discovery.md](docs/workflow/discovery.md) | Find existing docs / roadmap conventions |
| [documentation-architecture.md](docs/workflow/documentation-architecture.md) | Default `docs/roadmaps/` layout when bootstrapping |
| [README.md](docs/workflow/README.md) | Workflow doc index |

## Must not

- Store roadmaps under `~/.config/opencode` or the adapter skills tree
- Invent scope not in the accepted plan when Escalation was **yes**

## Related

skill `composer`, skill `implementation-plan`, skill `implementation-review`, skill `documentation-architecture`
