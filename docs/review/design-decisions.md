# Design Decisions & Project Intent

**Last updated:** 2026-08-20

This document is the **canonical record of project intent** for cursorEscape while the repository is documentation-only. Implementation must not contradict these decisions without updating this file in the same change set.

---

## Context

cursorEscape is the owner's **skill and workflow manager**: preserve and evolve personal agentic skills and the plan → implement → dual review loop, and apply them across **stacks** without binding to one IDE subscription or one model vendor. Analog to Theo's `fleet` repo ([Observed](../research/theo-fleet-skill-management.md)); **not** a multi-machine fleet. See [Roadmap](../Roadmap.md).

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
| **Primary job** | **Manage skills and workflows that work** — plan, implement, dual review, repository discovery — as portable contracts in this repo, applied across stacks; later copy-out of thin host overlays (not authorized yet). |
| **Canonical skill tree (Target)** | Portable contracts live in this repo (`docs/skills`, `docs/agents`). Host dirs (`~/.config/opencode`, `~/.cursor`) are **copy-out targets**, not a second authored procedure tree. Cursor-native workflow files are recorded under [docs/overlays/cursor](../overlays/cursor/_index.md) (**Observed**, bodies unchanged). Copy-out into host dirs is not authorized. |
| **Personal workflow first** | Success = the owner's loop works reliably on their repos, not market share or a general IDE product. |
| **Not building a general IDE** | cursorEscape is a **workspace-pointing companion**, not a from-scratch editor or Cursor clone. |
| **First host attempt** | **T3 Code** (control plane: threads, diffs, file preview) + **OpenCode** (harness: skills, named subagents, parallel Task dual-gate). T3 is not a VS Code replacement and does not own agent/skill contracts. See [host recreation study](../analysis/host-recreation-2026-08.md). |
| **Bugbot leg (initial)** | OpenCode **`bug_reviewer`** subagent + skills/rules (same pattern as `production_readiness_reviewer` / live reviewer-a). **openBuggy is not required** for v0 — research archive / optional later only. |
| **Keys** | **BYOK** — the operator supplies model API keys; inference cost and control stay with the operator. |
| **Inference (Desired)** | **ClinePass** (or equivalent open-weight subscription) as the likely OpenCode provider later — not a week-one gate. |
| **IDE coupling** | **VS Code is not inseparably coupled.** T3 (or similar) is the preferred agent cockpit for observability; a thin IDE client remains acceptable. Engine and workflow contracts are not VS Code–specific. |
| **Replaceability** | Backends, models, and execution surfaces must remain swappable without rewriting canonical intent docs. |
| **Cursor dependency (target)** | **None** for the recreation path. Observed Cursor behavior may be imported as research/reference only. |
| **Runtime in this repo** | **Not started.** Docs remain canonical until an explicit R0+ go-ahead; first recreation uses external T3 + OpenCode, not a cursorEscape engine. |
| **Documentation taxonomy** | Mirror openBuggy's `docs/` layout (featureArchitecture, SOPs, research, analysis, roadmaps) — extend hubs; do not invent parallel trees. |
| **Instruction budget** | **Thin always-on gates**; deeper procedure in on-demand skills and workflow docs; lean role agents. Portable pattern — see [instruction layering](../featureArchitecture/instruction-layering.md). |
| **Isolated review handoffs** | Reviewers and phase subagents run in **clean child context**; parent packs the invoke; no prior review transcripts — see [clean-context isolation](../featureArchitecture/clean-context-isolation.md). |

### Non-goals (initial)

| Non-goal | Rationale |
| -------- | --------- |
| General-purpose IDE | Companion workflow / contracts, not an editor product. T3 is a control plane, not a Cursor clone. |
| Reimplement Bugbot engine first | Recreate bug-finder utility with OpenCode agent + skills; openBuggy stays research. |
| Require openBuggy for v0 dual gate | Optional later; not a default transport. |
| Monetization or productized SaaS | Private workflow preservation. |
| Inseparable VS Code coupling | T3 or thin client OK; contracts stay host-agnostic. |
| Runtime during docs lock-in | No packages, adapters, or pretend APIs in this repository yet. |
| Pretend every Unknown is settled | Record TBD until spikes; U2/U8 settled 2026-08 — see [unresolved questions](./unresolved-architectural-questions.md). |
| Multi-machine skill fleet | Unlike Theo `fleet`, device sync is **not** a goal. Variation is **stacks** (Cursor vs OpenCode), not laptops. |

---

## Implications / open questions

1. Engine language (U1) remains Unknown until a later implementation phase — first recreation does not need a cursorEscape runtime.
2. Decide license and remote hosting only if/when pursuing an optional public release.
3. Phase 4 Target docs classify claims (Desired / Required / Nice-to-have / Cursor-specific / Unknown) — see [feature architecture index](../featureArchitecture/_index.md).
4. Sibling relationships documented in [relationship-to-siblings](./relationship-to-siblings.md); openBuggy is not a v0 runtime dependency.
5. R0 spike must still prove OpenCode parallel Tasks + parent-owned Fast CI honesty ([implementation roadmap](../roadmaps/implementation-roadmap.md)).
6. Overlay FA (shared procedure + additive host constraints) is Target staging — do not dual-author Cursor vs OpenCode review loops. Cursor workflow overlay extract: [docs/overlays/cursor](../overlays/cursor/_index.md). Init report remains archaeology; do not treat its Q3/Q6 body as live adapter or openBuggy-required text.

---

## Related

- [Roadmap](../Roadmap.md)
- [Host recreation study](../analysis/host-recreation-2026-08.md)
- [Feature architecture index](../featureArchitecture/_index.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md)
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
- [Documenting this repo (SOP)](../SOPs/documenting-this-repo.md)
- [Relationship to siblings](./relationship-to-siblings.md)
- [Initialization roadmap](../roadmaps/cursorEscape-initialization.md)
- [Theo fleet skill management (Observed)](../research/theo-fleet-skill-management.md)
