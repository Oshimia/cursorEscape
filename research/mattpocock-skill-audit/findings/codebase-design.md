# Tier 1 Finding: codebase-design

**Snapshot:** Engineering; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/codebase-design/SKILL.md)
- **Docs:** [codebase-design.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/codebase-design.md)
- **Companions:** [DEEPENING.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/codebase-design/DEEPENING.md), [DESIGN-IT-TWICE.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/codebase-design/DESIGN-IT-TWICE.md)

## Verified purpose

`codebase-design` is a shared vocabulary and principles reference for deep modules, small interfaces, clean seams, testability, leverage, and locality. It is explicitly a reference with no process or produced artifact. The catalog's description is accurate and omits the important warning that pointing an agent at the reference alone can cause it to invent a long process.

## Core mechanism

Define `module`, `interface`, `implementation`, `depth`, `seam`, `adapter`, `leverage`, and `locality`; apply the deletion test, treat the interface as the test surface, and require two adapters before treating a seam as real. The companion pages provide dependency categories for deepening and a parallel “design it twice” comparison of alternative interfaces.

## What it does better than the local equivalent

There is no direct local design-vocabulary contract. The source's scale-agnostic definition of interface includes invariants, ordering, errors, configuration, and performance, rather than only a type signature ([SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/codebase-design/SKILL.md)). The deletion test and “one adapter means a hypothetical seam; two adapters means a real one” are compact decision tools that can prevent speculative abstraction. The docs explicitly preserve the reference/process distinction and call out the missing TypeScript enforcement story ([codebase-design.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/codebase-design.md)).

## What cursorEscape does better

cursorEscape has stronger contract schemas, documentation indexes, plan/review gates, and host overlays. Its architecture vocabulary is intentionally repository-specific where needed, and its dual review process provides an actual stopping bar. Upstream's `DESIGN-IT-TWICE.md` assumes Claude's named Agent tool, so the companion pattern is less portable than the glossary.

## Host dependency

The glossary and principles are host-agnostic. The design-it-twice companion is partly Claude-tool-dependent; the reference also relies on the upstream skill-routing model. Neither should be copied as an executable local workflow.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 5 | Definitions and tests of interface shape do not require a harness. |
| Thin-harness | 5 | A compact pointer to a companion reference is the natural integration. |
| Gate-able | 4 | Deletion test, adapter count, and interface-test-surface checks are reviewable; design quality remains judgment. |
| Isolated-reviewable | 4 | Alternative designs can be isolated, but the named upstream tool requires adaptation. |

## Adaptation proposal

**Draft verdict: Adopt.** Rebuild the glossary and principles as a local portable companion, explicitly mapping “interface” and “seam” to cursorEscape's existing architecture vocabulary and banning only terms that conflict with local usage. Keep the reference non-driver: callers such as architecture survey or plan review must own process, checkpoints, and outputs. Translate design-it-twice to the local isolated-agent contract and make a host overlay only where parallel dispatch syntax differs.

**Proposed roadmap phase:** Add a portable `skills/codebase-design/` reference plus deepening/design-it-twice companion pages, update skill/workflow indexes, and add a local pointer from architecture/planning procedures; no automatic refactor behavior.

## Cost + risk

Medium authoring cost and low-to-medium review burden. The major risk is vocabulary collision with existing `boundary`, `interface`, or feature-architecture terms and accidental invocation as a driver. Reconcile terminology before authoring, keep one source of truth, and require caller skills to provide the process.

## Verdict

**Adopt (draft; owner discussion required).** The core is a portable reference gap with high leverage, provided the local contract preserves the non-driver boundary and adapts parallel design dispatch.
