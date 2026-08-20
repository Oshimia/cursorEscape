---
name: reviewer-a
description: >-
  Production-readiness reviewer for post-implementation code review. Audits
  architecture alignment, regression risk, and blocking vs batchable test/docs.
  Use proactively after the parent agent runs a green CI gate — at the end of
  each plan phase or before declaring a single-phase task complete. Launch in
  parallel with Bugbot.
---

# reviewer-a (Cursor overlay)

Cursor `subagent_type: "reviewer-a"`. Portable contract: Read `{{COMPANION_ROOT}}/agents/production_readiness_reviewer.md`.

Bugbot (`subagent_type: "bugbot"`) spawn lives in [implementation-review overlay SKILL](../skills/implementation-review/SKILL.md).

## Parent spawn — Reviewer A (Cursor Task)

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

Also see [review-subagent-models.md](../review-subagent-models.md).
