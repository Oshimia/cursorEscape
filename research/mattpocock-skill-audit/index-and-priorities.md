# Index and priorities: mattpocock/skills vs cursorEscape

**Snapshot pin:** `mattpocock/skills` at `0ab1b63` (2026-08-21). Mapping is against cursorEscape as of 2026-08-21. Statuses are **draft** — the deeper-model assessment ([assessment-spec.md](./assessment-spec.md)) refines them against actual skill content.

**Owner exclusions (2026-08-21):** solo dev — collaborative/team-workflow skills (GitHub/issue-tracker or working with another dev) are **not assessed**; non-coding skills are mostly not assessed, with **`teach`** as the owner-named exception. See [Excluded](#excluded-from-assessment-not-to-be-assessed).

**Adapt, don't copy (owner principle):** anything that comes out of this audit must be **adapted to cursorEscape's own workflows and conventions** — host-agnostic portable contracts, thin harness + companion procedure, overlay-only host specifics, dual-gate review, clean-context isolation — never pasted over verbatim from the source. See [assessment-spec.md](./assessment-spec.md) ground rules and the [handoff roadmap](../../docs/roadmaps/mattpocock-skills-audit.md).

## Status legend

| Status | Meaning |
|--------|---------|
| **Equivalent/Overlap** | Local has a directly comparable artifact |
| **Partial** | Local has something comparable, but different shape or mechanism |
| **Gap** | No meaningful local equivalent; candidate to assess for adoption |
| **Novel** | Genuinely new capability OR outside cursorEscape's loop/relevance |
| **Excluded** | Not to be assessed — owner opt-out (collaborative/team-workflow, or non-coding with no use) |

## Comparison index

| GitHub skill | Status | Local counterpart | Note |
|---|---|---|---|
| wizard | **Gap** | — | Interactive bash wizard for human-only steps; no local HITL-step skill. **Owner Tier 1.** |
| writing-for-agents | **Gap/Partial** | `skills/documentation-architecture`, `docs/SOPs/` | Deeper on agent-comprehension mechanics (pointer-reached docs, skill authoring); directly improves how cursorEscape authors its own skills. **Owner Tier 1.** |
| code-review | **Partial** | `skills/implementation-review` (dual gate: production_readiness × bug_reviewer) | Two-axis Standards vs Spec, parallel sub-agents, Fowler smell baseline vs local dual-gate. Strong comparison target. **Owner Tier 1.** |
| improve-codebase-architecture | **Gap** | — | Architecture survey + HTML report + grill; none local. **Owner Tier 1.** |
| codebase-design | **Gap** | `skills/documentation-architecture` (different purpose) | Deep-modules discipline (DEEPENING.md, DESIGN-IT-TWICE.md). **Owner Tier 1.** |
| domain-modeling | **Partial/Gap** | `review/design-decisions.md`, `docs/featureArchitecture/` | CONTEXT.md + ADR discipline loop; no active domain-modeling in local. **Owner Tier 1.** |
| grilling | **Gap** | `agents/plan_reviewer` | Reusable interview primitive (human-facing, pre-plan). plan_reviewer reviews drafted plans; grilling interviews the human first. |
| grill-with-docs / grill-me | **Gap** | `agents/plan_reviewer`, `skills/implementation-plan` | Pre-plan alignment + domain build vs post-draft adversarial review. |
| to-spec / to-tickets | **Excluded** | — | Collaborative issue-tracker family (GitHub/Linear). to-tickets also has a local-file mode if ever wanted; excluded now. |
| wayfinder | **Excluded** | — | Shared decision-ticket map on the issue tracker; collaborative. |
| implement | **Partial** | `agents/implementer`, `skills/implementation-review` | Drives `/tdd` at seams + `/code-review` closeout vs local dual-gate closeout. |
| research | **Partial** | `agents/repository_explorer`, `research/` | Background-agent cited-source research → md file vs bounded read-only exploration. |
| diagnosing-bugs | **Gap** | `agents/bug_reviewer` | Runtime diagnosis loop (feedback red → minimise → hypothesise) vs diff review. |
| tdd | **Gap** | `skills/implementation-review` (references tests, no discipline skill) | Red-green-refactor loop + mocking/tests companions. |
| handoff | **Partial** | `skills/composer` cap-exhausted handoff schema | Conversation compaction doc for another agent. |
| ask-matt | **Gap** | `skills/_index.md` (static index, no router) | Router over user-invoked skills. |
| triage | **Excluded** | — | Issue-tracker triage state machine; team workflow (labels, roles, needs-triage). |
| prototype | **Gap** | — | Throwaway HTML logic/UI prototypes. |
| resolving-merge-conflicts | **Gap** | — | Hunk-by-hunk intent-traced resolution (git management, not collaboration — assessed). |
| wait-what | **Gap** | — | Re-pitch a message with missing context using shared vocabulary. |
| teach | **Gap** | — | Multi-session teaching workspace. **Owner exception** — non-coding but potentially very useful; assessed (elevated to Tier 2). |
| to-questionnaire | **Excluded** | — | Async questionnaire to another human (collaborative). |
| git-guardrails-claude-code | **Novel** | `rules/` | Claude-Code-hook-specific; host-dependent, conflicts with host-agnostic overlay model. |
| setup-pre-commit | **Partial** | `rules/pre-commit-ci-gate.md` | Setup tooling (husky/lint-staged) vs always-on gate rule — different purpose. |
| setup-matt-pocock-skills | **Excluded** | — | Wires the issue tracker + triage labels + team setup (collaborative platform). |
| migrate-to-shoehorn / scaffold-exercises | **Novel** | — | TS tooling migration / exercise scaffolding; not relevant to cursorEscape. |
| claude-handoff | **Partial** | `skills/composer` handoff | `claude --bg` host-specific; concept overlaps local handoff discipline. |
| loop-me / setup-ts-deep-modules | **Novel** | — | In-progress; loop-me (multi-session workflow specs) worth a glance; setup-ts TS-specific. |
| writing-beats / writing-fragments / writing-shape | **Excluded** | — | Article-authoring; non-coding, no use for the owner. |

## Priority tiers

Tiering rationale: Tier 1 = owner-named interest areas + capabilities that change how cursorEscape authors its own skills. Tier 2 = skills overlapping the existing plan/review/implement loop (highest merge probability) + the owner's non-coding exception. Tier 3 = standalone or host-specific tools, assess if capacity allows.

### Tier 1 — assess first (owner interest + highest leverage)

1. `wizard` (Gap — novel capability)
2. `writing-for-agents` (+ `.agents/writing-docs.md`) (Gap/Partial — meta, improves local skill authoring)
3. `code-review` (Partial — direct comparison vs local dual-gate)
4. `improve-codebase-architecture` (Gap — architecture survey)
5. `codebase-design` (Gap — deep-modules discipline)
6. `domain-modeling` (+ CONTEXT.md/ADR discipline) (Partial/Gap — shared language)

### Tier 2 — core-loop adjacent / reusable primitives

7. `grilling` (reusable interview primitive)
8. `grill-with-docs` / `grill-me` (pre-plan alignment)
9. `implement` (vs implementer + implementation-review)
10. `research` (vs repository_explorer)
11. `diagnosing-bugs` (vs bug_reviewer)
12. `tdd` (test discipline)
13. `handoff` (vs composer handoff)
14. `ask-matt` (router)
15. `teach` (owner exception — non-coding, potentially very useful)

### Tier 3 — contextual / host-specific / low-leverage

16. `prototype`
17. `resolving-merge-conflicts`
18. `wait-what`
19. Misc set: `git-guardrails-claude-code`, `setup-pre-commit`, `migrate-to-shoehorn`, `scaffold-exercises`
20. In-progress set: `claude-handoff`, `loop-me`, `setup-ts-deep-modules`

### Excluded from assessment (not to be assessed)

- **Collaborative / GitHub-or-similar-platform (solo dev — no interest):** `setup-matt-pocock-skills`, `triage`, `to-spec`, `to-tickets`, `wayfinder`, `to-questionnaire`. Excluded for suggesting a team/shared workflow (issue tracker, triage labels, shared decision maps, or another human).
- **Non-coding, no use:** `writing-beats`, `writing-fragments`, `writing-shape`.
- **Exception (assess):** `teach` — owner explicitly wants it assessed despite being non-coding.

Git-management skills are **not** excluded (owner note): `git-guardrails-claude-code`, `setup-pre-commit`, `resolving-merge-conflicts`, `migrate-to-shoehorn` stay assessable.

### Cross-cutting infra (fixed block after Tier 1, before merge triage)

These are assessed **once**, not per-skill. They inform adaptation of anything in Tier 1–3.

| Infra area | What to compare | Local counterpart |
|------------|-----------------|-------------------|
| Skill authoring format | Frontmatter (name/description/disable-model-invocation) + thin SKILL.md pointer → docs/ deep page + `agents/openai.yaml` model assignment + companion FORMAT files | `skills/*/SKILL.md` thin-harness + `workflow/*.md` companion pattern |
| User vs model invocation | `disable-model-invocation` + `policy.allow_implicit_invocation` split; rich trigger phrasing for model-invoked | Local `disable-model-invocation: true` on some skills |
| CONTEXT.md / ADR discipline | Shared-language glossary + inline ADR updates to cut verbosity and naming drift | `review/design-decisions.md`, `docs/featureArchitecture/` |
| Human-facing docs pages | `writing-docs.md` four-section frame (What it does / When to reach / Common questions / It's working if / Where it fits) | No per-skill human-facing pages locally |
| ask-matt router | Router over user-invoked skills that must stay accurate on add/rename/remove | `skills/_index.md` (static) |
| Distribution | Plugin + changesets + CHANGELOG + `scripts/link-skills.sh` | `scripts/Sync-HostHarness.ps1` + overlays |
| House style | No-em-dashes prose rule | — |
| Out-of-scope discipline | `.out-of-scope/` explicit non-goal docs | — |

## Owner interest mapping

| Interest | Skills | Why |
|----------|--------|-----|
| **Wizard** | `wizard` | Interactive bash wizard for human-only steps; no local equivalent |
| **writing-for-agents** | `writing-for-agents`, `.agents/writing-docs.md`, `CLAUDE.md` | Directly improves how cursorEscape authors skills and agent contracts |
| **Review-based** | `code-review`, `ask-matt` | Two-axis review vs local dual-gate; skill router (triage excluded — collaborative) |
| **Architecture-shape** | `improve-codebase-architecture`, `codebase-design`, `domain-modeling` | Deepening, deep modules, shared language (to-spec/wayfinder excluded — tracker-based) |
| **Teaching** | `teach` | Owner exception — non-coding but potentially very useful (multi-session teaching) |

## Cross-references

- Full catalog with file sizes and URLs: [catalog.md](./catalog.md)
- Per-skill assessment spec: [assessment-spec.md](./assessment-spec.md)
- Where the audit runs next: [handoff roadmap](../../docs/roadmaps/mattpocock-skills-audit.md)