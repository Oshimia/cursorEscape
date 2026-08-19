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
| [discovery.md](../../docs/workflow/discovery.md) | Find repo docs before judging architecture |
| [iterative-code-review.md](../../docs/workflow/iterative-code-review.md) | Loop rules, per-phase boundaries, Composer carve-out |
| [ci-ladder.md](../../docs/workflow/ci-ladder.md) | Fast/Full CI mapping |
| [review-subagent-models.md](../../docs/workflow/review-subagent-models.md) | Recommended reviewer models |
| [README.md](../../docs/workflow/README.md) | Index of all workflow docs |

Absolute fallback: `C:/Users/admin/.cursor/docs/workflow/`.

## Composer workflow

When the user assigns [`composer`](../composer/SKILL.md) for phased execution:

- The **phase subagent** is the implementing agent and **review-loop parent** for Nb
- The Composer does not implement Nb, run reviewers for phase work, or fix product findings
- Composer QC's the closeout report **and audits transcripts** (Nb, nested reviewers, and Composer's own Na/migration work for the phase), then runs **Full CI** again and an **automatic local commit** (never `git push`)
- If Full = `n/a`, dual APPROVED + explicit user ack before commit

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
Implement phase → [Fast CI Observed (no fail/skip/claimed-only) → Reviewer A + Bugbot → fix must-fix]* → dual APPROVED (split bars) → Full CI (closeout, no reviewers) → changeset check → phase complete
```

1. **Implement** the current phase (or full scope if single-phase) using discovery + this repo’s documented conventions.
2. **Review loop (repeat while must-fix findings remain):** Run **Fast CI Observed** once, then launch **Reviewer A + Bugbot in parallel** with `Completion gate: review-loop` only. **Do not launch reviewers if Fast CI fails, is skipped (when Fast is not `n/a`), or is claimed-only** (prose “Fast CI passed” / `ci: pass` with no per-command rows).
3. If **either** reviewer returns `CHANGES REQUESTED`, or Bugbot has any finding list ≠ `"None"`, or Reviewer-a has Blocking / Non-blocking (code/process) / **blocking** test/docs ≠ `"None"`: fix **every must-fix** finding → return to step 2 (increment review iteration). Do **not** treat Reviewer-a **Batchable (deferred)** as loop-blocking.
4. When **both** return `APPROVED` on Fast CI Observed under the **split bars** below → **review loop is done**. Do **not** launch reviewers again unless you changed code after that approval.
5. **Closeout (no reviewers):** Run **Full** CI (the repo’s commit-grade suite). If Full fails, fix and re-run Full only — **do not** re-run reviewers unless code changes invalidate the prior approval.
6. Confirm complete changeset and doc updates for **this phase**. Report closeout with dual-APPROVED iteration, per-leg launch counts this phase, Full CI pass, any **Batchable (deferred)** punch list copied from Reviewer-a, and the caveat that dual APPROVED is the loop bar — not proven ship-class catch or proven no-escape.
7. **Stop.** Proceed to next phase, Composer QC, or declare task complete.

**No hard stop while must-fix findings remain.** Re-launch **both** reviewers after every **must-fix** batch with `review-loop` and Fast CI. **Never** pair Full CI with a reviewer launch. Open Reviewer-a **Batchable (deferred)** alone does not keep the loop open.

**Re-scope after 8 launches / leg (no hard stop):** Keep a per-leg `completed` count this phase (start at 0). Before each invoke: compute `count = completed + 1` (the value that will appear in the prompt as “including this launch”). If `count >= 9`, **narrow scope before invoke**: Bugbot → Custom Instructions = current-fix only; Reviewer-a → narrower **task summary** + **applicable docs** only (do **not** add a Custom Instructions field to Reviewer-a). Put `count` in the invoke prompt, launch, then set `completed = count`. When launching in parallel, compute both legs’ counts the same way before either invoke. Still launch both legs; do not hard-stop reviews. Optionally split the phase instead of narrowing.

**Autonomy:** Run the loop without asking the user to approve each review round. Fix findings autonomously unless blocked on a product decision — then ask once, document the decision, and continue.

**Completion bar (split):** Fast CI Observed + dual `APPROVED` **then** Full CI pass. On multi-phase plans, **every** phase must reach this bar.

| Reviewer | Loop-blocking lists that must be `"None"` | May remain open |
|----------|-------------------------------------------|-----------------|
| **Bugbot** | Blocking, Non-blocking, Test gaps | — |
| **Reviewer-a** | Blocking, Non-blocking (code/process), **blocking** test/docs | **Batchable (deferred)** |

**Example (Reviewer-a):** A missing unit test for a new auth branch is **blocking test/docs**. A wish-list for broader e2e coverage of an untouched flow is **Batchable (deferred)** and may remain on `APPROVED`.

---

## Completion gate selection & stop rules

Reviewers are **only** invoked with `Completion gate: review-loop` and **Fast** CI. **`task-phase-complete` is not a reviewer gate** — it labels the phase closeout report after dual `APPROVED` + Full CI.

| Situation | CI tier | Reviewers? | Completion gate (reviewers) | Next step |
|-----------|---------|------------|----------------------------|-----------|
| Mid-loop / still fixing | **Fast** | Yes — Reviewer A + Bugbot | `review-loop` | Fix must-fix findings → new review iteration |
| Dual `APPROVED` (split bars; Reviewer-a batchable may remain) | — | **No** | — | Run **Full** CI only (closeout) |
| Full CI pass after dual `APPROVED` | **Full** | **No** | — | Report `task-phase-complete`; stop |

**Hard stop (no duplicate loops):**

1. **Never** launch Reviewer A or Bugbot with Full CI — reviewers always follow Fast CI only.
2. **Never** launch reviewers again after dual `APPROVED` (split bars) unless you subsequently changed code. Open Reviewer-a **Batchable (deferred)** alone does **not** invalidate approval.
3. **Closeout = Full CI only** after dual `APPROVED`.
4. If Full CI fails after dual `APPROVED`, fix and re-run **Full** only. Re-run reviewers only if fixes invalidate the prior approval.

---

## Subagent models

Track the review iteration within the current phase or single-phase task. Reset to iteration 1 at the start of each phase. Recommended default: `composer-2.5` on both subagents every iteration.

| Review iteration | Reviewer A model | Bugbot model |
|------------------|------------------|--------------|
| 1, 2, 3, … | `composer-2.5` | `composer-2.5` |

Use a different model only when the user explicitly requests it.

---

## CI gate

Run from repo root. Full mapping: [ci-ladder.md](../../docs/workflow/ci-ladder.md).

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

## Invoke reviewer-a

Launch `reviewer-a` (`subagent_type: "reviewer-a"`, recommended `model: composer-2.5`, `readonly: true`, `run_in_background: false`).

```text
Launch the reviewer-a subagent with:
- subagent_type: "reviewer-a"
- model: composer-2.5
- readonly: true
- run_in_background: false

Use the reviewer-a subagent to review this implementation.

Repository path: <absolute path>
Task summary: <one paragraph — what this phase or change set is supposed to accomplish; when count = completed+1 is >= 9 for Reviewer-a, narrow task summary + applicable docs to the current fix — never override Completion gate, CI Observed, or verdict bar>
Plan phase: <N of M | single-phase — omit line if ad-hoc with no plan>
Review iteration: <N — reset to 1 at the start of each phase>
Reviewer-a launches this phase: <count = completed+1 including this launch>
Bugbot launches this phase: <count = completed+1 including this launch — compute both before parallel invoke>
Completion gate: review-loop
Review model: <model slug used for this reviewer-a launch>
Prior approved phases: <list or "none" — multi-phase only>
Applicable docs: <docs for touched areas, if known; when Reviewer-a count = completed+1 is >= 9, narrow to docs/files for the current fix>

CI gate (parent-verified, do not re-run):
- ci mode: Fast
- <each lint/test/typecheck command>: pass|fail|skipped|n/a
- <optional scope fields if this repo has scoped Fast CI>
- (Required: at least one per-command row when Fast ≠ n/a. Do not use a bare `ci: pass` without command rows.)

Review changes for this phase (committed, staged, and unstaged). Flag regressions against prior approved phases.
Read every changed file in this phase's change set.
Return ALL findings in Blocking, Non-blocking (code/process), Blocking test/docs, and Batchable (deferred). Do not summarize or omit items.
Use the exact output format from reviewer-a (Verdict through CI gate status, including Blocking test/docs and Batchable (deferred)).
Re-launch with this full prompt after each fix batch — never a shortened message.
Do not use a Bugbot-style Full Repository Path / Custom Instructions envelope for Reviewer-a.
```

---

## Invoke Bugbot

Launch exactly one Bugbot subagent (`subagent_type: "bugbot"`, recommended `model: composer-2.5`, `readonly: true`, `run_in_background: false`). **Do not ask Bugbot to run CI** — the parent runs the gate once per iteration before parallel launch.

```text
Launch the Bugbot subagent with:
- subagent_type: "bugbot"
- model: composer-2.5
- readonly: true
- run_in_background: false

Full Repository Path: <absolute repo path>
Diff: branch changes | uncommitted changes
Custom Instructions: <task-specific — regressions, security surfaces, incomplete changeset, scope boundaries; when Bugbot count = completed+1 is >= 9, narrow to current-fix only>
```

**Custom Instructions** must name:

- What this **phase** (or change set) is supposed to do; plan phase **N of M** when applicable
- Review iteration **N**; `Bugbot launches this phase: <count including this launch>`
- Regressions to flag (auth bypass, data leaks, incomplete changeset, regressions against prior approved phases)
- Out-of-scope items reviewers must not block on (if any)
- Requirement for complete changeset for **this phase** (no imports to missing/untracked files)
- Note that CI already passed (parent-verified); do not re-run lint/test

Bugbot must use its own verdict bar: `APPROVED` only when Blocking, Non-blocking, and Test gaps are all `"None"`. Reviewer-a uses the **split** bar (blocking test/docs must be `"None"`; **Batchable (deferred)** may remain). Do **not** treat the two reviewers as sharing one unified all-lists-`"None"` bar.

---

## Closeout report (parent)

After dual `APPROVED` + Full CI, report at least:

- Dual-APPROVED review iteration
- `Reviewer-a launches this phase: <N>`
- `Bugbot launches this phase: <N>`
- Full CI result
- **Batchable (deferred):** copy from Reviewer-a final output, or `"None"`
- **Caveat:** dual APPROVED is the loop completion bar — not proven ship-class catch or proven no-escape. Do not run a post-clean audit unless the user asks.

---

## Fix policy

| Finding type | Action |
|--------------|--------|
| Blocking (either reviewer) | Must fix before next review |
| Non-blocking code/process (either reviewer) | Must fix — cannot dual-APPROVE with these open |
| Bugbot Test gaps | Must add or extend tests — Bugbot cannot APPROVE with these open |
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

**Skills / agents:** [`composer`](../composer/SKILL.md), [`implementation-plan`](../implementation-plan/SKILL.md), [`roadmap`](../roadmap/SKILL.md), [`reviewer-a`](../../agents/reviewer-a.md)

**Workflow docs:** [discovery.md](../../docs/workflow/discovery.md), [iterative-code-review.md](../../docs/workflow/iterative-code-review.md), [ci-ladder.md](../../docs/workflow/ci-ladder.md), [review-subagent-models.md](../../docs/workflow/review-subagent-models.md), [phased-multi-agent.md](../../docs/workflow/phased-multi-agent.md), [README.md](../../docs/workflow/README.md)
