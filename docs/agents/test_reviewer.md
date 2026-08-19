# test_reviewer

**Last updated:** 2026-08-17

## Context

**Target** role contract. Optional test-strategy / coverage reviewer. **Nice-to-have** — not part of the default dual gate. Does **not** replace [production_readiness_reviewer](./production_readiness_reviewer.md) blocking test/docs. When to make this mandatory remains **Unknown (U9)** — see [unresolved architectural questions](../../review/unresolved-architectural-questions.md).

---

## Substance

### Purpose

Advise on test strategy, coverage gaps, and regression risk for the phase changeset when explicitly invoked. Complements dual-gate review; does not gate dual APPROVED by default.

### When to invoke (Desired)

- User explicitly asks for a test-focused review
- Phase is explicitly test-heavy (new suites, flaky-test remediations, coverage gates)

Do not invent a third required parallel leg unless the user adds it for that phase. **U9** unsettled for mandatory policy.

### Inputs (Required when launched)

| Input | Description |
| ----- | ----------- |
| Repository path | Absolute workspace root |
| Task summary | Phase goal and test concerns |
| Changeset / diff scope | What changed |
| Applicable test docs | Existing test SOPs, coverage expectations if any |
| Note | Parent-verified Fast CI when dual gate also ran — do not re-run CI |

Follow [clean-context isolation](../featureArchitecture/clean-context-isolation.md): pack the invoke; no prior review transcripts.

### Outputs

| List | Meaning |
| ---- | ------- |
| Blocking | Test-strategy defects that would mislead the phase (advisory unless user elevates) |
| Non-blocking | Improvements and nits |
| Test gaps | Missing or weak coverage themes |

**Verdict:** Advisory findings. Parent does **not** require this leg for dual APPROVED unless the user explicitly adds test_reviewer to the loop for that phase. When elevated, parent may treat empty Blocking / Test gaps as clean for that extra leg only.

### Must not

- Replace production_readiness_reviewer’s blocking test/docs bar
- Join the default parallel dual gate without user/phase instruction
- Edit the workspace when launched as a read-only reviewer
- Re-run CI
- Require Cursor-specific subagent type IDs

### Model

**Desired:** Strong reasoning or test-aware model — config override ([agent roles](../featureArchitecture/agent-roles-and-model-assignment.md)).

---

## Implications / open questions

1. **U9:** Mandatory vs optional invoke policy unsettled.
2. Hosts may omit this role entirely; dual gate remains production_readiness ∥ bug_reviewer.

---

## Related

- [production_readiness_reviewer](./production_readiness_reviewer.md)
- [bug_reviewer](./bug_reviewer.md)
- [Agent roles and model assignment](../featureArchitecture/agent-roles-and-model-assignment.md)
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
- [Unresolved architectural questions](../../review/unresolved-architectural-questions.md) (U9)
