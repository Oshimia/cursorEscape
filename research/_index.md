# Research Documentation

**Last updated:** 2026-08-20

## Context

This section holds **sourced** market and product research plus **imported** sibling research (openBuggy, AITestSuite, live `~/.cursor` workflow) that informs cursorEscape architecture and evaluation.

**Status:** Phase 3 imports complete. Phase 4 added Target synthesis [preliminary-backend-landscape.md](./preliminary-backend-landscape.md). Identity research: [theo-fleet-skill-management.md](./theo-fleet-skill-management.md) (2026-08-19). Current Cursor workflow: [overlays/cursor](../overlays/cursor/_index.md). Overlay FA: [skill-source-and-host-overlays](../docs/featureArchitecture/skill-source-and-host-overlays.md).

---

## Substance

### Content boundaries

| Location | Responsibility |
| -------- | -------------- |
| `research/*` (authored leaves) | Facts and synthesis with **Sources**; label **Observed** vs **Target** per leaf (e.g. [theo-fleet](./theo-fleet-skill-management.md) is Observed) |
| `research/imported/` | Copied sibling docs with provenance banners |
| `docs/featureArchitecture/` | Target system design — link research; do not duplicate long competitor essays |

### Target synthesis (Phase 4+)

| Document | Purpose |
| -------- | ------- |
| [preliminary-backend-landscape.md](./preliminary-backend-landscape.md) | First attempt: OpenCode + T3 Code; ClinePass Desired later |

### Observed synthesis (identity)

| Document | Purpose |
| -------- | ------- |
| [theo-fleet-skill-management.md](./theo-fleet-skill-management.md) | Observed: Theo `fleet` repo; stacks analog / machines delta |

Operator study: [host recreation](../analysis/host-recreation-2026-08.md).

### Citation rules

1. Prefer URLs listed in canonical source lists or original imported docs.
2. Do not invent URLs.
3. Imported files carry provenance banners; **Observed ≠ Target**.

### Import manifest

* [COPY-MANIFEST](./imported/COPY-MANIFEST.md) — every copied file, source path, date, why, status

### Imported openBuggy (Phase 2)

| Area | Hub |
| ---- | --- |
| Feature architecture (subset) | [imported/openBuggy/featureArchitecture/](./imported/openBuggy/featureArchitecture/_index.md) |
| Cursor BugBot Observed suite | [cursor-bugbot-agent-review/](./imported/openBuggy/featureArchitecture/cursor-bugbot-agent-review/_index.md) |
| Product/API research | [imported/openBuggy/research/](./imported/openBuggy/research/_index.md) |
| Reviewer effectiveness analysis | [imported/openBuggy/analysis/](./imported/openBuggy/analysis/_index.md) |
| openBuggy design decisions (imported) | [design-decisions.md](./imported/openBuggy/review/design-decisions.md) |
| Agent review loop SOP (imported) | [running-an-agent-review-loop](./imported/openBuggy/SOPs/running-an-agent-review-loop-with-openBuggy.md) |

Sibling relationship (Target): [relationship-to-siblings](../review/relationship-to-siblings.md).

### Imported AITestSuite + live workflow (Phase 3)

| Area | Hub |
| ---- | --- |
| Workflow source delta (authored) | [workflow-source-delta.md](./imported/workflow-source-delta.md) — Observed freeze-vs-live archaeology |
| AITestSuite Phase 4 freeze / eval packaging | [imported/AITestSuite/](./imported/AITestSuite/) |
| Live `~/.cursor` workflow (Phase 3 bannered snapshot) | [imported/cursor-global-workflow/](./imported/cursor-global-workflow/) |
| Current Cursor workflow (verbatim extract) | [overlays/cursor](../overlays/cursor/_index.md) |

Key live workflow entry points in the import mirror:

- [cursor-global-workflow/docs/workflow/README.md](./imported/cursor-global-workflow/docs/workflow/README.md)
- Current overlay: [workflow index](../workflow/_index.md), [implementation-review](../overlays/cursor/skills/implementation-review/SKILL.md), [reviewer-a](../overlays/cursor/agents/reviewer-a.md)

---

## Implications / open questions

1. Host-only absolute paths in imports are annotated in COPY-MANIFEST.
2. U2/U8 settled in [unresolved questions](../review/unresolved-architectural-questions.md); remaining Unknowns stay labeled.
3. Do not treat the Phase 3 live `~/.cursor` import as Target overlay SoT. Current Cursor workflow files: [overlays/cursor](../overlays/cursor/_index.md). Contracts in this repo are Target. Overlay FA: [skill-source-and-host-overlays](../docs/featureArchitecture/skill-source-and-host-overlays.md).

---

## Related

- [Roadmap](../docs/Roadmap.md)
- [Feature architecture index](../docs/featureArchitecture/_index.md)
- [Host recreation study](../analysis/host-recreation-2026-08.md)
- [Initialization roadmap](../docs/roadmaps/cursorEscape-initialization.md)
