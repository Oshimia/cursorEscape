---
name: documentation-architecture
description: >-
  Bootstrap or extend repository documentation with procedures-vs-design
  layout. Use when creating new docs areas or standardizing an under-documented
  repo — follow existing coherent layouts instead of inventing parallel trees.
---

# Documentation architecture

Lean entry → deep doc. Prefer existing repo layout when coherent.

## When to use

New docs areas; user asks for SOPs / featureArchitecture; under-documented repo.

## When not

Repo already has a coherent docs layout — **follow it**.

## Steps

1. Load skill `discovery`.
2. If coherent layout exists → extend it; map procedures vs design onto existing folders.
3. If greenfield: bootstrap `docs/SOPs/`, `docs/featureArchitecture/`, `docs/roadmaps/` with `_index.md` hubs (or repo-equivalent names).
4. New leaves: update indexes in the **same** changeset.

## Read when

| Doc | When |
|-----|------|
| [documentation-architecture.md](docs/workflow/documentation-architecture.md) | Full bootstrap procedure |
| [discovery.md](docs/workflow/discovery.md) | Find existing layout first |

## Must not

- Invent parallel trees beside a coherent layout
- Leave new leaves unlinked from indexes

## Related

skill `discovery`, skill `roadmap` (if present)
