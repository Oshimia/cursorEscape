# Documenting This Repo

**Last updated:** 2026-08-20

## Context

cursorEscape's value is its documentation. Drift (undocumented decisions, broken indexes, invented parallel trees) destroys that value. This SOP is the local equivalent of a "reference docs check" discipline — adapted to repo paths.

**SoT (Target — Approach A):** Gold procedure and contracts land at repo-root `workflow/`, `skills/`, `agents/`, and `rules/` (Phases 3–5 of [shared-workflow-docs](../roadmaps/shared-workflow-docs.md)). **Interim:** portable contracts under `docs/skills/` and `docs/agents/`; shared deep procedure at repo-root [`workflow/`](../../workflow/_index.md) (Phase 3+). `docs/` holds **this-repo-only** FA, SOPs, roadmaps, and `Roadmap.md`. Cursor overlay under `overlays/cursor/` is a **fat Observed interim extract** (thin wrappers in Phase 5). Phase 3 import under `research/imported/cursor-global-workflow/` is archaeology. Identity: skill/workflow manager across **stacks**, not machines ([design decisions](../../review/design-decisions.md)).

Adapted from openBuggy's `documenting-this-concept-repo` SOP; paths below are cursorEscape-local.

---

## Substance

### Before changing docs

1. Read [Roadmap](../Roadmap.md) and the relevant `_index.md`.
2. Decide document kind (see table below).
3. Do not put metrics in `competitive-landscape.md` — put them in `research/` with Sources (rule from imported openBuggy documenting SOP).
4. When tone or distribution framing changes, re-read stewardship in [design decisions](../../review/design-decisions.md) (private-first; monetization is not a goal).

### Document kinds (Target taxonomy — Approach A)

| Kind | Target home | Interim (pre-Phase 4/5) | Edit rule |
| ---- | ----------- | ----------------------- | --------- |
| **featureArchitecture** | `docs/featureArchitecture/` | Same | Target design. Host extra restrictiveness: [skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md). Cite Observed imports from `research/imported/` — do not add Observed harness subdirectories directly under `docs/featureArchitecture/` |
| **workflow** (shared deep procedure) | `workflow/` | Phase 3+: [`workflow/`](../../workflow/_index.md) | One authored procedure per leaf; skills **point**, they do not paste |
| **skills** | `skills/*/SKILL.md` | `docs/skills/` | Host-agnostic workflow skill contracts (Target) |
| **agents** | `agents/*.md` | `docs/agents/` | Host-agnostic role contracts (Target) |
| **rules** | `rules/*.md` | `docs/skills/pre-commit-ci-gate.md` → `rules/` in Phase 4 | Always-on gate contracts |
| **overlays** | `overlays/<host>/` | Same (Phase 2+) | Host-native wrappers (thin after Phase 5); fat extract is interim |
| **SOP** | `docs/SOPs/` | Same | How to do a task |
| **research** | `research/` | Same (Phase 2+) | Sourced facts and imported sibling material |
| **review** | `review/` | Same (Phase 2+) | Intent, design decisions |
| **analysis** | `analysis/` | Same (Phase 2+) | Operator studies of local workflows |
| **roadmaps/** | `docs/roadmaps/` | Same | Multi-phase handoff conductors |

Promotion rule: **Target** portable procedure edits go to gold bases; **interim (Phases 1–4):** edit `docs/skills/`, `docs/agents/`, FA, or overlay index — not overlay bodies. Overlay refresh is re-copy, thin-wrapper rewrite (Phase 5), or spawn-extract — not a second authored tree ([overlay FA](../featureArchitecture/skill-source-and-host-overlays.md)).

### Observed vs Target

| Label | When to use |
| ----- | ----------- |
| **Observed** | Characterization of external systems (Cursor harness, imported sibling docs) — cite Sources |
| **Target** | cursorEscape's intended workflow and architecture (Phase 4+ synthesizing docs) |
| **Inferred** / **Unknown** | Mark explicitly; do not present as settled Target |

Imported research files carry provenance banners. Overlay `SKILL.md` files do **not** — provenance lives in the overlay `_index.md`. **Observed ≠ Target** — never merge without classification.

### Operator analysis

[`analysis/`](../../analysis/_index.md) indexes **decision-grade studies** of the owner's existing loops. Phase 2 imported openBuggy operator studies live under [`research/imported/openBuggy/analysis/`](../../research/imported/openBuggy/analysis/_index.md) (Observed/imported) — link from `analysis/_index.md`, do not duplicate under `analysis/` as if native. Do not fold those write-ups into Observed FA suites or into future eval scoring. Committed analysis docs use aliases and theme labels; UUID/path sheets for imported openBuggy studies remain in the **openBuggy source repo** under gitignored `.local/` (not copied here). Future local studies may use `.local/` under `analysis/**` (`**/.local/` in `.gitignore`).

### When adding a document

1. Create the `.md` file with **Last updated**, **Context**, **Substance**, **Implications** (or **Implications / open questions**).
2. Link it from the section `_index.md` in the **same change**.
3. Cross-link related Roadmap / design-decisions entries when intent changes.
4. Research docs must include a **Sources** subsection (see [research index](../../research/_index.md)).

### Path rules

| Allowed | Forbidden |
| ------- | --------- |
| Relative links under repo paths | Copying live skills into repo-root `.cursor/skills` or `.cursor/agents` as if this were a Cursor project |
| Prose mentioning external sibling projects by absolute path or name | Pretending runtime APIs are implemented |
| Importing under `research/imported/` with manifest updates (Phase 2+) | Ignoring COPY-MANIFEST when adding imports |
| Recording host-native files under `overlays/<host>/` with an index (hashes, date, live source) | Editing overlay SKILL/agent/rule **bodies** during Phases 1–4 except authorized extract refresh; portable procedure edits go to interim contracts (`docs/skills/`, `docs/agents/`, FA) or gold bases when they exist |

### Analysis vs featureArchitecture

| Folder | Holds |
| ------ | ----- |
| `analysis/` | Index for operator studies; future local studies may live here |
| `research/imported/openBuggy/analysis/` | Imported openBuggy operator studies (Observed/imported) |
| `docs/featureArchitecture/` | How cursorEscape is **intended** to work (Target); Observed openBuggy FA under `research/imported/openBuggy/featureArchitecture/` |

### After edits

- Update **Last updated** dates on touched docs.
- Spot-check that every new `_index` link resolves.

---

## Implications / open questions

1. When runtime code appears in a future repo or branch, extend this SOP with code↔doc sync rules.
2. Target docs use claim taxonomy: Desired / Required / Nice-to-have / Cursor-specific / Unknown — see [feature architecture index](../featureArchitecture/_index.md).
3. Keep this archive docs-only until an explicit implementation phase begins.

---

## Related

- [Roadmap](../Roadmap.md)
- [Design decisions](../../review/design-decisions.md)
- [SOPs index](./_index.md)
- [Shared workflow docs roadmap](../roadmaps/shared-workflow-docs.md)
- [Skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)
