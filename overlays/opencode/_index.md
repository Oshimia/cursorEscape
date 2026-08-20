# OpenCode overlay — harness copy-out map

**Last updated:** 2026-08-20  
**Status:** **pointer-first-2** (Nb) — harness stubs rewritten to absolute `{{COMPANION_ROOT}}` Reads; live stub sync applied after backup (see [skills.paths probe](../../analysis/opencode-pointer-first-2-skills-paths-probe-2026-08.md)). Awaiting Composer QC commit. **Load path:** companion SoT + thin harness; deep procedure via `{{COMPANION_ROOT}}/workflow/` Reads — **not** host `docs/workflow/` mirror as SoT.  
**Fidelity bar:** [host-adaptation-fidelity](../../docs/featureArchitecture/host-adaptation-fidelity.md) (C1–C6).

## Context

OpenCode-native **host overlay** at `overlays/opencode/`. Portable procedure stays at repo-root bases (`workflow/`, `skills/`, `agents/`, `rules/`). Overlay = **thin harness** + host-native agent bodies. Live `~/.config/opencode` was synced from this overlay in Phase 3 (backup first — see [host-adapter smoke](../../docs/SOPs/opencode-host-adapter.md)). **pointer-first-0 lock:** harness-only sync below; mirrored `docs/workflow/*` is **legacy transitional** — not sync SoT.

**Tokens (Phase 3 merge):** `{{COMPANION_ROOT}}` = absolute path to this git repo; `{{OPENCODE_HOME}}` = absolute path to OpenCode global config (e.g. `C:/Users/admin/.config/opencode`).

**C1 merge Must (Failure mode I / wrong-base class):** Specimen `instructions` must stay `{{OPENCODE_HOME}}/instructions/cursor-escape-loop.md` (absolute after merge). Never reintroduce bare relative `instructions/…` in global config. Copy the same body to live `AGENTS.md`.

**C4 merge Must (pointer-first-2):** Harness leaves Read absolute `{{COMPANION_ROOT}}/workflow/...`, `{{COMPANION_ROOT}}/skills/...`, `{{COMPANION_ROOT}}/agents/...` — **zero** `../../docs|skills|agents/` hops and **zero** host `docs/workflow/` as procedure SoT in harness bodies. Legacy host mirror may remain on disk until pointer-first-4 — do not author new procedure there. See [Wrong path resolution base](../../docs/featureArchitecture/host-adaptation-fidelity.md#wrong-path-resolution-base-failure-class--i--j).

## Copy-out map (harness-only — pointer-first Target)

| Copy to `{{OPENCODE_HOME}}/` | Overlay source | Notes |
| ---------------------------- | -------------- | ----- |
| `instructions/cursor-escape-loop.md` | [instructions/cursor-escape-loop.md](./instructions/cursor-escape-loop.md) | Always-on gates body (C1) |
| `AGENTS.md` | [AGENTS.md](./AGENTS.md) | **Same gates** — OpenCode global rules surface (must match `instructions/cursor-escape-loop.md`) |
| `skills/<id>/SKILL.md` (×8) | [skills/](./skills/) | Thin harness stubs → absolute `{{COMPANION_ROOT}}` Reads (C2; pointer-first-2 rewrites bodies) |
| `agents/<role>.md` (×7) | [agents/](./agents/) | Thin harness bodies (C3) |
| `opencode.json` (harness merge) | [opencode.specimen.json](./opencode.specimen.json) | Merge tokens; **preserve** operator `model` / `provider` (not in specimen sole form) |
| `docs/workflow/review-subagent-models.md` | [review-subagent-models.md](./review-subagent-models.md) | Thin overlay leaf (model hints) — harness sync; **not** companion `workflow/` SoT |

**Legacy transitional (not harness-only sync SoT — disposition pointer-first-4):** mirrored `docs/workflow/*` (procedure leaves), rubric under `docs/workflow/`. Produced by archived [Rewrite-OpenCodeWorkflowLinks.ps1](./scripts/Rewrite-OpenCodeWorkflowLinks.ps1) — **not primary sync** after pointer-first-0; retained for Phase 3 live tree until mirror delete proof.

**README-only host workflow (legacy):** After historical sync, `docs/workflow/README.md` was the workflow index on the host. **Target:** companion `{{COMPANION_ROOT}}/workflow/_index.md` via absolute Read — do not author a second procedure tree under the adapter.

## Sync vs pointer (pointer-first-0 lock)

| Class | Paths | Action |
| ----- | ----- | ------ |
| **Sync (harness-only)** | `instructions/*`, `AGENTS.md` (same body as loop instructions), thin `skills/*/SKILL.md`, thin `agents/*.md`, `docs/workflow/review-subagent-models.md` (from [review-subagent-models.md](./review-subagent-models.md)), harness keys in `opencode.json` | Copy overlay harness; resolve `{{COMPANION_ROOT}}` / `{{OPENCODE_HOME}}` tokens on live merge; stub bodies Read `{{COMPANION_ROOT}}/workflow/`, `skills/`, `agents/` — **not** procedure mirror re-sync |
| **Pointer (companion-resident — SoT)** | `workflow/**`, repo-root `skills/**`, `agents/**`, `rules/**`, `docs/featureArchitecture/**`, `docs/SOPs/**`, `docs/roadmaps/**`, `research/**`, `analysis/**`, maintainer indexes | `external_directory` allow on `{{COMPANION_ROOT}}/**` (C5); absolute Reads from harness |
| **Legacy transitional (not sync SoT)** | Mirrored host `docs/workflow/*` (procedure leaves), rubric on host under `docs/workflow/` | Remains on disk from Phase 3 until [pointer-first-4](../../docs/roadmaps/pointer-first.md) mirror disposition; **do not treat as procedure SoT** |
| **Contract SoT (diff only)** | Repo-root `agents/*.md` | Portable contracts — **do not paste** onto host files; re-diff when portable `agents/` change |

## Transform table (workflow mirror — archived; not primary sync)

**Status (pointer-first-0):** [Rewrite-OpenCodeWorkflowLinks.ps1](./scripts/Rewrite-OpenCodeWorkflowLinks.ps1) is **archived** — used for Phase 3 historical mirror only. **Not** the Target load path after pointer-first-0. **Target load path (pointer-first-2):** harness stub bodies Read `{{COMPANION_ROOT}}/workflow/<leaf>.md` directly. Mirror delete proof: [pointer-first-4](../../docs/roadmaps/pointer-first.md).

Applied historically by the script when copying companion `workflow/` → host `docs/workflow/`:

| Companion `workflow/` link | Host `docs/workflow/` link |
| -------------------------- | -------------------------- |
| `](../skills/` | `](skills/` (**host-root** — not `../../skills/`; Failure mode J class) |
| `](../agents/` | `](agents/` (same) |
| `](../rules/` | Plain text note (OpenCode uses instructions + skills) |
| `](../research/` | Plain text note (companion-resident — `{{COMPANION_ROOT}}/research/...`) |
| `](../overlays/cursor/review-subagent-models.md)` | `](review-subagent-models.md)` |
| `](_index.md)` | `](README.md)` |
| `+ Bugbot (built-in)` | `+ bug_reviewer` |

Idempotent: re-run after edits; grep-clean contract = zero `](../workflow/`, `](../skills/`, `](../../skills/`, `](../../agents/`, `](../rules/`, `](../overlays/` in host `docs/workflow/`.

**Rubric copy-out (same script, `-IncludeRubric`):** companion `docs/featureArchitecture/bug-reviewer-finding-rubric.md` → host `docs/workflow/bug-reviewer-finding-rubric.md`. No second authored rubric SoT — single FA source, transformed on copy.

| Companion rubric link | Host `docs/workflow/` after transform |
| --------------------- | ------------------------------------- |
| `](../../agents/` | `](agents/` (host-root — Failure mode J class) |
| `](../../research/` | Plain text note (companion-resident — `{{COMPANION_ROOT}}/research/...`) |
| `](../../analysis/` | Plain text note (companion-resident — `{{COMPANION_ROOT}}/analysis/...`) |
| `](./<fa-leaf>.md)` (sibling FA) | Plain text note (companion FA — `{{COMPANION_ROOT}}/docs/featureArchitecture/<fa-leaf>.md`) |

Grep-clean rubric contract = zero raw `](../../agents/`, `](../../research/`, `](../../analysis/`, `](./` sibling FA hops in host `docs/workflow/bug-reviewer-finding-rubric.md` after `-IncludeRubric` transform.

## Agent authoring recipe (strategy A)

1. Edit portable contract at repo-root `agents/<role>.md` when **semantics** change.
2. Re-adapt overlay `agents/<role>.md` from live specimen or portable contract — **host-native** body with OpenCode frontmatter (`description`, `mode`, `permission.edit: deny` on reviewers).
3. Use **absolute companion** Read paths: `{{COMPANION_ROOT}}/workflow/...`, `{{COMPANION_ROOT}}/skills/...`, `{{COMPANION_ROOT}}/agents/...` — load skills by id via skill tool; **never** `../../docs|skills|agents/` hops (Failure mode J).
4. Re-diff portable vs overlay when portable `agents/` change (trigger below).
5. Full quit + restart OpenCode after config-time edits.

## Portable agent contract diff trigger

When repo-root `agents/*.md` changes, re-diff overlay `agents/*.md` vs portable contracts and vs live `{{OPENCODE_HOME}}/agents/*.md` before the next live re-sync. Record intentional deltas on this index.

## Specimen vs live `agent.*` keys (row 14)

Compared `opencode.specimen.json` vs live `C:/Users/admin/.config/opencode/opencode.json` (2026-08-20):

| Key | Specimen | Live | Match |
| --- | -------- | ---- | ----- |
| `agent.plan` | bash allowlist (git + listing) | same structure | **yes** |
| `agent.build.permission.skill` | `*`: allow | same | **yes** |
| `agent.build.permission.bash` | git + listing allowlist | same | **yes** |
| `agent.build.permission.task` | deny `*`; allow workflow subagents + general/explore/scout | same ids | **yes** |
| `agent.implementer.mode` | primary | primary | **yes** |
| `agent.implementer.permission.task` | deny `*`; same as build **plus** `implementer`: allow (Composer Task → phase implementer) | same (Phase 3 merge 2026-08-20) | **yes** — live merge set `implementer`: `allow` |

**Not in specimen (preserved on live at Phase 3 merge — complete 2026-08-20):** top-level `model`, `provider`, absolute paths in `external_directory` / `skills.paths` (specimen uses `{{OPENCODE_HOME}}` / `{{COMPANION_ROOT}}` tokens; live merge resolved tokens and preserved operator `model`/`provider`).

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
| **C1** | Always-on gates | Specimen `instructions` = **`{{OPENCODE_HOME}}/instructions/cursor-escape-loop.md`** (absolute — cwd-relative paths do not load from global config); `AGENTS.md` matches that body; instruction states plan + implementation-review gates |
| **C2** | Eight skills incl. `roadmap` | Eight overlay `skills/*/SKILL.md` with matching `name`; host-adapter row 9 + Probe A updated |
| **C3** | Reviewers deny-edit; loops cited | Seven overlay agents; reviewers `permission.edit: deny`; bodies cite `{{COMPANION_ROOT}}/workflow/iterative-*` and companion FA rubric |
| **C4** | Companion workflow Reads (pointer-first-2) | Harness stubs use absolute `{{COMPANION_ROOT}}/workflow/...` Reads — **zero** host `docs/workflow/` as procedure SoT in harness; **zero** `../../` hops |
| **C5** | Companion FA reads | Specimen `external_directory` includes `{{COMPANION_ROOT}}/**` |
| **C6** | Runtime smoke | N/A author-time — Phase 3 operator smoke |

## Related

- [Overlays index](../_index.md)
- [Host adaptation fidelity](../../docs/featureArchitecture/host-adaptation-fidelity.md)
- [OpenCode overlays SoT roadmap](../../docs/roadmaps/opencode-overlays-sot.md) (historical — load path superseded)
- [Companion pointer-first](../../docs/roadmaps/pointer-first.md)
- [OpenCode host adapter SOP](../../docs/SOPs/opencode-host-adapter.md)
- [Authoring OpenCode adapter](../../docs/SOPs/opencode-authoring-adapter.md)
- [Workflow index](../../workflow/_index.md)
- [Portable skills](../../skills/_index.md)
- [Portable agents](../../agents/_index.md)
