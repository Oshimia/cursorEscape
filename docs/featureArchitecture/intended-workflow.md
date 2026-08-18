# Intended Workflow

**Last updated:** 2026-08-18

## Context

This document is **Target** cursorEscape design for the owner's agentic loop: plan → implement → dual review → closeout. Canonical process is the **live** `~/.cursor` workflow (imported under [cursor-global-workflow](../research/imported/cursor-global-workflow/)); AITestSuite Phase 4 freeze is **Observed/eval-packaging** only. Where they disagree, cite [workflow-source-delta](../research/imported/workflow-source-delta.md).

Dual-gate review research (openBuggy) informs leg responsibilities. First recreation host: **T3 Code** (control plane) + **OpenCode** (harness). The bug-finder leg is an OpenCode **`bug_reviewer`** subagent + skills (reviewer-a pattern) — **not** an openBuggy engine requirement ([design decisions](../review/design-decisions.md), [host recreation](../analysis/host-recreation-2026-08.md)).

---

## Substance

### End-to-end loop (Required)

```text
Discover repo docs (discovery)
  → Plan (implementation-plan skill; plan_reviewer gate)  [default on]
  → Implement (implementer; phase subagent on multi-phase work)
  → [Fast CI Observed → production_readiness_reviewer ∥ bug_reviewer → fix must-fix]* 
  → dual APPROVED (split bars)
  → Full CI (closeout; no reviewers)
  → phase complete / commit (host-specific)
```

| Stage | Owner | Claim |
| ----- | ----- | ----- |
| Doc discovery before edits | Parent or implementer | **Required** — [discovery](../skills/discovery.md) |
| Plan + plan_reviewer | planner + plan_reviewer | **Required** default on — skip only if truly trivial **or** user **explicitly** opts out ([implementation-plan](../skills/implementation-plan.md)). Eval/harness/multi-step operational work is **not** exempt. **When in doubt, run the plan loop.** |
| Fast CI before reviewers | Review-loop parent | **Required** — per-command Observed rows when Fast ≠ `n/a` |
| Parallel dual review | production_readiness_reviewer ∥ bug_reviewer | **Required** default on for non-trivial changes — same skip list as plan gate ([implementation-review](../skills/implementation-review.md)) |
| Full CI at closeout | Parent (never paired with reviewers) | **Required** when Full ≠ `n/a` |
| Composer conductor on phased roadmaps | Composer QC + phase subagent parent | **Cursor-specific** optional orchestration — see [composer skill](../skills/composer.md) |

### Dual-gate review (Required)

Aligned with live [implementation-review](../research/imported/cursor-global-workflow/skills/implementation-review/SKILL.md) and openBuggy dual-gate analysis ([recommendation](../research/imported/openBuggy/analysis/reviewer-effectiveness/synthesis/recommendation.md)):

| Leg | Role | Target responsibility |
| --- | ---- | --------------------- |
| **production_readiness_reviewer** | Process, architecture drift, incomplete changesets, **blocking** test/docs | Maps to live **reviewer-a** contract |
| **bug_reviewer** | Bugs, security, concurrency, high-value correctness | OpenCode subagent + skills (`edit: deny`); not Cursor `bugbot`; openBuggy optional later only |

**Required:** Fix every must-fix finding from either leg before re-review. **Required:** Re-launch **both** legs after each fix batch.

**Required (live):** Split verdict bars — Reviewer-a may APPROVE with **Batchable (deferred)** open; Bugbot-shaped bar requires Blocking, Non-blocking, and Test gaps all `"None"`. Freeze eval packaging used a unified bar — **do not** copy ([workflow-source-delta](../research/imported/workflow-source-delta.md#batchable-deferred--split-verdict-bars-live-only)).

**Required (live):** Observed Fast CI — no launch on fail, skipped (when Fast ≠ `n/a`), or claimed-only prose. openBuggy study ranks this enforcement highly ([ci-gating](../research/imported/openBuggy/analysis/reviewer-effectiveness/angles/ci-gating.md)). On OpenCode, Fast CI remains **parent skill discipline** (not host-enforced).

**Nice-to-have:** Per-leg launch count; narrow scope when `count >= 9` before invoke — no hard stop ([workflow-source-delta](../research/imported/workflow-source-delta.md#iteration-narrowing-live-only)).

**First host (Desired):** Dual review as **one OpenCode session** with two Task launches in parallel — not two T3 worktrees ([workspace model](./workspace-model.md)).

### CI ladder (Required for cursorEscape pre-runtime)

| Tier | cursorEscape (docs-only) | Runtime repos (future) |
| ---- | ------------------------ | ---------------------- |
| **Fast** | Hub/index link integrity for phase files; claim taxonomy spot-check | Repo-specific lint/test per [ci-ladder](../research/imported/cursor-global-workflow/docs/workflow/ci-ladder.md) |
| **Full** | Fast + deliverable checklist + no runtime scaffolding + no pretend-settled Unknowns | Commit-grade suite; never paired with reviewers |

Do **not** copy freeze baseline's hardcoded four npm commands into cursorEscape pre-runtime CI ([workflow-source-delta](../research/imported/workflow-source-delta.md#ci-ladder--fast-vs-full-major-delta)).

### Phased multi-agent (Nice-to-have / Cursor-specific)

On initialization-style roadmaps, **Composer** conducts: phase subagent implements, owns review loop, reaches dual APPROVED, runs first Full CI when Full ≠ `n/a` (or returns after dual APPROVED when Full = `n/a`); Composer QCs report + transcripts, runs second Full CI when Full ≠ `n/a` (or obtains user ack when Full = `n/a`), then local commit (never push) ([composer](../research/imported/cursor-global-workflow/skills/composer/SKILL.md)). Host-agnostic equivalent: any orchestrator that enforces the same gates without Cursor Task IDs (OpenCode parent + Task subagents).

### What cursorEscape does not own in v0

| Item | Label |
| ---- | ----- |
| Bugbot engine implementation | **Non-goal** for v0 — skill/agent recreation; openBuggy research only |
| Cursor proprietary subagent types | **Cursor-specific** — map to host-agnostic role contracts / OpenCode agents |
| Eval runners in this repo | **Out of scope** until implementation phase |
| T3 / OpenCode product code | External hosts — this repo holds contracts |

---

## Implications / open questions

1. OpenCode expresses dual-gate **shape**; R0 must prove parallel Tasks + MCP/tool policy ([host recreation](../analysis/host-recreation-2026-08.md)).
2. **Unknown:** Whether cursorEscape runtime re-homes a repo-local `reference-docs` skill; live owner workflow uses global discovery instead ([workflow-source-delta](../research/imported/workflow-source-delta.md#reference-docs-skill-presence)).
3. Dual APPROVED is the loop bar — not proven ship-class catch or proven no-escape ([recommendation](../research/imported/openBuggy/analysis/reviewer-effectiveness/synthesis/recommendation.md)).

---

## Related

- [Agent roles and model assignment](./agent-roles-and-model-assignment.md)
- [Instruction layering](./instruction-layering.md)
- [Clean context and isolation](./clean-context-isolation.md)
- [Desired behavior vs Cursor-specific](./desired-behavior-vs-cursor-specific.md)
- [bug-reviewer-finding-rubric](./bug-reviewer-finding-rubric.md)
- [Host recreation study](../analysis/host-recreation-2026-08.md)
- [Evaluation methodology](./evaluation-methodology.md)
- [Workflow source delta](../research/imported/workflow-source-delta.md)
