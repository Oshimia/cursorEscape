# Bounded research (advisory)

Procedure for one bounded, externally sourced, fully cited research artifact. Companion skill: [research](../skills/research/SKILL.md). [repository_explorer](../agents/repository_explorer.md) answers repo-internal questions; this procedure answers external ones.

## Bound the question

One question per run, stated by the parent with an explicit success criterion (what a useful answer must contain) and out-of-scope notes. The parent records the question, criterion, and scope in the packed child input so review can check boundedness mechanically. A question that cannot state its success criterion is not ready to run.

## One packed read-only child

Run exactly one isolated read-only child per question per [clean context and isolation](../docs/featureArchitecture/clean-context-isolation.md): the input packs the question, success criterion, scope notes, candidate source list, and output format. The child never spawns further agents, never edits the workspace, and never writes outside its returned report. Network fetching is expected; if sources are unreachable, the child reports them as unknowns instead of filling gaps from memory.

## Primary sources only

Every claim traces to the source that owns it: official documentation, published specifications, first-party APIs and vendor announcements. Secondary commentary (blogs, forum threads, aggregators) may orient the search but never carries a claim. If only secondary sources exist for a claim, record the claim as unverified with the best secondary pointer.

## Citations and freshness

Each claim carries its source URL and an access date. The artifact header carries a freshness label using the repository's Observed convention plus the run date. Claims without a citable source or date are rejected from the artifact, not silently kept.

## Artifact format

Exactly one Markdown file under research/, kebab-case descriptive name. Header block: question, run date, freshness label, scope notes, and the packed success criterion. Body: findings grouped by sub-topic, every claim citation-annotated, an explicit Unknowns section listing what could not be verified, and a Sources list. The artifact is Observed evidence: it may inform plans, grilling sessions, and reviews, but it is never contract source of truth and may go stale; re-verify before reuse in later decisions. The caller materializes the file from the returned report; the child only drafts content.

## Parent interpretation

The child returns the full report content and a proposed artifact path; the caller then writes the report to that path under research/ (the read-only child never writes the workspace itself). The parent reads the artifact, judges relevance and confidence, and decides follow-up. The child does not interpret, recommend, or extend scope.

## Related

- [Research skill](../skills/research/SKILL.md)
- [Clean context and isolation](../docs/featureArchitecture/clean-context-isolation.md)
- [repository_explorer](../agents/repository_explorer.md)
- [Workflow docs index](_index.md)
