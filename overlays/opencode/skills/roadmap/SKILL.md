---
name: roadmap
description: >-
  Create or update multi-phase handoff roadmaps as repository documentation
  (not under ~/.config/opencode). Resolves path via local convention or defaults
  to docs/roadmaps/<feature>.md. Use for large/complex phased work, Composer
  handoffs, or when restructuring an approved plan into per-phase Agent context.
---

# Roadmap (OpenCode harness)

Thin harness. Full procedure: Read `{{COMPANION_ROOT}}/skills/roadmap/SKILL.md`.

Roadmaps are **repo documentation**. Never write them under the OpenCode adapter tree.

## When to use

- Escalation **yes** plans (copy Agent context into the repo after accept)
- User assigns `composer` for multi-phase execution (**required**)
- Escalation **no** plans that later need Composer: restructure thin Incremental execution into Agent context (**no new scope**)

## Steps

1. Read companion skill for path resolution and copy vs restructure rules.
2. Include Inter-phase contracts + per-phase Agent context headings.
3. Update status after each phase QC accept.

## Read when

| Doc | When |
|-----|------|
| [SKILL.md]({{COMPANION_ROOT}}/skills/roadmap/SKILL.md) | Full procedure |
| [plan-agent-context.md]({{COMPANION_ROOT}}/workflow/plan-agent-context.md) | Escalation dual path + Agent context headings |
| [phased-multi-agent.md]({{COMPANION_ROOT}}/workflow/phased-multi-agent.md) | When to use, Composer handoff |
| [discovery.md]({{COMPANION_ROOT}}/workflow/discovery.md) | Find existing docs / roadmap conventions |
| [documentation-architecture.md]({{COMPANION_ROOT}}/workflow/documentation-architecture.md) | Default `docs/roadmaps/` layout |
| [_index.md]({{COMPANION_ROOT}}/workflow/_index.md) | Workflow doc index |

## Must not

- Store roadmaps under `~/.config/opencode` or the adapter skills tree
- Use host `docs/workflow/` as procedure SoT

## Related

skill `composer`, skill `implementation-plan`, skill `implementation-review`, skill `documentation-architecture`
