> **Imported research** — Source: openBuggy `docs/featureArchitecture/competitive-landscape.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Competitive Landscape (openBuggy Design Context)

**Last updated:** 2026-08-04  
**Status:** Design/eval context only — metrics live in research docs

## Context

This page supports **design and eval choices** (what to copy, what to avoid) by summarizing where peers sit relative to openBuggy’s private workflow goal. It is not go-to-market positioning. For numbers and citations, follow the research links.

---

## Substance

| Peer | Typical strength | Gap vs openBuggy intent | Research |
|------|------------------|-------------------------|----------|
| Cursor Bugbot | High-precision bug findings; deep Cursor integration | Cursor plan/seat coupling; not BYOK-local for leavers | [Bugbot limits](../research/bugbot-product-and-api-limits.md), [benchmarks](../research/community-benchmarks-and-opinions.md) |
| CodeRabbit | Broad PR+CLI agent JSON; multi-SCM | Often minutes latency; seat/org product; broader/noisier personality | [Competitors](../research/competitor-product-notes.md), [Latency](../research/latency-and-api-gap.md) |
| Greptile | Codebase-context precision; CLI/MCP/loops | Hosted product; CLI ignores uncommitted (per docs) | [Competitors](../research/competitor-product-notes.md) |
| Sentry Seer | Production blast-radius focus | Different job; not a general local BYOK engine | [Benchmarks](../research/community-benchmarks-and-opinions.md) |
| Qodo / Graphite / Copilot | Enterprise or IDE-bundled review | Mixed depth; not the openBuggy design focus | [Competitors](../research/competitor-product-notes.md) |
| Autofix-style hybrid | Static+LLM precision floor | Still minutes-class agent tools; not the same packaging | [Competitors](../research/competitor-product-notes.md) |
| DIY prompt in coding agent | Fast; fully local control | No shared eval, schema, or multi-pass design | [Latency](../research/latency-and-api-gap.md) |

**openBuggy design focus:** engine-first CLI/MCP + BYOK + bug-first eval + uncommitted/branch scopes + structured findings for fix loops.

Community evidence that reviewers barely overlap (additive second bots) is documented in [community benchmarks](../research/community-benchmarks-and-opinions.md) — openBuggy should expect to coexist with a production-readiness reviewer and possibly a PR bot.

---

## Implications / open questions

1. Keep this page free of naked statistics; update research docs when numbers change, then re-check links here.
2. If a peer ships true BYOK sync-ish local bug review, revisit design focus in [design decisions](../review/design-decisions.md).
