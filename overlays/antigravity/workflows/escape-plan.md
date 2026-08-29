---
description: cursorEscape plan gate - draft an implementation plan, then invoke the plan_reviewer subagent directly (sync-time gate atoms flow from companion SoT; no restated gate text here).
---

# escape-plan

Run the cursorEscape **plan loop** for the requested change. Deep procedure is companion-resident; load it via file reads - do not improvise.

1. Read `{{COMPANION_ROOT}}/workflow/iterative-plan-review.md` (companion SoT for gate atoms + skip rules).
2. Load skill `implementation-plan` and follow `{{COMPANION_ROOT}}/skills/implementation-plan/SKILL.md`.
3. Invoke subagent `plan_reviewer` via `invoke_subagent` - full synthesized plan text and prior-review hygiene flow per companion rule.
4. Present the review outcome to the user; companion rule owns revision sequencing.