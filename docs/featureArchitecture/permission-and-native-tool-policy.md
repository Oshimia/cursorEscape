# Permission and native tool policy

**Last updated:** 2026-08-22

## Context

Target design for how cursorEscape governs shell permissions and native-tool preference across hosts. Contract SoT: [shell-native-tool-policy](../../rules/shell-native-tool-policy.md) (rules/). This leaf records **why** the policy is shaped this way and how it survives the host-sync machinery. Claim taxonomy: labels below are **Required** (red line, invariants) or **Desired** (relief metrics).

---

## Substance

### Problem (Observed data; window 2026-08-17→21, as of 2026-08-22 — regenerate via script, log grows)

| Metric | Value | Source |
|---|---|---|
| Permission prompts in log window | 558 (415 bash, 142 external_directory, 1 task) | `opencode.log` `message=asking` lines |
| Historical bash calls that would prompt under pre-policy config | 386/644 (60%) | `opencode.db` part analysis |
| Share of bash asks from subagent sessions | ~87% (361/415 nearest-prior attribution; 08-17: 31 vs 0; 08-18: 61 vs 0; 08-21: 257 vs 45) | `scripts/analyze-permission-asks.py` |
| Top offenders (bash ask heads) | `python -c` ×141, `Get-ChildItem` ×99, pipeline stages (`Select-Object` ×81, `ForEach-Object` ×42, `Where-Object` ×33), read cmdlets (`Get-Content` ×60), `git status` ×39, `Get-FileHash` ×36, `Set-Content` ×31, `git -C …` ×28, `rg` ×23, mutating git correctly asking (`add` ×19, `commit` ×19), openBuggy eval scripts ≈32 | Same |

Operator pain corroborated by [DSV4F session extension study](../../analysis/opencode-dsv4f-session-extension-2026-08.md): shell-approval babysitting every 2–3 minutes when bash substituted for skills/tools.

### Design (Target)

1. **Dual enforcement.** Config is the enforcement layer — the red line holds regardless of model compliance. Instruction text (always-on C1 section) reduces prompt *incidence* by steering to native `read`/`glob`/`grep`, so bash is rarely needed at all.
2. **Single global SoT entry + inheritance.** One canonical allowlist in specimen global `permission.bash`; per-agent/per-stub bash blocks deleted (OpenCode merges agent permissions over global per-key). Avoids 10× duplication and entry-count CI chores.
3. **Order independence (Required).** The sync optimizer (`HostSync.Core.ps1` `Order-OpenCodePermissionPatternMap`) hoists `*` first and sorts all other keys — insertion order cannot be part of any contract. The canonical set therefore uses disjoint prefix classes with exact-form branch/tag reads; last-match-wins semantics then have a unique winner regardless of sort order.
4. **Merge-preserve awareness (Required).** `Merge-HashtablePreserve` keeps live-only keys, so key deletions never propagate through sync. Stale per-agent bash subtrees must be pruned manually during the apply window; rollback of removals is manual too (asymmetry documented in rules leaf).
5. **Writable temp analysis zone (Desired).** `%TEMP%\opencode` joins `external_directory` allow so models stage helper scripts via the auditable native `write` tool instead of `Set-Content` in bash.
6. **Project-scoped script allows.** openBuggy's five reviewed eval scripts are allowed only in openBuggy's project `.opencode/opencode.json`, pinned to logged invocation forms — not globally.

### Why not alternatives

- **Runtime relief only** (`--auto`, session "always"): session-scoped, non-durable, defeats the red line. Also Observed: "Allow always" accumulates in-memory until restart ([skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md)) — prefer promoting intentional patterns into reviewed config.
- **Patch per-agent blocks minimally:** duplicates the block ×10, leaves pipeline/python/temp/subagent pain (~40% vs ~90% projected relief).

### Host mapping

| Layer | OpenCode (Target — applied Phase 2) | Cursor (deferred) |
|---|---|---|
| Enforcement config | `opencode.specimen.json` global `permission.bash` + `external_directory` temp zone | n/a until Cursor live sync |
| Always-on instruction | C1 dual-write section | user-rules snippet / `.mdc` pointer |
| Contract SoT | this policy pair (host-agnostic) | same |

Cursor echo trigger: **before the first Cursor live sync** (editing-companion cascade requires same-changeset thin wrapper when Cursor is an active target).

### Measurement

Reproducible attribution: [scripts/analyze-permission-asks.py](../../scripts/analyze-permission-asks.py) parses `opencode.log` (`asking` + session-created lines) into per-day/type/session-kind tallies. Success criterion after ≥3-day soak: subagent read-only bash asks ≈ 0 while mutating-git asks persist; residual known asks excluded ([rules leaf](../../rules/shell-native-tool-policy.md)).

---

## Implications / open questions

1. If OpenCode changes matcher semantics (segment parsing, comment stripping), re-run the Phase probe matrix before trusting allows.
2. High-frequency residual asks may earn allowlist entries after soak data — add via this policy's contract, never ad hoc in host JSON.
3. Sync-tooling prune semantics (removing keys via `-Apply`) would obsolete the manual prune step; tracked as follow-up, not built here.

## Related

- [Shell & native tool policy (contract)](../../rules/shell-native-tool-policy.md)
- [Instruction layering](./instruction-layering.md)
- [Skill source and host overlays](./skill-source-and-host-overlays.md)
- [Editing companion workflow](../SOPs/editing-companion-workflow.md)
- [Sub-agent nesting & model control study](../../analysis/opencode-subagent-nesting-model-control-2026-08.md)
