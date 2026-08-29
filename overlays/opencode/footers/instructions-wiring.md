## Composer conduct (when assigned)

When the user assigns **composer / conductor**: load skill `composer`, then conduct per its OpenCode protocol (pre-flight, payload integrity, iteration discipline, Gate B evidence, headless fallback). Gate pointers:

- **Auto-continue:** never pause between iterations to ask permission — a pressure-release block runs to dual APPROVED or iteration 4 without operator "continue" prompts.
- **Fail-loud legs:** reviewer Tasks that complete in well under ~1s with empty results are routing/auth failures, not "no bugs found."
- **Config currency:** agent/config files edited mid-session stay invisible until a fresh process or full restart — verify before blaming agents.
- **Isolation:** reviewers run in isolated child sessions; parent synthesizes the invoke payload each pass; never attach prior child transcripts.

## Isolation (required)

Reviewers and plan_reviewer run in **isolated** child sessions. Parent synthesizes the invoke payload each pass. Never attach prior child transcripts. Never pair Full CI with reviewers.

## Empty Task signature (operator)

Reviewer Tasks that complete in well under ~1s with empty results are **fail-loud** (routing/auth) until logs show a real model stream — not "no bugs found."

## Skills to load by name

`discovery` · `implementation-plan` · `plan-review` · `implementation-review` · `pre-commit-ci-gate` · `composer` (phased conductor) · `documentation-architecture` (new docs trees) · `roadmap` (repo multi-phase handoffs) · `diagnosing-bugs` (shipped-code diagnosis)

`opencode-headless-run` · `opencode-history-search` — the `opencode-` prefix marks the OpenCode-infrastructure skill group; when a task involves driving or inspecting OpenCode itself, load from that group before improvising.

**How to load:** Use the OpenCode **`skill` tool** with the exact skill id above. Do **not** use bash/shell to list or discover adapter SoT under the OpenCode config root. Prefer native `read` / `glob` / `grep` for repo files; reserve bash for real commands (tests, builds, git when needed).

Empty `glob`/`grep` on gitignored or out-of-workspace paths is often **tool blindness**, not proof of absence. Prefer absolute `read` of companion procedure paths (e.g. `{{COMPANION_ROOT}}/workflow/iterative-plan-review.md`). Do not treat host `docs/workflow/` mirror as procedure SoT. Do not Shell-list the adapter tree to discover SoT. Prefer `glob` for `eval/runs` when the repo provides a `.ignore` un-ignore. Prefer approving shell **once** unless the pattern is promoted into reviewed config.

## Shell & native tools (all repos)

Prefer native tools over shell equivalents: `read` not `Get-Content`/`cat`; `grep` not `rg`/`Select-String`; `glob` not `ls`/`dir`/`Get-ChildItem` listings. Use the bash `workdir` parameter — never `git -C`, never `cd` chaining.

## Shell & native tools (all repos)

Prefer native tools over shell equivalents: `read` not `Get-Content`/`cat`; `grep` not `rg`/`Select-String`; `glob` not `ls`/`dir`/`Get-ChildItem` listings. Use the bash `workdir` parameter - never `git -C`, never `cd` chaining.

Git red line: read/discovery git (status, log, diff, show, rev-parse, ls-files, blame, branch listings, remote -v) is pre-allowed. Mutating stash/tag operations and all other mutating git verbs (add, commit, push, pull, merge, rebase, reset, checkout, switch, restore, revert, cherry-pick, clean) always prompt - do not chain mutating verbs onto allowed reads to dodge the gate; compound commands are checked per segment and each mutating segment still asks.
