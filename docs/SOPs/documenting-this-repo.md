# Documenting This Repo

**Last updated:** 2026-08-17

## Context

cursorEscape's value is its documentation. Drift (undocumented decisions, broken indexes, invented parallel trees) destroys that value. This SOP is the local equivalent of a "reference docs check" discipline — adapted to `docs/` paths only.

Adapted from openBuggy's `documenting-this-concept-repo` SOP; paths below are cursorEscape-local.

---

## Substance

### Before changing docs

1. Read [Roadmap](../Roadmap.md) and the relevant `_index.md`.
2. Decide document kind:
   - **featureArchitecture** — how it works (Target design; cite Observed imports from `docs/research/imported/` — do not add Observed harness subdirectories directly under `docs/featureArchitecture/`)
   - **SOP** — how to do a task
   - **research** — sourced facts and imported sibling material
   - **roadmaps/** — multi-phase handoff conductors
   - **review/design-decisions** — intent
   - **analysis** — operator studies of local workflows (not eval scores, not proposed engine design)
3. Do not put metrics in `competitive-landscape.md` — put them in `research/` with Sources (rule from imported openBuggy documenting SOP).
4. When tone or distribution framing changes, re-read stewardship in [design decisions](../review/design-decisions.md) (private-first; monetization is not a goal).

### Observed vs Target

| Label | When to use |
| ----- | ----------- |
| **Observed** | Characterization of external systems (Cursor harness, imported sibling docs) — cite Sources |
| **Target** | cursorEscape's intended workflow and architecture (Phase 4+ synthesizing docs) |
| **Inferred** / **Unknown** | Mark explicitly; do not present as settled Target |

Imported research files carry provenance banners. **Observed ≠ Target** — never merge without classification.

### Operator analysis

[`docs/analysis/`](../analysis/_index.md) indexes **decision-grade studies** of the owner's existing loops. Phase 2 imported openBuggy operator studies live under [`docs/research/imported/openBuggy/analysis/`](../research/imported/openBuggy/analysis/_index.md) (Observed/imported) — link from `docs/analysis/_index.md`, do not duplicate under `docs/analysis/` as if native. Do not fold those write-ups into Observed FA suites or into future eval scoring. Committed analysis docs use aliases and theme labels; UUID/path sheets for imported openBuggy studies remain in the **openBuggy source repo** under gitignored `.local/` (not copied here). Future local studies may use `.local/` under `docs/analysis/**` (`**/.local/` in `.gitignore`).

### When adding a document

1. Create the `.md` file with **Last updated**, **Context**, **Substance**, **Implications** (or **Implications / open questions**).
2. Link it from the section `_index.md` in the **same change**.
3. Cross-link related Roadmap / design-decisions entries when intent changes.
4. Research docs must include a **Sources** subsection (see [research index](../research/_index.md)).

### Path rules

| Allowed | Forbidden |
| ------- | --------- |
| Relative links under `docs/` | Copying sibling `.cursor/skills` or `.cursor/agents` paths as if they lived here |
| Prose mentioning external sibling projects by absolute path or name | Pretending runtime APIs are implemented |
| Importing under `docs/research/imported/` with manifest updates (Phase 2+) | Ignoring COPY-MANIFEST when adding imports |

### Analysis vs featureArchitecture

| Folder | Holds |
| ------ | ----- |
| `docs/analysis/` | Index for operator studies; future local studies may live here |
| `docs/research/imported/openBuggy/analysis/` | Imported openBuggy operator studies (Observed/imported) |
| `docs/featureArchitecture/` | How cursorEscape is **intended** to work (Target); Observed openBuggy FA under `docs/research/imported/openBuggy/featureArchitecture/` |

### After edits

- Update **Last updated** dates on touched docs.
- Spot-check that every new `_index` link resolves.

---

## Implications / open questions

1. When runtime code appears in a future repo or branch, extend this SOP with code↔doc sync rules.
2. Phase 4 Target docs will use claim taxonomy: Desired / Required / Nice-to-have / Cursor-specific / Unknown.
3. Keep this archive docs-only until an explicit implementation phase begins.

---

## Related

- [Roadmap](../Roadmap.md)
- [Design decisions](../review/design-decisions.md)
- [SOPs index](./_index.md)
