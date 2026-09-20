# Project Decisions and Open Questions

**Last updated:** 2026-09-18

## Context

This page is the durable home for cursorEscape's current project decisions, framework and process fitness assessments, sibling-relationship intent, and unresolved architectural questions. It is a Target document — not a changelog or archaeology snapshot.

---

## Project decisions (retained from design decisions)

### Stewardship and distribution

| Topic | Decision |
| ----- | -------- |
| **Primary operator** | Owner (single maintainer). Built for the owner's agentic loop, not a multi-tenant service. |
| **Repository posture** | **Private-first.** Documentation is the durable artifact until (and unless) a runtime is implemented. |
| **Future distribution** | Open source is **conditional** — only if maintainable, scrubbed of private material, and worth supporting others. License and remote hosting remain **TBD** until that gate. |
| **Monetization** | **Not a goal.** No hosted SaaS business, seat sales, or GTM exercises. |

### Core identity

| Topic | Decision |
| ----- | -------- |
| **Project name** | **cursorEscape** (folder and display name). |
| **Primary job** | Manage skills and workflows that work — plan, implement, dual review, repository discovery — as portable contracts applied across stacks; OpenCode host-plugged copy-out authorized; Cursor copy-out remains manual. |
| **Canonical skill tree (Target — Approach A)** | Portable procedure and contracts at repo-root `workflow/`, `skills/`, `agents/`, `rules/`. Host dirs are copy-out targets, not a second authored tree. |
| **Personal workflow first** | Success = the owner's loop works reliably on their repos, not market share or a general IDE product. |
| **Not building a general IDE** | cursorEscape is a workspace-pointing companion, not a from-scratch editor or Cursor clone. |
| **First host attempt** | **T3 Code** (control plane) + **OpenCode** (harness). Not a VS Code replacement; does not own agent/skill contracts. |
| **Bugbot leg (initial)** | OpenCode `bug_reviewer` subagent + skills/rules. openBuggy is not required for v0. |
| **Keys** | **BYOK** — the operator supplies model API keys; inference cost and control stay with the operator. |
| **Inference (Desired)** | ClinePass (or equivalent open-weight subscription) as the likely OpenCode provider later. |
| **IDE coupling** | **VS Code is not inseparably coupled.** T3 (or similar) is the preferred agent cockpit; a thin IDE client remains acceptable. |
| **Replaceability** | Backends, models, and execution surfaces must remain swappable without rewriting canonical intent docs. |
| **Cursor dependency (target)** | **None** for the recreation path. Observed Cursor behavior may be imported as research/reference only. |
| **Runtime in this repo** | **Not started.** Docs remain canonical until an explicit R0+ go-ahead. |
| **Documentation taxonomy** | Target (Approach A): repo-root `workflow/`, `skills/`, `agents/`, `rules/`, `research/`, `analysis/`, `overlays/`; `docs/` for this-repo-only FA and SOPs. |

### Non-goals

| Non-goal | Rationale |
| -------- | --------- |
| General-purpose IDE | Companion workflow / contracts, not an editor product. |
| Reimplement Bugbot engine first | Recreate bug-finder utility with OpenCode agent + skills; openBuggy stays research. |
| Require openBuggy for v0 dual gate | Optional later; not a default transport. |
| Monetization or productized SaaS | Private workflow preservation. |
| Inseparable VS Code coupling | T3 or thin client OK; contracts stay host-agnostic. |
| Runtime during docs lock-in | No packages, adapters, or pretend APIs in this repository yet. |
| Pretend every Unknown is settled | Record TBD until spikes. |
| Multi-machine skill fleet | Variation is stacks (Cursor vs OpenCode), not laptops. |

---

## Sibling relationship intent (retained from relationship-to-siblings)

| Sibling | Role relative to cursorEscape | Sync? |
| ------- | ------------------------------- | ----- |
| **openBuggy** | Market/harness **research** archive; BugBot characterization; optional later bug engine — not a v0 runtime dependency | **No sync** — one-time import under `research/imported/openBuggy/` |
| **AITestSuite** | Eval packaging for plan/review workflow (frozen baselines, scoring framework) | **No sync** — Phase 3 import only; Observed/eval-packaging label |
| **Live `~/.cursor`** | Observed Cursor loop; skills/rules/agents extracted to `overlays/cursor/` (thin wrappers); repo-root contracts are Target SoT | **No sync** — overlay extract is a dated copy |

Replaceability principle: cursorEscape owns workflow contracts, repo knowledge, and evaluation methodology while keeping backends and models swappable. Siblings remain reference and packaging sources, not upstream dependencies. Re-import requires manifest update and explicit phase decision.

---

## Framework and process fitness assessments

Durable decisions on which mechanisms to retain, defer, or propose separately. Each area records the current mechanism, named alternatives, decision, rationale, revisit trigger, and first slice if revisited.

### 1. Documentation architecture vs documentation framework/static-site generator

| Field | Value |
| ----- | ----- |
| **Current mechanism** | Plain Markdown files with `_index.md` hub pages in structured directories (`docs/featureArchitecture/`, `docs/SOPs/`, `workflow/`, `skills/`, `agents/`, `rules/`, `research/`, `analysis/`). No build step, no SSG, no package manager. |
| **Alternatives assessed** | Do nothing (retain); Docusaurus/VitePress; MkDocs Material; Hugo |
| **Decision** | **`retain`** |
| **Reason** | Zero dependencies, maximum agent readability, deterministic, portable across all seven hosts. No build step means no lock-in, no rendering to maintain. Agent readability is the primary consumer; human navigation via `_index.md` is adequate at current scale. An SSG adds node_modules or Python/pip, a build lifecycle, and migration cost disproportionate to the rendered-navigation benefit. Rollback is trivial (delete the framework). Seven-host compatibility is preserved because plain Markdown needs no runtime. |
| **Revisit trigger** | A public-facing docs site requirement, or owner need for rendered search/navigation that `_index.md` hubs cannot sustain. |
| **First slice if revisited** | Audit current `_index.md` link coverage; identify gaps; prototype one section with the lowest-cost alternative (MkDocs) in a throwaway branch; measure agent-readability regression via the deterministic double-render check. |

### 2. Retained fail-fast PowerShell assertion harness vs Pester or another test framework

| Field | Value |
| ----- | ----- |
| **Current mechanism** | `scripts/normalization/Test-ProcedureRegistry.ps1`, `Test-ProcedureRegistryViews.ps1`, and various `Invoke-*Checks.ps1` scripts use `Set-StrictMode -Version Latest`, `$ErrorActionPreference = 'Stop'`, and fail non-zero on any failed assertion. The sole normalization Fast CI chains these and fails fast. No external test framework dependency. Observed Fast-path assertion volume (2026-09-18): 676 registry view checks + 24 host-sync unit checks, plus registry validity, current-state, and focused Codex checks. |
| **Alternatives assessed** | Do nothing (retain); Pester 5; Jest/Vitest; pytest; custom wrapper runner |
| **Decision** | **`retain`** |
| **Reason** | Zero external dependencies, deterministic, agent-readable, immediately runnable via `pwsh` across all seven hosts. Diagnostics are sufficient — each check has a named pass/fail line. Pester 5 requires module installation and version pinning, adding dependency management without proportional test-power benefit for the current assertion surface (~700 named Fast-path checks across 25 PowerShell scripts). Jest/pytest are not applicable (no JS/Python runtime exists). A wrapper adds indirection without value. Migration cost (the check scripts across `scripts/normalization` and `scripts/host-sync`) exceeds the structural benefit at this scale. The original "~50 checks" revisit marker has been passed in count; assertions remain individually named and diagnosable via shared assert helpers, so the readability condition this trigger guarded is not yet met. Revisit remains governed by this row's trigger. |
| **Revisit trigger** | Runtime code with complex test behavior (async, mocking, parameterized fixtures) joins the repo, or the assertion count grows beyond ~50 checks making flat `throw` unreadable. |
| **First slice if revisited** | Inventory all assertion scripts; identify the three highest-maintenance checks; convert them to Pester describe/it blocks behind a wrapper; compare diagnostics quality and CI runtime before committing to full migration. |

### 3. Current exact-reference audits vs repository-local or third-party link/reference checker

| Field | Value |
| ----- | ----- |
| **Current mechanism** | Exact `git grep -F` over `git ls-files` for reference auditing, plus the `Invoke-CodexRenderChecks.ps1` "markdown links are absolute or anchors only" check. No general-purpose link checker tool. |
| **Alternatives assessed** | Do nothing (retain); repository-local link checker script; third-party tool (markdown-link-check, lychee); extended grep pattern |
| **Decision** | **`retain`** |
| **Reason** | Exact-match `git grep -F` audits re-derived at phase entry are deterministic, dependency-free, and correctly scoped to catch planned-deletion cascades. The absolute-or-anchor check covers the most critical link-integrity class. A general link checker would produce noise from broken external links and imported-research interiors without proportional value for this documentation-only repo. Third-party tools add node/binary installs and network-dependent non-determinism. A repo-local script is viable but the current scale does not warrant it. |
| **Revisit trigger** | Pre-existing broken relative links accumulate across Phase 6+ cascade work to a maintenance burden, or the repo gains user-visible docs paths that change independently. |
| **First slice if revisited** | Run a one-shot relative-link resolution audit (read-only) across `docs/featureArchitecture/`, `docs/SOPs/`, and `workflow/`; classify hits as Phase-scheduled, imported-research-interior, or genuinely broken; decide whether to add a CI check or fix links inline. |

### 4. Explicit operator/Apply gates vs general migration framework

| Field | Value |
| ----- | ----- |
| **Current mechanism** | `scripts/Sync-HostHarness.ps1` requires `-Apply` (dry-run by default) plus lifecycle gate (Active status per stack), skew guard (shared source identity check), and optional `-AllowSkew` / `-BringUpException` owner overrides. No generic migration framework. |
| **Alternatives assessed** | Do nothing (retain); Alembic/Flyway; CI-enforced Apply pipeline; Ansible/Chef |
| **Decision** | **`retain`** |
| **Reason** | Fail-closed by default; every live host write requires explicit operator action. Deterministic preflight. Zero external dependencies. General migration frameworks solve schema-evolution and multi-environment deploy problems this repo does not have while introducing complexity and dependency management. CI-enforced Apply adds secret management and provider lock-in that conflicts with seven-host compatibility. Config management is vastly overkill for projecting Markdown/TOML to host config directories. |
| **Revisit trigger** | Registered stacks grow beyond 7, or a runtime component requires schema/data migrations. |
| **First slice if revisited** | Enumerate current stack manifests and Apply flow; identify the minimum contract a migration framework must satisfy (dry-run default, rollback, preflight); prototype with the simplest stack in a sandbox; measure preflight coverage vs current guard. |

### 5. Research artifact placement outside cursorEscape

| Field | Value |
| ----- | ----- |
| **Current mechanism** | `docs/SOPs/documenting-this-repo.md` places sourced facts under `research/` (with imported material under `research/imported/`), operator studies under `analysis/`, and future local studies may use `.local/` under `analysis/**` (gitignored). Two frozen research archives (`research/imported/openBuggy/`, `research/imported/AITestSuite/`) are owner-frozen. |
| **Alternatives assessed** | Do nothing (retain implicit); separate research sibling repo; keep in cursorEscape but constrain to `.local/` only; owner-selected external location with pointer/citation |
| **Decision** | **`retain`** (with explicit guidance: large working research outputs placed outside cursorEscape) |
| **Reason** | Durable, sourced research facts and imported archives stay in cursorEscape under `research/imported/` and `analysis/`. Large working outputs (transcripts, raw data, generated figures) should be placed outside cursorEscape by the owner in a sibling or local `.local/` path, with only a pointer/citation in this repo. This preserves the repo as a clean contract/procedure home without accumulating research intermediaries. A separate research repo adds a maintenance surface and cross-reference complexity. Constraining everything to `.local/` would prevent durable versioned research from being archived. |
| **Revisit trigger** | A research project produces artifacts that must be version-controlled for reproducibility and cannot be reasonably placed in a sibling repo or `.local/`. |
| **First slice if revisited** | Identify the specific research artifact; assess whether it fits under `research/imported/`, `analysis/`, or must be external; document the placement decision and pointer location in the same changeset as the research work. |

---

## Unresolved architectural questions (retained from unresolved-architectural-questions)

Claim label: **Unknown** unless noted otherwise.

### Settled (2026-08 host lock-in)

| # | Question | Decision |
| - | -------- | -------- |
| U2 | Primary backend adapter | **OpenCode** (first attempt). T3 Code is the control plane (observability), not the harness. Spike still required for parallel Task honesty. |
| U8 | openBuggy as default bug_reviewer transport | **Withdrawn for v0.** Bug leg = OpenCode `bug_reviewer` subagent + skills (reviewer-a pattern). openBuggy remains research / optional later. |

### Partial (2026-08-19 identity / overlay)

| # | Question | Decision |
| - | -------- | -------- |
| U3 (skill inventory) | Where is the canonical skill/adapter tree? | **This companion repo** is Target SoT. Host dirs are copy-out targets. See [skill-source-and-host-overlays](./skill-source-and-host-overlays.md). |
| U3 (target-repo config) | Companion config in target repo (`.cursorEscape/`) vs global? | Still **Unknown** — see [workspace model](./workspace-model.md). |

### Runtime and stack

| # | Question | Notes |
| - | -------- | ----- |
| U1 | Engine language (TypeScript, Python, …)? | **Unknown** — blocked until a cursorEscape runtime is authorized. |
| U4 | Unified agent API schema | [backend abstraction](./backend-and-provider-abstraction.md) — OpenCode markdown agents are the v0 adapter surface. |

### Workflow and discovery

| # | Question | Notes |
| - | -------- | ----- |
| U5 | Re-home repo-local `reference-docs` skill vs global discovery only? | [workflow-source-delta](../../research/imported/workflow-source-delta.md) |
| U6 | Generated index tier (LSP, embeddings) for v1? | [repository discovery](./repository-discovery-and-context.md) |
| U7 | Monorepo / multi-root workspace scoping | [workspace model](./workspace-model.md) |

### Review and eval

| # | Question | Notes |
| - | -------- | ----- |
| U9 | When to invoke optional test_reviewer vs production_readiness only | [agent roles](./agent-roles-and-model-assignment.md); contract [test_reviewer.md](../../agents/test_reviewer.md) — Desired triggers only; mandatory policy still **Unknown**. |
| U10 | Eval harness ownership — cursorEscape repo vs AITestSuite pattern | [evaluation methodology](./evaluation-methodology.md) |

### Distribution

| # | Question | Notes |
| - | -------- | ----- |
| U11 | License and public release gate | Stewardship and distribution table (above). |
| U12 | Remote hosting if open-sourced | **Unknown.** |
| U13 | Default model provider per role | **Unknown** (unproven) — Desired: ClinePass (or equivalent) when using OpenCode; see [agent roles](./agent-roles-and-model-assignment.md). |

---

## Implications / open questions

1. Target docs may cite these U-IDs when marking **Unknown** claims elsewhere.
2. Resolving a question requires updating the relevant Target doc + this page in the same change set.
3. The five framework/process decisions above are durable `retain` decisions; they should not be relitigated without hitting a revisit trigger.

## Related

- [Feature architecture index](./_index.md)
- [Skill source and host overlays](./skill-source-and-host-overlays.md)
- [Workspace model](./workspace-model.md)
- [Documenting this repo (SOP)](../SOPs/documenting-this-repo.md)
