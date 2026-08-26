---
name: opencode-history-search
description: >-
  Search and extract past OpenCode sessions and chat history. Use when looking
  for prior sessions, transcripts, tool-call records, or answers the user
  remembers from earlier OpenCode conversations; includes CLI commands, export,
  and direct SQLite fallback with schema gotchas.
---

# Searching OpenCode chat history (OpenCode harness)

Thin harness. Full procedure: Read `{{COMPANION_ROOT}}/skills/opencode-history-search/SKILL.md`.

## When to use

Finding prior sessions/transcripts; recovering answers or decisions from earlier
conversations; auditing what tools a past session ran.

## Read when

| Doc | When |
|-----|------|
| [SKILL.md]({{COMPANION_ROOT}}/skills/opencode-history-search/SKILL.md) | Tiered search (list / export / db query), traps table (truncated ids, directory forms, ms epochs) |
| [reference-history-internals.md]({{COMPANION_ROOT}}/skills/opencode-history-search/reference-history-internals.md) | DB schema walkthrough, part-data field map, SQL cookbook |

## Must not

- Query `message` as the content store (it is frequently empty; `part` holds everything)
- Use display-truncated session ids in equality queries
