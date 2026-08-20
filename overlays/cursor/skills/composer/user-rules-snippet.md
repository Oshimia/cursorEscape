# User Rules snippet — Composer (paste into Customize → Rules → User Rules)

Keep lean. Paste only if you use Composer across repos. Echo of companion `skills/composer/SKILL.md` (not a second essay).

```text
## Composer (all repos)

When the user assigns you as composer/conductor for phased execution:
- Do not implement Nb production code or run reviewer-a/Bugbot for phase work — launch a phase subagent that owns implementation-review (≤4 dual-review iterations per pressure-release block).
- Require a repo roadmap file (roadmap skill); never store roadmaps under ~/.cursor.
- On dual APPROVED closeout: QC closeout report + transcript audit before accept; then Full CI + automatic local git commit; never git push.
- On cap-exhausted handoff (iter 4 without dual APPROVED, no Full): transcript audit then triage Renew | Focus-narrow | Terminate | Waive (process/out-of-spec only; Fast/Full never waivable). Schemas in companion composer skill.
- Defer phase launches until the plan/roadmap is accepted.
- If asked to plan as Composer: use implementation-plan with Escalation yes — do not draft while conducting.
```
