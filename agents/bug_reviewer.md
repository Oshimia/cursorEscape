# bug_reviewer

**Last updated:** 2026-08-23

## Context

**Target** role contract. Bug-finder leg of the dual gate. Recreate Bugbot-shaped utility with an OpenCode (or host-equivalent) subagent + skills/rules — the same pattern as [production_readiness_reviewer](./production_readiness_reviewer.md) / live reviewer-a. **Not** Cursor proprietary `bugbot`. **openBuggy is not required** for v0 ([design decisions](../review/design-decisions.md)).

**Read when reviewing:** [bug-reviewer-finding-rubric.md](../docs/featureArchitecture/bug-reviewer-finding-rubric.md) — report vs ignore SoT. Then follow [bug-review-sweep](../skills/bug-review-sweep/SKILL.md) — ordered class passes + gates that operationalize the rubric (canonical SoT this repo).

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
| Optional evidence frame | When parent supplies `Fixed point` + `Spec path` in Custom Instructions, tag findings by Standards/Spec axis with citations per [code-review-frame](../workflow/code-review-frame.md); without both, ignore framing |
| Optional time budget | Parent hint bounding opportunistic reproduction; absence means default (no reproduction) |
| Note | Parent-verified Fast CI passed — do not re-run lint/test |

### Outputs

Bug-native findings or CLEAN — never code-review scaffolding (no Blocking/Non-blocking/Test-gaps tiers, no verdict lines):

| Outcome | Form | Loop meaning |
| ------- | ---- | ------------ |
| Findings | Each reported defect as one structured entry with openBuggy-compatible fields: **title, file, start_line/end_line, category (class), severity (high/medium/low), description (mechanism + trigger), rationale (introduced-by-change)** — per [bug-review-sweep](../skills/bug-review-sweep/SKILL.md) §Output | CHANGES REQUESTED — parent fixes and re-launches |
| CLEAN | Empty answer / explicit "no findings" in the caller's format | This leg contributes APPROVED |

Parents derive loop decisions from findings-vs-CLEAN; they must not ask this leg for tiered lists.

If required inputs are missing: emit ONE finding titled "Missing required inputs" naming what is absent (findings form, never a tiered list) — this fails the loop loudly; do not return CLEAN.

### Evidence discipline (advisory)

- Prefer evidence from the diff, call paths, tests, static results, or safe workspace observation.
- Localize cheaply when possible: name the smallest changed hunk, input, or branch that demonstrates the issue.
- Opportunistic reproduction is an optimization, never a gate: only when strictly read-only (no file modification, no dependency installation, no service or database mutation, no artifact writes, no added instrumentation) and it does not materially increase review time. Default is no reproduction.
- Redact secrets and personal data before any captured output enters a finding.
- For non-obvious findings, state at most one concise hypothesis and what would confirm or refute it. Full diagnosis machinery belongs elsewhere.
- A finding whose evidence suggests shipped-code-style investigation may end with `Follow-up: diagnosis` plus a one-line reason and what evidence is still needed. This recommends the separate user-invoked diagnosis workflow and never launches it. Absence of the field means none.

### Must not

- Require Cursor-specific subagent types at runtime
- Require openBuggy (or any external Bugbot engine) for v0
- Edit the workspace (`edit: deny` on OpenCode agent)
- Report style/nits, out-of-scope items, pre-existing conditions, speculative env claims, or harness/doc nits — see [finding rubric](../docs/featureArchitecture/bug-reviewer-finding-rubric.md)
- Block on out-of-scope items named in Custom Instructions
- Re-run CI
- Invoke the review skill, spawn further reviewers or subagents, or re-launch reviews of your own output
- Install dependencies, mutate services or databases, write artifacts, add instrumentation, or perform diagnosis-only work such as deep minimization campaigns, ranked multi-hypothesis investigation, or bisection

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

- [bug-reviewer-finding-rubric](../docs/featureArchitecture/bug-reviewer-finding-rubric.md)
- [production_readiness_reviewer](./production_readiness_reviewer.md)
- [Clean context and isolation](../docs/featureArchitecture/clean-context-isolation.md)
- [Host recreation study](../analysis/host-recreation-2026-08.md)
- [openBuggy agent review loop SOP](../research/imported/openBuggy/SOPs/running-an-agent-review-loop-with-openBuggy.md) (Observed / optional)
