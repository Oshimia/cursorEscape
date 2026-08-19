> **Imported research** — Source: live `~/.cursor`; copied 2026-08-17 into cursorEscape. Status: Observed/imported (Observed interim Cursor wording; companion repo is Target contract SoT). Do not treat as Target cursorEscape design unless a Target doc cites it.
# Iterative code review (Reviewer A + Bugbot)

**Skill:** [implementation-review](../../skills/implementation-review/SKILL.md). **Agents:** [reviewer-a](../../agents/reviewer-a.md) + Bugbot (built-in).

## When mandatory

Same bar as plan review — multi-file, large single-file, cross-layer, behavioral, new modules, migrations, each plan phase. **When in doubt, run it.**

**Composer exception:** When the user assigns [composer](../../skills/composer/SKILL.md), the **phase subagent** is the review-loop parent for Nb. Composer does QC (closeout report + transcript audit) + Full CI + local commit only.

## Per-phase rule

Do not batch phases. Finish dual `APPROVED` + Full closeout for phase N before phase N+1. Reset review iteration to 1 each phase.

## Workflow

```text
Implement → [Fast CI Observed → Reviewer A + Bugbot → fix must-fix]* → dual APPROVED (split bars) → Full CI (no reviewers) → done
```

1. Implement using [discovery.md](discovery.md)
2. Fast CI Observed (see [ci-ladder.md](ci-ladder.md)); do not launch on fail, skipped (when Fast ≠ n/a), or claimed-only; then launch both reviewers with `Completion gate: review-loop` and the locked Reviewer-a opener
3. Fix must-fix findings; repeat until dual `APPROVED`: Bugbot all lists `"None"`; Reviewer-a Blocking / Non-blocking (code/process) / blocking test/docs `"None"` — **Batchable (deferred)** may remain. Per leg: `count = completed+1`; if `count >= 9`, narrow before invoke (Bugbot Custom Instructions = current-fix; Reviewer-a = narrower task summary + applicable docs) — no hard stop; do not add Custom Instructions to Reviewer-a
4. Full CI only — do **not** re-launch reviewers after dual APPROVED unless code changed. Closeout attests per-leg launch counts and **Batchable (deferred)** punch list; dual APPROVED ≠ proven ship-class catch or proven no-escape
5. Report `task-phase-complete`

Recommended model: see [review-subagent-models.md](review-subagent-models.md).

## Related

- [discovery.md](discovery.md)
- [ci-ladder.md](ci-ladder.md)
- [review-subagent-models.md](review-subagent-models.md)
- [iterative-plan-review.md](iterative-plan-review.md)
- [phased-multi-agent.md](phased-multi-agent.md)
- [implementation-review](../../skills/implementation-review/SKILL.md)
- [composer](../../skills/composer/SKILL.md)
- [README.md](README.md)
