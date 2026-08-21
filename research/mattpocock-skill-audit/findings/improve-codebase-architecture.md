# Tier 1 Finding: improve-codebase-architecture

**Snapshot:** Engineering; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/improve-codebase-architecture/SKILL.md)
- **Docs:** [improve-codebase-architecture.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/improve-codebase-architecture.md)

## Verified purpose

This is a non-mutating architecture survey: it prioritizes recently changed areas, finds shallow modules that may be deepened, presents visual HTML candidates, then grills the user on one selected candidate. It does not implement the refactor. The catalog's description is accurate, with the important addition that the report is temp-only and the decision later returns to a build/spec flow.

## Core mechanism

Read domain context/ADRs, choose scope using recent history or the user's direction, explore for shallow interfaces, apply the deletion test, and produce a self-contained candidate card with files, problem, solution, locality/leverage benefits, before/after diagram, and strength. Stop for user selection; only then run a grilling loop and update domain records as decisions crystallize.

## What it does better than the local equivalent

There is no direct local architecture-survey skill. The source supplies a useful YAGNI filter, explicit deletion test, recent-hotspot bias, and a structured visual report ([SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/improve-codebase-architecture/SKILL.md)). Its docs are unusually honest about stopping before code changes and about visual/CDN and harness limitations ([improve-codebase-architecture.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/improve-codebase-architecture.md)).

## What cursorEscape does better

cursorEscape has an explicit plan gate, owner-controlled roadmap phases, isolated reviewers, and a no-contract-change freeze during research. The upstream skill's HTML uses Tailwind and Mermaid CDNs and names Claude's `Agent`/Explore tool directly; the docs acknowledge degraded portability and offline rendering failures ([improve-codebase-architecture.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/improve-codebase-architecture.md)). Local architecture docs also distinguish intended workflow and host-specific behavior rather than relying on an external report viewer.

## Host dependency

The survey idea is portable. The upstream implementation is partly Claude-tool-dependent and its report is network-dependent because of CDN assets; it also writes domain files during grilling. The HTML artifact and browser opening need host overlays or a simpler Markdown-first fallback.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 2 | Core survey is portable, but exploration and CDN/browser report paths are host/network coupled. |
| Thin-harness | 3 | A survey pointer is plausible, but the report scaffold and grilling procedure are substantial companions. |
| Gate-able | 3 | Deletion-test and candidate-card bars are useful; visual quality is difficult to gate automatically. |
| Isolated-reviewable | 4 | Read-only exploration and a user decision checkpoint fit isolation; domain writes need review. |

## Adaptation proposal

**Draft verdict: Adapt.** Build only a local, read-only architecture survey procedure around recent-history scope, deletion test, deep-module vocabulary, and candidate cards. Make Markdown the portable canonical report; an optional HTML rendering belongs in an overlay and must work without CDN assets. Use `repository_explorer` or a local architecture-review role instead of assuming Claude's `Agent` tool. Stop at candidate selection, then hand the accepted decision to `implementation-plan`; do not let this procedure mutate local contracts or ADRs automatically.

**Proposed roadmap phase:** Add a standalone architecture-survey skill/workflow and optional host renderer, integrating `repository_explorer`, `codebase-design` vocabulary, and plan-review entry; touch only those new/extended research-to-plan contracts after approval.

## Cost + risk

High authoring cost and medium review burden. It risks becoming a generic refactoring recommender, duplicating planning, or generating visual polish without actionable decisions. Automatic CONTEXT/ADR mutation and CDN rendering are the highest portability and trust risks; keep the first phase read-only and Markdown-first.

## Verdict

**Adapt (draft; owner discussion required).** The survey/deletion-test capability fills a gap, but only a read-only, portable subset fits the local loop.
