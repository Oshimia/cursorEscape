# Feature Architecture Documentation

**Last updated:** 2026-08-17

## Context

This section explains **how cursorEscape is intended to work** — Target design and workflow contracts. Unlike SOPs (how to perform a task), these documents describe system behavior and architecture.

**Status:** Phase 4 Target synthesizing docs authored. Observed imports remain under `docs/research/imported/`.

## Substance

### Content boundaries

| Document type | Responsibility |
| ------------- | -------------- |
| This folder (Target docs) | Intended workflow, backend abstraction, agent roles, evaluation methodology |
| [`../research/`](../research/_index.md) | Sourced facts and imported sibling research |
| [`../analysis/`](../analysis/_index.md) | Operator studies of local workflows |
| [`../agents/`](../agents/_index.md) | Host-agnostic role contracts |
| [`../skills/`](../skills/_index.md) | Host-agnostic skill contracts |

### Observed imports (Phase 2–3)

Imported Observed harness and workflow snapshots live under [research/imported/](../research/imported/COPY-MANIFEST.md) — not Target cursorEscape design.

### Target documents (Phase 4)

| Document | Purpose |
| -------- | ------- |
| [intended-workflow.md](./intended-workflow.md) | Canonical loop — live workflow + dual gate (OpenCode bug_reviewer) |
| [desired-behavior-vs-cursor-specific.md](./desired-behavior-vs-cursor-specific.md) | Portable vs Cursor-specific claims |
| [cursor-behavior-to-reproduce.md](./cursor-behavior-to-reproduce.md) | Observed behaviors worth preserving |
| [backend-and-provider-abstraction.md](./backend-and-provider-abstraction.md) | T3 → OpenCode → provider layering |
| [repository-discovery-and-context.md](./repository-discovery-and-context.md) | What context agents need |
| [workspace-model.md](./workspace-model.md) | Companion vs target workspace; T3 vs OpenCode sessions |
| [agent-roles-and-model-assignment.md](./agent-roles-and-model-assignment.md) | Role catalog + config |
| [evaluation-methodology.md](./evaluation-methodology.md) | How workflow quality is measured |

First host attempt: [host recreation study](../analysis/host-recreation-2026-08.md). Claim taxonomy: **Desired / Required / Nice-to-have / Cursor-specific / Unknown**.

---

## Implications / open questions

1. Do not mix Observed and Target in the same doc without labels.
2. Runtime implementation must update these docs when behavior diverges.

## Related

- [Roadmap](../Roadmap.md)
- [Design decisions](../review/design-decisions.md)
- [Unresolved architectural questions](../review/unresolved-architectural-questions.md)
- [Initialization roadmap](../roadmaps/cursorEscape-initialization.md)
