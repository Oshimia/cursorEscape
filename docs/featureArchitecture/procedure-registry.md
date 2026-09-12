# Procedure registry

**Last updated:** 2026-09-13

## Context

Phase 1 introduces a writable semantic registry for machine metadata (agent identity, aliases, required reading, authority/isolation, loop/gate, fail-loud behavior, host representation, skill applicability, composition references, and semantic composition order). Canonical Markdown remains the sole source for procedure prose; manifests remain the sole source for destination/binding. This phase does not migrate canonical Markdown or host projections; `overlays/` remains runtime source until later phases.

## Substance

### Ownership model

Registry catalogs own machine identity, aliases, required reading, authority/isolation, loop/gate policy, fail-loud behavior, host representation, skill explicit-only policy, composition references, and semantic order. Markdown owns prose; manifests own destination/binding. Skill entries keep two distinct booleans: `modelInvocationDisabled` mirrors the canonical skill frontmatter `disable-model-invocation` flag, while `explicitOnly` must exactly match Phase 0 inventory `explicit_only` (currently only `opencode-headless-run` and `opencode-history-search`).

### Fail-closed boundary

`ProcedureRegistry.psm1` validates schema/version, exact Phase 0 inventory coverage, IDs, canonical identity and first-read contract, required reading, aliases, authority/isolation, loop/gate, fail-loud behavior, host representation, route identity, launch mechanism and evidence, both skill booleans (`modelInvocationDisabled` against frontmatter; `explicitOnly` against inventory), explicit skill applicability, rules/workflow canonical sources, one-to-one composition coverage, duplicate-free semantic order, and path containment. Schema items are closed to their declared ownership fields; skill registry entries reject destination metadata because manifests own bindings. Any ambiguity fails rather than falling back to host metadata. Historical baseline directories fail closed when absent or inaccessible; the checker's explicit sandbox opt-out waives inaccessibility only, and absence always fails.

### Renderer and CI

`Render-ProcedureRegistry.ps1` renders repository-owned explicit output roots; the sole Full CI disposable render passes an explicit temporary-root ownership switch, and the public renderer rejects temporary roots without it. Output roots are segment-checked so exact protected/source roots and the OS temporary root itself fail closed. `Test-ProcedureRegistryViews.ps1` double-renders, checks the public render seam, compares hashes, checks 49 host-agent rows, renders composition rows through `semanticOrder`, exercises resolver seams, and tests fail-closed edges. CI threads one repository root through normalization checks; it never writes committed managed views or live hosts.

## Phase 1 boundary

Registry is a new writable metadata source, but existing canonical Markdown, overlays, manifests, and baselines remain unchanged. Phase 1 consistency and render behavior are implementation-under-review, not owner-accepted. Migration can begin only after dual review, Full CI, and a later reviewed slice owns the projection switch.

## Implications / open questions

1. Host projection switch requires later reviewed slice with canonical managed-view byte-match.
2. Destination metadata must remain manifest-owned; registry entries reject it.
