# bug_reviewer

**Last updated:** 2026-08-17

## Context

**Target** role contract. Bug-finder leg of the dual gate. Recreate Bugbot-shaped utility with an OpenCode (or host-equivalent) subagent + skills/rules — the same pattern as [production_readiness_reviewer](./production_readiness_reviewer.md) / live reviewer-a. **Not** Cursor proprietary `bugbot`. **openBuggy is not required** for v0 ([design decisions](../review/design-decisions.md)).

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
- Require openBuggy (or any external Bugbot engine) for v0
- Edit the workspace (`edit: deny` on OpenCode agent)
- Block on out-of-scope items named in Custom Instructions
- Re-run CI

### Model

**Desired:** Matched to production_readiness or a stronger bug-focused model — config override. ClinePass (or BYOK) when using OpenCode.

### Host mapping (first attempt)

OpenCode markdown agent (`mode: subagent`, `permission.edit: deny`) with a bug-first system prompt and Custom Instructions envelope. Parent launches via Task in the same session as production_readiness_reviewer.

---

## Implications / open questions

1. openBuggy CLI/MCP remains **Nice-to-have** later — research under `docs/research/imported/openBuggy/`.
2. Until OpenCode agents are installed, Cursor-hosted workflow may still use Cursor Bugbot as **Cursor-specific** stand-in — not Target recreation path.

---

## Related

- [production_readiness_reviewer](./production_readiness_reviewer.md)
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
- [Host recreation study](../analysis/host-recreation-2026-08.md)
- [openBuggy agent review loop SOP](../research/imported/openBuggy/SOPs/running-an-agent-review-loop-with-openBuggy.md) (Observed / optional)
