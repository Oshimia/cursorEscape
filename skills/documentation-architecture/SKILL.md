---
name: documentation-architecture
description: >-
  Bootstrap or extend repository documentation using a procedures-vs-design
  layout. Use when creating new docs areas, standardizing an under-documented
  repo, or when the user asks for SOPs / feature architecture structure. Follow
  existing layouts when present; do not invent parallel trees.
disable-model-invocation: true
---

# Documentation architecture

Lean entry point. **Full detail:** [documentation-architecture.md](../../workflow/documentation-architecture.md)

Absolute fallback: `C:/Users/admin/.cursor/` workflow mirror — see [documentation-architecture.md](../../workflow/documentation-architecture.md) in-repo.

## Instructions

1. Run [discovery.md](../../workflow/discovery.md) (Step 0 local `reference-docs` if present).
2. If the repo already has a coherent docs layout → **follow it**. Map procedures vs design onto existing folders.
3. If greenfield / user asks to adopt defaults → bootstrap under the docs root (or create `docs/`):

   - `SOPs/_index.md` — how-tos
   - `featureArchitecture/_index.md` — design/behavior
   - `roadmaps/` — multi-phase handoffs (see [`roadmap`](../roadmap/SKILL.md) skill)

4. New or changed patterns: update docs + indexes in the **same changeset** as code.
5. Do not force `SOPs` / `featureArchitecture` names onto a repo that already chose differently.
6. When authoring new skills, companions, contracts, or agent-facing docs, run the [agent-documentation rubric](../../workflow/documentation-architecture.md#agent-documentation-rubric-writing-for-agents) pass.

---

## Related

**Skills:** [`roadmap`](../roadmap/SKILL.md), [`implementation-plan`](../implementation-plan/SKILL.md), [`composer`](../composer/SKILL.md)

**Workflow docs:** [documentation-architecture.md](../../workflow/documentation-architecture.md), [discovery.md](../../workflow/discovery.md), [phased-multi-agent.md](../../workflow/phased-multi-agent.md), [_index.md](../../workflow/_index.md)
