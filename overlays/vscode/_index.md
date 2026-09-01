# vscode overlay (√ VS Code / Copilot harness)

**Stack:** `Vscode` · **Live root:** `~/.copilot/` (docs-verified 2026-09-01; see `analysis/vscode-load-surface-2026-09.md`) · **Manifest:** `scripts/host-sync/manifests/vscode.manifest.psd1` · **Adapter:** `scripts/host-sync/adapters/Vscode.Adapter.ps1`

Thin host harness per Approach A (`docs/featureArchitecture/skill-source-and-host-overlays.md`). Host dirs are copy-out targets, never a second SoT. Pointer-first: stubs Read companion procedure via absolute `{{COMPANION_ROOT}}` paths after token merge.

## Copy-out map (sync-vs-pointer)

| Live dest (`~/.copilot/...`) | Source class | Authored here? |
|---|---|---|
| `instructions/cursor-escape-loop.instructions.md` | composed: `instructions/__header__.md` + `base:rules/iterative-plan-review.md` + `base:rules/iterative-code-review.md` + `footers/instructions-wiring.md` | header/footer only (host wiring) |
| `instructions/pre-commit-gate.instructions.md` | composed: `base:rules/pre-commit-ci-gate.md` + `footers/pre-commit-vscode.md` | footer only |
| `skills/<11 ids>/SKILL.md` | `shared:` opencode authored leaves + host Substitutions; composed pre-commit stub | nothing (render-out) |
| `agents/<8 roles>.agent.md` | local `agents/*.agent.md` (host frontmatter + pointer bodies) | frontmatter + thin pointers |

Pointer-only (never copied out): `review-subagent-models.md` (Cursor-native), this `_index.md`, `analysis/`, `research/`.

## Host facts (stable 2026-09, docs-verified)

| Fact | Value | Consequence |
|---|---|---|
| Instructions `applyTo: '**'` | always-on, all contexts | gates = 2 thin instructions files (budget: instruction-layering) |
| Skills `name` must equal parent dir | dir per id | manifest Dests are `skills/<id>/SKILL.md` exactly |
| Skills ARE slash commands | `/discovery` etc. | owner-invoked skills: `disable-model-invocation: true` |
| Agents `tools: []` semantics | array of tool names; reviewers need read-only sets | read-only enforcement via tools array (not permission fields) |
| `handoffs` | plan → implement → review buttons | loop is literal UI in `implementer`/`planner` agents |
| Diagnostics view | lists loaded customizations + errors | designated verification instrument (C1/C2/C6) |
| Subagent depth | 1 (no grandchild spawn; `analysis/vscode-subagent-recursion-2026-08.md`) | deviation-attested (Antigravity C3 precedent) |

## Skills inventory (parity bar: canonical eleven)

`discovery` · `implementation-plan` · `plan-review` · `implementation-review` · `pre-commit-ci-gate` · `composer` · `documentation-architecture` · `roadmap` · `diagnosing-bugs` · `opencode-headless-run` · `opencode-history-search`

## Agents inventory (8 roles)

`planner` · `plan_reviewer` · `implementer` · `production_readiness_reviewer` · `bug_reviewer` · `repository_explorer` · `test_reviewer` · `composer` (conduct via skill; agent body = thin conductor pointers)

## Deliberate exclusions

- `~/.copilot/config.json` — VS Code/Copilot-managed config; **NeverTouch**.
- `ide/`, `logs/` — transient runtime state; excluded from manifest and baselines.
- No `JsonMerge`, `AgentsDualWrite`, or `HybridRuleIds` legs — VS Code needs none (manifest: CopyEntries only).
