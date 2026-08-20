# cursorEscape loop (always-on, thin)

OpenCode host adapter for the owner's agentic loop. Full procedures live in **skills** and `docs/workflow/` — load them on demand. Do not paste full review essays into this layer.

See cursorEscape SoT: companion `docs/featureArchitecture/instruction-layering.md`, `clean-context-isolation.md`, `intended-workflow.md` (read via `external_directory` when needed).

## Plan review (all repos)

**Default on** unless truly trivial or the user **explicitly** opts out.

**When in doubt, run the plan loop.**

Eval / harness / multi-step operational work is **not** exempt.

1. Load skill `implementation-plan` (Escalation *when* SoT is that skill; when Escalation=yes, read `docs/workflow/plan-agent-context.md` for specimen headings only). Plan is incomplete until that skill's **Incomplete until** section bar is met — load `implementation-plan` for the list; do not invent always-on line budgets.
2. Invoke OpenCode agent `plan_reviewer` via Task (max 3 passes), **clean context**, full synthesized plan only — no prior review transcripts. Runs for every drafted plan regardless of Escalation yes/no. APPROVED requires Incomplete until compliance (missing-Inputs urgency).
3. Present after APPROVED or pass 3; wait for user if CHANGES REQUESTED.

**Skip only if:** truly trivial one-place typo/copy, comment-only, formatting, cosmetic-only UI, docs-only with no behavior change, **or** explicit user opt-out (`skip plan review`, `skip planning`, `implement now`, `no plan gate`) — not inferred urgency.

## Implementation review (all repos)

**Default on** after implementation unless Skip applies.

**When in doubt, run it.**

1. Load skill `implementation-review`. Run **Fast CI Observed** (per-command pass|fail|skipped|n/a; do not launch on fail, skipped when Fast ≠ n/a, or claimed-only).
2. Launch **both** `production_readiness_reviewer` and `bug_reviewer` in **parallel** via Task in **one** session (`Completion gate: review-loop`). Isolated children — pack all Inputs; no shared review memory. `bug_reviewer` must follow `docs/workflow/bug-reviewer-finding-rubric.md`.
3. Fix must-fix; re-run Observed Fast CI (when Fast ≠ n/a), then re-launch **both** until dual APPROVED (bug_reviewer all lists None; production_readiness Blocking / Non-blocking / blocking test/docs None — Batchable deferred may remain).
4. Closeout = **Full CI only** (no reviewers). Load `pre-commit-ci-gate` before commit. Dual APPROVED ≠ proven no-escape.

**Skip only if:** truly trivial cases listed under plan review, or explicit user opt-out (`skip review`, `no dual review`).

## Isolation (required)

Reviewers and plan_reviewer run in **isolated** child sessions. Parent synthesizes invoke payload each pass. Never attach prior child transcripts. Never pair Full CI with reviewers.

## Empty Task signature (operator)

Reviewer Tasks that complete in well under ~1s with empty results are **fail-loud** (routing/auth) until logs show a real model stream — not "no bugs found."

## Skills to load by name

`discovery` · `implementation-plan` · `plan-review` · `implementation-review` · `pre-commit-ci-gate` · `composer` (phased conductor) · `documentation-architecture` (new docs trees) · `roadmap` (repo multi-phase handoffs)

**How to load:** Use the OpenCode **`skill` tool** with the exact skill id above. Do **not** use bash/shell to list or discover adapter SoT under the OpenCode config root. Prefer native `read` / `glob` / `grep` for repo files; reserve bash for real commands (tests, builds, git when needed).

Empty `glob`/`grep` on gitignored or out-of-workspace paths is often **tool blindness**, not proof of absence. Prefer absolute `read` of known adapter paths under the OpenCode config root (e.g. `docs/workflow/iterative-plan-review.md`). Do not Shell-list the adapter tree to discover SoT. Prefer `glob` for `eval/runs` when the repo provides a `.ignore` un-ignore. Prefer approving shell **once** unless the pattern is promoted into reviewed config.
