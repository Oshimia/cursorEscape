---
name: roadmap
description: >-
  Create or update multi-phase handoff roadmaps as repository documentation
  (not under the Antigravity adapter tree). Resolves path via local convention or defaults
  to docs/roadmaps/<feature>.md. Use for large/complex phased work, Composer
  handoffs, or when restructuring an approved plan into per-phase Agent context.
---

# Roadmap (Antigravity harness)

Thin harness. Full procedure: Read `C:/Users/admin/source/repos/general-projects/cursorEscape/skills/roadmap/SKILL.md`.

Roadmaps are **repo documentation**. Never write them under the Antigravity adapter tree (`~/.gemini`).

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
| [SKILL.md](C:/Users/admin/source/repos/general-projects/cursorEscape/skills/roadmap/SKILL.md) | Full procedure |
| [plan-agent-context.md](C:/Users/admin/source/repos/general-projects/cursorEscape/workflow/plan-agent-context.md) | Escalation dual path + Agent context headings |
| [phased-multi-agent.md](C:/Users/admin/source/repos/general-projects/cursorEscape/workflow/phased-multi-agent.md) | When to use, Composer handoff |
| [discovery.md](C:/Users/admin/source/repos/general-projects/cursorEscape/workflow/discovery.md) | Find existing docs / roadmap conventions |
| [documentation-architecture.md](C:/Users/admin/source/repos/general-projects/cursorEscape/workflow/documentation-architecture.md) | Default `docs/roadmaps/` layout |
| [_index.md](C:/Users/admin/source/repos/general-projects/cursorEscape/workflow/_index.md) | Workflow doc index |

## Must not

- Store roadmaps under `~/.gemini` or the adapter skills tree
- Use host `docs/workflow/` as procedure SoT

## Related

skill `composer`, skill `implementation-plan`, skill `implementation-review`, skill `documentation-architecture`
