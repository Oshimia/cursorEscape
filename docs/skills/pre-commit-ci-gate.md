# pre-commit-ci-gate

**Last updated:** 2026-08-20

## Context

**Target** skill contract for the **on-demand** Full-before-commit policy. Not always-on. Live Cursor surface is a deferred rule (`alwaysApply: false`): [pre-commit-ci-gate.mdc](../overlays/cursor/rules/pre-commit-ci-gate.mdc). Deep CI mapping: [ci-ladder.md](../overlays/cursor/docs/workflow/ci-ladder.md). Closeout pairing with dual review: [implementation-review](./implementation-review.md).

---

## Substance

### When to use (Required when committing)

- Before any `git commit` (implementer or Composer phase commit)
- When Full ≠ `n/a` after dual APPROVED closeout
- On-demand load — **not** injected every turn ([instruction layering](../featureArchitecture/instruction-layering.md))

### Workflow steps

1. If the project has a local pre-commit CI rule (e.g. `.cursor/rules/pre-commit-ci-gate.mdc` or equivalent) → **follow that**; do not apply a second Full command set
2. Else map Fast / Full via [ci-ladder](../overlays/cursor/docs/workflow/ci-ladder.md) and project README/scripts
3. Before commit: **Full** must pass — or Full = `n/a` with **explicit user acknowledgment**
4. Never substitute Fast for Full when Full exists
5. If install/test fails due to locked `node_modules` / busy processes, ask the user to stop those processes and re-run Full

**Composer:** same Full (or `n/a` ack) before automatic local phase commits; never `git push` ([composer](./composer.md)).

### Outputs

- Full CI Observed (or documented `n/a` + user ack) before commit
- Clear owner when Composer conducts (Composer owns second Full / ack)

### Must not

- Always-inject this policy into every agent turn
- Invent hardcoded cross-repo npm / test suites
- Treat Fast CI as commit-grade when Full exists
- Pair Full CI with dual-gate reviewer launch ([clean-context isolation](../featureArchitecture/clean-context-isolation.md))

### Cursor-specific mapping

Overlay [pre-commit-ci-gate.mdc](../overlays/cursor/rules/pre-commit-ci-gate.mdc) with `alwaysApply: false` — on-demand rule, not a SKILL.md. Host adapters may use a skill, deferred rule, or explicit parent step; semantics stay Full-before-commit.

### Related roles

[implementer](../agents/implementer.md), [composer](./composer.md) (when conducting)

---

## Implications / open questions

1. Review-loop Fast CI and pre-commit Full CI are different tiers — see [intended-workflow](../featureArchitecture/intended-workflow.md).
2. Host wiring for deferred policy hooks can be validated per host; the Target contract is the semantics above.

---

## Related

- [implementation-review](./implementation-review.md)
- [composer](./composer.md)
- [ci-ladder (Observed)](../overlays/cursor/docs/workflow/ci-ladder.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md)
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
