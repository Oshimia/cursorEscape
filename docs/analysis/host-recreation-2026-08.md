# Host recreation study (2026-08)

**Last updated:** 2026-08-17

## Context

Operator study of how to recreate the owner's Cursor plan → implement → dual-review loop **outside** Cursor, without building a cursorEscape runtime first. Informs Target lock-in in [design decisions](../review/design-decisions.md) and [implementation roadmap](../roadmaps/implementation-roadmap.md). Claim labels: **Target** decisions below; product capabilities cited as **Observed** from public docs.

---

## Substance

### What already has value

cursorEscape's durable artifact is the **portable workflow IP**: agent/skill contracts, dual-gate semantics, discovery, and claim taxonomy. Skills, rules, and custom agents are now common across hosts; the uncommon piece is Cursor-shaped **Task isolation + parent-owned Fast CI + parallel complementary reviewers**. Replicating that loop on an existing harness is the first recreation attempt — not a new agent platform in this repo.

### First attempt (Target)

| Layer | Choice | Role |
| ----- | ------ | ---- |
| **Control plane** | [T3 Code](https://t3.codes/) ([pingdotgg/t3code](https://github.com/pingdotgg/t3code)) | Threads, worktrees, diffs, file preview, PR helpers — observability without a full IDE |
| **Harness** | [OpenCode](https://opencode.ai/) | Skills, named subagents, Task tool, permissions (`edit: deny` on reviewers) |
| **Inference (Desired later)** | ClinePass (or other BYOK) | Cheap open-weight models for role routing; not a week-one blocker |
| **Contracts** | This repo + OpenCode agent/skill markdown | Source of truth stays in cursorEscape docs; host folders are adapters |

```text
cursorEscape docs (contracts)
        ↓
T3 Code (optional UI / control plane)
        ↓
OpenCode (orchestration + agents)
        ↓
Provider (BYOK; ClinePass Desired later)
```

**T3 is not an IDE replacement** and does not own skills/agents. Dual review must run as **one OpenCode session** with two Task launches — not two T3 worktrees (those are two checkouts).

### Non-chosen for first attempt

| Option | Why not first |
| ------ | ------------- |
| Native Cline | Strong implementer; subagents are research-oriented, weak dual-gate |
| Copilot Chat + Cline BYOK bridge | Model picker into Copilot; not Cline-the-agent; third-party glue |
| Kilo Code | OpenCode fork with VS Code UI; separate `.kilo/` config — pick one harness |
| OpenCode TUI alone | Correct harness; weak file tree / document display for this operator |
| cursorEscape custom runtime | Premature until R0 proves the loop on an existing host |

### openBuggy stance

openBuggy remains a valuable **characterization and research** sibling (imported under `docs/research/imported/openBuggy/`). For v0 recreation, the bug-finder leg is **not** required to use that engine. Recreate Bugbot-shaped utility with an OpenCode `bug_reviewer` subagent + skills/rules — the same pattern as `production_readiness_reviewer` / live reviewer-a. Optional openBuggy wire-up later is Nice-to-have, not Required.

### OpenCode parallel subagents vs the loop

**Observed (OpenCode docs):** Custom markdown subagents with per-role model and `permission.edit: deny`; parent invokes via Task / `@`; child sessions; parallel Task calls possible when the model emits multiple Tasks in one turn.

**Gap vs Cursor:** OpenCode expresses the dual-gate **shape** but does not enforce Observed Fast CI, split verdict bars, or mandatory re-launch of both legs. Loop discipline remains in parent skills (`implementation-review`), same as a well-behaved Cursor agent.

### Spike checks (R0 — not this docs change)

1. Two reviewer Tasks start concurrently (two child sessions alive).
2. Reviewers cannot edit; parent owns Fast CI then Full CI.
3. Diff scope (branch vs uncommitted) passed explicitly in Task prompts.
4. ClinePass (or chosen BYOK) wired into OpenCode when ready.

---

## Implications / open questions

1. Settle U2 (OpenCode + T3 control plane) and withdraw U8 (openBuggy as default transport) in [unresolved architectural questions](../review/unresolved-architectural-questions.md).
2. Keep U1 / U3–U7 / U9–U13 Unknown until spikes; U13 notes ClinePass as **Desired** when using OpenCode.
3. OpenCode adapter install paths and smoke checklist: [opencode-host-adapter SOP](../SOPs/opencode-host-adapter.md).
4. Do not authorize R1+ engine work in this repo until R0 dogfood proves the loop.

---

## Sources

- [T3 Code](https://t3.codes/) — control plane positioning
- [pingdotgg/t3code README](https://github.com/pingdotgg/t3code) — providers, BYO subscription, early-project caveats
- [OpenCode Agents](https://opencode.ai/docs/agents/) — primary/subagent modes, permissions, Task
- [ClinePass docs](https://docs.cline.bot/getting-started/clinepass) — subscription open-weight catalog
- Owner conversation 2026-08-17 — first-attempt lock-in; openBuggy over-engineering judgment

---

## Related

- [Design decisions](../review/design-decisions.md)
- [Preliminary backend landscape](../research/preliminary-backend-landscape.md)
- [Implementation roadmap](../roadmaps/implementation-roadmap.md)
- [Intended workflow](../featureArchitecture/intended-workflow.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md) — thin always-on vs on-demand skills/agents
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
