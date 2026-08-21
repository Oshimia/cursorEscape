# Tier 2 Finding: handoff

**Snapshot:** Productivity; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/handoff/SKILL.md)
- **Docs:** [handoff.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/handoff.md)

## Verified purpose

`handoff` writes a redacted, targeted Markdown summary to the operating system's temporary directory so a fresh agent can continue in another harness, directory, colleague context, or side task. The catalog is accurate; the docs narrow it sharply versus ordinary compaction: the value is portability, not summarisation.

## Core mechanism

Capture current work, why it matters, next focus, and suggested skills; reference existing specs, plans, ADRs, issues, commits, and diffs rather than duplicating them. Write outside the workspace, redact secrets, and tailor the summary to the supplied next-session argument.

## What it does better than the local equivalent

cursorEscape's Composer has a cap-exhausted handoff path, but no general user-facing portable conversation artifact in the skill index. Upstream's distinction that “handoff writes a portable file” while compact preserves same-session intent is useful for choosing between context operations ([handoff.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/productivity/handoff.md)). Suggested skills and reference-only links also reduce duplicated state.

## What cursorEscape does better

Local clean-context isolation requires the parent to synthesize complete child inputs and forbids relying on prior transcripts ([clean-context-isolation.md](../../../docs/featureArchitecture/clean-context-isolation.md)). Composer's handoff is phase-specific, auditable, and integrated with cap handling. Upstream's temp-directory output is fragile across reboot and harnesses, and its generic summary can become an unverified contract if the next agent does not re-check claims.

## Host dependency

The Markdown format and redaction rule are portable. OS temp paths, cross-harness transfer, and invocation metadata are host-dependent. It is not tracker-coupled.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 3 | Portable concept, but temp location and transfer vary by host. |
| Thin-harness | 4 | A short wrapper can use a shared handoff schema. |
| Gate-able | 4 | Redaction, references, next-focus, and provenance can be checked. |
| Isolated-reviewable | 5 | It directly supports packed fresh-child inputs. |

## Adaptation proposal

**Draft verdict: Adapt.** Extend the existing Composer handoff schema with a portable, user-invoked handoff artifact contract. Preserve non-duplication, redaction, suggested skills, and provenance, but make destination explicit and require the recipient to revalidate claims. Prefer a durable caller-selected path for user handoffs; retain temp output only as a host overlay. Do not create a second Composer procedure.

**Proposed roadmap phase:** Extend `skills/composer` handoff documentation and add a `workflow/handoff.md` schema/portable wrapper; touch agent and workflow indexes after owner acceptance and normal gates.

## Cost + risk

Low-medium cost and medium operational risk. Risks are overlap with Composer, stale or overconfident summaries, secrets in transit, and temp-file loss. Clear distinction between phase QC handoff and user portability is required.

## Verdict

**Adapt (draft; owner discussion required).** Reuse the portability contract only where it complements, rather than duplicates, Composer's cap-exhausted handoff.
