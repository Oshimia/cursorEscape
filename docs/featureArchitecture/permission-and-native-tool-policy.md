# Permission and native tool policy

**Last updated:** 2026-09-20

## Context

Permissions are architecture, not prompt etiquette. Instructions reduce unnecessary approval interruptions, but the host configuration remains the enforcement layer for dangerous commands. The durable goal is broad read access through native tools, narrowly scoped writes, and a hard red line around mutating Git and shell-filesystem operations.

---

## Substance

### Policy (Required)

| Action class | Policy |
| --- | --- |
| Repository reads | Prefer native read, search, glob, and inspect tools. Broad repository reads should not require repeated shell approval. |
| Temporary analysis files | Prefer an approved writable temporary zone and native write tools. Do not use shell redirection or broad shell writes as the default analysis path. |
| Repository writes | Allow only through the configured workspace-write surface and explicit task scope. |
| Shell-native filesystem mutations and scriptblock-carrying pipeline stages | Prompt-gated by [`rules/red-line.md`](../../rules/red-line.md); use approved native write or temporary-zone tools instead. |
| Git status, diff, log, and other non-mutating reads | Allowed as normal evidence gathering, preferably through the host's shell policy where native tools cannot express the query. |
| Git add, commit, reset, clean, checkout, restore, rebase, merge, cherry-pick, push, and force operations | Mutating. Each requires the applicable workflow gate and explicit authorization; these are never inferred from ordinary task approval. |
| Installation, service, database, network-mutating, or host-state changes | Blocked unless explicitly requested and represented in the reviewed task scope. |

### Enforcement model (Required)

1. **Host config is the enforcement boundary.** A prompt instruction cannot authorize an operation denied by host policy.
2. **One canonical allowlist inherits outward.** Avoid duplicating the same shell policy in every agent body.
3. **Order independence is required.** Allowlists must produce a deterministic outcome even when the host sorts matcher keys.
4. **Merge-preserve is understood.** Live-only keys may survive sync; removal of stale per-agent policy requires an explicit reviewed cleanup, not an incidental propagation assumption.
5. **Broad read, narrow write.** Read friction should be minimized; write and mutating-system friction is intentional.

### Host projection (Required)

| Host | Application |
| --- | --- |
| Cursor | Host-native permission and rule surfaces enforce the policy; overlays carry only thin wrappers. |
| OpenCode | Global shell and external-directory policy enforces allow/ask/deny; reviewer agents deny edits. |
| Antigravity | Host tool permissions and overlay reviewer definitions enforce read-only review behavior. |
| VS Code | Host handoff/tool permissions enforce the repository write boundary. |
| Cline | Host workflow and permission configuration enforce read-only review and scoped writes. |
| Kilo Code | Host workflow and permission configuration enforce read-only review and scoped writes. |
| Codex | Managed AGENTS policy plus host tool sandbox permissions enforce the same read/write and Git red lines. |

Hosts may be more restrictive than this policy. They may not grant a mutating Git operation merely because the task was broadly approved.

### Review boundary (Required)

Reviewers are read-only for repository edits. They may inspect diffs, tests, logs, and repository evidence according to their host permissions, but they must not modify files, run installs, mutate services, or perform Git state changes. Runtime reproduction is allowed only when it is read-only, inexpensive, explicitly in scope, and does not create artifacts or instrumentation.

### Change control

New allowlist entries require a reviewed changeset that shows the exact command class, why native tools cannot express it, the blast radius, and the host-policy tests or fixture update. Never add an entry temporarily in a live host without representing and reviewing it in the repository.

---

## Implications

1. Fewer shell approvals for reads is a design goal; preserving mutating-Git friction is also a design goal.
2. A host's more restrictive policy does not violate this contract.
3. Permission changes are architecture changes and require normalization CI plus the implementation-review cycle.

---

## Related

- [Shell and native tool policy rule](../../rules/shell-native-tool-policy.md)
- [Git and shell-filesystem red line](../../rules/red-line.md)
- [Instruction layering](./instruction-layering.md)
- [Clean context and isolation](./clean-context-isolation.md)
- [Skill source and host overlays](./skill-source-and-host-overlays.md)
- [Editing companion workflow SOP](../SOPs/editing-companion-workflow.md)
