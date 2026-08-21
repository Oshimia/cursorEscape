# Tier 2 Finding: teach

**Snapshot:** Productivity; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/teach/SKILL.md)
- **Docs:** [teach.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/teach.md)
- **Companions:** [MISSION-FORMAT.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/teach/MISSION-FORMAT.md), [RESOURCES-FORMAT.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/teach/RESOURCES-FORMAT.md), [LEARNING-RECORD-FORMAT.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/teach/LEARNING-RECORD-FORMAT.md), [GLOSSARY-FORMAT.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/teach/GLOSSARY-FORMAT.md)

## Verified purpose

`teach` turns a directory into a stateful teaching workspace and produces short, cited HTML lessons across multiple sessions. The catalog is accurate, with the pinned source adding a full artifact model: mission, resources, lessons, reference documents, learning records, assets, and notes.

## Core mechanism

Ground instruction in high-trust resources and a user-confirmed mission; teach one small skill per lesson; use retrieval, spacing, interleaving, feedback, and a zone-of-proximal-development model; persist lessons and learning records so fresh sessions continue. Shared HTML assets and references make the workspace a course rather than disconnected answers.

## What it does better than the local equivalent

There is no local teaching workspace. Upstream explicitly treats model knowledge as untrusted, requires `RESOURCES.md` and citations, and uses learning records to choose the next lesson ([SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/teach/SKILL.md), [teach.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/teach.md)). The persistent mission/lesson/record loop is substantially better than one-off explanations for the owner's stated interest in assessing this skill.

## What cursorEscape does better

cursorEscape has disciplined portable contracts, pointer-first loading, and review isolation, while upstream `teach` is a large stateful content generator with no formal assessment gate and known path-resolution ambiguity between installed skill files and the current workspace ([skill-source-and-host-overlays.md](../../../docs/featureArchitecture/skill-source-and-host-overlays.md), [instruction-layering.md](../../../docs/featureArchitecture/instruction-layering.md)). It also does not schedule review or reliably know when to stop, and HTML authoring is not part of the local engineering loop.

## Host dependency

The workspace file formats are portable. HTML rendering, browser opening, asset paths, filesystem permissions, and external research are host-dependent. The skill is non-coding and should not be loaded into normal engineering flow by default.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 3 | Markdown/HTML workspace is portable; rendering and path semantics vary. |
| Thin-harness | 3 | The trigger can be thin, but the companion is necessarily substantial. |
| Gate-able | 3 | Mission, citations, lesson scope, and learning records are checkable; mastery is not. |
| Isolated-reviewable | 3 | Artifacts can be reviewed, but teaching is an interactive user process. |

## Adaptation proposal

**Owner direction: Adopt as a standalone workflow.** Build this as an explicitly opt-in dedicated learning workspace, not a root engineering skill or a normal coding-session extension. Preserve source grounding, mission/prior-knowledge assessment, lesson exit/review criteria, and isolated workspace boundaries. HTML rendering remains optional; begin with a narrow text/Markdown mode. Do not allow it to write in the active product repo by default.

**Proposed roadmap phase:** Add an isolated `skills/teach/` contract plus companion workspace formats and an OpenCode/Cursor-neutral host note; touch skill indexes only after owner acceptance and normal gates.

## Cost + risk

High authoring cost and medium content-safety risk. Risks include fabricated teaching, incorrect procedural examples, path confusion, workspace sprawl, accessibility/rendering burden, and scope drift into a second product. Start with a narrow text/Markdown lesson mode before HTML if adopted.

## Verdict

**Adopt (owner accepted; discussion amended).** The stateful, source-grounded learning loop is a genuine owner-named capability and should be treated as its own dedicated workflow, separate from normal coding sessions.
