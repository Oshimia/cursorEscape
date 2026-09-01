# kilocode overlay (6th stack — Kilo CLI-platform VS Code extension harness)

**Stack:** `Kilocode` · **Live root:** `~/.kilocode/` (legacy-compat auto-consumed; new model root `~/.config/kilo/kilo.jsonc` is the documented future-migration leg — out of scope) · **Manifest:** `scripts/host-sync/manifests/kilocode.manifest.psd1` · **Adapter:** shared `Generic.Adapter.ps1` (dispatch fallback — no per-stack adapter file)

Thin host harness per Approach A. Pointer-first via absolute `{{COMPANION_ROOT}}` Reads after token merge.

## Host facts (Kilo 7.5.6, docs 2026-09-01)

| Fact | Value | Consequence |
|---|---|---|
| Global rules | `.kilocode/rules/` **auto-included** (backward compat; new model = `kilo.jsonc instructions`) | 1 always-on composed rule |
| Global workflows | **auto-migrated from `.kilocode/workflows/` to command format on startup**; slash = `/filename` | trio (`/plan`, `/review`, `/closeout`) |
| Frontmatter | `description`, `agent`, `model`, `variant`, `subtask` | `subtask: true` potential for review legs (probe at smoke before reliance) |
| Subagents | first-class NEW feature; depth/behavior unproven | deviation row reworded (probe at Phase 4 smoke) |
| Rules toggles | none (all discovered rules concatenate always-on; global-first) | no toggle deviation; thin budget mandatory |
| MCP | `<globalStorage>/settings/mcp_settings.json` + `.kilo/mcp.json` | NeverTouch |

## Copy-out map

| Live dest | Source class | Authored here? |
|---|---|---|
| `rules/cursor-escape-loop.md` | composed: `instructions/__header__.md` + `base:rules/iterative-plan-review.md` + `base:rules/iterative-code-review.md` + `base:rules/pre-commit-ci-gate.md` + `footers/kilocode-wiring.md` | header/footer |
| `workflows/plan.md`, `workflows/review.md`, `workflows/closeout.md` | authored in this overlay (interactive dual-review adaptation) | trio only (host-adapted) |

Pointer-only: `_index.md`, companion SoT trees.

## Parity inventory (11 ids) + escape trio

`discovery` · `implementation-plan` · `plan-review` · `implementation-review` · `pre-commit-ci-gate` · `composer` · `documentation-architecture` · `roadmap` · `diagnosing-bugs` · `opencode-headless-run` · `opencode-history-search` — plus the workflow trio `plan` / `review` / `closeout` (workflow names, not skills).

## Deliberate exclusions

- `~/.kilocode/` runtime state beyond rules/workflows (none today on this machine); Kilo globalStorage (`%APPDATA%\Code\User\globalStorage\kilocode.kilo-code\**`) — **NeverTouch** entirely (state.vscdb, settings, MCP).
- `~/.config/kilo/kilo.jsonc` — new-model config; out of scope (documented future-migration leg; any change there is an owner-decided separate change).
