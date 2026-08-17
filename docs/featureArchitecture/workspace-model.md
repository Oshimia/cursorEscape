# Workspace Model

**Last updated:** 2026-08-17

## Context

cursorEscape is a **workspace-pointing companion**: it operates *on* a target repository's working tree and docs, not as a monolithic application repo. This Target doc defines how workspaces relate to orchestration and adapters.

---

## Substance

### Concepts (Required)

| Term | Meaning |
| ---- | ------- |
| **Companion repo** | cursorEscape (or future runtime package) holding workflow IP, skills, agent contracts |
| **Target workspace** | The repository the agent is modifying (may be cursorEscape itself or any other project) |
| **Working tree** | Uncommitted changes — valid review scope |
| **Branch scope** | Committed delta vs base branch — valid review scope |
| **Import trees** | `docs/research/imported/**` — Observed snapshots, not live sync |

### Pointer model (Desired)

```text
Operator
  → opens Target workspace in host (Cursor, VS Code, CLI)
  → companion workflow config resolves:
        - role → model profiles
        - bug_reviewer → openBuggy endpoint
        - discovery paths → target repo docs/
  → orchestration runs against target workspace root
```

**Required:** Workflow contracts do not assume cursorEscape is the only repo on disk.

**Required:** Review diff scope must be explicit (branch vs uncommitted) — aligned with openBuggy [invocation contract](../research/imported/openBuggy/featureArchitecture/cursor-bugbot-agent-review/invocation-contract.md).

### cursorEscape-as-target (this repo)

During initialization, the target workspace **is** cursorEscape:

| Property | Value |
| -------- | ----- |
| Runtime | **None** — docs only |
| CI | Link/manifest checks ([initialization roadmap](../roadmaps/cursorEscape-initialization.md)) |
| Canonical workflow source | Live `~/.cursor` import + [workflow-source-delta](../research/imported/workflow-source-delta.md) |

### Multi-root / monorepo (Unknown)

| Scenario | Status |
| -------- | ------ |
| Single git root | **Required** support |
| Monorepo with packages | **Unknown** — scoped Fast CI per package |
| Multi-root VS Code workspace | **Unknown** |

---

## Implications / open questions

1. Future runtime must accept `workspace_root` as an explicit parameter to adapters.
2. **Unknown:** Whether companion config lives in target repo (`.cursorEscape/`) vs global operator config.

---

## Related

- [Repository discovery and context](./repository-discovery-and-context.md)
- [Backend and provider abstraction](./backend-and-provider-abstraction.md)
- [Design decisions](../review/design-decisions.md)
