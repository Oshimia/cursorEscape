# Backend and Provider Abstraction

**Last updated:** 2026-08-17

## Context

cursorEscape intends a **thin boundary** between workflow orchestration and execution backends so models, providers, and agent hosts swap without rewriting Target docs. No runtime exists in this repository yet — this page defines the **Target** layering only.

---

## Substance

### Layer model (Required)

```text
Workflow orchestration (skills, roles, CI gates)
        ↓
Agent abstraction (role contracts, prompts, tool policy)
        ↓
Backend adapter (Cline, OpenCode, Cursor, CLI, MCP, …)
        ↓
Model provider (Anthropic, OpenAI, local, …)
```

| Layer | Responsibility | cursorEscape artifact |
| ----- | -------------- | --------------------- |
| Workflow | Plan/review sequencing, Fast/Full CI, phase boundaries | [intended-workflow](./intended-workflow.md), [skills](../skills/_index.md) |
| Agent abstraction | Role identity, inputs/outputs, verdict bars | [agents](../agents/_index.md) |
| Backend adapter | Spawn agent, stream tools, map diff scope | **Unknown** — research in [preliminary backend landscape](../research/preliminary-backend-landscape.md) |
| Provider | API keys, model routing, rate limits | **Required** BYOK per [design decisions](../review/design-decisions.md) |

### Thin boundary rules (Required)

1. **Workflow docs never embed** provider-specific API shapes — adapters translate.
2. **Role contracts** are host-agnostic markdown; adapters map to native agent types.
3. **bug_reviewer** adapter calls **openBuggy** (or successor) — not inlined Bugbot logic.
4. **One orchestration parent** per phase owns CI + reviewer launches (live [implementation-review](../research/imported/cursor-global-workflow/skills/implementation-review/SKILL.md)).

### Adapter responsibilities (Desired)

| Concern | Adapter must provide |
| ------- | -------------------- |
| Tool execution | File read/search, shell (policy-bound), optional LSP |
| Subagent / parallel launch | Map production_readiness_reviewer ∥ bug_reviewer |
| Diff scope | Branch vs working tree ([openBuggy diff model](../research/imported/openBuggy/featureArchitecture/ide-and-agent-integration.md)) |
| Model selection | Per-role overrides from config |

### Unresolved API (Unknown)

| Surface | Status |
| ------- | ------ |
| Unified `Agent.run(role, context) → stream` | **Unknown** — no schema chosen |
| MCP vs embedded CLI for openBuggy | **Unknown** — see [preliminary backend landscape](../research/preliminary-backend-landscape.md) |
| Config file format (YAML/TOML/env) | **Unknown** |
| Streaming progress / timeline events | **Nice-to-have** |

---

## Implications / open questions

1. Implementation roadmap prioritizes **research-first** adapter spike before large build ([implementation roadmap](../roadmaps/implementation-roadmap.md)).
2. Backend choice (Cline vs OpenCode vs other) **remains unsettled** — preliminary research only.

---

## Related

- [Preliminary backend landscape](../research/preliminary-backend-landscape.md)
- [Agent roles and model assignment](./agent-roles-and-model-assignment.md)
- [Workspace model](./workspace-model.md)
