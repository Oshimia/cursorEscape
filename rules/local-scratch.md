# Local scratch (conditional)

Apply when intentionally persisting a durable-but-temporary artifact or saving a plan.

- Use `/.scratch/` as the single local scratch root in the active repository or worktree.
- Save every filesystem plan as `/.scratch/plans/<plan-id>.md`; edit that file in place.
- On first scratch persistence, create `.scratch/.gitignore` containing exactly `*` and `.scratch/plans/`.
- Do not commit, enumerate, clean, or promote scratch automatically.
- If scratch is known to be tracked or an explicit specialized scratch policy applies, stop and ask the owner; that policy takes precedence.

Before first scratch use in a session, read [workflow/local-scratch.md]({{COMPANION_ROOT}}/workflow/local-scratch.md).
