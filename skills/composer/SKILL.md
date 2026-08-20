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

Multi-phase Composer work **requires** a **repo** roadmap file via the `roadmap` skill (never under `~/.cursor`). Nb launches still require full Agent context from that roadmap ([plan-agent-context.md](../../workflow/plan-agent-context.md)).

**Read before conducting** (workflow docs):

| Doc | When |
|-----|------|
| [phased-multi-agent.md](../../workflow/phased-multi-agent.md) | Phase handoffs, roadmap shape, Composer lifecycle context |
| [plan-agent-context.md](../../workflow/plan-agent-context.md) | Agent context headings Nb must receive |
| [discovery.md](../../workflow/discovery.md) | How to find repo docs (Step 0 + fallback) |
| [iterative-code-review.md](../../workflow/iterative-code-review.md) | Review loop the phase subagent must run |
| [ci-ladder.md](../../workflow/ci-ladder.md) | Fast/Full CI mapping for any repo |
| [review-subagent-models.md](../../overlays/cursor/review-subagent-models.md) | Recommended models + chat override |

Absolute fallback if relative links fail: `C:/Users/admin/.cursor/` workflow mirror (copy-out only).

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
Composer ── Nb: launch ──► Phase subagent ── review loop (≤4/block) ──► closeout OR cap-exhausted handoff
Composer ── on closeout: QC (report + transcript audit) ──► accept/reject
Composer ── on cap handoff: transcript audit → triage (Renew|Focus-narrow|Terminate|Waive)
Composer ── Full CI + git commit (local only) after ACCEPT ──► next phase
User ── git push (manual) ──► origin
```

---

## Hard boundaries

### Composer DOES

- Own thread state: phase, Na/Nb, locked decisions, blockers, todos
- Ensure a repo roadmap exists (`roadmap` skill) before multi-phase Nb
- Build disposable **Na** previews only when the roadmap/repo docs call for sign-off
- Draft migration / external-apply artifacts only when the repo documents a user-apply gate; wait for user confirmation
- Follow [discovery](../../workflow/discovery.md) (Step 0 local `reference-docs` if present)
- Launch one phase subagent at a time (Cursor Task spawn: [composer overlay](../../overlays/cursor/skills/composer/SKILL.md#phase-subagent-launch-contract))
- QC closeout reports **and audit transcripts** (see [Composer QC](#composer-qc)); resume/relaunch on rejection (max 2 substantive rejections)
- On **cap-exhausted handoff**: transcript audit **then** [triage](#cap-exhausted-triage-before-accept) (Renew | Focus-narrow | Terminate | Waive) — do not treat handoff as dual-APPROVED closeout
- Update roadmap status after QC accept (or after Cap→Waive accept)
- After QC accept: run **Full** CI (per [ci-ladder](../../workflow/ci-ladder.md)), then **automatic local `git commit`** (Cap→Waive: single Composer Full; dual path: Double Full)
- Report commit SHA; never ask for commit confirmation

### Composer DOES NOT

- Implement Nb production code or fix review findings in product files
- Run `reviewer-a` / Bugbot for phase work (phase subagent owns the loop)
- Start phase N+1 before phase N closeout completes
- Run **`git push`** to any remote — even if the user says "push"
- Attach prior chat transcripts to phase subagents
- Commit migration-only changes before Nb dual APPROVED (or Composer-attested waiver after pressure-release triage)

### Phase subagent DOES

- Discover docs first ([discovery](../../workflow/discovery.md); Step 0 `reference-docs` if present)
- Implement Nb per roadmap **Agent context**
- Run full `implementation-review` as review-loop parent (**≤4 dual-review iterations per block**; no 5th pair)
- Delete disposable Na preview folder on closeout when required
- Return [closeout report](#closeout-report-schema) after dual APPROVED + Full **or** [cap-exhausted handoff](#cap-exhausted-handoff-schema) after iteration 4 without dual APPROVED (**no Full** on handoff; **do not self-renew**)
- **Never** `git commit` or `git push`
- **Never** self-Waive

---

## Phase lifecycle

```text
Phase N:
  1. Na? → Composer builds disposable preview → user sign-off → lock in roadmap
  2. Migration/external gate? → Composer drafts → user applies → confirm
  3. Launch Nb subagent
  4. Nb: implement → Fast + dual review (≤4/block)
       ├─ dual APPROVED → Full CI → cleanup → closeout report → step 5a
       └─ iter 4 without dual APPROVED → cap-exhausted handoff (no Full) → step 5b
  5a. Composer QC on closeout (report + transcript audit) → ACCEPT → roadmap → Full → commit → next
  5b. Composer transcript audit on handoff → triage (Renew|Focus-narrow|Terminate|Waive)
       ├─ Renew / Focus-narrow → relaunch/resume Nb (iteration reset to 1; ≤4 more) → step 4
       ├─ Terminate / change approach → escalate to user; no ACCEPT
       └─ Waive (process/out-of-spec only) → waiver attestation → Composer Full → ACCEPT → commit
  6. Next phase
```

**Double Full CI (dual-APPROVED path):** subagent Full at closeout; Composer Full again before commit. If Full = `n/a`, require dual APPROVED + explicit user ack before commit.

**Cap→Waive path:** subagent skipped Full; **single** Composer Full only (intentional Double-Full exception). If Full = `n/a`, require waiver attestation + explicit user ack before commit.

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
- Pressure-release block: N
- Iterations this block: N (≤4)
- Reviewer A final: APPROVED (iter #) | CHANGES REQUESTED
- Bugbot final: APPROVED (iter #) | CHANGES REQUESTED
- Bugbot finding lists all "None": yes | no
- Reviewer-a blocking lists "None" (Blocking / Non-blocking / blocking test/docs): yes | no
- Batchable (deferred): None | [punch list copied from Reviewer-a]
- Reviewer-a launches this phase (cumulative): N
- Bugbot launches this phase (cumulative): N
- Reviewer completion gate: review-loop
- Closeout: Full CI after dual APPROVED (no reviewers on Full)
- Subagent / reviewer Task ids (or transcript refs):

### Cleanup
- Disposable Na preview deleted: yes | n/a

### Blockers
- none | [list]
```

---

## Cap-exhausted handoff schema

When iteration 4 ends without dual APPROVED, Nb returns this instead of a closeout report. **No Full CI.**

```markdown
## Phase cap-exhausted handoff — Phase N of M

### Attestation
- Handoff UTC timestamp:
- git rev-parse HEAD at handoff:
- git diff --name-only at handoff (paste list):
- dual APPROVED: no
- Full CI: not run (cap handoff)

### Scope
- Files changed: [list]
- Phase N+1 touched: no (required)

### Review loop
- Pressure-release block: N
- Iterations this block: 4
- Reviewer A final: …
- Bugbot final: …
- Remaining Bugbot lists (Blocking / Non-blocking / Test gaps):
- Remaining Reviewer-a lists (Blocking / Non-blocking / blocking test/docs / Batchable deferred):
- In-spec must-fix: [list]
- Out-of-spec / process-only: [list]
- Reviewer-a launches this phase (cumulative): N
- Bugbot launches this phase (cumulative): N
- Subagent / reviewer Task ids (or transcript refs):

### Punch list for Composer triage
- [must-fix items]

### Blockers
- none | [list]
```

---

## Cap-exhausted triage (before ACCEPT)

On receiving a **cap-exhausted handoff** (not a dual-APPROVED closeout): **do not** run the dual-APPROVED QC ACCEPT path. Run transcript audit first (verify ≤4 iterations this block, no 5th pair, no Full-before-handoff), then choose exactly one:

1. **Renew** — relaunch/resume Nb with the in-spec must-fix list; reset review iteration to 1; ≤4 more iterations; same phase scope
2. **Focus-narrow** — same as Renew but reduced file/doc scope and Bugbot Custom Instructions = current-fix only (maps closed-roadmap “narrowed spec” / “change approach” when the fix is to shrink scope)
3. **Terminate** — escalate to user or replan; do not silent-continue; no ACCEPT (maps closed-roadmap “change approach” when stopping the loop)
4. **Waive** — only out-of-spec or process-only nits; write [Composer waiver attestation](#composer-waiver-attestation); **never** waive Fast/Full CI failures; then Composer Full (or user ack if `n/a`) → ACCEPT

**Waive is Composer-only.** Phase subagents and normal agents never waive.

### Composer waiver attestation

Record in the Composer thread and roadmap status note when conducting:

```markdown
## Composer waiver attestation — Phase N of M
- UTC:
- Phase id:
- Waived findings (quoted):
- Rationale (process / out-of-spec only):
- Fast CI (last Observed): pass | n/a
- Full CI: pass | n/a (+ user ack if n/a)
- Cap-handoff Task / transcript ids:
```

---

## Composer QC

QC has **two mandatory gates** on the **dual-APPROVED closeout** path — both must pass before ACCEPT.

### A. Report + attestation QC (closeout path)

Compare report to **attestation** `git diff --name-only` (not the live tree after roadmap edits).

**REJECT** if: missing attestation; not dual APPROVED / Bugbot lists ≠ `"None"` or Reviewer-a blocking lists ≠ `"None"` (Batchable (deferred) may be non-None — do not REJECT for that alone); Full not pass (unless blocked → ask user to stop lockers); reviewers launched with Full or after dual APPROVED without code changes; phase N+1 production paths in attestation (vs phase Agent context); required Na folder still present; subagent committed/pushed; empty docs-consulted section.

**Cap→Waive ACCEPT:** do **not** REJECT solely for missing dual APPROVED when a complete [Composer waiver attestation](#composer-waiver-attestation) is present and Full passes (or `n/a` + user ack). Still REJECT if Fast/Full failures were “waived,” or if waived items were clearly in-spec must-fix.

### B. Transcript audit (hard gate)

After Nb returns (and after any Na / migration Composer did for this phase), read transcripts and audit for **evidence in the transcript**, not self-attestation alone.

**On cap-exhausted handoff:** run this audit **before** triage.

**Required reads:**

| Who | What to read |
|-----|----------------|
| Phase Nb subagent | Full transcript for that Task (via agent id / agent-transcripts path from the launch) |
| Nested `reviewer-a` / Bugbot | Each nested reviewer’s transcript when IDs or transcript paths appear in the Nb transcript or Task results |
| Composer (self) | This thread’s own actions for Na preview and migration/external-apply drafts for this phase |

If a nested reviewer transcript cannot be located after a reasonable search, **REJECT** — do not ACCEPT on trust of the closeout claim alone. Missing Task ids in the closeout report alone is not automatic accept; Composer must still find and read transcripts.

**REJECT** (with a concrete gap list for `resume`) if any of:

- **Discovery / SOP skip:** no reads of discovery Step 0 / required repo docs / roadmap “Where to read context” before implementing
- **Review loop skip or compression:** missing Fast CI before reviewers; missing parallel `reviewer-a` + Bugbot; claimed APPROVED without matching reviewer output; must-fix findings left open on closeout path (Bugbot any list, or Reviewer-a Blocking / Non-blocking / blocking test/docs); do **not** treat Reviewer-a Batchable (deferred) as findings left open; iteration count doesn’t match launches/fixes
- **Pressure-release misuse:** 5th reviewer pair in a block; Full CI run on cap-exhausted handoff; self-renew past the block without Composer triage; Normal-agent-style Terminate used by Nb to claim phase complete
- **Gate misuse:** reviewers launched with Full CI; reviewers re-launched after dual APPROVED with no code changes; Full CI skipped or run before dual APPROVED on the closeout path
- **Shortcut closeout:** empty/fake docs-consulted; Na folder not deleted when required; `git commit` / `git push` by subagent
- **Scope leak:** work clearly outside this phase’s Agent context / into phase N+1
- **Composer self-audit fails:** Na built when not required, or skipped when required; migration draft/apply gate violated; Nb launched before user confirmation on gated steps
- **Nested reviewer audit fails:** reviewer did not actually review the phase changeset / rubber-stamped without reading changed files (when transcript shows that)

On REJECT: `resume` with gap list when possible; else fresh launch with Current state. Max 2 substantive QC rejections → escalate to user.

### ACCEPT

| Path | Condition |
|------|-----------|
| Dual closeout | Both QC gates pass → Full CI → auto local commit |
| Cap→Waive | Waiver attestation + transcript audit + Composer Full (or n/a ack) → auto local commit |
| Cap→Renew / Focus-narrow | No ACCEPT — relaunch |
| Cap→Terminate | No ACCEPT — user escalation |

Never push.

---

## Commit flow

1. Subagent: dual APPROVED then Full (or `n/a` path) **or** Cap→Waive after Composer Full
2. QC accept (report + transcript audit, or waiver path) → update roadmap
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
| Skip dual APPROVED (no waiver) | QC reject                     |
| Cap handoff treated as closeout ACCEPT | Triage first; Waive only with attestation |
| Nb self-renews past 4 iterations | Cap-exhausted handoff to Composer |
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
| Cap-exhausted handoff             | Audit → triage; do not dual-APPROVED REJECT reflex         |

---

## Related

**Skills:** [`roadmap`](../roadmap/SKILL.md), [`implementation-review`](../implementation-review/SKILL.md), [`implementation-plan`](../implementation-plan/SKILL.md), [`documentation-architecture`](../documentation-architecture/SKILL.md)

**Workflow docs:**

- [phased-multi-agent.md](../../workflow/phased-multi-agent.md)
- [plan-agent-context.md](../../workflow/plan-agent-context.md)
- [discovery.md](../../workflow/discovery.md)
- [iterative-code-review.md](../../workflow/iterative-code-review.md)
- [ci-ladder.md](../../workflow/ci-ladder.md)
- [review-subagent-models.md](../../overlays/cursor/review-subagent-models.md)
- [_index.md](../../workflow/_index.md) — index of all workflow docs
