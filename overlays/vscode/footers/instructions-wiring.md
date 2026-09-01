## VS Code harness pointers

Thin harness. Host: VS Code Copilot, user-level surface at `~/.copilot/` (instructions/agents/skills; Agent Host-compatible).

- **Skills** live at `~/.copilot/skills/` and appear both as slash commands (`/discovery`, `/plan-review`, …) and as description-triggered on-demand loads. Owner-invoked skills (`disable-model-invocation: true`) run via `/slash` only. Load the matching id before non-trivial work.
- **Agents** live at `~/.copilot/agents/` — user-selectable from the agents dropdown. Reviewer agents carry read-only `tools` arrays. Note: subagents cannot spawn further subagents (depth 1); parent fans out to reviewers in one turn.
- **Handoffs:** planner → implementer → reviewer transitions are wired as `handoffs` buttons in agent frontmatter; prefer them over re-typing loop steps.
- **Verification:** Diagnostics view (right-click Chat → Diagnostics) lists loaded instructions/agents/skills. Empty skill or agent surface = discovery failure, fail loud.
- Do **not** use shell to list or discover adapter SoT under `~/.copilot`. Empty `glob`/`grep` on gitignored or out-of-workspace paths is often **tool blindness**, not proof of absence; prefer absolute reads of companion procedure paths.
- Prefer native tools over shell equivalents: reads via view/read tools, search via grep tools, discovery via glob tools. Git red line: read/discovery git pre-allowed; all mutating git verbs prompt — the pre-commit gate is the only sanctioned path to a local commit, after dual APPROVED + Full CI; never `git push`.
