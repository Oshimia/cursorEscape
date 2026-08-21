# loop-me

- **Skill + snapshot path:** In-progress; `in-progress/loop-me`; [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/in-progress/loop-me/SKILL.md) and [agent config](https://github.com/mattpocock/skills/blob/0ab1b63/skills/in-progress/loop-me/agents/openai.yaml).
- **Verified purpose:** Runs a stateful grilling session that produces workflow specifications in `workflows/*.md`, using loop/trigger/checkpoint/brief vocabulary and `NOTES.md` as workspace context.
- **Core mechanism:** Repeated questioning over a stateful workspace until an implementer can build the workflow without questions; only workflow specs are outputs.
- **What it does better:** It sharply distinguishes a recurring loop from a workflow and makes “done” depend on unresolved questions reaching zero. It also pushes checkpoints right and requires decision-ready briefs.
- **What cursorEscape does better:** cursorEscape has a roadmap and plan-review system for implementation work, plus explicit clean-context and artifact ownership rules. The source assumes a new `workflows/` tree and does not connect to those gates.
- **Host dependency:** Procedure is broadly portable, but `workflows/`, `NOTES.md`, `/grilling`, and skill-tool naming are repository/host conventions.
- **Fit with cursorEscape philosophy:** host-agnostic 3/5; thin-harness 3/5; gate-able 3/5; isolated-reviewable 3/5.
- **Adaptation proposal:** **Reference-only**. Reconsider if the owner wants workflow-spec authoring as a distinct capability; map its vocabulary to existing docs/roadmap ownership rather than creating an ungoverned parallel tree.
- **Cost + risk:** Medium authoring cost; high risk of a second planning/specification system and unclear ownership of generated workflow files.
- **Verdict:** **Reference-only**.
