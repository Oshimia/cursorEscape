# scaffold-exercises

- **Skill + snapshot path:** Misc; `misc/scaffold-exercises`; [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/misc/scaffold-exercises/SKILL.md)
- **Verified purpose:** Creates numbered course exercise directories, readmes, and optional code stubs, then runs `pnpm ai-hero-cli internal lint` and commits the result.
- **Core mechanism:** Naming and folder-shape convention plus a repository-specific linter-driven scaffold recipe.
- **What it does better:** It gives precise structural validation, including non-empty readmes, no `.gitkeep`, no speaker notes, and link checks. It distinguishes problem, solution, and explainer variants.
- **What cursorEscape does better:** cursorEscape does not contain exercises or the upstream CLI, and its commit/review authority is separated from an implementation skill. Copying this would create a false product surface.
- **Host dependency:** Upstream course repository layout, `pnpm`, and `ai-hero-cli`.
- **Fit with cursorEscape philosophy:** host-agnostic 1/5; thin-harness 2/5; gate-able 2/5; isolated-reviewable 1/5.
- **Adaptation proposal:** **Reject**. The directory convention is not a transferable cursorEscape capability.
- **Cost + risk:** Low implementation cost but zero local leverage; high risk of importing unrelated course assumptions.
- **Verdict:** **Reject**.
