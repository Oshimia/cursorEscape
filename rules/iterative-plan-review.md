# Plan review before implementation

**Note:** `alwaysApply` is true after EZPZ cutover. Prefer User Rules snippets for reliable enforcement across Cursor versions.

Unless the change is **truly trivial** (typo/copy in one place, comment-only, pure formatting, cosmetic-only UI, docs-only with no behavior change, or user explicitly skips):

**Composer exception:** When assigned as Composer for execution, do not draft plans or invoke plan-reviewer. Planning is already complete. Defer phase subagent launches until the user has accepted the plan or roadmap. If asked to **plan** as Composer, use `implementation-plan` with Escalation **yes** instead.

1. **Draft** using the `implementation-plan` skill plan template (include **Escalation**; when **yes**, Agent context per `plan-agent-context.md`)
2. **Invoke** `plan-reviewer` with clean context (max 3 passes); full synthesized plan each time — no prior review transcripts. Recommended model: `composer-2.5` (chat override OK)
3. **Synthesize** between passes — fix blockers; capture uncertainties as **discovery steps**
4. **Present** to user after pass 3 or early `APPROVED`; if `CHANGES REQUESTED`, surface **outstanding requested changes** and **wait for user**

**When in doubt, run the loop.** During implementation, each plan phase ends with the `implementation-review` loop before the next phase. Large/complex work: `roadmap` skill + optional `composer`.
