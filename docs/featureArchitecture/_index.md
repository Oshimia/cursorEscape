# Feature Architecture Documentation

**Last updated:** 2026-09-20

## Context

This section explains how cursorEscape is intended to work: the portable loop, source and overlay architecture, host fidelity model, agent roles, permission policy, project decisions, and registry-owned verification boundary.

Procedures are distinct from design. How to perform a task belongs in [`docs/SOPs/`](../SOPs/_index.md); shared deep procedure belongs in [`workflow/`](../../workflow/_index.md), with [`skills/`](../../skills/_index.md), [`agents/`](../../agents/_index.md), and [`rules/`](../../rules/_index.md) as the portable contract trees.

## Content boundaries

| Area | Responsibility |
| --- | --- |
| This folder | Current this-repository feature architecture and durable design decisions. |
| `workflow/` | Shared deep procedures and loop mechanics. |
| `skills/` | On-demand skill contracts and Read-when pointers. |
| `agents/` | Portable role contracts. |
| `rules/` | Always-on gate bodies. |
| `overlays/` | Host wrappers, host-only composition, and wiring for seven registered stacks. |
| `catalog/` and manifests | Machine metadata, destinations, composition bindings, and source classes. |
| `scripts/normalization/` | Sole Fast and Full CI entry points. |

## Architecture documents

| Document | Purpose |
| --- | --- |
| [Intended workflow](./intended-workflow.md) | Workspace scope and the plan → implement → dual-review → closeout architecture. |
| [Agent roles and model assignment](./agent-roles-and-model-assignment.md) | Portable role catalog, dual-gate rule, and model-assignment boundary. |
| [Instruction layering](./instruction-layering.md) | Always-on, skill, deep-procedure, and role-agent context budget. |
| [Clean context and isolation](./clean-context-isolation.md) | Parent synthesis, child isolation, dual-gate envelopes, and thread hygiene. |
| [Skill source and host overlays](./skill-source-and-host-overlays.md) | Canonical homes, companion-pointer overlays, sync, promotion, and host deviations. |
| [Host adaptation fidelity](./host-adaptation-fidelity.md) | The behavior bar, path-resolution rules, and C1–C6 verification classes. |
| [Procedure registry](./procedure-registry.md) | Registry ownership, guarded source flow, CI entry points, and Apply boundary. |
| [Permission and native tool policy](./permission-and-native-tool-policy.md) | Read-only defaults, native-tool preference, and mutating-command red lines. |
| [Project decisions and open questions](./project-decisions-and-open-questions.md) | Current project decisions, retained framework choices, and live open questions. |
| [bug_reviewer finding rubric](./bug-reviewer-finding-rubric.md) | Report, ignore, clean-context, doubt, and evidence rules for the bug-review leg. |

The registered host set is Cursor, OpenCode, Antigravity, VS Code, Cline, Kilo Code, and Codex. Host mechanics are documented by their overlay indexes and SOPs; this folder defines the invariants they must preserve.

## Operating rules

1. Canonical prose has one home; hosts receive projections.
2. Registry composition owns semantic order; manifests own destinations.
3. Fast CI is observed before review; Full CI closes after dual APPROVED.
4. Dry-run Apply is always allowed; live Apply requires fresh explicit owner authorization.
5. Current-facing documentation describes the working architecture, not completed migration history.

## Related

- [SOP index](../SOPs/_index.md)
- [Workflow index](../../workflow/_index.md)
- [Overlays index](../../overlays/_index.md)
- [Host harness sync README](../../scripts/host-sync/README.md)
