# repository_explorer

**Last updated:** 2026-08-17

## Context

**Target** role contract. Bounded investigation — codebase and doc search — to answer specific questions for planner or implementer. Not a substitute for full context retrieval pipeline.

---

## Substance

### Purpose

Explore the target workspace (read, search, list) within a stated question; return concise evidence with paths — no drive-by implementation.

### Inputs (Required)

| Input | Description |
| ----- | ----------- |
| Workspace root | Target repo |
| Investigation question | Narrow scope |
| Thoroughness | quick \| medium \| very thorough |
| Paths hint | Optional starting directories |

### Outputs

| Output | Description |
| ------ | ----------- |
| Findings summary | Answering the question |
| Key file paths | For parent to attach to implementer context |
| Residual unknowns | Explicit |

### Must not

- Modify files (read-only)
- Expand scope beyond the question
- Claim index parity with Cursor internals

### Model

**Desired:** Fast/cheap model sufficient — config override.

---

## Implications / open questions

1. **Unknown:** Tool policy (shell allowed or read-only tools only) — adapter-defined.

---

## Related

- [Repository discovery and context](../docs/featureArchitecture/repository-discovery-and-context.md)
- [discovery procedure](../workflow/discovery.md)
