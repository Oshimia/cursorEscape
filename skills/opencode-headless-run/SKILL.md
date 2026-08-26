---
name: opencode-headless-run
description: Run reliable headless (non-interactive) OpenCode sessions with opencode run. Use when scripting OpenCode, automating reviews or tasks, wiring CI agents, or debugging headless failures like empty answers, permission denials, or Session not found errors.
---

# Headless OpenCode sessions

Run OpenCode programmatically with `opencode run`. This skill covers invocation,
permissions, output capture, response validation, and retry policy. Verified
against opencode **1.4.6** on Windows (2026-08-26); re-check `opencode --version`
and `opencode run --help` if behavior seems off.

{{COMPANION_ROOT}}/skills/opencode-headless-run/reference-cli.md — read on demand (companion) alongside this
file. Official documentation: https://opencode.ai/docs/cli/

## Environment hygiene (do this first)

Inherited environment variables change headless behavior silently:

- `OPENCODE_CLIENT`, `OPENCODE_SERVER_PASSWORD`, `OPENCODE_SERVER_USERNAME` set by
  the desktop app break fresh runs with `Error: Session not found`.
- Clear every `OPENCODE_*` variable before launching unless you specifically need one:

```powershell
Get-ChildItem env: | Where-Object { $_.Name -like 'OPENCODE*' } |
    ForEach-Object { Remove-Item "env:$($_.Name)" }
```

```bash
env | grep ^OPENCODE_ | cut -d= -f1 | xargs -r -n1 -I{} env -u {}
```

## Basic invocation

```powershell
opencode run --dir <workspace> --agent <agent> -m <provider/model> `
    --title <findable-name> "<prompt>" *> <log-file>
```

```bash
opencode run --dir <workspace> --agent <agent> -m <provider/model> \
    --title <findable-name> "<prompt>" > <log-file> 2>&1
```

Key flags:

| Flag | Purpose |
|------|---------|
| `--dir` | Working directory for the session |
| `--model provider/model` | Model selection (`opencode models` lists choices) |
| `--agent` | Agent to use (controls permissions and persona) |
| `--title <name>` | Name the session now so history search finds it later |
| `-s <id>` / `-c` / `--fork` | Continue a specific/last session, optionally forked |
| `--format json` | Raw JSON event stream instead of formatted text (for scripting) |
| `-f <file>` | Attach files to the message |

Exit code 0 means the process finished. It does NOT mean the task succeeded:
see "Permission asks resolve as silent denial" below.

## Permissions: the part that breaks headless runs

OpenCode permission actions are `allow`, `ask`, `deny`. Global defaults are
mostly `allow`, but two default to `ask`: `doom_loop` (same tool call repeated
3x) and `external_directory` (touching paths outside `--dir`). `.env` reads are
denied by default.

In a headless session there is no TTY to answer an `ask`. Observed behavior on
1.4.6: the tool call is **denied silently**, the model improvises around it, and
the process exits 0. You get a confident answer that skipped the step you asked
for. Exit codes will not tell you. Validate output substance (next section), and
prefer explicit agent files over defaults.

Rules of thumb:

- Give each automation its own agent file (`.opencode/agent/<name>.md`) with an
  explicit `permission:` frontmatter block. Allow what the task needs, deny the
  rest.
- Never use `--dangerously-skip-permissions` for scripted work.
- Deny `external_directory` explicitly unless the task truly must reach outside.
- Agent frontmatter merges over global config and wins.

## Validating responses

Check the captured log for all of these before trusting a run:

1. Non-empty, on-topic response (reject template echoes, protocol dumps, text
   truncated mid-sentence).
2. Evidence the requested work happened: expected tool calls, expected output
   markers, or deliverable files present on disk.
3. If your prompt defines a terminal delimited block or marker, confirm it
   appears intact.

On validation failure, retry with backoff (about 20 seconds times attempt,
budget of 3). Retry only the failure classes above; do not retry to average out
quality.

## Repeated runs: serve once, attach many

Each `run` boots its own server instance. For batches, start one server and
attach:

```powershell
Start-Process opencode -ArgumentList 'serve', '--port', '4096'
opencode run --attach http://localhost:4096 --dir <ws> "first task"
opencode run --attach http://localhost:4096 --dir <ws> "second task"
```

```bash
opencode serve &
opencode run --attach http://localhost:4096 --dir <ws> "first task"
```

Set `OPENCODE_SERVER_PASSWORD` before `serve` if other local users exist.

## Finding the session afterwards

```powershell
opencode session list --format json -n 10
opencode export <sessionID>            # full transcript JSON (--sanitize to redact)
opencode db path                       # locate the SQLite DB for direct queries
```

Searching transcripts in depth is covered by the `opencode-history-search`
skill.

## Failure modes

| Symptom | Cause | Fix |
|---------|-------|-----|
| `Error: Session not found` on a fresh run | Inherited `OPENCODE_*` env (desktop app) | Clear all `OPENCODE_*` vars |
| Task "completes" but the key action never ran | A permission `ask` was silently denied | Explicit allow in agent file; validate output substance |
| Empty or truncated answer | Model/service issue | Retry with backoff; try `--variant` or another model |
| Response echoes your prompt back | Degenerate generation | Retry; tighten prompt |
| Unknown flag error | Version drift vs docs | Check `opencode --version`; consult `--help` |

## Reference

- Full flag/command tables and permission-model summary:
  {{COMPANION_ROOT}}/skills/opencode-headless-run/reference-cli.md — read on demand (companion)
- Official docs: https://opencode.ai/docs/cli/ , /docs/agents/ , /docs/permissions/
