# Feature Architecture Documentation

**Last updated:** 2026-08-22

## Context

This section explains **how cursorEscape is intended to work** — Target design and workflow contracts. Unlike SOPs (how to perform a task), these documents describe system behavior and architecture.

**Status:** Phase 6 closeout — Target synthesizing docs authored. Observed imports remain under `research/imported/`. Identity: companion repo is **Target** contract SoT at repo-root bases (`workflow/`, `skills/`, `agents/`, `rules/` — Approach A). Cursor overlay: [overlays/cursor](../../overlays/cursor/_index.md) (thin wrappers). Overlay FA: [skill-source-and-host-overlays.md](./skill-source-and-host-overlays.md).

## Substance

### Content boundaries

| Document type | Responsibility |
| ------------- | -------------- |
| This folder (Target docs) | Intended workflow, instruction layering, clean-context isolation, **skill source and host overlays**, backend abstraction, agent roles, evaluation methodology |
| [research/](../../research/_index.md) | Sourced facts and imported sibling research |
| [analysis/](../../analysis/_index.md) | Operator studies of local workflows |
| [`agents/`](../../agents/_index.md) | Host-agnostic role contracts |
| [`skills/`](../../skills/_index.md) | Host-agnostic skill contracts |
| [`rules/`](../../rules/_index.md) | Always-on gate contracts |
| [`workflow/`](../../workflow/_index.md) | Shared deep procedure (plan/review loops, discovery, CI ladder) |
| [overlays/](../../overlays/_index.md) | Host-native thin wrappers (Cursor spawn + Read tables) |

### Observed imports (Phase 2–3)

Imported Observed harness and workflow snapshots live under [research/imported/](../../research/imported/COPY-MANIFEST.md) — not Target cursorEscape design.

### Target documents (Phase 4)

| Document | Purpose |
| -------- | ------- |
| [intended-workflow.md](./intended-workflow.md) | Target loop (dual gate; OpenCode bug_reviewer). Live Cursor import = Observed interim wording |
| [instruction-layering.md](./instruction-layering.md) | Thin always-on vs on-demand skills/docs/agents (context budget) |
| [clean-context-isolation.md](./clean-context-isolation.md) | Isolated child handoffs; no prior review transcripts |
| [desired-behavior-vs-cursor-specific.md](./desired-behavior-vs-cursor-specific.md) | Portable vs Cursor-specific claims |
| [cursor-behavior-to-reproduce.md](./cursor-behavior-to-reproduce.md) | Observed behaviors worth preserving |
| [backend-and-provider-abstraction.md](./backend-and-provider-abstraction.md) | T3 → OpenCode → provider layering |
| [repository-discovery-and-context.md](./repository-discovery-and-context.md) | What context agents need |
| [workspace-model.md](./workspace-model.md) | Companion vs target workspace; T3 vs OpenCode sessions |
| [skill-source-and-host-overlays.md](./skill-source-and-host-overlays.md) | One procedure; additive host overlays; promotion rule |
| [host-adaptation-fidelity.md](./host-adaptation-fidelity.md) | Host wiring bar; C1–C6 matrix; anti-patterns; Done definition (OpenCode overlay program Phase 0) |
| [agent-roles-and-model-assignment.md](./agent-roles-and-model-assignment.md) | Role catalog + config |
| [evaluation-methodology.md](./evaluation-methodology.md) | How workflow quality is measured |
| [bug-reviewer-finding-rubric.md](./bug-reviewer-finding-rubric.md) | bug_reviewer report vs ignore (nits / out-of-scope / pre-existing) |
| [permission-and-native-tool-policy.md](./permission-and-native-tool-policy.md) | Shell permission policy: read-only allowlist SoT, git red line, accepted risks, measurement |

First host attempt: [host recreation study](../../analysis/host-recreation-2026-08.md). Claim taxonomy: **Desired / Required / Nice-to-have / Cursor-specific / Unknown**.

---

## Implications / open questions

1. Do not mix Observed and Target in the same doc without labels.
2. Runtime implementation must update these docs when behavior diverges.
3. Host extra restrictiveness lives in overlays ([skill-source-and-host-overlays](./skill-source-and-host-overlays.md)), not a second procedure tree.

## Related

- [Roadmap](../Roadmap.md)
- [Design decisions](../../review/design-decisions.md)
- [Unresolved architectural questions](../../review/unresolved-architectural-questions.md)
- [Initialization roadmap](../roadmaps/cursorEscape-initialization.md)
- [Editing companion workflow](../SOPs/editing-companion-workflow.md) — operational edit map (cascade) for Approach A + pointer-first
