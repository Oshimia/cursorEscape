# Teach procedure

**Last updated:** 2026-08-22

Deep companion for the [teach skill](../skills/teach/SKILL.md): a dedicated opt-in Markdown learning workspace where the owner learns a named topic from cited resources through small lessons and spaced retrieval. User-invoked only.

## Workspace boundary

The owner selects a dedicated directory at invocation; that directory becomes the workspace root for the whole session. All writes resolve under this root: MISSION.md, RESOURCES.md, lessons/, and LEARNING-RECORD.md live there and nowhere else. Skill and companion files are read-only reference and are never written into the workspace. Path-resolution rule: any path not inside the workspace root is out of scope for writes. The active product repo is never the workspace; a teaching session never shares its root with an engineering tree.

## Non-coding invocation

This is a user-invoked learning workflow, neutral across hosts. It is never ambient-loaded into coding sessions; hosts advertise it as caller-loaded only (`disable-model-invocation: true`). Entering a coding task ends the teaching session until re-invoked: the workspace persists on disk, but no lesson work happens inside an engineering context.

## MISSION.md format

Written first, confirmed by the owner before any resource or lesson work:

```markdown
# Mission: <topic>

| Field | Value |
| ----- | ----- |
| Topic | <owner-named topic> |
| Learner goal | <owner words, verbatim> |
| Prior-knowledge assessment | <confirmed by owner, never assumed> |
| Success signal | <observable condition that ends the mission> |
| Scope boundaries | <what the mission excludes> |
```

The prior-knowledge assessment is confirmed by the owner explicitly; the agent never infers it.

## RESOURCES.md format

A numbered list of high-trust sources; each entry states title, locator/link, why trusted, and what it covers:

```markdown
# Resources

1. **<title>** - <locator or link>
   - Why trusted: <provenance or reputation reason>
   - Covers: <scope relevant to the mission>
```

Trust rules:

- Model knowledge is untrusted until verified against a listed source.
- Every lesson claim carries a source reference into RESOURCES.md.
- Sources are added or pruned only with the owner's visibility.

## Lesson format

One file per lesson under `lessons/`, named `<number>-<slug>.md`. One small skill per lesson: a short explanation with per-claim citations, then 2-4 exercises. Keep lessons short enough to finish in one sitting; if a topic needs more, split it across lessons rather than growing one file.

## LEARNING-RECORD format

Append-style log, one entry per study interaction:

```markdown
## <YYYY-MM-DD> - <lesson id>

- Retrieval results: <what recall showed>
- Gaps noticed: <misremembered or missing pieces>
- Next review: <date, spacing-aware>
- Next lesson selection: <rationale, interleaving where useful>
```

Spacing widens next-review dates as retrieval succeeds; interleaving mixes related topics where useful instead of drilling one topic to exhaustion.

## Exit and review criteria

Exit when the learner goal is met (the mission success signal holds) or the owner stops the session. On exit, the record states a final review date. Resuming creates a fresh session that reads MISSION.md and LEARNING-RECORD.md first, then confirms continuation with the owner before any new lesson work.

## Deferred

HTML rendering, browser-based presentation, and asset pipelines are explicitly deferred as future options; this phase is text/Markdown-first. There is no glossary file: shared-language discipline lives in [domain-modeling](domain-modeling.md), not here.

## Related

- [Teach skill](../skills/teach/SKILL.md)
- [Workflow docs index](_index.md)
- [Research procedure](research.md) (source-grounding kinship)
- [Domain-modeling procedure](domain-modeling.md) (terminology boundary)
