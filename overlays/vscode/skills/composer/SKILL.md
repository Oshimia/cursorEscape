---
name: composer
description: >-
  Conduct multi-phase roadmap execution: launch phase implementer subagents
  (≤4 dual-review iterations per block), QC closeout or triage cap-exhausted
  handoff, Full CI, local commit never push. Use when the user assigns Composer.
---

# Composer (VS Code harness)

Thin harness. Full procedure: Read `{{COMPANION_ROOT}}/skills/composer/SKILL.md`.

## When to use

User assigns Composer for multi-phase roadmap execution after an accepted plan.

## Steps

1. Read companion skill for division of labor, QC gates (Gate B), and cap-exhausted triage.
2. Per phase: launch `implementer` as a subagent (phase subagent = implementer + review-loop parent; ≤4 iterations/block; no 5th pair).
3. On **dual APPROVED closeout:** QC report + verification audit → ACCEPT → Full CI (when Full ≠ `n/a`) or user ack → local commit — never push.
4. On **cap-exhausted handoff** (iter 4 without dual APPROVED, no Full): transcript audit → triage Renew | Focus-narrow | Terminate | Waive (process/out-of-spec only; Fast/Full never waivable) — schemas in companion composer skill.

## VS Code conductor protocol

1. **Pre-flight:** confirm agent defs (`implementer`, reviewers, this conductor) are discovered — Diagnostics view lists loaded custom agents; mid-session config edits stay invisible until a fresh session or full restart. Empty/fast reviewer returns (< ~1s, empty result) are routing failures — **fail loud**, never treat as APPROVED.
2. **Launch contract:** every subagent payload carries an **attestation marker line** the child must echo back verbatim (mangling detection); roadmap-derived prompts come from companion **Read** — never improvised from memory.
3. **Iteration discipline:** auto-continue within each 4-iteration pressure-release block — no permission pauses between iterations; track cumulative per-leg launch counts across blocks.
4. **Subagent depth:** depth 1 — this conductor's children cannot spawn further subagents. Reviewer legs are launched by the conductor (or phase parent) directly, one fan-out per iteration.
5. **Gate B evidence:** reviewer verdict receipts captured per iteration in conversation; missing receipts = **REJECT** the closeout claim.
6. **Cap-exhausted triage** unchanged — schemas in companion composer skill.

## Read when

| Doc | When |
|-----|------|
| [SKILL.md]({{COMPANION_ROOT}}/skills/composer/SKILL.md) | Full conductor procedure + handoff/waiver schemas |
| [phased-multi-agent.md]({{COMPANION_ROOT}}/workflow/phased-multi-agent.md) | Handoff shape |
| [iterative-code-review.md]({{COMPANION_ROOT}}/workflow/iterative-code-review.md) | Review loop the subagent must run |
| [implementation-review/SKILL.md]({{COMPANION_ROOT}}/skills/implementation-review/SKILL.md) | Pressure-release policy |

## Must not

- Plan (planner) or edit code directly while conducting
- Launch a 5th dual-review pair in a block
- Treat an empty/fast subagent return as success
- Push to remote (local commit only, after Full CI + pre-commit gate)
