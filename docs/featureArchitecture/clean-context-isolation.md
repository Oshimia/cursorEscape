# Clean Context and Isolation

**Last updated:** 2026-08-20

## Context

This document is **Target** design for **isolated child handoffs** — how parents invoke reviewers and phase subagents without shared chat memory. It is distinct from [instruction-layering.md](./instruction-layering.md) (token/context *budget*) and from [intended-workflow.md](./intended-workflow.md) (loop *stages*). Isolation is about **honesty of each review pass**, not how thin always-on text is.

**Required** portable intent: plan_reviewer, production_readiness_reviewer, bug_reviewer, and Composer phase subagents run in isolated child context; the parent packs everything they need into the invoke message. Cursor Task / OpenCode Task child sessions are **Cursor-specific** / host mappings of that intent.

Observed overlay agents under [overlays/cursor/agents](../../overlays/cursor/agents/) illustrate the pattern (e.g. “You run in isolated context”). Live `~/.cursor` is the running install; the overlay is the in-repo **Observed** record (thin wrappers). This page is SoT for the portable isolation contract.

---

## Substance

### Why isolate

Shared parent chat history lets a child “remember” prior review transcripts, claimed CI, or pass conditions the parent never re-stated. That hides incomplete handoffs and makes re-reviews non-reproducible. Isolation forces the parent to **synthesize** (full plan text, current-fix task summary, Observed Fast CI block) and pass only what this pass needs.

### Who runs isolated (Required)

| Role / actor | Isolation |
| ------------ | --------- |
| [plan_reviewer](../../agents/plan_reviewer.md) | Child session; full synthesized plan each pass — **no** prior review transcripts |
| [production_readiness_reviewer](../../agents/production_readiness_reviewer.md) | Child session; locked opener; parent supplies Completion gate + CI Observed |
| [bug_reviewer](../../agents/bug_reviewer.md) | Child session; Custom Instructions envelope for scope |
| Composer phase subagent | Child implementer + review-loop parent for phase Nb ([composer](../../skills/composer/SKILL.md)) |

[repository_explorer](../../agents/repository_explorer.md) and optional [test_reviewer](../../agents/test_reviewer.md) should follow the same pack-everything-in-invoke pattern when launched as children.

### Parent duties (Required)

1. Launch the child with a **complete** invoke payload for that role (see agent contract Inputs).
2. On re-invoke: pass **synthesized** artifacts only — updated full plan, or narrower task summary + applicable docs — **not** the previous child’s transcript.
3. Own Fast CI Observed before dual-gate reviewers; do not ask reviewers to re-run CI.
4. After dual APPROVED, run Full CI **without** reviewers ([intended-workflow](./intended-workflow.md)).

### Split envelope (Required for dual gate)

| Leg | Parent shaping |
| --- | -------------- |
| production_readiness_reviewer | **Locked opener** — no Bugbot-style Custom Instructions field; re-scope via narrower task summary + applicable docs |
| bug_reviewer | **Custom Instructions** allowed — phase summary, iteration, launch count, regressions, out-of-scope |

### Completion gate vs closeout (Required)

| Mode | Reviewers | Meaning |
| ---- | --------- | ------- |
| `Completion gate: review-loop` | Yes (dual gate) | Mid-loop review after Fast CI Observed |
| Closeout | **No** | Full CI only after dual APPROVED; never pair Full with reviewer launch |

If the parent passes a closeout / Full / `task-phase-complete` gate to a dual-gate reviewer, the child should reject (CHANGES REQUESTED) — reviewers are not the closeout.

### Composer transcript audit (Required when using Composer)

Composer **QC** reads closeout reports and may audit child transcripts for process honesty (wrong actor committed, skipped gates). That audit stays on the **Composer parent**. It must **not** be used as “prior review memory” stuffed into the next plan_reviewer or dual-gate invoke. See [composer](../../skills/composer/SKILL.md) and [intended-workflow.md](./intended-workflow.md).

### Anti-patterns (Required non-goals)

| Anti-pattern | Why |
| ------------ | --- |
| Relying on shared chat history as review memory | Non-reproducible; hides missing Inputs |
| Attaching pass-1 review transcripts to pass-2 | Child should see synthesized plan / current-fix summary only |
| “You already saw the findings — just re-check” | Illegal override of clean context |
| Pairing Full CI with reviewer launch | Closeout ≠ review-loop |
| Feeding Composer transcript audit into the next reviewer Task | Confuses QC with invoke payload |

### Host mapping

| Portable idea | Cursor-specific | OpenCode (first attempt) |
| ------------- | --------------- | ------------------------ |
| Isolated child | Task / subagent clean context | Task / `@agent` child session |
| Pack invoke message | Parent Task prompt | Parent Task prompt |
| Deny reviewer edits | Host policy | `permission.edit: deny` on reviewer agents |

---

## Implications / open questions

1. Recreation hosts that share one long chat with “reviewer mode” without child isolation violate this contract even if dual-gate *roles* exist.
2. Target [plan_reviewer](../../agents/plan_reviewer.md) Inputs must not imply prior-transcript handoff — parent synthesizes into the plan text.
3. Isolation and instruction layering reinforce each other: lean agent bodies + packed invokes, not full procedure paste + chat memory.

---

## Related

- [Instruction layering](./instruction-layering.md) — budget; this page is isolation honesty
- [Intended workflow](./intended-workflow.md)
- [Desired behavior vs Cursor-specific](./desired-behavior-vs-cursor-specific.md)
- [Cursor behavior to reproduce](./cursor-behavior-to-reproduce.md)
- [Agent role contracts](../../agents/_index.md)
- [implementation-review](../../skills/implementation-review/SKILL.md)
- [iterative-plan-review](../../workflow/iterative-plan-review.md)
- [composer](../../skills/composer/SKILL.md)
- [Host recreation study](../../analysis/host-recreation-2026-08.md)
