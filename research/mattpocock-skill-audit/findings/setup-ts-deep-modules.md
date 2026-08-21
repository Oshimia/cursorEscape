# setup-ts-deep-modules

- **Skill + snapshot path:** In-progress; `in-progress/setup-ts-deep-modules`; [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/in-progress/setup-ts-deep-modules/SKILL.md), [config companion](https://github.com/mattpocock/skills/blob/0ab1b63/skills/in-progress/setup-ts-deep-modules/dependency-cruiser.config.cjs).
- **Verified purpose:** Installs dependency-cruiser and configures a TypeScript repository so package internals remain behind root entry points, with tests importing through those entry points. It scaffolds an example package and proves the rule with pass/fail/pass checks.
- **Core mechanism:** Path-depth dependency-cruiser rules for entry-point boundaries, test privacy, intra-package freedom, and cycles, plus an intentional violating test to prove enforcement.
- **What it does better:** It treats a non-failing rule as worthless and explicitly tests that the boundary rejects a deep import. The “entry points, not a barrel” distinction is useful design vocabulary.
- **What cursorEscape does better:** cursorEscape is not a TypeScript package monorepo and already has architecture documentation for deep modules and seams without dependency-cruiser enforcement. Adding this would confuse a product-specific static rule with the companion’s file layout.
- **Host dependency:** TypeScript, dependency-cruiser, package-manager lockfiles, `src/packages`, and package scripts; config is supplied at the pinned path above.
- **Fit with cursorEscape philosophy:** host-agnostic 1/5; thin-harness 2/5; gate-able 3/5; isolated-reviewable 3/5.
- **Adaptation proposal:** **Reject** for this repository. The deep-module concept remains a useful reference, but implementation belongs in a TypeScript product repository.
- **Cost + risk:** High relative cost and high scope drift; it would add dependencies, config, examples, and CI assumptions unrelated to the companion.
- **Verdict:** **Reject**.
