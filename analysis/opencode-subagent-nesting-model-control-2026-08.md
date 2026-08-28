# OpenCode sub-agent nesting & model control (2026-08)

**Last updated:** 2026-08-22

## Context

Capability study answering two questions blocking the Cursor-composer port to OpenCode: (1) can an OpenCode agent spawn sub-agents that themselves spawn sub-agents (recursive orchestration); (2) can a parent control the model assigned to a sub-agent. Continues the OpenCode study line ([DSV4F session extension](./opencode-dsv4f-session-extension-2026-08.md), [skill-binding discovery](./opencode-skill-binding-discovery-2026-08.md)). Process SoT: [opencode-host-adapter](../docs/SOPs/opencode-host-adapter.md).

**Host pin:** Desktop-hosted interactive session (`OPENCODE_CLIENT=desktop`) plus fresh `opencode run` CLI subprocesses reporting **1.4.6**. Same CLI/Desktop skew caveat as [skill-binding discovery](./opencode-skill-binding-discovery-2026-08.md) — behavior was consistent across both surfaces here unless noted.

Claim labels: **Observed**, **Inferred**, **Unknown**.

---

## Substance

### Answer table

| Capability | Status | Mechanism |
| ---------- | ------ | --------- |
| Sub-agent spawns sub-agent, default agents | **Blocked** (**Observed**) | Built-in `general` toolset = `bash, edit, glob, grep, read, skill, webfetch, write` — no `task` tool. Depth capped at 1 |
| Sub-agent spawns sub-agent, configured | **Works** (**Observed**) | Agent definition with `permission.task` allowlist (`"*": "deny"` + named allows incl. self) gains a working `task` tool |
| Per-invocation model override on Task tool | **Does not exist** (**Observed**) | Task schema = description/prompt/subagent_type/task_id/command only |
| Static per-agent model pinning | **Works** (**Observed**) | `model:` frontmatter in `.opencode/agents/*.md`; DB-verified `providerID/modelID` on child assistant messages |
| Model inheritance | Unpinned child inherits invoker's model (**Observed**) | Nested unpinned `general` ran on its invoker's pinned model, not the top-level conductor's |
| Dynamic runtime model selection | Top-level only (**Observed**) | `opencode run -m <provider/model>` fresh process works; blocked *from inside subagents* by blocker B2 |

### Probe log

| Probe | Setup | Result |
| ----- | ----- | ------ |
| N1 | Interactive parent → built-in `general`; instructed to spawn `explore` + nested `general` | **Negative (definitive):** child reported `TASK_TOOL_AVAILABLE: no`; honest non-fabricated report |
| N2 | Project `.opencode/agents/orchestrator.md` (pinned free model; `permission.task`: explore/general/orchestrator) driven by `opencode-go/deepseek-v4-flash` conductor | **Pass:** DB shows conductor → L1 `orchestrator` (task call `state=completed`) → L2 `general` child session with `parent_id` = L1. Three agent levels + conductor |
| M1 | `probe-mimo.md` pinned to `opencode/mimo-v2.5-free`, spawned by a `gemma4:e4b` fallback parent | **Pass:** marker + arithmetic (19×29=551) + self-report all correct; DB confirms mimo-v2.5-free on the child session |
| M2 | Direct `opencode run -m opencode/hy3-free` (after env scrub) | **Pass:** reply recorded under `opencode/hy3-free` session |
| M3 | Inheritance check inside N2 chain | **Pass:** L2 unpinned `general` ran on nemotron pin of its invoker, not conductor's deepseek |
| B1–B3 | Headless subagent bash ladder: `echo` sanity → stdin-closed `opencode run -m` → retry with `--dangerously-skip-permissions` | **Blocked:** every subagent bash call stuck `state=running` until killed, including bare `echo` with timeout set |

### Verification method (authoritative, not self-report)

Model identity and lineage were verified against `~/.local/share/opencode/opencode.db` (SQLite; legacy JSON storage is stale):

- `session.parent_id` chain proves spawn lineage regardless of what models claim.
- `message.data` (`role=assistant`) carries `providerID`/`modelID` per message.
- `part.data` (`type=tool`) exposes exact task-tool inputs and `state` — this is what exposed conductors passing `prompt: "test"`.
- Query driver: `bun` + `bun:sqlite` readonly one-liners (schema introspection first: `sqlite_master`).

### Blockers observed

| # | Blocker | Label | Detail |
| - | ------- | ----- | ------ |
| B1 | Config snapshots at session start | **Observed** | Agent `.md` files and project `opencode.json` permission overrides created mid-session were invisible to the running session (Task denials showed stale rules) yet loaded correctly in fresh processes (`opencode debug config`). No create-and-invoke in one session; full restart required. Matches the restart-after-config-edit family already logged for skills (#12741 class) |
| B2 | Subagent bash hangs headless | **Observed**, root cause **Unknown** | Inside subagents of a headless `opencode run` tree, any bash call — including `echo` — never leaves `state=running`; `--dangerously-skip-permissions` had no effect. Kills the `opencode run -m` dynamic-model escape hatch when invoked *by* a subagent. Top-level bash in the same conditions untested (discriminator interrupted) |
| B3 | Multi-line argv truncation | **Observed** (host shell layer, **Inferred** not an OpenCode bug) | Prompt files piped via `"$(Get-Content -Raw …)"` reached `opencode run` truncated at the first newline; conductors received line 1 only and improvised protocols. Single-line prompts deliver intact |
| B4 | `OPENCODE_*` env leakage | **Observed** | Desktop client exports (`OPENCODE_SERVER_PASSWORD` etc.) cause `Session not found` in nested CLI runs; scrubbing env vars fixes it |
| B5 | `--agent` accepts primary agents only | **Observed** | Subagent names fall back to default build with a warning |
| B6 | Weak conductors mangle task payloads | **Observed** | `gemma4:e4b` sent `prompt: "test"`; deepseek-v4-flash once rewrote a 3-step protocol into its own simpler one. Orchestration fidelity is conductor-quality-bound |
| B7 | Free-tier noise | **Observed** | `nemotron-3-ultra-free` returned upstream 502 (provider overload); one phantom successful Write (file absent on disk) |

### Composer-port recipe (Target-facing)

1. Pre-define every role as an agent file in `.opencode/agents/` with pinned `model:` and, for orchestrators, an explicit `permission.task` allowlist including any child types (and itself for recursion).
2. Treat model differentiation as **author-time config**, not invocation-time choice; layers inherit down unless pinned.
3. Restart the host after any agent/config edit before probing.
4. Every parent using `"*": "deny"` task rules must allowlist each new subagent type or spawns deny silently-by-rule.
5. Dynamic per-call model selection currently requires top-level `opencode run -m`; do not route it through subagents until B2 is resolved.

---

## Implications / open questions

1. Candidate smoke rows for [opencode-host-adapter](../docs/SOPs/opencode-host-adapter.md): (a) nesting probe — configured orchestrator spawns one child, DB `parent_id` verified; (b) model-pin probe — pinned probe agent returns marker + arithmetic, DB `modelID` verified.
2. **Open:** B2 root cause — discriminator test (top-level headless bash with `--dangerously-skip-permissions`) not completed; determines permission-propagation bug vs deeper subagent-bash defect. Candidate upstream issue.
3. **Open:** depth beyond three agent levels and `explore`-as-leaf branch not exercised (conductor rewrote the payload); mechanism expected to hold.
4. **Open:** whether Desktop (vs CLI 1.4.6) subagent bash behaves differently — version-skew caveat applies to B2.
5. Failure-mode promotion: B1/B2 may deserve letters in the host-adaptation fidelity suite if they reproduce; not assigned here.

---

## Sources

- Live capability probes, 2026-08-22 (interactive Desktop session + headless `opencode run` 1.4.6 subprocesses; workspace openBuggy)
- `opencode.db` session/message/part queries (parent chains, per-message `modelID`, tool states) — same day
- [opencode.ai/docs/agents](https://opencode.ai/docs/agents/) — `model`, `permission.task`, mode/hidden semantics
- `opencode run --help` (1.4.6) — `-m/--model`, `--agent`, `--dangerously-skip-permissions`
- Test fixtures: openBuggy `.opencode/agents/{probe-hy3,probe-mimo,orchestrator}.md`, `.opencode/opencode.json` build task-allowlist override

---

## Related

- [VS Code sub-agent recursion](./vscode-subagent-recursion-2026-08.md) — same question against the VS Code native harness (also depth-capped at 1)
- [OpenCode DSV4F session extension](./opencode-dsv4f-session-extension-2026-08.md)
- [OpenCode skill-binding discovery](./opencode-skill-binding-discovery-2026-08.md)
- [OpenCode host adapter SOP](../docs/SOPs/opencode-host-adapter.md)
- [Authoring OpenCode adapter files](../docs/SOPs/opencode-authoring-adapter.md)
- [Analysis index](./_index.md)
