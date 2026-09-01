# cline overlay (5th stack — VS Code extension harness)

**Stack:** `Cline` · **Live root:** `~/.cline/` (docs-verified 2026-09-01; see `analysis/cline-kilo-probes-2026-09.md`) · **Manifest:** `scripts/host-sync/manifests/cline.manifest.psd1` · **Adapter:** shared `Generic.Adapter.ps1` (dispatch fallback — no per-stack adapter file)

Thin host harness per Approach A. Pointer-first: rule/workflow bodies Read companion procedure via absolute `{{COMPANION_ROOT}}` paths after token merge.

## Host facts (Cline VS Code ext, docs 2026-09-01)

| Fact | Value | Consequence |
|---|---|---|
| Global rules | `~/.cline/rules/` | 1 always-on composed rule (this stack) |
| Global workflows | `~/.cline/data/workflows/` | plan/review/closeout trio |
| Rules toggles | new files default-ON; user can toggle OFF | deviation row: gate persistence depends on toggles |
| Dual review | serial in-chat (no subagent spawn; per cline-cli-subagent orchestr analysis) | reviewers personified in wiring footer |
| MCP | `~/.cline/data/settings/cline_mcp_settings.json` | NeverTouch |
| Compat dirs | `~/Documents/Cline/{Rules,Workflows}` read too | fallback table (composite dest) only if probe claims primary scan fails |

## Copy-out map

| Live dest | Source class | Authored here? |
|---|---|---|
| `rules/cursor-escape-loop.md` | composed: `instructions/__header__.md` + `base:rules/iterative-plan-review.md` + `base:rules/iterative-code-review.md` + `base:rules/pre-commit-ci-gate.md` + `footers/cline-wiring.md` | header/footer (host wiring; serial-review deviation inside footer) |
| `data/workflows/plan.md`, `data/workflows/review.md`, `data/workflows/closeout.md` | authored in this overlay (serial-review adaptation) | trio only (host-adapted) |
| `data/workflows/<11 ids>.md` | `shared:skills/<id>/SKILL.md` + host Substitutions; composed pre-commit | nothing (render-out) |

Pointer-only (never copied): `_index.md`, this mapping, companion SoT trees.

## Skills→workflows parity inventory (11 ids)

`discovery` · `implementation-plan` · `plan-review` · `implementation-review` · `pre-commit-ci-gate` · `composer` · `documentation-architecture` · `roadmap` · `diagnosing-bugs` · `opencode-headless-run` · `opencode-history-search`

## Deliberate exclusions

- `~/.cline/data/{sessions,db,cache,workspaces,settings/{providers,global-settings}}`, MCP settings — **NeverTouch** (live app state; secrets).
- `~/Documents/Cline/**` — compat path; not written (read-only consideration).
- No agent defs synced (serial in-chat reviewers per deviation).
