# General review of the production reviewer - findings and assessment

Date: 2026-10-08. Scope: general performance review of the
`production_readiness_reviewer` agent (Reviewer A) in Codex review loops.
Excludes evaluation of the supersession/short-form update (`650066a`) per
owner direction.

## Method and corpus

- Sessions mined from `C:\Users\admin\.codex\sessions` (2026-09-11 through
  2026-10-08). Launches identified by the child session's developer identity
  (`production_readiness_reviewer`), not by envelope text: file-level envelope
  matching over-counts 257 because Codex's built-in command-approval reviewer
  sessions embed the parent transcript, envelope included.
- **Corpus: 113 true launches** across 3 root threads and 2 consumer repos
  (curriculumConversion 80, easyPeasyWebsite 33). cursorEscape's own changes
  were mostly owner-skipped from dual review, so the repo-agnostic claim is
  under-exercised.
- Classification was corrected after manual inspection of all non-verdict
  records (`../scripts/fix-classification.ps1`): three launches that produced
  full outputs with deviant verdict formatting are classed `FORMAT_DEVIANT`,
  five missing-envelope rejections are classed `ENVELOPE_REJECTED`, and the
  five remaining empty-output launches were owner-initiated aborts for external
  reasons (owner statement, 2026-10-08) and are excluded from process-waste
  findings.

## Headline numbers (corrected)

| Class | Count | % of 113 | Reading |
|---|---|---|---|
| CHANGES REQUESTED | 61 | 54.0% | structured verdict, blocking items |
| APPROVED | 39 | 34.5% | structured verdict, no must-fix items |
| ENVELOPE_REJECTED | 5 | 4.4% | contract-compliant rejection of malformed parent payload |
| NO_OUTPUT (owner-aborted) | 5 | 4.4% | external aborts, excluded from process findings |
| FORMAT_DEVIANT | 3 | 2.7% | usable verdict, wrong formatting (2 APPROVED, 1 CR) |

Usable verdicts: 103. Exact `## Verdict` heading format: 100/103 (97.1%).
All required sections present: at least 102/113 (90.3%); the bold-verdict
deviant also carried full sections, so effectively 103/113 (91.2%).

## What works well

### 1. Finding quality and actionability are high

Of 62 findings-bearing CR-family launches, 58 (93.5%) cite file:line-style
evidence in the blocking or blocking test/docs sections; the remainder are
process findings that cite plan lines instead. Sampled outputs consistently
carry the contract's three-part discipline: precise location, concrete failure
scenario, required correction.

Concrete catches worth naming (all verified against the session output):

- **Real data-loss bug found on iteration 4:** promotion retry can overwrite an
  unresolved recovery journal and erase the backup, then record
  `replacement_occurred: false` with the wrong prior hash
  (`../samples/2026-10-08-024856-cr-iter4-cap.md`). This survived fake-based
  tests; the reviewer found it by reading the retry path.
- **Acceptance masking:** the default WSOLA slowdown path produced 59.5-85.2%
  duration errors that both the automated fake-based test and the live proof
  failed to catch, because validation only checked that a file was created
  (`../samples/2026-10-06-165226-cr.md`).
- **Silence-retention bug with proof-index cross-check:** extraction retained
  leading silence against plan lines, caught by comparing retained ranges to
  the proof index (same sample).
- **Manifest fail-closed gap:** `input_snapshot["task_ordinal"]` accepted
  malformed values while sibling ordinals were strictly validated
  (`../samples/2026-10-06-225916-cr.md`).
- **Current-facing doc drift:** stale tracked roadmap still teaching "Phase 5
  not implemented" after implementation, correctly routed to blocking with the
  note that the orchestrator (not the read-only reviewer) must fix it (same
  sample).

### 2. Output and section discipline

Structured outputs follow the required schema: 90%+ carry all nine sections;
regression matrices are per-behavior with test citations rather than ritual
(example: `../samples/2026-10-06-225916-cr.md`); CI gate status echoes
per-command results with counts (same sample: `pytest ... 151 passed`,
`545/545 SHA-256 values match`). Profile: `../data/quantitative-profile.md`.

### 3. Leg split with bug_reviewer holds

105/113 launches had a bug sibling within 3 minutes. The inspected pair shows
clean division: prod leg flagged stale roadmap + manifest validation; bug leg
returned exactly one doc-reference bug (README import example) with rubric
categories and coverage markers; zero overlap
(`../samples/2026-10-08-035607-bug-paired.md`). 8/113 launches lacked a
detectable sibling - minor.

### 4. APPROVED calibration looks sound and loop memory works

39 APPROVED vs 61 CR is conservative but not paralyzed. The inspected APPROVED
shows a clean evidence-based regression matrix and batchable items carried
forward as "Deferred prior item" across reviews
(`../samples/2026-09-11-143410-approved-6batchable.md`) - the loop remembers
through the parent payload without violating clean-context isolation.

### 5. Gate enforcement fires when fed bad input

- 5 launches correctly returned `CHANGES REQUESTED: missing invocation envelope`
  (2026-10-06/07) when the parent omitted the envelope.
- CI claimed-only/skip policing appears in 12.7% of CR launches
  (`../data/finding-categories.md`).
- The plan's 1,000-line non-waivable size gate was enforced in 11.1% of CR
  launches, including catching untracked files in the line count.

## What does not work

### 1. Parent payload quality is the biggest operating cost

- **Review iteration missing in 37/113 (32.7%)** launches; at least one
  anomaly with two consecutive launches both numbered iteration 2 (2026-10-06
  22:45 and 22:59, `../data/quantitative-profile.md`).
- **Missing iteration consumed a blocking finding slot in 8 launches**
  (12.7% of CR launches). The iteration number is parent-owned loop
  bookkeeping; the audit itself does not use it. Each such finding forces a
  full paid re-launch to fix a one-line payload defect.
- Completion gate explicitly `review-loop` in only 72.6% of payloads. The
  literal `ci mode` label appears in 49.6% of envelopes, but per-command CI
  rows are echoed in 90%+ of outputs, so parents usually supply results in
  varying formats - the label requirement is satisfied in spirit, not letter.

### 2. No fix-verification mechanism; re-runs rediscover scope

The contract mandates a full audit on every re-run, forbids prior transcripts
as input, and the parent supplies no prior-findings list either. Consequences
observed in traces:

- Each iteration surfaces *new* issue classes rather than closing prior ones:
  the 2026-10-08 block went iter 1 (size gate, path containment) -> iter 4
  (journal overwrite safety) with no record connecting them.
- The reviewer already relies on parent claims to skip work: "no code review
  performed (code unchanged since iteration 1, per parent report)"
  (`C:\Users\admin\.codex\sessions\2026\10\03\rollout-2026-10-03T03-38-24-01a0fe56-ed74-70d2-8029-f567296f6688.jsonl`)
  - that trust is currently unauditable.
- Long CR streaks: 5 consecutive CRs in thread `01a0fd1a` (2026-10-06
  16:52-19:15), and a block ending CR at iteration 4 (2026-10-08 01:16-02:48)
  followed by APPROVED on an un-numbered relaunch. Cap decisions rest on
  unverifiable fresh audits.

This is thoroughness with no convergence signal - the loop cannot distinguish
"same findings reopened" from "new surface being found".

### 3. The non-blocking lane is de facto unused

92.9% of launches report zero non-blocking findings (mean 0.07, max 1 across
113 launches). Because non-blocking items block approval while batchable items
do not, reviewers route polish to Batchable. The lane exists in the contract
but does no work in practice; its boundary with Batchable is unmotivated in the
data.

### 4. Lost launches (process-attributable)

- 5 envelope rejections: correct behavior, but each is a full launch spent to
  discover a missing payload element the parent checklist should have caught.
- 3 format deviants: verdict on the same line as the heading, or bold without
  a heading. Minor (2.7%), all still parseable by a human; noted for
  completeness, not worth machinery.
- The 5 owner-aborted launches are excluded per owner statement.

## Blocking-finding category mix (multi-label, % of 63 scanned CR-family launches)

| Category | % | Note |
|---|---|---|
| identity/hash | 38.1% | largest voice; adapts to the audio pipeline's hash-chain invariants |
| stale-doc/roadmap | 33.3% | doc drift is the second-largest recurring catch |
| test-gap | 22.2% | usually "this change needs regression X" |
| payload/iteration | 12.7% | self-inflicted parent cost |
| ci-gate | 12.7% | claimed-only/skip policing |
| size/line-gate | 11.1% | plan gate enforcement |
| safety/data-loss | 11.1% | path containment, backup/journal safety |
| supersession/lifecycle | 7.9% | low blocking yield; independently corroborates the prior verbosity study; out of scope here |

Full tables: `../data/finding-categories.md`, per-launch hits in
`../category-scan/`.

## Limitations

- **False-negative rate is unmeasured.** Transcripts do not record defects
  found after APPROVED; validating "does APPROVED mean anything" needs
  post-approval tracing (see `deeper-data-assessment.md`).
- Two consumer repos only; loop-shape and category conclusions may be
  repo-flavored (the identity/hash dominance reflects the audio pipeline).
- Pairing metric uses time proximity; a small number of false bug records may
  inflate the 105/113 figure slightly.
- The 39.8% "blocking has file:line" figure in the profile counts all launches
  including those with no findings; the meaningful rate is 93.5% among
  findings-bearing launches (computed 2026-10-08).

## Evidence index

| Claim | Artifact |
|---|---|
| Corpus, verdict, section, payload stats | `../data/quantitative-profile.md` |
| Launch index (raw) | `../data/launches.jsonl`, `../data/bug-launches.jsonl` |
| Category mix | `../data/finding-categories.md`, `../category-scan/*.json` |
| Iter-4 journal-overwrite catch | `../samples/2026-10-08-024856-cr-iter4-cap.md` |
| Block start (iter 1) | `../samples/2026-10-08-011631-cr-iter1-blockstart.md` |
| WSOLA + extraction catches | `../samples/2026-10-06-165226-cr.md` |
| Iteration-missing blocking + size gate | `../samples/2026-10-06-205903-cr.md` |
| Stale roadmap + manifest gap + full sections | `../samples/2026-10-06-225916-cr.md` |
| APPROVED calibration + batchable carry | `../samples/2026-09-11-143410-approved-6batchable.md` |
| Leg-split pair (prod) / (bug) | `../samples/2026-10-08-035547-cr-post-apply.md` / `../samples/2026-10-08-035607-bug-paired.md` |
| Parent-claim reliance ("code unchanged since iteration 1") | `C:\Users\admin\.codex\sessions\2026\10\03\rollout-2026-10-03T03-38-24-01a0fe56-ed74-70d2-8029-f567296f6688.jsonl` |
| Extraction/mining scripts | `../scripts/` |
