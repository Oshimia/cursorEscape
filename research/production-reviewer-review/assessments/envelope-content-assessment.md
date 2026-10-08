# Envelope-content assessment - what parents actually send Reviewer A

Date: 2026-10-08. Companion to `findings.md`, `improvement-candidates.md`, and
`cost-latency-assessment.md`. This is the deeper look recommended before
implementing candidate 2 (fix-verification input): it quantifies what the 113
parent payloads actually contain, whether a renewal-shaped input already
exists to build on, and how the contract's "required inputs" behave in
practice. Collector: `../scripts/envelope-quant.ps1`; collated rows:
`../data/envelope-content.csv`; summary: `../data/envelope-content.md`.

## Method and caveats

The user envelope message(s) of each child session were extracted and pattern-
checked per element. Heuristics: iteration/gate/CI-label use anchored regexes;
"per-command CI rows" counts pass/fail/skipped/n-a-like lines (prose can
inflate it slightly); "iteration missing" means the strict contract phrase
(`Review iteration: N`) was absent - variant phrasings were re-checked manually
where noted below. This look is design input for candidate 2, not a verdict on
it.

## Findings

### 1. CI data is nearly always supplied - but formats vary widely

Per-command CI results are present in 92.9% of payloads (median 4 row-like
lines, max 8), but the literal `ci mode:` label appears in only 48.7% (all 55
say `Fast`). The contract's real acceptance bar (per-command rows) is met in
substance almost always; the label convention is honored half the time. No
launch was rejected for CI format alone; 12.7% of CRs policed CI substance
(claimed-only/skipped) per the category scan.

### 2. The "required" iteration input is enforced arbitrarily

- Strict contract phrase (`Review iteration: N`): 76/113 (67.3%; 1:25, 2:26,
  3:16, 4:9).
- Of the 37 without it, a manual re-check of the 12 APPROVED cases found 9
  carrying iteration in variant phrasings parents naturally write ("Completion
  gate: review-loop, iteration 1", "Follow-up review iteration: 1 of 4",
  "Loop metadata: current review iteration 3 of 4", "Review-loop state: Phase
  7C iteration 2 of a 4-iteration block", "Iteration: 1 of 4 in the fresh
  Phase 8B block"). Truly absent: 3 of those 12; corpus-wide the truly-absent
  rate is bounded between ~25% and 32.7%.
- Enforcement is inconsistent in both directions: 8 CR launches were blocked
  citing the missing literal `Review iteration: 1-4` format, while 12 APPROVED
  launches proceeded without the literal format (9 of them with variant
  phrasings). The requirement as written does not describe what parents send
  or what reviewers consistently require.

### 3. "Missing invocation envelope" rejections are usually content misses, not identity misses

All 5 ENVELOPE_REJECTED launches carried the full canonical identity block
(`Host alias:` / `Isolation:` / `Authority:` / `Loop/gate:` present in 112/113
payloads overall). What was missing was required content - task summary, gate,
or CI results. The rejection first-line ("missing invocation envelope") is
therefore misleading for diagnosis; the outputs do list the missing elements,
but the headline phrase mislabels the failure class.

Separately, exactly 1 launch (2026-09-11, APPROVED) lacked the canonical
structure lines entirely and was approved anyway - a 1/113 (0.9%) enforcement
gap on the identity block itself, from the early era.

### 4. No renewal-shaped input exists to build candidate 2 on

Focus-narrow appears in 4 payloads (3.5% - one Phase 8B block), Renew in 0.
Candidate 2's prior-findings claims input must be introduced fresh, not
derived from an existing renewal payload pattern.

### 5. Payloads are slim; a claims list adds marginal weight

Envelope size: mean 3,508 chars, median 3,391, max 7,174. A one-line-per-item
claims list for a typical block (3-6 findings) adds ~300-600 chars - under 20%
of the median payload. Payload weight is not a real objection to candidate 2.

### 6. Optional contract inputs are mostly dormant

Applicable docs hint: 10.6%. Plan-phase context: 41.6%. Review model: 11.5%.
Evidence frame (fixed point + spec path): 0 of 113 - the feature has never
been used on Codex.

### 7. Override language: 4 pattern hits, all benign scoping

Four payloads contain "treat as approved" - all the same construction:
`Boundaries (do not flag as missing, and treat as approved out-of-scope): no
editing/rescheduling/cancel of created classes`. That is parents pre-scoping
the changeset (legitimate task context), not verdict overrides. No genuine
override attempts found in 113 payloads. The gray zone is worth one contract
sentence (see S4).

### 8. One malformed gate value

Completion gate values: review-loop 72, `sections` 1 (malformed), missing 40.
Consistent with the profile's 72.6% review-loop figure (72/113 = 63.7% here;
the profile counted the malformed one toward "present").

## Design inputs for candidate 2 (fix-verification)

1. Introduce the claims list as a new named block; do not anchor it to
   Renew/Focus-narrow (unused).
2. Match the loop-state style parents already write: short `key: value` lines
   like the CI rows and "Loop metadata:" lines. Proposed shape:
   `Prior findings claims:` then one line per prior item, e.g.
   `B1: journal overwrite guard - claimed Fixed in promotion.py retry path`.
3. Weight is a non-issue (finding 5).
4. Because enforcement of the literal iteration format is already arbitrary
   (finding 2), the claims block should be specified by content ("one line per
   prior blocking/non-blocking/blocking-test-docs item with claimed
   resolution"), not by exact header wording - or it will decay the same way.

## Suggestions for updates

### S1. Candidate 2 spec: content-defined claims block (edit `improvement-candidates.md`)

Adopt the design inputs above into candidate 2's proposed change: define the
claims block by required content and per-item one-line format, not by a
mandatory literal header; note the measured +300-600 char cost against the
3.4k-char median payload.

*Status: folded into candidate 2 (accepted 2026-10-08); the claims block will
be content-defined per the design inputs above.*

### S2. Candidate 3 extension: accept variant loop-state phrasing (edit `improvement-candidates.md`)

The iteration demotion should cover not just absence but the literal-format
requirement: parents' variant loop-state lines carry the information, and
reviewers already accept them in APPROVED launches. Recommend the contract
accept "iteration identifiable in the payload (any clear phrasing)" as
satisfying the input, with the payload-defect note reserved for truly absent
cases.

*Status: folded into candidate 3 (accepted 2026-10-08): variant loop-state
phrasing satisfies the input; truly absent cases get the payload-defect note.*

### S3. Fix the rejection phrase (edit contract output guidance)

`CHANGES REQUESTED: missing invocation envelope` should be reserved for
identity-block misses; content misses (task summary, gate, CI) should lead
with `CHANGES REQUESTED: incomplete review payload - missing: <elements>`.
All 5 observed rejections were content misses; the current phrase sent this
survey down a wrong path initially.

### S4. One contract sentence on scope boundaries (edit contract "When invoked")

Add: parent-declared out-of-scope boundaries for named features are task
context, not pass conditions; the reviewer still audits everything within the
declared scope. This codifies the benign pattern observed 4 times and keeps
the illegal-override guard unambiguous.

### S5. Evidence frame: dormant feature - REMOVAL ACCEPTED (owner)

0/113 uses. Either remove the evidence-frame paragraph from the Codex-facing
guidance or advertise when to use it; silent dormancy is dead contract weight.
Owner call.

**OWNER NOTE**

"Removal is accepted"

**Status: accepted (owner note 2026-10-08); pending implementation.** Scope
resolved by owner (2026-10-08): removal is canonical and repo-wide - contract
item 8, `workflow/code-review-frame.md`, skill mentions, and all host mirrors.
Nothing is applied to Codex alone; cursorEscape is the skills-and-agents
source of truth and every stack inherits via sync.

### S6. CI label: make it optional in contract text (edit contract CI gate input description)

Parents meet the per-command-rows bar 92.9% of the time but use the
`ci mode:` label 48.7% of the time. Recommend the contract accept any format
that lists each required check with an observed result, treating the label as
optional. This removes a label-only failure mode without weakening CI Observed.

### S7. Note the early-era enforcement gap in metrics only

The single no-identity-lines APPROVED (2026-09-11) predates the canonical
envelope rollout maturity; no action needed beyond noting the 0.9% figure as
the identity-block enforcement error rate.

## Limitations

- "Per-command CI rows" is a line-shape heuristic; it cannot verify that each
  listed check was actually required for the repo.
- Variant-iteration re-check covered the 12 APPROVED cases manually; the 21 CR
  and other missing-iteration cases were not exhaustively re-checked, so the
  corpus-wide "truly absent" rate is bounded, not exact.
- Envelope extraction takes the message(s) beginning with the canonical role
  line; a payload that put task content in a separate message would be
  under-measured (none observed in sampling).
