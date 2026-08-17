> **Imported research** — Source: live `~/.cursor`; copied 2026-08-17 into cursorEscape. Status: Observed/imported (live canonical for Target workflow). Do not treat as Target cursorEscape design unless a Target doc cites it.
---
name: implementation-plan
description: >-
  Draft comprehensive implementation plans for Plan mode. Covers goal, scope,
  confidence-rated assumptions, discovery steps, conditional A/B/C, incremental
  phases, and verification. Use proactively when planning any non-trivial change,
  before invoking the plan-reviewer subagent (max 3 passes per loop).
disable-model-invocation: true
---

# Implementation plan

Use when drafting a plan in Plan mode. A complete draft feeds the **plan-reviewer** subagent for adversarial review.

This skill is **repo-agnostic**. Do not assume a fixed doc tree or scripts.

**Read when planning:**

| Doc | When |
|-----|------|
| [discovery.md](../../docs/workflow/discovery.md) | Find repo docs (Step 0 + fallback) |
| [iterative-plan-review.md](../../docs/workflow/iterative-plan-review.md) | Plan → plan-reviewer loop |
| [plan-agent-context.md](../../docs/workflow/plan-agent-context.md) | Escalation field + Agent context when escalated |
| [phased-multi-agent.md](../../docs/workflow/phased-multi-agent.md) | Multi-phase / Composer handoffs |
| [review-subagent-models.md](../../docs/workflow/review-subagent-models.md) | Recommended `plan-reviewer` model |
| [README.md](../../docs/workflow/README.md) | Index of all workflow docs |

Absolute fallback: `C:/Users/admin/.cursor/docs/workflow/`.

---

## When review is mandatory

**When in doubt, run it.**

| Trigger | Examples |
|---------|----------|
| Multi-file work | 2+ source files (code, tests, migrations) |
| Cross-layer change | Frontend + backend, API + UI, DB + app |
| Behavioral change | Endpoints, auth/RBAC, state, permissions |
| Database / migration | Schema, enums, RLS, grants |
| New patterns | Hooks, workflows, architecture others should follow |
| External dependencies | APIs, user migration steps, secrets, deploy |
| Ambiguous scope | Assumes behavior without citing code or docs |

## When it may be skipped

- Typo or copy fix in one place
- Comment-only or pure formatting
- Cosmetic-only UI (no behavior, data, or permissions)
- Documentation-only with no code/behavior change
- User explicitly instructs skip

If the plan touches tests, APIs, auth, migrations, shared utilities, or logic/state/fetch/handlers — **do not skip**.

---

## Workflow

```text
Research docs → draft plan → review (max 3) → synthesize between passes → present to user
```

1. **Research** — [discovery.md](../../docs/workflow/discovery.md) Step 0 / fallback. Skip missing paths; do not invent a required layout.
2. **Draft** using the [plan template](#plan-template) below. Fill every section.
3. **Invoke plan-reviewer** with **clean context** — repository path, task summary, review pass number, and **synthesized plan text only**. Do **not** attach prior review transcripts.

   ```text
   Launch the plan-reviewer subagent with:
   - subagent_type: "plan-reviewer"
   - model: composer-2.5   (recommended default; override only if user asks)
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

Recommended default for every `plan-reviewer` launch:

| Review pass | `plan-reviewer` model |
|-------------|----------------------|
| 1 of 3 | `composer-2.5` |
| 2 of 3 | `composer-2.5` |
| 3 of 3 | `composer-2.5` |

If the user chooses **Continue planning** after the first three-pass loop, reset to pass 1. Use a different model only when the user explicitly requests it.

---

## Plan template

Fill every section. Missing critical sections are likely blocking findings from plan-reviewer.

### Goal

One paragraph: what success looks like.

### Scope

- **In scope** — files, layers, behaviors touched
- **Out of scope** — explicit boundaries to prevent creep

### Escalation

Mandatory on every non-trivial plan. Place **immediately after Scope**. Schema and Agent context headings: [plan-agent-context.md](../../docs/workflow/plan-agent-context.md).

```markdown
### Escalation
- Agent context required: **yes** | **no**
- Reason: `user-labeled-composer` | `complex-or-extensive` | `n/a`
```

| Set | When |
|-----|------|
| **yes** + `user-labeled-composer` | User says composer-level, or asks Composer to **plan** |
| **yes** + `complex-or-extensive` | Unusually hard / extensive (≤3 phases usually **no**; not a hard cap) |
| **no** + `n/a` | Default — do **not** write Agent context blocks |

If unsure: AskQuestion; do not silently escalate.

**Planning vs conduct (Composer):**

| User says (examples) | Action |
|----------------------|--------|
| “plan with Composer”, “composer-level plan”, “you are composer for planning” | Stay on **this** skill; Escalation **yes** / `user-labeled-composer` |
| “you are the composer/conductor”, “conduct phase 2”, “execute the roadmap” | Conducting — do **not** draft here; follow [`composer`](../composer/SKILL.md) after an accepted plan |

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

**SOP post-apply / operator checklist (mandatory when applicable):** If the plan touches migrations, schema dumps, RPC signature changes, grants/RLS verify scripts, API schema-cache reloads, or any other steps listed in the **repo’s** migration/deploy SOP checklist, do **not** leave those only as bullets here.

- Lift **each** checklist item into **Incremental execution** (named phase or todo) and/or **Verification** (row with command/when).
- Name the **owner** per step (user applies SQL vs agent runs refresh tool vs either).
- Prefer the repo’s documented tool names and gates when known (from SOPs/rules); do not invent a cross-repo tool name.
- Mention-only under External dependencies is **not** sufficient — plan-reviewer treats buried SOP post-apply steps as an unacknowledged verification gap.

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

Ordered **phases** that can land safely. Name phases explicitly (Phase 1, Phase 2, …).

- What ships independently per phase
- Migration ordering (schema before code, etc.)
- Rollback or backward compatibility
- Partial-deploy risk and mitigations
- Optional final cross-phase verification (smoke, regression) as its own phase if needed
- **Post-apply / operator steps** from the repo SOP (schema dump refresh, grants verify, schema-cache reload, etc.) as their own phase or explicit todos — not only listed under External dependencies

On multi-phase plans, treat each phase as a review boundary during implementation (run whatever post-implementation review process this repo uses before starting the next phase).

**When Escalation is `Agent context required: **yes**`:** also include (do not invent a thinner stub):

- **Inter-phase contracts** (N/A OK for a single-phase escalated plan)
- **Migration / external apply order** when the repo has those gates (else none)
- **`#### Agent context — Phase N`** for every execution phase — required headings in [plan-agent-context.md](../../docs/workflow/plan-agent-context.md) (link; do not paste the full specimen into this skill)

When Escalation is **no**, keep light phase bullets only — no Agent context blocks.

### Verification

Per risky behavior: what to verify, how (test, manual check, project CI command), and when.

Prefer the **repo's actual** lint/test/CI commands when known (from README, scripts, package.json, Makefile, etc.). Example shape:

| Tier | Command | When |
|------|---------|------|
| **Fast** | project quick lint/test | Mid-loop / iteration |
| **Full** | project full CI / test suite | Before commit or phase closeout |

Include applicable commands when the plan touches those layers. If CI commands are unknown, list **Discovery steps** to identify them.

When the plan includes DB/schema/RPC work, also include Verification rows (or an Incremental execution phase) for each repo SOP post-apply checklist item (dump refresh, grants verify, cache reload, etc.) with owner and timing.

### Architecture and docs

- Project docs / conventions that apply
- Planned doc updates if patterns or behavior change

---

## What plan-reviewer audits

| Area | Plan section |
|------|----------------|
| Assumptions (confidence) | Assumptions |
| Unknowns | Unknowns |
| Accepted uncertainties | Discovery steps |
| External dependencies | External dependencies |
| Buried SOP post-apply steps | External dependencies vs Incremental execution / Verification |
| Pre-implementation checks | Verification, Discovery steps |
| A/B/C (conditional) | Alternative approaches |
| Architecture inflation | Cost challenge (reviewer) |
| Likely failures | Failure forecast (reviewer) |
| Safe sequencing | Incremental execution |
| Documented patterns | Architecture and docs |
| Escalation field present | Escalation |
| Escalated Agent context / contracts | Escalation **yes** → [plan-agent-context.md](../../docs/workflow/plan-agent-context.md) headings |
| Composer planning mismatch | Planning signal + Escalation **no** → blocking |

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
2. At the end of each phase, run the **implementation-review** skill (Reviewer A + Bugbot): Fast CI → dual `APPROVED` → Full CI closeout before the next phase.
3. Task is complete when the **final** phase passes that bar (not when all phases are coded without intermediate review).

Do **not** batch multiple phases into one review at plan completion.

### Composer-conducted execution

When the user assigns the `composer` skill for execution, planning is already complete. Do not re-plan or invoke `plan-reviewer`. Each phase goes to a clean-context subagent per `composer`; the Composer does not implement phase code.

### Large & complex / escalated plans

When Escalation is **yes**, put full Agent context (and contracts) **in the accepted plan** per [plan-agent-context.md](../../docs/workflow/plan-agent-context.md) — not only after accept in a repo roadmap.

After approval, use the [`roadmap`](../roadmap/SKILL.md) skill to write a **repo** roadmap: Escalation **yes** → **copy** from the plan (fail-closed if stub); Escalation **no** → optional roadmap that **may restructure** thin Incremental execution into Agent context **without new scope**. See [phased-multi-agent.md](../../docs/workflow/phased-multi-agent.md). Do not store roadmaps under `~/.cursor`. Prefer [`documentation-architecture`](../documentation-architecture/SKILL.md) when bootstrapping new docs areas.

---

## Related

**Skills / agents:** [`roadmap`](../roadmap/SKILL.md), [`implementation-review`](../implementation-review/SKILL.md), [`composer`](../composer/SKILL.md), [`documentation-architecture`](../documentation-architecture/SKILL.md), [`plan-reviewer`](../../agents/plan-reviewer.md)

**Workflow docs:** [discovery.md](../../docs/workflow/discovery.md), [iterative-plan-review.md](../../docs/workflow/iterative-plan-review.md), [plan-agent-context.md](../../docs/workflow/plan-agent-context.md), [phased-multi-agent.md](../../docs/workflow/phased-multi-agent.md), [iterative-code-review.md](../../docs/workflow/iterative-code-review.md), [review-subagent-models.md](../../docs/workflow/review-subagent-models.md), [README.md](../../docs/workflow/README.md)
