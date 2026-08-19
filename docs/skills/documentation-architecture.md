# documentation-architecture

**Last updated:** 2026-08-20

## Context

**Target** skill contract for bootstrapping or extending repository documentation with a procedures-vs-design layout. Full Cursor skill (Observed, unchanged): [overlay SKILL.md](../overlays/cursor/skills/documentation-architecture/SKILL.md). Deep procedure: [documentation-architecture.md](../overlays/cursor/docs/workflow/documentation-architecture.md). Positive example of lean skill → deep doc ([instruction layering](../featureArchitecture/instruction-layering.md)).

---

## Substance

### When to use (Nice-to-have)

- Creating new docs areas or standardizing an under-documented repo
- User asks for SOPs / featureArchitecture structure
- Introducing a durable how-to or design note that needs an index home

### When not to use

- Repo already has a coherent docs layout — **follow it**; do not invent parallel trees
- Trivial one-line comments or ephemeral chat notes

### Workflow steps

1. Run [discovery](./discovery.md) (Step 0 local `reference-docs` if present)
2. If the repo already has a coherent layout → **follow it**; map procedures vs design onto existing folders
3. If greenfield / user asks to adopt defaults → bootstrap under the docs root (or create `docs/`):
   - `SOPs/_index.md` — how-tos
   - `featureArchitecture/_index.md` — design/behavior
   - `roadmaps/` — multi-phase handoffs (see [roadmap](./roadmap.md))
4. New or changed patterns: update docs + indexes in the **same changeset** as code
5. Do not force `SOPs` / `featureArchitecture` names onto a repo that already chose differently

### Outputs

- Docs tree additions or extensions with current `_index.md` links
- Clear procedures vs design placement for new leaves

### Must not

- Invent parallel doc trees beside an existing coherent layout
- Leave new leaves unlinked from section indexes
- Treat Observed import paths under `docs/research/imported/` as Target homes for product docs

### Related roles

[planner](../agents/planner.md), [implementer](../agents/implementer.md), [repository_explorer](../agents/repository_explorer.md)

---

## Implications / open questions

1. cursorEscape itself follows this layout; other repos may map the same split onto different folder names.

---

## Related

- [discovery](./discovery.md)
- [roadmap](./roadmap.md)
- [Documenting this repo (SOP)](../SOPs/documenting-this-repo.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md)
- [Live deep doc](../overlays/cursor/docs/workflow/documentation-architecture.md)
