# Design Decisions & Project Intent

**Last updated:** 2026-08-17

This document is the **canonical record of project intent** for cursorEscape while the repository is documentation-only. Implementation must not contradict these decisions without updating this file in the same change set.

---

## Context

cursorEscape is an **open agentic workflow companion** for escaping Cursor lock-in: the owner keeps a reliable plan → implement → review loop, portable repository knowledge, and evaluable workflow behavior without binding to one IDE subscription or one model vendor. See [Roadmap](../Roadmap.md).

---

## Substance

### Stewardship and distribution

| Topic | Decision |
| ----- | -------- |
| **Primary operator** | Owner (single maintainer). Built for the owner's agentic loop, not a multi-tenant service. |
| **Repository posture** | **Private-first.** Documentation is the durable artifact until (and unless) a runtime is implemented. |
| **Future distribution** | Open source is **conditional** — only if maintainable, scrubbed of private material, and worth supporting others. License and remote hosting remain **TBD** until that gate. |
| **Monetization** | **Not a goal.** No hosted SaaS business, seat sales, or GTM exercises. |

### Project decisions

| Topic | Decision |
| ----- | -------- |
| **Project name** | **cursorEscape** (folder and display name). |
| **Primary job** | Preserve and evolve a **personal agentic workflow** — plan, implement, dual review, repository discovery — as portable docs and (later) replaceable runtime surfaces. |
| **Personal workflow first** | Success = the owner's loop works reliably on their repos, not market share or a general IDE product. |
| **Not building a general IDE** | cursorEscape is a **workspace-pointing companion**, not a from-scratch editor or Cursor clone. |
| **Bugbot leg (initial)** | Use **openBuggy** as the external Bugbot-shaped sibling for the bug-finder review leg — **not reimplemented initially** in cursorEscape. |
| **Keys** | **BYOK** — the operator supplies model API keys; inference cost and control stay with the operator. |
| **IDE coupling** | **VS Code is not inseparably coupled.** A future thin client is acceptable; the engine and workflow contracts are not VS Code–specific. |
| **Replaceability** | Backends, models, and execution surfaces must remain swappable without rewriting canonical intent docs. |
| **Cursor dependency (target)** | **None** for cursorEscape runtime. Observed Cursor behavior may be imported as research/reference only. |
| **Documentation taxonomy** | Mirror openBuggy's `docs/` layout (featureArchitecture, SOPs, research, analysis, roadmaps) — extend hubs; do not invent parallel trees. |

### Non-goals (initial)

| Non-goal | Rationale |
| -------- | --------- |
| General-purpose IDE | Companion workflow, not an editor product. |
| Reimplement Bugbot engine first | Delegate to openBuggy; focus on workflow portability and knowledge. |
| Monetization or productized SaaS | Private workflow preservation. |
| Inseparable VS Code coupling | Thin client OK; engine and contracts stay host-agnostic. |
| Runtime in documentation phases | Initialization roadmap is docs-only through Phase 5. |
| Pretend stack or APIs are chosen | Record TBD until implementation explicitly starts. |

---

## Implications / open questions

1. When implementation starts, pick engine language and record it here.
2. Decide license and remote hosting only if/when pursuing an optional public release.
3. Phase 4 Target docs will classify claims (Desired / Required / Nice-to-have / Cursor-specific / Unknown).
4. Relationship to openBuggy and AITestSuite will be documented in Phase 2–3 imports.

---

## Related

- [Roadmap](../Roadmap.md)
- [Feature architecture index](../featureArchitecture/_index.md)
- [Documenting this repo (SOP)](../SOPs/documenting-this-repo.md)
- [Initialization roadmap](../roadmaps/cursorEscape-initialization.md)
