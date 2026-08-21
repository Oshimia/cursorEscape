# Matt Pocock skills audit map

**Last updated:** 2026-08-21
**Status:** Observed (external-repo analysis). **Snapshot pin:** `mattpocock/skills` `main` at commit `0ab1b63a410a03d3627979a109c8695de27af954` (2026-08-21). Re-fetch targets the pinned SHA, not `main`.

## Context

Full-sweep catalog and comparison index of [mattpocock/skills](https://github.com/mattpocock/skills) (18 engineering + 7 productivity + 4 misc + 6 in-progress skills, plus repo infra) against cursorEscape's skill/agent/workflow tree, plus the per-skill assessment spec a deeper reasoning model follows to run the audit.

This tree is **Observed** research (sourced facts + comparison against an external repo). It is the map for the assessment handoff in [docs/roadmaps/mattpocock-skills-audit.md](../../docs/roadmaps/mattpocock-skills-audit.md). The assessment itself is **not** performed here — the deeper model runs it per [assessment-spec.md](./assessment-spec.md).

## Purpose

- Give the deeper reasoning model a **self-contained** map: catalog (what exists), index (how it maps to cursorEscape), priorities (what to assess first), and a spec (what to output per skill).
- Surface **what mattpocock does better** than the local tree and **where cursorEscape can improve**, prioritized by the owner's interest areas (wizard, writing-for-agents, review-based skills, architecture-shape skills).

## Documents

| Doc | Purpose |
|-----|---------|
| [catalog.md](./catalog.md) | Full-sweep catalog: every skill + repo infra with GitHub path, invocation type, purpose, file sizes, companion files, docs-mirror size |
| [index-and-priorities.md](./index-and-priorities.md) | Comparison index (Equivalent / Partial / Gap / Novel) against the local tree, priority tiers, cross-cutting infra learnings |
| [assessment-spec.md](./assessment-spec.md) | The handoff spec the deeper reasoning model follows: per-skill fields, output shape, adapt-proposal routing, infra assessments |
| [Handoff roadmap](../../docs/roadmaps/mattpocock-skills-audit.md) | Phased plan the deeper model (optionally Composer-conducted) executes: assessment sweep → merge triage → adaptation |

## Provenance

- Data re-fetched from the GitHub API tree at the pinned commit; raw files via `raw.githubusercontent.com` at the same pin.
- One-line skill purposes are **provisional** (from the repo's READMEs). The assessment spec requires verification against each skill's actual `SKILL.md` before any adapt decision.
- Catalog size figures are bytes from the pinned API tree.

## Observed labels

External-repo analysis only. Nothing here changes cursorEscape contracts; `skills/`, `agents/`, `workflow/`, `rules/`, and `overlays/` are untouched by this tree.

## Related

- [Research index](../_index.md)
- [Roadmaps index](../../docs/roadmaps/_index.md)
- [Theo fleet skill management](../theo-fleet-skill-management.md)
- [Skill source and host overlays](../../docs/featureArchitecture/skill-source-and-host-overlays.md)