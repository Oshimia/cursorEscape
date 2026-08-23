---
name: resolving-merge-conflicts
description: >-
  User-invoked Git procedure for an active merge, rebase, or cherry-pick
  conflict: state inspection first, hunk-by-hunk intent tracing to each
  side's primary source, verification through the project's checks, and
  owner-owned completion. Abort only on explicit user authorization.
disable-model-invocation: true
---

# Resolving merge conflicts

## When to use

The owner is inside an active merge, rebase, or cherry-pick with conflicts and asks for help resolving them. Not for planning merges or reviewing diffs; if no conflict exists yet this skill does not apply.

## Workflow

The companion procedure defines the gated sequence; the caller owns invocation and every abort/finish decision. Follow its order: merge-state inspection, hunk-by-hunk intent tracing, verification, then owner-approved finish. Do not skip intent evidence for any hunk.

## Outputs

Resolved conflict hunks with per-hunk intent notes in the conversation, plus a proposed (not executed) completion command. The agent never commits on behalf of the user.

## Read

- [Merge-conflict resolution procedure](../../workflow/resolving-merge-conflicts.md)

## Must not

Never run `--abort`, `--quit`, or `--skip` without explicit owner authorization for that operation; never commit on behalf of the user; never run destructive commands (`reset --hard`, `clean`, force operations, history rewriting) during conflict work; never resolve a hunk without tracing both sides' intent; never invent compromise behavior neither side wrote.

## Related roles

The owner authorizes aborts and executes final commits. The agent inspects state, traces intent, resolves hunks, runs verification checks, and proposes completion steps.

## Provenance

Adapted from the pinned mattpocock/skills snapshot at commit 0ab1b63: [source skill](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/resolving-merge-conflicts/SKILL.md). The upstream always-resolve-never-abort hard line became a default-with-explicit-user-authorization policy, and upstream's stage-and-commit step was replaced by owner-owned commit authority.
