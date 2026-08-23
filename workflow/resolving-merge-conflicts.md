# Resolving merge conflicts procedure

**Last updated:** 2026-08-23

Deep companion for the [resolving-merge-conflicts skill](../skills/resolving-merge-conflicts/SKILL.md): a user-invoked Git procedure for working through an active merge, rebase, or cherry-pick conflict hunk by hunk with intent traced to each side's primary source, then verifying and finishing. User-invoked only.

## Merge-state safety

Before touching any file, identify the in-progress operation and record it:

```bash
git status
```

Determine which of merge / rebase / cherry-pick is active (`.git/MERGE_HEAD` for merges, `.git/rebase-merge` or `.git/rebase-apply` directories for rebases, `.git/CHERRY_PICK_HEAD` or the status report for cherry-picks; `git status` names the active operation in all cases) and which commits are involved (`git log --merge -p` for merges; the rebase todo range otherwise). List unmerged paths with `git diff --name-only --diff-filter=U` to inventory the conflict set. Do not run resolution commands until the state is understood. If the working tree contains unrelated uncommitted user work outside conflicted paths, stop and ask the owner how to proceed before staging anything.

## Hunk-by-hunk intent tracing

For each conflicted file, resolve hunk by hunk, not file-wide:

1. Read both sides. For each conflicting hunk, find what each side intended: `git log` on the conflicting path from each parent, commit messages, and where they exist PRs, tickets, or review threads.
2. State the intent per side in one line before choosing a resolution.
3. Preserve both intents where compatible. Where intents are truly incompatible, pick the one matching the merge's stated goal (branch purpose, ticket scope) and note the trade-off in the session record.
4. Never invent new behavior to paper over a conflict. A synthesized "compromise" that neither side wrote is a bug.

Intent evidence is mandatory: a resolution chosen without at least one traced source per side is not done.

## Abort policy

The default is resolve-and-finish. `--abort` (and `--quit`/`--skip`) is permitted only on explicit owner authorization for this specific operation; if the owner authorizes an abort, confirm the destructive consequence first (in-progress work on both sides is discarded back to pre-operation state). The agent never aborts on its own judgment.

## Verification

Discover the project's automated checks and run them in the repo's normal order — typically typecheck, then tests, then format. Use the repo's [ci-ladder](ci-ladder.md) Fast/Full tiers where defined. Fix anything the merge broke; a fix that changes behavior beyond merging the two sides belongs to a new change through the normal implementation and review loop, not to conflict resolution.

## Finish

Completion steps are proposed to the owner, never executed as a silent commit:

- Stage only the resolved paths; the agent stages these itself, then presents - never executes - the proposed completion command (`git commit` for a merge, `git rebase --continue` during a rebase, `git cherry-pick --continue` during a cherry-pick).
- The agent never commits on behalf of the user during conflict resolution; final commit authority stays with the owner's existing pre-commit/commit gates.
- After completion, re-run the Fast tier once to confirm the finished state.

## Destructive-command boundary

During conflict work the agent never runs `reset --hard`, `clean`, force-push, filter/history rewriting, branch deletion, or checkout of a different branch. These require separate explicit owner authorization outside this procedure.

## Related

- [Resolving-merge-conflicts skill](../skills/resolving-merge-conflicts/SKILL.md)
- [Workflow docs index](_index.md)
- [Pre-commit CI gate](../rules/pre-commit-ci-gate.md) (commit authority)
- [Diagnosing-bugs procedure](diagnosing-bugs.md) (when a merged result misbehaves later)
