# Git & shell-filesystem red line

**Last updated:** 2026-08-28

Single SoT for the mutating-git / shell-fs red line. Moved wholesale from
[rules/shell-native-tool-policy.md](./shell-native-tool-policy.md) (D9 mechanical move, 2026-08-28) —
content-preserving SoT re-location; shell-native-tool-policy.md remains the SoT for the read-only
allowlist invariants and references this leaf for the red line.

---

## Red line (Required)

Mutating git **always prompts**: `add`, `commit`, `push`, `pull`, `merge`, `rebase`, `reset`, `checkout`, `switch`, `restore`, `revert`, `cherry-pick`, `stash` (except `list*`/`show*`), `tag` (creation/move/delete), `clean`, `config` (set/unset), `branch` (create/delete/rename/copy), `remote` (add/rename/remove/set-url/prune/update), `worktree` (add/remove/move/prune), `reflog` (expire/delete). Searching commits is fine; rebasing the head is not. Looking at logs is fine; making a commit is not.

Do not chain mutating verbs onto allowed reads to dodge the gate — compound commands are checked per segment and each mutating segment still asks.

Shell-native filesystem mutations (`Set-Content`, `New-Item`, `Remove-Item`, `Copy-Item`, `Move-Item`, `Rename-Item`) and scriptblock-carrying pipeline stages (`ForEach-Object {…}`, `Where-Object {…}`) stay prompt-gated. The accepted-risk and residual-ask registers for these allow decisions are [Accepted risks](#accepted-risks-owner-accepted-balanced-posture) and [Residual known asks](#residual-known-asks-not-failures) below.

## Accepted risks (owner-accepted Balanced posture)

| Risk | Why accepted |
|---|---|
| `python*` = arbitrary-code permit | Dominant legitimate use is read-only sqlite/log analysis (48+ asks in window); blanket deny would recreate the babysitting tax |
| `rg --pre <cmd>` executes preprocessor command | Obscure; native `grep` preferred by instruction anyway |
| Scriptblock-capable allowed cmdlets (`Select-Object` calculated properties, `Sort-Object`/`Group-Object` custom expressions) can execute mutating code inside an allowed pipeline | Contrived; red-line intent is git history/structure and routine fs safety, not adversarial self-hosting |
| `git difftool` matches `git diff*` | External viewer, read-only intent |
| `git config --get*` cannot reach mutating modes (`--add`/`--unset`/`--replace-all` are disjoint flags git rejects in combination) | Verified flag semantics |

## Residual known asks (not failures)

Expected to keep prompting; exclude from soak-failure counts: `git show-ref`, `git symbolic-ref`, `git ls-remote`, patterned branch/tag listing (use the allowlist's escape hatch), binary version checks outside the allowlist (`node -v` etc.), `git reflog <ref>` with explicit ref.

---

## Related

- [Shell & native tool policy](./shell-native-tool-policy.md) (read-only allowlist invariants remain there)
- [Permission and native tool policy (FA)](../docs/featureArchitecture/permission-and-native-tool-policy.md)
