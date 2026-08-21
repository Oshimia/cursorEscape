# Shell & native tool policy

**Last updated:** 2026-08-22

## Context

Always-on gate contract for shell usage and permissions across hosts. Companion SoT (Target): this file owns the canonical read-only bash allowlist, the mutating-git red line, and the accepted-risk register. Host harnesses **echo** it (OpenCode echo lands via `overlays/opencode/opencode.specimen.json` + C1 dual-write in Phase 2, live on next operator `-Apply`; Cursor thin wrapper **deferred — required before the first Cursor live sync**). Design rationale: [permission-and-native-tool-policy](../docs/featureArchitecture/permission-and-native-tool-policy.md).

Origin: OpenCode log analysis (window 2026-08-17→21, as of 2026-08-22 via [scripts/analyze-permission-asks.py](../scripts/analyze-permission-asks.py)) — 558 permission prompts (415 bash, 142 external_directory); 87% of bash asks came from read-only work in subagent review/plan sessions ([FA leaf](../docs/featureArchitecture/permission-and-native-tool-policy.md)).

---

## Substance

### Red line (Required)

Mutating git **always prompts**: `add`, `commit`, `push`, `pull`, `merge`, `rebase`, `reset`, `checkout`, `switch`, `restore`, `revert`, `cherry-pick`, `stash` (except `list*`/`show*`), `tag` (creation/move/delete), `clean`, `config` (set/unset), `branch` (create/delete/rename/copy), `remote` (add/rename/remove/set-url/prune/update), `worktree` (add/remove/move/prune), `reflog` (expire/delete). Searching commits is fine; rebasing the head is not. Looking at logs is fine; making a commit is not.

Do not chain mutating verbs onto allowed reads to dodge the gate — compound commands are checked per segment and each mutating segment still asks.

Shell-native filesystem mutations (`Set-Content`, `New-Item`, `Remove-Item`, `Copy-Item`, `Move-Item`, `Rename-Item`) and scriptblock-carrying pipeline stages (`ForEach-Object {…}`, `Where-Object {…}`) stay prompt-gated. Registered exceptions below.

### Canonical read-only bash allowlist (single SoT entry)

**Target state (applied in Phase 2):** lives once, in the **global** `permission.bash` of `overlays/opencode/opencode.specimen.json`; per-agent and per-stub bash blocks are deleted there — agents inherit global per-key. Until Phase 2–4 land, the live config keeps its current narrow blocks. Echo rule: **entry-set equality, order-insensitive** (the sync optimizer sorts keys).

Design invariants:

1. Exactly one catch-all `"*": "ask"`; every other entry is `"allow"`.
2. **No allow entry prefix-matches an ask-class command.** Entries that overlap each other share the same verdict (`git diff*` / `git diff-tree*` both allow — safe).
3. No mid-pattern `*` inside any allow entry.
4. Order-independent under the sync optimizer (`Order-OpenCodePermissionPatternMap`: `*` hoisted first, rest sorted alphabetically).

```json
{
  "*": "ask",
  "git status*": "allow",
  "git log*": "allow",
  "git diff*": "allow",
  "git show*": "allow",
  "git rev-parse*": "allow",
  "git ls-files*": "allow",
  "git ls-tree*": "allow",
  "git blame*": "allow",
  "git shortlog*": "allow",
  "git describe*": "allow",
  "git rev-list*": "allow",
  "git cat-file*": "allow",
  "git diff-tree*": "allow",
  "git for-each-ref*": "allow",
  "git check-ignore*": "allow",
  "git grep*": "allow",
  "git merge-base*": "allow",
  "git count-objects*": "allow",
  "git remote": "allow",
  "git remote -v": "allow",
  "git remote get-url*": "allow",
  "git remote show*": "allow",
  "git branch": "allow",
  "git branch -a": "allow",
  "git branch -r": "allow",
  "git branch -v": "allow",
  "git branch -vv": "allow",
  "git branch --list": "allow",
  "git branch --show-current": "allow",
  "git tag": "allow",
  "git tag -l": "allow",
  "git tag --list": "allow",
  "git stash list*": "allow",
  "git stash show*": "allow",
  "git worktree list*": "allow",
  "git config --get*": "allow",
  "git config --list*": "allow",
  "git reflog": "allow",
  "git reflog show*": "allow",
  "Get-ChildItem*": "allow",
  "Test-Path*": "allow",
  "Get-Content*": "allow",
  "Get-Item*": "allow",
  "Get-Command*": "allow",
  "Get-FileHash*": "allow",
  "Get-Date*": "allow",
  "Get-Location*": "allow",
  "Select-String*": "allow",
  "Select-Object*": "allow",
  "Sort-Object*": "allow",
  "Group-Object*": "allow",
  "Measure-Object*": "allow",
  "Compare-Object*": "allow",
  "Format-Table*": "allow",
  "Format-List*": "allow",
  "Format-Wide*": "allow",
  "Out-String*": "allow",
  "Out-Null*": "allow",
  "ConvertFrom-Json*": "allow",
  "ConvertTo-Json*": "allow",
  "ConvertFrom-Csv*": "allow",
  "ConvertTo-Csv*": "allow",
  "Join-Path*": "allow",
  "Split-Path*": "allow",
  "Resolve-Path*": "allow",
  "Write-Output*": "allow",
  "Write-Host*": "allow",
  "echo*": "allow",
  "rg*": "allow",
  "python*": "allow"
}
```

Branch/tag reads are **exact-form** so combined-flag mutants fall through to the catch-all: `git branch -a -D x` and `git tag -l -f v1 v2` match no allow → ask.

Patterned listing escape hatch: `git branch --list <pat>` / `git tag -l <pat>` intentionally prompt — use allowed `git for-each-ref refs/heads/<pat>` or `refs/tags/<pat>` instead (pure read verb, wildcard-safe).

### Instruction echo (always-on C1 text)

Fixed text, byte-identical dual-write into `overlays/opencode/AGENTS.md` ≡ `overlays/opencode/instructions/cursor-escape-loop.md`:

```markdown
## Shell & native tools (all repos)

Prefer native tools over shell equivalents: `read` not `Get-Content`/`cat`; `grep` not `rg`/`Select-String`; `glob` not `ls`/`dir`/`Get-ChildItem` listings. Use the bash `workdir` parameter — never `git -C`, never `cd` chaining.

Git red line: read/discovery git (status, log, diff, show, rev-parse, ls-files, blame, branch listings, remote -v) is pre-allowed. Mutating stash/tag operations and all other mutating git verbs (add, commit, push, pull, merge, rebase, reset, checkout, switch, restore, revert, cherry-pick, clean) always prompt — do not chain mutating verbs onto allowed reads to dodge the gate; compound commands are checked per segment and each mutating segment still asks.
```

### Accepted risks (owner-accepted Balanced posture)

| Risk | Why accepted |
|---|---|
| `python*` = arbitrary-code permit | Dominant legitimate use is read-only sqlite/log analysis (48+ asks in window); blanket deny would recreate the babysitting tax |
| `rg --pre <cmd>` executes preprocessor command | Obscure; native `grep` preferred by instruction anyway |
| Scriptblock-capable allowed cmdlets (`Select-Object` calculated properties, `Sort-Object`/`Group-Object` custom expressions) can execute mutating code inside an allowed pipeline | Contrived; red-line intent is git history/structure and routine fs safety, not adversarial self-hosting |
| `git difftool` matches `git diff*` | External viewer, read-only intent |
| `git config --get*` cannot reach mutating modes (`--add`/`--unset`/`--replace-all` are disjoint flags git rejects in combination) | Verified flag semantics |

### Residual known asks (not failures)

Expected to keep prompting; exclude from soak-failure counts: `git show-ref`, `git symbolic-ref`, `git ls-remote`, patterned branch/tag listing (use escape hatch), binary version checks outside the allowlist (`node -v` etc.), `git reflog <ref>` with explicit ref.

### Role posture (current → unified)

| Role | Before (live frontmatter) | After |
|---|---|---|
| plan_reviewer | bash `"*": deny` (+ must-not shell-browse text) | inherits unified read-only set; behavioral must-not text stays |
| test_reviewer | bash `"*": deny` + `git status/log/diff/show` allows | inherits unified set |
| bug_reviewer / production_readiness_reviewer | bash `"*": deny` + `git status/log/diff/show/rev-parse` allows | inherit unified set |
| planner | bash `"*": ask` + `Get-ChildItem/Test-Path/git status/log/diff/show` allows | inherits unified set |
| repository_explorer | same as planner plus `rg */find *` allows | inherits unified set |
| implementer | same as planner; keeps `edit: allow` + `task:` allowlist | inherits unified set; edit/task unchanged |

Unification loosens reviewer *permissions* deliberately (owner decision); `edit:` stays deny on every reviewer, and reviewer must-not behavioral text is unchanged.

### Rollback asymmetry

Re-sync overwrites values but **never removes keys** (`Merge-HashtablePreserve` preserves live-only keys). Key removals (e.g. stale per-agent bash subtrees) require manual live edit during the apply window — same mechanism as the Phase prune step.

---

## Must not

- Add mid-pattern `*` to any allow entry
- Allow any mutating git verb or filesystem-mutation cmdlet
- Duplicate this allowlist into per-agent/stub blocks (single global SoT)
- Treat Fast relief metrics as license to widen scriptblock-capable surface beyond the register

## Related

- [Permission and native tool policy (FA)](../docs/featureArchitecture/permission-and-native-tool-policy.md)
- [Editing companion workflow](../docs/SOPs/editing-companion-workflow.md)
- [Host harness sync](../scripts/host-sync/README.md)
- [OpenCode permissions docs](https://opencode.ai/docs/permissions/)
