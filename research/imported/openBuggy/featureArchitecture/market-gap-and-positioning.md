> **Imported research** — Source: openBuggy `docs/featureArchitecture/market-gap-and-positioning.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Market Gap and Positioning

**Last updated:** 2026-08-04  
**Status:** Workflow motivation and design focus (no runtime yet)

**Not in scope:** Monetization, GTM, or a commercial SaaS offering. Stewardship: [design decisions](../review/design-decisions.md).

## Context

The owner relies on Cursor Bugbot inside iterative local review loops. Leaving Cursor (or losing Bugbot) means either paying into Cursor’s ecosystem, accepting a PR-centric commercial bot, or rebuilding the bug-finder leg. openBuggy is that third path for the owner — documented before any code is written. Observed local Agent Review behavior (what to replicate vs what remains Unknown) is archived under [cursor-bugbot-agent-review](./cursor-bugbot-agent-review/_index.md).

---

## Substance

### The workflow gap

Successful local loops look like:

```text
Implement → Fast CI → [production-readiness reviewer ∥ bug finder] → fix all → re-review → Full CI
```

Bugbot (and Cursor’s local `/review-bugbot` path) fill the **bug finder** slot with high-precision, low-frivolous findings. Commercial alternatives often optimize for **async PR comments**, team seats, and broad review surface area. CLI “agent modes” exist (CodeRabbit, Greptile), but latency is typically measured in **minutes**, and packaging is rarely true BYOK-local with a Bugbot-shaped contract.

### What is easy vs hard to replace

| Portable today | Hard without Cursor |
|----------------|---------------------|
| Dual-reviewer orchestration skills | Proprietary Bugbot model / PR multi-pass product (local Agent Review logs show a single tool loop — see [unknowns](./cursor-bugbot-agent-review/unknowns-and-non-replicables.md)) |
| Project rules (`BUGBOT.md` → `AGENTS.md`) — PR surface; local Agent Review rule file effect is Unknown in corpus | Learned rules from millions of PR resolutions |
| Fix-all completion bars | Patch-id sync with hosted PR Bugbot; Autofix cloud |

A custom agent + skill can recover much of the *process*. Matching Bugbot’s *signal* needs eval, retrieval, and multi-pass design — which is openBuggy’s proposed job. Use the Observed suite for envelope/output/personality requirements; do not assume proprietary weights are required.

### Design focus (one sentence)

**BYOK, local-first review engine that coding agents call for structured bug findings on a repo diff — before PR theater.**

Details of competitors’ surfaces: [competitor product notes](../research/competitor-product-notes.md). Billing/API limits of Bugbot: [bugbot product and API limits](../research/bugbot-product-and-api-limits.md). Latency reality: [latency and API gap](../research/latency-and-api-gap.md).

---

## Implications / open questions

1. Scope discipline: do not become “another PR summary bot.”
2. Primary user is the owner; design should optimize for dual review loops already in use.
3. Naming and license only matter if the project is published openly (see [design decisions](../review/design-decisions.md)).
