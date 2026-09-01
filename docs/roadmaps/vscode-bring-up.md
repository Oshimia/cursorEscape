# VS Code bring-up roadmap (4th sync stack)

**Status:** Phases 0–3 complete 2026-09-01 (same-session bring-up, owner-directed). Phase 4 (Apply + smoke) pending operator authorization.

## Context

Closes the parked "VSCode overlay bring-up (follow-on consumer)" item in [overlay-remediation](./overlay-remediation.md) (goals line ~21, out-of-scope lines ~32/121): the 4th stack inherits the proven v2 `base:`/`shared:` sourcing once it was verified on Cursor/OpenCode/Antigravity.

Authoritative design inputs:

- Load-surface map (docs-verified): [analysis/vscode-load-surface-2026-09.md](../../analysis/vscode-load-surface-2026-09.md)
- Overlay map + host facts: [overlays/vscode/_index.md](../../overlays/vscode/_index.md)
- Plan + review log: plan_reviewer APPROVED (2 passes; GitHub Copilot session)

## Decisions locked

| Decision | Value |
|---|---|
| LiveRelativeRoot | `.copilot` (`~/.copilot/` — instructions/agents/skills; prompt files not used, Agent Host reads `~/.copilot`) |
| Gates | always-on via `applyTo: '**'` instructions (2 thin files) |
| Skills | SKILL.md at `~/.copilot/skills/<id>/` — 11-id parity bar; `disable-model-invocation: true` for owner-invoked ids (owner-invoked split handled natively by VS Code frontmatter, no `.prompt.md` split needed) |
| Agents | 8 `.agent.md` roles; reviewers read-only via `tools` arrays; handoffs wire the loop UI |
| Machinery | manifest-generic adapter (Antigravity clone); owner-approved 4-stack Core gate edit; check scripts 4-stack aware |

## Phases

- [x] **Phase 0 — Discovery & baseline:** load-surface map authored; pre-bringup baseline `C:\Users\admin\.copilot-backup-pre-vscode-bringup-20260901-120000` (+ baseline JSON entry, restore-only); clean-surface inventory recorded
- [x] **Phase 1 — Overlay authorship:** `overlays/vscode/` complete (instructions header/footers, 3 authored-delta skill stubs, 8 agent defs, `_index.md`, pointer-only review-subagent-models)
- [x] **Phase 2 — Sync machinery:** manifest (21 entries), `Vscode.Adapter.ps1`, registry +core gate edits, Fast-CI structural block + vscode fail-closed baseline fixtures; unit 22/22, remediation 65/65, Fast CI 92 passes green; existing 3 stacks' renders byte-identical (stash-diff zero-diff gate)
- [x] **Phase 3 — Docs cascade:** this roadmap, SOP, indexes, README rows, live-sync row
- [x] **Phase 4 — Verify & Apply:** dry-run gates (done for Vscode single + All); operator-authorized `-Target Vscode -AllowSkew -Apply`; full VS Code restart; smoke attestation (C1–C6 table below); then live==planned verdict recorded here

## C1–C6 smoke matrix (fill at Phase 4)

| # | Check | Method | Status |
|---|---|---|---|
| C1 | Always-on gates load | Diagnostics view lists both instructions files; quote-probe answers from context in a clean workspace | pending |
| C2 | Skill catalog complete | Diagnostics lists 11 skills; `/discovery` etc. resolve as slash commands | pending |
| C3 | Reviewers spawnable + isolated | plan_reviewer/reviewers selectable from agents dropdown with clean context (depth-1 deviation attested) | pending |
| C4 | Excludes/NeverTouch intact | `config.json`, `ide/`, `logs/` untouched post-Apply (hash/snapshot) | pending |
| C5 | Token merge complete | Post-Apply live files contain zero `{{...}}` tokens | pending |
| C6 | Loop exercises end-to-end | Operator runs plan → implement → dual review → closeout through synced surfaces | pending |

## Deviations attested

- **Subagent depth 1** (children cannot spawn subagents) — reviewer fan-out stays parent-side; per Antigravity C3 precedent.
- **Model assignment** — `model` frontmatter left unset (picker default); U13 open.
