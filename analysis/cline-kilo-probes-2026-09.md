# Cline + Kilo Code probes & grounding — Phase 0 evidence (5th/6th stack bring-up)

**Date:** 2026-09-01 · **Provenance:** vendor docs fetched in-session (docs.cline.bot `getting-started/config`, `customization/cline-rules`; kilo.ai `customize/custom-rules`, `customize/workflows`) + live machine inventory (terminal) + installed extension versions. Feeds `docs/roadmaps/kilo-cline-bring-up.md`, overlay `_index.md`s, SOPs ×2.

## Cline (saoudrizwan.claude-dev 4.1.16 installed)

| Surface | Primary path (docs "Configuration Directory Layout") | Notes |
|---|---|---|
| Global rules | **`~/.cline/rules/`** | toggle-filtered; new files default-ON on scan; Rules panel = scale icon |
| Global workflows | **`~/.cline/data/workflows/`** | slash-invocable |
| MCP | `~/.cline/data/settings/cline_mcp_settings.json` | **NeverTouch** |
| Compat search paths | `~/Documents/Cline/{Rules,Workflows,…}` | additional (secondary), read-only for our purposes |

Compat-path history rule (per pass-2/3 review): the Lazy `ensureRulesDirectoryExists()` anchor observed in repo studies targets `~/Documents/Cline/Rules` in older builds; docs now name `~/.cline/rules` as primary. **Decision table (Phase 0 vs Phase 4 C1):** if the installed build's Rules panel discovers the probe file placed in `~/.cline/rules` → primary confirmed; else fallback = composite dest (dual-write to `Documents\Cline\Rules`) deviation-attested in SOP + live-sync row coupling note.

## Kilo Code (kilocode.kilo-code-7.5.6, rebuilt on Kilo CLI platform)

| Surface | Docs answer (kilo.ai current) | Notes |
|---|---|---|
| Global rules | **`~/.config/kilo/kilo.jsonc` `instructions` key** (new model); **`.kilocode/rules/` auto-included for backward compat** | no per-rule toggles; global-first load; project precedence on conflict |
| Global workflows/commands | **`~/.config/kilo/commands/`** (primary); **legacy `.kilocode/workflows/` auto-migrated to command format on startup** | `/filename` invocation; frontmatter `description`/`agent`/`model`/`variant`/`subtask` |
| Custom subagents | **first-class feature (NEW)** — supersedes earlier depth-1 assumption | depth/behavior re-probed at C-matrix; deviation row reworded |
| MCP | `<globalStorage>/settings/mcp_settings.json` + project `.kilo/mcp.json` | **NeverTouch** |
| External markdown | `permission.markdown_source` allowlist for symlinked commands dirs | not needed for file-dir dests |

**Decision (owner-locked earlier, now docs-confirmed):** Kilo dest root = `~/.kilocode/` (legacy-compat, auto-consumed). `kilo.jsonc` merge leg = documented future-migration, out of scope.

## Machine inventory (Phase 0)

- Baselines captured: `C:\Users\admin\.cline-backup-pre-kilobringup-20260901-180000` (5 files incl. cline_mcp_settings + globalState) and `C:\Users\admin\.kilocode-backup-pre-kilobringup-20260901-180000` (3 files: probe rules/workflows markers).
- `baseline-backups.paths.json` extended to 6 entries (cline + kilocode added 2026-09-01).
- Probe artifact plan: `.probe-edit-20260901.md` (rules ×2) + `probe-slash-20260901.md` (workflows ×2) — deleted after C1–C6 rows land (tracked in roadmap deliverables).
- Extension versions pinned at bring-up: Cline 4.1.16, Kilo 7.5.6.

## Deviations (pre-attested, forwarded to SOPs)

- **Cline:** serial in-chat dual review (no subagent spawn mechanism in VS Code ext; `cline-cli-subagent-orchestration-2026-08.md`); reviewers personified in wiring footer; user can toggle rules OFF (toggle semantics deviation).
- **Kilo:** subagents are first-class NEW — depth/behavior unproven; probe at Phase 4 smoke before any conductor reliance; reviewer read-only is instruction-level (mode-defs out of scope); rules always concatenate.
- **Both:** skills-as-workflows (name = filename); parity = 11-pointer-or-equivalent set; `/escape-plan` slash verified at smoke.
