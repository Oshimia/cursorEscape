# discovery

**Last updated:** 2026-08-20

## Context

**Target** skill contract for repository documentation discovery before changes. Replaces freeze **reference-docs** skill for live owner workflow ([workflow-source-delta](../research/imported/workflow-source-delta.md)). Live doc: [discovery.md](../overlays/cursor/docs/workflow/discovery.md).

---

## Substance

### When to use (Required)

Before any non-trivial doc or code change — first step of [implementation-plan](./implementation-plan.md).

### Workflow steps

1. **Step 0** — If target repo has `.cursor/skills/reference-docs/SKILL.md`, follow it (project override)
2. **Fallback** — README, AGENTS.md, CONTRIBUTING, `.cursor/rules`, `docs/` indexes, roadmap hints
3. **Workflow process** — For plan/review expectations only, read global workflow index (not product architecture)
4. Record applicable paths for plan and reviewers

### Outputs

- List of hubs, SOPs, FA targets, CI mapping sources
- Explicit note when doc tree is sparse

### Must not

- Invent required parallel doc trees
- Treat imported Observed harness paths as Target homes
- Skip discovery on unfamiliar repos

### Freeze note (Observed)

AITestSuite baseline includes [reference-docs skill](../research/imported/AITestSuite/tests/ez-pz-streaming-media-phase-4/baseline/.cursor/skills/reference-docs/SKILL.md) — use when evaluating freeze baselines. This page is the **Target** discovery contract in the companion repo; the live overlay under [discovery.md](../overlays/cursor/docs/workflow/discovery.md) is **Observed** Cursor wording.

### Related roles

[planner](../agents/planner.md), [implementer](../agents/implementer.md), [repository_explorer](../agents/repository_explorer.md)

---

## Implications / open questions

1. **Unknown (U5):** Whether cursorEscape runtime re-homes repo-local reference-docs.

---

## Related

- [repository_explorer agent](../agents/repository_explorer.md)
- [Repository discovery and context](../featureArchitecture/repository-discovery-and-context.md)
