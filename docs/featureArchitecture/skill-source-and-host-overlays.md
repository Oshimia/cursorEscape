# Skill source and host overlays

**Last updated:** 2026-08-20

## Context

This document is **Target** design for how cursorEscape **authors one workflow** and applies it across **stacks** (Cursor, OpenCode) without two documentation trees. T3 Code is a control plane (threads, diffs) and **does not** get a third skill tree ([backend abstraction](./backend-and-provider-abstraction.md)).

Identity: this companion repo is the owner's **skill and workflow manager** ([design decisions](../../review/design-decisions.md)). Analog: Theo `fleet` ([Observed](../../research/theo-fleet-skill-management.md)) — **stacks**, not machines. Multi-machine sync is a **non-goal**.

Claim labels: **Required** / **Desired** / **Cursor-specific** / **Unknown**.

**Program:** [Companion pointer-first](../roadmaps/pointer-first.md) (`pointer-first-0` … `pointer-first-4`) locks this page’s Target stance below. Do not confuse with [opencode-overlays-sot](../roadmaps/opencode-overlays-sot.md) phases 0–3.

---

## Substance

### Pointer-first architecture (Required)

**Locked (pointer-first-0):**

- cursorEscape is the **sole SoT** for skills, rules, agents, workflows, and report schemas.
- Host folders (`~/.config/opencode`, `~/.cursor`) hold **thin harness only** — advertisement, permissions, spawn, absolute `{{COMPANION_ROOT}}` / `{{OPENCODE_HOME}}` wiring, thin always-on gates.
- Deep procedure loads via **companion Reads** to `{{COMPANION_ROOT}}/workflow/`, `skills/`, `agents/` — **not** host `docs/workflow/` mirror as SoT.
- Bulk copy-out of procedure ([opencode-overlays-sot](../roadmaps/opencode-overlays-sot.md) Phase 3 Strategy A mirror) is **transitional**; **load path superseded** by [pointer-first](../roadmaps/pointer-first.md). Harness lessons retained: Failure mode I/J, absolute `instructions`, C1–C6 behavior bar.

**Harness-only sync (Target):** `instructions/*`, `AGENTS.md`, thin `skills/*/SKILL.md` stubs, thin `agents/*.md` harness, harness keys in `opencode.json`. **`review-subagent-models.md`:** companion overlay-Read only (`{{COMPANION_ROOT}}/overlays/opencode/review-subagent-models.md`) — not host copy-out. **Not sync SoT:** OpenCode host `docs/workflow/*` procedure mirror **deleted** pointer-first-4 ([closeout](../../analysis/pointer-first-4-closeout-2026-08.md)); Cursor `~/.cursor/docs/workflow/` may remain transitional.

### Job (Required)

This repo is the **canonical manager** of portable skills, agent roles, always-on gates, shared workflow procedure, and thin host overlays. Host folders (`~/.config/opencode`, `~/.cursor`) are **copy-out / install targets**, not a second authored procedure tree. **OpenCode** host-plugged copy-out from [overlays/opencode](../../overlays/opencode/_index.md) is **authorized** and **applied** (Phase 3 live sync 2026-08-20); **pointer-first-4** deleted OpenCode procedure mirror (2026-08-20). C6 minimum runtime smoke **pass** (2026-08-20 operator post-mirror) per [host-adapter](../SOPs/opencode-host-adapter.md) and [closeout](../../analysis/pointer-first-4-closeout-2026-08.md). **Cursor** copy-out to `~/.cursor` remains manual / not repo-authorized. Cursor overlay: [overlays/cursor](../../overlays/cursor/_index.md) (**thin wrappers**). Do not create repo-root `adapters/` directories.

### Target taxonomy — Approach A (Required)

**Approach A (locked):** Portable procedure and contracts live at **repo-root** bases (`workflow/`, `skills/`, `agents/`, `rules/`). The Cursor overlay is **thin wrappers** at `overlays/cursor/` that point at those bases. `docs/skills/` and `docs/agents/` folded into root bases in Phase 4; `research/`, `review/`, `analysis/`, and `overlays/` moved to root in Phase 2. `docs/` retains **this-repo-only** FA, SOPs, roadmaps, and `Roadmap.md`.

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
| Host overlay | `overlays/cursor/` (thin wrappers); `overlays/opencode/` (OpenCode harness) | **Yes** — harness mechanics, spawn IDs, additive safety |
| Copy-out install | `~/.cursor`, `~/.config/opencode` | Install target only |

### Authored layers vs copy-out (Required)

**Target (Approach A):** Shared loop, shared deep docs, and shared skill/agent contracts are **three authored SoTs** for procedure at repo-root bases (`workflow/`, `skills/`, `agents/`). **Host overlay** is the fourth layer: **thin wrappers** at `overlays/cursor/` and the **OpenCode harness** at `overlays/opencode/` (instructions, skills, agents, specimen config, workflow mirror recipe). **Copy-out** is install, not a fifth SoT.

```text
Target (after Phases 3–5):
Shared loop (when to plan, dual-review, verdict bars)     → workflow/
Shared deep docs (full steps, specimens, CI ladder)       → workflow/
Shared skill/agent contracts (triggers, outline, must-not) → skills/, agents/
Host overlay (Cursor: thin wrappers)                      → overlays/cursor/
Host overlay (OpenCode: harness + specimen)               → overlays/opencode/  (copy-out authorized and applied Phase 3)
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

**Migration order (Target):** Phases 2–5 of [shared-workflow-docs](../roadmaps/shared-workflow-docs.md) — move deliverable trees to root, promote overlay extract to bases, thin overlay (complete). OpenCode overlay and copy-out authorization: [opencode-overlays-sot](../roadmaps/opencode-overlays-sot.md) Phases 2–3.

**Unknown:** Copy-out calendar; whether Phase 3+ refresh is fully scripted vs operator-merge for `opencode.json` provider/model keys.

**Resolved (Phase 3 — OpenCode overlays SoT; load path superseded):** OpenCode overlay path = [`overlays/opencode/`](../../overlays/opencode/_index.md); workflow mirror transform = archived [`Rewrite-OpenCodeWorkflowLinks.ps1`](../../overlays/opencode/scripts/Rewrite-OpenCodeWorkflowLinks.ps1) (**not** primary sync — transitional mirror only; [pointer-first](../roadmaps/pointer-first.md)); host-plugged harness copy-out **authorized and applied** (live sync 2026-08-20; backup `opencode-backup-20260820-153803`). **Target load path:** companion `{{COMPANION_ROOT}}/workflow/` via absolute Reads from thin harness — not mirror-as-SoT.

### Other rejected patterns (detail)

- **Host sections in one SKILL.md** — wrong host text loads into context.
- **Two authored full skill trees** — the upkeep this page exists to avoid. Generated copy-out artifacts are fine; two SoTs are not.

---

## Implications / open questions

1. U3 is **partial**: skill/adapter inventory SoT = this companion repo (**Target:** repo-root bases at `workflow/`, `skills/`, `agents/`, `rules/`; overlay = thin wrappers); host dirs = copy-out targets; per-target `.cursorEscape/` remains **Unknown** ([unresolved questions](../../review/unresolved-architectural-questions.md), [workspace model](./workspace-model.md)).
2. Remaining incidental “canonical” phrasing in untouched leaves is **not** a second identity project — fix when that leaf is edited, or in a dedicated sweep, not by expanding review scope.
3. R0 live trial runs on the Phase 3–synced global OpenCode adapter from [overlays/opencode](../../overlays/opencode/_index.md). C6 minimum smoke **pass** (2026-08-20 operator post-mirror) per [closeout](../../analysis/pointer-first-4-closeout-2026-08.md).
4. Overlay bodies are **thin wrappers** pointing at repo-root bases — not a second `implementation-review` procedure in this tree.

---

## Related

- [Host adaptation fidelity](./host-adaptation-fidelity.md) — binding wiring bar and C1–C6 verification matrix for every stack
- [OpenCode overlay](../../overlays/opencode/_index.md) — host-plugged copy-out **authorized and applied** (Phase 3 live sync 2026-08-20; [opencode-overlays-sot](../roadmaps/opencode-overlays-sot.md))
- [Instruction layering](./instruction-layering.md)
- [Intended workflow](./intended-workflow.md)
- [Desired behavior vs Cursor-specific](./desired-behavior-vs-cursor-specific.md)
- [Backend and provider abstraction](./backend-and-provider-abstraction.md)
- [Workspace model](./workspace-model.md)
- [OpenCode host adapter](../SOPs/opencode-host-adapter.md)
- [Shared workflow docs roadmap](../roadmaps/shared-workflow-docs.md)
- [Cursor overlay](../../overlays/cursor/_index.md)
- [Theo fleet skill management (Observed)](../../research/theo-fleet-skill-management.md)
- [Companion pointer-first](../roadmaps/pointer-first.md)
