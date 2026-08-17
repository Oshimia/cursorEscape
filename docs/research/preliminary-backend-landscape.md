# Preliminary Backend Landscape

**Last updated:** 2026-08-17

## Context

**Research note — not a decision.** Surfaces that could host cursorEscape's agent abstraction and thin adapter layer. Metrics and vendor claims live in imported research; this page orients implementation planning only.

**Status:** Preliminary comparison for Phase 5 initialization report Q6 — **Unknown** which (if any) becomes primary.

---

## Substance

### Candidates

| Backend | Typical strength | Fit vs cursorEscape intent | Label |
| ------- | ---------------- | -------------------------- | ----- |
| **Cline** (VS Code extension) | Mature agent loop in IDE; MCP; BYOK patterns | Strong thin-client path; VS Code coupling | **Unknown** — research |
| **OpenCode** | Open agent CLI / multi-provider | Headless orchestration; less IDE lock-in | **Unknown** — research |
| **Aider** | Git-centric pair programming CLI | Fast for implementer leg; weak dual-gate story | **Nice-to-have** adjunct |
| **T3 / custom stack** | Full control | Highest build cost | **Unknown** fallback |
| **Cursor (current)** | Best-in-class loop today | **Cursor-specific** reference; not runtime target | Observed only |

### Evaluation axes (Desired for spike)

| Axis | Question |
| ---- | -------- |
| Role parallelism | Can two review legs run concurrently? |
| Diff scope | Branch vs uncommitted explicit? |
| MCP / CLI for openBuggy | Clean bug_reviewer integration? |
| Config | Role→model mapping without forked prompts? |
| Headless CI | Runnable outside IDE for closeout? |

### openBuggy alignment

openBuggy targets **CLI/MCP first** ([ide-and-agent-integration](./imported/openBuggy/featureArchitecture/ide-and-agent-integration.md)). Any primary backend must expose or wrap:

- `review --json` or MCP equivalent for **bug_reviewer**
- Parent-owned Fast/Full CI (not backend-owned review sequencing)

### Decision status

| Decision | Status |
| -------- | ------ |
| Primary adapter (Cline vs OpenCode vs other) | **Unknown** |
| Engine language | **Unknown** — see [design decisions](../review/design-decisions.md) |
| Whether Aider is implementer-only sidecar | **Unknown** |

---

## Sources

- [Imported openBuggy competitive landscape](./imported/openBuggy/featureArchitecture/competitive-landscape.md)
- [Imported competitor product notes](./imported/openBuggy/research/competitor-product-notes.md)
- [Backend and provider abstraction](../featureArchitecture/backend-and-provider-abstraction.md)

---

## Implications / open questions

1. Implementation roadmap mandates **adapter spike before large build** ([implementation roadmap](../roadmaps/implementation-roadmap.md)).
2. Do not record a winner here without eval evidence — Phase 5 report may summarize trade-offs only.

---

## Related

- [Unresolved architectural questions](../review/unresolved-architectural-questions.md)
- [Implementation roadmap](../roadmaps/implementation-roadmap.md)
