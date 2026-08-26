# cursorEscape loop (always-on, thin)

OpenCode host adapter for the owner's agentic loop. Full procedures load via companion **Read** — `{{COMPANION_ROOT}}/skills/`, `{{COMPANION_ROOT}}/workflow/`, `{{COMPANION_ROOT}}/agents/`. Host harness stubs advertise skills; deep procedure is companion-resident. Do not paste full review essays into this layer.

**This file is session-injected.** When asked to quote default-on / when-in-doubt / eval-harness gates, answer from **this text in context**. Do **not** search the workspace, read companion FA docs, or Shell-list `~/.config/opencode` to rediscover always-on.

Architecture background (only when the user asks how layers are authored — not for quoting gates): companion `{{COMPANION_ROOT}}/docs/featureArchitecture/instruction-layering.md`, `{{COMPANION_ROOT}}/docs/featureArchitecture/clean-context-isolation.md`, `{{COMPANION_ROOT}}/docs/featureArchitecture/intended-workflow.md` via `external_directory`.

## Plan review (all repos)

**Default on** unless truly trivial or the user **explicitly** opts out.

**When in doubt, run the plan loop.**

Eval / harness / multi-step operational work is **not** exempt.

1. Load skill `implementation-plan` (Escalation *when* SoT is that skill; when Escalation=yes, read `{{COMPANION_ROOT}}/workflow/plan-agent-context.md` for specimen headings only). Plan is incomplete until that skill's **Incomplete until** section bar is met — load `implementation-plan` for the list; do not invent always-on line budgets.
2. Invoke OpenCode agent `plan_reviewer` via Task (max 3 passes), **clean context**, full synthesized plan only — no prior review transcripts. Runs for every drafted plan regardless of Escalation yes/no. APPROVED requires Incomplete until compliance (missing-Inputs urgency).
3. Present after APPROVED or pass 3; wait for user if CHANGES REQUESTED.

**Skip only if:** truly trivial one-place typo/copy, comment-only, formatting, cosmetic-only UI, docs-only with no behavior change, **or** explicit user opt-out (`skip plan review`, `skip planning`, `implement now`, `no plan gate`) — not inferred urgency.

## Implementation review (all repos)

**Default on** after implementation unless Skip applies.

**When in doubt, run it.**

1. Load skill `implementation-review`. Run **Fast CI Observed** (per-command pass|fail|skipped|n/a; do not launch on fail, skipped when Fast ≠ n/a, or claimed-only).
2. Launch **both** `production_readiness_reviewer` and `bug_reviewer` in **parallel** via Task in **one** session (`Completion gate: review-loop`). Isolated children — pack all Inputs; no shared review memory. `bug_reviewer` must follow `{{COMPANION_ROOT}}/docs/featureArchitecture/bug-reviewer-finding-rubric.md`.
3. Fix must-fix within a **4-iteration pressure-release block**; re-run Observed Fast CI (when Fast ≠ n/a); re-launch **both** — **do not launch a 5th pair**. Dual APPROVED = bug_reviewer all lists None; production_readiness Blocking / Non-blocking / blocking test/docs None (Batchable deferred may remain).
4. After dual APPROVED: closeout = **Full CI only** (no reviewers). Load `pre-commit-ci-gate` before commit. Dual APPROVED ≠ proven no-escape.
5. After iteration 4 **without** dual APPROVED: normal reassessment (Renew | Focus-narrow | Terminate+user with anti-abuse) or Composer Nb **cap-exhausted handoff** (no Full) — detail in companion `implementation-review` / `composer` skills. Waive = Composer-only.

**Skip only if:** truly trivial cases listed under plan review, or explicit user opt-out (`skip review`, `no dual review`).

## Composer conduct (when assigned)

When the user assigns **composer / conductor**: load skill `composer`, then conduct per its OpenCode protocol (pre-flight, payload integrity, iteration discipline, Gate B evidence, headless fallback). Gate pointers:

- **Auto-continue:** never pause between iterations to ask permission — a pressure-release block runs to dual APPROVED or iteration 4 without operator "continue" prompts.
- **Fail-loud legs:** reviewer Tasks that complete in well under ~1s with empty results are routing/auth failures, not "no bugs found."
- **Config currency:** agent/config files edited mid-session stay invisible until a fresh process or full restart — verify before blaming agents.
- **Isolation:** reviewers run in isolated child sessions; parent synthesizes the invoke payload each pass; never attach prior child transcripts.

## Isolation (required)

Reviewers and plan_reviewer run in **isolated** child sessions. Parent synthesizes invoke payload each pass. Never attach prior child transcripts. Never pair Full CI with reviewers.

## Empty Task signature (operator)

Reviewer Tasks that complete in well under ~1s with empty results are **fail-loud** (routing/auth) until logs show a real model stream — not "no bugs found."

## Skills to load by name

`discovery` · `implementation-plan` · `plan-review` · `implementation-review` · `pre-commit-ci-gate` · `composer` (phased conductor) · `documentation-architecture` (new docs trees) · `roadmap` (repo multi-phase handoffs) · `diagnosing-bugs` (shipped-code diagnosis)

`opencode-headless-run` · `opencode-history-search` — the `opencode-` prefix marks the OpenCode-infrastructure skill group; when a task involves driving or inspecting OpenCode itself, load from that group before improvising.

**How to load:** Use the OpenCode **`skill` tool** with the exact skill id above. Do **not** use bash/shell to list or discover adapter SoT under the OpenCode config root. Prefer native `read` / `glob` / `grep` for repo files; reserve bash for real commands (tests, builds, git when needed).

Empty `glob`/`grep` on gitignored or out-of-workspace paths is often **tool blindness**, not proof of absence. Prefer absolute `read` of companion procedure paths (e.g. `{{COMPANION_ROOT}}/workflow/iterative-plan-review.md`). Do not treat host `docs/workflow/` mirror as procedure SoT. Do not Shell-list the adapter tree to discover SoT. Prefer `glob` for `eval/runs` when the repo provides a `.ignore` un-ignore. Prefer approving shell **once** unless the pattern is promoted into reviewed config.

## Shell & native tools (all repos)

Prefer native tools over shell equivalents: `read` not `Get-Content`/`cat`; `grep` not `rg`/`Select-String`; `glob` not `ls`/`dir`/`Get-ChildItem` listings. Use the bash `workdir` parameter — never `git -C`, never `cd` chaining.

Git red line: read/discovery git (status, log, diff, show, rev-parse, ls-files, blame, branch listings, remote -v) is pre-allowed. Mutating stash/tag operations and all other mutating git verbs (add, commit, push, pull, merge, rebase, reset, checkout, switch, restore, revert, cherry-pick, clean) always prompt — do not chain mutating verbs onto allowed reads to dodge the gate; compound commands are checked per segment and each mutating segment still asks.
