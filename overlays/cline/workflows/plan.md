# plan (Cline overlay)

Thin harness. Full procedure: Read `{{COMPANION_ROOT}}/workflow/discovery.md` then `{{COMPANION_ROOT}}/skills/implementation-plan/SKILL.md`.

## Steps

1. Read companion skill `{{COMPANION_ROOT}}/skills/implementation-plan/SKILL.md`.
2. Follow `{{COMPANION_ROOT}}/workflow/discovery.md` Step 0/fallback.
3. Draft the plan per the implementation-plan template; then start the plan-review loop (see below via the plan-review workflow).
4. For each plan-review pass, start a fresh Cline task/session for `plan_reviewer`; do not reuse the drafting conversation. Begin its payload with the canonical envelope at `{{COMPANION_ROOT}}/workflow/agent-invocation.md` (`plan_reviewer`; alias `plan_reviewer`; clean-context; read-only; `plan-review`). After `---`, explicitly pack absolute repository path, one-paragraph task summary, review pass, the full synthesized plan, and a prohibition on prior review transcripts. Return only that reviewer's result to the parent.

Companion reachability: `{{COMPANION_ROOT}}` resolves to the cursorEscape SoT checkout.
