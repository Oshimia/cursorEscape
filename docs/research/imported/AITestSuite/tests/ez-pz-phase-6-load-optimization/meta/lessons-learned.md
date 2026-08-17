> **Imported research** — Source: AITestSuite `tests\ez-pz-phase-6-load-optimization\meta\lessons-learned.md`; copied 2026-08-17 into cursorEscape. Status: Observed/eval-packaging. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Lessons learned — why Phase 6 is a strong AI benchmark

Derived from the real easyPeasyWebsite Phase 6 implementation (multiple plan iterations, remediation passes, reviewer loops).

## What makes it hard

1. **Cross-layer scope** — Backend API contract, SSR pages, client components, shared account UI, embed routes, and docs must align.
2. **Fail-closed semantics** — `{}` vs `null`, partial batch maps, prefetch HTTP errors, and SSR completeness guards are easy to get wrong.
3. **Route-specific dedup** — Dashboard account settings vs admin account settings behave differently (`forceMount`, bootstrap atoms, SSR prefetch).
4. **Test-first tension** — Characterization tests encode old O(N) behavior; AI must flip tests and implementation together.
5. **Complete changeset** — New helper modules (`prefetch.js`, `progressPrefetch.js`, skeleton components) must ship with importers or CI breaks on clean checkout.
6. **Reviewer drift** — Incomplete fixes can increase finding counts on re-review (untracked files, partial remediation).
7. **Scope boundary** — Phase 7 items (integration regression, manual smoke) tempt scope creep but are out of scope.

## Autonomy failure modes

- Stopping to ask which dedup strategy to use (documented in decision gate)
- Plan approval loops before implementation
- User steering after reviewer returns CHANGES REQUESTED without autonomous fix iteration
- Real supervised run: **4–8+ user-input stops**; strong autonomous target: **0–2 stops**

## What separates good submissions

- Reads SOPs and architecture docs before coding
- Backend contract tests before route implementation
- Single coherent changeset with all new files
- Fail-closed progress and prefetch paths
- Load tests for admin bootstrap vs dashboard SSR paths separately
- Updates architecture doc in same pass as code

## Reference commits

| Role | Commit | Label |
|------|--------|-------|
| Baseline | `0fdb57a` | Phase 5 complete |
| Target | `abc11cc` | Phase 6 complete |

## Metrics (frozen)

| Metric | Baseline | Target |
|--------|----------|--------|
| Frontend tests | 571 | ≥ 583 |
| Backend tests | 210 | ≥ 210 |

## Known traps (see REMEDIATION_CHECKLIST.md)

C1 partial map, A1/A2 account dedup, prefetch fail-closed, SSR progress resync on enrollment, incomplete git changeset.
