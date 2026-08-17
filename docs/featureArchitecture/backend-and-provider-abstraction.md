# Backend and Provider Abstraction

**Last updated:** 2026-08-17

## Context

cursorEscape intends a **thin boundary** between workflow orchestration and execution backends so models, providers, and agent hosts swap without rewriting Target docs. No runtime exists in this repository yet — this page defines the **Target** layering. First recreation attempt: **T3 Code** (control plane) → **OpenCode** (harness) → BYOK provider (**ClinePass Desired** later). See [host recreation](../analysis/host-recreation-2026-08.md).

---

## Substance

### Layer model (Required)

```text
Workflow orchestration (skills, roles, CI gates)  ← cursorEscape contracts
        ↓
Agent abstraction (role contracts, prompts, tool policy)
        ↓
Control plane (optional) — T3 Code: threads, diffs, file preview
        ↓
Harness adapter — OpenCode: Task/subagents, permissions, skills
        ↓
Model provider — BYOK; ClinePass Desired later
```

| Layer | Responsibility | cursorEscape artifact |
| ----- | -------------- | --------------------- |
| Workflow | Plan/review sequencing, Fast/Full CI, phase boundaries | [intended-workflow](./intended-workflow.md), [skills](../skills/_index.md) |
| Agent abstraction | Role identity, inputs/outputs, verdict bars | [agents](../agents/_index.md) |
| Control plane | Observability UI (not skill ownership) | External: T3 Code — [preliminary backend landscape](../research/preliminary-backend-landscape.md) |
| Harness adapter | Spawn agent, stream tools, map diff scope | **OpenCode** (first attempt) — markdown agents under host config |
| Provider | API keys, model routing, rate limits | **Required** BYOK; **Desired** ClinePass later |

### Thin boundary rules (Required)

1. **Workflow docs never embed** provider-specific API shapes — adapters translate.
2. **Role contracts** are host-agnostic markdown; OpenCode agents map role names to native files.
3. **bug_reviewer** is an OpenCode subagent + skills (`edit: deny`) — not inlined Bugbot logic; openBuggy is **not** the v0 adapter.
4. **One orchestration parent** per phase owns CI + reviewer launches (live [implementation-review](../research/imported/cursor-global-workflow/skills/implementation-review/SKILL.md)).
5. **T3 does not own** skills/agents — it drives OpenCode (or other) CLIs.

### Adapter responsibilities (Desired)

| Concern | Adapter must provide |
| ------- | -------------------- |
| Tool execution | File read/search, shell (policy-bound), optional LSP |
| Subagent / parallel launch | Map production_readiness_reviewer ∥ bug_reviewer (OpenCode Task) |
| Diff scope | Branch vs working tree (prompt / invocation input) |
| Model selection | Per-role overrides from config |

### Unresolved API (Unknown)

| Surface | Status |
| ------- | ------ |
| Unified `Agent.run(role, context) → stream` | **Unknown** — v0 uses OpenCode native agents; no cursorEscape schema |
| openBuggy CLI/MCP | **Withdrawn as default** (U8) — optional later |
| Config file format (YAML/TOML/env) | **Unknown** for a future cursorEscape companion package |
| Streaming progress / timeline events | **Nice-to-have** (T3 may supply UI) |

---

## Implications / open questions

1. R0 spike proves OpenCode parallel Tasks before any cursorEscape engine ([implementation roadmap](../roadmaps/implementation-roadmap.md)).
2. Distinguishing **T3 Code** (pingdotgg control plane) from a from-scratch “T3/custom stack” fallback — see [preliminary backend landscape](../research/preliminary-backend-landscape.md).

---

## Related

- [Preliminary backend landscape](../research/preliminary-backend-landscape.md)
- [Agent roles and model assignment](./agent-roles-and-model-assignment.md)
- [Workspace model](./workspace-model.md)
- [Host recreation study](../analysis/host-recreation-2026-08.md)
