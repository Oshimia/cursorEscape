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

# Implementation review (Cursor overlay)

Thin harness. Full procedure: Read `{{COMPANION_ROOT}}/skills/implementation-review/SKILL.md`.

**Read when reviewing:**

| Doc | When |
|-----|------|
| [SKILL.md]({{COMPANION_ROOT}}/skills/implementation-review/SKILL.md) | Full review-loop procedure |
| [discovery.md]({{COMPANION_ROOT}}/workflow/discovery.md) | Find repo docs before judging architecture |
| [iterative-code-review.md]({{COMPANION_ROOT}}/workflow/iterative-code-review.md) | Loop rules, per-phase boundaries, Composer carve-out |
| [ci-ladder.md]({{COMPANION_ROOT}}/workflow/ci-ladder.md) | Fast/Full CI mapping |
| [review-subagent-models.md](../../review-subagent-models.md) | Recommended reviewer models (overlay leaf) |
| [code-review-frame.md]({{COMPANION_ROOT}}/workflow/code-review-frame.md) | Optional Standards/Spec evidence frame |
| [_index.md]({{COMPANION_ROOT}}/workflow/_index.md) | Index of all workflow docs |

**Companion reachability:** `{{COMPANION_ROOT}}` resolves to the cursorEscape SoT checkout — required when workspace ≠ cursorEscape. Copy-out fallback (transitional mirror only): `C:/Users/admin/.cursor/docs/workflow/`.

---

## Invoke reviewer-a (Cursor Task)

Routing metadata (not part of the child payload): launch `reviewer-a` with `subagent_type: "reviewer-a"`, recommended `model: composer-2.5`, `readonly: true`, and `run_in_background: false`.

Child prompt (paste exactly; begins here):

```text
You are the `production_readiness_reviewer` agent.
Read `{{COMPANION_ROOT}}/agents/production_readiness_reviewer.md` before acting.
Required reading:
- `{{COMPANION_ROOT}}/agents/production_readiness_reviewer.md`
- Applicable docs supplied below and references the contract requires

Host alias: reviewer-a
Isolation: clean-context
Authority: read-only
Loop/gate: review-loop

---

Repository path: <absolute path>
Task summary: <one paragraph — what this phase or change set is supposed to accomplish; when parent declares Focus-narrow for this pressure-release block, narrow task summary + applicable docs to the current fix — never override Completion gate, CI Observed, or verdict bar>
Plan phase: <N of M | single-phase — omit line if ad-hoc with no plan>
Review iteration: <N — 1–4 within current pressure-release block; reset to 1 at phase start and after Renew/Focus-narrow>
Reviewer-a launches this phase: <count = completed+1 including this launch — cumulative for the phase>
Bugbot launches this phase: <count = completed+1 including this launch — compute both before parallel invoke>
Completion gate: review-loop
Review model: <model slug used for this reviewer-a launch>
Prior approved phases: <list or "none" — multi-phase only>
Applicable docs: <docs for touched areas, if known; when parent declares Focus-narrow for this block, narrow to docs/files for the current fix>
Fixed point (optional): <commit/tag/branch; enables Standards/Spec axis framing only when Spec path is also supplied>
Spec path (optional): <path to approved spec/plan; required together with Fixed point to activate framing>

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

## Invoke Bugbot (Cursor Task)

Launch exactly one Bugbot subagent (`subagent_type: "bugbot"`, recommended `model: composer-2.5`, `readonly: true`, `run_in_background: false`). **Do not ask Bugbot to run CI** — the parent runs the gate once per iteration before parallel launch.

Routing metadata (not part of the child payload): launch Bugbot with `subagent_type: "bugbot"`, recommended `model: composer-2.5`, `readonly: true`, and `run_in_background: false`.

Child prompt (paste exactly; begins here):

```text
You are the `bug_reviewer` agent.
Read `{{COMPANION_ROOT}}/agents/bug_reviewer.md` before acting.
Required reading:
- `{{COMPANION_ROOT}}/agents/bug_reviewer.md`
- `{{COMPANION_ROOT}}/docs/featureArchitecture/bug-reviewer-finding-rubric.md`
- `{{COMPANION_ROOT}}/skills/bug-review-sweep/SKILL.md`

Host alias: bugbot
Isolation: clean-context
Authority: read-only
Loop/gate: review-loop

---

Full Repository Path: <absolute repo path>
Diff: branch changes | uncommitted changes
Custom Instructions: <task-specific — regressions, security surfaces, incomplete changeset, scope boundaries; when parent declares Focus-narrow for this pressure-release block, narrow to current-fix only>
Review iteration: <N — 1-4 within current pressure-release block>
Bugbot launches this phase: <count including this launch>
Attestation marker: <parent-generated marker>

Echo the attestation marker verbatim.
```

**Custom Instructions** must also specify:

- What this **phase** (or change set) is supposed to do; plan phase **N of M** when applicable
- Review iteration **N**; `Bugbot launches this phase: <count including this launch>`
- Regressions to flag (auth bypass, data leaks, incomplete changeset, regressions against prior approved phases)
- Out-of-scope items reviewers must not block on (if any)
- Requirement for complete changeset for **this phase** (no imports to missing/untracked files)
- Note that CI already passed (parent-verified); do not re-run lint/test
- Optionally, Fixed point and Spec path when axis framing is requested (both required together; omit entirely otherwise)

Bugbot must use its own verdict bar: `APPROVED` only when Blocking, Non-blocking, and Test gaps are all `"None"`. Reviewer-a uses the **split** bar (blocking test/docs must be `"None"`; **Batchable (deferred)** may remain). Do **not** treat the two reviewers as sharing one unified all-lists-`"None"` bar.
