---
name: composer
description: >-
  Thread conductor and run manager for phased multi-agent execution when the
  user explicitly assigns the composer/conductor role. Delegates Nb
  implementation and per-phase review loops to subagents; Na previews and
  migration drafts only; QC closeout reports plus transcript audit; automatic
  local commit per phase; never git push.
disable-model-invocation: true
---

# Composer (Cursor overlay)

Thin wrapper. Full conductor procedure: [skills/composer/SKILL.md](../../../../skills/composer/SKILL.md).

**Read before conducting:**

| Doc | When |
|-----|------|
| [SKILL.md](../../../../skills/composer/SKILL.md) | Full conductor procedure |
| [phased-multi-agent.md](../../../../workflow/phased-multi-agent.md) | Phase handoffs, roadmap shape, Composer lifecycle context |
| [plan-agent-context.md](../../../../workflow/plan-agent-context.md) | Agent context headings Nb must receive |
| [discovery.md](../../../../workflow/discovery.md) | How to find repo docs (Step 0 + fallback) |
| [iterative-code-review.md](../../../../workflow/iterative-code-review.md) | Review loop the phase subagent must run |
| [ci-ladder.md](../../../../workflow/ci-ladder.md) | Fast/Full CI mapping for any repo |
| [review-subagent-models.md](../../review-subagent-models.md) | Recommended models + chat override |
| [_index.md](../../../../workflow/_index.md) | Index of all workflow docs |

Copy-out fallback: `C:/Users/admin/.cursor/docs/workflow/` (live mirror — not overwritten from this repo).

**Cursor conductor notes:** Phase subagent is the implementer and review-loop parent. Composer does not implement Nb, run reviewers for phase work, or fix product findings. Composer QC's closeout + transcript audit, then Full CI + automatic local commit (never `git push`).

---

## Phase subagent launch contract

```text
Launch Task:
- subagent_type: generalPurpose
- model: composer-2.5   (or user override)
- run_in_background: false

Rule overrides:
- You are implementing agent + review-loop parent. Follow implementation-review completely.
- Before code: discovery Step 0 (local reference-docs if present) else discovery fallback. Roadmap "Where to read context" is an index, not a substitute.
- Do NOT git commit or git push. Return closeout report; Composer commits after QC.
- Complete only after dual APPROVED (Fast + review-loop) then Full CI. Never launch reviewers with Full.
- After dual APPROVED (Bugbot all None; Reviewer-a blocking lists None — Batchable (deferred) may remain): Full CI only — do not re-launch reviewers.

Prompt (mandatory):
  0. Docs mandate (above)
  1. Phase N of M + roadmap path + prior phases complete
  2. Locked product decisions
  3. Inter-phase contracts (full)
  4. Agent context — Phase N (full)
  5. Closeout report schema (include docs consulted + subagent/reviewer Task ids)
```
