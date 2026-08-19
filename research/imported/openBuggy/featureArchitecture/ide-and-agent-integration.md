> **Imported research** — Source: openBuggy `docs/featureArchitecture/ide-and-agent-integration.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# IDE and Agent Integration (Proposed)

**Last updated:** 2026-08-04  
**Status:** Target / proposed

## Context

openBuggy replaces the **bug-finder leg** of iterative local review loops. Integration must work for coding agents first; IDE UI second. Lineage: dual-reviewer loops practiced in sibling projects (e.g. easyPeasyWebsite iterative code review SOPs) — referenced here as **external prose only**, not as in-repo `.cursor` copies. Cursor Agent Review orchestration patterns (Custom Instructions, parallel Reviewer-a + BugBot, empty XML = clean) are documented under [orchestration-and-review-loops.md](./cursor-bugbot-agent-review/orchestration-and-review-loops.md).

---

## Substance

### Priority order

1. **CLI** — `review --json` for shells and agents  
2. **MCP** — tools wrapping the same engine  
3. **VS Code / compatible extension** — thin client: run review, list findings, jump to `file:line`

### Dual-reviewer loop (target)

```text
Implement
  → Fast CI (repo-specific)
  → Parallel: ProductionReadinessReviewer ∥ openBuggy
  → Fix ALL findings from either side
  → Re-run until both clean under policy
  → Full CI closeout
```

| Leg | Responsibility |
|-----|----------------|
| Production-readiness reviewer | Incomplete changesets, architecture drift, test gaps, CI honesty |
| openBuggy | Bugs, security, concurrency, high-value correctness |

Parent orchestrator (skill/command in the user’s agent environment) owns sequencing. openBuggy must not require Cursor’s proprietary `bugbot` subagent type.

### Uncommitted vs branch

Agent skills should pass explicit scope matching [diff model](./diff-and-scope-model.md), analogous to Bugbot’s “branch changes” vs “uncommitted changes” prompts ([invocation-contract.md](./cursor-bugbot-agent-review/invocation-contract.md)).

### What not to integrate in v0

- GitHub App PR bot (can follow later)  
- Cursor-only deep links  
- Silent auto-commits / autofix cloud (optional later; keep review read-only initially)

---

## Implications / open questions

1. Publish example agent skill markdown in a future implementation repo — not required in this docs-only archive beyond SOPs.  
2. MCP tool timeouts must document deep-review minute-scale latency ([latency research](../research/latency-and-api-gap.md)).  
3. See SOP [running an agent review loop](../SOPs/running-an-agent-review-loop-with-openBuggy.md).
