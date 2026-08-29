## Composer conduct (when assigned)

When the user assigns **composer / conductor**: load skill `composer`, then conduct per its Antigravity protocol (pre-flight, payload integrity, iteration discipline, Gate B evidence, CLI fallback). Gate pointers:

- **Auto-continue:** never pause between iterations to ask permission — a pressure-release block runs to dual APPROVED or iteration 4 without operator "continue" prompts.
- **Fail-loud legs:** reviewer subagents that complete in well under ~1s with empty results are routing failures, not "no bugs found."
- **Config currency:** agent/config files edited mid-session stay invisible until a fresh session or full restart — verify before blaming agents.
- **Isolation:** reviewers run in isolated child sessions with clean context (`invoke_subagent` does not inherit parent history). Parent synthesizes the invoke payload each pass; never attach prior child transcripts.

## Isolation (required)

Reviewers and plan_reviewer run in **isolated** child sessions. Parent synthesizes the invoke payload each pass. Never attach prior child transcripts. Never pair Full CI with reviewers.

## Empty subagent signature (operator)

Reviewer subagents that complete in well under ~1s with empty results are **fail-loud** (routing/config) until logs show a real model stream — not "no bugs found."

## Skills

Skills live at `~/.gemini/config/skills/` and are auto-discovered into the catalog. Workflow skill ids:

`discovery` · `implementation-plan` · `plan-review` · `implementation-review` · `pre-commit-ci-gate` · `composer` (phased conductor) · `documentation-architecture` (new docs trees) · `roadmap` (repo multi-phase handoffs) · `diagnosing-bugs` (shipped-code diagnosis)

Load the matching id before non-trivial work. Do **not** use bash/shell to list or discover adapter SoT under `~/.gemini`. Empty `glob`/`grep` on gitignored or out-of-workspace paths is often **tool blindness**, not proof of absence; prefer absolute reads of companion procedure paths.

## Shell & native tools (all repos)

Prefer native tools over shell equivalents: file reads via view/read tools, not `Get-Content`/`cat`; content search via grep tools, not `rg`/`Select-String`; file discovery via glob tools, not `ls`/`dir` listings. Use the shell's working-directory parameter — never `git -C`, never `cd` chaining.

Git red line: read/discovery git (status, log, diff, show, rev-parse, ls-files, blame, branch listings, remote -v) is pre-allowed. Mutating stash/tag operations and all other mutating git verbs (add, commit, push, pull, merge, rebase, reset, checkout, switch, restore, revert, cherry-pick, clean) always prompt — do not chain mutating verbs onto allowed reads to dodge the gate; compound commands are checked per segment and each mutating segment still asks.
