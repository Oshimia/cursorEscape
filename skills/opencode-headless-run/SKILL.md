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

**Agent / automation callers — hygiene is per-invocation, not per-session.**
When every command runs in a fresh shell (agent loops, CI steps, subprocess
wrappers), the parent environment re-supplies these variables between calls;
cleanup performed in an earlier command does NOT persist. Chain the cleanup and
the run together as one command:

```powershell
Get-ChildItem env: | Where-Object { $_.Name -like 'OPENCODE*' } |
    ForEach-Object { Remove-Item "env:$($_.Name)" }
opencode run --dir <workspace> --agent <agent> -m <provider/model> `
    --title <findable-name> "<prompt>" *> <log-file>
```

```bash
env | grep ^OPENCODE_ | cut -d= -f1 | xargs -r -n1 -I{} env -u {} \
    opencode run --dir <workspace> -m <provider/model> "<prompt>" > <log> 2>&1
```

To confirm contamination as the cause of `Session not found`, list the
variables inside the *same* invocation that fails — if they reappear there,
the previous cleanup ran in a different process.

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

4. Model responsiveness varies by route: some free-tier models answer in
   seconds from the chat client but stall for minutes through `run`, and some
   providers throttle mid-session (persistent 502 "service overloaded" after
   tool use). Probe first; if slow or 502-ing, switch models rather than
   debugging the harness — and budget wall-clock accordingly before launching
   batches.

Before any long-running call, validate the pipeline with a short probe:
a trivial prompt ("Reply OK") under a hard cap (about 60 to 90 seconds). A probe
that times out means fix the path first; do not launch real work unvalidated.

On validation failure, retry with backoff (about 20 seconds times attempt,
budget of 3). Retry only the failure classes above; do not retry to average out
quality.

## Cold boot and warm servers (read before long runs)

Every bare `opencode run` boots its own server instance first. That cold boot is
invisible but expensive: on free tiers a trivial prompt can take minutes per
call, which reads like a hang. Two rules prevent it:

1. **Probe before committing**: run the short validation probe above.
2. **For anything beyond one-off calls, use a warm server**:

```powershell
# start once (reuse if the port is already serving)
$port = 4096
$busy = Test-NetConnection 127.0.0.1 -Port $port -InformationLevel Quiet -WarningAction SilentlyContinue
if (-not $busy) {
    Start-Process opencode -ArgumentList 'serve', '--port', "$port" -WindowStyle Hidden
    $deadline = (Get-Date).AddSeconds(20)
    do {
        Start-Sleep -Milliseconds 500
        $busy = Test-NetConnection 127.0.0.1 -Port $port -InformationLevel Quiet -WarningAction SilentlyContinue
    } until ($busy -or (Get-Date) -gt $deadline)
}
if (-not $busy) { throw "opencode serve did not become ready on port $port" }

opencode run --attach http://localhost:$port --dir <ws> --title <name> "<task>"
```

```bash
opencode serve --port 4096 &          # skip if already running
until (exec 3<>/dev/tcp/127.0.0.1/4096) 2>/dev/null; do sleep 0.5; done
opencode run --attach http://localhost:4096 --dir <ws> --title <name> "<task>"
```

Attach-mode rules (each of these bit in real use):

- **`--dir` is mandatory when attaching.** The server uses its own working
  directory; your shell's `cd`/`Set-Location` is silently ignored. Omitting
  `--dir` makes the run execute in the wrong tree.
- **Use absolute paths inside prompts when attaching.** Relative paths in task
  instructions resolve against the server's cwd, which can trigger
  `external_directory` denials for reads that would succeed from the shell.
- A failed or killed `serve` can leave an orphaned server holding the port. A
  later `serve` then fails while the orphan still works: check who owns the port
  (`Get-NetTCPConnection -LocalPort 4096`) and attach to it instead of spawning.
- Do not launch `serve` with `-RedirectStandardError`/`-RedirectStandardOutput`
  on Start-Process: it can die with an opaque `ChildProcess.kill` error. Prefer
  `Start-Job { opencode serve --port <port> *> log }` or plain detached start,
  then wait for port readiness as shown above.
- Set `OPENCODE_SERVER_PASSWORD` before `serve` if other local users exist.

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
| `Error: Session not found` on a fresh run | Inherited `OPENCODE_*` env (desktop app) re-injected into every fresh shell | Clear all `OPENCODE_*` vars **in the same invocation as the run** (see Agent callers note above); verify by listing them inside the failing command |
| Task "completes" but the key action never ran | A permission `ask` was silently denied | Explicit allow in agent file; validate output substance |
| Empty or truncated answer | Model/service issue | Retry with backoff; try `--variant` or another model |
| Response echoes your prompt back | Degenerate generation | Retry; tighten prompt |
| Unknown flag error | Version drift vs docs | Check `opencode --version`; consult `--help` |
| Trivial prompt takes minutes per call | Per-run server cold boot | Use serve + attach (warm server section) |
| `serve` fails to start, or dies silently | Port already held by an orphaned server | Attach to the existing server, or kill its process (`Get-NetTCPConnection -LocalPort <port>`) |
| One model stalls while others answer fast | Provider-side routing/queueing for that model over the CLI route | Probe with a cheap timed call; pick a responsive model |

## Debugging discipline (for agent callers)

Agent loops lose context between commands and re-inherit parent environment.
When a documented failure mode hits, debug **mechanically** — do not vary
multiple things per attempt:

1. **Match the symptom to this table first.** Work through candidate causes in
   table order; each row names its own one-command verification.
2. **One variable per attempt.** Change only the suspected cause; keep model,
   flags, binary, and working directory fixed until that hypothesis is proven
   or disproven.
3. **Observe state inside the failing invocation**, not in a prior or separate
   command (agent shells are fresh processes — earlier observations describe a
   different environment).
4. **Reproduce minimal first:** bare `opencode run -m <model> "Reply OK"` with
   no other flags establishes whether the failure is invocation-shaped at all.
5. **Cap improvised attempts at 3.** If the failure persists past three
   single-variable tests drawn from this table, stop and report findings +
   remaining hypotheses to the caller rather than continuing to vary
   binaries, models, or attach modes blind.
6. **Log every probe's exact command + output** to files under one temp dir;
   the transcript is the evidence chain if escalation is needed.

## Reference

- Full flag/command tables and permission-model summary:
  {{COMPANION_ROOT}}/skills/opencode-headless-run/reference-cli.md — read on demand (companion)
- Official docs: https://opencode.ai/docs/cli/ , /docs/agents/ , /docs/permissions/
