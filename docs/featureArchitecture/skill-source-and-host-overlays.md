# Skill source and host overlays

**Last updated:** 2026-09-20

## Context

cursorEscape authors one portable workflow and projects it across seven stacks—currently Cursor, OpenCode, Antigravity, VS Code, Cline, Kilo Code, and Codex—without a second authored documentation tree. This companion repository is the source of truth for skills, agents, rules, workflows, report schemas, and registry-owned semantic order.

Host directories are install targets and harness homes. They may contain launch mechanics, permissions, host-only composition, and thin wrappers, but never a second canonical procedure.

---

## Substance

### Companion-pointer architecture (Required)

1. Canonical prose lives in repo-root `workflow/`, `skills/`, `agents/`, and `rules/`.
2. Canonical Markdown owns procedure language; manifests own destinations and bindings; registry catalogs own machine metadata and composition order.
3. Host overlays contain thin or composed harness: load surfaces, permissions, launch mechanics, host substitutions, and pointers.
4. Deep procedure is read from the companion through canonical tokens such as `{{COMPANION_ROOT}}/workflow/...`.
5. A host procedure mirror is not a source of truth and must not be reintroduced as a permanent load path.

### Canonical homes (Required)

| Kind | Canonical home | May vary by host? |
| --- | --- | --- |
| Shared loop | `workflow/` and [`intended-workflow.md`](./intended-workflow.md) | No |
| Deep procedure | `workflow/*.md` | No |
| Skill contracts | `skills/*/SKILL.md` | No host IDs in shared bodies |
| Agent contracts | `agents/*.md` | No |
| Always-on gates | `rules/*.md` | No |
| Host overlay | `overlays/<stackId>/` | Yes, for mechanics and restrictions |
| Machine metadata | `catalog/*.json` | No |
| Destinations | Host manifests | Yes |
| Regression output | Render baselines | Host-specific, but generated |

`docs/featureArchitecture/` and `docs/SOPs/` are this-repository design and operations documentation; they are not a portable replacement for the root contract trees.

### Job and sync boundary (Required)

[`scripts/Sync-HostHarness.ps1`](../../scripts/Sync-HostHarness.ps1) is the operator entry for host harness sync. Dry-run is the default. Live Apply requires fresh explicit owner authorization, all-host Apply is normative, and single-stack `-AllowSkew` is only an explicitly owner-authorized recovery exception as defined by [`procedure-registry.md`](./procedure-registry.md#live-apply-boundary).

Sync is global-preflighted: every selected stack is planned and checked before any write pass. It does not create ad hoc backups; registered render baselines are restore and regression anchors. No normalization or reviewer step writes to live hosts.

### Per-entry sourcing (Required)

Manifest copy entries resolve explicit source classes rather than relying on ambiguous relative paths:

| Class | Meaning |
| --- | --- |
| Plain overlay path | File authored in the registered overlay. |
| `base:` | Canonical root body composed or copied into a host destination. |
| `shared:` | A shared overlay-authored source registered for reuse across compatible host projections, with declared substitutions and exactly-once resolution. |
| Registry composition | `CompositionId` selects semantic order; manifests do not duplicate governed order. |

An entry must declare exactly one authoritative source path. Destination metadata in registry entries, unspecified substitutions, or duplicate composition order all fail closed.

### Allowed host differences (Required)

A host overlay may differ only where the host genuinely differs:

- launch routes and native agent identifiers;
- permission model and edit-denial representation;
- load surface, restart/reload behavior, and path-resolution mechanics;
- host-only composition and managed-block boundaries;
- additional restrictions required by the host's safety model.

Allowed differences must remain local to overlays, manifests, adapters, or host SOPs. They may not change plan, review, isolation, CI-order, closeout, or Apply-authorization semantics.

### Promotion rule (Required)

When a host-specific pattern is required by more than one stack, first express the shared contract in the relevant root tree. Then project it through registry composition, manifests, or thin overlays. If only one host needs it, keep it in that host's overlay or SOP.

Do not promote a host workaround into canonical prose until its portable rule is explicit. Do not leave a shared concern in one overlay after a second stack needs the same behavior.

### Extension directories (Required)

Every host overlay may carry `rules/` and `hooks/` directories for host-specific content. `rules/` hosts custom procedural rules beyond the canonical set; `hooks/` hosts host-specific lifecycle hook configurations. Agents and skills already have per-host surfaces; workflows remain canonical, and host-specific workflow notes belong in instruction footers rather than a copied workflow tree.

One exception exists: `overlays/cursor/rules/` already contains native `.mdc` rule files. New stacks follow the same two-directory extension shape without importing that host's native format.

### Host examples (Required)

| Host | Appropriate overlay concern |
| --- | --- |
| Cursor | Native task IDs, User Rules, and hybrid `.mdc` wiring. |
| OpenCode | Absolute instruction wiring, AGENTS dual-write, skill paths, and reviewer edit denial. |
| Antigravity | Host subagent definitions and composed gate order. |
| VS Code | Instruction and handoff wiring for its native surfaces. |
| Cline / Kilo Code | Fresh task boundaries, workflow composition, and manifest-backed rules. |
| Codex | Managed AGENTS block, TOML agent routes, and the independent skill catalog. |

Host IDs and host permission JSON never belong in shared skill, agent, workflow, or rule bodies.

### Forbidden (Required)

- Two authored procedure trees for the same loop.
- Host sections inside a canonical body that multiple hosts load.
- A permanent host workflow mirror treated as source.
- Repo-root `adapters/` or other invented production trees outside the registered layout.
- Secrets, personal absolute paths, or live host state committed to this repository.
- Weakening a canonical gate in one overlay without an explicit, reviewed host-deviation contract.

---

## Implications

1. The cheapest durable path is one canonical body plus explicit host projection, not copied host variants.
2. Overlay drift is normal only where host mechanics differ; semantic drift is always a defect.
3. Adding a stack requires overlay, manifest, adapter, registry, SOP, CI, and fidelity updates in the same governance cycle.

---

## Related

- [Host adaptation fidelity](./host-adaptation-fidelity.md)
- [Procedure registry](./procedure-registry.md)
- [Instruction layering](./instruction-layering.md)
- [Intended workflow](./intended-workflow.md)
- [Editing companion workflow SOP](../SOPs/editing-companion-workflow.md)
- [Host harness sync README](../../scripts/host-sync/README.md)
- [Overlays index](../../overlays/_index.md)
