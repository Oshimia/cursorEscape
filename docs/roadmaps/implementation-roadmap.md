# Implementation Roadmap

**Last updated:** 2026-08-17

## Context

**Future work** after initialization — distinct from the [cursorEscape initialization](./cursorEscape-initialization.md) conductor. This roadmap is **research-first**: prove repo discovery + thin backend adapter before a large runtime build. **No tasks here are authorized** until initialization Phase 5 closeout and explicit owner go-ahead.

**Status:** Planning document only — no runtime in this repository.

---

## Substance

### Principles (Required)

1. **Docs remain canonical** — runtime must not contradict [featureArchitecture](../featureArchitecture/_index.md) without updating Target docs.
2. **openBuggy stays external** for bug_reviewer until deliberately replaced.
3. **Adapter before engine** — spike Cline/OpenCode/other per [preliminary backend landscape](../research/preliminary-backend-landscape.md).
4. **BYOK** — no hosted inference requirement.

### Proposed phases (Unknown ordering — subject to spike)

| Phase | Goal | Entry gate | Out of scope |
| ----- | ---- | ---------- | ------------ |
| **R0 — Spike** | Role spawn + parallel review + diff scope on one dogfood repo | Init Phase 5 complete | Full IDE |
| **R1 — Discovery module** | Implement [repository discovery](../featureArchitecture/repository-discovery-and-context.md) minimum (hub walk, changed files, rules) | R0 adapter chosen | Embedding index |
| **R2 — Workflow runner** | Host-agnostic orchestration of plan → implement → dual review gates | R1 + skill contracts stable | Custom UI |
| **R3 — openBuggy wire-up** | bug_reviewer adapter production path | R2 loop honest on Fast/Full | Reimplement engine |
| **R4 — Eval hook** | Transcript capture + rubric scoring (external harness OK) | R3 | Full AITestSuite port |
| **R5 — Thin client** | Optional VS Code / web shell | R3 stable | General IDE |

### Research-first gates (Required before R2+)

- [ ] Resolve U2, U4 from [unresolved questions](../review/unresolved-architectural-questions.md) with evidence
- [ ] Document chosen adapter in [design decisions](../review/design-decisions.md)
- [x] Repo discovery approach written ([initialization report Q7](../review/initialization-report.md#q7--proposed-repository-discovery-and-context-acquisition))

### Explicit non-starters

| Item | Rationale |
| ---- | --------- |
| Cursor clone IDE | [design decisions](../review/design-decisions.md) non-goal |
| Inline Bugbot engine | Delegate to openBuggy |
| Skipping dual-gate | [intended workflow](../featureArchitecture/intended-workflow.md) |

---

## Implications / open questions

1. Phase ordering may change after R0 spike — update this file; do not fork a second roadmap tree.
2. **Unknown:** Calendar estimates — owner-driven, single maintainer.

---

## Related

- [Initialization roadmap](./cursorEscape-initialization.md)
- [Roadmap hub](../Roadmap.md)
- [Backend and provider abstraction](../featureArchitecture/backend-and-provider-abstraction.md)
