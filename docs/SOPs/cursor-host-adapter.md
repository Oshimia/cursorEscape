# Cursor host adapter

**Last updated:** 2026-08-21

## Context

This SOP documents the **global Cursor adapter** on the operator machine. **Target SoT** is this companion repo ([skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md), [agents](../../agents/_index.md), [skills](../../skills/_index.md)). Files under `~/.cursor/` are the **host adapter / copy-out target**, not a second procedure tree.

**Cursor copy-out:** operator-authorized **pointer-first live sync** applied **2026-08-21** (backup first). OpenCode copy-out is separately authorized ([opencode-host-adapter](./opencode-host-adapter.md)).

**Install root (this machine):** `C:\Users\admin\.cursor\`

**Companion root (this machine):** `C:\Users\admin\source\repos\general-projects\cursorEscape`

**Backup (restore SoT):** `C:\Users\admin\.cursor-backup-pre-pointer-sync-20260821-002858` — see `BACKUP_MANIFEST.md` in that folder. Companion SHA at backup: `06b16a8`.

---

## Substance

### Must / Must-not (host adaptation fidelity)

**Must:** Meet [host-adaptation-fidelity](../featureArchitecture/host-adaptation-fidelity.md) behavior bar — same operator loops as OpenCode; C1–C6 adapted to Cursor load surfaces (User Rules / `.mdc` for always-on; global skills for on-demand).

**Must:** Harness Read tables cite **absolute** companion paths (`C:/Users/admin/source/repos/general-projects/cursorEscape/…` after token merge) so deep procedure loads when **workspace ≠ cursorEscape**.

**Must-not:** Use `../../../../skills|workflow|agents|rules/` hops in overlay harness ([Wrong path resolution base](../featureArchitecture/host-adaptation-fidelity.md)); treat host `~/.cursor/docs/workflow/` mirror as procedure SoT; mark adapter **Done** on inventory alone; replace live rules with thin-pointer-only `.mdc` without injectable gate body (breaks C1).

### Layer map

| Layer | Portable contract | Cursor adapter path (pointer-first Target) |
| ----- | ----------------- | ------------------------------------------ |
| Always-on | Gate semantics in portable `rules/` | Live **hybrid** `rules/*.mdc` = overlay frontmatter + companion gate body + spawn pointers; optional User Rules snippets |
| Skills (on-demand) | [skills/](../../skills/_index.md) — thin harness stubs | `skills/*/SKILL.md` → Read companion `skills/…` and `workflow/…` |
| Deep workflow docs | Companion [workflow/](../../workflow/_index.md) | **Absolute companion Read** — not host mirror SoT |
| Role agents | [agents/](../../agents/_index.md) — thin harness | `agents/*.md` (spawn blocks; portable contract via companion Read) |
| Model hints | Overlay leaf only | `review-subagent-models.md` |

### Token merge on copy-out

When syncing from [overlays/cursor](../../overlays/cursor/_index.md) to live `~/.cursor/`:

1. **Backup** live harness first (timestamped sibling folder outside `~/.cursor`).
2. Copy harness files only (skills, agents, review-subagent-models) — **not** bulk procedure re-copy into `docs/workflow/`.
3. Replace `{{COMPANION_ROOT}}` with the absolute companion checkout path.
4. **Rules (hybrid):** overlay YAML frontmatter + **companion** `rules/<id>.md` gate body + spawn/snippet pointers — script: [Write-HybridCursorRules.ps1](../../overlays/cursor/scripts/Write-HybridCursorRules.ps1). Do **not** ship thin-pointer-only `.mdc` as the sole always-on text.
5. Leave `docs/workflow/` mirror in place until post-sync smoke (transitional; not SoT).
6. Restart Cursor after skill/rule changes when smoke-testing. Paste User Rules snippets from live `skills/*/user-rules-snippet.md`.

### Live inventory (pointer-first sync — 2026-08-21)

**Skills (5 — thin harness, companion Reads)**

| Skill | Live path | Status |
| ----- | --------- | ------ |
| implementation-plan | `~/.cursor/skills/implementation-plan/SKILL.md` | **Thin** + absolute companion Reads |
| implementation-review | `~/.cursor/skills/implementation-review/SKILL.md` | **Thin** + absolute companion Reads |
| composer | `~/.cursor/skills/composer/SKILL.md` | **Thin** + absolute companion Reads |
| roadmap | `~/.cursor/skills/roadmap/SKILL.md` | **Thin** + absolute companion Reads |
| documentation-architecture | `~/.cursor/skills/documentation-architecture/SKILL.md` | **Thin** + absolute companion Reads |

**Not in live skill catalog (by design)**

| Portable id | Live | Notes |
| ----------- | ---- | ----- |
| discovery | absent as skill | Via `workflow/discovery.md` from other harness Reads |
| plan-review | absent as skill | Via implementation-plan loop |
| pre-commit-ci-gate | rule only | Hybrid `.mdc` present |

**Agents (2)** — thin overlay harness live: `plan-reviewer.md`, `reviewer-a.md`

**Rules (3)** — **hybrid** live: companion gate body (incl. pressure-release) + overlay frontmatter/spawn pointers. Pre-sync fat bodies restored from backup if needed.

**Deep docs mirror (transitional)**

- `~/.cursor/docs/workflow/` — **retained** this sync (not deleted); **not SoT**

### C1–C2 attestation (Cursor)

| Check | Author-time (overlay) | Live (post 2026-08-21 sync) | Result |
| ----- | --------------------- | --------------------------- | ------ |
| **C1** always-on gates inject | Overlay `.mdc` thin + hybrid write script | Hybrid `.mdc` injects companion gate text (pressure-release) | **pass** (author-time + 2026-08-21 runtime) |
| **C2** companion reachability | Overlay stubs `{{COMPANION_ROOT}}/…` | Live skills/agents token-merged to absolute companion paths | **pass** (author-time + 2026-08-21 runtime) |
| Wrong-base hops | `rg` clean on `overlays/cursor` | Live skills should have zero `../../../../` hops | **author-time pass** |

### Smoke (Cursor — after full quit/restart)

| # | Check | How | Result |
| - | ----- | --- | ------ |
| 1 | C1 gates | New chat; **no tools**. Quote plan default-on, when-in-doubt; dual-review ≤4 / pressure-release from injected rules | **pass** (2026-08-21 operator; fresh chat) |
| 2 | Skill → companion | Load `implementation-review`; confirm Read hits `…/cursorEscape/skills/` or `workflow/` — not only `~/.cursor/docs/workflow/` | **pass** (2026-08-21) |
| 3 | Workspace ≠ companion (optional) | Other folder open; skill Read still absolute companion | **operator optional** |
| 4 | User Rules | Paste snippets from `~/.cursor/skills/*/user-rules-snippet.md` into Customize → Rules | **deferred** (operator skipped second-layer reinforcement) |
| 5 | Restore drill | Confirm backup folder + `BACKUP_MANIFEST.md` restore commands | **pass** (backup `…-20260821-002858`) |

**Smoke notes (2026-08-21):** Skill→companion **pass**. Restore drill **pass**. Fresh-chat C1 **pass** (default-on + when-in-doubt + pressure-release ≤4; not `count≥9`). User Rules paste **deferred**. Hybrid script fixed doubled `ci-ladder` URL. Phrase **eval/harness not exempt** remains OpenCode-style C1 wording — not required in Cursor hybrid gate bodies for this sync.

**OpenCode C6 minimum:** **pass** (2026-08-20) — [pointer-first-4 closeout](../../analysis/pointer-first-4-closeout-2026-08.md).

### Restore

1. Fully quit Cursor.
2. Follow restore PowerShell in `C:\Users\admin\.cursor-backup-pre-pointer-sync-20260821-002858\BACKUP_MANIFEST.md`.
3. Restart Cursor.

---

## Related

- [Cursor overlay copy-out map](../../overlays/cursor/_index.md)
- [pointer-first-3 audit](../../analysis/cursor-pointer-first-3-audit-2026-08.md)
- [Editing companion workflow](./editing-companion-workflow.md)
- [OpenCode host adapter](./opencode-host-adapter.md)
- [host-adaptation-fidelity](../featureArchitecture/host-adaptation-fidelity.md)
