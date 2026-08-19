# Skill source and host overlays

**Last updated:** 2026-08-19

## Context

This document is **Target** design for how cursorEscape **authors one workflow** and applies it across **stacks** (Cursor, OpenCode) without two documentation trees. T3 Code is a control plane (threads, diffs) and **does not** get a third skill tree ([backend abstraction](./backend-and-provider-abstraction.md)).

Identity: this companion repo is the owner's **skill and workflow manager** ([design decisions](../review/design-decisions.md)). Analog: Theo `fleet` ([Observed](../research/theo-fleet-skill-management.md)) — **stacks**, not machines. Multi-machine sync is a **non-goal**.

Claim labels: **Required** / **Desired** / **Cursor-specific** / **Unknown**.

---

## Substance

### Job (Required)

This repo is the **canonical manager** of portable skills, agent roles, always-on gates, and (later) thin host overlays. Host folders (`~/.config/opencode`, `~/.cursor`) are **copy-out / install targets**, not a second authored procedure tree. Copy-out is **not authorized** in this change — do not create `adapters/` directories or move host files.

### Authored layers vs copy-out (Required)

Shared loop, shared deep docs, and shared skill/agent contracts are **three authored SoTs** for procedure. **Host overlay** is a fourth authored layer for harness-only text. **Copy-out** is install, not a fifth SoT.

```text
Shared loop (when to plan, dual-review, verdict bars)     authored
        ↓
Shared deep docs (full steps, specimens, CI ladder)       authored
        ↓
Shared skill/agent contracts (triggers, outline, must-not) authored
        ↓
Host overlay (wiring + extra constraints only)            authored, future files
        ↓
Copy-out to host config dirs                              install later; not SoT
```

| Kind | Home | May vary by host? |
| ---- | ---- | ----------------- |
| Shared loop | [intended-workflow](./intended-workflow.md), [agents](../agents/_index.md) verdict bars | **No** — same meaning or label Cursor-specific / Unknown |
| Shared deep docs | Imported/adapted workflow docs; skills **point**, they do not paste | **No** |
| Shared contracts | [docs/skills](../skills/_index.md), [docs/agents](../agents/_index.md) | **No** host IDs (`subagent_type`, OpenCode filenames) |
| Host overlay | Future thin files (path **Unknown** — propose `adapters/<host>/` in prose only) | **Yes** — harness mechanics and additive safety only |

Instruction **budget** (thin always-on vs on-demand vs deep docs) stays in [instruction-layering](./instruction-layering.md). Overlays sit **beside** that budget; they do not replace it.

### Promotion rule (Required — upkeep control)

When editing a sentence, ask: would this still be true if we deleted this host tomorrow?

- **Yes** → shared loop, shared skill, or shared deep doc. One edit.
- **No** (how this host wires or extra-constrains) → overlay only.
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
- Pretend overlay directories exist in this repo until a copy-out phase creates them.

### Copy-out vs authorship (Desired later)

Later, copy-out may generate host-native wrappers that `Read` shared deep docs. You still **author the procedure once**. Secrets stay out of git.

**Migration order (Desired):** extract **OpenCode overlay** first when authorized; live `~/.cursor` stays **Observed interim Cursor wording** until a Cursor overlay extract. That is sequencing, not a competing architecture.

**Unknown:** exact on-disk overlay path (`adapters/<host>/` vs `docs/adapters/…`); extract method (manual vs script); calendar.

### Rejected alternatives

- **B:** Host sections in one SKILL.md — wrong host text loads into context.
- **C:** Two authored full skill trees — the upkeep this page exists to avoid. Generated copy-out artifacts are fine; two SoTs are not.

---

## Implications / open questions

1. U3 is **partial**: skill/adapter inventory SoT = this companion repo; host dirs = copy-out targets; per-target `.cursorEscape/` remains **Unknown** ([unresolved questions](../review/unresolved-architectural-questions.md), [workspace model](./workspace-model.md)).
2. Remaining incidental “canonical” phrasing in untouched leaves is **not** a second identity project — fix when that leaf is edited, or in a dedicated sweep, not by expanding review scope.
3. R0 dogfood continues on the current global OpenCode adapter until copy-out is authorized.

---

## Related

- [Instruction layering](./instruction-layering.md)
- [Intended workflow](./intended-workflow.md)
- [Desired behavior vs Cursor-specific](./desired-behavior-vs-cursor-specific.md)
- [Backend and provider abstraction](./backend-and-provider-abstraction.md)
- [Workspace model](./workspace-model.md)
- [OpenCode host adapter](../SOPs/opencode-host-adapter.md)
- [Implementation roadmap](../roadmaps/implementation-roadmap.md)
- [Theo fleet skill management (Observed)](../research/theo-fleet-skill-management.md)
