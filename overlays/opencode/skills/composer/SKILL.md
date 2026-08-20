---
name: composer
description: >-
  Conduct multi-phase roadmap execution: launch phase implementer subagents
  (≤4 dual-review iterations per block), QC closeout or triage cap-exhausted
  handoff, Full CI, local commit never push. Use when the user assigns Composer.
---

# Composer (OpenCode harness)

Thin harness. Full procedure: Read `{{COMPANION_ROOT}}/skills/composer/SKILL.md`.

## When to use

User assigns Composer for multi-phase roadmap execution after an accepted plan.

## Steps

1. Read companion skill for division of labor, QC gates (incl. Bugbot Task UI "found no bugs" when nested transcript empty/redacted — Gate B), and cap-exhausted triage.
2. Per phase: Task → `implementer` (phase subagent = implementer + review-loop parent; ≤4 iterations/block; no 5th pair).
3. On **dual APPROVED closeout:** QC report + transcript audit → ACCEPT → Full CI (when Full ≠ `n/a`) or user ack → local commit — never push.
4. On **cap-exhausted handoff** (iter 4 without dual APPROVED, no Full): transcript audit → triage Renew | Focus-narrow | Terminate | Waive (process/out-of-spec only; Fast/Full never waivable) — schemas in companion composer skill.

## Read when

| Doc | When |
|-----|------|
| [SKILL.md]({{COMPANION_ROOT}}/skills/composer/SKILL.md) | Full conductor procedure + handoff/waiver schemas |
| [phased-multi-agent.md]({{COMPANION_ROOT}}/workflow/phased-multi-agent.md) | Handoff shape |
| [iterative-code-review.md]({{COMPANION_ROOT}}/workflow/iterative-code-review.md) | Review loop the subagent must run |
| [implementation-review/SKILL.md]({{COMPANION_ROOT}}/skills/implementation-review/SKILL.md) | Pressure-release policy Nb must follow |

## Must not

- Composer implementing Nb
- Skipping dual gate
- Treating cap handoff as dual-APPROVED closeout
- Commit without Full when Full ≠ `n/a` (or without user ack when Full = `n/a`; Cap→Waive = single Composer Full)
- Use host `docs/workflow/` as procedure SoT

## Related agents

`implementer`, `plan_reviewer`
