# Documentation architecture (default for new docs)

**Skill:** [documentation-architecture](../skills/documentation-architecture/SKILL.md) (procedure entry point).

## When to use

- Bootstrapping docs in a greenfield or under-documented repo
- User asks to standardize or add a new documentation area
- Introducing a pattern that needs a durable how-to or design note

## When not to use

- Repo already has a coherent docs layout — **follow it**; do not invent parallel trees
- Trivial one-line comments or ephemeral chat notes

## Default bootstrap layout

Only when there is no conflicting convention, or the user asks to adopt this layout. Prefer an existing docs root (`docs/`, `documentation/`, etc.); else create `docs/`.

```text
docs/
  SOPs/
    _index.md          # procedures / how-tos
  featureArchitecture/
    _index.md          # design / why / behavior
  roadmaps/            # multi-phase handoffs (see roadmap skill)
```

| Kind | Lives in | Contains |
|------|----------|----------|
| Procedures | `SOPs/` | Repeatable how-tos, checklists, gates |
| Design | `featureArchitecture/` | Why it works, contracts, state flows |
| Roadmaps | `roadmaps/` | Multi-phase Agent context (repo docs) |

Keep indexes current in the **same changeset** as new docs. Multi-phase roadmaps: [roadmap](../skills/roadmap/SKILL.md) skill + [phased-multi-agent.md](phased-multi-agent.md). Escalated plans (in-plan Agent context): [plan-agent-context.md](plan-agent-context.md).

## Existing layouts

Discover via [discovery.md](discovery.md). Map “procedure” vs “design” onto whatever folders the repo already uses. Do not force `SOPs` / `featureArchitecture` names onto a repo that already chose differently.

## Same-changeset rule

When code introduces or changes a pattern:

1. Update or create the appropriate doc
2. Link from the relevant index
3. Do not ship undocumented architecture when the repo expects docs

## Agent-documentation rubric (writing for agents)

When authoring or revising any artifact an agent reads (skills, companions, agent contracts, SOPs, FA leaves), apply these heuristics. Adapted from the pinned mattpocock/skills writing-for-agents snapshot at commit 0ab1b63; upstream publishing, router, and model-metadata mechanics are intentionally omitted. Forward-looking guidance for new authoring; no retroactive sweep of existing docs.

- **Context load:** every document costs context each time it loads; write the thinnest artifact that lets the reader succeed. Example: a skill entry states its trigger and links one companion instead of embedding the procedure.
- **Pointer disclosure:** keep branch-common material in-file; put branch-specific material behind pointers whose wording says exactly who should follow them and when. The pointer's wording decides whether readers reach the material, not just its target. Example: prefer `Read only when the review loop cannot launch` over a bare link labeled `more`.
- **Information hierarchy:** order content by reading priority: what every reader needs first, branch-specific detail later.
- **Completion criteria:** tasks state observable done-conditions so readers stop when criteria are met instead of guessing. Example: `registered in both indexes with resolving links` beats `update indexes`.
- **Leading words:** front-load the operative term of each sentence and heading so scanners catch meaning on the first words.
- **No-op pruning:** strike sentences with no behavioral effect, duplication, or sediment; if deleting a sentence changes nothing, it was already gone.

These are authoring heuristics, not gates; reviewers may cite them, but nothing here blocks a change by itself.

## Related

- [discovery.md](discovery.md)
- [phased-multi-agent.md](phased-multi-agent.md)
- [plan-agent-context.md](plan-agent-context.md)
- [documentation-architecture](../skills/documentation-architecture/SKILL.md)
- [roadmap](../skills/roadmap/SKILL.md)
- [_index.md](_index.md)
