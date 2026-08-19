# Workspace Model

**Last updated:** 2026-08-20

## Context

cursorEscape is the owner's **skill/workflow manager** and a **workspace-pointing companion**: it operates *on* a target repository's working tree and docs, not as a monolithic application repo. This Target doc defines how workspaces relate to orchestration and adapters. First recreation: **T3 Code** (control plane) + **OpenCode** (harness) — see [host recreation](../../analysis/host-recreation-2026-08.md).

---

## Substance

### Concepts (Required)

| Term | Meaning |
| ---- | ------- |
| **Companion repo** | cursorEscape (docs contracts; future optional runtime package) holding workflow IP |
| **Target workspace** | The repository the agent is modifying (may be cursorEscape itself or any other project) |
| **Working tree** | Uncommitted changes — valid review scope |
| **Branch scope** | Committed delta vs base branch — valid review scope |
| **Import trees** | `research/imported/**` — Observed snapshots, not live sync |
| **T3 thread / worktree** | T3 isolation for parallel *implementation* threads — **not** the dual-review mechanism |
| **OpenCode child session** | Subagent Task session — correct unit for parallel dual review |

### Pointer model (Desired)

```text
Operator
  → opens Target workspace in T3 Code (or OpenCode TUI / IDE terminal)
  → T3 drives OpenCode against target workspace root
  → OpenCode resolves:
        - role → agent markdown + model profiles
        - discovery paths → target repo docs/
  → dual review: one OpenCode parent session → two Task children
     (do not use two T3 worktrees for the two review legs)
```

**Required:** Workflow contracts do not assume cursorEscape is the only repo on disk.

**Required:** Review diff scope must be explicit (branch vs uncommitted) — aligned with openBuggy [invocation contract](../../research/imported/openBuggy/featureArchitecture/cursor-bugbot-agent-review/invocation-contract.md) semantics (prompt input on OpenCode).

**Required:** Dual-gate reviewers share the **same** checkout / diff evidence as the implementer parent.

### cursorEscape-as-target (this repo)

| Property | Value |
| -------- | ----- |
| Runtime | **None** — docs only |
| CI | Link/manifest checks ([initialization roadmap](../roadmaps/cursorEscape-initialization.md)) |
| Canonical workflow source | **Target:** gold bases in this companion repo (`workflow/`, `skills/`, `agents/`, `rules/` — interim: `docs/skills/` until Phase 4, `docs/agents/` until Phase 4, overlay extract Phases 1–2 for deep procedure; `workflow/` after Phase 3). **Observed archaeology:** [workflow-source-delta](../../research/imported/workflow-source-delta.md) (eval freeze vs live; not a second procedure SoT) |
| First recreation host | External T3 + OpenCode — not in-repo packages |

### Multi-root / monorepo (Unknown)

| Scenario | Status |
| -------- | ------ |
| Single git root | **Required** support |
| Monorepo with packages | **Unknown** — scoped Fast CI per package |
| Multi-root VS Code workspace | **Unknown** |
| T3 `.t3-worktrees/` paths | **Desired** for parallel implementer threads; **must not** split dual reviewers |

---

## Implications / open questions

1. Future optional runtime must accept `workspace_root` as an explicit parameter to adapters.
2. **Unknown:** Per-target `.cursorEscape/` companion config (U3 remainder). Skill/adapter inventory SoT is this repo — [skill-source-and-host-overlays](./skill-source-and-host-overlays.md).

---

## Related

- [Repository discovery and context](./repository-discovery-and-context.md)
- [Backend and provider abstraction](./backend-and-provider-abstraction.md)
- [Design decisions](../../review/design-decisions.md)
- [Host recreation study](../../analysis/host-recreation-2026-08.md)
- [Skill source and host overlays](./skill-source-and-host-overlays.md)
