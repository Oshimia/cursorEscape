> **Imported research** — Source: AITestSuite `tests\ez-pz-streaming-media-phase-2\meta\lessons-learned.md`; copied 2026-08-17 into cursorEscape. Status: Observed/eval-packaging. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Lessons learned — why Phase 2 is a strong AI benchmark

Derived from the real easyPeasyWebsite Phase 2 implementation ([agent transcript 530e8776](530e8776-21cc-446d-8ac4-e7d51a2c062c)): 4 review iterations, multiple blocking bugs, and significant architectural churn before dual approval.

## What makes it hard

1. **Deceptively small scope** — "just a hook" but token-ensure lifecycle parity with `useCdnBlobUrl` is subtle and easy to get wrong.
2. **ESLint asymmetry** — `useCdnBlobUrl.js` has a file-level `eslint-disable react-hooks/set-state-in-effect`; a naive copy of the pattern into a new file fails strict lint until the same exemption is applied with documented rationale.
3. **Auth gating** — Missing `isAuthenticated` check allows token ensure for logged-out users (iteration 1 blocking finding).
4. **Error lifecycle** — Stale errors persist after disable, logout, and re-login; each requires a separate fix and test (iterations 2–3).
5. **Retry semantics** — Must mirror blob hook (max 2 retries, 1s delay); effect cleanup that resets the retry counter causes infinite retry (iteration 4 blocking bug).
6. **storageKey reset** — Changing storage key after exhausted retries must reset counter and clear error (Bugbot iteration 3 finding).
7. **Architectural churn** — Real AI tried multiple abandoned approaches: `useEnsureMediaToken` wrapper, merging into `useCdnBlobUrl.js`, strict ESLint path list edits, session-ID error tracking — before settling on separate file with eslint-disable.
8. **Test timing** — Retry tests with fake timers failed; real-timer `waitFor` with timeouts was needed.

## Autonomy failure modes

- Stopping to ask which token-ensure pattern to use (documented: read `useCdnBlobUrl.js`)
- User steering after reviewer returns CHANGES REQUESTED without autonomous fix iteration
- Real supervised run: **1 user-input stop** ("worker deployed, continue") — eliminated in benchmark by baking Phase 1 into baseline
- Strong autonomous target: **0 stops**

## Review loop difficulty

| Iteration | Outcome | Key finding |
|-----------|---------|-------------|
| 1 | Both CHANGES REQUESTED | Missing auth gate, stale error on disable |
| 2 | Reviewer A CHANGES, Bugbot APPROVED | Error visibility, re-login flash |
| 3 | Reviewer A APPROVED, Bugbot CHANGES | storageKey reset missing |
| 4 | Both APPROVED | Infinite retry from cleanup counter reset |

**4 iterations to green** — significantly harder than typical single-pass hook implementations.

## What separates good submissions

- Reads `useCdnBlobUrl.js` first and mirrors token-ensure lifecycle exactly
- Adds comprehensive error/auth/retry/storageKey tests upfront
- Uses file-level eslint-disable with documented rationale (same as blob hook)
- Does not migrate consumers or touch worker
- Completes review loop autonomously

## Reference commits

| Role | Commit | Label |
|------|--------|-------|
| Parent | `f215c63` | Pre-streaming baseline |
| Baseline | `9bd636b` | Phase 1 complete |
| Target | `29cf960` | Phase 2 complete |

## Metrics (frozen)

| Metric | Baseline | Target |
|--------|----------|--------|
| Frontend tests | 1025 | ≥ 1041 |
| Backend tests | 345 | ≥ 345 |

## Known traps (see REMEDIATION_CHECKLIST.md)

E1 auth gate, E2–E4 error lifecycle, E5 storageKey reset, R1 infinite retry, L1 eslint-disable pattern, C1 no fetch/blob.
