# Cost/latency assessment - production reviewer launches

Date: 2026-10-08. Companion to `findings.md` and `improvement-candidates.md`.
This document assesses what Reviewer A launches cost and where the spend
concentrates, then draws update suggestions from that. Data collection script:
`../scripts/cost-latency.ps1`; per-launch collated rows: `../data/cost-latency.csv`;
summary tables: `../data/cost-latency.md`.

## Method and caveats

- Tokens: cumulative `thread_token_usage` from `token_usage_record` events in
  each child session file (last record = launch totals). This is multi-turn
  cumulative accounting - a launch re-sends context every turn - so per-launch
  totals (median ~2M) exceed the 996k context window by design.
- Wall-clock: last minus first event timestamp per session file.
- Collation: joined onto the launch index (verdict class, repo, root thread,
  iteration, blocking/non-blocking/test-docs/batchable counts) in
  `cost-latency.csv`.
- Caveats: 94.5% of input tokens were served from cache, so token totals are
  not dollar cost; output and reasoning tokens are the scarcer resource.
  Owner-aborted launches (5, external per owner) consumed real spend but are
  excluded from process attributions. Duration excludes any parent-side time
  between launches.

## Corpus-wide results (113 launches)

| Group | n | mean total tok | median total tok | mean out tok | median out tok | mean dur | median dur |
|---|---|---|---|---|---|---|---|
| CHANGES REQUESTED | 61 | 2,242,233 | 2,113,475 | 16,343 | 17,089 | 12.0 min | 11.0 min |
| APPROVED | 39 | 1,932,352 | 1,740,482 | 13,398 | 13,860 | 9.0 min | 9.7 min |
| ENVELOPE_REJECTED | 5 | 84,458 | 81,863 | 1,079 | 1,035 | 0.9 min | 0.9 min |
| NO_OUTPUT (owner-aborted) | 5 | 1,326,714 | 782,907 | 6,654 | 5,974 | 7.0 min | 9.1 min |
| FORMAT_DEVIANT | 3 | 146,348 | 130,149 | 1,086 | 1,021 | 0.7 min | 0.7 min |

Totals: 219,632,860 tokens (218.1M input, 206.1M of it cached; 1.56M output,
0.96M of it reasoning) and 18.6 reviewer-hours.

Spend share by verdict:

| Group | Tokens | Share |
|---|---|---|
| CHANGES REQUESTED | 136,776,228 | 62.3% |
| APPROVED | 75,361,731 | 34.3% |
| NO_OUTPUT (owner-aborted) | 6,633,568 | 3.0% |
| FORMAT_DEVIANT | 439,044 | 0.2% |
| ENVELOPE_REJECTED | 422,289 | 0.2% |

## Block-level collation (traced loops)

Oct-6 CR streak (thread `01a0fd1a`, 16:52-19:27; 5 CR + closing APPROVED):

| Time | Verdict | Tokens | Duration |
|---|---|---|---|
| 16:52 | CR | 5,182,143 | 19.1 min |
| 17:29 | CR | 2,822,994 | 12.2 min |
| 17:50 | CR | 3,333,962 | 16.3 min |
| 18:13 | CR | 2,360,043 | 11.1 min |
| 19:15 | CR | 1,819,837 | 11.6 min |
| 19:27 | APPROVED | 1,279,616 | 7.9 min |
| **Block total** | | **16,798,595** | **1.3 h** |

Oct-8 cap block (iter 1-4 CR, then relaunch APPROVED): 4,465,830 / 1,424,687 /
1,698,511 / 1,967,568 / 1,905,984 tokens = **11,462,580 tokens / 1.0 h**
across 5 launches.

Patterns visible in the collation:

- The **first CR of a block is the most expensive** (5.2M and 4.5M in the two
  blocks) - it audits the largest, least-fixed changeset. Later CRs shrink but
  stay in the 1.3-3.3M band because every re-run is a full audit.
- The closing APPROVED costs ~1.3-1.9M - roughly one extra "launch tax" per
  block, by design (reviewers never approve on the same pass that fixed).
- Multi-CR blocks are the expensive unit: 11-17M tokens and ~1 hour each.
- Envelope rejections are token-cheap (~84k each) but each one costs a full
  parent round-trip and a relaunch; their cost is cycle time, not tokens.
- Owner aborts still burned ~6.6M tokens - real spend, external cause.

## Interpretation

1. **Loop churn, not gate failures, is where the money goes.** Gate-related
    classes (envelope, format) are 0.4% of spend; CR iterations are 62.3%.
    This matches the findings doc: the missing fix-verification mechanism
    cannot tell "same findings reopened" from "new surface found", and every
    re-run pays full-audit price for the deepest parts of the changeset again.
2. **Cache changes the cost model.** With 94.5% cached input, the scarce
    resources are output/reasoning tokens (~1.56M total) and wall-clock
    (18.6 h), not raw input. Arguments for or against contract changes should
    therefore weigh latency and cycle count at least as much as tokens.
3. **The convergent-block baseline is estimable.** A block that converged in
    CR + APPROVED would cost roughly first-CR + closing-APPROVED (~6-7M based
    on observed shapes). The two traced blocks spent 1.7-2.5x that baseline.
    That gap is the upper bound of what fix-verification could save - an upper
    bound only, because both traced blocks found genuinely new issues each
    pass, which fix-verification would not have prevented.

## Suggestions for updates

These are proposals only; nothing has been applied outside this scratch
document.
Owner decisions 2026-10-08: S3 declined, S4 declined with a recorded
principle; S1-S2 are folded into `improvement-candidates.md` candidate
updates; S5-S6 unchanged.

### S1. Reframe candidate 1's success metric (edit `improvement-candidates.md`)

The payload gate (candidate 1) is confirmed worth doing, but its measured
saving is launches and cycle time, not tokens (rejections cost 0.2% of spend).
Update its success metric and trade-off lines to say "removes ~1 wasted launch
cycle per occurrence and the parent relaunch loop", not "saves tokens".

### S2. Add a cost argument - with the honest caveat - to candidate 2 (edit `improvement-candidates.md`)

Candidate 2 (fix-verification) now has a quantified churn incentive: CR
launches are 62.3% of spend and multi-CR blocks cost 11-17M tokens each.
Add to its "Why it works": the loop currently cannot distinguish reopened
findings from new surface; cost telemetry makes that visible. Add to its
trade-offs: traced streaks found genuinely new issues each pass, so expected
token savings are unproven; guaranteed gains are attribution and auditable cap
decisions.

### S3. Record cost in the closeout report - DECLINED (owner)

The parent closeout already reports launch counts and CI results. Add two
lines: `Reviewer block tokens: <sum>` and `Reviewer block wall-clock: <sum>`
(derivable from session events by the same method as this assessment, or
tracked approximately by the parent from launch events). Cost-free to collect
retroactively; makes future cap decisions data-driven.

**Declined (owner note 2026-10-08):** "I don't think this is necessary."
Recorded for history; cost stays survey-context only.

**OWNER NOTE**

"I don't think this is necessary"

### S4. Exploratory: cost-aware pressure release - DECLINED (owner principle recorded)

Once S3 makes block cost visible, the contract's existing Renew /
Focus-narrow mechanisms get a cheap trigger: if a block's spend exceeds roughly
2x the estimated convergent baseline (first-CR + closing-APPROVED, observed
~6-7M tokens) without fix-verification evidence of convergence, the parent
considers Focus-narrow (shrink the reviewed surface) instead of a fourth
full-audit launch. Mark as exploratory: the 11-17M blocks each found real new
issues, so this trades escape-detection depth for spend and should require the
candidate-2 attribution signal before acting.

**OWNER NOTE**

"This is thinking about it in the wrong terms. The review loop is costly, yes, and efforts should be made to reduce iterations and wall clock time especially yes, but the iterative review is specifically for quality control. It is expected to be costly, and that is an accepted price. We do not want to reduce code or application quality in *any* respect, and any suggestions should be mindeful of that"

**Assessment: declined, and the principle generalizes.** S4 optimized the
wrong objective. Recorded principle for all future suggestions: the iterative
review is quality control; its cost is an accepted price. Efficiency work
targets redundant cycles and unverifiable trust (candidate 2), never review
depth; anything that could reduce review quality in any respect is off the
table regardless of savings.

### S5. Keep the collated index current (no repo change)

`cost-latency.csv` is the join key for any future re-run (candidate 6 in
`improvement-candidates.md`): rerunning `mine-launches.ps1` +
`quantitative-profile.ps1` + `cost-latency.ps1` after new usage accumulates
refreshes every number in this document in minutes.

### S6. Cross-document consistency (edits already applied)

`deeper-data-assessment.md` was updated when this data landed: its deeper-look
1 is marked DONE with headline results, and its Net section now reflects the
launch-discipline framing for candidate 1 and the quantified churn incentive
for candidate 2. `findings.md` and `improvement-candidates.md` updates are
covered by S1-S2 above and intentionally not yet applied - they are owner
decisions like the rest.

## Limitations

- Token totals are provider-side accounting including cache reads; they are
  not a billing statement.
- Two consumer repos; block-shape conclusions come from two traced blocks and
  may not generalize to other change profiles.
- Duration excludes parent-side think time between launches, so per-block
  wall-clock undercounts true end-to-end latency.
