# Local scratch

## Purpose

`.scratch/` is the local-only boundary for durable-but-temporary artifacts: useful across turns or sessions, but not repository documentation or expected behavior. It supplements, and never replaces, the docs, roadmap, implementation, review, or specialized-scratch policies.

## Boundary

1. Resolve `/.scratch/` against the active repository or worktree root. If no repository or worktree root exists, ask the owner; do not invent a fallback.
2. Create the boundary only when intentionally persisting a scratch artifact. At that creation, add `.scratch/.gitignore` containing exactly `*` and ensure `.scratch/plans/` exists.
3. Keep other scratch paths ad hoc. Do not scaffold them merely because the rule is loaded.

## Saved plans

Save every intentionally persisted planning artifact as `/.scratch/plans/<plan-id>.md`. Use an owner/parent-selected `plan-id`, normally `YYYY-MM-DD-slug`. If the filename belongs to a different task, choose a disambiguated filename; if it is the same active task, edit the same file in place.

An active scratch plan is the task-local plan of record and may be its temporary source of truth. It is not durable repository documentation. Long-lived direction belongs to an owner-approved roadmap under existing policy; promotion requires explicit owner instruction.

## Boundaries

- Do not commit scratch.
- Do not enumerate, inventory, clean, or delete scratch automatically.
- Do not promote scratch into durable docs, plans, rules, roadmaps, or other repository-owned contract surfaces without explicit owner instruction.

## Related

- [Local scratch rule](../rules/local-scratch.md)
- [Iterative plan review](iterative-plan-review.md)
