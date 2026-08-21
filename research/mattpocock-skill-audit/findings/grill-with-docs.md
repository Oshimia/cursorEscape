# Tier 2 Finding: grill-with-docs

**Snapshot:** Engineering; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/grill-with-docs/SKILL.md)
- **Docs:** [grill-with-docs.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/grill-with-docs.md)

## Verified purpose

This is a user-invoked wrapper that delegates to `grilling` and `domain-modeling`, interviewing against a repository while updating glossary terms and qualifying ADRs. The catalog is accurate, but the 247-byte `SKILL.md` contains no safeguards beyond “Call the Skill tool twice,” so the deep docs carry the real behavior.

## Core mechanism

Run the frontier interview against the codebase; write each resolved term to `CONTEXT.md` immediately and write only decisions that pass three ADR conditions to `docs/adr/`. Keep ordinary conversation decisions in the thread. The workflow is explicitly stateful and intended to precede specification.

## What it does better than the local equivalent

cursorEscape has plan and architecture documents, but no active pre-plan workflow that updates shared vocabulary while interviewing. Upstream distinguishes glossary from decision record and says a term lands “the moment it resolves,” while ADRs require all three gates ([grill-with-docs.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/grill-with-docs.md)). That is sharper than allowing plan prose or design notes to become an unbounded glossary, and it links vocabulary clarification directly to the planning start.

## What cursorEscape does better

Local architecture makes write ownership, pointer-first layering, and isolated reviewer inputs explicit ([instruction-layering.md](../../../docs/featureArchitecture/instruction-layering.md), [skill-source-and-host-overlays.md](../../../docs/featureArchitecture/skill-source-and-host-overlays.md)). Upstream assumes root `CONTEXT.md` and `docs/adr/`, and its docs report silent file-writing failures when invoked inside orchestration. It also depends on the primitive loading correctly; the source wrapper does not itself guarantee that.

## Host dependency

The interview and artifacts are portable, but upstream paths and `Skill` tool calls are harness conventions. It assumes a repository is writable and has a chosen glossary/ADR layout; it does not fit cursorEscape's audit read-only phase or automatically justify writes.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 4 | Files and interview are portable; invocation is not. |
| Thin-harness | 4 | Thin wrapper is a good shape, but must point to local companions. |
| Gate-able | 4 | Term and ADR qualification can be explicit gates. |
| Isolated-reviewable | 3 | Human alignment is foreground; writes need owner authorization and review. |

## Adaptation proposal

**Draft verdict: Adapt.** Build on the adapted `grilling` primitive and local domain-modeling rules. Define the approved glossary and ADR homes before implementation, make writes owner-authorized, use pointer-first companion reads, and add a failure report when the interview runs but artifacts cannot be written. Do not copy the upstream root paths or delegate blindly to two skills.

**Proposed roadmap phase:** Extend `skills/implementation-plan` or add `skills/grill-with-docs/` plus a workflow companion for glossary/ADR alignment; touch local domain-document conventions and indexes only after owner acceptance and normal gates.

## Cost + risk

Medium-high authoring cost. Risks include unsolicited architecture writes, glossary/ADR duplication with existing `review/` and `docs/featureArchitecture/`, stale terms, and nested skill-loading failures. The artifact policy must be narrower than the upstream default.

## Verdict

**Adapt (draft; owner discussion required).** The stateful pre-plan alignment is valuable, but local artifact ownership and authorization are unresolved prerequisites.
