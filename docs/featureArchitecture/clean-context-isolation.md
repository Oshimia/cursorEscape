# Clean Context and Isolation

**Last updated:** 2026-09-16

## Context

This document is **Target** design for **isolated child handoffs** — how parents invoke reviewers and phase subagents without shared chat memory. It is distinct from [instruction-layering.md](./instruction-layering.md) (token/context *budget*) and from [intended-workflow.md](./intended-workflow.md) (loop *stages*). Isolation is about **honesty of each review pass**, not how thin always-on text is.

**Required** portable intent: every governed child launched under [agent invocation](../../workflow/agent-invocation.md)—including `planner`, `ad_hoc_child`, `repository_explorer`, and `test_reviewer`—runs in isolated child context; the parent packs everything it needs into the invocation. Host child sessions, fresh task/session replacements, and managed-agent routes are host mappings of that intent; they never relax the packed-payload or no-prior-transcript requirements.

**Registry context:** the [procedure registry](./procedure-registry.md) owns the machine metadata (identity, aliases, required reading, authority/isolation, loop/gate, host representation) that every governed child's invocation envelope references; host projections and fallback routes are derived deterministically from registry composition entries.

Observed overlay agents under [overlays/cursor/agents](../../overlays/cursor/agents/) illustrate the pattern (e.g. “You run in isolated context”). Live `~/.cursor` is the running install; the overlay is the in-repo **Observed** record (thin wrappers). This page is SoT for the portable isolation contract.

---

## Substance

### Why isolate

Shared parent chat history lets a child “remember” prior review transcripts, claimed CI, or pass conditions the parent never re-stated. That hides incomplete handoffs and makes re-reviews non-reproducible. Isolation forces the parent to **synthesize** (full plan text, current-fix task summary, Observed Fast CI block) and pass only what this pass needs.

### Who runs isolated (Required)

All governed child agents use clean context. Role-specific requirements add to, and never relax, this baseline:

| Role / actor | Isolation requirements |
| ------------ | ---------------------- |
| [planner](../../agents/planner.md) | Child session; parent supplies task summary, applicable docs, and constraints |
| [plan_reviewer](../../agents/plan_reviewer.md) | Child session; full synthesized plan each pass — **no** prior review transcripts |
| [production_readiness_reviewer](../../agents/production_readiness_reviewer.md) | Child session; locked opener; parent supplies Completion gate + CI Observed |
| [bug_reviewer](../../agents/bug_reviewer.md) | Child session; Custom Instructions envelope for scope |
| [repository_explorer](../../agents/repository_explorer.md) | Child session; parent supplies only the bounded question, thoroughness, and path hints |
| [test_reviewer](../../agents/test_reviewer.md) | Child session; parent supplies changeset scope and test context |
| `ad_hoc_child` | Child session; parent supplies the packed task procedure, purpose, scope, and output format |
| Composer phase subagent | Child implementer + review-loop parent for the phase ([composer](../../skills/composer/SKILL.md)) |

### Parent duties (Required)

1. Launch the child with a **complete** invoke payload for that role (see agent contract Inputs), beginning with the [agent invocation](../../workflow/agent-invocation.md) envelope.
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

| Host | Isolated child mapping | Invocation notes |
| --- | --- | --- |
| Cursor | Task/subagent clean context | Aliases `plan-reviewer`, `reviewer-a`, or Bugbot may route, but the envelope supplies canonical identity. |
| OpenCode | Task / `@agent` child session | Canonical routes use host alias `none`; reviewer permissions deny edits. |
| Antigravity | `invoke_subagent` clean context | Reviewer subagent defs are read-only; dual review launches both legs. |
| VS Code | Custom-agent handoff / subagent at depth 1 | Handoff prompts contain fillable payload fields and attestation markers after the envelope. |
| Cline | Separate fresh task/session per reviewer leg until child spawn is attested | Same-conversation persona blocks are not clean-context and are prohibited. |
| Kilo Code | Separate fresh task/session per reviewer leg until `subtask` isolation is attested | The parent transfers only loop decisions, never prior reviewer reasoning. |
| Codex | Managed agent route from TOML contract | Canonical routes use host alias `none`. |
| Portable contract | Parent packs all role-required inputs after `---` | Host metadata, surrounding chat, and prior transcripts never establish identity or scope. |

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
