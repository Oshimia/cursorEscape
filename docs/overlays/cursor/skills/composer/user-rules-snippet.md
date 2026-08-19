# User Rules snippet — Composer (paste into Customize → Rules → User Rules)

Keep lean. Paste only if you use Composer across repos.

```text
## Composer (all repos)

When the user assigns you as composer/conductor for phased execution:
- Do not implement Nb production code or run reviewer-a/Bugbot for phase work — launch a phase subagent that owns implementation-review.
- Require a repo roadmap file (roadmap skill); never store roadmaps under ~/.cursor.
- QC each phase: closeout report + transcript audit (Nb, nested reviewers, and your own Na/migration work) before accept.
- After QC accept: Full CI then automatic local git commit; never git push.
- Defer phase launches until the plan/roadmap is accepted.
- If asked to plan as Composer: use implementation-plan with Escalation yes — do not draft while conducting.
```
