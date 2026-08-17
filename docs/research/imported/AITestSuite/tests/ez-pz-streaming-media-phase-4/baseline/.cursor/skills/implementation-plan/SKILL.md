> **Imported research** — Source: AITestSuite `tests\ez-pz-streaming-media-phase-4\baseline\.cursor\skills\implementation-plan\SKILL.md`; copied 2026-08-17 into cursorEscape. Status: Observed/eval-packaging. Do not treat as Target cursorEscape design unless a Target doc cites it.
---
name: implementation-plan
description: >-
  Draft comprehensive implementation plans for Plan mode. Covers goal, scope,
  confidence-rated assumptions, discovery steps, conditional A/B/C, incremental
  phases, and verification. Use when planning any non-trivial change, before
  invoking the plan-reviewer subagent (max 3 passes per loop). During execution,
  each phase triggers the implementation-review loop before the next phase starts.
disable-model-invocation: true
---

# Implementation plan

Use when drafting a plan in Plan mode. A complete draft feeds the [`plan-reviewer`](../../agents/plan-reviewer.md) subagent for adversarial review.

Canonical triggers and exemptions: [iterative-plan-review.md](../../../referenceFiles/SOPs/iterative-plan-review.md)

---

## Workflow

```text
Research docs → draft plan → review (max 3) → synthesize between passes → present to user
```

1. Follow the [reference-docs skill](../reference-docs/SKILL.md) — consult indexes and read every applicable doc for touched areas.
2. Draft the plan using the [template](#plan-template) below.
3. Invoke plan-reviewer with **clean context** and `model: composer-2.5` from [Subagent models](#subagent-models) — repository path, task summary, review pass number, and **synthesized plan text only**. Do **not** attach prior review transcripts.

   ```text
   Launch the plan-reviewer subagent with:
   - subagent_type: "plan-reviewer"
   - model: composer-2.5
   - readonly: true
   - run_in_background: false

   Use the plan-reviewer subagent to review this plan.

   Repository path: <absolute path>
   Task summary: <one paragraph>
   Review pass: <1|2|3> of 3
   Review model: <model slug used for this launch>
   Plan under review:
   <full plan text>
   ```

4. **Synthesize** between passes (see [Synthesis between passes](#synthesis-between-passes)).
5. Repeat until `APPROVED` **or** 3 passes complete — then [present to user](#final-presentation).

**Hard cap:** max **3** plan-reviewer invocations per autonomous loop. After pass 3, always stop and present — even if verdict is `CHANGES REQUESTED`.

---

## Subagent models

Set the Task `model` parameter to `composer-2.5` on every `plan-reviewer` launch:

| Review pass | `plan-reviewer` model |
|-------------|----------------------|
| 1 of 3 | `composer-2.5` |
| 2 of 3 | `composer-2.5` |
| 3 of 3 | `composer-2.5` |

If the user chooses **Continue planning** after the first three-pass loop, reset the next planning loop to pass 1 with `composer-2.5`. To use the premium alternating GPT/Opus profile, see [review-loop-model-profiles.md](../../../referenceFiles/SOPs/review-loop-model-profiles.md).

---

## Plan template

Fill every section. Missing critical sections are likely blocking findings.

### Goal

One paragraph: what success looks like.

### Scope

- **In scope** — files, layers, behaviors touched
- **Out of scope** — explicit boundaries to prevent creep

### Assumptions

| Assumption | Confidence (High/Medium/Low) | Evidence | Validation method |

**Rule:** Low confidence without evidence → move to **Unknowns** or **Discovery steps**, not Assumptions.

### Unknowns

Open questions, unverified APIs, unclear permissions — items to resolve before or during execution.

### Discovery steps

Uncertainties accepted for planning but requiring investigation before dependent work:

| Item | Why it matters | Method | When (before step N) |

A verification gap is acceptable when captured here with method and timing.

### External dependencies

Third-party services, manual user steps (migrations, secrets, deploy), CI/infra, package changes.

### Alternative approaches

**Required:** yes | no — \<one-line reason\>

**Required yes** when: architectural change, new subsystem, database design, new shared abstraction, or new external integration.

```markdown
[If required]
- Approach A (recommended) — preferred path and rationale
- Approach B (alternative) — different trade-off
- Approach C (minimal-change) — smallest diff that could work, with limits

[If optional]
- Recommended approach — ...
- Simpler options considered — brief note on why they were not chosen
```

### Incremental execution

Ordered **phases** that can land safely. Each phase is a review boundary — implementation runs the [implementation-review](../implementation-review/SKILL.md) loop (Reviewer A + Bugbot) at the end of **every** phase before the next begins.

- What ships independently per phase (name phases explicitly: Phase 1, Phase 2, …)
- Migration ordering (schema before code, etc.)
- Rollback or backward compatibility
- Partial-deploy risk and mitigations
- Optional final cross-phase verification (smoke, regression) as its own phase if needed

### Verification

Per risky behavior: what to verify, how (test, manual check, CI command), and when.

```powershell
cd frontend; npm run lint
cd frontend; npm test
cd backend; npm run lint
cd backend; npm test
```

Include applicable commands when the plan touches those layers.

### Architecture and docs

- SOPs and feature-architecture docs that apply
- Planned doc updates if patterns or behavior change

---

## What plan-reviewer audits

| Area | Plan section |
|------|----------------|
| Assumptions (confidence) | Assumptions |
| Unknowns | Unknowns |
| Accepted uncertainties | Discovery steps |
| External dependencies | External dependencies |
| Pre-implementation checks | Verification, Discovery steps |
| A/B/C (conditional) | Alternative approaches |
| Architecture inflation | Cost challenge (reviewer) |
| Likely failures | Failure forecast (reviewer) |
| Safe sequencing | Incremental execution |
| Documented patterns | Architecture and docs |

---

## Synthesis between passes

After each review, merge fixes into the **plan template sections** — do not paste the full review output into the next invocation.

**Act on (max 5):**

- Emitted **blocking findings** from the review
- **Unacknowledged verification gaps** (promote to discovery steps or resolve)

**Use as backlog hints only (do not fix in this pass):**

- **Findings summary** overflow line (`+N additional … omitted — themes: …`)
- Non-emitted items; the next pass will surface them after top blockers are fixed

**Also fold in when relevant:**

- Cost challenge and failure forecast → update discovery steps, scope, or incremental execution
- Low-confidence assumptions → move to Unknowns or Discovery steps

Re-invoke with **synthesized plan text only** + review pass number. No review transcripts.

---

## Final presentation

Present after pass 3 **or** early `APPROVED`.

### Package contents

- Revised plan (full text)
- Review pass count (1–3)
- Final verdict
- **Outstanding requested changes** — if `CHANGES REQUESTED`, lead with emitted blocking findings (max 5) and overflow themes from Findings summary
- Blocking findings (verbatim from last review, if any)
- Non-blocking findings
- Discovery steps for user acknowledgment
- Note if 3-pass cap was hit before `APPROVED`

### User decision (required when cap hit with `CHANGES REQUESTED`, or discovery steps need acknowledgment)

```text
Planning loop completed (N of 3 passes). Verdict: CHANGES REQUESTED.

Outstanding requested changes:
1. ...
2. ...

How would you like to proceed?
- Continue planning — run another review cycle
- Revise manually — you edit or give direction; agent re-drafts then may re-review
- Accept as-is — proceed to implementation despite open items (explicit override)
```

**Wait for user input** before another planning loop or switching to Agent mode.

Early `APPROVED`: present plan and non-blocking findings; optional acknowledgment of discovery steps.

---

## After review (between passes)

| Verdict | Action |
|---------|--------|
| `CHANGES REQUESTED` | [Synthesize](#synthesis-between-passes) — fix emitted blockers and unacknowledged gaps only; re-invoke with full synthesized plan |
| `APPROVED` | Present to user (normally present on `APPROVED`) |

Do not start implementation until user accepts the plan (or explicitly overrides).

---

## During implementation (Agent mode)

After the user accepts the plan:

1. Implement **one phase** at a time from **Incremental execution**.
2. Run the full [implementation-review](../implementation-review/SKILL.md) loop at the end of that phase — dual `APPROVED` required.
3. Only then start the next phase.
4. Task is complete when the **final** phase passes review (not when all phases are coded without intermediate review).

Do **not** batch multiple phases into one review at plan completion.
