<!-- cursorEscape-managed-block:v1 id="codex-cursor-escape-loop" source="overlays/codex/instructions/agents-block.md"; begin managed block -->
# cursorEscape loop (always-on, thin)

OpenAI Codex adapter for the owner's agentic loop. Canonical procedure is companion-resident under `C:/codex-phase1-fixture/companion/skills/`, `C:/codex-phase1-fixture/companion/workflow/`, `C:/codex-phase1-fixture/companion/agents/`, and `C:/codex-phase1-fixture/companion/rules/`; the installed harness advertises and points, it is not a second procedure tree. When asked to quote default-on, when-in-doubt, or eval/harness gates, answer from this block without searching for the policy.

## Plan review (all repositories)

**Default on** unless truly trivial or the user **explicitly** opts out. **When in doubt, run the plan loop.** Eval, harness, and multi-step operational work are **not** exempt.

1. Load skill `implementation-plan`. When Escalation=yes, Read `C:/codex-phase1-fixture/companion/workflow/plan-agent-context.md` for specimen headings only. The plan is incomplete until that skill's **Incomplete until** bar is met.
2. Spawn custom agent `plan_reviewer` for up to three clean-context passes. Pass the full synthesized plan only; never attach prior review transcripts.
3. Present after APPROVED or pass three. Wait for the user after CHANGES REQUESTED.

Skip only for a truly trivial one-place typo/copy, comment-only change, formatting, cosmetic-only UI, or docs-only change with no behavior change, or for an explicit opt-out such as `skip plan review`, `skip planning`, `implement now`, or `no plan gate`; do not infer a skip from urgency.

## Implementation review (all repositories)

**Default on** after implementation unless Skip applies. **When in doubt, run it.**

1. Load skill `implementation-review` and run Fast CI with observed per-command pass/fail (or explicit n/a). Do not launch reviewers after a failed or claimed-only Fast run.
2. Spawn `production_readiness_reviewer` and `bug_reviewer` in parallel in the same parent turn. Keep both children isolated; pack all required inputs fresh each pass. `bug_reviewer` must Read `C:/codex-phase1-fixture/companion/docs/featureArchitecture/bug-reviewer-finding-rubric.md`.
3. Fix every must-fix finding within at most four dual-review iterations; rerun observed Fast CI before each replacement pair when Fast is applicable.
4. Dual APPROVED means `bug_reviewer` reports every list as None and `production_readiness_reviewer` reports Blocking, Non-blocking code/process, and blocking test/docs as None; Batchable deferred findings may remain.
5. After dual APPROVED, run Full CI only and load skill `pre-commit-ci-gate` before any local commit. Never pair Full CI with reviewer launches. At four iterations without dual APPROVED, stop with a cap-exhausted handoff and no Full-CI claim.

Skip only for the truly trivial plan-review cases or explicit user opt-out such as `skip review` or `no dual review`.

## Codex skills and pointers

The installed catalog has 23 thin wrappers. Invoke the exact `$skill-id` when using Codex; load the matching canonical skill before non-trivial work. `opencode-headless-run` and `opencode-history-search` are explicit-only. For deep procedure, FA, SOP, rule, workflow, and agent-contract reads, use the absolute companion path shown by `C:/codex-phase1-fixture/companion`; never replace it with a relative hop from the Codex home or skill root, and never treat host-local files as procedure source-of-truth.

## Isolation and safety boundaries

Reviewers and `plan_reviewer` run as isolated custom agents. The parent synthesizes each invocation payload, owns implementation and recovery, and does not paste prior child transcripts. `config.toml`, authentication, history, logs, sessions, databases, and unrelated host state are never modified by this loop. Read-only reviewer agents return findings only; they do not edit, run writes, install, commit, push, or rerun CI.

<!-- cursorEscape-managed-block:v1 id="codex-cursor-escape-loop"; end managed block -->
