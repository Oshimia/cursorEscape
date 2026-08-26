# opencode-headless-run reference (CLI surface, verified 1.4.6 on 2026-08-26)

## `opencode run` flags

| Flag | Purpose |
|------|---------|
| `--dir <path>` | Working directory for the session |
| `-m, --model provider/model` | Model in provider/model form (`opencode models` lists) |
| `--agent <name>` | Agent to use (permissions + persona) |
| `--title <text>` | Session title; defaults to truncated prompt |
| `-s, --session <id>` | Continue a specific session |
| `-c, --continue` | Continue the last session |
| `--fork` | Fork instead of mutate when continuing |
| `--format default\|json` | Formatted text or raw JSON event stream |
| `-f, --file <path>` | Attach files to the message (repeatable) |
| `--share` | Publish the session (careful: transcript leaves the machine) |
| `--attach <url>` | Route through a running `opencode serve` instance |
| `-p, --password` / username | Basic auth for attach (env defaults exist) |
| `--port <n>` | Port when spawning a local server |
| `--variant <v>` | Provider-specific reasoning effort (e.g. high, minimal) |
| `--thinking` | Include thinking blocks in output |
| `--command <cmd>` | Run a configured command, message as args |
| `--dangerously-skip-permissions` | Auto-approve everything not denied. Banned for scripted work. |

Global: `--print-logs`, `--log-level DEBUG|INFO|WARN|ERROR`, `--pure` (no external plugins), `--help`, `--version`.

## Commands most useful headless

| Command | Notes |
|---------|-------|
| `serve` (+ `run --attach`) | One server, many runs: avoids per-run cold boot |
| `session list --format json -n <N>` | Recent sessions as JSON (`-n` limit) |
| `session delete <sessionID>` | Remove a session |
| `export <sessionID> [--sanitize]` | Full transcript JSON; sanitize redacts file data |
| `db path` / `db [query] --format json\|tsv` | Locate / query the SQLite store |
| `models [--refresh]` | List provider/model ids for `-m` |
| `stats --days N --tools --models` | Token/cost usage |

## Permission model summary

Actions resolve to `allow` / `ask` / `deny`. Global config defaults are mostly
`allow`; two safety guards default to `ask`: `doom_loop` (identical tool call
repeated 3x) and `external_directory` (paths outside `--dir`). `.env` reads deny
by default.

- Agent-file frontmatter `permission:` merges over global config and wins.
- Granular object syntax with wildcards: `"bash": { "*": "ask", "git *": "allow" }`
  \u2014 last matching rule wins.
- Headless consequence: an `ask` cannot be answered, so the call is refused and
  the model improvises; exit code stays 0. Detection is output-side only.
- Env overrides: `OPENCODE_PERMISSION` (inline JSON), `OPENCODE_CONFIG`
  (alternate config file).

## Worked batch example (PowerShell)

```powershell
Get-ChildItem env: | Where-Object { $_.Name -like 'OPENCODE*' } |
    ForEach-Object { Remove-Item "env:$($_.Name)" }

Start-Process opencode -ArgumentList 'serve', '--port', '4096' -WindowStyle Hidden
Start-Sleep -Seconds 2

$dirs = Get-ChildItem D:\repos -Directory
foreach ($d in $dirs) {
    $log = "$env:TEMP\review-$($d.Name).log"
    opencode run --attach http://localhost:4096 --dir $d.FullName `
        --agent reviewer --title "batch-review $($d.Name)" `
        "Review the working tree changes." *> $log
}
```

## Retry skeleton (PowerShell)

```powershell
function Invoke-Headless {
    param([string]$Dir, [string]$Prompt, [int]$MaxAttempts = 3)
    for ($i = 1; $i -le $MaxAttempts; $i++) {
        $log = "$env:TEMP\headless-$([guid]::NewGuid().ToString('N')).log"
        opencode run --dir $Dir --title "auto" $Prompt *> $log
        $out = Get-Content $log -Raw
        if ($out -and $out.Length -gt 200 -and $out -notmatch '(?i)^\s*$') {
            return $out
        }
        Start-Sleep -Seconds (20 * $i)
    }
    throw "headless run failed validation after $MaxAttempts attempts"
}
```

Tighten the middle validation line to your task's real success markers.
