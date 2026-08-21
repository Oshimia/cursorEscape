# Assessment spec: mattpocock/skills deep-model run

This document is the **handoff spec** for the deeper reasoning model that runs the skill audit. It converts [catalog.md](./catalog.md) + [index-and-priorities.md](./index-and-priorities.md) into a reproducible, per-skill assessment with a defined output shape, so findings can be triaged and merged by the [handoff roadmap](../../docs/roadmaps/mattpocock-skills-audit.md).

## Reading order

1. [index-and-priorities.md](./index-and-priorities.md) — statuses and tiers (draft).
2. [catalog.md](./catalog.md) — what exists, with pinned URLs.
3. This spec — what to produce.
4. Repo context, as needed: `skills/_index.md`, `agents/_index.md`, `workflow/_index.md`, `rules/_index.md`, `docs/featureArchitecture/` (esp. [instruction-layering](../../docs/featureArchitecture/instruction-layering.md), [skill-source-and-host-overlays](../../docs/featureArchitecture/skill-source-and-host-overlays.md), [clean-context-isolation](../../docs/featureArchitecture/clean-context-isolation.md)), [editing-companion-workflow](../../docs/SOPs/editing-companion-workflow.md).

## Ground rules

- **Snapshot discipline.** Assess the pinned commit `0ab1b63` (2026-08-21). Re-fetch via `https://github.com/mattpocock/skills/blob/0ab1b63/<path>`; do not silently track `main`.
- **Verify, don't trust the README.** Catalog one-line purposes are provisional. Read the actual `SKILL.md` (and deep docs page where one exists) before deciding anything.
- **Fit first.** Every adapt proposal must be judged against cursorEscape's principles: host-agnostic portable contracts at repo root; thin harness + companion procedure; overlay-only host specifics; dual-gate review; clean-context isolation. Host-dependent mechanisms (Claude Code hooks, issue-tracker assumptions, `claude --bg`, Codex `openai.yaml`) are not automatically portable — say so explicitly.
- **Adapt, don't copy.** The deliverable is a **fit assessment against this repo's workflow**, not a catalog of what mattpocock does. Every proposal must describe how the skill is rebuilt to integrate with cursorEscape's existing contracts and current plan/review loop. A verbatim copy of a source `SKILL.md` is **not** an acceptable proposal — if the only option is a straight copy, that is a signal to reconsider the verdict or the integration points.
- **No implementation.** This phase produces findings + proposals only. No edits to `skills/`, `agents/`, `workflow/`, `rules/`, or `overlays/`. Any accepted proposal later goes through the repo's own plan → implement → dual-review → closeout bar (roadmap P3+).

## Excluded from assessment (do not assess)

Owner opt-out (2026-08-21): solo dev, no interest in collaborative/team-workflow skills; non-coding skills mostly not useful. **Skip these — no findings block required** (a one-line note in the summary index is enough).

- **Collaborative / GitHub-or-similar-platform (another dev, team issue tracker, shared maps, another human):** `setup-matt-pocock-skills`, `triage`, `to-spec`, `to-tickets`, `wayfinder`, `to-questionnaire`.
- **Non-coding, no use:** `writing-beats`, `writing-fragments`, `writing-shape`.
- **Exception — assess `teach`** (owner named it as potentially very useful despite being non-coding; it sits at Tier 2).

Git-management skills are **not** excluded: `git-guardrails-claude-code`, `setup-pre-commit`, `resolving-merge-conflicts`, `migrate-to-shoehorn` remain assessable.

## Per-skill assessment (fill for each Tier 1–3 skill)

For each skill, produce a findings block. Tier 1 first, then Tier 2, then Tier 3.

| Field | Requirement |
|-------|-------------|
| Skill + snapshot path | Name, bucket, pinned URL |
| Verified purpose | What it actually does, from `SKILL.md` (1–2 sentences). Note any divergence from the catalog's provisional line |
| Core mechanism | The reusable idea/loop/artifact (e.g. wizard = bash template + `stage` library; code-review = two parallel axes) |
| What it does **better** than the local equivalent | Concrete, evidence-backed (quote the file). "Better" includes: missing capabilities, sharper discipline, better feedback loop, less context cost |
| What cursorEscape does **better** | If the local counterpart has an edge (e.g. dual-gate separation, escalation gates, clean-context isolation), say it |
| Host dependency | Claude-Code-only? Codex? issue-tracker-coupled? portable? |
| Fit with cursorEscape philosophy | Scores per principle: host-agnostic, thin-harness, gate-able, isolated-reviewable |
| Adaptation proposal | One of the verdicts below, with concrete integration points (new skill under `skills/<name>/`, extend `skills/<existing>`, new agent under `agents/`, new `workflow/` doc, adopt pattern only, or reject) |
| Cost + risk | Authoring cost, review burden, overlap/duplication risk with existing skills |
| Verdict | `Adopt` \| `Adapt` \| `Reference-only` \| `Reject` |

### Verdict taxonomy

- **Adopt** — bring the capability into cursorEscape, **rebuilt to fit this repo's workflow and conventions** (never a verbatim copy of the source). State the integration points with existing contracts.
- **Adapt** — take the core mechanism and **rebuild it carefully to work with cursorEscape's current workflows** (portable contract + overlay wrappers). State the specific changes from the source and how it integrates with existing skills/agents/workflow docs.
- **Reference-only** — keep as a studied pattern; do not build locally now. Note the trigger that would change this.
- **Reject** — out of scope / host-locked / duplicates existing discipline with no gain. One-line reason.

## Output artifact

- One file per skill: `research/mattpocock-skill-audit/findings/<skill-name>.md` with the per-skill block above. Alternatively, if the runner prefers a single artifact, one `findings.md` with a section per skill — the roadmap accepts either.
- A **summary index** `research/mattpocock-skill-audit/findings/_index.md` listing every assessed skill, verdict, and one-line reason, so merge triage (roadmap P2) can rank without re-reading every file.

## Infra cross-cutting assessments (one block, after Tier 1, before merge triage)

Assess each infra area from [index-and-priorities.md](./index-and-priorities.md#cross-cutting-infra-fixed-block-after-tier-1-before-merge-triage) with the same evidence discipline but as a **single recommendation per area**:

- `Adopt-pattern` / `Reject` + why, and what it would change in cursorEscape's authoring (e.g. "adopt thin-pointer + docs/ deep page split for future skills", "adopt CONTEXT.md glossary discipline", "reject Claude plugin distribution; keep Sync-HostHarness").

## Adapt-proposal routing

Each `Adopt`/`Adapt` verdict must end with a **proposed roadmap phase** (one line): what the phase builds, which cursorEscape artifacts it touches, and its rough scope. Merge triage (roadmap P2) ranks these; P3+ implements them through the repo's own gates. Do not rank them yourself — that is P2's job.

**Verdicts are draft until the owner discussion.** P1 must present its findings to the owner in a dedicated discussion before any verdict counts as final (roadmap P1 agent context). The owner may disagree with any choice; the discussion record captures amendments, and P2 ranks the **amended** set.

## Done when

- Every Tier 1–3 skill has a findings block (or an explicit skip note in the summary index with a reason).
- The infra block has one recommendation per area.
- The summary index exists with verdicts + one-line reasons.
- No cursorEscape contract files were modified.