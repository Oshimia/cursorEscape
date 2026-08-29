# Cline CLI as orchestrator sub-agents (2026-08)

**Last updated:** 2026-08-29

## Context

Capability study answering whether the **Cline CLI** (3.0.60, installed via `npm install -g cline`) can serve as a **sub-agent mechanism for an external top-level orchestrator** — here, a Cline IDE (VS Code) session that itself has no native spawn tool. Three probes mirror the VS Code recursion study ([vscode-subagent-recursion](./vscode-subagent-recursion-2026-08.md)): (1) single headless child run; (2) multiple concurrent child runs; (3) nested chain — orchestrator → child → grandchild. Distinct from Cline's *internal* `use_subagents` feature (parallel read-only research agents, depth-capped: see [Cline subagents docs](https://docs.cline.bot/features/subagents)) — this study tests **CLI-process orchestration** from outside, where the parent is *this* IDE session and every child is a fresh `cline` process.

**Host pin:** Windows 11 + PowerShell 7; top-level orchestrator = Cline VS Code extension session (no spawn tool registered); children = `cline.cmd` (npm global shim at `%APPDATA%\npm\cline.cmd`) launched via `Start-Process -NoNewWindow` with `--json` event-stream output redirected to files; model pinned per run with `-m z-ai/glm-5.3-flash` (provider `cline`). Hub daemon healthy (`cline doctor`).

Claim labels: **Observed**, **Inferred**, **Unknown**.

---

## Substance

### Answer table

| Capability | Status | Mechanism |
| ---------- | ------ | --------- |
| External orchestrator runs one Cline sub-agent | **Works** (**Observed**) | `cline --json -t 240 -m z-ai/glm-5.3-flash "<prompt>"`; child used its own tools (2 iterations), returned accurate repo summary in `run_result.text` |
| External orchestrator runs several sub-agents in parallel | **Works** (**Observed**) | 3 × `Start-Process` launched within 46 ms; `agent_start` timestamps within 82 ms of each other; all three ran concurrently; 2/3 returned correct answers, 1 interrupted post-computation (blocker C1) |
| Nested chain: orchestrator → child → grandchild | **Works** (**Observed**) | Child instructed to run `cline --json … 'Reply with exactly one word: GRANDCHILD-OK'` via its own command tool; child's log contains the grandchild's own `agent_start`/`done` event stream; child extracted `run_result.text` = `GRANDCHILD-OK` and reported it |
| Recursion depth | **Uncapped in principle** (**Inferred**) | Depth bounded only by orchestrator patience/spend — each level is a process spawning a process; 3 levels exercised; deeper not tested |
| Per-run model pinning | **Works** (**Observed**) | `-m z-ai/glm-5.3-flash` on every child; `run_result.model.id` confirms on all completed runs; `totalCost: 0` throughout |
| Headless JSON observability | **Works** (**Observed**) | `--json` emits NDJSON event stream (`agent_start`, `iteration_start/end`, tool `content_start/end` with tool name + input, `usage`, `done`, `run_result`) — tool calls and answers are auditable, not self-reported |

### Probe log

| Probe | Setup | Result |
| ----- | ----- | ------ |
| S0 | Smoke: `cline --json "Reply with exactly one word: PONG"` | **Pass:** `run_result.text = "PONG"`, 1 iteration, 2.1 s, model `z-ai/glm-5.3-flash`, cost 0 |
| S1 | Single child: read `README.md`, report repo name + one-sentence purpose | **Pass:** 2 iterations (used its read tool), accurate summary, 6.3 s, cost 0 |
| P1 | Three children in parallel: count `.md` files in `agents/`, `skills/`, `rules/` | **Pass (2/3):** `agents=8` ✓, `skills=28` ✓ correct; third computed `rules=6` ✓ (visible in its tool-call log) but was `^C`-interrupted before emitting the final answer (C1) |
| N1 | Child orchestrator spawns grandchild via its command tool, extracts grandchild's `run_result.text` | **Pass:** grandchild event stream present in child log (`agent_start` → `done` "GRANDCHILD-OK", 1 iteration); child replied `GRANDCHILD-OK` |

### Invocation recipe (Observed, Windows/PowerShell)

```powershell
$p = Start-Process -FilePath "$env:APPDATA\npm\cline.cmd" `
  -ArgumentList @('--json','-t','240','-m','z-ai/glm-5.3-flash',"`"$prompt`"") `
  -WorkingDirectory (Get-Location) `
  -RedirectStandardOutput "$env:TEMP\child-out.txt" `
  -RedirectStandardError "$env:TEMP\child-err.txt" `
  -NoNewWindow -PassThru
# poll Get-Process -Id $p.Id, then read the NDJSON stream; final line = run_result
```

Gotchas, each **Observed**:

1. **Quote the prompt as one argument** — unquoted prompts fail with `Unknown command or unquoted prompt` (the npm `.cmd` shim re-splits arguments; `Start-Process` on the bare shim name fails with `%1 is not a valid Win32 application` — target `cline.cmd` explicitly).
2. **No inner double quotes in prompts** — use single quotes for any nested command the child should run (children execute commands in PowerShell).
3. **Pin the model with `-m`** — the CLI default happened to be `z-ai/glm-5.3-flash`, but pinning makes cost/model identity auditable per run.
4. **`--json` is the verification surface** — NDJSON gives per-tool-call provenance; styled output is hard to parse.
5. **Launch, don't wait, then poll** — synchronous runs from an IDE-agent terminal can be aborted by the terminal layer; `Start-Process` + polling + redirected files decouples child lifetime from the parent's tool-call window.

### Blockers

| ID | Blocker | Status |
| -- | ------- | ------ |
| C1 | **Stray `^C` kills long-running children** | **Observed** — one parallel child and one early smoke run died with `^C` in stderr and no error from Cline itself; suspected terminal/shell-integration interference with `-NoNewWindow` children, not a Cline defect. Mitigation: rerun lost children (cheap at flash prices); consider detached processes for critical legs |
| C2 | **Internal `use_subagents` ≠ process orchestration** | **Note** — Cline's built-in subagents are read-only research agents that *cannot spawn nested subagents* ([docs](https://docs.cline.bot/features/subagents)); the CLI-process route used here has no such cap but also no harness-enforced isolation between levels |

### Comparison with sibling studies

| Aspect | Cline IDE session (prior test) | Cline CLI as sub-agent (this study) | VS Code Copilot ([study](./vscode-subagent-recursion-2026-08.md)) | OpenCode ([study](./opencode-subagent-nesting-model-control-2026-08.md)) |
| ------ | ------------------------------ | ----------------------------------- | -------------------------------- | --------- |
| Parent spawns child | ❌ no spawn tool registered | ✅ via CLI process | ✅ `runSubagent` | ✅ Task tool |
| Child spawns child | n/a (no spawn at all) | ✅ process-in-process | ❌ tool absent from child toolset | ❌ by default; ✅ via `permission.task` allowlist |
| Parallel children | Tool-call batching only (same context) | ✅ independent processes, separate contexts | Unknown | Not exercised in study |
| Depth cap | 0 | None observed (process-based) | 1 | 1 default; configurable |
| Verification surface | — | NDJSON `run_result` + per-tool-call log | child self-report | `opencode.db` parent_id chains |

## Implications / open questions

1. **Cline CLI is a viable external sub-agent harness for this repo's dual-gate loops**: read-only research legs (repository_explorer-shaped) map cleanly onto cheap flash-model children; the NDJSON stream gives the parent an auditable contract (`run_result.text`) similar in spirit to the pack-everything-in-invoke isolation contract ([clean-context-isolation](../docs/featureArchitecture/clean-context-isolation.md)).
2. **Reviewer legs need care**: children default to full tool access with auto-approve in headless mode; `edit: deny`-shaped reviewer isolation must come from prompt + `--auto-approve false` + permission config, not from the spawn mechanism.
3. **Open:** root-cause C1 (`^C` on backgrounded children) — reproduce with detached process creation to discriminate terminal-layer vs Cline behavior.
4. **Open:** cost/latency envelope at scale — 3 parallel children ≈ 37 k input tokens total at cost 0 (flash tier); repeat with a paid model to get real numbers before wiring this into a workflow gate.
5. **Open:** whether Cline's internal `use_subagents` plus external CLI children compose into a useful hybrid, or whether mixing the two surfaces muddies auditability.

## Sources

- Live probes, 2026-08-29 (this workspace; Cline CLI 3.0.60, core 0.0.81; NDJSON stdout captures in `%TEMP%` during the session)
- [Cline CLI installation & setup](https://docs.cline.bot/cline-cli/installation) — `npm install -g cline`; Node 20+; `cline auth`
- [Cline subagents feature](https://docs.cline.bot/features/subagents) — internal `use_subagents` semantics (parallel, read-only, no nesting) contrasted with this study's process route
- `cline --help` / `cline doctor` output (3.0.60)

## Related

- [VS Code sub-agent recursion](./vscode-subagent-recursion-2026-08.md) — same question against the VS Code Copilot native harness (depth-capped at 1)
- [OpenCode sub-agent nesting & model control](./opencode-subagent-nesting-model-control-2026-08.md) — OpenCode counterpart with `permission.task` recursion config
- [Host recreation](./host-recreation-2026-08.md) — harness landscape (Cline noted "rejected for first attempt" on dual-gate subagent grounds)
- [Clean context isolation](../docs/featureArchitecture/clean-context-isolation.md) — portable child-handoff contract this mechanism could serve
- [Analysis index](./_index.md)

