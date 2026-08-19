# Pre-commit CI gate (fallback)

**Fallback only.** If the project has `.cursor/rules/pre-commit-ci-gate.mdc` (or equivalent), **follow that** — do not apply a second Full command set.

Otherwise:

1. Map Fast/Full via `workflow/ci-ladder.md` (and project README/scripts).
2. Before any `git commit`, Full must pass — or Full = `n/a` with **explicit user acknowledgment**.
3. Never substitute Fast for Full when Full exists.
4. If install/test steps fail due to locked `node_modules` / busy processes, ask the user to stop those processes and re-run Full.

**Composer:** same Full (or `n/a` ack) before automatic local phase commits; never `git push`.

## When to use (Required when committing)

- Before any `git commit` (implementer or Composer phase commit)
- When Full ≠ `n/a` after dual APPROVED closeout
- On-demand load — **not** injected every turn

## Must not

- Always-inject this policy into every agent turn
- Invent hardcoded cross-repo npm / test suites
- Treat Fast CI as commit-grade when Full exists
- Pair Full CI with dual-gate reviewer launch

## Related

- [implementation-review](../skills/implementation-review/SKILL.md)
- [composer](../skills/composer/SKILL.md)
- [ci-ladder](../workflow/ci-ladder.md)
