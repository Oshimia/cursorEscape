# bug_reviewer

**Last updated:** 2026-08-18

## Context

**Target** role contract. Bug-finder leg of the dual gate. Recreate Bugbot-shaped utility with an OpenCode (or host-equivalent) subagent + skills/rules — the same pattern as [production_readiness_reviewer](./production_readiness_reviewer.md) / live reviewer-a. **Not** Cursor proprietary `bugbot`. **openBuggy is not required** for v0 ([design decisions](../../review/design-decisions.md)).

**Read when reviewing:** [bug-reviewer-finding-rubric.md](../featureArchitecture/bug-reviewer-finding-rubric.md) — report vs ignore SoT.

---

## Substance

### Purpose

Find bugs, security issues, concurrency problems, and high-value correctness defects **introduced by** the phase changeset. Runs **in parallel** with production_readiness_reviewer.

Process/docs completeness belongs on [production_readiness_reviewer](./production_readiness_reviewer.md) — not this leg.

### Inputs (Required)

| Input | Description |
| ----- | ----------- |
| Repository path | Absolute workspace root |
| Diff scope | Branch changes \| uncommitted changes \| natural-language change description |
| Custom Instructions | Phase summary, iteration, launch count, regressions to flag, out-of-scope, clean-case signals |
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
- Report style/nits, out-of-scope items, pre-existing conditions, speculative env claims, or harness/doc nits — see [finding rubric](../featureArchitecture/bug-reviewer-finding-rubric.md)
- Block on out-of-scope items named in Custom Instructions
- Re-run CI

### Model

**Desired:** Matched to production_readiness or a stronger bug-focused model — config override. ClinePass (or BYOK) when using OpenCode. Do **not** pin provider-specific models in the agent file.

### Host mapping (first attempt)

OpenCode markdown agent (`mode: subagent`, `permission.edit: deny`) with a bug-first system prompt, Custom Instructions envelope, and **Read when** the finding rubric. Parent launches via Task in the same session as production_readiness_reviewer.

---

## Implications / open questions

1. openBuggy CLI/MCP remains **Nice-to-have** later — research under `research/imported/openBuggy/`.
2. Until OpenCode agents are installed, Cursor-hosted workflow may still use Cursor Bugbot as **Cursor-specific** stand-in — not Target recreation path.

---

## Related

- [bug-reviewer-finding-rubric](../featureArchitecture/bug-reviewer-finding-rubric.md)
- [production_readiness_reviewer](./production_readiness_reviewer.md)
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
- [Host recreation study](../../analysis/host-recreation-2026-08.md)
- [openBuggy agent review loop SOP](../../research/imported/openBuggy/SOPs/running-an-agent-review-loop-with-openBuggy.md) (Observed / optional)
