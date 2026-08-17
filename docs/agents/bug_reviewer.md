# bug_reviewer

**Last updated:** 2026-08-17

## Context

**Target** role contract. Bug-finder leg of the dual gate. **Required:** Delegate to **openBuggy** (external sibling) — not Cursor proprietary `bugbot` subagent type ([design decisions](../review/design-decisions.md)).

---

## Substance

### Purpose

Find bugs, security issues, concurrency problems, and high-value correctness defects in the phase changeset. Runs **in parallel** with production_readiness_reviewer.

### Inputs (Required)

| Input | Description |
| ----- | ----------- |
| Repository path | Absolute workspace root |
| Diff scope | Branch changes \| uncommitted changes |
| Custom Instructions | Phase summary, iteration, launch count, regressions to flag, out-of-scope |
| Note | Parent-verified Fast CI passed — do not re-run lint/test |

### Outputs

| List | All must be `"None"` for APPROVED |
| ---- | ----------------------------------- |
| Blocking | Yes |
| Non-blocking | Yes |
| Test gaps | Yes |

### Must not

- Require Cursor-specific subagent types at runtime
- Block on out-of-scope items named in Custom Instructions
- Re-run CI

### Model

openBuggy engine default or matched to parent — config override.

### Adapter note (Unknown)

Transport: CLI `review --json` vs MCP — see [preliminary backend landscape](../research/preliminary-backend-landscape.md) and openBuggy [ide-and-agent-integration](../research/imported/openBuggy/featureArchitecture/ide-and-agent-integration.md).

---

## Implications / open questions

1. Until openBuggy adapter exists, Cursor-hosted workflow may still use Cursor Bugbot as **Cursor-specific** stand-in — not Target runtime.

---

## Related

- [production_readiness_reviewer](./production_readiness_reviewer.md)
- [openBuggy agent review loop SOP](../research/imported/openBuggy/SOPs/running-an-agent-review-loop-with-openBuggy.md)
