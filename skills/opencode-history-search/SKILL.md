---
name: opencode-history-search
description: Search and extract past OpenCode sessions and chat history. Use when looking for prior sessions, transcripts, tool-call records, or answers the user remembers from earlier OpenCode conversations; includes CLI commands, export, and direct SQLite fallback with schema gotchas.
---

# Searching OpenCode chat history

Find past sessions and extract their content. Approach in tiers, cheapest
tool first. Verified against opencode **1.4.6** (2026-08-26).

## Tier 1: list sessions (no SQL)

```powershell
opencode session list --format json -n 20
```

```bash
opencode session list --format json -n 20
```

JSON output includes id, title, and timestamps. Titles come from `--title` at
run time or a truncated prompt, so well-titled sessions are findable here.

## Tier 2: export a full transcript

```powershell
opencode export <sessionID> > transcript.json
opencode export <sessionID> --sanitize > transcript-shared.json   # redacts sensitive data
```

The export contains messages with their parts: assistant/user text, tool calls,
and results. This is usually all you need once you know the session id.

## Tier 3: query the database directly

```powershell
opencode db path                          # locate the SQLite file
opencode db "SELECT id, title FROM session LIMIT 5" --format json
```

## Tier 4: direct SQLite (fallback for anything the CLI cannot express)

Open the database read-only:

```powershell
python -c "import sqlite3; print(sqlite3.connect('file:$env:USERPROFILE/.local/share/opencode/opencode.db?mode=ro', uri=True))"
```

Schema reality (matters \u2014 the obvious queries fail without it):

| Table | Reality |
|-------|---------|
| `session` | `id` is a 30-char string; `directory`; `time_created`/`time_updated` are **milliseconds** epoch |
| `part` | The authoritative content store: JSON `data` per row, `session_id`, `message_id` |
| `message` | Often empty. Do not build queries on it |

Part rows carry `"type"` of `text`, `reasoning`, or `tool`. Assistant/user text
lives at `$.text`; tool input lives at `$.state.input`.

Useful queries:

```sql
-- recent sessions touching a repo (directory forms vary: always LIKE)
SELECT id, title, datetime(time_updated/1000,'unixepoch') AS updated
FROM session WHERE directory LIKE '%openBuggy%'
ORDER BY time_updated DESC;

-- text parts of one session, in order
SELECT json_extract(data,'$.type') AS type,
       json_extract(data,'$.text') AS txt
FROM part WHERE session_id = '<full-30-char-id>'
ORDER BY COALESCE(time_created,0);

-- every tool call made in a date range
SELECT session_id, json_extract(data,'$.tool') AS tool
FROM part
WHERE json_extract(data,'$.type') = 'tool'
  AND time_created > 1787000000000;
```

## Traps that waste the most time

1. **Truncated ids.** Session ids display truncated (~28 of 30 chars). An
   equality query on a copied-from-screen id returns nothing. Recover the full
   value with `SELECT id FROM session WHERE id LIKE 'ses_...prefix%'`.
2. **Directory forms vary** (`C:\...`, relative, machine-prefixed). Never use
   equality; use `LIKE '%reponame%'`.
3. **Millisecond epochs.** Divide by 1000 before `datetime(...)`.
4. **The `message` table can be empty** while `part` holds everything.
5. **WAL sidecars.** A read-only open still needs write access to `-shm`/`-wal`
   while a writer is active; "database is locked" means another OpenCode is
   running, not corruption.

## Reference

Official documentation: https://opencode.ai/docs/cli/#db , #export , #session
(verified 2026-08-26). Deeper internals: {{COMPANION_ROOT}}/skills/opencode-history-search/reference-history-internals.md (read on demand, companion root).
