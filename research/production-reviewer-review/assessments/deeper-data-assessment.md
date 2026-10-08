# Would a deeper data look genuinely improve this survey?

Date: 2026-10-08 (cost/latency look completed same day). Short answer: **for
the top improvement candidates, no - the current corpus is sufficient.** The
first targeted deeper look (cost/latency) has now been executed; two more have
real payoff, and one core question (APPROVED trustworthiness) needs data this
survey cannot extract from transcripts alone. Everything else has diminishing
returns.

**Owner acceptance (2026-10-08):** the owner confirmed this document contains
no OWNER NOTE and stated everything here is accepted. Conclusions stand as
written; deeper look 3 (post-APPROVED defect tracing) remains optional and
owner-initiated per its own terms.

## What the current data already settles

Candidates 1, 3, and 4 (payload gate, iteration demotion, non-blocking lane)
rest on counts that are mechanical and already measured: 5 envelope rejections,
32.7% missing iteration, 8 blocking-slot misuses, 92.9% zero non-blocking.
More data would tighten confidence intervals, not change the direction. These
can proceed on current evidence.

## Deeper looks with genuine payoff

### 1. Cost/latency per launch - DONE (2026-10-08)

Executed via `../scripts/cost-latency.ps1`; per-launch collated rows (verdict,
repo, thread, iteration, finding counts, duration, token breakdown) in
`../data/cost-latency.csv`; summary in `../data/cost-latency.md`. Source:
cumulative `thread_token_usage` from `token_usage_record` events; duration =
last minus first event timestamp.

**Headline results (113 launches, 219.6M total tokens, 18.6 reviewer-hours;
94.5% of input tokens were cached):**

| Group | n | mean total tok | mean out tok | mean duration |
|---|---|---|---|---|
| CHANGES REQUESTED | 61 | 2,242,233 | 16,343 | 12.0 min |
| APPROVED | 39 | 1,932,352 | 13,398 | 9.0 min |
| ENVELOPE_REJECTED | 5 | 84,458 | 1,079 | 0.9 min |
| NO_OUTPUT (owner-aborted) | 5 | 1,326,714 | 6,654 | 7.0 min |
| FORMAT_DEVIANT | 3 | 146,348 | 1,086 | 0.7 min |

Traced blocks, collated with the loop-shape data:

- Oct-6 CR streak (thread `01a0fd1a`, 5 CR + closing APPROVED):
  **16.8M tokens / 1.3 hours** across 6 launches. The deepest CR was the
  first (5.2M); later CRs shrank (1.8-3.3M); the APPROVED cost 1.3M.
- Oct-8 cap block (iter 1-4 CR + relaunch APPROVED): **11.5M tokens /
  1.0 hour** across 5 launches.
- Envelope rejections: 422k tokens / 4.1 minutes total - cheap per launch
  (~84k each) because they reject fast, so their real cost is the parent's
  relaunch cycle and lost wall-clock, not tokens.
- Owner-aborted launches still consumed ~6.6M tokens before abort - real
  spend, but not process-attributable.

**What this changes in the improvement list:**

- Candidate 1 (payload gate): confirmed worth doing, but the saving is mostly
  launches, latency, and parent relaunch cycles - the token cost of a
  rejection is small.
- Candidate 2 (fix-verification): the cost mass sits exactly where the
  convergence gap sits - CR launches are 62.3% of corpus token spend, and
  multi-CR blocks cost 11-17M tokens each. Honest caveat: the traced streaks
  found genuinely new issues each pass, so fix-verification would not
  automatically have shrunk them; its guaranteed gains are attribution
  (reopened vs new per block) and auditable cap decisions, with token savings
  plausible but unproven. The cost data strengthens the case for measuring
  this; it does not by itself prove the savings.

### 2. Envelope-content quantification before implementing candidate 2 - DONE (2026-10-08)

Executed via `../scripts/envelope-quant.ps1`; full assessment with suggestions
in `envelope-content-assessment.md`; collated rows in
`../data/envelope-content.csv`. Headlines: per-command CI rows present in
92.9% of payloads while the literal `ci mode` label appears in only 48.7%;
the strict `Review iteration: N` phrase in 67.3%, with variant loop-state
phrasings common and enforcement arbitrary (8 CRs blocked on the literal
format while 12 APPROVEDs proceeded without it); all 5 envelope rejections
were content misses, not identity misses; Focus-narrow 3.5%, Renew 0% - so
candidate 2 must introduce its claims input fresh; payloads are slim (median
3.4k chars), so the claims block's weight is a non-issue; evidence frame 0%.

### 3. Bounded post-APPROVED defect tracing (only if that question matters to the owner)

The survey's blind spot is the false-negative rate: nothing in the transcripts
records defects discovered after APPROVED. A bounded version - manually trace
5-10 APPROVED phases forward through the parent thread for fixes or incidents
referencing things the reviewer passed - would give a first, rough escape-rate
estimate. This is manual reading, hours not minutes, and a small sample; it
answers "does APPROVED mean anything" more credibly than any automated pass.
Recommend only if the owner intends to act on APPROVED trustworthiness;
otherwise the honest label "unmeasured" in findings.md stands.

## Deeper looks with low or negative value now

- **Scanning more threads/repos:** there is no more data to seek - 113 launches
  across 3 threads is everything Codex has produced since the loop went live.
  The corpus grows organically; re-running the existing scripts after a few
  weeks of usage (candidate 6) is the right move, not deeper mining of a fixed
  pool.
- **Full 105-pair prod/bug overlap scan:** automatable, but the sampled pair
  plus the rubric's clear leg split make systematic overlap unlikely; value is
  refinement, not direction. Do it only if leg-split complaints appear.
- **More supersession/verbosity analysis:** a finished prior study plus the
  7.9% category yield here already bound the question; owner ruled it out of
  scope.
- **Bigger qualitative samples:** the 8 sampled outputs were consistent;
  additional samples would mostly re-confirm the actionability pattern.

## Net

Proceed with candidates 1, 3, 4 on current evidence; the cost look confirms 1
is about launch discipline more than tokens, and adds a quantified churn
incentive (62.3% of spend in CR launches; 11-17M-token blocks) behind
candidate 2. The envelope look has now de-risked candidate 2's design: define
the claims block by content (not literal header), sized against measured
payload norms, with S2/S3/S6 of `envelope-content-assessment.md` as companion
contract wording fixes. Deeper look 3 is a separate, owner-initiated question
about review trust, not a prerequisite for any improvement candidate.
