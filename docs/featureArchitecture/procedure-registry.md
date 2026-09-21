# Procedure registry

**Last updated:** 2026-09-22

## Context

The procedure registry is the sole writable source for machine metadata used to project portable procedure onto hosts. Canonical Markdown remains the sole source of procedure prose. Host manifests remain the sole source of destinations and host-only bindings. This separation prevents prose, composition order, and install destinations from drifting into separate authorities.

## Substance

### Ownership model

| Concern | Owner |
| --- | --- |
| Procedure language | `workflow/`, `skills/`, `agents/`, and `rules/` Markdown. |
| Identity, aliases, required reading, authority/isolation, loop/gate, fail-loud behavior, host representation, explicit-only policy | Registry catalogs under `catalog/`. |
| Composition references and semantic order | `catalog/workflows.json`. |
| Destinations, excludes, host substitutions, and binding | Host manifests under `scripts/host-sync/manifests/`. |
| Host-only leaves and safety boundaries | Registered overlays and adapters. |
| Byte-exact regression anchors | Committed render baselines. |

Registry entries are closed to their declared ownership fields. A skill entry mirrors canonical `disable-model-invocation`, while `explicitOnly` comes from inventory. Registry entries reject destination metadata because manifests own bindings.

### Canonical source flow

To change an existing governed entity:

1. Edit prose in the canonical root tree, or machine metadata in the appropriate catalog.
2. Edit hand-authored overlay wrappers only when they mirror prose or contain genuine host mechanics.
3. Run normalization Fast CI and `git diff --check`.

To add a governed entity:

1. Create the canonical Markdown source and frontmatter.
2. Add exact inventory coverage.
3. Add the registry entry with required identity, authority, isolation, loop/gate, fail-loud, host representation, and applicability fields.
4. Add a composition when order matters, bind it from the host manifest by `CompositionId`, and register host-only leaves.
5. Run Fast CI for schema/inventory closure and Full CI for host, fixture, and baseline closure.

Any ambiguity fails closed; the registry does not infer missing identity or order from host files.

### Hooks and overlay extension surfaces

Lifecycle hooks are currently host-only overlay and manifest concerns; the registry schema and validator do not yet have a `hooks` entity kind. That future kind will require minimum fields `id` and either `source` (inventory) or `body` (catalog). Separately, every registered overlay has one `rules/` and one `hooks/` extension surface. Their exact paths, filenames, and placeholder content are CI-owned; a placeholder is structural reserve capacity, not a deployed destination or active behavior.

### Fail-closed boundary

`scripts/normalization/ProcedureRegistry.psm1` validates schema/version, exact inventory coverage, IDs, canonical identity and first-read contracts, required reading, aliases, authority/isolation, loop/gate policy, fail-loud behavior, host representation, route identity, launch evidence, skill flags, explicit applicability, canonical rule/workflow sources, one-to-one composition coverage, duplicate-free semantic order, and path containment.

Restore baselines fail closed when absent or inaccessible. A checker may explicitly waive host-profile inaccessibility in a disposable environment, but it may not waive an absent registered baseline.

### Blocking guard coverage

Every governed ownership class has a blocking guard in Fast CI:

| Class | Guarded invariant |
| --- | --- |
| Cursor hybrid composition | Registry-owned order; forbidden legacy composition fields. |
| OpenCode dual-write | Identical instruction/AGENTS gate and composition ownership. |
| Antigravity | Managed composition and runtime rejection of forbidden fields. |
| Cline and Kilo Code | Registry-owned composition and explicit destination binding. |
| Codex managed AGENTS block | Managed-block boundary and writer-side rejection of unknown/divergent composition. |
| Overlay extension surfaces | Exactly seven `rules/` and seven `hooks/` paths with pinned filenames, UTF-8 no-BOM placeholder bytes, and fail-closed Unit-suite propagation. |
| Source ingress | Missing, BOM-corrupted, or noncanonical sources fail. |
| Generated-file boundaries | Protected roots and unrestricted output roots fail. |
| Deterministic rendering | Double render must produce identical bytes. |

Full CI additionally coordinates focused host adapters, lifecycle fixtures, drift fixtures, and the disposable render pass.

### Baselines and renderer

Committed baselines are generated regression anchors, never hand-edited expectations. When output legitimately changes, render through the registered deterministic path, review the result, and commit the baseline in the same changeset.

`scripts/normalization/Render-ProcedureRegistry.ps1` renders only repository-owned explicit output roots unless explicitly invoked for the disposable Full CI temporary root. `scripts/normalization/Test-ProcedureRegistryViews.ps1` double-renders and validates registry views, host-agent coverage, composition order, resolver seams, and fail-closed boundaries.

### CI gates

| Gate | Sole entry point | Role |
| --- | --- | --- |
| Fast | `scripts/normalization/Invoke-NormalizationFastCI.ps1` | Blocking registry, inventory, current-state, host-sync Unit, extension-surface, focused Codex-render, hygiene, and diff checks. |
| Full | `scripts/normalization/Invoke-NormalizationFullCI.ps1` | Fast plus consolidated host, all-stack disposable dry-run, Codex lifecycle, drift fixture, and disposable render verification. |

There is exactly one Fast entry point and one Full entry point. Host-sync suite scripts are internal Full CI components, not alternate entry points.

### Live Apply boundary

Normalization CI and documentation are non-live. For every Apply surface:

1. Dry-run is always allowed.
2. Live Apply requires fresh explicit owner authorization.
3. All-host Apply is normative.
4. Single-stack `-AllowSkew` is only an explicitly owner-authorized recovery exception.

Pre-Apply requires an all-host dry-run, read-only drift report, baseline readiness, and Full CI. Post-Apply requires dry-run/drift re-check, parity confirmation, host restart/reload, and the applicable host smoke matrix.

---

## Implications

1. Never move semantic order into a manifest, wrapper, or renderer ad hoc.
2. Never edit a baseline to hide drift; regenerate it only after reviewing the legitimate source/output change.
3. Never let a reviewer or CI gate perform a live host write.

---

## Related

- [Skill source and host overlays](./skill-source-and-host-overlays.md)
- [Host adaptation fidelity](./host-adaptation-fidelity.md)
- [Editing companion workflow SOP](../SOPs/editing-companion-workflow.md)
- [Host harness sync README](../../scripts/host-sync/README.md)
