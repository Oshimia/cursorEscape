> **Imported research** — Source: openBuggy `docs/SOPs/running-an-agent-review-loop-with-openBuggy.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Running an Agent Review Loop with openBuggy

**Last updated:** 2026-07-29  
**Status:** Conceptual — runtime not implemented

## Context

This is the target operating procedure once openBuggy’s CLI/MCP exists. It mirrors dual-reviewer iterative loops used in sibling projects (production-readiness reviewer + bug finder). Those sibling Cursor skills/agents are **external lineage** — do not expect `.cursor/` paths inside this repo.

---

## Substance

### Target loop

```text
1. Implement the phase / change set
2. Run Fast CI for the repo (discover commands from that repo’s docs)
3. If Fast CI fails → fix; do not review yet
4. In parallel:
     a. Production-readiness reviewer (architecture, complete changeset, test gaps)
     b. openBuggy review (bug/security/concurrency) with explicit diff scope
5. Fix ALL findings from both legs
6. Re-run step 2–5 until both legs are clean under policy
7. Run Full CI closeout (no reviewers unless code changed again)
```

### openBuggy invocation (proposed)

```text
openbuggy review --scope branch|uncommitted --json
```

Or MCP tool `review_diff` with the same arguments. Parse findings per [schema](../featureArchitecture/findings-schema-and-agent-contract.md).

### Policies

| Rule               | Detail                                                                                                    |
| ------------------ | --------------------------------------------------------------------------------------------------------- |
| Fix-all            | Do not stop at “blocking only” unless user overrides                                                      |
| No Bugbot required | Never call Cursor `subagent_type: bugbot`                                                                 |
| Scope explicit     | Pass branch vs uncommitted deliberately ([choosing scope](./choosing-diff-scope.md))                      |
| Deep reviews       | May take minutes — run async/background in the agent host ([latency](../research/latency-and-api-gap.md)) |

---

## Implications / open questions

1. Exact CLI binary name and flags will be fixed at implementation.
2. Parent agent skill text should live with the implementer’s agent host, not necessarily in this docs repo.
3. Until runtime ships, use this SOP as design validation only.
