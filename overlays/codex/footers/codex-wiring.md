## Codex skills and pointers

The installed catalog has 23 thin wrappers. Invoke the exact `$skill-id`; load the matching canonical skill before non-trivial work. `opencode-headless-run` and `opencode-history-search` are **explicit-only**. For deep procedure reads, use the absolute companion paths under `{{COMPANION_ROOT}}`; never treat host-local files as procedure source-of-truth. When acting as Composer after resume or compaction, reread canonical `composer/SKILL.md` and the active roadmap first.

## Isolation and safety boundaries

Reviewers and `plan_reviewer` run as isolated custom agents. The parent synthesizes each invocation payload, owns implementation and recovery, and does not paste prior child transcripts. Read-only reviewers return findings only; they do not edit, run writes, install, commit, push, or rerun CI. Never modify `config.toml`, authentication, history, logs, sessions, databases, or unrelated host state. Every spawned child-agent launch uses the canonical envelope in `{{COMPANION_ROOT}}/workflow/agent-invocation.md`; missing, malformed, contradictory, or unreadable envelopes fail loudly.

## Subagent cleanup

After consuming each spawned agent's final result, the parent calls `close_agent` unless the agent is intentionally persistent with a stated reason. Before the final response, close all non-persistent completed descendants.
