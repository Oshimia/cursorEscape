# Improvement suggestions - production reviewer (general review)

Date: 2026-10-08. Companion to `findings.md`. Ranked by expected impact vs
effort. Groups: **P** = parent-side (canonical workflow docs shared across stacks), **C** = contract
(`agents/production_readiness_reviewer.md` + mirrors), **A** = Codex adapter
(`overlays/codex/agents/production_readiness_reviewer.toml`).
None implemented; owner decisions recorded 2026-10-08 via OWNER NOTEs and
marked inline below.

**Owner principle (applies to every candidate):** the iterative review loop is
quality control; its cost is an accepted price. Suggestions may reduce
iterations or wall-clock only in ways that cannot reduce review quality in
any respect.

---

## 1. (P, highest ROI - REWORK REQUIRED) Pre-spawn payload gate in the launch instructions

**Status: rework required (owner note 2026-10-08).** A Codex-only footer edit
is not acceptable - the gate must apply across every stack cursorEscape
manages.

**Problem.** 5 launches were spent discovering a missing envelope, and missing
iteration numbers caused 8 blocking findings that each forced a full paid
re-launch (32.7% of launches omit iteration entirely). All of this is
parent-side bookkeeping failure, policed at review cost.

**Proposed change (reworked for stack-agnostic scope).** Put the pre-spawn
check in the canonical, host-neutral procedure sources that every stack
mirrors: `workflow/agent-invocation.md` (the launch boundary itself) and the
launch step of `skills/implementation-review/SKILL.md`. The check: before
spawning either reviewer, the parent verifies the payload contains (a) the
canonical envelope, (b) iteration identifiable in the payload (literal phrase
per current contract; see candidate 3 for variant phrasings), and (c) observed
per-command CI rows. If the parent cannot supply all three, it must not
launch; it fixes its own payload first. Host footers and adapters (including
the Codex footer) only point at the canonical procedure, so every stack
inherits the gate without a per-host rule.

**Why it works.** The failure is mechanical and checkable at spawn time by the
same agent composing the payload. It moves the check from "reviewer rejects,
relaunch" to "never launch broken".

**Trade-offs.** Slightly longer canonical docs; relies on parent self-discipline like
the rest of the loop rules (which demonstrably mostly work - 82/113 payloads
did carry the completion gate).

**Effort.** Small (one footer edit + canonical doc note). Mirrors in overlays
regenerate via host sync.

**Success metric.** `ENVELOPE_REJECTED` rate ~0; truly-absent iteration rate
(strict phrase plus variants) from ~25-33% toward <5%; the "payload/iteration"
blocking category (12.7% of CRs) disappears. Savings are launch cycles and
latency; token savings are negligible (envelope rejections were 0.2% of
spend).

**OWNER NOTE**

"This may need a slightly different mechanism. We want this to be applicable across all stacks that are used. So a Codex only footer update is *not* ideal"

---

## 2. (C - ACCEPTED) Fix-verification section and prior-findings claims input for re-runs

**Status: accepted (owner note 2026-10-08); pending implementation.** Design
inputs from `envelope-content-assessment.md` apply at implementation time:
define the prior-findings claims block by required content with one line per
prior item (no mandatory literal header); measured payload cost is +300-600
chars against a 3.4k-char median envelope. Cost context: multi-CR blocks cost
11-17M tokens; per the owner principle, savings are incidental - the
guaranteed gains are attribution and auditable cap decisions.

**Problem.** Re-runs are full audits with no memory: each iteration surfaced
new issue classes (traced block went iter 1 size-gate/path-containment -> iter 4
journal-overwrite), long CR streaks occurred (5 consecutive; blocks ending CR at
iteration 4), and the reviewer already relies on parent claims anyway - one
output explicitly says "no code review performed (code unchanged since
iteration 1, per parent report)". Today that trust is unauditable; cap
decisions at iteration 4 rest on unverifiable fresh audits.

**Proposed change.** Three coordinated edits:

1. Contract input: for iterations >= 2, the parent must supply a compact
   **prior-findings claims list** - for each prior blocking/non-blocking/
   blocking-test-docs item: the claim in one line and the parent's asserted
   resolution. Claims, not transcripts - this preserves the clean-context rule
   (the child still reads no prior review outputs).
2. Contract output: a new required section `Fix verification` listing each
   prior item as **Resolved / Reopened / Not-addressed**, with evidence for the
   judgment. Reopened items must also appear in Blocking findings.
3. Full-audit rule unchanged: the reviewer still audits the whole changeset
   fresh; fix verification is additive, not a delta-review replacement.

**Why it works.** It converts implicit trust ("parent says unchanged") into an
explicit, evidence-checked claim, and gives the loop a convergence signal:
cap-exhaustion at iteration 4 with all items Resolved-but-new-found reads very
differently from the same findings reopened four times. It also makes the
existing "Deferred prior item" carry-forward (which already works, see
`../samples/2026-09-11-143410-approved-6batchable.md`) symmetric: the loop
remembers both polish and blockers.

**Trade-offs.** Slightly heavier payload on re-runs; risk of parents writing
glib "resolved" claims - mitigated because the reviewer must verify with
evidence, and a false claim becomes a finding. Slight tension with the
existing rule that parent text must not set pass conditions: scope the claims
list as *factual assertions to verify*, never as pass conditions (state this
explicitly in the contract so the override-guard keeps working).

**Effort.** Medium: contract input/output sections, footer step update, adapter
mirror. No harness change.

**Success metric.** Reopened-vs-new ratio measurable per block; CR streak
length becomes attributable; iteration-4 handoffs carry a defensible
verification record.

**OWNER NOTE**

"This is a good suggestion, we'll do this."

---

## 3. (C - ACCEPTED) Demote missing iteration/counts from blocking to advisory

**Status: accepted (owner note 2026-10-08); pending implementation.**

**Problem.** Missing `Review iteration` currently forces `CHANGES REQUESTED`
and consumed a blocking slot in 8 launches, yet the number is bookkeeping the
reviewer's audit never uses (the parent owns pressure-release caps).

**Proposed change (updated 2026-10-08).** Contract edit: missing iteration is
recorded as a dedicated **`Payload defects` line** (the Non-blocking findings
lane is being removed; see candidate 4) and the review proceeds with
`iteration: unspecified`. A variant loop-state phrasing that clearly
identifies the iteration ("Loop metadata: current review iteration 3 of 4")
satisfies the input; the defect note is reserved for truly absent cases. Keep
the envelope itself mandatory - identity and isolation depend on it. Candidate
1 makes this a rare event anyway; this is the belt-and-braces pair.

**Why it works.** Removes the only self-inflicted, zero-information blocking
category without weakening any real gate (CI, envelope, override guards stay
blocking).

**Trade-offs.** If candidate 2 lands, the iteration number becomes slightly
more useful (fix-verification expects it) - but a payload defect note still
gives the parent what it needs without a wasted launch. Small ambiguity: cap
bookkeeping for the un-numbered launch falls entirely to the parent; acceptable
since it already does today whenever the number is wrong (observed: two
consecutive iteration-2 launches).

**Effort.** Small (contract verdict-bar edit + adapter mirror).

**Success metric.** Category "payload/iteration" at 0 blocking findings;
re-launch-per-payload-defect rate ~0.

**OWNER NOTE**

"This is a good suggestion we'll do this"

---

## 4. (C - ACCEPTED WITH EXTENSION) Remove the non-blocking lane; lexicon overhaul

**Status: accepted with extension (owner note 2026-10-08).** The non-blocking
lane is removed entirely, and the owner raised a full lexicon overhaul to
remove "blocking/non-blocking" wording from the reviewer's vocabulary.

**Problem.** Non-blocking is de facto unused: 92.9% of launches report zero.
Incentives explain it - non-blocking items block approval, batchable does not -
so reviewers route polish to Batchable. The lane's boundary with Batchable is
undefined in practice.

**Proposed change (per owner decision).**

1. Remove the Non-blocking findings lane from the contract output schema.
   Must-fix substance is unchanged: what previously counted as non-blocking
   code/process was approval-blocking, so it joins the must-fix set;
   polish/coverage wish-lists remain in Batchable (deferred).
2. Lexicon overhaul (owner-confirmed scheme, 2026-10-08):
   replace blocking/non-blocking terminology across the reviewer's surface -
   proposed working terms **Must-fix findings**, **Must-fix test & docs**, and
   **Batchable (deferred)**, with verdict wording such as "APPROVED - no
   must-fix items open".
3. Ripple scope for one coordinated pass: the contract (output format, verdict
   bar, "What you do not do"), the Codex adapter toml schema line, the other
   host agent mirrors, the AGENTS/footer APPROVED criteria wording, and the
   implementation-review skill's fix-policy table and closeout criteria.
   `bug_reviewer` is unaffected (severity-based output).

**Effort.** Small (contract wording).

**Success metric.** Non-blocking lane gone; must-fix substance unchanged; one
lexicon used consistently across contract, adapter, footers, and skill.

**OWNER NOTE**

"Accepted, we can remove non blocking entirely, and possibly update the language entirely to remove blocking/non-blocking from the lexicon"

---

## 5. (A, standing) Keep the adapter in sync; no structural change

The Codex adapter toml mirrors the contract correctly (identity, read-only
authority, verdict schema, no-CI rule) and the read-only sandbox is consistent
with "record parent-reported results only". Only action: mirror whichever
contract changes above are adopted, via the existing host-sync flow.

Format hardening (require the verdict on its own line after the heading) is
optional and one line in the output-format block: 3/103 (2.7%) deviants, all
human-parseable. Fine to add while editing anyway; not worth its own change.

---

## 6. (P, optional) Keep a periodic launch-index health check

The scripts in `../scripts/` rebuild the launch index, profile, and category
mix from session files in minutes. Re-running monthly (or after contract
changes) tracks: wasted-launch rate, iteration discipline, category drift,
CR-streak length. This survey now lives under `research/production-reviewer-review/`
for long-term retention (owner decision 2026-10-08); promoting a metrics
runner into the repo (e.g., `scripts/review-metrics/`) remains an owner call.

---

## Considered and declined

- **Delta-only reviews on re-runs** (audit only claimed fixes): weakens escape
  detection, which the traces show is the reviewer's main value (new issue
  classes found every iteration). Candidate 2 gets convergence without this.
- **Verbosity limits on closure sections:** already addressed by the shipped
  short-form rule; out of scope per owner direction.
- **Mechanical verdict-format validation in the harness:** 2.7% incidence,
  human-parseable; a one-line contract clarification (candidate 5) is enough.
- **Making bug-sibling pairing mandatory in the adapter:** 105/113 already
  pair; the 8 misses correlate with the aborted/external launches, not a
  systemic gap.
- **Cost lines in the closeout report:** declined (owner note 2026-10-08,
  cost-latency assessment S3).
- **Cost-triggered pressure release (spend thresholds gating full audits):**
  declined (owner note 2026-10-08, cost-latency assessment S4). The review
  loop is quality control; its cost is an accepted price. Iteration and
  wall-clock reduction comes only via better convergence and verification
  (candidate 2), never shallower review.
