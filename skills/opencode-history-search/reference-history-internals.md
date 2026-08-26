# opencode-history-search internals

Verified against opencode 1.4.6 (2026-08-26). Database located via
`opencode db path` \u2014 observed: `~/.local/share/opencode/opencode.db`
(WAL mode; `-shm`/`-wal` sidecars present while any OpenCode runs).

## Tables that matter

### session

| Column | Notes |
|--------|-------|
| `id` | TEXT, exactly 30 chars, `ses_` prefix. UIs truncate display; queries need the full value |
| `directory` | Project path as recorded at session start. Forms vary across machines/launch styles |
| `title` | Set by `--title` or truncated first prompt |
| `time_created`, `time_updated` | Milliseconds since epoch |

### part

The content store. One row per message part.

| Column | Notes |
|--------|-------|
| `session_id`, `message_id` | Ownership |
| `data` | JSON blob. `"type"` is one of `text`, `reasoning`, `tool` |
| `time_created` | Milliseconds epoch; may be NULL on some rows |

JSON field map inside `part.data`:

| Field path | Present for | Content |
|------------|-------------|---------|
| `$.text` | text parts | Assistant/user prose |
| `$.type` | all | Part discriminator |
| `$.tool` | tool parts | Tool name |
| `$.state.input` | tool parts | Tool call arguments (object) |
| `$.state.output` / `$.state.error` | tool results | Outcome data |

### message

Frequently empty even for active sessions. Treat `part` as the source of truth
and ignore `message`.

## Query cookbook

```sql
-- All sessions for a repo, newest first
SELECT id, title,
       datetime(time_updated/1000,'unixepoch') AS updated
FROM session
WHERE directory LIKE '%openBuggy%'
ORDER BY time_updated DESC;

-- Full ordered transcript of one session
SELECT json_extract(data,'$.type') AS type,
       json_extract(data,'$.text') AS txt,
       json_extract(data,'$.tool') AS tool
FROM part
WHERE session_id = '<full-id>'
ORDER BY COALESCE(time_created,0);

-- Find sessions where a specific file was edited
SELECT DISTINCT p.session_id, s.title
FROM part p JOIN session s ON s.id = p.session_id
WHERE p.data LIKE '%the-file-name.ext%'
  AND json_extract(p.data,'$.type') = 'tool';

-- Assistant text only, date-bounded
SELECT json_extract(data,'$.text') AS txt
FROM part
WHERE session_id = '<full-id>'
  AND json_extract(data,'$.type') = 'text'
  AND time_created BETWEEN 1787000000000 AND 1787086400000
ORDER BY COALESCE(time_created,0);
```

## Access notes

- Open read-only with URI mode:
  `sqlite3.connect('file:<path>?mode=ro', uri=True)`.
- While an OpenCode process is live, the `-wal`/`-shm` sidecars are hot.
  Read-only opens still require write permission on those sidecar files;
  "database is locked" during active sessions is normal contention, not
  corruption. Retry or copy the trio (`db`, `-wal`, `-shm`) and query the copy.
- The CLI alternatives cover most needs without SQL: `session list --format
  json`, `export <id> [--sanitize]`, and `db [query] --format json`.
- A bulk exporter exists in openBuggy:
  `eval/scripts/export_opencode_transcript.py` (normalizes tool-call parts into
  Cursor-style JSONL for audits).
