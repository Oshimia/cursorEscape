---
description: cursorEscape plan gate — draft an implementation plan, then gate it with the plan_reviewer subagent (max 3 passes) before any implementation.
---

# escape-plan

Run the cursorEscape **plan loop** for the requested change. Deep procedure is companion-resident; load it via file reads — do not improvise.

1. Discovery first: read `{{COMPANION_ROOT}}/skills/discovery/SKILL.md`, then follow Step 0 / fallback in `{{COMPANION_ROOT}}/workflow/discovery.md`.
2. Load skill `implementation-plan` and follow `{{COMPANION_ROOT}}/skills/implementation-plan/SKILL.md`. The plan is incomplete until that skill's **Incomplete until** bar is met.
3. Invoke subagent `plan_reviewer` via `invoke_subagent` — clean context, full synthesized plan only, no prior review transcripts, max 3 passes. Fix emitted blockers between passes; re-invoke with the synthesized plan only.
4. Present after APPROVED or pass 3. Wait for the user when CHANGES REQUESTED at cap.
5. Default on unless the user explicitly opts out (`skip plan review` / `implement now`). Eval / harness / multi-step work is not exempt.
