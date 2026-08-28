# VS Code Copilot sub-agent recursion (2026-08)

**Last updated:** 2026-08-28

## Context

Capability study answering whether VS Code's native agent harness (GitHub Copilot agent with the `runSubagent` tool) permits a sub-agent to spawn its own sub-agent (recursive orchestration). Direct VS Code counterpart to the [OpenCode sub-agent nesting & model control](./opencode-subagent-nesting-model-control-2026-08.md) study — same question, different host. Prior motivation: an earlier attempt at this test escaped to opencode (CLI) instead of testing the native mechanism, so this run pinned the test to native tooling only.

Claim labels: **Observed**, **Inferred**, **Unknown**.

**Host pin:** VS Code desktop (GitHub Copilot Chat agent) in the cursorEscape workspace, top-level agent session, 2026-08-28. No CLI subprocess; all spawns via the harness-native `runSubagent` tool.

---

## Substance

### Answer table

| Capability | Status | Mechanism |
| ---------- | ------ | --------- |
| Parent spawns sub-agent | **Works** (**Observed**) | Top-level agent holds `runSubagent` (`agentName` + prompt). Child completed research work and returned a structured report |
| Sub-agent spawns sub-agent | **Blocked** (**Observed**) | The child's toolset does **not** include `runSubagent` (or any equivalent). Silent absence — no error surface, the capability is simply never registered for spawned agents |
| Recursion depth | Depth-capped at 1 (**Observed**) | Parent → child works; child → grandchild impossible. Same default shape as OpenCode's built-in agents |
| Workaround for tree-shaped delegation | Fan-out from the orchestrator (**Inferred**) | The parent can spawn follow-up children based on prior children's results (sequential waves at depth 1). Same breadth, flattened hierarchy |

### Probe log

| Probe | Setup | Result |
| ----- | ----- | ----- |
| R1 | Top-level agent → `runSubagent` (Explore role), instructed to invoke `runSubagent` itself from a grandchild, using native tooling only (no CLI/terminal shell-out) | **Blocked (definitive):** child reported the tool is absent from its toolset ("tool not present — no such registered tool to invoke"), honestly non-fabricated; no grandchild launched |

### Comparison with OpenCode (Observed vs Observed)

| Aspect | VS Code (this study) | OpenCode ([nesting study](./opencode-subagent-nesting-model-control-2026-08.md)) |
| ------ | -------------------- | ------------------- |
| Default recursion | Blocked, tool absent from child toolset | Blocked, same shape (built-in toolset lacks `task`) |
| Configurable recursion | **Unknown** — no agent-definition `permission` analog probed | Works via `permission.task` allowlist in agent `.md` frontmatter |
| Capability granted at | Top-level agent only | top-level session + configured orchestrator agents |
| Failure surface | Silent tool absence (child infers absence) | Silent denial-by-rule (spawns deny without error) |

### Failure mode worth cataloguing

The blocked case fails **silently and asymmetrically**: the parent believes delegation is available (it just used it), while the child has no way to distinguish "tool deliberately withheld" from "tool doesn't exist." Any workflow contract that assumes depth-2 delegation must therefore be verified by probe, not assumed symmetric — matches the B6-class lesson from OpenCode (orchestration fidelity is conductor-quality-bound) in a new form: **orchestration structure is harness-granted, not model-guaranteed**.

---

## Implications / open questions

1. **Open:** whether a VS Code agent-definition mechanism (custom agent files, tool allowlists) can re-expose `runSubagent` to children — the `permission.task`-equivalent configuration was not probed here. If it exists, this study's table gets a "configured" row like the OpenCode study.
2. **Open:** whether the Explore role specifically strips `runSubagent` while other agent names (e.g. a custom role) retain it — role-dependent toolsets not discriminated.
3. Candidate smoke habit for any host-adapter work ([opencode-host-adapter](../docs/SOPs/opencode-host-adapter.md) analog): before assuming recursion, have a child echo its own tool list; treat "tool absent in child" as the depth-1 signature shared by both hosts so far.
4. Do not write workflow contracts (agents/, skills/) that presume depth-2 spawning without a probe against the target host.

---

## Sources

- Live capability probe, 2026-08-28 (VS Code desktop, cursorEscape workspace; native `runSubagent` spawn, child self-report of toolset contents)
- [opencode.ai/docs/agents](https://opencode.ai/docs/agents/) — comparison baseline from the OpenCode nesting study

---

## Related

- [OpenCode sub-agent nesting & model control](./opencode-subagent-nesting-model-control-2026-08.md)
- [Analysis index](./_index.md)
- [Documenting this repo (SOP)](../docs/SOPs/documenting-this-repo.md)
