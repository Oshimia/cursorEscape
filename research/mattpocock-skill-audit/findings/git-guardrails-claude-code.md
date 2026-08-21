# git-guardrails-claude-code

- **Skill + snapshot path:** Misc; `misc/git-guardrails-claude-code`; [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/misc/git-guardrails-claude-code/SKILL.md) and [hook script](https://github.com/mattpocock/skills/blob/0ab1b63/skills/misc/git-guardrails-claude-code/scripts/block-dangerous-git.sh).
- **Verified purpose:** Installs a Claude Code `PreToolUse` hook that blocks push, hard reset, clean, force branch deletion, and destructive checkout/restore commands. It asks for project/global scope and customization before installation.
- **Core mechanism:** Shell pattern matching over the incoming tool command, returning exit code 2 for blocked patterns.
- **What it does better:** It provides an executable safety boundary before a dangerous command runs, with a concrete verification input. The block list is easy to inspect and customize.
- **What cursorEscape does better:** cursorEscape separates portable contracts from host mechanics and already forbids push through workflow while using operator-gated host sync. Regex matching is not a general parser and can evade or overblock.
- **Host dependency:** Claude Code-only: `PreToolUse`, `Bash`, `$CLAUDE_PROJECT_DIR`, and `~/.claude` paths.
- **Fit with cursorEscape philosophy:** host-agnostic 1/5; thin-harness 2/5; gate-able 3/5; isolated-reviewable 2/5.
- **Adaptation proposal:** **Reject** as a local skill. A future host adapter could add additive safety, but it must be authored in a Claude-specific overlay and cannot become a shared Git policy.
- **Cost + risk:** Medium maintenance cost for hook installation and settings merging; high portability and false-negative risk; overlap with existing host safety rules.
- **Verdict:** **Reject**.
