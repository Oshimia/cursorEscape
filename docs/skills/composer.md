# composer

**Last updated:** 2026-08-20

## Context

**Target** optional orchestration skill — **Cursor-specific** phased conductor. Full Cursor skill (Observed, unchanged): [overlay SKILL.md](../overlays/cursor/skills/composer/SKILL.md). Host-agnostic workflows may omit Composer if another orchestrator enforces the same gates.

---

## Substance

### When to use (Nice-to-have)

User assigns Composer for multi-phase roadmap execution with Incremental execution phases.

### Workflow steps

1. User accepts plan/roadmap
2. Launch phase subagent (implementer + review-loop parent) per phase
3. Subagent returns closeout report after dual APPROVED + first Full CI (when Full ≠ `n/a`); when Full = `n/a`, return after dual APPROVED only — user ack is Composer's commit gate
4. Composer QC: report + transcript audit
5. Composer runs second Full CI + local commit (never push); when Full = `n/a`, explicit user acknowledgment then commit

### Outputs

- Per-phase closeout reports (from subagents)
- QC attestation + second Full CI result before commit (or documented `n/a` + user ack at Composer only)
- Local commit (never push)

### Division of labor (Required when using Composer)

| Actor | Owns |
| ----- | ---- |
| Phase subagent | Implement Nb, review loop, fix findings, first Full CI when Full ≠ `n/a`; when Full = `n/a`, dual APPROVED then return (no commit, no user ack) |
| Composer | QC, second Full CI when Full ≠ `n/a`; when Full = `n/a`, user ack → commit — does not implement Nb |

### Must not

- Composer implementing phase product work
- Skipping review loop or compressing dual gate
- Commit without Full CI pass (when Full ≠ `n/a`); when Full = `n/a`, require explicit user ack before commit

### Related roles

[implementer](../agents/implementer.md) (phase subagent), [plan_reviewer](../agents/plan_reviewer.md) (roadmap gate when applicable)

---

## Implications / open questions

1. Portable equivalent: any CI/orchestration system with explicit phase handoff + QC parent.

---

## Related

- [roadmap](./roadmap.md)
- [implementation-review](./implementation-review.md)
- [pre-commit-ci-gate](./pre-commit-ci-gate.md)
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md) — transcript audit stays on Composer; not next-reviewer memory
- [phased-multi-agent](../overlays/cursor/docs/workflow/phased-multi-agent.md)
