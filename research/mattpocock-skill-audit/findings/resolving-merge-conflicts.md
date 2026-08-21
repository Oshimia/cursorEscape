# resolving-merge-conflicts

- **Skill + snapshot path:** Tier 3; `engineering/resolving-merge-conflicts`; [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/resolving-merge-conflicts/SKILL.md)
- **Verified purpose:** Resolves an active merge or rebase by inspecting state, tracing each hunk to primary intent, resolving without aborting, running checks, and finishing the operation.
- **Core mechanism:** Hunk-by-hunk intent tracing followed by verification and completion. The key constraint is “Always resolve; never `--abort`.”
- **What it does better:** It explicitly requires commit history, PRs, and original issues as evidence before choosing between incompatible changes. That is sharper than a generic conflict checklist.
- **What cursorEscape does better:** The local workflow has stronger scope ownership, CI ladder, review gates, and destructive-command prohibitions. A conflict resolver should not bypass those gates or commit on behalf of the user.
- **Host dependency:** Portable Git workflow; the exact PR/issue sources may not exist in every repository.
- **Fit with cursorEscape philosophy:** host-agnostic 5/5; thin-harness 4/5; gate-able 4/5; isolated-reviewable 4/5.
- **Adaptation proposal:** **Adapt** into a small Git-specific skill or workflow page. Retain evidence-first hunk resolution and completion, but allow an explicit user-authorized abort when repository policy requires it, and delegate final commit authority to the existing local workflow. It should read repo SOPs and use existing pre-commit/Full CI rules.
- **Cost + risk:** Low to medium authoring cost; moderate risk around merge state, user-owned changes, and destructive commands; little conceptual overlap with current skills.
- **Verdict:** **Adapt**.
- **Proposed roadmap phase:** Add a portable merge-conflict procedure under `skills/` or `workflow/`, integrating discovery, user-owned Git boundaries, and existing CI/commit gates.
