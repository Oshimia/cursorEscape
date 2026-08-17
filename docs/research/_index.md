# Research Documentation

**Last updated:** 2026-08-17

## Context

This section holds **sourced** market and product research plus **imported** sibling research (openBuggy, AITestSuite, live `~/.cursor` workflow) that informs cursorEscape architecture and evaluation.

**Status:** Phase 3 imports complete. Phase 4 added Target synthesis [preliminary-backend-landscape.md](./preliminary-backend-landscape.md).

---

## Substance

### Content boundaries

| Location | Responsibility |
| -------- | -------------- |
| `docs/research/*` (Target synthesis) | Facts and synthesis with **Sources** subsections |
| `docs/research/imported/` | Copied sibling docs with provenance banners |
| `docs/featureArchitecture/` | Target system design — link research; do not duplicate long competitor essays |

### Target synthesis (Phase 4)

| Document | Purpose |
| -------- | ------- |
| [preliminary-backend-landscape.md](./preliminary-backend-landscape.md) | Cline vs OpenCode vs Aider/T3 — research, not decision |

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
| Workflow source delta (authored) | [workflow-source-delta.md](./imported/workflow-source-delta.md) |
| AITestSuite Phase 4 freeze / eval packaging | [imported/AITestSuite/](./imported/AITestSuite/) |
| Live `~/.cursor` workflow (canonical Target) | [imported/cursor-global-workflow/](./imported/cursor-global-workflow/) |

Key live workflow entry points in the import mirror:

- [cursor-global-workflow/docs/workflow/README.md](./imported/cursor-global-workflow/docs/workflow/README.md)
- [implementation-review skill](./imported/cursor-global-workflow/skills/implementation-review/SKILL.md)
- [composer skill](./imported/cursor-global-workflow/skills/composer/SKILL.md)

---

## Implications / open questions

1. Host-only absolute paths in imports are annotated in COPY-MANIFEST.
2. Backend landscape remains **Unknown** until implementation spike — see [unresolved questions](../review/unresolved-architectural-questions.md).

---

## Related

- [Roadmap](../Roadmap.md)
- [Feature architecture index](../featureArchitecture/_index.md)
- [Initialization roadmap](../roadmaps/cursorEscape-initialization.md)
