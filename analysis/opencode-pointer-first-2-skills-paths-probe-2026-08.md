# OpenCode pointer-first-2 — skills.paths + external_directory probe

**Last updated:** 2026-08-20  
**Program:** `pointer-first-2`  
**Host pin:** OpenCode CLI 1.4.6; Desktop study pin 1.18.18

## Context

pointer-first-2 rewrites OpenCode overlay harness stubs to thin `{{COMPANION_ROOT}}` Reads. This note records **Probe A** (skills.paths + external_directory) attestation for the phase closeout.

**Companion root:** `C:/Users/admin/source/repos/general-projects/cursorEscape`  
**OpenCode home:** `C:/Users/admin/.config/opencode`

## Discovery (author-time)

| Field | Value |
| ----- | ----- |
| `skills.paths` (live) | `["C:/Users/admin/.config/opencode/skills"]` — host harness stubs only |
| `external_directory` (live) | `OPENCODE_HOME/**` + `COMPANION_ROOT/**` allow |
| Catalog source | Host stubs (`name` + `description` frontmatter) — **not** companion `skills/` tree |
| Deep procedure load | Harness stub bodies cite `{{COMPANION_ROOT}}/skills/...` and `{{COMPANION_ROOT}}/workflow/...`; agent reads companion `{{COMPANION_ROOT}}/agents/...` |
| Mirror SoT | **Rejected** — host `docs/workflow/*` legacy transitional only; harness does not cite as procedure SoT after pointer-first-2 |

## Probe A — expected (post-restart)

Frozen prompt (from [opencode-skill-binding-discovery-2026-08.md](./opencode-skill-binding-discovery-2026-08.md)):

```text
Without using bash/shell: (1) list every skill the skill tool can load by name;
(2) load skill implementation-plan via the skill tool;
(3) quote the skill's Escalation when-table first row.
If you cannot see a skill in the skill tool, say so explicitly — do not list ~/.config/opencode with shell.
```

**Pass bar:** 8 workflow skills incl. `roadmap`; loaded `implementation-plan` shows companion Read rows with resolved `COMPANION_ROOT`; Escalation when-table points at companion skill.

## Author-time attestation (pointer-first-2)

| Check | Result |
| ----- | ------ |
| 8 overlay skills with `name` frontmatter | **pass** — inventory unchanged |
| Zero `docs/workflow/` in harness stubs | **pass** — `rg` clean on `overlays/opencode/skills` + `agents` + `AGENTS.md` + `instructions` |
| Zero `../../docs\|skills\|agents/` hops | **pass** |
| `{{COMPANION_ROOT}}` token in overlay sources | **pass** — resolved on live sync |
| `external_directory` includes companion | **pass** — live `opencode.json` |
| Live stub sync (backup first) | **pass** — see backup path below |
| Operator Probe A after restart | **blocked: operator gate** — OpenCode full quit/restart required before runtime Probe A; author-time inventory + grep contracts pass |

## Live sync (pointer-first-2)

| Item | Value |
| ---- | ----- |
| Backup path | `C:/Users/admin/.config/opencode-backup-pointer-first-2-20260820` |
| Sync scope | `instructions/`, `AGENTS.md`, `skills/*/SKILL.md` (×8), `agents/*.md` (×7), `docs/workflow/review-subagent-models.md` |
| **Not** synced | Procedure mirror bulk re-copy (`docs/workflow/*` leaves except review-subagent-models overlay leaf) |
| Token merge | `{{COMPANION_ROOT}}` → `C:/Users/admin/source/repos/general-projects/cursorEscape`; `{{OPENCODE_HOME}}` → `C:/Users/admin/.config/opencode` |
| Restart note | **Full quit + restart OpenCode** before runtime Probe A (rows 4, 9–10) |

## Implications

- **Empty catalog risk:** If `skills.paths` pointed only at companion without host stubs, catalog would be empty until companion paths registered — keep host stubs with `name` until Observed.
- **C4 Target met:** Harness bodies no longer use host `docs/workflow/` as load path; companion absolute Reads only.
- **plan_reviewer parity:** Overlay harness now points at `{{COMPANION_ROOT}}/workflow/plan-reviewer-report.md` for output schema (pointer-first-1 portable + pointer-first-2 overlay).

## Related

- [opencode-skill-binding-discovery-2026-08.md](./opencode-skill-binding-discovery-2026-08.md)
- [pointer-first roadmap](../docs/roadmaps/pointer-first.md) — pointer-first-2
- [overlays/opencode/_index.md](../overlays/opencode/_index.md)
