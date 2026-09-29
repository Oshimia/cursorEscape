# Documenting This Repo

## Context

cursorEscape's value is its documentation. Drift (undocumented decisions, broken indexes, invented parallel trees) destroys that value. This SOP is the local equivalent of a "reference docs check" discipline — adapted to repo paths.

**Source-of-truth map:** portable procedures and contracts live at repo-root `workflow/`, `skills/`, `agents/`, and `rules/` ([skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)). `docs/featureArchitecture/` explains this repository's intended architecture; `docs/SOPs/` contains repeatable maintainer procedures. Machine metadata, host bindings, and composition order live in the [procedure registry](../featureArchitecture/procedure-registry.md). Host overlays contain thin harness only.

**Changing portable workflow / gates / review loops:** follow [editing-companion-workflow](./editing-companion-workflow.md) (same-changeset cascade to Cursor + OpenCode thin harness) before editing.

---

## Substance

### Before changing docs

1. Read the relevant `_index.md`.
2. Decide document kind (see table below).
3. Prefer updating an existing current-facing leaf over creating a parallel one. Keep completed investigation records in Git history, not in active SOPs.
4. If the change affects behavior, scripts, catalogs, manifests, or CI, identify the corresponding implementation and verification seam before editing prose.

### Document kinds (Target taxonomy — Approach A)

| Kind | Home | Edit rule |
| ---- | ---- | --------- |
| **featureArchitecture** | `docs/featureArchitecture/` | Current intended architecture and durable design rationale. Host extra restrictiveness: [skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md). |
| **workflow** (shared deep procedure) | [`workflow/`](../../workflow/_index.md) | One authored procedure per leaf; skills **point**, they do not paste |
| **skills** | `skills/*/SKILL.md` | Host-agnostic workflow skill contracts |
| **agents** | `agents/*.md` | Host-agnostic role contracts |
| **rules** | `rules/*.md` | Always-on gate contracts |
| **overlays** | `overlays/<host>/` | Host-native wrappers (thin); spawn IDs and copy-out Read tables |
| **SOP** | `docs/SOPs/` | How to do a task |
| **analysis** | `analysis/` | Operator studies of local workflows |

Promotion rule: **Target** portable procedure edits go to repo-root bases (`workflow/`, `skills/`, `agents/`, `rules/`, FA). Overlay refresh is thin-wrapper / harness **echo** of changed gates (Steps, always-on summary, Read when) — not a second authored procedure tree. Full cascade checklist: [editing-companion-workflow](./editing-companion-workflow.md).

### Changing portable workflow

Non-trivial edits to plan/review loops, Composer, always-on gates, or L3 schemas: **read [editing-companion-workflow](./editing-companion-workflow.md) first**, then apply the edit-map cascade in the **same changeset** (companion SoT + Cursor overlay + OpenCode harness + FA claims if Required wording moved).

### Observed vs Target

| Label | When to use |
| ----- | ----------- |
| **Observed** | Characterization of external systems or sibling projects — cite Sources |
| **Target** | cursorEscape's intended workflow and architecture |
| **Inferred** / **Unknown** | Mark explicitly; do not present as settled Target |

Overlay wrappers do not duplicate portable procedure bodies. **Observed ≠ Target** — never merge them without classification.

### When adding a document

1. Create the `.md` file with **Context**, **Substance**, **Implications** (or **Implications / open questions**).
2. Link it from the section `_index.md` in the **same change**.
3. Cross-link related feature-architecture entries when intent changes; record durable decisions and unresolved questions in [project decisions and open questions](../featureArchitecture/project-decisions-and-open-questions.md).
4. Observed claims must include a **Sources** subsection.

### Path rules

| Allowed | Forbidden |
| ------- | --------- |
| Relative links under repo paths | Copying live skills into repo-root `.cursor/skills` or `.cursor/agents` as if this were a Cursor project |
| Prose mentioning external sibling projects by absolute path or name | Pretending runtime APIs are implemented |
| Recording host-native files under `overlays/<host>/` with an index (hashes, date, live source) | Pasting full portable procedure essays into overlay skill/agent/rule **bodies** (second SoT) |
| Updating thin overlay harness **echo** (Steps outline, always-on summary, spawn Inputs, Read when) when companion SoT gates change — same changeset | Leaving OpenCode/Cursor harness text on a superseded loop (e.g. unbounded “until dual APPROVED” after pressure-release SoT) |

### Analysis vs featureArchitecture

| Folder | Holds |
| ------ | ----- |
| `analysis/` | Index and durable artifacts for local operator studies |
| `docs/featureArchitecture/` | How cursorEscape is intended to work (Target) |

### After edits

- Confirm affected indexes, catalogs, scripts, and tests were updated in the same change.
- Run relative-link closure for touched Markdown.
- Run normalization Fast CI before handoff; run Full CI before a phase commit.

---

## Implications / open questions

1. Documentation, scripts, registry metadata, fixtures, and CI assertions form one contract. Update them together when the contract changes.
2. Target docs use claim taxonomy: Desired / Required / Nice-to-have / Cursor-specific / Unknown — see [feature architecture index](../featureArchitecture/_index.md).
3. Do not retain completed migration or bring-up evidence in active SOPs; cite Git history when provenance is essential.

---

## Related

- [Project decisions and open questions](../featureArchitecture/project-decisions-and-open-questions.md)
- [SOPs index](./_index.md)
- [Skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)
- [Editing companion workflow](./editing-companion-workflow.md)
