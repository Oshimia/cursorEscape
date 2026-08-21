# Tier 2 Finding: research

**Snapshot:** Engineering; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/research/SKILL.md)
- **Docs:** [research.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/research.md)

## Verified purpose

`research` delegates external reading to a background agent, restricts claims to high-trust primary sources, and writes one cited Markdown artifact where the repository keeps notes. The catalog is accurate; the docs make delegation and durable citations the defining behavior rather than an answer returned in chat.

## Core mechanism

Scope a question, run exactly one background research task, trace claims to official docs/source/specs/first-party APIs, write one Markdown file with claim-level citations, and return the path. The source has no stopping criterion and permits accidental nested background agents, both material operational details.

## What it does better than the local equivalent

Local `repository_explorer` is a bounded read-only exploration role, while upstream produces a reusable cited artifact and states “Follow every claim back to the source that owns it” ([SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/research/SKILL.md)). The primary-source constraint and one-file output make external fact gathering auditable and easier to hand into a later plan or grill session ([research.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/research.md)).

## What cursorEscape does better

cursorEscape already defines parent-owned context packing and isolated child roles, including repository exploration ([agents/_index.md](../../../agents/_index.md), [clean-context-isolation.md](../../../docs/featureArchitecture/clean-context-isolation.md)). Upstream's unguarded background delegation can nest and duplicate work, and its “high-trust” test is model judgment without an allowlist or verification pass. Local research output also needs an explicit freshness/Observed label to avoid becoming accidental architecture SoT.

## Host dependency

Primary-source research and Markdown are portable. Background-agent invocation, network access, and source browsing require host capabilities; no tracker is inherently required. The upstream skill's nested-agent behavior is host-sensitive and unsafe to copy unchanged.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 4 | Artifact and source discipline are portable; dispatch/network need overlays. |
| Thin-harness | 4 | A pointer can carry the bounded research procedure. |
| Gate-able | 4 | Scope, source quality, citations, and one-artifact checks are gateable. |
| Isolated-reviewable | 5 | It naturally fits a read-only child with packed inputs and a report. |

## Adaptation proposal

**Draft verdict: Adapt.** Add a portable research skill and companion that accepts a bounded question, packs all inputs into one read-only child, forbids child re-delegation, requires source URLs and freshness labels, and writes under the existing `research/` convention. Keep the parent responsible for scope and final interpretation; do not treat the output as contract SoT.

**Proposed roadmap phase:** Add `skills/research/` and a `workflow/research.md` companion, plus a research-report schema and agent/index entries; implement only after owner acceptance and the normal gates.

## Cost + risk

Medium cost and medium operational risk. Risks are nested-agent cost, unbounded scope, citation laundering, stale research poisoning future context, and network/source availability. A bounded question and explicit Observed status are essential.

## Verdict

**Adapt (draft; owner discussion required).** The cited artifact and primary-source discipline fill a useful gap, but delegation must be rebuilt around local isolation and bounded scope.
