# Skill source and host overlays

**Last updated:** 2026-09-18

## Context

This document is **Target** design for how cursorEscape **authors one workflow** and applies it across **stacks** (currently Cursor, OpenCode, Antigravity, VS Code, Cline, Kilo Code, and Codex) without two documentation trees. T3 Code is a control plane (threads, diffs) and **does not** get a third skill tree ([backend abstraction](./backend-and-provider-abstraction.md)).

Identity: this companion repo is the owner's **skill and workflow manager** ([project decisions](./project-decisions-and-open-questions.md)). Analog: Theo `fleet` (Observed) — **stacks**, not machines. Multi-machine sync is a **non-goal**.

Claim labels: **Required** / **Desired** / **Cursor-specific** / **Unknown**.

**Program:** this page locks the Target stance below; program phase labels (`pointer-first-0` … `pointer-first-4`; OpenCode overlay phases 0–3) are disambiguated in [host adaptation fidelity](./host-adaptation-fidelity.md).

---

## Substance

### Pointer-first architecture (Required)

**Locked (pointer-first-0):**

- cursorEscape is the **sole SoT** for skills, rules, agents, workflows, and report schemas.
- Host folders (`~/.config/opencode`, `~/.cursor`) hold **thin harness only** — advertisement, permissions, spawn, absolute `{{COMPANION_ROOT}}` / `{{OPENCODE_HOME}}` wiring, thin always-on gates.
- Deep procedure loads via **companion Reads** to `{{COMPANION_ROOT}}/workflow/`, `skills/`, `agents/` — **not** host `docs/workflow/` mirror as SoT.
- Bulk copy-out of procedure is **transitional**; **load path superseded** by absolute companion Reads. Harness lessons retained: Failure mode I/J, absolute `instructions`, C1–C6 behavior bar.

**Harness-only sync (Target):** `instructions/*`, `AGENTS.md`, thin `skills/*/SKILL.md` stubs, thin `agents/*.md` harness, harness keys in `opencode.json`. **`review-subagent-models.md`:** companion overlay-Read only (`{{COMPANION_ROOT}}/overlays/opencode/review-subagent-models.md`) — not host copy-out. **Not sync SoT:** OpenCode host `docs/workflow/*` procedure mirror **deleted** pointer-first-4; Cursor `~/.cursor/docs/workflow/` may remain transitional.

### Job (Required)

This repo is the **canonical manager** of portable skills, agent roles, always-on gates, shared workflow procedure, and thin host overlays. Host folders (`~/.config/opencode`, `~/.cursor`, `~/.gemini`, effective `CODEX_HOME`, and other registered homes) are **copy-out / install targets**, not a second authored procedure tree. **Live sync:** [`Sync-HostHarness.ps1`](../../scripts/Sync-HostHarness.ps1) (dry-run default; `-Apply` requires fresh explicit owner authorization per the [procedure registry Apply boundary](./procedure-registry.md), all-host normative, single-stack `-AllowSkew` only as an explicitly owner-authorized recovery exception) from the registered overlay trees, including [overlays/codex](../../overlays/codex/_index.md) — modular layout in [host-sync README](../../scripts/host-sync/README.md). Sync **does not create backups**; registered baselines are restore-only. Codex became Active on 2026-09-08 with C1–C6 attested; every future Apply pass requires fresh owner authorization. OpenCode uses a companion pointer harness; a host procedure mirror is forbidden. Runtime smoke methods are owned by the [OpenCode host adapter](../SOPs/opencode-host-adapter.md). Do not create repo-root `adapters/` directories.

### Target taxonomy — Approach A (Required)

**Approach A (locked):** Portable procedure and contracts live at **repo-root** bases (`workflow/`, `skills/`, `agents/`, `rules/`). The Cursor overlay is **thin wrappers** at `overlays/cursor/` that point at those bases. `docs/skills/` and `docs/agents/` folded into root bases in Phase 4; `research/`, `review/`, `analysis/`, and `overlays/` moved to root in Phase 2. `docs/` retains **this-repo-only** FA and SOPs.

**Rejected alternatives (locked):**

- **B:** Lean `docs/skills` / `docs/agents` contracts as the sole portable SoT while bulk procedure stays under `overlays/cursor` — rejected (two homes; overlay becomes perpetual SoT).
- **C:** Hybrid bulk still in overlay with lean contracts elsewhere — rejected (same upkeep bug as B).

**Phase 5 complete:** Cursor Task / `subagent_type` / Bugbot spawn blocks live in overlay wrappers only — **not** in `skills/` or `agents/` bodies.

| Kind | Target home (Approach A) | May vary by host? |
| ---- | ------------------------ | ----------------- |
| Shared loop | `workflow/` + [intended-workflow](./intended-workflow.md) | **No** |
| Shared deep docs | `workflow/` (discovery, plan/review loops, ci-ladder, …) | **No** |
| Shared skill contracts | `skills/*/SKILL.md` | **No** host IDs in shared bodies |
| Shared agent contracts | `agents/*.md` | **No** |
| Shared always-on gates | `rules/*.md` | **No** |
| Host overlay | Registered overlay trees, including `overlays/codex/` (Codex managed block + TOML agents + skill wrappers) | **Yes** — harness mechanics, spawn IDs, additive safety |
| Copy-out install | `~/.cursor`, `~/.config/opencode`, `~/.gemini` | Install target only |

### Per-entry v2 sourcing (overlay-remediation Phase 1–2 — Required)

Manifest entries are **v2**: each `CopyEntry` names its source with a **class prefix**, resolved by `Copy-ManifestEntry` in `HostSync.Core.ps1` — overlays carry **only host differences**, and shared bodies are sourced from repo-root SoT at sync time.

| Class | Meaning | Example |
| ----- | ------- | ------- |
| *(plain)* | Overlay-relative file — backward-compat for not-yet-migrated rows | `skills/composer/SKILL.md` |
| `base:` | Repo-root SoT body rendered into this dest (promote-into-twin) | `base:rules/pre-commit-ci-gate.md` |
| `shared:` | `SharedRoot` knob — a rooted directory shared by several stacks; rooted values accepted verbatim | `shared:skills/discovery/SKILL.md` |

Composition and safety semantics (current state after Phase 4 normalization):

- **CompositionId (registry-governed)** — for all five migrated host classes, the semantic composition order is owned by the [procedure registry](./procedure-registry.md) via `catalog/workflows.json`; manifest entries bind the composition via `CompositionId` and **must not** declare `Parts` or `Footer` (the blocking `composition-order-ownership` guard rejects any divergence). Deterministic rendering derives the effective `Parts`/`Footer` sequence at sync time.
- **Parts / Footer (historical/legacy)** — before registry normalization, a dest composed from multiple file references (a host `__header__.md` part + the `base:`/twin body + a host wiring footer), concatenated in declared order at sync time. This mechanism remains available for non-composition-bound entries that carry host-mechanics-only leaves; composed dests must not introduce a second authored procedure.
- **Substitutions are fail-closed** — declared per entry, must match **exactly once**; a no-match or double-match is a hard render error, never a silent skip.
- **PlannedContent capture** — dry-run captures the would-be written content (including dual-written mirrors like `AGENTS.md`) so CI can assert on renders without touching live trees.
- **Baseline substrate** — committed expected-renders under `scripts/host-sync/render-baselines/` are the regression anchor for composed dests; renders must equal baselines byte-for-byte.
- **Skew degeneration** — the cross-stack skew guard keys on **source identity + sibling stacks** at whole-leaf (Dest) granularity; when sources degenerate to overlay-only, single-stack Apply stops failing closed for that leaf (documented, not silent).
- **Ref resolution contract** (pinned by unit checks U17–U20): rooted/absolute refs are used **verbatim**; un-pre-resolved classed refs throw a clear error; overlay-relative refs resolve source-dir first, then fall back to `OverlayRoot`.

Enforcement lives in [`Invoke-HostSyncChecks.ps1`](../../scripts/host-sync/Invoke-HostSyncChecks.ps1): the Composition suite has 79 checks and the Unit suite has 24 checks. Manifest surface reference: [host-sync README](../../scripts/host-sync/README.md).

### Authored layers vs copy-out (Required)

**Target (Approach A):** Shared loop, shared deep docs, and shared skill/agent contracts are **three authored SoTs** for procedure at repo-root bases (`workflow/`, `skills/`, `agents/`). **Host overlay** is the fourth layer: **thin wrappers** at `overlays/cursor/`, the **OpenCode harness** at `overlays/opencode/` (instructions, skills, agents, specimen config, workflow mirror recipe), and the **Antigravity harness** at `overlays/antigravity/` (GEMINI.md gate, skills, workflows, subagent defs). **Copy-out** is install, not a fifth SoT.

```text
Target (after Phases 3–5):
Shared loop (when to plan, dual-review, verdict bars)     → workflow/
Shared deep docs (full steps, specimens, CI ladder)       → workflow/
Shared skill/agent contracts (triggers, outline, must-not) → skills/, agents/
Host overlay (Cursor: thin wrappers)                      → overlays/cursor/
Host overlay (OpenCode: harness + specimen)               → overlays/opencode/  (copy-out authorized and applied Phase 3)
Host overlay (Antigravity: harness — GEMINI.md full-replace) → overlays/antigravity/
Copy-out to host config dirs                              → install; not SoT

Interim (Phases 3–4, historical): workflow/, docs/skills/, docs/agents/, overlays/cursor/ (fat extract) — folded into repo-root bases Phase 4–6.
```

Instruction **budget** (thin always-on vs on-demand vs deep docs) stays in [instruction-layering](./instruction-layering.md). Overlays sit **beside** that budget; they do not replace it.

### Promotion rule (Required — upkeep control)

When editing a sentence, ask: would this still be true if we deleted this host tomorrow?

- **Yes** → shared loop, shared skill, or shared deep doc. **Target:** repo-root bases (`workflow/`, `skills/`, `agents/`, `rules/`, FA). **Not** overlay SKILL/agent/rule bodies for portable procedure.
- **No** (how this host wires or extra-constrains) → overlay only (spawn blocks, harness IDs, additive safety).
- **Same paragraph appearing in two overlays** → it was shared; promote it. Dual overlays of procedure is the bug.
- **OpenCode cannot meet a Required gate** → change the portable Required, or mark Cursor-specific / Unknown. Never write an “OpenCode edition” of the loop.

OpenCode being **more restrictive** means **more overlay on the same loop**, not a second loop. Cursor skills that already work in Cursor stay in the Cursor overlay / [desired-behavior mapping](./desired-behavior-vs-cursor-specific.md); they are not forked into a second `implementation-review` procedure.

### What may differ per stack (Required)

Only **harness mechanics** and **additive safety**, for example:

- Skill advertisement (OpenCode frontmatter `name`/`description`; Cursor `disable-model-invocation`).
- How a reviewer is spawned (OpenCode Task + `permission.edit: deny` vs Cursor `subagent_type`).
- Extra “must also” lines OpenCode needs because it does not host-enforce Fast CI / dual re-launch.
- Config wiring (`opencode.json` `instructions`, `skills.paths`).

Those lines change when **the product** changes, not when **you** change discovery or Escalation.

### Host-mechanics deviations and shared-source governance (Required)

Post-Phase 3L Composer decisions formally retain two aspects of the current
wrapper topology. These are durable governance policy, not historical drift.

**Cursor `disable-model-invocation: true` asymmetry (Required — retained).**
The Cursor-specific `disable-model-invocation: true` flag remains set for
exactly `implementation-plan`, `implementation-review`, `composer`,
`documentation-architecture`, and `roadmap`. The flag is part of Cursor
skill-advertisement/load mechanics — it controls whether the Cursor UI
auto-suggests the skill during drafting — not a license for any host to
override canonical procedure ownership. Registry profiles remain the
fail-closed source of each wrapper's exact description and effective invocation
metadata. Cross-host behavior remains governed by canonical procedure and
registry contracts; the differing flag is an intentional host-mechanics
deviation under "What may differ per stack" above. Other hosts must not adopt
this flag as a policy signal.

**OpenCode / Antigravity / VS Code shared-source topology (Required — retained).**
The current topology is formally retained: use a shared physical source only
when host mechanics are genuinely identical; retain separate sources where
authored host deltas exist. Equality across these three hosts is enforced at
the governed semantic/metadata boundary by registry profiles and applicability
checks, not by requiring unrelated wrapper sources to be byte-identical or by
collapsing sources solely to reduce file count. Cross-host equality does not
mean byte-equality of wrapper files; it means the registry-validated
description, invocation policy, and routing contract hold for every applicable
host binding regardless of whether the physical source is shared or authored
separately.

**Cross-reference:** the registry ownership boundary in
[procedure-registry](./procedure-registry.md) is the fail-closed enforcement
seam for both policies. No wrapper body, canonical skill body, catalog value,
schema, baseline, runtime projection, or test is affected by this governance
resolution.

### Concrete overlay examples (Required)

**OpenCode-only (additive):**

- Reviewers: `permission.edit: deny`.
- Skill tool: `permission.skill: { "*": "allow" }`; frontmatter `name` + `description`; optional `skills.paths`.
- Extra always-on: prefer the skill tool and native read/glob/grep; do not bash-discover `~/.config/opencode`.
- Parent owns Observed Fast CI; empty Task finishing in ≪1s is routing/auth failure, not “no bugs.”

**Cursor-only:**

- Task / `subagent_type` IDs (`reviewer-a`, `plan-reviewer`, `bugbot`).
- User Rules snippets and optional `alwaysApply` `.mdc` dual-channel — **Cursor-specific** mapping of thin always-on ([instruction-layering](./instruction-layering.md)).

Do **not** put Cursor Task IDs in shared skill bodies. Do **not** put OpenCode permission JSON in shared loop docs.

### Forbidden (Required)

- Two authored deep-doc trees (`implementation-review` for Cursor vs OpenCode).
- Host `# Cursor` / `# OpenCode` sections inside one SKILL.md that both models will load.
- Committing secrets, machine paths, or `~/.config/opencode` into this git repo ([opencode-host-adapter](../SOPs/opencode-host-adapter.md)).
- Pretend repo-root `adapters/` or copy-out into `~/.cursor` / `~/.config/opencode` exists. Recorded overlay files live under `overlays/`.
- Claiming `overlays/cursor/` or overlay `docs/workflow/` as the **permanent** procedure SoT after Phase 3–5 land.

### Copy-out vs authorship (Desired later)

Later, copy-out may generate host-native wrappers that `Read` shared deep docs. You still **author the procedure once** at repo-root bases. Secrets stay out of git.

**Migration order (Target):** deliverable trees at repo root, overlay extract promoted to bases, thin overlay (complete). OpenCode overlay and copy-out authorization are recorded in [host adaptation fidelity](./host-adaptation-fidelity.md).

**Unknown:** Whether future refresh needs operator-merge for `opencode.json` provider/model keys beyond what the sync script preserves.

**Resolved (host-harness-sync + Codex Phase 3):** Modular sync entry [`Sync-HostHarness.ps1`](../../scripts/Sync-HostHarness.ps1) + [`scripts/host-sync/`](../../scripts/host-sync/README.md) registers seven stacks. Apply is lifecycle-gated and global-preflighted; dry-run preflight covers every selected stack before any write. OpenCode overlay path = [`overlays/opencode/`](../../overlays/opencode/_index.md); archived [`Rewrite-OpenCodeWorkflowLinks.ps1`](../../overlays/opencode/scripts/Rewrite-OpenCodeWorkflowLinks.ps1) (**not** primary sync). **Target load path:** companion `{{COMPANION_ROOT}}/workflow/` via absolute Reads from thin harness — not mirror-as-SoT.

### Other rejected patterns (detail)

- **Host sections in one SKILL.md** — wrong host text loads into context.
- **Two authored full skill trees** — the upkeep this page exists to avoid. Generated copy-out artifacts are fine; two SoTs are not.

---

## Implications / open questions

1. U3 is **partial**: skill/adapter inventory SoT = this companion repo (**Target:** repo-root bases at `workflow/`, `skills/`, `agents/`, `rules/`; overlay = thin wrappers); host dirs = copy-out targets; per-target `.cursorEscape/` remains **Unknown** ([project decisions](./project-decisions-and-open-questions.md), [workspace model](./workspace-model.md)).
2. Remaining incidental “canonical” phrasing in untouched leaves is **not** a second identity project — fix when that leaf is edited, or in a dedicated sweep, not by expanding review scope.
3. R0 live trial runs on the Phase 3–synced global OpenCode adapter from [overlays/opencode](../../overlays/opencode/_index.md). C6 minimum smoke **pass** (2026-08-20 operator post-mirror).
4. Overlay bodies are **thin wrappers** pointing at repo-root bases — not a second `implementation-review` procedure in this tree.

---

## Related

- [Host adaptation fidelity](./host-adaptation-fidelity.md) — binding wiring bar and C1–C6 verification matrix for every stack
- [OpenCode overlay](../../overlays/opencode/_index.md) — host-plugged copy-out **authorized and applied** (Phase 3 live sync 2026-08-20)
- [Instruction layering](./instruction-layering.md)
- [Intended workflow](./intended-workflow.md)
- [Desired behavior vs Cursor-specific](./desired-behavior-vs-cursor-specific.md)
- [Backend and provider abstraction](./backend-and-provider-abstraction.md)
- [Workspace model](./workspace-model.md)
- [OpenCode host adapter](../SOPs/opencode-host-adapter.md)
- [Cursor overlay](../../overlays/cursor/_index.md)
- [Codex overlay](../../overlays/codex/_index.md) — Active since 2026-09-08
