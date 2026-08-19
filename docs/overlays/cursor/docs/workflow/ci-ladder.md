# CI ladder (Fast / Full)

Discover commands from README, `package.json`, `Makefile`, `scripts/`, `.github/workflows/`, or AGENTS.md. Also see [discovery.md](discovery.md).

| Tier | Meaning | When | Reviewers? | Sufficient for commit? |
|------|---------|------|------------|------------------------|
| **Fast** | Quickest meaningful lint/test for touched areas | Every review-loop iteration | Yes (after Fast passes) | No |
| **Full** | Commit-grade suite | Closeout after dual APPROVED; before `git commit` | No | Yes |

## Mapping

1. Repo documents Fast/Full (or Quick/Full) → use those commands
2. Else package/Make/GHA lint+test → Fast = focused on touched areas; Full = all available checks (+ typecheck if present)
3. Else single check → Fast = Full = that check (degraded; note in closeout)
4. Else none → Fast/Full = `n/a`; still run dual review; commit only after **explicit user acknowledgment** that no Full suite exists

If a project `.cursor/rules/pre-commit-ci-gate.mdc` (or equivalent) exists, **follow it** for Full/commit — it overrides this ladder’s Full mapping for that repo.

**Never** launch Reviewer A or Bugbot until Fast passes (when Fast is not `n/a`). **Never** launch on **skipped** Fast checks when Fast is not `n/a`, or on **claimed-only** evidence (prose “Fast CI passed” / `ci: pass` with no per-command rows). Parent CI blocks must list each command actually run: `pass|fail|skipped|n/a`. **Never** pair reviewers with Full CI.

## Related

- [iterative-code-review.md](iterative-code-review.md)
- [implementation-review](../../skills/implementation-review/SKILL.md)
- [composer](../../skills/composer/SKILL.md)
- [README.md](README.md)
