# implementation-review

**Last updated:** 2026-08-17

## Context

**Target** skill contract. Closeout review loop after non-trivial implementation. Full skill: [live import](../research/imported/cursor-global-workflow/skills/implementation-review/SKILL.md). Freeze eval packaging differs — cite [workflow-source-delta](../research/imported/workflow-source-delta.md).

---

## Substance

### When to use (Required)

End of each plan phase or any non-trivial single-phase task — **when in doubt, run it.**

### Workflow steps

```text
Implement → [Fast CI Observed → production_readiness_reviewer ∥ bug_reviewer → fix must-fix]* 
  → dual APPROVED → Full CI (no reviewers) → changeset check → complete
```

1. Run **Fast CI Observed** — per-command rows; no fail/skip/claimed-only when Fast ≠ `n/a`
2. Launch **both** reviewers in parallel — `Completion gate: review-loop`
3. Fix **all** must-fix findings; re-launch **both** legs
4. Stop reviewers after dual APPROVED (Batchable deferred OK on production_readiness leg)
5. Run **Full CI** only — never with reviewers; when Full = `n/a`, complete after dual APPROVED + explicit user acknowledgment before commit (**Composer exception:** subagent returns after dual APPROVED only; user ack is Composer's commit gate — see [composer](./composer.md))

### Outputs

- Dual APPROVED attestation (per-leg launch counts)
- Full CI result or documented `n/a` path (user ack at implementer when solo; at Composer when conducting)
- Closeout report for Composer QC when applicable

### Verdict bars (Required)

| Reviewer | APPROVED requires |
| -------- | ----------------- |
| bug_reviewer | Blocking, Non-blocking, Test gaps = `"None"` |
| production_readiness_reviewer | Blocking, Non-blocking, blocking test/docs = `"None"`; Batchable deferred may remain |

### Composer exception (Cursor-specific)

When Composer conducts the phase:

- Phase subagent runs this review loop through dual APPROVED
- Run **first** Full CI when Full ≠ `n/a`; when Full = `n/a`, return closeout after dual APPROVED only
- **Do not** commit — Composer runs second Full CI (or user ack when Full = `n/a`) after QC ([composer](./composer.md))

### Must not

- Launch reviewers on failed/skipped/claimed-only Fast CI
- Pair Full CI with reviewers
- Treat dual APPROVED as proven no-escape
- Skip loop across multiple plan phases
- Commit when Composer conducts (hand off closeout report instead)

### Related roles

[implementer](../agents/implementer.md), [production_readiness_reviewer](../agents/production_readiness_reviewer.md), [bug_reviewer](../agents/bug_reviewer.md)

---

## Implications / open questions

1. Per-leg launch count ≥ 9: narrow scope before invoke — no hard stop (live only).

---

## Related

- [implementation-plan](./implementation-plan.md)
- [composer](./composer.md)
- [pre-commit-ci-gate](./pre-commit-ci-gate.md)
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
- [ci-ladder](../research/imported/cursor-global-workflow/docs/workflow/ci-ladder.md)
