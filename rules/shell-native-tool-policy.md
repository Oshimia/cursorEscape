# Shell & native tool policy

**Last updated:** 2026-08-22

## Context

Always-on gate contract for shell usage and permissions across hosts. Companion SoT (Target): this file owns the canonical read-only bash allowlist and the accepted-risk register; the mutating-git / shell-fs **red line moved to [red-line.md](./red-line.md)** (D9 mechanical move 2026-08-28 — that leaf is the red-line SoT, this file keeps the allowlist invariants). Host harnesses **echo** it (OpenCode echo lands via `overlays/opencode/opencode.specimen.json` + C1 dual-write in Phase 2, live on next operator `-Apply`; Cursor thin wrapper **deferred — required before the first Cursor live sync**). Design rationale: [permission-and-native-tool-policy](../docs/featureArchitecture/permission-and-native-tool-policy.md).

Origin: OpenCode log analysis (window 2026-08-17→21, as of 2026-08-22 via [scripts/analyze-permission-asks.py](../scripts/analyze-permission-asks.py)) — 558 permission prompts (415 bash, 142 external_directory); 87% of bash asks came from read-only work in subagent review/plan sessions ([FA leaf](../docs/featureArchitecture/permission-and-native-tool-policy.md)).

---

## Substance

### Red line (Required)

Moved wholesale → [red-line.md](./red-line.md) (D9 mechanical move 2026-08-28; this leaf is not the SoT for the red line, only for the read-only allowlist invariants below).

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

Patterned listing escape hatch: `git branch --list <pat>` / `git tag -l <pat>` intentionally prompt — use allowed `git for-each-ref refs/heads/<pat>` or `refs/tags/<pat>` instead (pure read verb, wildcard-safe). Escape-hatch exceptions to the red line live in [red-line.md](./red-line.md) (single red-line SoT).

### Risk register (pointer)

Accepted-risk entries and residual known asks moved with the red line → [red-line.md](./red-line.md#accepted-risks-owner-accepted-balanced-posture) (D9 mechanical move 2026-08-28; one register, one home).

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

- [Red line (red-line SoT)](./red-line.md)
- [Permission and native tool policy (FA)](../docs/featureArchitecture/permission-and-native-tool-policy.md)
- [Editing companion workflow](../docs/SOPs/editing-companion-workflow.md)
- [Host harness sync](../scripts/host-sync/README.md)
- [OpenCode permissions docs](https://opencode.ai/docs/permissions/)
