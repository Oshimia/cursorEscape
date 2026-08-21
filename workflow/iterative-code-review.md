# Iterative code review (Reviewer A + Bugbot)

**Skill:** [implementation-review](../skills/implementation-review/SKILL.md). **Agents:** [production_readiness_reviewer](../agents/production_readiness_reviewer.md) + Bugbot (built-in).

## When mandatory

Same bar as plan review — multi-file, large single-file, cross-layer, behavioral, new modules, migrations, each plan phase. **When in doubt, run it.**

**Composer exception:** When the user assigns [composer](../skills/composer/SKILL.md), the **phase subagent** is the review-loop parent for Nb. After dual APPROVED, Composer does QC (closeout report + transcript audit) + Full CI + local commit only. After a 4-iteration block without dual APPROVED, the subagent returns a **cap-exhausted handoff** (no Full) for Composer triage (Renew | Focus-narrow | Terminate | Waive) — see composer skill. QC evidence rules (including Bugbot Task UI zero-findings when the nested transcript is empty/redacted) live in [composer Gate B](../skills/composer/SKILL.md#b-transcript-audit-hard-gate).

## Per-phase rule

Do not batch phases. Finish dual `APPROVED` + Full closeout for phase N before phase N+1. Reset review iteration to 1 each phase and after each pressure-release Renew / Focus-narrow.

## Workflow

```text
Implement
  → ≤4× (Fast CI Observed → Reviewer A + Bugbot → fix must-fix)
  → dual APPROVED → Full CI → done
  → else: normal reassessment (Renew | Focus-narrow | Terminate+user)
       or Composer Nb cap-exhausted handoff
```

1. Implement using [discovery.md](discovery.md)
2. Fast CI Observed (see [ci-ladder.md](ci-ladder.md)); do not launch on fail, skipped (when Fast ≠ n/a), or claimed-only; then launch both reviewers with `Completion gate: review-loop` and the locked Reviewer-a opener
3. Fix must-fix findings; at most **4** dual-review iterations per block. Do **not** launch a 5th pair. Dual `APPROVED` requires Bugbot all lists `"None"`; Reviewer-a Blocking / Non-blocking (code/process) / blocking test/docs `"None"` — **Batchable (deferred)** may remain. Track cumulative per-leg launch counts for the phase; reset **iteration** (not launch totals) after Renew / Focus-narrow. Full policy + **anti-abuse** (normal agents must not use the valve to skip in-spec must-fix): [implementation-review](../skills/implementation-review/SKILL.md)
4. After dual APPROVED: Full CI only — do **not** re-launch reviewers unless code changed. Closeout attests block number, cumulative launch counts, and **Batchable (deferred)** punch list; dual APPROVED ≠ proven ship-class catch or proven no-escape. Report `task-phase-complete` **only** after dual APPROVED + Full.
5. After iteration 4 **without** dual APPROVED: do **not** report `task-phase-complete`. Normal parent: written reassessment (Renew | Focus-narrow | Terminate+user with anti-abuse). Composer Nb: **cap-exhausted handoff** (no Full). See [implementation-review](../skills/implementation-review/SKILL.md) / [composer](../skills/composer/SKILL.md).

Recommended model: see [review-subagent-models.md](../overlays/cursor/review-subagent-models.md).

## Related

- [discovery.md](discovery.md)
- [ci-ladder.md](ci-ladder.md)
- [review-subagent-models.md](../overlays/cursor/review-subagent-models.md)
- [iterative-plan-review.md](iterative-plan-review.md)
- [phased-multi-agent.md](phased-multi-agent.md)
- [implementation-review](../skills/implementation-review/SKILL.md)
- [composer](../skills/composer/SKILL.md)
- [_index.md](_index.md)
- [Code-review evidence frame](code-review-frame.md) (optional Standards/Spec framing)
