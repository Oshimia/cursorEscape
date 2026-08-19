# User Rules snippet — Plan review (paste into Customize → Rules → User Rules)

Keep lean.

```text
## Plan review (all repos)

For non-trivial plans (multi-file, cross-layer, behavioral, DB/migration, new patterns, external deps, ambiguous scope):
1. Draft with the implementation-plan skill template (include Escalation; when yes, Agent context per plan-agent-context.md).
2. Invoke plan-reviewer (max 3 passes), clean context, full synthesized plan only. Recommended model: composer-2.5.
3. Present after APPROVED or pass 3; wait for user if CHANGES REQUESTED.

Skip only for truly trivial one-place typo/copy, comment-only, formatting, cosmetic-only UI, docs-only with no behavior change, or explicit user skip.
```
