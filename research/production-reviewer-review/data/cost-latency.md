# Cost/latency per Reviewer A launch

Corpus rows: 113 (missing token data possible for aborted launches). Source: cumulative thread_token_usage from token_usage_record events; duration = last minus first event timestamp.

| Group | n | mean total tokens | median total tokens | mean output tokens | median output tokens | mean duration (min) | median duration (min) |
|---|---|---|---|---|---|---|---|
| CHANGES REQUESTED | 61 | 2,242,233 | 2,113,475 | 16,343.4 | 17,089 | 12 | 11.0 |
| APPROVED | 39 | 1,932,352 | 1,740,482 | 13,397.6 | 13,860 | 9 | 9.7 |
| ENVELOPE_REJECTED | 5 | 84,458 | 81,863 | 1,078.6 | 1,035 | 1 | 0.9 |
| NO_OUTPUT | 5 | 1,326,714 | 782,907 | 6,653.6 | 5,974 | 7 | 9.1 |
| FORMAT_DEVIANT | 3 | 146,348 | 130,149 | 1,086.3 | 1,021 | 1 | 0.7 |

Corpus totals: 218,071,489 input tokens (206,102,016 cached), 1,561,371 output tokens (959,783 reasoning), 219,632,860 total tokens across 113 launches with token data.
Waste check - 5 envelope-rejection launches cost 422,289 total tokens and 4.1 minutes combined (pure orchestration overhead).


