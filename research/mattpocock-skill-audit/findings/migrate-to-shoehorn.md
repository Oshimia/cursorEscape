# migrate-to-shoehorn

- **Skill + snapshot path:** Misc; `misc/migrate-to-shoehorn`; [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/misc/migrate-to-shoehorn/SKILL.md)
- **Verified purpose:** Replaces TypeScript test assertions with `@total-typescript/shoehorn`, choosing `fromPartial`, `fromAny`, or `fromExact` for partial, intentionally invalid, or exact test data.
- **Core mechanism:** A narrow migration mapping from `as Type` to `fromPartial()` and double assertions to `fromAny()`, followed by type checking.
- **What it does better:** It distinguishes intentionally invalid test data from partial valid data and explicitly says the dependency is test-code-only.
- **What cursorEscape does better:** cursorEscape is a workflow/agent manager, not a TypeScript application or test suite. Its source/overlay rules prevent importing this stack-specific recipe into shared contracts.
- **Host dependency:** TypeScript, npm, and the `@total-typescript/shoehorn` package; test-file naming assumptions.
- **Fit with cursorEscape philosophy:** host-agnostic 1/5; thin-harness 2/5; gate-able 2/5; isolated-reviewable 2/5.
- **Adaptation proposal:** **Reject**. This is an application migration recipe with no meaningful local use or reusable workflow capability.
- **Cost + risk:** Low direct value; dependency and TypeScript assumptions create unnecessary maintenance and scope drift.
- **Verdict:** **Reject**.
