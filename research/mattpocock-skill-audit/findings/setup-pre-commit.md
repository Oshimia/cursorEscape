# setup-pre-commit

- **Skill + snapshot path:** Misc; `misc/setup-pre-commit`; [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/misc/setup-pre-commit/SKILL.md)
- **Verified purpose:** Detects a JavaScript package manager, installs Husky/lint-staged/Prettier, creates a pre-commit hook, and runs typecheck/tests where scripts exist. It ends by staging and committing the setup.
- **Core mechanism:** Repository mutation recipe for Husky plus staged formatting and full type/test checks.
- **What it does better:** It checks package-manager lockfiles and adapts missing `typecheck` or `test` scripts instead of assuming every repository has both. It also gives a concrete verification checklist.
- **What cursorEscape does better:** The local `pre-commit-ci-gate` is a policy gate, not a JavaScript tool installer, and the repo’s host-sync/overlay architecture avoids assuming Husky, npm scripts, or a Node project. Automatic commit conflicts with local authority rules.
- **Host dependency:** Strongly JavaScript/Node and Husky-specific; commands are npm-oriented with limited substitution.
- **Fit with cursorEscape philosophy:** host-agnostic 1/5; thin-harness 2/5; gate-able 3/5; isolated-reviewable 2/5.
- **Adaptation proposal:** **Reject** for cursorEscape. Retain the checklist as research only; project-specific CI setup belongs in the target product repository.
- **Cost + risk:** Medium implementation cost, high ecosystem assumptions, and high risk of conflicting with repository-specific hooks or user changes.
- **Verdict:** **Reject**.
