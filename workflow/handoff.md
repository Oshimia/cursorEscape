# Portable handoff

**Last updated:** 2026-08-22

Contract for a redacted Markdown artifact that lets work continue in a fresh session, host, directory, or colleague context. User-invoked only.

## What this is

A portable handoff is a single self-contained Markdown document the caller (the user) can drop into any new context: another session, another host, another repository checkout, or a colleague's environment. It carries orientation, not state: where work stands, why it matters, what to read next, and which claims the recipient must revalidate. The agent writes it on request; it is never produced automatically and never replaces session mechanics like compacting or QC triage.

## When to use

| Operation | Scope | Definition lives in |
|-----------|-------|---------------------|
| Compacting | Same-session intent preservation; the conversation continues with itself | Host mechanism (not this doc) |
| Composer cap-exhausted handoff | QC triage inside phased execution when iteration 4 ends without dual APPROVED | [composer SKILL.md](../skills/composer/SKILL.md) Cap-exhausted handoff schema section (never duplicated here) |
| Portable handoff | Cross-session, cross-host, cross-directory, or cross-person continuation | This doc |

## Artifact schema

```markdown
# Handoff: <one-line title>

- **Timestamp (UTC):** <YYYY-MM-DD HH:MM UTC>
- **Source:** <repo path> @ <HEAD SHA> (<branch>)
- **Destination:** <explicit caller-selected path; durable workspace location preferred>
- **Audience / purpose:** <who continues this and toward what outcome>

## Current state

<Concise summary of where the work stands>

## Why it matters

<The goal or motivation the recipient needs to preserve intent>

## Next focus

<The concrete first moves for the recipient>

## References

<Links to specs, plans, ADRs, issues, commits, diffs: pointers only, never copied content>

## Claim provenance

<Which statements above are verified vs assumed>

## Suggested skills

<Skill names that exist in the repo's local skill index (e.g. workflow/_index.md Skills table); none invented>

## Open questions / blockers

<Known unknowns and blocking conditions>
```

Destination guidance: prefer a durable path inside the workspace chosen by the caller. OS temp directories are allowed only as a host-overlay-level fallback, with an explicit caution that temp contents may not survive reboot or cleanup.

## Rules

1. Redact secrets, tokens, and environment values before writing the artifact, then re-scan the finished text before handing it over.
2. The destination is explicit and caller-selected; the agent never silently picks where the artifact lands.
3. References point, they do not copy: link specs, plans, ADRs, issues, commits, and diffs instead of duplicating their content.
4. Provenance labels distinguish verified facts from assumptions so the recipient knows what to trust and what to check.
5. The recipient MUST revalidate claims; the artifact is a starting map, not a verified contract.
6. No host-specific transfer mechanics and no tracker coupling: the artifact stays plain Markdown readable anywhere.
7. This is not the Composer cap-exhausted QC handoff and does not replace it (see When to use).

## Related

- [Composer skill](../skills/composer/SKILL.md) (cap-exhausted handoff distinction)
- [Workflow docs index](_index.md)
- [Clean context isolation](../docs/featureArchitecture/clean-context-isolation.md) (packed-input discipline for recipients)
