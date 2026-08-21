# Tier 1 Finding: writing-for-agents

**Snapshot:** Productivity; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/writing-for-agents/SKILL.md)
- **Companion:** [SKILL-MECHANICS.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/writing-for-agents/SKILL-MECHANICS.md)
- **Docs:** [writing-for-agents.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/writing-for-agents.md)
- **Authoring rules:** [.agents/writing-docs.md](https://github.com/mattpocock/skills/blob/0ab1b63/.agents/writing-docs.md)

## Verified purpose

This is a reference for authoring agent-consumed documents, including skills, `AGENTS.md`/`CLAUDE.md`, specs, prompts, and pointer-reached docs. Its central discipline is to control context load and cognitive load through pointers, information hierarchy, completion criteria, leading words, and pruning. The catalog's purpose is accurate, but understated: it is a general document-authoring model, not merely a skill-writing guide.

## Core mechanism

Treat every document as ordered steps plus on-demand reference. Keep branch-common material in-file, disclose branch-specific material behind sharpened context pointers, and test each sentence for behavioral effect, duplication, sediment, sprawl, or no-op status. Skill-specific mechanics are deliberately disclosed to `SKILL-MECHANICS.md`, which covers user/model invocation and router behavior. `.agents/writing-docs.md` adds a four-section human-facing page frame, absolute-link rules, evidence-based questions, and explicit done checks.

## What it does better than the local equivalent

The local documentation architecture skill establishes a procedures-vs-design layout, but the upstream reference supplies a sharper cognitive model for deciding what belongs in the thin pointer versus the companion. It states, “The pointer's wording, not its target, decides when the agent reaches the material” and uses “completion criteria” to drive legwork ([SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/writing-for-agents/SKILL.md)). The `.agents/writing-docs.md` rules also distinguish human-facing orientation from the runbook and require observable “It's working if” criteria ([.agents/writing-docs.md](https://github.com/mattpocock/skills/blob/0ab1b63/.agents/writing-docs.md)). These are useful review lenses missing as explicit local authoring heuristics.

## What cursorEscape does better

cursorEscape already has a stronger source-of-truth and host split: thin root harnesses point into companion workflow docs, while overlays carry host behavior ([instruction-layering.md](../../../docs/featureArchitecture/instruction-layering.md), [skill-source-and-host-overlays.md](../../../docs/featureArchitecture/skill-source-and-host-overlays.md)). Its shared skill contract fields and dual-review verdict bars are explicit ([skills/_index.md](../../../skills/_index.md), [agents/_index.md](../../../agents/_index.md)). Upstream's invocation guidance is tied to its frontmatter and `agents/openai.yaml`; it does not model cursorEscape's overlay matrix or its clean-context review isolation.

## Host dependency

The writing principles are portable. `SKILL-MECHANICS.md` names frontmatter fields and `policy.allow_implicit_invocation`, and `.agents/writing-docs.md` assumes the upstream promoted-bucket/site publishing model. Those mechanics are host/repository-specific and must not be copied into root contracts.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 5 | Context hierarchy, pruning, and completion criteria apply to any agent reader. |
| Thin-harness | 5 | The pointer/disclosure model directly reinforces thin `SKILL.md` plus companion docs. |
| Gate-able | 4 | Done checks are strong, but prose quality still needs human/reviewer judgment. |
| Isolated-reviewable | 4 | It supports small, independently reviewable documents, though it does not define local dual-review orchestration. |

## Adaptation proposal

**Draft verdict: Adapt.** Extend the existing documentation-architecture procedure with a compact authoring rubric derived from context/cognitive load, information hierarchy, completion criteria, leading words, and no-op pruning. Add a local companion page for human-facing documentation only if the repository needs that artifact; do not import the upstream site template or `agents/openai.yaml` rules. Apply the rubric to root skill/agent contracts and workflow companions, and make review findings cite the affected pointer, branch, or completion criterion.

**Proposed roadmap phase:** Extend `skills/documentation-architecture/` and its companion workflow with the portable authoring rubric and local done checks; update its index references and add no host-specific frontmatter or publishing requirements.

## Cost + risk

Low-to-medium authoring cost and medium review burden because the rubric can create subjective “no-op” debates. The principal risk is duplicating the repository's existing documentation SOP or adding vocabulary without a single source of truth. Keep the upstream terms as assessment heuristics, not mandatory prose style, and retain local contract/index ownership.

## Verdict

**Adapt (draft; owner discussion required).** The portable authoring heuristics materially strengthen local skill writing, but upstream packaging and publishing rules do not belong here.
