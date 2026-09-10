---
name: implementation-review
description: >-
  Run the iterative Reviewer A + Bugbot review loop after non-trivial
  implementation — once per plan phase on multi-phase plans, or once at
  completion for single-phase work. Covers CI gate (parent-only, once per
  iteration), parallel reviewer launch, fix-all policy, and completion bar.
  Use proactively when closing a phase or any non-trivial task.
disable-model-invocation: true
---

# Implementation review

Use when completing a **plan phase** or non-trivial implementation work in Agent mode. Orchestrate **reviewer-a** and **Bugbot** for production-readiness and security/correctness review.

This skill is **repo-agnostic**. Do not assume a fixed script tree.

**Read when reviewing:**

| Doc | When |
|-----|------|
| [discovery.md](../../workflow/discovery.md) | Find repo docs before judging architecture |
| [iterative-code-review.md](../../workflow/iterative-code-review.md) | Loop rules, per-phase boundaries, Composer carve-out |
| [ci-ladder.md](../../workflow/ci-ladder.md) | Fast/Full CI mapping |
| [code-review-frame.md](../../workflow/code-review-frame.md) | Optional Standards/Spec evidence frame |
| [review-subagent-models.md](../../overlays/cursor/review-subagent-models.md) | Recommended reviewer models |
| [_index.md](../../workflow/_index.md) | Index of all workflow docs |

Absolute fallback: `C:/Users/admin/.cursor/` workflow mirror (copy-out only).

## Composer workflow

When the user assigns [`composer`](../composer/SKILL.md) for phased execution:

- The **phase subagent** is the implementing agent and **review-loop parent** for Nb
- The Composer does not implement Nb, run reviewers for phase work, or fix product findings
- After dual `APPROVED` + Full CI, Composer QC's the closeout report **and audits transcripts** (Nb, nested reviewers, and Composer's own Na/migration work for the phase), then runs **Full CI** again and an **automatic local commit** (never `git push`)
- If Full = `n/a`, dual APPROVED + explicit user ack before commit
- **Pressure release:** after a 4-iteration block without dual APPROVED, the phase subagent does **not** self-renew and does **not** run Full CI — return a **cap-exhausted handoff** per [`composer`](../composer/SKILL.md). Schemas and triage live there. **Waive = Composer-only.**

---

## When to run

**When in doubt, run it.**

| Situation | When |
|-----------|------|
| **Multi-phase plan** | End of **each** phase in **Incremental execution** — dual `APPROVED` before starting the next phase |
| **Single-phase or ad-hoc** | Once before declaring the task complete |

### Mandatory triggers

| Trigger | Examples |
|---------|----------|
| Multi-file work | 2+ source files (code, tests, migrations) |
| Large single-file change | Substantial refactor of a route, service, module, or shared hook |
| Cross-layer change | Frontend + backend, API + UI, DB + app |
| Behavioral change | Endpoints, auth/RBAC, state, permissions |
| New modules | Helpers imported from multiple places |
| Database / migration | Schema or data migrations |
| Each plan phase | Every Incremental execution phase |

### May be skipped

- Typo or copy fix in one place
- Comment-only or pure formatting
- Cosmetic-only UI (no behavior, data, or permissions)
- Documentation-only with no code/behavior change
- User explicitly instructs skip

If the change touches tests, APIs, auth, migrations, shared utilities, or logic/state/fetch/handlers — **do not skip**.

Do **not** implement multiple plan phases and run one review at the end.

---

## Workflow

```text
Implement phase
  → for each ≤4-iteration block:
      [Fast CI Observed → Reviewer A + Bugbot → fix must-fix] (max 4)
      → dual APPROVED? → Full CI → complete
      → else pressure-release reassessment (normal) or cap-exhausted handoff (Composer Nb)
```

1. **Implement** the current phase (or full scope if single-phase) using discovery + this repo’s documented conventions.
2. **Review loop (within a 4-iteration block):** Run **Fast CI Observed** once, then launch **Reviewer A + Bugbot in parallel** with `Completion gate: review-loop` only. Cursor Task spawn: [implementation-review overlay](../../overlays/cursor/skills/implementation-review/SKILL.md). **Do not launch reviewers if Fast CI fails, is skipped (when Fast is not `n/a`), or is claimed-only** (prose “Fast CI passed” / `ci: pass` with no per-command rows).

   Optional evidence frame: when a fixed point and an originating spec both exist, the parent may add `Fixed point:` and `Spec path:` lines to the reviewer invoke payload to enable Standards/Spec axis framing with per-finding citations per [code-review-frame.md](../../workflow/code-review-frame.md). Absent those inputs, reviews are unchanged.

3. If **either** reviewer returns `CHANGES REQUESTED`, or Bugbot/`bug_reviewer` does not return CLEAN/no findings, or Reviewer-a has Blocking / Non-blocking (code/process) / **blocking** test/docs ≠ `"None"`: fix **every must-fix** finding → return to step 2 (increment review iteration within the block). Do **not** treat Reviewer-a **Batchable (deferred)** as loop-blocking. **Do not launch a 5th pair** in the current block.
4. **Exit the block:**
   - If **both** return `APPROVED` → go to step 5 (closeout). Do **not** launch reviewers again unless you subsequently changed code.
   - If iteration **4** ends without dual APPROVED → **stop** here; follow [Pressure release](#pressure-release-4-iteration-blocks) (normal reassessment or Composer cap-exhausted handoff). Do **not** run Full CI, do **not** report `task-phase-complete`, do **not** continue to steps 5–7.
5. **Closeout (no reviewers) after dual APPROVED only:** Run the [deferred-item disposition pass](#deferred-item-disposition-batchables) first, then run **Full** CI (the repo's commit-grade suite) so any fixed-now edits are validated. If Full fails, fix and re-run Full only — **do not** re-run reviewers unless code changes invalidate the prior approval.
6. Confirm complete changeset and doc updates for **this phase**. Report closeout with dual-APPROVED iteration, **pressure-release block number**, **cumulative** per-leg launch counts this phase, Full CI pass, any **Batchable (deferred)** punch list copied from Reviewer-a, and the caveat that dual APPROVED is the loop bar — not proven ship-class catch or proven no-escape.
7. **Stop.** Proceed to next phase, Composer QC, or declare task complete — **only** after dual APPROVED + Full (or documented `n/a` path).


**Never** pair Full CI with a reviewer launch. Open Reviewer-a **Batchable (deferred)** alone does not keep the loop open.

### Deferred item disposition (batchables)

After dual `APPROVED`, alongside Full CI prep and BEFORE the Full CI run, the parent walks the Reviewer-a `Batchable (deferred)` punch list once and rules on every item. The pass never blocks commit, never relaunches reviewers for wording/index closures (see step 4: no relaunch unless code changed), and never silently drops an item.

**Fix now when ALL hold:**

- Effort is trivial: single file, a few lines.
- Value is concrete: prevents a likely agent or operator misread, closes an inconsistency or incompleteness this same changeset introduced or touched, or completes a table/index the changeset affects.
- Zero semantics risk: wording or index completeness only.
- The surface was already touched by this phase or its immediate registration echo.

**Defer with a one-line reason when ANY hold:**

- It needs new files, scripts, tooling, or cross-phase coordination.
- Value is speculative: no identifiable future reader or operator.
- It would rewrite dated or historical records.
- It belongs to another accepted-but-unstarted phase; move the note into that phase's context instead.
- Effort rivals the phase's own review cost.

Ambiguous items become a one-line question to the owner, never a silent drop.

**Reporting:** annotate the existing closeout `Batchable (deferred):` line rather than adding a parallel list; each punch item gains a suffix, `-> fixed now` or `-> deferred: <reason>`. If closing an item would require semantic or code changes, stop and escalate to the owner instead.

### Pressure release (4-iteration blocks)

**One iteration** = Fast CI Observed → Reviewer A ∥ Bugbot → fix must-fix. **Max 4 iterations per block.** Reset review **iteration** to 1 at phase start and after each Renew / Focus-narrow block. Keep a per-leg `completed` launch count for the **whole phase** (do **not** reset at block boundaries). Before each invoke: `count = completed + 1`; put `count` in the invoke prompt; after launch set `completed = count`. Closeout / reassessment reports both `block N` and cumulative launches.

After iteration 4 without dual APPROVED:

| Parent | Action |
|--------|--------|
| **Normal (non-Composer)** | Stop editing for the loop → punch list → **written reassessment** → choose exactly one: **Renew** (≤4 same must-fix) \| **Focus-narrow** (≤4 with reduced task summary / applicable docs / Bugbot Custom Instructions = current-fix only — **no** Custom Instructions field on Reviewer-a) \| **Terminate** + escalate to user |
| **Composer phase subagent** | Do **not** self-renew; do **not** run Full CI; return **cap-exhausted handoff** per [`composer`](../composer/SKILL.md) |

**Focus-narrow** is an explicit reassessment choice for the **next** block — not a mid-block “when count ≥ 9” parallel valve.

#### Anti-abuse (normal agents) — must / must-not

Pressure release is a **stuckness / thrash brake**, not an opt-out from dual APPROVED or must-fix work.

**Default:** if any **in-spec must-fix** findings remain → **Renew** or **Focus-narrow**. Dual APPROVED remains the success path unless the user ends the task.

**Terminate allowed only when** stated in the reassessment: (1) blocked on a product/scope decision the agent cannot resolve; (2) contradictory requirements need user arbitration; (3) only true out-of-scope leftovers remain (escalate — do not silently drop); (4) no meaningful progress across the last full Focus-narrow block (same must-fix recurring with no new evidence).

**Terminate forbidden when:** actionable in-spec must-fix remain; convenience / “ship anyway”; Fast CI fail/skip/claimed-only; skipping required fixes/tests/docs; implying dual APPROVED, phase complete, or task complete without the bar.

**Focus-narrow is not a drop-list** — do not reclassify in-spec must-fix as Batchable/out-of-spec to clear the bar. **Renew is not idle spinning** — each block must attempt concrete fixes or Terminate+escalate with the blocker.

**Required reassessment record** (before choosing): block number; cumulative per-leg launches; in-spec vs out-of-spec lists; choice; rationale; attestation `not using pressure release to skip in-spec must-fix work: yes`.

**Normal agents never Waive.** Waive (process/out-of-spec with attestation) is **Composer-only**.

**Autonomy:** Run the loop without asking the user to approve each review round. Fix findings autonomously unless blocked on a product decision — then ask once, document the decision, and continue.

**Completion bar (split):** Fast CI Observed + dual `APPROVED` **then** Full CI pass. On multi-phase plans, **every** phase must reach this bar.

| Reviewer | Loop-blocking result | May remain open |
|----------|---------------------|-----------------|
| **Bugbot / `bug_reviewer`** | CLEAN/no findings; any finding fails this leg | — |
| **Reviewer-a** | Blocking, Non-blocking (code/process), and **blocking** test/docs are `"None"` | **Batchable (deferred)** |

**Example (Reviewer-a):** A missing unit test for a new auth branch is **blocking test/docs**. A wish-list for broader e2e coverage of an untouched flow is **Batchable (deferred)** and may remain on `APPROVED`.

---

## Completion gate selection & stop rules

Reviewers are **only** invoked with `Completion gate: review-loop` and **Fast** CI. **`task-phase-complete` is not a reviewer gate** — it labels the phase closeout report after dual `APPROVED` + Full CI.

| Situation | CI tier | Reviewers? | Completion gate (reviewers) | Next step |
|-----------|---------|------------|----------------------------|-----------|
| Mid-loop / still fixing (iterations 1–3 of block, or 4 with dual APPROVED pending after this launch) | **Fast** | Yes — Reviewer A + Bugbot | `review-loop` | Fix must-fix findings → new review iteration **within the block** (max 4) |
| Dual `APPROVED` (split bars; Reviewer-a batchable may remain) | — | **No** | — | Run **Full** CI only (closeout) |
| Full CI pass after dual `APPROVED` | **Full** | **No** | — | Report `task-phase-complete`; stop |
| Iteration 4 without dual `APPROVED` | — | **No** further launches | — | Pressure release: normal reassessment or Composer cap-exhausted handoff — **no Full**, **no** `task-phase-complete` |

**Closeout prohibitions (no duplicate loops):**

1. **Never** launch Reviewer A or Bugbot with Full CI — reviewers always follow Fast CI only.
2. **Never** launch reviewers again after dual `APPROVED` (split bars) unless you subsequently changed code. Open Reviewer-a **Batchable (deferred)** alone does **not** invalidate approval.
3. **Closeout = Full CI only** after dual `APPROVED`. After a **4-iteration pressure-release block** without dual APPROVED, Composer Nb returns a cap-exhausted handoff instead — **no Full**.
4. If Full CI fails after dual `APPROVED`, fix and re-run **Full** only. Re-run reviewers only if fixes invalidate the prior approval.

---

## Subagent models

Track the review **iteration within the current pressure-release block** (1–4). Reset to iteration 1 at the start of each phase and after each Renew / Focus-narrow. Recommended default: `composer-2.5` on both subagents every iteration.

| Review iteration (within block) | Reviewer A model | Bugbot model |
|---------------------------------|------------------|--------------|
| 1, 2, 3, 4 | `composer-2.5` | `composer-2.5` |

Use a different model only when the user explicitly requests it.

---

## CI gate

Run from repo root. Full mapping: [ci-ladder.md](../../workflow/ci-ladder.md).

If a project `pre-commit-ci-gate` (or equivalent) rule exists, follow it for Full/commit.

### CI tiers (conceptual)

| Tier | Meaning | When | Reviewers? | Sufficient for commit? |
|------|---------|------|------------|------------------------|
| **Fast** | Quickest meaningful lint/test for touched areas | **Every review-loop iteration** — before Reviewer A + Bugbot | **Yes** (after Fast passes) | **No** |
| **Full** | Commit-grade suite | **Closeout after dual APPROVED**; before any `git commit` | **No** | **Yes** |

If Full is `n/a` (no automated suite), still require dual APPROVED; commit only after explicit user acknowledgment.

**Do not launch Reviewer A or Bugbot until Fast CI passes** (when Fast is not `n/a`).

**Observed Fast CI (required):** The CI block must list **commands actually run** with `pass|fail|skipped|n/a` per command. Do **not** launch if any Fast check is `skipped` when Fast is not `n/a`. Do **not** launch on **claimed-only** evidence: prose “Fast CI passed” or `ci: pass` with **no** per-command rows. `n/a` (no suite) is unchanged — still run dual review.

**On Full CI failure:** never commit; never substitute Fast or partial checks. Fix and re-run Full until it passes.

**Composer phase commit:** Composer runs Full again before each automatic local phase commit — the subagent’s earlier Full does not replace it.

---

## Closeout report (parent)

After dual `APPROVED` + Full CI, report at least:

- Dual-APPROVED review iteration (within final block)
- Pressure-release **block** number
- `Reviewer-a launches this phase: <N>` (cumulative)
- `Bugbot launches this phase: <N>` (cumulative)
- Full CI result
- **Batchable (deferred):** copy from Reviewer-a final output, or `"None"`
- **Caveat:** dual APPROVED is the loop completion bar — not proven ship-class catch or proven no-escape. Do not run a post-clean audit unless the user asks.

Cap-exhausted handoff (Composer Nb, no dual APPROVED): do **not** use this closeout schema — use the handoff schema in [`composer`](../composer/SKILL.md).

---

## Fix policy

| Finding type | Action |
|--------------|--------|
| Blocking (either reviewer) | Must fix before next review |
| Non-blocking code/process (either reviewer) | Must fix — cannot dual-APPROVE with these open |
| Reviewer-a **blocking** test/docs | Must fix — Reviewer-a cannot APPROVE with these open |
| Reviewer-a **Batchable (deferred)** | Do **not** re-block the loop; list in closeout punch list |

Do not close the phase or task or tell the user the work is “done” while any **must-fix** finding remains open. **Batchable (deferred)** items may remain after dual APPROVED.

---

## Complete changeset

Before requesting approval, verify for **the current phase**:

- Every new module, test file, and helper imported by the phase is included in the change set
- Docs updated in the same pass when patterns or behavior changed
- No “works on my machine” reliance on untracked files

Incomplete changesets are a common blocking finding on re-review.

---

## Related

**Skills / agents:** [`composer`](../composer/SKILL.md), [`implementation-plan`](../implementation-plan/SKILL.md), [`roadmap`](../roadmap/SKILL.md), [`production_readiness_reviewer`](../../agents/production_readiness_reviewer.md)

**Workflow docs:** [discovery.md](../../workflow/discovery.md), [iterative-code-review.md](../../workflow/iterative-code-review.md), [ci-ladder.md](../../workflow/ci-ladder.md), [review-subagent-models.md](../../overlays/cursor/review-subagent-models.md), [phased-multi-agent.md](../../workflow/phased-multi-agent.md), [_index.md](../../workflow/_index.md)
