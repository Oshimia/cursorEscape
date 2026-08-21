# Findings Index

**Snapshot:** `mattpocock/skills` commit `0ab1b63a410a03d3627979a109c8695de27af954` (short form `0ab1b63`).

These findings are the completed Phase 1 assessment. Verdicts were amended and accepted during the dedicated owner discussion recorded in [discussion-record.md](discussion-record.md). No adaptation is implemented here; ranking and phase selection belong to Phase 2.

| Skill | Draft verdict | Summary |
|---|---|---|
| [wizard](wizard.md) | Adapt | Human-only procedures and static safety checks fill a gap, but the Bash/GitHub template must become a portable contract with overlays. |
| [writing-for-agents](writing-for-agents.md) | Adapt | Context-load, disclosure, completion, and pruning heuristics strengthen local authoring, but upstream publishing/invocation mechanics do not transfer. |
| [code-review](code-review.md) | Adapt | Standards-vs-Spec evidence is valuable, but must remain optional inside the existing dual gate with recursion protection. |
| [improve-codebase-architecture](improve-codebase-architecture.md) | Adapt | Read-only deletion-test survey fills a gap; use Markdown-first local exploration rather than Claude-tool/CDN HTML assumptions. |
| [codebase-design](codebase-design.md) | Adopt | Portable deep-module vocabulary and deletion/seam tests are a high-leverage reference gap; preserve its non-driver boundary. |
| [domain-modeling](domain-modeling.md) | Adapt | Active glossary/ADR discipline is useful, but local artifact locations and write authorization must be settled first. |

## Tier 2

| Skill | Draft verdict | Summary |
|---|---|---|
| [grilling](grilling.md) | Adapt | Frontier-based human alignment fills a pre-plan gap, but must remain optional and subordinate to the existing plan gate. |
| [grill-with-docs](grill-with-docs.md) | Adapt | Stateful glossary/ADR alignment is useful, but local artifact ownership and write authorization are unresolved. |
| [grill-me](grill-me.md) | Reference-only | Preserve the stateless interview distinction as a pattern; a second wrapper would duplicate the shared grilling primitive. |
| [implement](implement.md) | Adapt | Reuse one-ticket vertical-slice discipline, not the upstream self-review ordering or mandatory commit behavior. |
| [research](research.md) | Adapt | Cited primary-source artifacts fill a gap, provided delegation is bounded and cannot recursively spawn research. |
| [diagnosing-bugs](diagnosing-bugs.md) | Adopt | User-invoked diagnosis of already accepted or shipped-code bugs is distinct from the mandatory change-review bug leg; selected evidence-first techniques may inform that leg separately. |
| [tdd](tdd.md) | Adopt | Public-seam, red-green, vertical-slice, and test-quality guidance fills the local TDD reference gap. |
| [handoff](handoff.md) | Adapt | Add portable user handoffs alongside, not instead of, Composer's phase-specific cap handoff. |
| [ask-matt](ask-matt.md) | Reference-only | The routing model is useful, but a hand-maintained second local map would violate single-SoT discipline. |
| [teach](teach.md) | Adopt | Dedicated source-grounded learning sessions are valuable, but must remain a separate isolated workflow rather than part of normal coding. |

## Excluded in this block

The owner-excluded skills remain intentionally unassessed: `setup-matt-pocock-skills`, `triage`, `to-spec`, `to-tickets`, `wayfinder`, `to-questionnaire`, `writing-beats`, `writing-fragments`, and `writing-shape`. No findings were created for them.

## Tier 3 and infrastructure

| Skill | Draft verdict | Summary |
|---|---|---|
| [prototype](prototype.md) | Adapt | Question-first, visible-state prototyping is useful, but branch capture and preview mechanics need local ownership boundaries. |
| [resolving-merge-conflicts](resolving-merge-conflicts.md) | Adapt | Intent-traced hunk resolution fills a small Git workflow gap; integrate with local CI and commit authority. |
| [wait-what](wait-what.md) | Adapt | A tiny user-invoked re-pitch trigger is valuable, but local context discovery must not assume an absent glossary. |
| [git-guardrails-claude-code](git-guardrails-claude-code.md) | Reject | Claude Code hook mechanics conflict with the portable contract and overlay-only host model. |
| [setup-pre-commit](setup-pre-commit.md) | Reject | Husky and Node setup is product-specific and does not match this repo’s purpose. |
| [migrate-to-shoehorn](migrate-to-shoehorn.md) | Reject | TypeScript test migration has no meaningful cursorEscape application. |
| [scaffold-exercises](scaffold-exercises.md) | Reject | Upstream course layout and CLI are unrelated to this repository. |
| [claude-handoff](claude-handoff.md) | Reference-only | Useful handoff ideas overlap Composer, while `claude --bg` is host-specific. |
| [loop-me](loop-me.md) | Reference-only | Workflow-spec discipline is interesting, but a second `workflows/` planning system would create ownership drift. |
| [setup-ts-deep-modules](setup-ts-deep-modules.md) | Reject | Dependency-cruiser setup is a TypeScript product concern, not a companion capability. |
| [infra](infra.md) | See sections | Adopt thin authoring, invocation, docs, style, and non-goal patterns; reject duplicate router and distribution systems. |

## Review and provenance

Each finding links the pinned upstream `SKILL.md`, docs, and listed companion pages where relevant. Local comparisons use the repository indexes and architecture/workflow contracts; no cursorEscape contract files were modified.

The owner explicitly waived the implementation review loop for this documentation-only audit. No adaptation is authorized until Phase 2 merge triage and owner acceptance.
