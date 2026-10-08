# Iterative code review (mandatory)

**Default on** after implementation unless Skip applies.

**When in doubt, run it.**

1. Load skill `implementation-review`. Run **Fast CI Observed** (per-command pass|fail|skipped|n/a; do not launch on fail, skipped when Fast ≠ n/a, or claimed-only).
2. Run the canonical pre-spawn payload gate, then launch **both** `production_readiness_reviewer` and `bug_reviewer` in **parallel** in **one** session (`Completion gate: review-loop` for the ordinary loop). Isolated children — pack all Inputs; no shared review memory. For Reviewer A iterations 2–4, pack prior-findings claims, not transcripts. `bug_reviewer` must follow `{{COMPANION_ROOT}}/docs/featureArchitecture/bug-reviewer-finding-rubric.md`.
3. Fix must-fix within a **4-iteration pressure-release block**; re-run Observed Fast CI (when Fast ≠ n/a); re-launch **both** — **do not launch a 5th pair**. Dual APPROVED = bug_reviewer CLEAN/no findings; production_readiness Must-fix findings and Must-fix test & docs None; required `Supersession closure`, `Lifecycle and naming closure`, and `Fix verification` present with every unresolved closure or prior claim routed into an applicable must-fix list (**Batchable (deferred)** may remain).
4. For assembled multi-slice or reopened-closeout work, run the conditional **integrated review gate** before closeout: one integrated pair plus at most one replacement pair, tightly scoped to the assembled diff and cross-slice invariants. A single cohesive phase diff does not need a duplicate gate.
5. Once the applicable dual approval is complete — including the integrated pair when step 4 triggered — closeout = **Full CI only** (no reviewers). Load `pre-commit-ci-gate` before commit. Dual APPROVED ≠ proven no-escape.
6. After iteration 4 **without** dual APPROVED: normal reassessment (Renew | Focus-narrow | Terminate+user with anti-abuse) or **cap-exhausted handoff** (no Full) — detail in companion `implementation-review` / `composer` skills. Waive = Composer-only.

**Skip only if:** truly trivial cases listed under plan review, or explicit user opt-out (`skip review`, `no dual review`).

**When in doubt, run the loop.** Detail: `implementation-review` skill and [`../workflow/ci-ladder.md`]({{COMPANION_ROOT}}/workflow/ci-ladder.md).
