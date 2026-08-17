# Preliminary Backend Landscape

**Last updated:** 2026-08-17

## Context

**Target synthesis** of host/control-plane options for recreating the owner's agentic loop. First-attempt decision locked 2026-08 — see [host recreation](../analysis/host-recreation-2026-08.md) and [design decisions](../review/design-decisions.md). Metrics and vendor claims live in imported research; this page orients recreation and future spikes.

**Status:** **First attempt chosen** — OpenCode harness + T3 Code control plane. ClinePass **Desired** later as inference. Other rows remain research comparators.

---

## Substance

### First attempt (Target)

| Layer | Choice | Notes |
| ----- | ------ | ----- |
| **Harness** | **OpenCode** | Skills, named subagents, Task parallelism, `edit: deny` reviewers |
| **Control plane** | **T3 Code** ([t3.codes](https://t3.codes/), [pingdotgg/t3code](https://github.com/pingdotgg/t3code)) | Threads, worktrees, diffs, file preview — does **not** own skills/agents |
| **Provider** | BYOK; **ClinePass Desired** later | Not a week-one gate; U13 unproven |

Distinguish **T3 Code** (pingdotgg open-source control plane) from a from-scratch **custom stack** fallback (below).

### Candidates (research)

| Backend | Typical strength | Fit vs cursorEscape intent | Label |
| ------- | ---------------- | -------------------------- | ----- |
| **OpenCode** | Headless / multi-provider; markdown agents; Task tool | **First harness** | **Chosen (first attempt)** |
| **T3 Code** | GUI control plane over Claude/Codex/OpenCode/Cursor/Grok CLIs | Observability without full IDE | **Chosen (control plane)** |
| **Cline** | Mature IDE agent; MCP; ClinePass | Strong implementer; weak dual-gate subagents | Rejected for first attempt |
| **Kilo Code** | OpenCode fork + VS Code UI | Same engine family; separate `.kilo/` config | Rejected for first attempt (pick one harness) |
| **Copilot + BYOK bridge** | Model picker into Copilot Agent Mode | Not OpenCode Task semantics | Rejected for first attempt |
| **Aider** | Git-centric pair programming CLI | Fast implementer adjunct | **Nice-to-have** adjunct |
| **Custom stack (build)** | Full control | Highest build cost | **Unknown** fallback only |
| **Cursor (current)** | Best-in-class loop today | **Cursor-specific** reference; not runtime target | Observed only |

### Evaluation axes (R0 spike)

| Axis | Question |
| ---- | -------- |
| Role parallelism | Do two OpenCode Task reviewers run concurrently? |
| Diff scope | Branch vs uncommitted explicit in prompts? |
| Parent-owned Fast CI | Skill discipline honest (no claimed-only)? |
| Config | Role→model without forked prompts? |
| T3 observability | File/diff preview enough without VS Code? |
| ClinePass (later) | Wire into OpenCode without Cline-the-agent? |

### openBuggy alignment

openBuggy remains **research** (dual-gate evidence, BugBot FA). v0 **bug_reviewer** does **not** require openBuggy CLI/MCP ([design decisions](../review/design-decisions.md)). Optional later wire-up is Nice-to-have.

### Decision status

| Decision | Status |
| -------- | ------ |
| Primary harness | **OpenCode** (first attempt) |
| Control plane | **T3 Code** |
| Engine language (cursorEscape runtime) | **Unknown** — not required for recreation |
| ClinePass as default provider | **Desired** — unproven (U13) |
| openBuggy as bug transport | **Withdrawn for v0** (U8) |

---

## Sources

- [Host recreation study](../analysis/host-recreation-2026-08.md)
- [T3 Code](https://t3.codes/)
- [OpenCode Agents](https://opencode.ai/docs/agents/)
- [ClinePass](https://docs.cline.bot/getting-started/clinepass)
- [Imported openBuggy competitive landscape](./imported/openBuggy/featureArchitecture/competitive-landscape.md)
- [Imported competitor product notes](./imported/openBuggy/research/competitor-product-notes.md)
- [Backend and provider abstraction](../featureArchitecture/backend-and-provider-abstraction.md)

---

## Implications / open questions

1. R0 dogfood on T3+OpenCode before any cursorEscape engine ([implementation roadmap](../roadmaps/implementation-roadmap.md)).
2. Do not treat init-report Q6 “neither chosen” as current — superseded by this lock-in.

---

## Related

- [Unresolved architectural questions](../review/unresolved-architectural-questions.md)
- [Implementation roadmap](../roadmaps/implementation-roadmap.md)
- [Design decisions](../review/design-decisions.md)
