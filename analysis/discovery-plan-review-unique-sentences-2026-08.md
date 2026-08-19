# Discovery + plan-review — unique-sentence checklist (Phase 1)

**Last updated:** 2026-08-20  
**Compared:** Live OpenCode `~/.config/opencode/skills/{discovery,plan-review}/SKILL.md` vs repo `workflow/` + `skills/implementation-plan/SKILL.md` + `workflow/iterative-plan-review.md`. Imported archaeology: `research/imported/cursor-global-workflow/docs/workflow/discovery.md` (no separate live plan-review skill in Cursor import).

**Legend:** **Unique live** = sentence/portable rule in live OpenCode skill not already in repo workflow/implementation-plan before Phase 1. **Unique repo** = in repo workflow/implementation-plan but not in live OpenCode thin skill. **Merged** = portable unique live rule folded into repo SoT in Phase 1.

---

## discovery — unique live sentences (OpenCode SKILL vs repo before Phase 1)

| # | Unique live sentence / rule | Merged to SoT |
| - | --------------------------- | ------------- |
| 1 | Find the target repo's docs before edits. | Already in workflow tone; retained in thin skill |
| 2 | Step 0: If `.cursor/skills/reference-docs/SKILL.md` **(or host equivalent)** exists… | **Merged** — `workflow/discovery.md` Step 0 OpenCode host-equivalent |
| 3 | Record applicable paths for the plan and reviewers. | **Merged** — thin skill Steps |
| 4 | Note when the doc tree is sparse. | **Merged** — thin skill Steps |
| 5 | Must not: Invent required parallel documentation trees | **Merged** — `workflow/discovery.md` § Must not |
| 6 | Must not: Skip discovery on unfamiliar repos | **Merged** — `workflow/discovery.md` § Must not |
| 7 | Must not: Treat `docs/research/imported/` Observed paths as Target product homes | **Merged** — `workflow/discovery.md` § Must not (+ `research/imported/` wording) |
| 8 | Read when → host `docs/workflow/discovery.md` | Phase 2 overlay path transform (not Phase 1) |
| 9 | Related agents: `implementer` | Repo workflow listed planner/repository_explorer; implementer added in thin skill Related |

## discovery — unique repo sentences (workflow vs live OpenCode)

| # | Unique repo sentence / rule | Where |
| - | ----------------------------- | ----- |
| 1 | Never invent a **required** doc tree (opening line) | `workflow/discovery.md` |
| 2 | Workflow process block — read cursorEscape workflow docs when target repo has no process SOPs | `workflow/discovery.md` |
| 3 | Eval freeze Step 0 — **when evaluating freeze baselines**, follow packaged AITestSuite `reference-docs` skill | `workflow/discovery.md` Step 0 Eval freeze row |
| 4 | Repo root `workflow/` vs live Cursor `~/.cursor/docs/workflow/` copy-out note | `workflow/discovery.md` |
| 5 | Related skills table (implementation-plan, composer, roadmap, …) | `workflow/discovery.md` |

## plan-review — unique live sentences (OpenCode SKILL vs repo before Phase 1)

| # | Unique live sentence / rule | Merged to SoT |
| - | --------------------------- | ------------- |
| 1 | Gate drafted plans through `plan_reviewer` before implementation. | Thin skill title line |
| 2 | Skip only if: truly trivial, explicit user opt-out, or Composer phased **execution** | Already in `iterative-plan-review.md` skip list |
| 3 | Parent incomplete until APPROVED… (unless user opts out) | Already in `iterative-plan-review.md` |
| 4 | Do **not** paste a second full Incomplete until enum here — load skill `implementation-plan` | **Merged** — thin skill + `iterative-plan-review.md` pointer |
| 5 | Must not: Feed previous child transcripts into the next Task | **Merged** — `iterative-plan-review.md` § Must not |
| 6 | Must not: Duplicate the full Incomplete until section enum | **Merged** — thin skill Must not pointer |
| 7 | Read when → `plan-agent-context.md` (not Escalation when-table) | Thin skill Read when |

## plan-review — unique repo sentences (workflow/implementation-plan vs live OpenCode)

| # | Unique repo sentence / rule | Where |
| - | ----------------------------- | ----- |
| 1 | Does **not** require Escalation=yes — Escalation only controls Agent context scaffolding | `iterative-plan-review.md` |
| 2 | Every non-trivial plan must include Escalation field; Agent context when yes | `iterative-plan-review.md` |
| 3 | Lift repo SOP post-apply checklist into Incremental execution / Verification | `iterative-plan-review.md` workflow step 2 |
| 4 | Must not: Compress plan review when Composer assigned for phased execution | `iterative-plan-review.md` § Must not |
| 5 | After acceptance → phased-multi-agent + roadmap copy/restructure | `iterative-plan-review.md` |
| 6 | Full Incomplete until enum (sole SoT) | `skills/implementation-plan/SKILL.md` only |

## Portable Must-not merge summary (`workflow/discovery.md`)

| Rule | Source wording |
| ---- | -------------- |
| Invent required / parallel documentation trees | Live OpenCode discovery |
| Skip discovery on unfamiliar repos | Live OpenCode discovery |
| Treat Observed import paths as Target product homes | Live: `docs/research/imported/`; repo FA: `research/imported/` and `docs/research/imported/` (documentation-architecture Must not) |

## Portable Must-not merge summary (`iterative-plan-review.md`)

| Rule | Source |
| ---- | ------ |
| Feed previous child transcripts into the next Task | Live OpenCode plan-review (clean-context isolation) |

---

## Related

- [OpenCode overlays SoT roadmap Phase 1](../docs/roadmaps/opencode-overlays-sot.md)
- [workflow/discovery.md](../workflow/discovery.md)
- [workflow/iterative-plan-review.md](../workflow/iterative-plan-review.md)
