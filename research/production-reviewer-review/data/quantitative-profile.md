# Production reviewer - quantitative profile

Corpus: 113 Reviewer A launch sessions across 3 distinct root threads and 2 repos.

## Verdict distribution

| Verdict | Count | % |
|---|---|---|
| CHANGES REQUESTED | 61 | 54.0% |
| APPROVED | 39 | 34.5% |
| ENVELOPE_REJECTED | 5 | 4.4% |
| NO_OUTPUT | 5 | 4.4% |
| FORMAT_DEVIANT | 3 | 2.7% |

## Review iteration (within block)

| Iteration | Count | % |
|---|---|---|
| 1 | 25 | 22.1% |
| 2 | 26 | 23.0% |
| 3 | 16 | 14.2% |
| 4 | 9 | 8.0% |
| unspecified | 37 | 32.7% |

## Per-repo launches

| Repo | Launches |
|---|---|
| curriculumConversion | 80 |
| easyPeasyWebsite | 33 |

## Required-section compliance

| Section | Present | % |
|---|---|---|
| Blocking findings | 102 | 90.3% |
| Non-blocking findings | 101 | 89.4% |
| Architecture alignment | 102 | 90.3% |
| Supersession closure | 71 | 62.8% |
| Lifecycle and naming closure | 71 | 62.8% |
| Regression matrix | 102 | 90.3% |
| Blocking test/docs | 102 | 90.3% |
| Batchable (deferred) | 102 | 90.3% |
| CI gate status | 102 | 90.3% |

## Finding counts per launch

- blockingCount: n=113, mean=0.75, median=0, max=5, zero=64 (56.6%)
- nonBlockingCount: n=113, mean=0.07, median=0, max=1, zero=105 (92.9%)
- blockingTestDocsCount: n=113, mean=0.68, median=0, max=5, zero=69 (61.1%)
- batchableCount: n=113, mean=1.81, median=2, max=8, zero=31 (27.4%)

- Blocking findings include file:line-style evidence in 45/113 launches (39.8%)
- CI mode line present in parent payload: 56/113 (49.6%)
- Completion gate = review-loop: 82/113 (72.6%)

## Era split (contract changes)

| Era | Launches | APPROVED | CR | Non-verdict | Supersession section | Lifecycle section |
|---|---|---|---|---|---|---|
| pre-supersession (to 2026-09-27) | 33 | 18 | 13 | 2 | 0 | 0 |
| supersession+lifecycle (2026-09-28 to 2026-10-07) | 73 | 19 | 43 | 11 | 64 | 64 |
| post short-form (2026-10-08+) | 7 | 2 | 5 | 0 | 7 | 7 |

## Multi-launch loops (threads with 2+ Reviewer A launches)

| Root thread | Repo | Launches | Verdict sequence | Iterations |
|---|---|---|---|---|
| 01a0fd1a-1fca-7323-b176-711565cfa4d8 | curriculumConversion | 77 | CR > OK > NO_OUTPUT > CR > FORMAT_DEVIANT > CR > FORMAT_DEVIANT > FORMAT_DEVIANT > OK > CR > CR > OK > CR > CR > OK > OK > CR > CR > ENVELOPE_REJECTED > ENVELOPE_REJECTED > CR > OK > CR > CR > OK > OK > NO_OUTPUT > OK > CR > ENVELOPE_REJECTED > CR > CR > CR > CR > CR > OK > CR > CR > ENVELOPE_REJECTED > CR > CR > CR > CR > CR > CR > CR > OK > CR > CR > OK > CR > CR > CR > CR > CR > OK > CR > OK > CR > CR > NO_OUTPUT > CR > CR > ENVELOPE_REJECTED > OK > CR > OK > OK > CR > OK > OK > CR > CR > CR > CR > OK > CR | 1,2,1,2,3,?,2,3,?,1,2,3,1,2,3,4,?,1,2,2,2,2,?,?,?,?,?,4,?,?,?,?,?,?,?,2,?,?,3,4,1,2,2,1,2,3,4,?,?,3,4,1,2,1,2,3,1,2,3,?,?,2,3,4,1,?,?,?,1,1,1,1,2,3,4,?,? |
| 01a08a83-ac95-70b2-ba36-e30a105d3b23 | easyPeasyWebsite | 33 | OK > CR > OK > OK > OK > OK > CR > OK > OK > NO_OUTPUT > OK > NO_OUTPUT > OK > CR > CR > CR > CR > OK > CR > CR > OK > OK > OK > OK > CR > OK > OK > OK > CR > OK > CR > CR > CR | ?,1,2,3,4,1,2,3,?,?,?,1,2,?,?,?,?,1,1,2,3,4,?,?,1,2,?,1,1,2,1,2,3 |
| 01a0f6b1-65bf-7b83-bb45-1ed91ff51736 | curriculumConversion | 3 | CR > CR > OK | 1,2,3 |

## Launches per day

| Date | Launches |
|---|---|
| 2026-09-11 | 9 |
| 2026-09-12 | 2 |
| 2026-09-14 | 16 |
| 2026-09-15 | 6 |
| 2026-10-01 | 3 |
| 2026-10-03 | 9 |
| 2026-10-05 | 3 |
| 2026-10-06 | 31 |
| 2026-10-07 | 27 |
| 2026-10-08 | 7 |

