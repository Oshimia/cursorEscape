> **Imported research** — Source: AITestSuite `tests\ez-pz-streaming-media-phase-4\baseline\referenceFiles\SOPs\iterative-code-review.md`; copied 2026-08-17 into cursorEscape. Status: Observed/eval-packaging. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Iterative code review (Reviewer A + Bugbot)

**Purpose:** Catch incomplete first passes, regressions, test gaps, and architecture drift before a phase or task is declared done. Run **per phase** on multi-phase plans so review batches stay small. Modeled on the Phase 6 page-load optimization review cycles.

| Artifact | Role |
|----------|------|
| [.cursor/skills/implementation-review/SKILL.md](../../.cursor/skills/implementation-review/SKILL.md) | Parent workflow — CI gate, loop orchestration, invocation blocks |
| [.cursor/agents/reviewer-a.md](../../.cursor/agents/reviewer-a.md) | Production-readiness review subagent, launched with `model: composer-2.5` |
| [.cursor/rules/iterative-code-review.mdc](../../.cursor/rules/iterative-code-review.mdc) | Mandatory trigger for non-trivial implementation work |

---

## When this process is mandatory

Run the full review loop **by default** for any non-trivial change. **When in doubt, run it.**

| Trigger | Examples |
|---------|----------|
| **Multi-file work** | Same task touches 2+ source files (code, tests, or migrations) |
| **Large or significant single file** | Substantial refactor or authoring of a route page, client shell, server action module, route handler, editor component, or shared hook/context |
| **Cross-layer change** | Frontend + backend, SSR + client, API + UI, DB + app code |
| **Behavioral change** | New endpoint, changed auth/RBAC, state/bootstrap flow, prefetch/dedup, embed path |
| **New modules** | New helpers imported from multiple places — high risk of incomplete changeset |
| **Architecture / SOP touch** | New pattern, hook, workflow, or doc that other code should follow |
| **Database / migration** | Schema, enum, RLS, grants SQL under `referenceFiles/supabase/sql/migrations/` |
| **Each plan phase** | Every bounded unit in a plan’s **Incremental execution** section — see [Per-phase review](#per-phase-review) |

## When it may be skipped

Only for **truly trivial** changes with **no behavioral risk** (same bar as the always-applied rule):

- Typo or copy fix in one place
- Comment-only edit
- Pure formatting with zero logic change
- **Cosmetic-only UI changes** — styling, spacing, typography, colors, or non-functional layout polish that does **not** change application behavior, user flows, data handling, loading/error states, permissions, or interactive semantics (including `aria-*` on controls). May span multiple files if every edit is presentational only.
- Documentation-only edit under `referenceFiles/` with no code change
- User explicitly instructs skip for a trivial fix

If the change touches tests, APIs, auth, migrations, shared utilities, or any logic/state/fetch/handlers — **do not skip**, even if the diff looks visual or small.

---

## Per-phase review

When executing an approved [implementation plan](../../.cursor/skills/implementation-plan/SKILL.md):

| Concept | Definition |
|---------|------------|
| **Phase** | One bounded, independently shippable step from the plan’s **Incremental execution** section |
| **Phase boundary** | End of that step — CI + Reviewer A + Bugbot run **before** the next phase starts |
| **Single-phase work** | Ad-hoc task or plan with one execution step — one review loop at completion (same bar) |

```text
Plan accepted → Phase 1 implement → review loop → dual APPROVED
             → Phase 2 implement → review loop → dual APPROVED
             → … → final phase APPROVED → task complete
```

**Rules:**

1. **Do not batch phases** — finish the review loop for phase N before implementing phase N+1.
2. **Scope reviewers to the current phase** — task summary names phase **N of M**, what this phase delivers, and which prior phases are already approved. Reviewers audit this phase’s changeset; they still flag regressions against earlier approved work.
3. **Reset review iteration per phase** — the first review iteration for every phase (and every single-phase task) starts at iteration 1.
4. **Optional cross-phase verification** — if the plan’s **Verification** section defines an integration or smoke pass across phases, treat it as its own phase or explicit final checklist; do not skip per-phase loops in favor of one end-of-plan review.
5. **Migration ordering** — schema/migration phases still require this loop before dependent code phases (see [supabase-migrations](./supabase-migrations.md)).

Planning review ([iterative plan review](./iterative-plan-review.md)) happens **before** implementation; this loop runs **during** implementation at each phase boundary.

---

## Workflow

Do **not** declare a phase or task complete after the first green CI run.

```text
Implement phase → CI gate (parent, once) → Reviewer A + Bugbot (parallel) → fix every finding → CI gate (parent, once) → re-review → … → both APPROVED → changeset check → [next phase or task complete]
```

1. **Implement** the current phase (or full scope if single-phase) using documented SOPs and architecture (see [reference-docs skill](../../.cursor/skills/reference-docs/SKILL.md) and [reference-docs-check SOP](./reference-docs-check.md)).
2. **Run CI gate** — parent only, once per review iteration, all four commands green (see [implementation-review skill](../../.cursor/skills/implementation-review/SKILL.md#ci-gate)). Do not launch reviewers if CI fails.
3. **Launch Reviewer A and Bugbot in parallel** — via [`reviewer-a`](../../.cursor/agents/reviewer-a.md) and Bugbot subagents, both with `model: composer-2.5` (see [implementation-review skill](../../.cursor/skills/implementation-review/SKILL.md)). Full prompts each round; do not abbreviate. Include phase **N of M** and review iteration **N** when executing a multi-phase plan.
4. If **either** reviewer returns `CHANGES REQUESTED`: fix **every** blocking finding, **every** non-blocking finding, and **every** test gap; re-run CI once; return to step 3 with the **full** prompts.
5. Repeat until **both** return `APPROVED` with Blocking, Non-blocking, and Test gaps all literally `"None"`.
6. Confirm complete changeset and doc updates for **this phase**. **No extra CI run** after dual `APPROVED` — the gate before the approving iteration is sufficient.
7. **Multi-phase plans only:** proceed to the next phase from step 1. **Single-phase:** task complete.

**Completion bar:** Passing CI alone is **not** sufficient. Both reviewers must approve with no open findings. On multi-phase plans, **every** phase must reach this bar — not only the final phase.

---

## Subagent models

Track the review iteration within the current phase or single-phase task. Set the Task `model` parameter to `composer-2.5` on both subagents for every iteration.

| Review iteration | Reviewer A model | Bugbot model |
|------------------|------------------|--------------|
| 1, 2, 3, … | `composer-2.5` | `composer-2.5` |

For each new phase, reset the review iteration to 1. There is no pass cap; continue re-review cycles until both reviewers approve. For the premium alternating GPT/Opus profile, see [review-loop-model-profiles.md](./review-loop-model-profiles.md).

---

## CI gate

Parent runs the gate **once per review iteration** immediately before launching reviewers. Commands: [implementation-review skill — CI gate](../../.cursor/skills/implementation-review/SKILL.md#ci-gate). For backend lint/test, rely on `backend/.env.local` (loaded by `config.js`); **do not** inline env vars in shell commands.

---

## Verdict policy

| Finding type | Action |
|--------------|--------|
| Blocking | Must fix before next review |
| Non-blocking | Must fix — reviewers cannot approve with open items |
| Test gaps | Must add or extend tests — reviewers cannot approve with open items |

Do not close the phase or task or tell the user the work is “done” while any finding remains open.

---

## Related

- [Iterative plan review](./iterative-plan-review.md) — [implementation-plan skill](../../.cursor/skills/implementation-plan/SKILL.md), [plan-reviewer agent](../../.cursor/agents/plan-reviewer.md)
- [Review loop model profiles](./review-loop-model-profiles.md) — active Composer 2.5 profile, archived alternating profile, swap procedure
- [Unit Testing Policy](./unit-testing-policy.md)
- [Testing strategy](../featureArchitecture/testing-strategy.md)
- Phase 6 example: load optimization review cycles in [page-load-optimization.md](../featureArchitecture/page-load-optimization.md)
- [Reference documentation check](./reference-docs-check.md) — [reference-docs skill](../../.cursor/skills/reference-docs/SKILL.md)
