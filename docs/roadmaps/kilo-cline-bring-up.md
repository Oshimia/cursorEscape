# Roadmap: Kilo + Cline bring-up (5th & 6th stacks)

**Last updated:** 2026-09-01

## Context

Bring up **Cline** (5th stack → `~/.cline/`) and **Kilo Code** (6th stack → `~/.kilocode/`) as host sync targets, plus the owner-ruled shared-machinery conversion that replaces the adapter-clone pattern with a dispatched `Generic.Adapter.ps1` (closes the vscode-host-adapter future note). Governing docs: [analysis/cline-kilo-probes-2026-09.md](../../analysis/cline-kilo-probes-2026-09.md) (surface map + grounding), plan history pass 1–3 (APPROVED 2026-09-01).

## Status checklist (extend-only)

- [x] **Phase 0 — probes, baselines, JSON:** docs-grounded surface maps (Cline `~/.cline/rules` primary; Kilo `.kilocode` legacy-compat auto-consumed + `/.config/kilo/kilo.jsonc` future-migration leg out-of-scope); baselines ×2 captured; `baseline-backups.paths.json` at 6 entries; probe artifacts placed for UI verification; evidence doc landed.
- [x] **Phase 1 — overlays ×2:** `overlays/cline/` (header, wiring footer w/ serial-review deviation, escape trio) and `overlays/kilocode/` (header, wiring footer w/ subagent-unproven deviation, escape trio w/ frontmatter).
- [x] **Phase 2 — machinery:** `Generic.Adapter.ps1` extracted (byte-identical engine); registry fallback dispatch; **Antigravity/Vscode clone adapter files deleted**; manifests ×2 (CopyEntries-only); `Register-StackAdapters` + Core baseline gate 4→6; Fast-CI adapter asserts updated (update-not-delete assert sweep); render zero-diff proven (73 planned-file hashes identical pre/post conversion); remediation checks 63→69 green.
- [x] **Phase 3 — docs cascade:** SOPs ×2 (deviation tables + risks), roadmap + `_index`, editing-companion live-sync rows, host-sync README additions, Roadmap.md status.
- [x] **Phase 4a — dry-run gates:** Cline + Kilocode dry-run success; full Fast CI green (exit 0); remediation 69/69; zero-diff of pre-existing 4 stacks across machinery conversion.
- [ ] **Phase 4b — live Apply + smoke:** operator-authorized `-Target Cline -AllowSkew -Apply` → restart → Cline smoke (Rules panel discovers `cursor-escape-loop.md`; `/plan` `/review` `/closeout` slash confirm) → then `-Target Kilocode -AllowSkew -Apply` → restart → Kilo smoke (auto-migrated `/plan` command listed) → live==planned byte-eq ×2 → convergence `-Target All`.
- [ ] **Probe artifact cleanup:** delete `.probe-edit-20260901.md` ×2 + `probe-slash-20260901.md` ×2 post-smoke.

## C-table (C1–C6 rows per host-adaptation fidelity)

| Row | Cline | Kilo Code |
| --- | ----- | --------- |
| C1 rules load | Rules panel shows composed always-on rule, toggle ON | compat loader auto-includes rule (Settings → Agent Behaviour list) |
| C2 surface parity | workflows list: plan/review/closeout present | `/plan`,`/review`,`/closeout` slash listed in `/` picker |
| C3 agent/roles | serial personas (footer attestation) | unproven subagent depth — probe before reliance |
| C4 render hygiene | zero unmerged `{{COMPANION_ROOT}}`; byte==planned | same |
| C5 NeverTouch | mcp/providers/sessions/db untouched | globalStorage untouched |
| C6 exclusion/probe cleanup | probe artifacts deleted | same |

## Implications

1. Convergence note: after both applies, run one full `-Target All` — 6 siblings of shared sources; skew guard then reports common knowledge (expected, not violation).
2. Any future gate-text edit now fans out to **six** stacks — editing-companion-workflow live-sync rows record the six-host coupling.
