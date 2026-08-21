# claude-handoff

- **Skill + snapshot path:** In-progress; `in-progress/claude-handoff`; [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/in-progress/claude-handoff/SKILL.md) and [agent config](https://github.com/mattpocock/skills/blob/0ab1b63/skills/in-progress/claude-handoff/agents/openai.yaml).
- **Verified purpose:** Summarizes the current conversation and launches a fresh background Claude agent using `claude --bg --name`, with suggested skills and redaction requirements.
- **Core mechanism:** Conversation compaction into a clean background session, with the user’s argument treated as the next session’s focus.
- **What it does better:** It makes redaction, descriptive naming, and suggested follow-up skills explicit, and avoids duplicating durable artifacts by pointing to their paths.
- **What cursorEscape does better:** Composer already defines isolated phase handoffs, transcript/audit boundaries, cap-exhausted triage, and no-push behavior. The command is a host-specific launcher, not a portable handoff contract.
- **Host dependency:** Claude CLI and `claude --bg`; user/global job management is assumed.
- **Fit with cursorEscape philosophy:** host-agnostic 2/5; thin-harness 3/5; gate-able 3/5; isolated-reviewable 4/5.
- **Adaptation proposal:** **Reference-only**. Revisit if cursorEscape needs a general user-triggered session handoff distinct from Composer’s phase handoff. Any future version should define a portable handoff schema first and put launch commands in host overlays.
- **Cost + risk:** Medium if generalized; high duplication risk with Composer and high host coupling if copied directly.
- **Verdict:** **Reference-only**.
