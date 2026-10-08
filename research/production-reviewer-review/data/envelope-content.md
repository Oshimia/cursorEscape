# Envelope-content quantification (113 payloads)

Rows collated: 113. Source: user envelope message(s) extracted from each child session; heuristics noted per row. Full rows: envelope-content.csv

## Contract-required inputs

| Element | Present | % |
|---|---|---|
| Repository/task context (non-empty envelope) | 113 | 100.0% |
| Review iteration (value) | 76 | 67.3% |
| Cumulative per-leg counts | 78 | 69.0% |
| Completion gate (any value) | 73 | 64.6% |
| Completion gate = review-loop | 72 | 63.7% |
| CI section present | 107 | 94.7% |
| Literal `ci mode` label | 55 | 48.7% |
| Per-command CI rows (>=1 heuristic) | 105 | 92.9% |

## Optional contract inputs

| Element | Present | % |
|---|---|---|
| Applicable docs hint | 12 | 10.6% |
| Plan phase context | 47 | 41.6% |
| Review model | 13 | 11.5% |
| Evidence frame (fixed point + spec) | 0 | 0.0% |

## Renewal-path usage

| Element | Present | % |
|---|---|---|
| Focus-narrow declared | 4 | 3.5% |
| Renew mentioned | 0 | 0.0% |

## Envelope structure lines

| Line | Present | % |
|---|---|---|
| Host alias: | 112 | 99.1% |
| Isolation: | 112 | 99.1% |
| Authority: | 112 | 99.1% |
| Loop/gate: | 112 | 99.1% |

Illegal-override attempts in payloads: 4/113

## Value distributions

- Iteration values: 1: 25, 2: 26, 3: 16, 4: 9, missing: 37
- Completion gate values: review-loop: 72, sections: 1, missing: 40
- CI mode labels: Fast: 55, missing: 58
- Envelope size (chars): mean 3,508, median 3,391, min 1,335, max 7,174
- CI row-like lines per payload: mean 3.5, median 4, max 8

