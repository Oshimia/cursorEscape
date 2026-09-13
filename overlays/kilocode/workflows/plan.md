# plan (Kilocode overlay)

---
description: Draft a plan per the cursorEscape loop (discovery → implementation-plan → plan-review gate)
---

Read companion: `{{COMPANION_ROOT}}/skills/implementation-plan/SKILL.md`, then `{{COMPANION_ROOT}}/workflow/discovery.md` (Step 0/fallback), then draft per the template. Plan is incomplete until `implementation-plan`'s **Incomplete until** bar is met.

**planner route (fresh task/session fallback):** Kilo subagent behavior is unattested for this role — claim no native `planner` subagent. Start a fresh Kilo task/session for each planning pass; never reuse the requesting conversation or a prior planning task. Begin the `planner` payload with the canonical envelope at `{{COMPANION_ROOT}}/workflow/agent-invocation.md` (`planner`; alias `none`; clean-context; read-only; `planning`), first-read `{{COMPANION_ROOT}}/agents/planner.md`, and required reading `workflow/agent-invocation.md`, `agents/planner.md`, `skills/implementation-plan/SKILL.md`; after `---`, explicitly pack absolute repository path, one-paragraph task summary, applicable docs, constraints, and the optional Escalation hint. A missing, malformed, contradictory, or unreadable envelope fails loudly as a planning failure naming the element; do not draft and do not infer identity from host routing. A reused conversation, an empty response, or a routing placeholder is **not** a valid planner result — treat it as a planning failure and start another fresh task; never reconstruct the plan from surrounding chat.

After drafting, start a fresh Kilo task/session for the plan-review pass (`{{COMPANION_ROOT}}/workflow/iterative-plan-review.md`) unless attested `subtask` isolation is available. Begin the `plan_reviewer` payload with the canonical envelope at `{{COMPANION_ROOT}}/workflow/agent-invocation.md`; after `---`, explicitly pack absolute repository path, one-paragraph task summary, review pass, the full synthesized plan, and a prohibition on prior review transcripts.
