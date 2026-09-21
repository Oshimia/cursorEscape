# Instruction Layering

**Last updated:** 2026-09-22

## Context

Instruction layering keeps always-on context small while preserving default-on gates. Full procedures belong in skills, workflow docs, and role contracts that are loaded only when needed. This page owns the budget rule; [`intended-workflow.md`](./intended-workflow.md) owns loop order.

---

## Substance

### Layers (Required)

| Layer | Contents | Load rule |
| --- | --- | --- |
| **Always-on** | Durable gates, red lines, and pointers to named skills or contracts. | Every turn on the host's active load surface. |
| **Skills** | Trigger description, task outline, and Read-when links to deep procedure. | When the selected skill matches the task. |
| **Deep workflow docs** | Complete procedures, specimens, report schemas, and CI details. | When a skill, agent, or escalated plan requires them. |
| **Role agents** | Purpose, inputs, outputs, authority, isolation, and must-not rules. | In a clean child context for that role. |

Always-on text must not inline a full plan template, review procedure, CI implementation, or role body. Its purpose is reliable gate recognition and correct delegation, not procedure duplication.

### Always-on gates (Required)

Always-on gate text states that plan review and implementation review are default on unless the change is truly trivial or the owner explicitly opts out. Evaluation, harness, operational, and multi-step work is not exempt. When classification is uncertain, run the gate.

There is no fixed line budget. The success measure is behavior: the agent can identify when a gate applies and invoke the owning skill or contract without relying on chat history.

### Escalation ownership (Required)

[`skills/implementation-plan/SKILL.md`](../../skills/implementation-plan/SKILL.md) is the sole source for when escalation is required. Workflow specimens and host mirrors may show required headings, but they must not create a competing trigger table.

### Skills and deep procedure (Required)

Each skill remains short: name, description, invocation rule, outline, verification, and links to deep docs. Deep procedure is read from `workflow/` through the companion pointer model. A host wrapper may advertise a skill, but it must not become a second authored procedure tree.

### Host mapping (Required)

| Host | Active always-on strategy |
| --- | --- |
| Cursor | User Rules and thin `.mdc` rule surfaces carry only gate pointers. |
| OpenCode | Absolute `instructions` wiring plus matching global `AGENTS.md` carries the thin gate. |
| Antigravity | Composed host gate points to the canonical rule bodies. |
| VS Code | Host instruction/handoff surfaces carry the thin gate. |
| Cline | Composed workflow/rule surfaces carry the thin gate. |
| Kilo Code | Composed workflow/rule surfaces carry the thin gate. |
| Codex | Codex mapping (Active): canonical rules plus a Codex footer compose the marker-bounded managed block on the host AGENTS surface; the independent skill catalog remains on-demand. The managed Stop hook is a separate lifecycle surface, not an alternate always-on gate. |

Each registered host overlay carries extension directories for host-specific content: `rules/` for custom procedural rules beyond the canonical set, and `hooks/` for host-specific lifecycle hook configurations. Unfilled surfaces contain only their `_index.md` placeholders. Extension presence is not load behavior; host content must be bound to and trust through its actual load or lifecycle surface. Workflows remain canonical regardless of host.

Hosts may add restrictions when their tool model requires them, but they may not weaken default-on gates or inline an alternate loop.

### Anti-patterns (Required)

| Anti-pattern | Why rejected |
| --- | --- |
| Full review loop in always-on text | Wastes context and creates a competing procedure SoT. |
| Gate only in a skill description | The model may never load the skill, so the gate is not always-on. |
| Role body duplicating a workflow skill | Two procedure homes drift and obscure the authority boundary. |
| Host-specific launch IDs in shared bodies | Host IDs are overlay concerns, not portable semantics. |
| Numeric line-count success criteria | Line count does not prove gate behavior. |

---

## Implications

1. Adding a gate requires deciding whether it belongs always-on, in a skill, in deep workflow, or in a role contract.
2. Host wiring changes require the same loop behavior, not a copied full procedure.
3. Registry-owned composition may generate order, but canonical prose still has one home.

---

## Related

- [Intended workflow](./intended-workflow.md)
- [Skill source and host overlays](./skill-source-and-host-overlays.md)
- [Host adaptation fidelity](./host-adaptation-fidelity.md)
- [Agent roles and model assignment](./agent-roles-and-model-assignment.md)
- [Procedure registry](./procedure-registry.md)
