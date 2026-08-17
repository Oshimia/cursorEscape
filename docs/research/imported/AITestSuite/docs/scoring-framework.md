> **Imported research** — Source: AITestSuite `docs\scoring-framework.md`; copied 2026-08-17 into cursorEscape. Status: Observed/eval-packaging. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Scoring framework

Cross-test dimensions for evaluating AI coding agent submissions. Each test defines criterion rows in `evaluation/SCORING_RUBRIC.md`; this document defines suite-wide rules.

## Incremental scoring model

Every submission receives a **0–100 composite score** plus per-dimension and per-criterion breakdowns. There are **no automatic fails** and **no score caps** — partial credit is always recorded.

```text
composite = (ci_score × 0.25) + (rubric_score × 0.50) + (autonomy_score × 0.25)
```

| Dimension | Weight | Source |
|-----------|--------|--------|
| CI health | 25% | `ci-results.json` from `run-ci-gate.ps1` |
| Implementation rubric | 50% | Per-row scores in `rubric-scores.json` |
| Autonomy | 25% | `user_input_stops` per test's `USER_INPUT_STOPS.md` |

## Dimension 1 — CI health (25%)

Fully incremental — a red build still earns partial credit.

| Sub-metric | Weight within CI | Score |
|------------|------------------|-------|
| `frontend lint` exit 0 | 20% | 100 or 0 |
| `frontend test` exit 0 | 20% | 100 or 0 |
| `backend lint` exit 0 | 20% | 100 or 0 |
| `backend test` exit 0 | 20% | 100 or 0 |
| Frontend test count ratio | 10% | `min(actual / target, 1.0) × 100` |
| Backend test count ratio | 10% | `min(actual / target, 1.0) × 100` |

Targets come from `meta/target-metrics.json` in the test package.

### `ci-results.json` schema

Written by `scripts/run-ci-gate-core.ps1` (default path: `<WorkspacePath>/ci-results.json`):

```json
{
  "version": 1,
  "workspacePath": "...",
  "evaluationRoot": "tests/<test-id>/",
  "steps": [
    { "name": "frontend-lint", "exitCode": 0 },
    { "name": "frontend-test", "exitCode": 0, "testsPassed": 1079, "testsTarget": 1079 },
    { "name": "backend-lint", "exitCode": 0 },
    { "name": "backend-test", "exitCode": 0, "testsPassed": 345, "testsTarget": 345 }
  ],
  "ciScore": 100,
  "recordedAt": "2026-07-10T12:00:00Z"
}
```

## Dimension 2 — Implementation rubric (50%)

Each test publishes weighted criteria in `evaluation/SCORING_RUBRIC.md` (human source) and `meta/rubric.json` (generated).

Scorers assign **0**, **0.5**, or **1.0** per criterion:

```text
rubric_score = Σ(weight × rowScore) / Σ(weight) × 100
```

### Severity guidance

| Severity | Typical weight | Notes |
|----------|----------------|-------|
| critical | 5–8 | Former automatic-fail traps (blob fetch, scope creep) |
| major | 3–4 | Core matrix behaviors |
| minor | 1–2 | Polish and edge-case UX |

High-weight critical rows materially lower the rubric dimension without zeroing CI or autonomy credit.

### Scorer input (`rubric-scores.json`)

```json
{
  "scores": {
    "P4-01": 1.0,
    "P4-04": 0.5
  },
  "userInputStops": 0
}
```

### Legacy shim (removed)

Use per-row `rubric-scores.json` only. See `SCORING_RUBRIC.md`.

## Dimension 3 — Autonomy (25%)

```text
autonomy_score = max(0, 100 - (user_input_stops × 12))
```

| Stops | Score | Interpretation |
|-------|-------|----------------|
| 0 | 100 | Fully autonomous |
| 1 | 88 | One clarification |
| 2 | 76 | Minor steering |
| 3 | 64 | Moderate dependency |
| 4 | 52 | Heavy hand-holding |
| 5+ | ≤ 40 | Poor autonomy |

Full counting rules: each test's `evaluation/USER_INPUT_STOPS.md`.

**Evaluator rule:** During a scored autonomy run, do not answer the AI's clarifying questions unless logging a stop.

## Interpretation bands (informational)

| Band | Composite | Meaning |
|------|-----------|---------|
| Excellent | 90–100 | Near-reference quality |
| Strong | 75–89 | Solid with localized gaps |
| Mixed | 50–74 | Partial success; rubric breakdown shows weak areas |
| Weak | 25–49 | Major gaps; some CI/rubric credit |
| Minimal | 0–24 | Broad failure |

## Informational fields (not in composite)

- `review_iterations_to_green` — process efficiency
- `reviewer_a_verdict` / `bugbot_verdict` — qualitative review outcome
- `wall_clock_minutes` — tie-breaker for leaderboards
- `category_breakdown` — derived from rubric rows by category

## `score-result.json` output

Written by `scripts/score-submission-core.ps1` (default: `<WorkspacePath>/score-result.json`):

```json
{
  "testId": "ez-pz-streaming-media-phase-4",
  "composite": 87.3,
  "band": "Strong",
  "dimensions": {
    "ci": { "score": 100, "weight": 0.25 },
    "rubric": { "score": 82.1, "weight": 0.50 },
    "autonomy": { "score": 88, "weight": 0.25 }
  },
  "categoryBreakdown": { "CoreImplementation": 90, "UxAndEdgeCases": 75 },
  "criteria": [{ "id": "P4-04", "score": 0.5, "weight": 6, "weightedContribution": 2.1 }],
  "userInputStops": 1,
  "recordedAt": "2026-07-10T12:00:00Z"
}
```

## Path contract

| Path | Location |
|------|----------|
| Submission workspace | Candidate copy of `baseline/` only (no `meta/` or `evaluation/`) |
| Test package (`EvaluationRoot`) | `tests/<test-id>/` — rubric, metrics, reference |
| `ci-results.json` | Submission workspace |
| `rubric-scores.json` | Evaluator-provided (often under `submissions/<run-id>/`) |
| `score-result.json` | Submission workspace (default) |

Per-test wrappers resolve `$RepoRoot` via `Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..")` from `evaluation/scripts/`.

## Reporting

Use each test's `evaluation/scorecard.template.md`. Always report:

- Composite score and band
- CI, rubric, and autonomy dimension scores
- Category breakdown and notable criterion gaps
- `user_input_stops`
- Model, date, wall time

See [`comparing-runs.md`](comparing-runs.md) for cross-run analysis.
