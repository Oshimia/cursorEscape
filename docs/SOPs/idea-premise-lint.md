# Tooling idea: reviewee premise lint (post-hoc hallucination detector)

**Created:** 2026-08-26 · **Status:** Idea — not implemented · **Owner scope:** personal worktree tooling only. Deliberately NOT part of the portable bug-review-sweep protocol or the openBuggy eval harness contract (harness-independence principle: the skill must work in anyone's tree with bare permissions; adjudication aids must not become a dependency).

## The observation it came from

Band-8 (openBuggy, bb-89): the reviewer reported "JSON tag `support_key` never matches the REST API's camelCase key." The workspace is a single Go file containing no REST surface and no camelCase anywhere. The model substituted a plausible prior (Go + REST → casing mismatch) for workspace evidence, asserted an external fact, and paid −1. Instruction is unlikely to fix this class: confidently-hallucinated premises are not a compliance failure.

## The idea

A mechanical, post-hoc lint over any `reviewee.xml`-style finding set:

1. Extract every file path, symbol, identifier, endpoint, and config key each finding's description/rationale references.
2. Diff against the reviewed workspace inventory (files + grep-extractable identifiers).
3. Flag findings whose causal chain contains references that resolve NOWHERE in the workspace AND are not explicitly marked as assumptions.

Flagged ≠ wrong — legitimate findings may cite genuinely-absent externals — but flagged = heightened adjudication scrutiny. In band-8 this lint would have caught exactly the one rejected claim at zero cost.

## Where it would live

An offline adjudication aid in this repo (e.g. `scripts/lint_reviewee_premises.py`), run by the operator between reviewee output and scoring/promotion decisions. It never gates the reviewer itself, so portability of the skill is unaffected.

## Related

- openBuggy campaign ledger: `skills/bug-review-sweep/VERSIONS.md`, REV rows 37–40
- Governing principle discussion: harness-independent skill vs eval scaffolding vs personal tooling (2026-08-26 session)
