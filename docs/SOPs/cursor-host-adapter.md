# Cursor host adapter

**Last updated:** 2026-08-20

## Context

This SOP documents the **global Cursor adapter** on the operator machine. **Target SoT** is this companion repo ([skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md), [agents](../../agents/_index.md), [skills](../../skills/_index.md)). Files under `~/.cursor/` are the **host adapter / copy-out target**, not a second procedure tree.

**Cursor copy-out is manual / not repo-authorized** unless the owner explicitly syncs. OpenCode copy-out is separately authorized ([opencode-host-adapter](./opencode-host-adapter.md)).

**Install root (this machine):** `C:\Users\admin\.cursor\`

**Companion root (this machine):** `C:\Users\admin\source\repos\general-projects\cursorEscape`

---

## Substance

### Must / Must-not (host adaptation fidelity)

**Must:** Meet [host-adaptation-fidelity](../featureArchitecture/host-adaptation-fidelity.md) behavior bar — same operator loops as OpenCode; C1–C6 adapted to Cursor load surfaces (User Rules / `.mdc` for always-on; global skills for on-demand).

**Must:** Harness Read tables cite **absolute** `{{COMPANION_ROOT}}/…` paths ([pointer-first-3](../roadmaps/pointer-first.md)) so deep procedure loads when **workspace ≠ cursorEscape**.

**Must-not:** Use `../../../../skills|workflow|agents|rules/` hops in overlay harness ([Wrong path resolution base](../featureArchitecture/host-adaptation-fidelity.md)); treat host `~/.cursor/docs/workflow/` mirror as procedure SoT; mark adapter **Done** on inventory alone.

### Layer map

| Layer | Portable contract | Cursor adapter path (pointer-first Target) |
| ----- | ----------------- | ------------------------------------------ |
| Always-on (thin) | Gate pointers + full semantics in portable `rules/` | `rules/*.mdc` (`alwaysApply` where required) + optional User Rules snippets |
| Skills (on-demand) | [skills/](../../skills/_index.md) — thin harness stubs | `skills/*/SKILL.md` → Read `{{COMPANION_ROOT}}/skills/…` and `{{COMPANION_ROOT}}/workflow/…` |
| Deep workflow docs | Companion [workflow/](../../workflow/_index.md) at `{{COMPANION_ROOT}}/workflow/*.md` | **Absolute companion Read** — not host mirror SoT |
| Role agents | [agents/](../../agents/_index.md) — thin harness | `agents/*.md` (spawn blocks; portable contract via companion Read) |
| Model hints | Overlay leaf only | `review-subagent-models.md` (host or overlay copy-out) |

### Token merge on copy-out

When syncing from [overlays/cursor](../../overlays/cursor/_index.md) to live `~/.cursor/`:

1. **Backup** live `~/.cursor` first (timestamped folder).
2. Copy harness files only (skills, agents, rules, review-subagent-models) — **not** bulk procedure re-copy into `docs/workflow/`.
3. Replace `{{COMPANION_ROOT}}` with the absolute path to this companion checkout on the operator machine.
4. Preserve fat gate bodies in live `rules/*.mdc` if already present and injecting (C1) — or paste from companion `rules/` + overlay spawn pointers.
5. Restart Cursor after skill/rule changes when smoke-testing.

### Live inventory (pointer-first-3 audit — 2026-08-20)

**Skills (5 advertised — historical fat extract)**

| Skill | Live path | Overlay harness status |
| ----- | --------- | ---------------------- |
| implementation-plan | `~/.cursor/skills/implementation-plan/SKILL.md` | **Fat** — cites `~/.cursor/docs/workflow/`; not pointer-first stub |
| implementation-review | `~/.cursor/skills/implementation-review/SKILL.md` | **Fat** |
| composer | `~/.cursor/skills/composer/SKILL.md` | **Fat** |
| roadmap | `~/.cursor/skills/roadmap/SKILL.md` | **Fat** |
| documentation-architecture | `~/.cursor/skills/documentation-architecture/SKILL.md` | **Fat** |

**Not in live skill catalog (by design or gap)**

| Portable id | Live | Notes |
| ----------- | ---- | ----- |
| discovery | absent as skill | Reachable via workflow / other harness Reads — **non-blocking** |
| plan-review | absent as skill | Via implementation-plan loop — **non-blocking** |
| pre-commit-ci-gate | rule only | `pre-commit-ci-gate.mdc` present — **non-blocking** |

**Agents (2)**

- `plan-reviewer.md`, `reviewer-a.md` — overlay harness present live

**Rules (3)**

- `iterative-plan-review.mdc`, `iterative-code-review.mdc`, `pre-commit-ci-gate.mdc` — **fat gate bodies** live (C1 **pass** at runtime)

**Deep docs mirror (transitional)**

- `~/.cursor/docs/workflow/` — 8 leaves; legacy copy-out from Phase 3–5 — **not SoT**; disposition [pointer-first-4](../roadmaps/pointer-first.md)

### C1–C2 attestation (Cursor, pointer-first-3)

| Check | Author-time (overlay) | Live runtime | Result |
| ----- | --------------------- | ------------ | ------ |
| **C1** always-on gates inject | Overlay `.mdc` thin + spawn pointers; copy-out must preserve injectable gate text | Fat `.mdc` bodies inject plan + dual-review gates | **pass** (live); overlay documents merge requirement |
| **C2** harness reaches companion when workspace ≠ cursorEscape | Overlay stubs use `{{COMPANION_ROOT}}/…` — zero `../../../../` hops | Live fat skills use host mirror paths — works only while mirror exists | **pass** (author-time after pf3 fix); live sync **deferred** |
| Wrong-base hops | `rg` clean on `overlays/cursor` | N/A until live sync | **pass** |

### Smoke (deferred to pointer-first-4)

Minimum behavior smoke for Cursor companion-edit + workspace ≠ cursorEscape: [pointer-first-4](../roadmaps/pointer-first.md). This phase is **audit + author-time fix only**.

---

## Related

- [Cursor overlay copy-out map](../../overlays/cursor/_index.md)
- [pointer-first-3 audit](../../analysis/cursor-pointer-first-3-audit-2026-08.md)
- [OpenCode host adapter](./opencode-host-adapter.md)
- [host-adaptation-fidelity](../featureArchitecture/host-adaptation-fidelity.md)
