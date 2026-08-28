# Plan review before implementation

**Default on** unless truly trivial or the user **explicitly** opts out.

**When in doubt, run the plan loop.**

Eval / harness / multi-step operational work is **not** exempt.

1. Load skill `implementation-plan` (Escalation *when* SoT is that skill; when Escalation=yes, read `{{COMPANION_ROOT}}/workflow/plan-agent-context.md` for specimen headings only). Plan is incomplete until that skill's **Incomplete until** section bar is met — load `implementation-plan` for the list; do not invent always-on line budgets.
2. Invoke the host's `plan_reviewer` (max 3 passes), **clean context**, full synthesized plan only — no prior review transcripts. Runs for every drafted plan regardless of Escalation yes/no. APPROVED requires Incomplete until compliance (missing-Inputs urgency).
3. Present after APPROVED or pass 3; wait for user if CHANGES REQUESTED.

**Skip only if:** truly trivial one-place typo/copy, comment-only, formatting, cosmetic-only UI, docs-only with no behavior change, **or** explicit user opt-out (`skip plan review`, `skip planning`, `implement now`, `no plan gate`) — not inferred urgency.

**When in doubt, run the loop.**

---

## Related

- [Iterative code review](./iterative-code-review.md)
- [CI ladder](../workflow/ci-ladder.md)
- [Instruction layering (FA)](../docs/featureArchitecture/instruction-layering.md)
