> **Imported research** — Source: openBuggy `docs/SOPs/documenting-this-concept-repo.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Documenting This Concept Repo

**Last updated:** 2026-08-16

## Context

This repository’s value is its documentation. Drift (undocumented decisions, broken indexes, invented parallel trees) destroys that value. This SOP is the local equivalent of a “reference docs check” discipline — adapted to `docs/` paths only.

---

## Substance

### Before changing docs

1. Read [Roadmap](../Roadmap.md) and the relevant `_index.md`.
2. Decide: **featureArchitecture** (how it works — including optional **Observed external harness** subdirectories), **SOP** (how to do a task), **research** (sourced facts), **roadmaps/** (multi-phase handoff conductors), **review/design-decisions** (intent), or **analysis** (operator studies of local workflows — not eval scores, not proposed engine design).
3. Do not put metrics in `competitive-landscape.md` — put them in `research/` with Sources.
4. When tone or distribution framing changes, re-read stewardship in [design decisions](../review/design-decisions.md) (private-first; monetization is not a goal).

### External harness reference under featureArchitecture

`docs/featureArchitecture/` may contain a subdirectory that characterizes an **external** system (today: [Cursor Agent Review BugBot](../featureArchitecture/cursor-bugbot-agent-review/_index.md)) as a **replication reference**.

| Rule | Detail |
|------|--------|
| Label | Every doc: **Status: Observed reference** (not Target / proposed openBuggy engine) |
| Claims | Mark **Observed** / **Inferred** / **Unknown** |
| Sources | **Required** on every file in that subdirectory (transcript UUIDs, external skill paths, research links) |
| Boundaries | Do not re-derive openBuggy’s proposed engine inside the Observed suite — link out to proposed docs |
| Research split | Product/API/billing facts stay in `docs/research/`; harness behavior lives in the FA Observed suite |

### Operator analysis under `docs/analysis/`

[`docs/analysis/`](../analysis/_index.md) holds **decision-grade studies** of the owner’s existing loops (today: [reviewer-effectiveness](../analysis/reviewer-effectiveness/_index.md)). Do not fold those write-ups into the Observed BugBot FA suite or into `eval/` scoring. Committed analysis docs use aliases and theme labels; UUID/path sheets stay gitignored under the study’s `.local/` directory.

### When adding a document

1. Create the `.md` file with **Last updated**, **Context**, **Substance**, **Implications / open questions**.
2. Link it from the section `_index.md` in the **same change**.
3. Cross-link related Roadmap / design-decisions entries when intent changes.
4. Research docs must include a **Sources** subsection (see [research index](../research/_index.md)).

### Path rules

| Allowed | Forbidden |
|---------|-----------|
| Relative links under `docs/` | Copying sibling `.cursor/skills` or `.cursor/agents` paths as if they lived here |
| Prose mentioning external sibling projects by absolute path or name | Pretending runtime APIs are implemented |

### After edits

- Update **Last updated** dates on touched docs.
- Spot-check that every new `_index` link resolves.

---

## Implications / open questions

1. When runtime code appears in a future repo or branch, extend this SOP with code↔doc sync rules.
2. Keep this archive docs-only until an explicit implementation phase begins.
