# Tier 1 Finding: domain-modeling

**Snapshot:** Engineering; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/domain-modeling/SKILL.md)
- **Docs:** [domain-modeling.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/domain-modeling.md)
- **Formats:** [CONTEXT-FORMAT.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/domain-modeling/CONTEXT-FORMAT.md), [ADR-FORMAT.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/domain-modeling/ADR-FORMAT.md)

## Verified purpose

`domain-modeling` is an active discipline for challenging ambiguous terms, stress-testing relationships with concrete scenarios, checking stated behavior against code, and recording resolved language inline in `CONTEXT.md`. It separately offers ADRs only when a decision is hard to reverse, surprising without context, and the result of a real trade-off. The catalog's description is accurate and the CONTEXT/ADR separation is central.

## Core mechanism

Use a glossary challenge and precise canonical terms, probe edge cases, cross-reference claims with code, update the glossary immediately, and offer a concise numbered ADR only when all three ADR tests pass. The companion formats require one- or two-sentence definitions, `_Avoid_` synonyms, domain-specific terms only, and short context/choice/reason paragraphs.

## What it does better than the local equivalent

The local tree has `review/design-decisions.md` and feature-architecture docs, but no active domain-modeling loop. Upstream sharply distinguishes “a glossary and nothing else” from a decision record and says to update `CONTEXT.md` “right there” when a term resolves ([SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/domain-modeling/SKILL.md)). Its three ADR tests are a useful anti-log and anti-diary filter, while `_Avoid_` synonyms and concrete scenario pressure make naming drift observable ([ADR-FORMAT.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/domain-modeling/ADR-FORMAT.md), [CONTEXT-FORMAT.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/domain-modeling/CONTEXT-FORMAT.md)).

## What cursorEscape does better

cursorEscape already has architecture documents, design-decision review material, and strict research/implementation freeze boundaries. It does not currently mandate a root `CONTEXT.md` or `docs/adr/`, which avoids imposing a new domain-doc tree during assessment. Its plan/review gates also ensure decisions enter a controlled phase rather than being silently treated as implementation authority.

## Host dependency

The modeling discipline is portable. Upstream assumes exact filenames, locations, numbering, and that all sibling skills read the same `CONTEXT.md`; those are repository conventions, not universal contracts. Its model-invoked routing can also cause accidental writes if adapted without an explicit write boundary.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 5 | Glossary, scenario, code cross-check, and ADR tests are host-independent. |
| Thin-harness | 4 | A portable reference/active procedure fits, but inline writes need explicit local policy. |
| Gate-able | 4 | Term definitions and three ADR tests are checkable; semantic correctness still needs owner review. |
| Isolated-reviewable | 3 | Read-only challenge is isolatable, but inline mutation of shared docs must be reviewed and owner-authorized. |

## Adaptation proposal

**Draft verdict: Adapt.** Do not import `CONTEXT.md`/`docs/adr/` by default. First define a local, optional domain-language procedure that can target existing `review/design-decisions.md` or a future owner-approved context document, preserving glossary-vs-decision separation, `_Avoid_` synonyms, scenario tests, code cross-checks, and the three ADR criteria. Require explicit owner confirmation before writing or creating domain artifacts, and route durable decisions through the existing plan/review process. If a local CONTEXT/ADR convention is later accepted, add a companion format rather than assuming upstream paths.

**Proposed roadmap phase:** Extend local documentation/decision-review guidance with an opt-in domain-modeling procedure and format mapping; touch `skills/`/`workflow/` only after owner-approved artifact locations, with no automatic root `CONTEXT.md` creation.

## Cost + risk

Medium authoring cost and medium review burden. Risks include introducing a parallel ADR tree, turning glossary entries into implementation specs, stale or agent-authored domain lore, and write side effects during unrelated reviews. The local artifact-location decision is the key prerequisite; until resolved, this should remain reference-plus-proposal.

## Verdict

**Adapt (draft; owner discussion required).** The discipline is useful, but artifact paths and mutation semantics must be negotiated against the existing local decision records before adoption.
