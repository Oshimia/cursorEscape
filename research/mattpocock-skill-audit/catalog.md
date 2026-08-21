# Catalog: mattpocock/skills (full sweep)

**Snapshot pin:** `mattpocock/skills` `main` at `0ab1b63a410a03d3627979a109c8695de27af954` (2026-08-21). Sizes in bytes from the pinned GitHub API tree. Skill purposes are **provisional** one-liners from the repo READMEs — the assessment must verify each against its actual `SKILL.md`.

All skill links point at the pinned commit: `https://github.com/mattpocock/skills/blob/0ab1b63/skills/<bucket>/<name>/SKILL.md`.

**Counts:** 25 promoted (18 engineering + 7 productivity) + 4 misc + 6 in-progress = **35 skills**, plus repo infra.

## Excluded from assessment (owner opt-out, 2026-08-21)

The owner is a solo dev. Skills that assume collaboration on GitHub or similar (another dev, team issue tracker, triage roles, shared maps, or another human) are **not assessed**. Non-coding skills are mostly not assessed, with **`teach`** as the exception. Full rationale and tier placement: [index-and-priorities.md](./index-and-priorities.md#excluded-from-assessment-not-to-be-assessed).

| Excluded skill | Reason |
|----------------|--------|
| `setup-matt-pocock-skills` | Collaborative — wires issue tracker + triage labels + team setup |
| `triage` | Collaborative — issue-tracker triage state machine (team roles/labels) |
| `to-spec` | Collaborative — publishes specs to GitHub/Linear issue tracker |
| `to-tickets` | Collaborative — tracker tickets (local-file mode exists if ever wanted) |
| `wayfinder` | Collaborative — shared decision-ticket map on the tracker |
| `to-questionnaire` | Collaborative — async questionnaire to another human |
| `writing-beats` | Non-coding — article authoring |
| `writing-fragments` | Non-coding — article authoring |
| `writing-shape` | Non-coding — article authoring |

Git-management skills are **not** excluded (owner note): `git-guardrails-claude-code`, `setup-pre-commit`, `resolving-merge-conflicts`, `migrate-to-shoehorn` stay assessable.

## Conventions (from `CLAUDE.md`)

- Buckets: `engineering/` (daily code work), `productivity/` (daily non-code), `misc/` (kept around, not promoted), `in-progress/` (beta, not in plugin), `deprecated/` (gone).
- Promoted buckets ship in the Claude plugin and appear in top-level README; each promoted skill also has a human-facing page at `docs/<bucket>/<name>.md` (published `https://aihero.dev/skills-<name>`).
- Invocation: **user-invoked** = `disable-model-invocation: true` + `policy.allow_implicit_invocation: false` in `agents/openai.yaml`; **model-invoked** = model- or user-reachable.
- `agents/openai.yaml` per skill assigns an agent/model.
- No em-dashes anywhere in the repo prose.

## 1. Engineering — user-invoked (9)

| Skill | Purpose (provisional) | SKILL.md | Docs page | Companions |
|-------|----------------------|----------|-----------|------------|
| [ask-matt](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/ask-matt/SKILL.md) | Router over the user-invoked skills; asks which skill or flow fits | 11417 | [ask-matt.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/ask-matt.md) 10723 | PHASE-BOUNDARIES.md 4249; agents/openai.yaml 137 |
| [grill-with-docs](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/grill-with-docs/SKILL.md) | Grilling session that builds the project's domain model, sharpening terminology and updating CONTEXT.md + ADRs inline | 247 (pointer) | 9922 | agents/openai.yaml 145 |
| [triage](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/triage/SKILL.md) | Move issues through a state machine of triage roles | 6557 | 13140 | AGENT-BRIEF.md 7942; OUT-OF-SCOPE.md 4667; agents 135 |
| [improve-codebase-architecture](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/improve-codebase-architecture/SKILL.md) | Scan a codebase for deepening opportunities, present as a visual HTML report, then grill through whichever you pick | 5993 | 11814 | HTML-REPORT.md 6641; agents 166 |
| [setup-matt-pocock-skills](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/setup-matt-pocock-skills/SKILL.md) | Configure a repo for the engineering skills (issue tracker, triage labels, domain doc layout); run once per repo | 6841 | 9359 | domain.md 2033; issue-tracker-github.md 3731; issue-tracker-gitlab.md 3809; issue-tracker-local.md 1810; triage-labels.md 1045; agents 152 |
| [to-spec](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/to-spec/SKILL.md) | Turn the current conversation into a spec and publish it to the issue tracker; no interview, synthesizes what was already discussed | 3043 | 8790 | agents 135 |
| [to-tickets](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/to-tickets/SKILL.md) | Break any plan/spec/conversation into tracer-bullet tickets, each declaring blocking edges (local file or native tracker links) | 5671 | 10724 | agents 146 |
| [implement](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/implement/SKILL.md) | Build the work described by a spec/tickets, driving `/tdd` at pre-agreed seams, closing out with `/code-review` | 433 (pointer) | 10259 | agents 139 |
| [wayfinder](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/wayfinder/SKILL.md) | Plan a huge chunk of work (more than one session) as a shared map of decision tickets on the tracker, resolved one at a time | 11908 | 15976 | agents 144 |

## 2. Engineering — model-invoked (9)

| Skill | Purpose (provisional) | SKILL.md | Docs page | Companions |
|-------|----------------------|----------|-----------|------------|
| [prototype](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/prototype/SKILL.md) | Build a throwaway prototype to answer a design question (single HTML file for logic, or toggleable UI variations) | 2931 | 9630 | LOGIC.md 6036; UI.md 6913; agents 100 |
| [diagnosing-bugs](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/diagnosing-bugs/SKILL.md) | Disciplined diagnosis loop for hard bugs/performance regressions: feedback loop goes red → minimise → hypothesise → instrument → fix → regression-test | 8529 | 10701 | scripts/hitl-loop.template.sh 1316; agents 103 |
| [research](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/research/SKILL.md) | Investigate a question against high-trust primary sources; capture as a cited Markdown file, run as a background agent | 794 (pointer) | 9674 | agents 94 |
| [tdd](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/tdd/SKILL.md) | Test-driven development with a red-green-refactor loop; features/bugs one vertical slice at a time | 3549 | 10453 | mocking.md 1481; tests.md 2214; agents 87 |
| [domain-modeling](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/domain-modeling/SKILL.md) | Actively build and sharpen the project's domain model: challenge terms against the glossary, stress-test with scenarios, update CONTEXT.md + ADRs inline | 3331 | 10742 | ADR-FORMAT.md 2733; CONTEXT-FORMAT.md 2290; agents 101 |
| [codebase-design](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/codebase-design/SKILL.md) | Shared discipline/vocabulary for designing deep modules: a lot of behaviour behind a small interface, clean seam, testable through it | 6446 | 12370 | DEEPENING.md 2553; DESIGN-IT-TWICE.md 2664; agents 102 |
| [code-review](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/code-review/SKILL.md) | Two-axis review of the diff since a fixed point: **Standards** (repo standards + Fowler smell baseline) and **Spec** (faithful to the issue/spec), run as parallel sub-agents | 6589 | 10553 | agents 100 |
| [resolving-merge-conflicts](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/resolving-merge-conflicts/SKILL.md) | Work through an in-progress merge/rebase conflict hunk by hunk, resolving by intent traced to each side's primary source, then finish (never `--abort`) | 918 (pointer) | 5326 | agents 113 |
| [wizard](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/wizard/SKILL.md) | Generate an interactive bash wizard that walks a human through steps only they can perform (provisioning, credentials/secrets, dashboards, one-off migrations/cutovers) | 4123 | 9877 | template.sh 8567; agents 96 |

## 3. Productivity — user-invoked (5)

| Skill | Purpose (provisional) | SKILL.md | Docs page | Companions |
|-------|----------------------|----------|-----------|------------|
| [grill-me](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/grill-me/SKILL.md) | Get relentlessly interviewed about a plan/design until every branch of the design tree is resolved (non-code uses) | 157 (pointer) | [grill-me.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/grill-me.md) 6489 | agents 137 |
| [handoff](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/handoff/SKILL.md) | Compact the current conversation into a handoff document so another agent can continue | 894 | [handoff.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/handoff.md) 8746 | agents 141 |
| [teach](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/teach/SKILL.md) | Teach the user a skill/concept over multiple sessions using the current directory as a stateful workspace | 9506 | [teach.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/teach.md) 13260 | GLOSSARY-FORMAT.md 2122; LEARNING-RECORD-FORMAT.md 2747; MISSION-FORMAT.md 1540; RESOURCES-FORMAT.md 1924; agents 139 |
| [to-questionnaire](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/to-questionnaire/SKILL.md) | Turn a decision you can't answer alone into a Markdown questionnaire for the one person who can, filled async or over a meeting | 2904 | [to-questionnaire.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/to-questionnaire.md) 7828 | agents 166 |
| [wait-what](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/wait-what/SKILL.md) | Fire when a message doesn't land: re-pitch it with the missing context in plain English, using the CONTEXT.md vocabulary | 394 (pointer) | [wait-what.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/wait-what.md) 3528 | agents 158 |

## 4. Productivity — model-invoked (2)

| Skill | Purpose (provisional) | SKILL.md | Docs page | Companions |
|-------|----------------------|----------|-----------|------------|
| [grilling](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/grilling/SKILL.md) | The reusable interview primitive behind `grill-me`, `grill-with-docs`, `triage`, `wayfinder`, `improve-codebase-architecture`: interview relentlessly until every branch resolves | 1987 | [grilling.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/grilling.md) 10413 | agents 113 |
| [writing-for-agents](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/writing-for-agents/SKILL.md) | Writing documents for agents: skills, AGENTS.md/CLAUDE.md, and any doc an agent reaches by a pointer | 10886 | [writing-for-agents.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/writing-for-agents.md) 7784 | SKILL-MECHANICS.md 2629; agents 102 |

## 5. Misc (4) — not promoted

| Skill | Purpose (provisional) | SKILL.md | Companions |
|-------|----------------------|----------|------------|
| [git-guardrails-claude-code](https://github.com/mattpocock/skills/blob/0ab1b63/skills/misc/git-guardrails-claude-code/SKILL.md) | Set up Claude Code hooks to block dangerous git commands (push, `reset --hard`, `clean`, …) before they execute | 2313 | scripts/block-dangerous-git.sh 507; agents 112 |
| [migrate-to-shoehorn](https://github.com/mattpocock/skills/blob/0ab1b63/skills/misc/migrate-to-shoehorn/SKILL.md) | Migrate test files from `as` type assertions to @total-typescript/shoehorn | 2795 | agents 110 |
| [scaffold-exercises](https://github.com/mattpocock/skills/blob/0ab1b63/skills/misc/scaffold-exercises/SKILL.md) | Create exercise directory structures with sections, problems, solutions, explainers | 3589 | agents 108 |
| [setup-pre-commit](https://github.com/mattpocock/skills/blob/0ab1b63/skills/misc/setup-pre-commit/SKILL.md) | Set up Husky pre-commit hooks with lint-staged, Prettier, type checking, tests | 2258 | agents 99 |

## 6. In-progress (6) — beta, excluded from plugin

| Skill | Purpose (provisional) | SKILL.md | Companions |
|-------|----------------------|----------|------------|
| [loop-me](https://github.com/mattpocock/skills/blob/0ab1b63/skills/in-progress/loop-me/SKILL.md) | Grill yourself into implementable workflow specs over multiple sessions using the current directory as a stateful workspace (user-invoked) | 2522 | agents 140 |
| [writing-beats](https://github.com/mattpocock/skills/blob/0ab1b63/skills/in-progress/writing-beats/SKILL.md) | Shape an article as a journey of beats, choose-your-own-adventure style | 4855 | agents 142 |
| [writing-fragments](https://github.com/mattpocock/skills/blob/0ab1b63/skills/in-progress/writing-fragments/SKILL.md) | Grilling session that mines you for heterogeneous writing fragments appended to one document | 3558 | agents 140 |
| [writing-shape](https://github.com/mattpocock/skills/blob/0ab1b63/skills/in-progress/writing-shape/SKILL.md) | Take a markdown file of raw material and shape it into an article paragraph by paragraph | 5922 | agents 144 |
| [claude-handoff](https://github.com/mattpocock/skills/blob/0ab1b63/skills/in-progress/claude-handoff/SKILL.md) | Hand the current conversation to a fresh background agent seeded with a handoff summary via `claude --bg` (user-invoked) | 1301 | agents 141 |
| [setup-ts-deep-modules](https://github.com/mattpocock/skills/blob/0ab1b63/skills/in-progress/setup-ts-deep-modules/SKILL.md) | Wire dependency-cruiser into a TypeScript repo so each package is a deep module (user-invoked) | 7546 | dependency-cruiser.config.cjs 3712; agents 149 |

## 7. Repo infra (not skills)

| Path | Purpose | Notes |
|------|---------|-------|
| `CLAUDE.md` (3703) | The repo's own agent instruction: bucket rules, promotion rules, docs-page duties, `ask-matt` router duty, `link-skills.sh`, no-em-dashes | `AGENTS.md` is a **symlink** to `CLAUDE.md` (mode 120000, size 9) |
| `CONTEXT.md` (1768) | Domain glossary for the repo itself: **Issue tracker**, **Issue**, **Decision ticket**, **Triage role** + flagged ambiguities | The shared-language discipline in action |
| `.agents/` | Repo-authoring rules + ADRs: `writing-docs.md` 12688 (docs-page template + rules), `invocation.md` 3848 (user vs model), `install-block.md` 2780, `adr/0001` 1154, `adr/0002` 5528 (Claude plugin decision) | `.agents/` = this repo's equivalent of `docs/SOPs/` |
| `.out-of-scope/` | Explicit non-goals: `mainstream-issue-trackers-only.md` 1573, `question-limits.md` 1259, `setup-skill-verify-mode.md` 1125 | Directly relevant to `triage`/`setup` assessment |
| `.claude-plugin/` | `plugin.json` 1636 + `marketplace.json` 605 — ships exactly the promoted set | Distribution mechanism |
| `.changeset/` | Changesets + CHANGELOG (44408) — versioned release discipline | Pending changesets at pin (e.g. `fix-yaml-frontmatter-colons`, `grilling-remove-em-dashes`) |
| `docs/engineering/` (18) + `docs/productivity/` (7) | Human-facing docs mirror of promoted skills; published `https://aihero.dev/skills-<name>` | Not a copy of SKILL.md; four-section frame per `writing-docs.md` |
| `scripts/` | `link-skills.sh` 1815 (symlink all skills into harness dirs), `list-skills.sh` 168, `sync-plugin-version.mjs` 1429 | vs cursorEscape `scripts/Sync-HostHarness.ps1` |
| `skills/*/README.md` | Bucket indexes (engineering 3840, productivity 1480, misc 684, in-progress 1676, deprecated 160) | Flat list for non-promoted buckets |
| `.github/workflows/release.yml` (780) | CI release | — |
| `LICENSE` (1068) | MIT | — |

## 8. Cross-references

- Full mapping to cursorEscape's tree, priority tiers, and infra learnings: [index-and-priorities.md](./index-and-priorities.md)
- Per-skill assessment spec: [assessment-spec.md](./assessment-spec.md)
- Where the audit runs next: [handoff roadmap](../../docs/roadmaps/mattpocock-skills-audit.md)