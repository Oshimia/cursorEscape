> **Imported research** — Source: AITestSuite `tests\ez-pz-streaming-media-phase-4\baseline\referenceFiles\SOPs\iterative-plan-review.md`; copied 2026-08-17 into cursorEscape. Status: Observed/eval-packaging. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Iterative plan review

**Purpose:** Adversarial review of implementation plans before execution — bounded loop with user decision gate.

| Artifact | Role |
|----------|------|
| [.cursor/skills/implementation-plan/SKILL.md](../../.cursor/skills/implementation-plan/SKILL.md) | Draft comprehensive plans |
| [.cursor/agents/plan-reviewer.md](../../.cursor/agents/plan-reviewer.md) | Adversarial review subagent, launched with `model: composer-2.5` |
| [.cursor/rules/iterative-plan-review.mdc](../../.cursor/rules/iterative-plan-review.mdc) | Mandatory trigger for non-trivial plans |

---

## When review is mandatory

**When in doubt, run it.**

| Trigger | Examples |
|---------|----------|
| Multi-file work | 2+ source files (code, tests, migrations) |
| Cross-layer change | Frontend + backend, API + UI, DB + app |
| Behavioral change | Endpoints, auth/RBAC, state/bootstrap, embed paths |
| Database / migration | Schema, enum, RLS, grants |
| New patterns | Hooks, workflows, architecture others should follow |
| External dependencies | APIs, user migration steps, secrets, deploy |
| Ambiguous scope | Assumes behavior without citing code or docs |

## When it may be skipped

- Typo or copy fix in one place
- Comment-only or pure formatting
- Cosmetic-only UI (no behavior, data, or permissions)
- Documentation-only under `referenceFiles/`
- User explicitly instructs skip

If the plan touches tests, APIs, auth, migrations, shared utilities, or logic/state/fetch/handlers — **do not skip**.

---

## Workflow

```text
Draft → review → synthesize → review → synthesize → review (max 3) → present to user → user decides
```

1. Draft using the [implementation-plan skill](../../.cursor/skills/implementation-plan/SKILL.md).
2. Invoke **`plan-reviewer`** with `model: composer-2.5`, repository path, task summary, review pass (`N of 3`), and full synthesized plan (clean context — no prior review transcripts).
3. On `CHANGES REQUESTED`: fix blocking findings and unacknowledged verification gaps; add discovery steps; synthesize; re-invoke.
4. **Max 3 passes per autonomous loop.** After pass 3, always present final package to user — even if `CHANGES REQUESTED`.
5. If `CHANGES REQUESTED` at cap (or discovery steps need acknowledgment): surface **outstanding requested changes** prominently and **wait for user** before another loop or implementation.

## Subagent models

Set the Task `model` parameter to `composer-2.5` on every `plan-reviewer` launch:

| Review pass | `plan-reviewer` model |
|-------------|----------------------|
| 1 of 3 | `composer-2.5` |
| 2 of 3 | `composer-2.5` |
| 3 of 3 | `composer-2.5` |

If the user chooses **Continue planning** after the first three-pass loop, reset the next planning loop to pass 1 with `composer-2.5`. For the premium alternating GPT/Opus profile, see [review-loop-model-profiles.md](./review-loop-model-profiles.md).

### User decision options

- **Continue planning** — another review cycle
- **Revise manually** — user steers; agent re-drafts then may re-review
- **Accept as-is** — explicit override to implementation

### After plan acceptance

Implementation proceeds **phase by phase**. Each phase in **Incremental execution** ends with the full [iterative code review](./iterative-code-review.md) loop (Reviewer A + Bugbot) before the next phase starts — see [implementation-review skill](../../.cursor/skills/implementation-review/SKILL.md).

---

## Verdict policy

| Finding type | Action |
|--------------|--------|
| Blocking | Must fix before `APPROVED` |
| Unacknowledged verification gaps | Must fix or capture as discovery step before `APPROVED` |
| Discovery steps | Acceptable uncertainty — user acknowledges at presentation |
| Non-blocking | Report for user decision — may remain on `APPROVED` |

**`APPROVED`:** blocking findings = None; no unacknowledged verification gaps.

### Conditional A/B/C

**Required** for: architectural change, new subsystem, database design, shared abstraction, new integration.

**Optional** for: localized changes within existing patterns.

---

## Reviewer categories

Plan Reviewer audits: assumptions (with confidence), unknowns, external dependencies, verification areas, conditional A/B/C, **cost challenge**, **failure forecast**, incremental safety, architecture alignment.

**Output caps:** 5 blocking / 10 non-blocking findings, severity-ranked, with overflow themes noted when truncated.

---

## Related

- [Iterative code review (Reviewer A + Bugbot)](./iterative-code-review.md) — per-phase during execution; [implementation-review skill](../../.cursor/skills/implementation-review/SKILL.md), [reviewer-a agent](../../.cursor/agents/reviewer-a.md)
- [Review loop model profiles](./review-loop-model-profiles.md) — active Composer 2.5 profile, archived alternating profile, swap procedure
- [Reference documentation check](./reference-docs-check.md) — [reference-docs skill](../../.cursor/skills/reference-docs/SKILL.md)
- [Risk assessment for database changes](./risk-assessment-for-database-changes.md)
