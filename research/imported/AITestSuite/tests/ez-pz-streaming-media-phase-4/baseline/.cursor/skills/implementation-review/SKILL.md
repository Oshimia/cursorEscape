> **Imported research** — Source: AITestSuite `tests\ez-pz-streaming-media-phase-4\baseline\.cursor\skills\implementation-review\SKILL.md`; copied 2026-08-17 into cursorEscape. Status: Observed/eval-packaging. Do not treat as Target cursorEscape design unless a Target doc cites it.
---
name: implementation-review
description: >-
  Run the iterative Reviewer A + Bugbot review loop after non-trivial
  implementation — once per plan phase on multi-phase plans, or once at
  completion for single-phase work. Covers CI gate (parent-only, once per
  iteration), parallel reviewer launch, fix-all policy, and completion bar.
  Use when closing a phase or any non-trivial task to orchestrate reviewer-a
  and Bugbot subagents.
disable-model-invocation: true
---

# Implementation review

Use when completing a **plan phase** or non-trivial implementation work in Agent mode. Follow the [`reviewer-a`](../../agents/reviewer-a.md) and **Bugbot** subagents for production-readiness and security/correctness review.

Canonical triggers and exemptions: [iterative-code-review.md](../../../referenceFiles/SOPs/iterative-code-review.md)

---

## When to run

| Situation | When |
|-----------|------|
| **Multi-phase plan** | End of **each** phase in **Incremental execution** — dual `APPROVED` before starting the next phase |
| **Single-phase or ad-hoc** | Once before declaring the task complete |

Do **not** implement multiple plan phases and run one review at the end.

---

## Workflow

```text
Implement phase → CI gate (parent, once) → Reviewer A + Bugbot (parallel) → fix every finding → CI gate (parent, once) → re-review → … → both APPROVED → changeset check → [next phase or task complete]
```

1. **Implement** the current phase (or full scope if single-phase) using documented SOPs and architecture (see [reference-docs skill](../reference-docs/SKILL.md) and [reference-docs-check SOP](../../../referenceFiles/SOPs/reference-docs-check.md)).
2. **Run CI gate** — parent only, **once per review iteration**, immediately before launching reviewers (see [CI gate](#ci-gate)). **Do not launch reviewers if any command fails.**
3. **Launch Reviewer A and Bugbot in parallel** — full prompts each round, using the explicit models from [Subagent models](#subagent-models) (see [Invoke reviewer-a](#invoke-reviewer-a) and [Invoke Bugbot](#invoke-bugbot)). Name plan phase **N of M** when applicable and include review iteration **N**.
4. If **either** reviewer returns `CHANGES REQUESTED`: fix **every** blocking finding, **every** non-blocking finding, and **every** test gap; return to step 2.
5. Repeat until **both** return `APPROVED` with Blocking, Non-blocking, and Test gaps all literally `"None"`.
6. Confirm complete changeset and doc updates for **this phase** (no extra CI run — the gate before the approving iteration is sufficient).
7. **Multi-phase plans:** proceed to the next phase from step 1. **Single-phase:** task complete.

**No pass cap.** Re-launch **both** reviewers after every fix batch using the **full** prompts, incrementing review iteration **N** each time for re-review tracking. Do not use abbreviated “please re-check” messages.

**Autonomy:** Run the loop without asking the user to approve each review round. Fix findings autonomously unless genuinely blocked on a product decision — then ask once, document the decision, and continue.

**Completion bar:** Passing CI alone is **not** sufficient. Both reviewers must approve with no open findings on an iteration where parent CI was green pre-review. On multi-phase plans, **every** phase must reach this bar.

---

## Subagent models

Track the review iteration within the current phase or single-phase task. Reset to iteration 1 at the start of each phase. Set the Task `model` parameter to `composer-2.5` on both subagents for every iteration.

| Review iteration | Reviewer A model | Bugbot model |
|------------------|------------------|--------------|
| 1, 2, 3, … | `composer-2.5` | `composer-2.5` |

To use the premium alternating GPT/Opus profile, see [review-loop-model-profiles.md](../../../referenceFiles/SOPs/review-loop-model-profiles.md).

---

## CI gate

Run from repo root **once per review iteration**, immediately before launching reviewers:

```powershell
cd frontend; npm run lint
cd frontend; npm test
cd backend; npm run lint
cd backend; npm test
```

Record pass/fail for each command and include results in every `reviewer-a` invocation. **Do not launch Reviewer A or Bugbot until all four pass.**

### Backend environment (local runs)

Backend `lint` and `test` import [`backend/config.js`](../../../backend/config.js), which **requires** `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `CLOUDFLARE_ACCOUNT_ID`, `R2_ACCESS_KEY_ID`, and `R2_SECRET_ACCESS_KEY` at module load. If any are missing, commands fail before tests run.

**Preferred (local agent runs):** Run the backend commands above with **no extra shell setup**. `config.js` loads `backend/.env.local` via `dotenv` automatically. Most developer machines already have this file (copy from `backend/.env.example` if needed).

**Do not** export or inline those variable names in shell commands (e.g. `$env:SUPABASE_SERVICE_ROLE_KEY=...` in PowerShell). That pattern looks like credential injection, may be blocked by safety review, and is unnecessary when `.env.local` exists.

**If backend fails with `Missing required environment variable`:** Ask the user to ensure `backend/.env.local` is present and populated — do **not** invent placeholder values on the command line.

**GitHub Actions only:** [`.github/workflows/ci.yml`](../../../.github/workflows/ci.yml) sets **non-secret CI placeholders** in the job `env:` block because runners have no `.env.local`. Agents mirror CI by running the same four commands locally; they do **not** need to duplicate the workflow `env:` block in the terminal.

---

## Invoke reviewer-a

Launch the [`reviewer-a`](../../agents/reviewer-a.md) subagent (`subagent_type: "reviewer-a"`, `model: composer-2.5`, `readonly: true`, `run_in_background: false`).

```text
Launch the reviewer-a subagent with:
- subagent_type: "reviewer-a"
- model: composer-2.5
- readonly: true
- run_in_background: false

Use the reviewer-a subagent to review this implementation.

Repository path: <absolute path>
Task summary: <one paragraph — what this phase or change set is supposed to accomplish>
Plan phase: <N of M | single-phase — omit line if ad-hoc with no plan>
Review iteration: <N — reset to 1 at the start of each phase>
Review model: <model slug used for this reviewer-a launch>
Prior approved phases: <list or "none" — multi-phase only>
Applicable docs: <SOP/architecture docs for touched areas>

CI gate (parent-verified, do not re-run):
- frontend lint: pass|fail
- frontend test: pass|fail
- backend lint: pass|fail
- backend test: pass|fail

Review changes for this phase (committed, staged, and unstaged). Flag regressions against prior approved phases.
Read every changed file in this phase's change set.
Return ALL findings — blocking AND non-blocking. Do not summarize or omit items.
Use the exact 7-section output format from reviewer-a (Verdict through CI gate status).
Re-launch with this full prompt after each fix batch — never a shortened message.
```

---

## Invoke Bugbot

Launch exactly one Bugbot subagent (`subagent_type: "bugbot"`, `model: composer-2.5`, `readonly: true`, `run_in_background: false`). **Do not ask Bugbot to run CI** — the parent runs the gate once per iteration before parallel launch; include in Custom Instructions when helpful: “CI gate already passed (parent-verified); do not re-run lint/test commands.”

```text
Launch the Bugbot subagent with:
- subagent_type: "bugbot"
- model: composer-2.5
- readonly: true
- run_in_background: false

Full Repository Path: <absolute repo path>
Diff: branch changes | uncommitted changes
Custom Instructions: <task-specific — regressions, security surfaces, incomplete changeset, scope boundaries>
```

**Custom Instructions** must name:

- What this **phase** (or change set) is supposed to do; plan phase **N of M** when applicable
- Review iteration **N**; Bugbot model is `composer-2.5`
- Regressions to flag (duplicate fetches, auth bypass, data leaks, broken embed/share paths, scope creep, regressions against prior approved phases)
- Out-of-scope items reviewers must not block on (if any)
- Requirement for complete changeset for **this phase** (no imports to missing/untracked files)

Bugbot must use the same verdict bar: `APPROVED` only when Blocking, Non-blocking, and Test gaps are all `"None"`. (Bugbot output format may differ from Reviewer A; only the verdict bar is shared.)

---

## Fix policy

Same bar as SOP **Verdict policy** — all finding types must be cleared before reviewers can approve:

| Finding type | Action |
|--------------|--------|
| Blocking | Must fix before next review |
| Non-blocking | Must fix — reviewers cannot approve with open items |
| Test gaps | Must add or extend tests — reviewers cannot approve with open items |

Do not close the phase or task or tell the user the work is “done” while any finding remains open.

---

## Complete changeset

Before requesting approval, verify for **the current phase**:

- Every new module, test file, and helper imported by the phase is included in the change set
- Architecture/SOP docs updated in the same pass when patterns or behavior changed
- No “works on my machine” reliance on untracked files

Incomplete changesets are a common blocking finding on re-review.

---

## Verification checklist

Use after landing or changing review artifacts:

- [ ] Slim rule is ~15–20 lines; `alwaysApply: true`; opens with “Unless truly trivial (see SOP)”
- [ ] Rule and SOP require per-phase loop on multi-phase plans; single-phase unchanged
- [ ] Skill documents **unlimited** loop and **no** user decision gate
- [ ] Skill documents **one CI run per iteration** (parent only); reviewers not launched on CI failure
- [ ] Skill specifies `reviewer-a` with `readonly: true`; Bugbot with `readonly: true`
- [ ] Skill specifies explicit `model: composer-2.5` for `reviewer-a` and Bugbot on every invocation
- [ ] Review iteration resets to 1 per phase and increments after each fix batch for re-review tracking
- [ ] `reviewer-a` invocation includes parent-verified CI results and plan phase **N of M** when applicable
- [ ] Agent output uses 7-section template with `## CI gate status` (parent-reported) instead of `## Commands run`
- [ ] Verbatim invocation block includes phase-scoped change set
- [ ] Bugbot invocation shape unchanged; shared verdict bar documented
- [ ] CI commands documented; backend uses `backend/.env.local` locally — no inline shell env vars
- [ ] No separate “final CI” step after dual `APPROVED`
- [ ] Triggers/exemptions text preserved in SOP
- [ ] `implementation-plan` skill documents per-phase code review during execution
- [ ] `reference-docs-check` quick pointer lists skill + SOP + rule (see [reference-docs-check SOP](../../../referenceFiles/SOPs/reference-docs-check.md))
- [ ] Grep sweep finds no stale prompt-template or “run CI yourself” references
- [ ] `reviewer-a` dry-invoke succeeds via Task tool (`readonly: true`)
- [ ] No plan-review-isms leaked (max 3 passes, non-blocking may remain on APPROVED, discovery steps, A/B/C)
