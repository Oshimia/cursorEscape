# OpenCode overlay — copy-out map

**Last updated:** 2026-08-20  
**Status:** Phase 2 authored — **copy-out authorized** for OpenCode host-plugged paths (Phase 3 executes live sync).  
**Fidelity bar:** [host-adaptation-fidelity](../../docs/featureArchitecture/host-adaptation-fidelity.md) (C1–C6).

## Context

OpenCode-native **host overlay** at `overlays/opencode/`. Portable procedure stays at repo-root bases (`workflow/`, `skills/`, `agents/`, `rules/`). Overlay = thin harness + host-native agent bodies (**strategy A** — 1:1 copy-out). Live `~/.config/opencode` is **not** overwritten until Phase 3 backup + operator sync.

**Tokens (Phase 3 merge):** `{{COMPANION_ROOT}}` = absolute path to this git repo; `{{OPENCODE_HOME}}` = absolute path to OpenCode global config (e.g. `C:/Users/admin/.config/opencode`).

## Copy-out map (host-plugged)

| Copy to `{{OPENCODE_HOME}}/` | Overlay source | Notes |
| ---------------------------- | -------------- | ----- |
| `instructions/cursor-escape-loop.md` | [instructions/cursor-escape-loop.md](./instructions/cursor-escape-loop.md) | Always-on gates (C1) |
| `skills/<id>/SKILL.md` (×8) | [skills/](./skills/) | On-demand harness; `name` + `description` required (C2) |
| `agents/<role>.md` (×7) | [agents/](./agents/) | Strategy A host-native bodies (C3) |
| `docs/workflow/*` | Companion `workflow/` + [scripts/Rewrite-OpenCodeWorkflowLinks.ps1](./scripts/Rewrite-OpenCodeWorkflowLinks.ps1) | Mirrored deep docs (C4) |
| `docs/workflow/review-subagent-models.md` | [review-subagent-models.md](./review-subagent-models.md) | Model hints (not in companion `workflow/`) |
| `docs/workflow/bug-reviewer-finding-rubric.md` | Companion `docs/featureArchitecture/bug-reviewer-finding-rubric.md` | Rubric for bug_reviewer — **transform via script `-IncludeRubric`** (Phase 3 copy) |
| `opencode.json` (harness merge) | [opencode.specimen.json](./opencode.specimen.json) | Merge tokens; **preserve** operator `model` / `provider` (not in specimen sole form) |

**README-only host workflow:** After sync, `docs/workflow/README.md` is the workflow index on the host (transformed from companion `workflow/_index.md`). Do not author a second procedure tree under the adapter.

## Sync vs pointer

| Class | Paths | Phase 3 action |
| ----- | ----- | -------------- |
| **Sync (copy-out)** | `instructions/*`, `skills/*/SKILL.md`, `agents/*.md`, harness keys in `opencode.json`, mirrored `docs/workflow/*`, `review-subagent-models.md`, rubric | Copy overlay + transformed workflow mirror |
| **Pointer (companion-resident)** | `docs/featureArchitecture/**`, `docs/SOPs/**`, `docs/roadmaps/**`, `research/**`, `analysis/**`, maintainer indexes | `external_directory` allow on `{{COMPANION_ROOT}}/**` (C5) |
| **Contract SoT (diff only)** | Repo-root `agents/*.md` | Portable contracts — **do not paste** onto host files; re-diff when portable `agents/` change |

## Transform table (workflow mirror — sync method A)

Applied by [Rewrite-OpenCodeWorkflowLinks.ps1](./scripts/Rewrite-OpenCodeWorkflowLinks.ps1) when copying companion `workflow/` → host `docs/workflow/`:

| Companion `workflow/` link | Host `docs/workflow/` link |
| -------------------------- | -------------------------- |
| `](../skills/` | `](../../skills/` |
| `](../agents/` | `](../../agents/` |
| `](../rules/` | Plain text note (OpenCode uses instructions + skills) |
| `](../research/` | Plain text note (companion-resident — `{{COMPANION_ROOT}}/research/...`) |
| `](../overlays/cursor/review-subagent-models.md)` | `](review-subagent-models.md)` |
| `](_index.md)` | `](README.md)` |
| `+ Bugbot (built-in)` | `+ bug_reviewer` |

Idempotent: re-run after edits; grep-clean contract = zero `](../workflow/`, `](../skills/` (from workflow mirror), `](../rules/`, `](../overlays/` in host `docs/workflow/`.

**Rubric copy-out (same script, `-IncludeRubric`):** companion `docs/featureArchitecture/bug-reviewer-finding-rubric.md` → host `docs/workflow/bug-reviewer-finding-rubric.md`. No second authored rubric SoT — single FA source, transformed on copy.

| Companion rubric link | Host `docs/workflow/` after transform |
| --------------------- | ------------------------------------- |
| `](../../agents/` | `](../../agents/` (unchanged — host adapter root) |
| `](../../research/` | Plain text note (companion-resident — `{{COMPANION_ROOT}}/research/...`) |
| `](../../analysis/` | Plain text note (companion-resident — `{{COMPANION_ROOT}}/analysis/...`) |
| `](./<fa-leaf>.md)` (sibling FA) | Plain text note (companion FA — `{{COMPANION_ROOT}}/docs/featureArchitecture/<fa-leaf>.md`) |

Grep-clean rubric contract = zero raw `](../../research/`, `](../../analysis/`, `](./` sibling FA hops in host `docs/workflow/bug-reviewer-finding-rubric.md` after `-IncludeRubric` transform.

## Agent authoring recipe (strategy A)

1. Edit portable contract at repo-root `agents/<role>.md` when **semantics** change.
2. Re-adapt overlay `agents/<role>.md` from live specimen or portable contract — **host-native** body with OpenCode frontmatter (`description`, `mode`, `permission.edit: deny` on reviewers).
3. Use **stack-local** Read paths only: `docs/workflow/...`, `skills/<id>` via skill tool — **never** `../workflow/`, `../skills/`, `../rules/`, `../overlays/` hops in overlay harness.
4. Re-diff portable vs overlay when portable `agents/` change (trigger below).
5. Full quit + restart OpenCode after config-time edits.

## Portable agent contract diff trigger

When repo-root `agents/*.md` changes, re-diff overlay `agents/*.md` vs portable contracts and vs live `{{OPENCODE_HOME}}/agents/*.md` before Phase 3 sync. Record intentional deltas on this index.

## Specimen vs live `agent.*` keys (row 14)

Compared `opencode.specimen.json` vs live `C:/Users/admin/.config/opencode/opencode.json` (2026-08-20):

| Key | Specimen | Live | Match |
| --- | -------- | ---- | ----- |
| `agent.plan` | bash allowlist (git + listing) | same structure | **yes** |
| `agent.build.permission.skill` | `*`: allow | same | **yes** |
| `agent.build.permission.bash` | git + listing allowlist | same | **yes** |
| `agent.build.permission.task` | deny `*`; allow workflow subagents + general/explore/scout | same ids | **yes** |
| `agent.implementer.mode` | primary | primary | **yes** |
| `agent.implementer.permission.task` | deny `*`; same as build **plus** `implementer`: allow (Composer Task → phase implementer) | omits `implementer` (same gap as pre-fix live) | **no** — specimen fixes fidelity; **Phase 3 merge must set** `agent.implementer.permission.task.implementer` = `allow` on live `opencode.json` |

**Not in specimen (operator merge in Phase 3):** top-level `model`, `provider`, absolute paths in `external_directory` / `skills.paths` (specimen uses `{{OPENCODE_HOME}}` / `{{COMPANION_ROOT}}` tokens).

### Rewrite script dry-run (no `COMPANION_ROOT` required)

From repo root, dry-run against companion `workflow/` without setting env vars:

```powershell
pwsh -File overlays/opencode/scripts/Rewrite-OpenCodeWorkflowLinks.ps1 `
  -SourceDir (Resolve-Path workflow) `
  -DestDir $env:TEMP/opencode-workflow-dryrun `
  -IncludeRubric `
  -RubricSourcePath (Resolve-Path docs/featureArchitecture/bug-reviewer-finding-rubric.md)
```

`-SourceDir` may point at repo `workflow/` directly. `-DestDir` may be any writable temp path for dry-run; Phase 3 `-Apply` uses `{{OPENCODE_HOME}}/docs/workflow`. Optional: set `COMPANION_ROOT` instead of `-SourceDir` (default source = `$COMPANION_ROOT/workflow`).

## Workflow leaf manifest (Phase 2 baseline)

Companion `workflow/` leaves mirrored to host `docs/workflow/` (**10** files):

| # | Companion leaf | Host mirror |
| - | -------------- | ----------- |
| 1 | `discovery.md` | `docs/workflow/discovery.md` |
| 2 | `documentation-architecture.md` | `docs/workflow/documentation-architecture.md` |
| 3 | `phased-multi-agent.md` | `docs/workflow/phased-multi-agent.md` |
| 4 | `plan-agent-context.md` | `docs/workflow/plan-agent-context.md` |
| 5 | `iterative-plan-review.md` | `docs/workflow/iterative-plan-review.md` |
| 6 | `iterative-code-review.md` | `docs/workflow/iterative-code-review.md` |
| 7 | `ci-ladder.md` | `docs/workflow/ci-ladder.md` |
| 8 | `_index.md` → | `docs/workflow/README.md` |
| 9 | *(overlay)* | `docs/workflow/review-subagent-models.md` |
| 10 | *(FA rubric)* | `docs/workflow/bug-reviewer-finding-rubric.md` |

Phase 3 smoke: leaf count must match this baseline unless this table is updated in the same program phase.

## Skills inventory (8 — C2)

| Skill id | Overlay |
| -------- | ------- |
| discovery | [skills/discovery/SKILL.md](./skills/discovery/SKILL.md) |
| implementation-plan | [skills/implementation-plan/SKILL.md](./skills/implementation-plan/SKILL.md) |
| plan-review | [skills/plan-review/SKILL.md](./skills/plan-review/SKILL.md) |
| implementation-review | [skills/implementation-review/SKILL.md](./skills/implementation-review/SKILL.md) |
| pre-commit-ci-gate | [skills/pre-commit-ci-gate/SKILL.md](./skills/pre-commit-ci-gate/SKILL.md) |
| composer | [skills/composer/SKILL.md](./skills/composer/SKILL.md) |
| documentation-architecture | [skills/documentation-architecture/SKILL.md](./skills/documentation-architecture/SKILL.md) |
| roadmap | [skills/roadmap/SKILL.md](./skills/roadmap/SKILL.md) |

## Agents inventory (7)

| Agent | Overlay | Portable contract (diff only) |
| ----- | ------- | ----------------------------- |
| planner | [agents/planner.md](./agents/planner.md) | [agents/planner.md](../../agents/planner.md) |
| plan_reviewer | [agents/plan_reviewer.md](./agents/plan_reviewer.md) | [agents/plan_reviewer.md](../../agents/plan_reviewer.md) |
| implementer | [agents/implementer.md](./agents/implementer.md) | [agents/implementer.md](../../agents/implementer.md) |
| production_readiness_reviewer | [agents/production_readiness_reviewer.md](./agents/production_readiness_reviewer.md) | [agents/production_readiness_reviewer.md](../../agents/production_readiness_reviewer.md) |
| bug_reviewer | [agents/bug_reviewer.md](./agents/bug_reviewer.md) | [agents/bug_reviewer.md](../../agents/bug_reviewer.md) |
| repository_explorer | [agents/repository_explorer.md](./agents/repository_explorer.md) | [agents/repository_explorer.md](../../agents/repository_explorer.md) |
| test_reviewer | [agents/test_reviewer.md](./agents/test_reviewer.md) | [agents/test_reviewer.md](../../agents/test_reviewer.md) |

## Author-time C1–C5 attestation (Phase 2)

| # | Item | Phase 2 evidence |
| - | ---- | ---------------- |
| **C1** | Always-on gates | `opencode.specimen.json` lists `instructions/cursor-escape-loop.md`; instruction states plan + implementation-review gates |
| **C2** | Eight skills incl. `roadmap` | Eight overlay `skills/*/SKILL.md` with matching `name`; host-adapter row 9 + Probe A updated |
| **C3** | Reviewers deny-edit; loops cited | Seven overlay agents; reviewers `permission.edit: deny`; bodies cite `docs/workflow/iterative-*` and rubric |
| **C4** | Host-relative Reads | Skill Read tables use `../../docs/workflow/...`; agents use `docs/workflow/...`; rewrite script dry-run + idempotency |
| **C5** | Companion FA reads | Specimen `external_directory` includes `{{COMPANION_ROOT}}/**` |
| **C6** | Runtime smoke | N/A author-time — Phase 3 operator smoke |

## Related

- [Overlays index](../_index.md)
- [Host adaptation fidelity](../../docs/featureArchitecture/host-adaptation-fidelity.md)
- [OpenCode overlays SoT roadmap](../../docs/roadmaps/opencode-overlays-sot.md)
- [OpenCode host adapter SOP](../../docs/SOPs/opencode-host-adapter.md)
- [Authoring OpenCode adapter](../../docs/SOPs/opencode-authoring-adapter.md)
- [Workflow index](../../workflow/_index.md)
- [Portable skills](../../skills/_index.md)
- [Portable agents](../../agents/_index.md)
