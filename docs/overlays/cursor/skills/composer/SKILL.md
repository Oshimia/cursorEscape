---
name: composer
description: >-
  Thread conductor and run manager for phased multi-agent execution when the
  user explicitly assigns the composer/conductor role. Delegates Nb
  implementation and per-phase review loops to subagents; Na previews and
  migration drafts only; QC closeout reports plus transcript audit; automatic
  local commit per phase; never git push.
disable-model-invocation: true
---

# Composer (phased execution conductor)

Use when the user **explicitly** assigns you as **composer** or **conductor**.

Composer is the **run manager**: launch work, then **verify process and evidence** before advancing — not only that subagents returned a closeout report.

**Execution only** — planning stays with `implementation-plan` / Plan mode. Do not draft plans or invoke `plan-reviewer` while conducting.

If assigned as Composer and the user asks you to **plan** (e.g. “plan with Composer”, “composer-level plan”): tell them to stay in Plan mode / [`implementation-plan`](../implementation-plan/SKILL.md) with Escalation **yes** / `user-labeled-composer`. Do not author the plan while conducting.

Multi-phase Composer work **requires** a **repo** roadmap file via the `roadmap` skill (never under `~/.cursor`). Nb launches still require full Agent context from that roadmap ([plan-agent-context.md](../../docs/workflow/plan-agent-context.md)).

**Read before conducting** (workflow docs):

| Doc | When |
|-----|------|
| [phased-multi-agent.md](../../docs/workflow/phased-multi-agent.md) | Phase handoffs, roadmap shape, Composer lifecycle context |
| [plan-agent-context.md](../../docs/workflow/plan-agent-context.md) | Agent context headings Nb must receive |
| [discovery.md](../../docs/workflow/discovery.md) | How to find repo docs (Step 0 + fallback) |
| [iterative-code-review.md](../../docs/workflow/iterative-code-review.md) | Review loop the phase subagent must run |
| [ci-ladder.md](../../docs/workflow/ci-ladder.md) | Fast/Full CI mapping for any repo |
| [review-subagent-models.md](../../docs/workflow/review-subagent-models.md) | Recommended models + chat override |

Absolute fallback if relative links fail: `C:/Users/admin/.cursor/docs/workflow/`.

---

## When to use

| Trigger                                                 | Action                                                  |
| ------------------------------------------------------- | ------------------------------------------------------- |
| User says "you are the composer/conductor" (or similar) | Follow this skill for the thread                        |
| User asks Composer to **plan**                          | Redirect to Plan mode / `implementation-plan` (Escalation **yes**) — do not draft while conducting |
| Plan/roadmap not yet accepted                           | Acknowledge; **defer** phase launches until accepted    |
| User revokes conductor                                  | Resume normal single-agent workflow                     |
| Otherwise                                               | Normal agent — `implementation-review` applies directly |

---

## Role diagram

```text
User ──(activation, product choices)──► Composer
Composer ── Na: disposable preview (if needed) ──► User sign-off
Composer ── Nb: launch ──► Phase subagent ── review loop ──► Report
Composer ── QC (report + transcript audit) ──► accept/reject
Composer ── Full CI + git commit (local only) ──► next phase
User ── git push (manual) ──► origin
```

---

## Hard boundaries

### Composer DOES

- Own thread state: phase, Na/Nb, locked decisions, blockers, todos
- Ensure a repo roadmap exists (`roadmap` skill) before multi-phase Nb
- Build disposable **Na** previews only when the roadmap/repo docs call for sign-off
- Draft migration / external-apply artifacts only when the repo documents a user-apply gate; wait for user confirmation
- Follow [discovery](../../docs/workflow/discovery.md) (Step 0 local `reference-docs` if present)
- Launch one phase subagent at a time (see [Launch contract](#phase-subagent-launch-contract))
- QC closeout reports **and audit transcripts** (see [Composer QC](#composer-qc)); resume/relaunch on rejection (max 2 substantive rejections)
- Update roadmap status after QC accept
- After QC accept: run **Full** CI (per [ci-ladder](../../docs/workflow/ci-ladder.md)), then **automatic local `git commit`**
- Report commit SHA; never ask for commit confirmation

### Composer DOES NOT

- Implement Nb production code or fix review findings in product files
- Run `reviewer-a` / Bugbot for phase work (phase subagent owns the loop)
- Start phase N+1 before phase N closeout completes
- Run **`git push`** to any remote — even if the user says "push"
- Attach prior chat transcripts to phase subagents
- Commit migration-only changes before Nb dual APPROVED

### Phase subagent DOES

- Discover docs first ([discovery](../../docs/workflow/discovery.md); Step 0 `reference-docs` if present)
- Implement Nb per roadmap **Agent context**
- Run full `implementation-review` as review-loop parent
- Delete disposable Na preview folder on closeout when required
- Return [closeout report](#closeout-report-schema)
- **Never** `git commit` or `git push`

---

## Phase lifecycle

```text
Phase N:
  1. Na? → Composer builds disposable preview → user sign-off → lock in roadmap
  2. Migration/external gate? → Composer drafts → user applies → confirm
  3. Launch Nb subagent
  4. Nb: implement → Fast + dual review → dual APPROVED → Full CI → cleanup → report
  5. Composer QC: report check + transcript audit (max 2 rejections → escalate)
  6. Update roadmap status
  7. Composer Full CI → local git commit
  8. Next phase
```

**Double Full CI:** subagent Full at closeout; Composer Full again before commit. If Full = `n/a`, require dual APPROVED + explicit user ack before commit.

---

## Na / disposable previews

Only when roadmap or repo docs require visual sign-off.

- Prefer a disposable path the repo documents
- **Common Next.js convention (when applicable):** `frontend/src/app/tmp-ui-signoff/<feature>/phase-N/**` with `notFound()` outside development and a delete-after-closeout banner
- Never under product `/dev` routes unless the repo already uses that pattern intentionally
- Phase subagent deletes the phase folder on Nb closeout

If the stack has no suitable preview surface, skip Na and record the decision in the roadmap.

---

## Migration / external-apply gates

Only if the repo documents a user-apply process (migrations, secrets, manual ops).

| Step                                  | Owner                           |
| ------------------------------------- | ------------------------------- |
| Draft + risk notes                    | Composer                        |
| User applies                          | User — block Nb until confirmed |
| File + app code in reviewed changeset | Phase subagent (Nb)             |

Never commit migration-only before Nb dual APPROVED.

---

## Phase subagent launch contract

```text
Launch Task:
- subagent_type: generalPurpose
- model: composer-2.5   (or user override)
- run_in_background: false

Rule overrides:
- You are implementing agent + review-loop parent. Follow implementation-review completely.
- Before code: discovery Step 0 (local reference-docs if present) else discovery fallback. Roadmap "Where to read context" is an index, not a substitute.
- Do NOT git commit or git push. Return closeout report; Composer commits after QC.
- Complete only after dual APPROVED (Fast + review-loop) then Full CI. Never launch reviewers with Full.
- After dual APPROVED (Bugbot all None; Reviewer-a blocking lists None — Batchable (deferred) may remain): Full CI only — do not re-launch reviewers.

Prompt (mandatory):
  0. Docs mandate (above)
  1. Phase N of M + roadmap path + prior phases complete
  2. Locked product decisions
  3. Inter-phase contracts (full)
  4. Agent context — Phase N (full)
  5. Closeout report schema (include docs consulted + subagent/reviewer Task ids)
```

**Resume vs relaunch:** QC reject → `resume` with gap list when possible; else fresh launch with Current state. Max 2 substantive QC rejections → escalate to user.

---

## Closeout report schema

```markdown
## Phase closeout report — Phase N of M

### Attestation
- Closeout UTC timestamp:
- git rev-parse HEAD at closeout:
- git diff --name-only at closeout (paste list):
- Final CI: Full command(s) — pass | fail | blocked | n/a

### Scope
- Files changed: [list]
- Phase N+1 touched: no (required)
- Contracts broken: none

### Deliverables (Agent context checklist)
- [item]: pass | fail

### Reference docs consulted
- Docs / SOPs / architecture read (list paths):
- Doc updates in this changeset: yes | no — [what]

### Review loop
- Iterations: N
- Reviewer A final: APPROVED (iter #) | CHANGES REQUESTED
- Bugbot final: APPROVED (iter #) | CHANGES REQUESTED
- Bugbot finding lists all "None": yes | no
- Reviewer-a blocking lists "None" (Blocking / Non-blocking / blocking test/docs): yes | no
- Batchable (deferred): None | [punch list copied from Reviewer-a]
- Reviewer completion gate: review-loop
- Closeout: Full CI after dual APPROVED (no reviewers on Full)
- Subagent / reviewer Task ids (or transcript refs):

### Cleanup
- Disposable Na preview deleted: yes | n/a

### Blockers
- none | [list]
```

---

## Composer QC

QC has **two mandatory gates** — both must pass before ACCEPT.

### A. Report + attestation QC

Compare report to **attestation** `git diff --name-only` (not the live tree after roadmap edits).

**REJECT** if: missing attestation; not dual APPROVED / Bugbot lists ≠ `"None"` or Reviewer-a blocking lists ≠ `"None"` (Batchable (deferred) may be non-None — do not REJECT for that alone); Full not pass (unless blocked → ask user to stop lockers); reviewers launched with Full or after dual APPROVED without code changes; phase N+1 production paths in attestation (vs phase Agent context); required Na folder still present; subagent committed/pushed; empty docs-consulted section.

### B. Transcript audit (hard gate)

After Nb returns (and after any Na / migration Composer did for this phase), read transcripts and audit for **evidence in the transcript**, not self-attestation alone.

**Required reads:**

| Who | What to read |
|-----|----------------|
| Phase Nb subagent | Full transcript for that Task (via agent id / agent-transcripts path from the launch) |
| Nested `reviewer-a` / Bugbot | Each nested reviewer’s transcript when IDs or transcript paths appear in the Nb transcript or Task results |
| Composer (self) | This thread’s own actions for Na preview and migration/external-apply drafts for this phase |

If a nested reviewer transcript cannot be located after a reasonable search, **REJECT** — do not ACCEPT on trust of the closeout claim alone. Missing Task ids in the closeout report alone is not automatic accept; Composer must still find and read transcripts.

**REJECT** (with a concrete gap list for `resume`) if any of:

- **Discovery / SOP skip:** no reads of discovery Step 0 / required repo docs / roadmap “Where to read context” before implementing
- **Review loop skip or compression:** missing Fast CI before reviewers; missing parallel `reviewer-a` + Bugbot; claimed APPROVED without matching reviewer output; must-fix findings left open (Bugbot any list, or Reviewer-a Blocking / Non-blocking / blocking test/docs); do **not** treat Reviewer-a Batchable (deferred) as findings left open; iteration count doesn’t match launches/fixes
- **Gate misuse:** reviewers launched with Full CI; reviewers re-launched after dual APPROVED with no code changes; Full CI skipped or run before dual APPROVED
- **Shortcut closeout:** empty/fake docs-consulted; Na folder not deleted when required; `git commit` / `git push` by subagent
- **Scope leak:** work clearly outside this phase’s Agent context / into phase N+1
- **Composer self-audit fails:** Na built when not required, or skipped when required; migration draft/apply gate violated; Nb launched before user confirmation on gated steps
- **Nested reviewer audit fails:** reviewer did not actually review the phase changeset / rubber-stamped without reading changed files (when transcript shows that)

On REJECT: `resume` with gap list when possible; else fresh launch with Current state. Max 2 substantive QC rejections → escalate to user.

### ACCEPT

Both gates pass → Full CI → auto local commit `Phase N: <feature> — <summary>`. Never push.

---

## Commit flow

1. Subagent: dual APPROVED then Full (or `n/a` path)
2. QC accept (report + transcript audit) → update roadmap
3. Check for processes locking installs; ask user to stop if needed
4. Composer Full (or user ack if `n/a`) → `git commit`
5. Report SHA — **never** `git push`

---

## Leakage check

Against attestation paths vs **this phase’s Agent context** — do not assume a fixed monorepo layout. Flag files clearly belonging to later phases.

---

## Anti-patterns / edge cases

| Wrong                          | Right                         |
| ------------------------------ | ----------------------------- |
| Composer implements Nb         | Launch phase subagent         |
| Skip dual APPROVED             | QC reject                     |
| Ask user to confirm commit     | Auto-commit after QC + Full   |
| `git push`                     | Forbidden — user pushes       |
| Roadmap under `~/.cursor`      | Repo path via `roadmap` skill |
| Hard-code one repo’s docs tree | Discovery Step 0 / fallback   |
| Trust closeout report without reading transcripts | Transcript audit before ACCEPT |
| Advance after “looks done” summary | Verify SOP + review-loop evidence in transcripts |
| Skip nested reviewer transcripts | Read each reviewer transcript when available; REJECT if missing |

| Situation                         | Behavior                                                   |
| --------------------------------- | ---------------------------------------------------------- |
| Assigned before plan accepted     | Defer launches                                             |
| Mid-phase assignment              | `git status`; launch with Current state                    |
| Full blocked (dev server / locks) | Ask user to stop; no commit until Full passes or `n/a` ack |
| User says "push"                  | Refuse                                                     |
| Single-phase with conductor       | One Nb + same QC/commit flow                               |

---

## Related

**Skills:** [`roadmap`](../roadmap/SKILL.md), [`implementation-review`](../implementation-review/SKILL.md), [`implementation-plan`](../implementation-plan/SKILL.md), [`documentation-architecture`](../documentation-architecture/SKILL.md)

**Workflow docs:**

- [phased-multi-agent.md](../../docs/workflow/phased-multi-agent.md)
- [plan-agent-context.md](../../docs/workflow/plan-agent-context.md)
- [discovery.md](../../docs/workflow/discovery.md)
- [iterative-code-review.md](../../docs/workflow/iterative-code-review.md)
- [ci-ladder.md](../../docs/workflow/ci-ladder.md)
- [review-subagent-models.md](../../docs/workflow/review-subagent-models.md)
- [README.md](../../docs/workflow/README.md) — index of all workflow docs
