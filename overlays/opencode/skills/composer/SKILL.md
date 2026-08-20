---
name: composer
description: >-
  Conduct multi-phase roadmap execution: launch phase implementer subagents,
  QC closeout reports, run second Full CI, local commit never push. Use when
  the user assigns Composer for phased execution.
---

# Composer (OpenCode harness)

Thin harness. Full procedure: Read `{{COMPANION_ROOT}}/skills/composer/SKILL.md`.

## When to use

User assigns Composer for multi-phase roadmap execution after an accepted plan.

## Steps

1. Read companion skill for division of labor and QC gates.
2. Per phase: Task → `implementer` (phase subagent = implementer + review-loop parent).
3. Composer QC closeout + second Full CI (when Full ≠ `n/a`) or explicit user ack (when Full = `n/a`) → local commit — never push.

## Read when

| Doc | When |
|-----|------|
| [SKILL.md]({{COMPANION_ROOT}}/skills/composer/SKILL.md) | Full conductor procedure |
| [phased-multi-agent.md]({{COMPANION_ROOT}}/workflow/phased-multi-agent.md) | Handoff shape |
| [iterative-code-review.md]({{COMPANION_ROOT}}/workflow/iterative-code-review.md) | Review loop the subagent must run |

## Must not

- Composer implementing Nb
- Skipping dual gate
- Commit without Full when Full ≠ `n/a` (or without user ack when Full = `n/a`)
- Use host `docs/workflow/` as procedure SoT

## Related agents

`implementer`, `plan_reviewer`
