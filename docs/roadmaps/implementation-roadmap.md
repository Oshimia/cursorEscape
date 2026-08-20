# Implementation Roadmap

**Last updated:** 2026-08-20

## Context

**Future work** after initialization — distinct from the [cursorEscape initialization](./cursorEscape-initialization.md) conductor. First recreation is **external**: try **T3 Code + OpenCode** hands-on using contracts in this repo — **not** building a cursorEscape engine yet. See [host recreation](../../analysis/host-recreation-2026-08.md) and [design decisions](../../review/design-decisions.md).

**Status:** Planning document — R0 authorized as owner live trial outside this repo; R1+ engine work **not** authorized until R0 proves the loop.

---

## Substance

### Principles (Required)

1. **Docs remain canonical** — recreation must not contradict [featureArchitecture](../featureArchitecture/_index.md) without updating Target docs.
2. **openBuggy is not the v0 bug_reviewer** — OpenCode subagent + skills; openBuggy stays research / optional later.
3. **Harness before engine** — prove OpenCode (+ T3) before any cursorEscape runtime package.
4. **BYOK** — no hosted inference requirement; **ClinePass Desired** later.

### Proposed phases

| Phase | Goal | Entry gate | Out of scope |
| ----- | ---- | ---------- | ------------ |
| **R0 — Live trial** | Encode roles as OpenCode agents; dual Task review; parent Fast CI skill; T3 for file/diff observability on one trial target repo | Init complete + this lock-in | cursorEscape packages; openBuggy-required path |
| **Copy-out overlays** | OpenCode overlay in git + live sync applied ([overlays/opencode](../../overlays/opencode/_index.md) Phase 3 2026-08-20); Cursor copy-out manual | opencode-overlays-sot Phases 2–3 | Committing `~/.config/opencode` |
| **R1 — Discovery hygiene** | Confirm hub-walk / discovery skill works on OpenCode against target repos | R0 loop usable | Embedding index; in-repo discovery module |
| **R2 — Workflow runner (optional)** | Only if OpenCode cannot hold the loop — thin host-agnostic orchestration | R0 failed on capability | Custom IDE |
| **R3 — openBuggy (optional)** | Wire openBuggy if skill-based bug_reviewer proves insufficient | Explicit owner decision | Default path |
| **R4 — Eval hook** | Transcript capture + rubric scoring (external harness OK) | Stable dual gate | Full AITestSuite port |
| **R5 — Thin client** | **N/A for first attempt** — T3 already supplies control plane; revisit only if T3 abandoned | — | General IDE |

### Research-first gates

- [x] Resolve U2 (OpenCode + T3) — [unresolved questions](../../review/unresolved-architectural-questions.md)
- [x] Withdraw U8 (openBuggy default) — same
- [ ] R0 evidence: parallel Tasks, deny-edit reviewers, Fast CI honesty
- [ ] Document ClinePass (or chosen) provider wiring when ready (U13)
- [x] Repo discovery approach written ([initialization report Q7](../../review/initialization-report.md#q7--proposed-repository-discovery-and-context-acquisition))
- [x] OpenCode overlay in git + copy-out authorized and applied — [overlays/opencode](../../overlays/opencode/_index.md) (Phase 3 live sync 2026-08-20; smoke rows **1–4**, **9–10**, **13** pass; load path superseded by [pointer-first](../roadmaps/pointer-first.md))

### Explicit non-starters

| Item | Rationale |
| ---- | --------- |
| Cursor clone IDE | [design decisions](../../review/design-decisions.md) non-goal |
| Inline Bugbot engine / require openBuggy for v0 | Skill-based bug_reviewer |
| Skipping dual-gate | [intended workflow](../featureArchitecture/intended-workflow.md) |
| Building R1+ engine before R0 live trial | Premature |

---

## Implications / open questions

1. Phase ordering may change after R0 — update this file; do not fork a second roadmap tree.
2. **Unknown:** Calendar estimates — owner-driven, single maintainer.
3. Dual review must use **one OpenCode session** (two Tasks), not two T3 worktrees.

---

## Related

- [Initialization roadmap](./cursorEscape-initialization.md)
- [Host recreation study](../../analysis/host-recreation-2026-08.md)
- [Roadmap hub](../Roadmap.md)
- [Backend and provider abstraction](../featureArchitecture/backend-and-provider-abstraction.md)
- [Skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)
