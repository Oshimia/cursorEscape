# wait-what

- **Skill + snapshot path:** Tier 3; `productivity/wait-what`; [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/wait-what/SKILL.md)
- **Verified purpose:** Re-pitches an explanation when the user did not understand it, adding missing context, Simplified Technical English, and project vocabulary. It is explicitly user-invoked via `disable-model-invocation: true`; see the [pinned docs page](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/wait-what.md) and [agent config](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/wait-what/agents/openai.yaml).
- **Core mechanism:** A tiny listener-state trigger rather than an output-style command: “The name is the mechanism.” It points to `CONTEXT.md` or `CONTEXT-MAP.md` when available.
- **What it does better:** The three-line contract avoids turning “be concise” into blunt truncation. Its docs define success as adding the missing premise, not merely deleting words.
- **What cursorEscape does better:** cursorEscape has explicit communication constraints and does not claim a ubiquitous-language file exists. Its pointer-first system can keep this as a small user-facing wrapper without ambient context.
- **Host dependency:** Portable interaction pattern, but invocation metadata and `CONTEXT.md` lookup are host/repository conventions.
- **Fit with cursorEscape philosophy:** host-agnostic 4/5; thin-harness 5/5; gate-able 2/5; isolated-reviewable 4/5.
- **Adaptation proposal:** **Adapt** as an explicit user-invoked communication skill. Preserve the tiny body; make context-file discovery follow local discovery rules and state what happens when no glossary exists. Do not make it model-invoked or require a new glossary.
- **Cost + risk:** Low cost; low behavioral risk; small risk of duplicated communication guidance or invented context-file conventions.
- **Verdict:** **Adapt**.
- **Proposed roadmap phase:** Add a thin user-invoked communication skill and companion pointer, touching `skills/` plus host advertisement overlays only; define fallback wording when no local glossary is present.
