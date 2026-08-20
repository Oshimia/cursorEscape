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

Thin harness. Full conductor procedure: Read `{{COMPANION_ROOT}}/skills/composer/SKILL.md`.

**Read before conducting:**

| Doc | When |
|-----|------|
| [SKILL.md]({{COMPANION_ROOT}}/skills/composer/SKILL.md) | Full conductor procedure |
| [phased-multi-agent.md]({{COMPANION_ROOT}}/workflow/phased-multi-agent.md) | Phase handoffs, roadmap shape, Composer lifecycle context |
| [plan-agent-context.md]({{COMPANION_ROOT}}/workflow/plan-agent-context.md) | Agent context headings Nb must receive |
| [discovery.md]({{COMPANION_ROOT}}/workflow/discovery.md) | How to find repo docs (Step 0 + fallback) |
| [iterative-code-review.md]({{COMPANION_ROOT}}/workflow/iterative-code-review.md) | Review loop the phase subagent must run |
| [ci-ladder.md]({{COMPANION_ROOT}}/workflow/ci-ladder.md) | Fast/Full CI mapping for any repo |
| [review-subagent-models.md](../../review-subagent-models.md) | Recommended models + chat override (overlay leaf) |
| [_index.md]({{COMPANION_ROOT}}/workflow/_index.md) | Index of all workflow docs |

**Companion reachability:** `{{COMPANION_ROOT}}` resolves to the cursorEscape SoT checkout — required when workspace ≠ cursorEscape. Copy-out fallback (transitional mirror only): `C:/Users/admin/.cursor/docs/workflow/`.

**Cursor conductor notes:** Phase subagent is the implementer and review-loop parent (≤4 dual-review iterations per pressure-release block). Composer does not implement Nb, run reviewers for phase work, or fix product findings. On dual APPROVED closeout: Composer QC's closeout + transcript audit, then Full CI + automatic local commit (never `git push`). On cap-exhausted handoff: audit → triage per companion composer skill (schemas live there).

---

## Phase subagent launch contract

```text
Launch Task:
- subagent_type: generalPurpose
- model: composer-2.5   (or user override)
- run_in_background: false

Rule overrides:
- You are implementing agent + review-loop parent. Follow implementation-review completely (≤4 dual-review iterations per pressure-release block; no 5th pair).
- Before code: discovery Step 0 (local reference-docs if present) else discovery fallback. Roadmap "Where to read context" is an index, not a substitute.
- Do NOT git commit or git push. Composer commits after QC ACCEPT.
- Prefer dual APPROVED (Fast + review-loop) then Full CI. Never launch reviewers with Full.
- After dual APPROVED (Bugbot all None; Reviewer-a blocking lists None — Batchable (deferred) may remain): Full CI only — do not re-launch reviewers; return closeout report.
- After iteration 4 without dual APPROVED: do NOT self-renew; do NOT run Full CI; return Phase cap-exhausted handoff (schema in companion composer SKILL).

Prompt (mandatory):
  0. Docs mandate (above)
  1. Phase N of M + roadmap path + prior phases complete
  2. Locked product decisions
  3. Inter-phase contracts (full)
  4. Agent context — Phase N (full)
  5. Return either closeout report schema OR cap-exhausted handoff schema (companion composer SKILL) — include docs consulted + subagent/reviewer Task ids
```
