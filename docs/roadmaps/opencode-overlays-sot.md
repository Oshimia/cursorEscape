# Roadmap: OpenCode overlays SoT

**Last updated:** 2026-08-20  
**Status:** Phase 3 **complete** (Composer ACCEPT 2026-08-20 — live sync; backup `opencode-backup-20260820-153803`). **Composer waiver:** after renew hub-sweep cap, Reviewer-a banner nits fixed post-cap; Bugbot clean; Fast/Full hub greps passed. Desktop runtime smoke deferred operator (restart + rows 1–4, 9–10, 13).  
**Plan source:** accepted plan `opencode_overlays_sot_1788a195` (copy of Inter-phase + Agent context; do not invent scope).

## Product decisions (locked)

- Repo SoT; live OpenCode host-plugged paths = duplicate of overlay + transformed workflow mirror.
- Full **host-adaptation fidelity** (Phase 0 FA) — Cursor↔OpenCode operator loop parity; reject cosmetic shape-matching.
- Host-plugged vs companion-resident split; companion FA/SOPs stay in-repo + `external_directory` allow.
- Agents: **strategy A** — overlay host-native bodies 1:1 copy-out; portable `agents/` = contract SoT.
- Rules → OpenCode `instructions` (always-on) / skill (deferred `pre-commit-ci-gate`); never host `rules/` tree.
- Sync method **A** (+ archived one-shot pwsh rewrite); B deferred; C rejected.
- Terminology cleanup already on `main`. Fidelity Phase 0 ≠ terminology Phase 0.
- **Review-loop cap (this program):** Phase subagents at most **4** dual-review iterations (Fast CI Observed → reviewer-a ∥ Bugbot → fix). Reset to 1 at phase start and after Composer renew. Spec launches to this phase’s Agent context only. Do not launch a 5th pair. If iteration 4 lacks dual APPROVED: stop, return punch list to Composer. Composer: (1) Renew ≤4 with narrowed spec; (2) Waive out-of-spec/process nits with attestation — **do not waive** Fast/Full CI failures; (3) Change approach. Dual APPROVED preferred.

## Inter-phase contracts

- Shared extend-only hubs: `README.md`, `docs/Roadmap.md`, `overlays/_index.md`, `docs/featureArchitecture/skill-source-and-host-overlays.md`, `docs/SOPs/opencode-host-adapter.md`, `docs/SOPs/opencode-authoring-adapter.md`, `docs/roadmaps/implementation-roadmap.md`, Phase 0 FA `host-adaptation-fidelity.md`, `docs/featureArchitecture/cursor-behavior-to-reproduce.md`.
- **One authored procedure** per skill/workflow leaf. Overlay harness must not paste the loop.
- **Fidelity bar (Phase 0) binds Phases 1–3.**
- **No live sync before Phase 2 dual APPROVED** and authorization doc flip.
- Phase 3 always **backs up** live adapter before overwrite.
- **roadmap** skill: intentional OpenCode catalog expansion.
- Inherit **4-iteration review-loop cap** (see Product decisions).

### Host-adaptation fidelity (binding — Phase 0 authors FA)

Success: same operator loops on Cursor and OpenCode (gates, skill ids, isolation, Incomplete-until / dual-APPROVED). Host chrome may differ; loop semantics must not.

Anti-patterns: cosmetic folder shape; Cursor `rules/` on OpenCode; unwired stubs; Done on file presence without smoke.

**C1–C6 matrix** (Phase 0 FA must ship full table with author-time / runtime / smoke columns — fail Phase 0 if missing):

| # | Item | Author-time (P2) | Runtime (P3) |
| - | ---- | ---------------- | ------------ |
| C1 | Always-on gates inject | Specimen lists instructions; file states both gates | Smoke 1 |
| C2 | Skill catalog (incl. roadmap) | 8 skills with `name`; inventory + row 9 probe | Smoke 9 (+10) |
| C3 | Plan→plan_reviewer; impl→dual→Full/pre-commit | Agents deny-edit; loops cited; rubric path | Smoke 13, 3, 2, 8, 14 |
| C4 | Deep workflow Reads on host | Host-relative Read tables; transform dry-run | Workflow rg + smoke 4 |
| C5 | Companion FA reads without repeated asks | Specimen companion external_directory tokens | Sample FA read; optional 11–12 |
| C6 | Smoke proves behavior not presence | N/A | Attest C1–C5 in host-adapter smoke table |

Minimum Phase 3 smoke: **1, 2, 3, 4, 8, 9–10, 13, 14**.

### Doc boundary (Phase 0 Must)

| Doc | Owns | Must not |
| --- | ---- | -------- |
| `cursor-behavior-to-reproduce.md` | Semantics to reproduce | Wiring recipes / install anti-patterns |
| `host-adaptation-fidelity.md` | Wiring bar, anti-patterns, C1–C6 matrix, Done definition | Re-paste Observed behavior tables |
| `instruction-layering.md` | Always-on vs skill vs deep-doc budget | OpenCode smoke matrices |
| `skill-source-and-host-overlays.md` | SoT vs overlay vs copy-out auth | Full fidelity smoke matrix (cite Phase 0 FA) |

### Host-plugged vs companion-resident

**Host-plugged:** `opencode.json` harness, `instructions/*`, `skills/*/SKILL.md`, overlay `agents/*.md`, mirrored `docs/workflow/*` (+ rubric + review-subagent-models).

**Companion-resident:** FA, SOPs (except short excerpts), research/analysis (except required host Read targets), maintainer indexes.

## Migration / external apply order

1. Phases 0–2 land in git (dual APPROVED each).
2. Phase 3: backup live `C:\Users\admin\.config\opencode` → sync host-plugged → pwsh rewrite → merge `opencode.json` → operator quit/restart → smoke.
3. No other external systems. Phase 3 is a **user-apply / operator** gate for smoke; Nb may prepare docs/checklists but operator runs Desktop smoke.

## Checklist

- [x] Phase 0 — Host-adaptation fidelity FA + hub/SOP wiring. Dual APPROVED iter 4 after Composer QC rejects on Bugbot transcript mismatches; Fast/Full doc greps passed.
- [x] Phase 1 — Thin discovery + plan-review skills; merge Must-nots. Dual APPROVED after Composer renew for eval-freeze Step 0 guidance.
- [x] Phase 2 — `overlays/opencode/` + authorization flip + archived pwsh. Dual APPROVED after Composer renews (implementer.task allow, rubric `-IncludeRubric`).
- [x] Phase 3 — Backup + live sync + C1–C6 smoke attestation (install-time pass rows 8/14; Desktop runtime smoke deferred operator)

---

## Agent context — Phase 0

- **Goal:** Make **complete host adaptation** and **Cursor↔OpenCode operator workflow parity** an explicit, binding architecture contract — not implied polish.
- **Depends on / entry gate:** Plan accepted; working tree clean on `main`.
- **Do not touch:** Live `~/.config/opencode`; overlay trees; portable procedure bodies except Related/index links.
- **In scope:** Author new FA leaf [`docs/featureArchitecture/host-adaptation-fidelity.md`](../featureArchitecture/host-adaptation-fidelity.md) covering: success criterion, Required adaptation vs anti-patterns, OpenCode load-surface map cite, **checklist→verification matrix (C1–C6)** with author-time vs runtime vs smoke columns, **doc boundary table**, phase-number disambiguation (“OpenCode overlay program phases 0–3” ≠ shared-workflow Phase 1–6), Related links. Wire FA `_index`; add short Must / Must-not to both OpenCode SOPs; Roadmap note that new stacks require full plug-in. Add Related forward-pointer on skill-source that copy-out authorization flips in Phase 2. State future Cursor refresh must meet the same bar.
- **Out of scope:** Authoring `overlays/opencode/`; live sync; changing loop semantics; flipping copy-out authorization (Phase 2).
- **Files expected:** New FA leaf with matrix + boundary table; FA `_index` + Related updates; SOP Must/Must-not deltas; skill-source Related forward-pointer; Roadmap one-liner if needed.
- **Where to read context:** this roadmap fidelity + matrix sections; plan `opencode_overlays_sot_1788a195`; OpenCode Rules/Config docs; existing OpenCode SOPs; `cursor-behavior-to-reproduce.md`; `analysis/opencode-skill-binding-discovery-2026-08.md`.
- **Fast CI:** FA exists with anti-patterns + **complete C1–C6 matrix** + doc boundary table; SOPs cite the FA; hubs link it.
- **Full CI:** Same + no language that treats “folder present” as Done without load/smoke; matrix columns usable by Phase 2/3 reviewers without inventing methods.
- **Deliverables:**
  - [x] Host-adaptation fidelity FA with enforceable matrix + doc boundary
  - [x] Hubs/SOPs wired (+ skill-source forward-pointer)
  - [x] Dual APPROVED
- **Review loop:** Inherit **4-iteration cap**. Spec = Phase 0 files only.
- **Risks:** Vague “be careful” prose without matrix — fail Phase 0 Full CI if matrix incomplete.

## Agent context — Phase 1

- **Goal:** Eliminate discovery/plan-review forks; SoT owns thin skill entries + workflow.
- **Depends on / entry gate:** Phase 0 dual APPROVED (or Composer-attested waiver per cap).
- **Do not touch:** Live `~/.config/opencode`; `overlays/cursor/`; imported research bodies.
- **In scope:** Written line-by-line diff of live discovery/plan-review vs workflow + implementation-plan; merge unique portable Must-nots into `workflow/discovery.md` covering **both** root `research/imported/` and live `docs/research/imported/` wording; clarify OpenCode Step 0 host-equivalent; add `skills/discovery/SKILL.md` + `skills/plan-review/SKILL.md` (thin — **no** Incomplete-until enum paste); update `skills/_index.md` and any FA/SOP “no SKILL.md” claims.
- **Out of scope:** Authoring `overlays/opencode/`; live sync.
- **Files expected:** Two new skill folders; updated `skills/_index.md`; small workflow edits if gaps found; short written unique-sentence checklist.
- **Where to read context:** roadmap comparison (plan); live `C:/Users/admin/.config/opencode/skills/{discovery,plan-review}/SKILL.md`; `workflow/discovery.md`; `workflow/iterative-plan-review.md`; `skills/implementation-plan/SKILL.md`.
- **Fast CI:** Grep new skills for Incomplete-until full enum — zero; skill links open to workflow; `skills/_index` lists both.
- **Full CI:** Same + implementation-plan still sole Incomplete-until SoT.
- **Deliverables:**
  - [ ] Thin discovery + plan-review skills at repo root
  - [ ] `skills/_index.md` lists both
  - [ ] Unique live Must-nots merged + written checklist
  - [ ] Dual APPROVED
- **Review loop:** Inherit **4-iteration cap**.
- **Risks:** Accidental second procedure essay in new skills — keep thin.

## Agent context — Phase 2

- **Goal:** `overlays/opencode/` exists as OpenCode-native harness meeting Phase 0 fidelity bar; docs authorize copy-out; sync-vs-pointer classification recorded.
- **Depends on / entry gate:** Phase 1 dual APPROVED (or Composer waiver).
- **Do not touch:** Live install; procedure bodies in `skills/`/`workflow/` except link fixes needed for OpenCode naming.
- **In scope:** Create overlay tree (8 skill wrappers; 7 host-native agents strategy A; instructions; `opencode.specimen.json` with tokens; `review-subagent-models.md`; `_index.md` with copy-out map, sync-vs-pointer, transform table, README-only, agent recipe, Phase 0 FA cite, workflow leaf baseline); author `scripts/Rewrite-OpenCodeWorkflowLinks.ps1`. Update hubs flipping OpenCode copy-out authorization; smoke row **14**; closeout grep no stale “not authorized” for OpenCode host-plugged. Diff specimen vs live all `agent.*` keys.
- **Out of scope:** Writing into `~/.config/opencode`; Cursor live sync; portable-body agent paste.
- **Files expected:** Full overlay inventory + archived script; hub updates.
- **Where to read context:** Phase 0 FA; live adapter; OpenCode docs; host-adapter + authoring SOPs; portable `agents/` for contract diff only.
- **Fast CI:** Skills have `name`; instructions in specimen; agent `rg` on overlay paths zero for portable hops (incl. `../skills/`, `../rules/`); script dry-run + idempotency; hubs link overlay + Phase 0 FA; smoke row 14 How text.
- **Full CI:** Same + authorization/classification; author-time C1–C5 attestation; row 9 probe for roadmap.
- **Deliverables:**
  - [ ] Overlay tree + archived pwsh
  - [ ] Authorization flipped + author-time C1–C5
  - [ ] Dual APPROVED
- **Review loop:** Inherit **4-iteration cap**.
- **Risks:** Fat portable paste; host `rules/` tree; shape-only overlay — reject.

## Agent context — Phase 3

- **Goal:** Live adapter matches overlay for host-plugged paths; companion pointers readable; operator smoke proves parity per C1–C6.
- **Depends on / entry gate:** Phase 2 dual APPROVED; backup completed.
- **Do not touch:** Repo procedure wording; AppData binaries; `node_modules`/lockfiles; wholesale companion trees.
- **In scope:** Backup live; copy-out map; archived pwsh rewrite; token merge `opencode.json`; inventory-before-delete; restart note; workflow+agent greps; operator smoke **1, 2, 3, 4, 8, 9–10, 13, 14** + C1–C6 attestation in host-adapter table. Shape-present without gates = fail.
- **Out of scope:** Automating Desktop UI catalog in CI; changing Ollama model; full deploy product.
- **Files expected:** Live paths match map; backup retained; smoke table updated.
- **Where to read context:** Phase 0 FA; Phase 2 `_index` + script; host-adapter smoke; skill-binding discovery.
- **Fast CI:** Test-Path; skill names; JSON parse; greps zero; companion sample read.
- **Full CI:** Same + preserve model/provider/inventoried agent.*; leaf count vs Phase 2 baseline; C1–C6 attestation.
- **Deliverables:**
  - [x] Backup + sync + transform
  - [x] Smoke + C1–C6 attestation (install-time rows 8/14; Desktop runtime deferred operator)
  - [ ] Dual APPROVED
- **Review loop:** Inherit **4-iteration cap**. Operator smoke may be Batchable with written reason in host-adapter table only.
- **Risks:** Cosmetic sync — mitigated by C6 fail definition.

## Related

- Plan: `opencode_overlays_sot_1788a195`
- [shared-workflow-docs](./shared-workflow-docs.md) (prior program; copy-out stance updated by Phase 2 of this program)
- [implementation-roadmap](./implementation-roadmap.md)
