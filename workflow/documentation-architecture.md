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

## Related

- [discovery.md](discovery.md)
- [phased-multi-agent.md](phased-multi-agent.md)
- [plan-agent-context.md](plan-agent-context.md)
- [documentation-architecture](../skills/documentation-architecture/SKILL.md)
- [roadmap](../skills/roadmap/SKILL.md)
- [_index.md](_index.md)
