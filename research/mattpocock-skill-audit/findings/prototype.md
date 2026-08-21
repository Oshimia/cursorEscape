# prototype

- **Skill + snapshot path:** Tier 3; `engineering/prototype`; [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/prototype/SKILL.md)
- **Verified purpose:** Builds throwaway artifacts to answer one unresolved logic or UI question. The logic branch is a self-contained HTML demo; the UI branch is several switchable variants on one route.
- **Core mechanism:** Question-first branching, visible state after every action, radically different UI variants, and separate capture of the answer and prototype evidence. Companions: [LOGIC.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/prototype/LOGIC.md) and [UI.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/prototype/UI.md).
- **What it does better:** It makes the learning question explicit: “A prototype is throwaway code that answers a question.” LOGIC requires a pure, liftable module and non-developer-readable state; UI requires structurally different variants and a shareable `?variant=` URL.
- **What cursorEscape does better:** cursorEscape has explicit plan/review gates, clean child isolation, and roadmap handoffs. The source’s branch capture and “no tests” posture must not become a production shortcut.
- **Host dependency:** Mostly portable HTML and workflow guidance; UI examples assume a framework router and environment variable, but no named host is required.
- **Fit with cursorEscape philosophy:** host-agnostic 4/5; thin-harness 4/5; gate-able 3/5; isolated-reviewable 3/5.
- **Adaptation proposal:** **Adapt** as an optional portable prototype contract or workflow page. Keep question-first and pure-module rules; replace branch/issue capture with an owner-approved disposable artifact path and route promoted decisions through the existing plan/review loop. Candidate integration: `skills/prototype/SKILL.md`, a `workflow/` page, and host-specific preview wiring only in overlays.
- **Cost + risk:** Medium authoring cost; low runtime risk; moderate risk that throwaway UI code leaks into production or duplicates preview conventions.
- **Verdict:** **Adapt**.
- **Proposed roadmap phase:** Build an optional prototype contract and companion guidance, touching `skills/`, `workflow/`, and only required host overlay pointers; define cleanup and decision-capture boundaries.
