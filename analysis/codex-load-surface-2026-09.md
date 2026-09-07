# Codex load-surface discovery — Phase 0

**Last updated:** 2026-09-08

## Context

This is the Phase 0 evidence record for the proposed Codex adapter. It is intentionally source-only: no live Codex home, config, credential, session, log, database, extension, or existing harness content was read or modified. Findings are based on the official documentation fetched on 2026-09-07, existing repository architecture, and scratch-only fixtures.

## Findings

### D1 — effective homes are two independent roots

| Logical root | Effective location | Phase 0 decision |
| --- | --- | --- |
| `codex-home` | `CODEX_HOME`, default `~/.codex` | Carry as an explicit injected root; do not infer it from the skill root. The only Phase 1+ candidates are `AGENTS.md`, guard-only `AGENTS.override.md`, and seven `agents/*.toml` leaves. |
| `skill-root` | `$HOME/.agents/skills` | Carry as a second explicit injected root, independent of `CODEX_HOME`; it receives 22 skill wrappers plus the generated pre-commit wrapper. |

Official configuration documentation states that local state is under `CODEX_HOME` (default `~/.codex`) and lists `config.toml`, auth, history, logs, and caches there. Those state files are excluded from the capture schema and all future adapter allowlists. [Advanced Configuration](https://learn.chatgpt.com/docs/config-file/config-advanced#config-and-state-locations) The official skills documentation places user skills at `$HOME/.agents/skills`, separately from the Codex home. [Build skills](https://learn.chatgpt.com/docs/build-skills#where-codex-loads-local-skills)

`AGENTS.override.md` precedes `AGENTS.md` and the first non-empty global file wins. A non-empty override therefore remains a preflight blocker, not a file an adapter may merge, replace, or delete. [AGENTS.md discovery](https://learn.chatgpt.com/docs/agent-configuration/agents-md#how-codex-discovers-guidance)

### D2 — companion reachability

The host-facing leaves must use the existing `{{COMPANION_ROOT}}` absolute-pointer convention for deep Reads. No relative hop may cross from either Codex root to the repository: the two roots are unrelated, and only the companion path is authoritative for `workflow/`, `skills/`, `agents/`, `rules/`, FA, and SOP reads. This is the same pointer-first boundary already required by [instruction layering](../docs/featureArchitecture/instruction-layering.md) and [host overlays](../docs/featureArchitecture/skill-source-and-host-overlays.md).

Phase 0 proves that rendering can carry an injected companion root without loading any profile. Runtime reachability remains a Phase 4 C4/C5 owner-attested smoke item because the desktop, IDE, and CLI permission surface cannot be inferred from files on disk.

### D3 — skill-catalog budget

The canonical source inventory has 22 `skills/*/SKILL.md` directories. Codex receives all 22 wrappers plus generated `pre-commit-ci-gate` (23 total); `opencode-headless-run` and `opencode-history-search` are marked explicit-only. This does not copy any canonical procedure: wrappers are thin advertisement/pointer leaves.

Codex caps the initially advertised skill list at 2% of context or 8,000 characters when context size is unknown; it shortens descriptions first and can omit skills if still over budget. [Build skills](https://learn.chatgpt.com/docs/build-skills#how-chatgpt-and-codex-use-skills) Phase 1 must therefore assert all 23 names, concise front-loaded descriptions, and a rendered initial-catalog description budget at or below 8,000 characters. The Phase 0 schema pins the inventory only; it does not author wrappers.

### D4 — reviewer boundary

The selected shape is standalone custom-agent TOML under `codex-home/agents/`, with seven underscore-named canonical roles. Official documentation requires `name`, `description`, and `developer_instructions`, supports `sandbox_mode`, and shows `read-only` reviewer agents. [Subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents#custom-agents) The Phase 1 reviewer roles must use `sandbox_mode = "read-only"` and deny write-oriented tool paths in their developer instructions; the parent implements and owns recovery.

Persistent adapter TOML must not pin a model or reasoning effort (locked product decision). For this execution's phase and review subagents, the owner directed GLM 5.3 Flash (2026-09-08 override after Codex usage exhaustion; previously GPT Terra at high reasoning effort). This remains compatible with Codex inheritance: omitted custom-agent settings inherit from the parent, while explicit spawn settings override defaults. [Subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents#global-settings) `read-only` means inspection without edits or commands absent approval; `workspace-write` is reserved for the parent's bounded workspace. [Sandboxing](https://learn.chatgpt.com/docs/sandboxing#configure-defaults)

### D5 — specialized two-root seam

The generic adapter derives one live root from `USERPROFILE` and a single manifest `LiveRelativeRoot`; it cannot represent distinct `CODEX_HOME` and `$HOME/.agents/skills` destinations or root-qualified rollback identities. The seam is therefore **a specialized `Codex.Adapter.ps1` in Phase 2**, not a Generic adapter extension. Phase 0’s scratch check invokes the baseline recipe with two explicit temporary roots, asserts neither equals the actual Codex or skill profile root, and proves capture leaves both sources byte-identical.

The safe capture recipe is [New-CodexPhase0Baseline.ps1](../scripts/host-sync/New-CodexPhase0Baseline.ps1). It requires `-OwnerAuthorized`, rejects nested roots and an existing destination, captures only schema-listed leaves, and records absence/presence plus SHA-256. The checked-in schema excludes configuration, authentication, history, logs, sessions, and databases. Baseline restoration is an explicit operator action only; later Apply preflight uses owned current bytes and hashes, never original-baseline equality or automatic restore.

## Recovery and regression evidence

`Invoke-CodexPhase0Checks.ps1` is scratch-only Fast CI. It verifies the owner gate, path containment, two-root separation, source immutability, destination schema, inventory counts, and restore-only semantics. `Get-ExistingSixStackRenderLedger.ps1` renders every current existing-stack destination with a temporary synthetic live root and writes/verifies the normalized six-stack hash ledger at [existing-six-stack-render-hashes-2026-09.json](../scripts/host-sync/goldens/existing-six-stack-render-hashes-2026-09.json). The ledger records one aggregate hash per stack over sorted destination/hash pairs, so a changed planned destination fails the comparison without reading a live host.

## C1–C6 mapping (unchanged)

| ID | Codex surface / later proof |
| --- | --- |
| C1 | Managed `codex-home/AGENTS.md` block; fresh CLI, IDE, and desktop attestation in Phase 4. |
| C2 | 23 `$HOME/.agents/skills/*/SKILL.md` wrappers; catalog test in Phase 1 and runtime catalog proof in Phase 4. |
| C3 | Seven `codex-home/agents/*.toml` files; read-only reviewer defaults and isolated runtime spawn proof. |
| C4 | Absolute `{{COMPANION_ROOT}}/workflow/...` pointers; fresh-client Read proof. |
| C5 | Absolute companion FA/SOP pointers; fresh-client native Read proof without repeated requests. |
| C6 | Three-client end-to-end attestation; presence or rendered hashes alone never pass it. |

## External gate

No initial real-profile baseline exists from this phase. Capturing it requires explicit owner authorization to run the recipe against the owner-supplied effective `CODEX_HOME`, `$HOME/.agents/skills`, and a new external baseline destination. The authorizer must confirm that the schema’s narrowly listed leaf bytes may be read and copied. Phase 4 separately requires authorization for any Codex Apply.

## Related

- [Codex bring-up roadmap](../docs/roadmaps/codex-bring-up.md)
- [Host adaptation fidelity](../docs/featureArchitecture/host-adaptation-fidelity.md)
- [Host sync README](../scripts/host-sync/README.md)
