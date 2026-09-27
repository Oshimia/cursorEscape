# User Rules snippet — Plan review (paste into Customize → Rules → User Rules)

Keep lean.

```text
## Plan review (all repos)

For non-trivial plans (multi-file, cross-layer, behavioral, DB/migration, new patterns, external deps, ambiguous scope):
1. Draft with the implementation-plan skill template (include Escalation; when yes, Agent context per plan-agent-context.md).
2. Save the gated plan at .scratch/plans/<plan-id>.md, edit it in place across passes, and invoke plan-reviewer (max 3 passes), clean context, with the plan artifact's absolute path only. The child prompt must begin exactly with the canonical envelope from workflow/agent-invocation.md; host alias never replaces canonical identity. Recommended model: composer-2.5.
3. Present after APPROVED or pass 3; wait for user if CHANGES REQUESTED.

Skip only for truly trivial one-place typo/copy, comment-only, formatting, cosmetic-only UI, docs-only with no behavior change, or explicit user skip.
```
