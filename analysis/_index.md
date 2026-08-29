# Analysis documentation

**Last updated:** 2026-08-29

## Context

Operator studies of **local workflows** (not proposed engine design, not eval scoring, not market research). Each study has its own subdirectory with a hub `_index.md` when imported or authored.

**Status:** Phase 2 openBuggy operator studies imported under `research/imported/openBuggy/analysis/`. Phase 3–4 complete — Target FA and workflow contracts live in [featureArchitecture](../docs/featureArchitecture/_index.md), [agents](../agents/_index.md), and [skills](../skills/_index.md). Local host-recreation study authored 2026-08-17; OpenCode DSV4F session study authored 2026-08-18; session extension study (skill binding / babysat plan loop) authored 2026-08-19; skill-binding discovery authored 2026-08-19; sub-agent nesting & model-control study authored 2026-08-22; VS Code sub-agent recursion study authored 2026-08-28; Cline CLI orchestrator sub-agent study authored 2026-08-29.

---

## Substance

### Content boundaries

| Location | Responsibility |
| -------- | -------------- |
| `analysis/*` (local studies) | Decision-grade studies of the owner's existing loops |
| [`../research/imported/openBuggy/analysis/`](../research/imported/openBuggy/analysis/_index.md) | Imported openBuggy operator studies (Observed/imported) |
| [`../docs/featureArchitecture/`](../docs/featureArchitecture/_index.md) | Target system design (Phase 4); Observed openBuggy FA under `research/imported/openBuggy/featureArchitecture/` |
| [`../research/`](../research/_index.md) | Sourced market/product facts |

### Documents (local)

* [Host recreation (2026-08)](./host-recreation-2026-08.md) — T3 + OpenCode first attempt; ClinePass later; skill-based bug_reviewer
* [OpenCode DSV4F session (2026-08)](./opencode-dsv4f-session-2026-08.md) — OpenCode + DeepSeek V4 Flash live trial; resolved Antigravity routing; lasting gap = automatic plan/review loop binding
* [OpenCode DSV4F session extension (2026-08)](./opencode-dsv4f-session-extension-2026-08.md) — same session continued; skill-tool catalog binding → bash substitution; shell-approval babysitting (~2–3 min); iterative plan loop still operator-prompted; desktop model-selection pin detail
* [OpenCode skill-binding discovery (2026-08)](./opencode-skill-binding-discovery-2026-08.md) — harness vs model vs config triage for C/E; Probe A–C; catalog fixed via skill `name` + `skills.paths`
* [OpenCode pointer-first-2 skills.paths probe (2026-08)](./opencode-pointer-first-2-skills-paths-probe-2026-08.md) — pointer-first-2 harness stub rewrite; `external_directory` + `skills.paths` author-time attestation; live backup path
* [OpenCode sub-agent nesting & model control (2026-08)](./opencode-subagent-nesting-model-control-2026-08.md) — recursion blocked by default, works via `permission.task`; no Task-tool model param — pin via agent `model:` frontmatter; unpinned children inherit invoker model; blockers: config snapshot-at-start, headless subagent bash hang
* [VS Code sub-agent recursion (2026-08)](./vscode-subagent-recursion-2026-08.md) — VS Code native harness counterpart; parent→child `runSubagent` works, child→grandchild blocked (tool absent from child toolset); depth capped at 1; silent asymmetric failure surface
* [Cline CLI as orchestrator sub-agents (2026-08)](./cline-cli-subagent-orchestration-2026-08.md) — external orchestration via headless `cline` CLI processes; single/parallel/nested all work; NDJSON `run_result` as auditable contract; `^C` blocker on backgrounded children
* [Cursor pointer-first-3 audit (2026-08)](./cursor-pointer-first-3-audit-2026-08.md) — overlay vs portable audit; `{{COMPANION_ROOT}}` harness fix; live `~/.cursor` gap disposition
* [Pointer-first-4 closeout (2026-08)](./pointer-first-4-closeout-2026-08.md) — C6 smoke attestation; companion-edit proof; OpenCode mirror delete; operator runbook
* [Overlay-remediation migration record (2026-08)](./overlay-remediation-2026-08.md) — Phases 0–3 migration record; golden-render index; Reviewer A doom-loop incident + owner waiver; recovered duplicate-section finding

### Documents (imported openBuggy)

* [Reviewer-a / BugBot effectiveness](../research/imported/openBuggy/analysis/reviewer-effectiveness/_index.md) — dual-reviewer loop study (Phases 1–5 complete in source archive)
* [Catch + escape follow-on](../research/imported/openBuggy/analysis/reviewer-effectiveness/follow-on-catch-escape/_index.md)

Target synthesis of dual-gate findings: [intended-workflow](../docs/featureArchitecture/intended-workflow.md), [evaluation-methodology](../docs/featureArchitecture/evaluation-methodology.md).

---

## Implications / open questions

1. UUID/path coding sheets stay gitignored under study `.local/` directories in source repos — not copied here.
2. Do not treat eval harness scores as live-loop outcomes.

---

## Related

- [Design decisions](../review/design-decisions.md)
- [Documenting this repo (SOP)](../docs/SOPs/documenting-this-repo.md)
- [Roadmap](../docs/Roadmap.md)
- [COPY-MANIFEST](../research/imported/COPY-MANIFEST.md)
