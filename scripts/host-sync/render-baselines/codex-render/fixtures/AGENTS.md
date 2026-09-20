<!-- cursorEscape-managed-block:v1 id="codex-cursor-escape-loop" source="overlays/codex/footers/codex-wiring.md"; begin managed block -->
# Agent invocation (mandatory)

**Default on for every governed spawned child-agent invocation.**

1. Begin each child-facing invocation with the canonical envelope in [`workflow/agent-invocation.md`](C:/codex-phase1-fixture/companion/workflow/agent-invocation.md): canonical role identity, first-read contract, required companion reading, host alias, isolation, authority, and loop/gate.
2. Put all existing task-specific inputs after the envelope separator. Never rely on host metadata, nearby prose, or prior transcripts to establish identity.
3. A host alias is routing metadata only. The canonical role contract and required reading remain authoritative.
4. If the envelope is missing, malformed, internally contradictory, or unreadable, the child must stop and fail loudly in its role-native output shape. It must not infer identity and proceed.

Detail and role map: [workflow/agent-invocation.md](C:/codex-phase1-fixture/companion/workflow/agent-invocation.md).


# Plan review before implementation

**Default on** unless truly trivial or the user **explicitly** opts out.

**When in doubt, run the plan loop.**

Eval / harness / multi-step operational work is **not** exempt.

1. Load skill `implementation-plan` (Escalation *when* SoT is that skill; when Escalation=yes, read `C:/codex-phase1-fixture/companion/workflow/plan-agent-context.md` for specimen headings only). Plan is incomplete until that skill's **Incomplete until** section bar is met — load `implementation-plan` for the list; do not invent always-on line budgets.
2. Invoke the host's `plan_reviewer` (max 3 passes), **clean context**, full synthesized plan only — no prior review transcripts. Runs for every drafted plan regardless of Escalation yes/no. APPROVED requires Incomplete until compliance (missing-Inputs urgency).
3. Present after APPROVED or pass 3; wait for user if CHANGES REQUESTED.

**Skip only if:** truly trivial one-place typo/copy, comment-only, formatting, cosmetic-only UI, docs-only with no behavior change, **or** explicit user opt-out (`skip plan review`, `skip planning`, `implement now`, `no plan gate`) — not inferred urgency.

**When in doubt, run the loop.**

---

## Related

- [Iterative code review](C:/codex-phase1-fixture/companion/rules/iterative-code-review.md)
- [CI ladder](C:/codex-phase1-fixture/companion/workflow/ci-ladder.md)
- [Instruction layering (FA)](C:/codex-phase1-fixture/companion/docs/featureArchitecture/instruction-layering.md)


# Iterative code review (mandatory)

**Default on** after implementation unless Skip applies.

**When in doubt, run it.**

1. Load skill `implementation-review`. Run **Fast CI Observed** (per-command pass|fail|skipped|n/a; do not launch on fail, skipped when Fast ≠ n/a, or claimed-only).
2. Launch **both** `production_readiness_reviewer` and `bug_reviewer` in **parallel** in **one** session (`Completion gate: review-loop` for the ordinary loop). Isolated children — pack all Inputs; no shared review memory. `bug_reviewer` must follow `C:/codex-phase1-fixture/companion/docs/featureArchitecture/bug-reviewer-finding-rubric.md`.
3. Fix must-fix within a **4-iteration pressure-release block**; re-run Observed Fast CI (when Fast ≠ n/a); re-launch **both** — **do not launch a 5th pair**. Dual APPROVED = bug_reviewer CLEAN/no findings; production_readiness Blocking / Non-blocking / blocking test/docs None (**Batchable (deferred)** may remain).
4. For assembled multi-slice or reopened-closeout work, run the conditional **integrated review gate** before closeout: one integrated pair plus at most one replacement pair, tightly scoped to the assembled diff and cross-slice invariants. A single cohesive phase diff does not need a duplicate gate.
5. Once the applicable dual approval is complete — including the integrated pair when step 4 triggered — closeout = **Full CI only** (no reviewers). Load `pre-commit-ci-gate` before commit. Dual APPROVED ≠ proven no-escape.
6. After iteration 4 **without** dual APPROVED: normal reassessment (Renew | Focus-narrow | Terminate+user with anti-abuse) or **cap-exhausted handoff** (no Full) — detail in companion `implementation-review` / `composer` skills. Waive = Composer-only.

**Skip only if:** truly trivial cases listed under plan review, or explicit user opt-out (`skip review`, `no dual review`).

**When in doubt, run the loop.** Detail: `implementation-review` skill and [`C:/codex-phase1-fixture/companion/workflow/ci-ladder.md`](C:/codex-phase1-fixture/companion/workflow/ci-ladder.md).


# Pre-commit CI gate (fallback)

**Fallback only.** If the project has `.cursor/rules/pre-commit-ci-gate.mdc` (or equivalent), **follow that** — do not apply a second Full command set.

Otherwise:

1. Map Fast/Full via `workflow/ci-ladder.md` (and project README/scripts).
2. Before any `git commit`, Full must pass — or Full = `n/a` with **explicit user acknowledgment**.
3. Never substitute Fast for Full when Full exists.
4. If install/test steps fail due to locked `node_modules` / busy processes, ask the user to stop those processes and re-run Full.

**Composer:** same Full (or `n/a` ack) before automatic local phase commits; never `git push`.

## When to use (Required when committing)

- Before any `git commit` (implementer or Composer phase commit)
- When Full ≠ `n/a` after dual APPROVED closeout
- On-demand load — **not** injected every turn

## Must not

- Always-inject this policy into every agent turn
- Invent hardcoded cross-repo npm / test suites
- Treat Fast CI as commit-grade when Full exists
- Pair Full CI with dual-gate reviewer launch

## Related

- [implementation-review](C:/codex-phase1-fixture/companion/skills/implementation-review/SKILL.md)
- [composer](C:/codex-phase1-fixture/companion/skills/composer/SKILL.md)
- [ci-ladder](C:/codex-phase1-fixture/companion/workflow/ci-ladder.md)


## Codex skills and pointers

The installed catalog has 23 thin wrappers. Invoke the exact `$skill-id`; load the matching canonical skill before non-trivial work. `opencode-headless-run` and `opencode-history-search` are **explicit-only**. For deep procedure reads, use the absolute companion paths under `C:/codex-phase1-fixture/companion`; never treat host-local files as procedure source-of-truth. When acting as Composer after resume or compaction, reread canonical `composer/SKILL.md` and the active roadmap first.

## Isolation and safety boundaries

Reviewers and `plan_reviewer` run as isolated custom agents. The parent synthesizes each invocation payload, owns implementation and recovery, and does not paste prior child transcripts. Read-only reviewers return findings only; they do not edit, run writes, install, commit, push, or rerun CI. Never modify `config.toml`, authentication, history, logs, sessions, databases, or unrelated host state. Every spawned child-agent launch uses the canonical envelope in `C:/codex-phase1-fixture/companion/workflow/agent-invocation.md`; missing, malformed, contradictory, or unreadable envelopes fail loudly.

## Subagent cleanup

After consuming each spawned agent's final result, the parent calls `close_agent` unless the agent is intentionally persistent with a stated reason. Before the final response, close all non-persistent completed descendants.
<!-- cursorEscape-managed-block:v1 id="codex-cursor-escape-loop"; end managed block -->
