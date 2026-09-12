# Iterative code review (Reviewer A + Bugbot)

**Skill:** [implementation-review](../skills/implementation-review/SKILL.md). **Agents:** [production_readiness_reviewer](../agents/production_readiness_reviewer.md) + Bugbot (built-in).

## When mandatory

Same bar as plan review — multi-file, large single-file, cross-layer, behavioral, new modules, migrations, each plan phase. **When in doubt, run it.**

**Composer exception:** When the user assigns [composer](../skills/composer/SKILL.md), the **phase subagent** is the review-loop parent. After dual APPROVED, Composer does QC (closeout report + transcript audit) + Full CI + local commit only. After a 4-iteration block without dual APPROVED, the subagent returns a **cap-exhausted handoff** (no Full) for Composer triage (Renew | Focus-narrow | Terminate | Waive) — see composer skill. QC evidence rules (including Bugbot Task UI zero-findings when the nested transcript is empty/redacted) live in [composer Gate B](../skills/composer/SKILL.md#b-transcript-audit-hard-gate).

## Per-phase rule

Do not batch phases. Finish dual `APPROVED` + Full closeout for phase N before phase N+1. Reset review iteration to 1 each phase and after each pressure-release Renew / Focus-narrow.

## Integrated review gate (conditional)

This is a **final cross-slice gate**, not a second always-on review loop. A single cohesive phase whose ordinary dual review covers its whole declared diff already satisfies integration review. Do not add a duplicate gate for it.

Run the integrated gate **before phase closeout** when previously reviewed or independently scoped work is assembled into one phase diff, especially when:

- two or more reviewed slices or recovered scopes are combined;
- an already-closed phase is reopened and its correction diff must compose with retained work;
- shared contracts, registries, schemas, validators, CI orchestrators, status/index docs, baselines, or generated projections are touched;
- separately reviewed parts meet at a cross-layer or cross-module seam;
- or the assembled work contains more than the normal single-slice boundary.

The gate does **not** rescue oversized new work. If the changeset is beyond the plan split bar before review, stop and split it. The integrated gate is for assessing bounded, already-reviewed pieces as one assembled diff.

Integrated-gate rules:

1. The review-loop parent records the true pre-assembly baseline and every included/excluded path.
2. After observed Fast CI, launch one fresh `production_readiness_reviewer` + `bug_reviewer` pair with `Completion gate: integrated-review`.
3. Review the integrated diff against that baseline, the named cross-slice invariants, direct callers/callees, status truth, and configuration/contract compatibility. Findings must identify a concrete defect in the assembled changeset; broad repository sweeps, prior transcripts, pre-existing issues, and unrelated improvements are out of scope.
4. If the first pair requests changes, fix only must-fix findings, rerun observed Fast CI, and launch one replacement integrated pair. If that replacement also requests changes, stop with `INTEGRATION REVIEW EXHAUSTED`; do not launch a third pair, run Full CI, or report phase complete without Composer/owner triage.
5. Same dual bar applies: `bug_reviewer` CLEAN and production readiness without Blocking, Non-blocking code/process, or blocking test/docs findings. Batchable deferred findings may remain.
6. If the owner predeclares a Composer-only status/index correction after approval, apply only that correction, rerun observed Fast and commit-grade Full CI, then follow the pre-commit gate. Do not relaunch reviewers for that predeclared docs-only correction.

## Workflow

```text
Implement
  → ≤4× (Fast CI Observed → Reviewer A + Bugbot → fix must-fix)
  → dual APPROVED → Full CI → done
  → else: normal reassessment (Renew | Focus-narrow | Terminate+user)
       or Composer phase implementation subagent cap-exhausted handoff
```

1. Implement using [discovery.md](discovery.md)
2. Fast CI Observed (see [ci-ladder.md](ci-ladder.md)); do not launch on fail, skipped (when Fast ≠ n/a), or claimed-only; then launch both reviewers with the canonical [agent invocation](agent-invocation.md) envelope, `Completion gate: review-loop` for the ordinary loop, and the locked Reviewer-a opener
3. Fix must-fix findings; at most **4** dual-review iterations per block. Do **not** launch a 5th pair. Dual `APPROVED` requires Bugbot to return CLEAN/no findings; Reviewer-a Blocking / Non-blocking (code/process) / blocking test/docs `"None"` — **Batchable (deferred)** may remain. Track cumulative per-leg launch counts for the phase; reset **iteration** (not launch totals) after Renew / Focus-narrow. Full policy + **anti-abuse** (normal agents must not use the valve to skip in-spec must-fix): [implementation-review](../skills/implementation-review/SKILL.md)
4. After dual APPROVED: Full CI only — do **not** re-launch reviewers unless code changed. Closeout attests block number, cumulative launch counts, integrated-gate outcome, and **Batchable (deferred)** punch list; dual APPROVED ≠ proven ship-class catch or proven no-escape. Report `task-phase-complete` **only** after dual APPROVED + Full.
5. After iteration 4 **without** dual APPROVED: do **not** report `task-phase-complete`. Normal parent: written reassessment (Renew | Focus-narrow | Terminate+user with anti-abuse). Composer phase implementation subagent: **cap-exhausted handoff** (no Full). See [implementation-review](../skills/implementation-review/SKILL.md) / [composer](../skills/composer/SKILL.md).

When the [integrated review gate](#integrated-review-gate-conditional) triggers, it runs after slice reviews and before phase closeout; it does not waive the ordinary per-phase loop. Report its per-leg launches separately from ordinary pressure-release iterations.

Recommended model: see [review-subagent-models.md](../overlays/cursor/review-subagent-models.md).

## Related

- [discovery.md](discovery.md)
- [agent-invocation.md](agent-invocation.md)
- [ci-ladder.md](ci-ladder.md)
- [review-subagent-models.md](../overlays/cursor/review-subagent-models.md)
- [iterative-plan-review.md](iterative-plan-review.md)
- [phased-multi-agent.md](phased-multi-agent.md)
- [implementation-review](../skills/implementation-review/SKILL.md)
- [composer](../skills/composer/SKILL.md)
- [_index.md](_index.md)
- [Code-review evidence frame](code-review-frame.md) (optional Standards/Spec framing)
