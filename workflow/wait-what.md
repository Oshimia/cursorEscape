# Wait-what procedure

**Last updated:** 2026-08-23

Deep companion for the [wait-what skill](../skills/wait-what/SKILL.md): a user-invoked communication-repair loop. When the owner signals that the last explanation did not land, the agent re-pitches it: adding the missing premise instead of bluntly truncating, in a simplified technical register. User-invoked only.

## Trigger semantics

The owner explicitly invokes the re-pitch: saying the explanation did not land ("wait, what?"), asking for it again more simply, or otherwise signaling non-comprehension. The trigger is the owner's signal, never the agent's self-assessment; the agent never fires this loop unprompted and never ambient-loads it into ordinary sessions. One invocation covers one message: the agent re-pitches the most recent explanation, then stops. The loop ends when the owner confirms comprehension or redirects; if the re-pitch also misses, the owner invokes it again.

## Re-pitch rules

1. **Name what did not land.** Before re-explaining, identify the specific part that failed: an unstated premise, an undefined term, a skipped inference, or too many ideas at once. Say this identification out loud in one short sentence so the owner can correct it.
2. **Add the missing premise.** Success is comprehension, not brevity. When something was cut for concision, restore the missing context rather than deleting more words. A shorter re-pitch that still skips the premise is a failed re-pitch.
3. **Simplified technical register.** Short sentences; one idea per sentence; common words over specialized ones where precision allows. This register is adapted from ASD-STE100 Simplified Technical English as a writing discipline; the standard itself is not imported, consulted, or required.
4. **One re-pitch per invocation.** Do not spiral into repeated paraphrase attempts within a single pass; hand control back to the owner.

## Vocabulary grounding

Before re-pitching, check whether the repo has locally discovered shared-language material (a glossary, domain-language section, or equivalent) using [discovery](discovery.md) Step 0 / fallback:

- **Glossary found:** reuse its exact terms and definitions; align the re-pitch with the shared vocabulary rather than inventing synonyms.
- **No glossary:** say so plainly in one sentence ("no shared glossary exists here"), use plain consistent wording of your own choosing, and keep that wording stable across the re-pitch. Never invent, reference, or require a `CONTEXT.md`, `CONTEXT-MAP.md`, or any glossary file that does not exist.

Vocabulary discovery replaces any assumed context-file convention; nothing upstream is copied.

## Boundaries

- User-invoked only: never model-invoked, never ambient-loaded; hosts advertise it as caller-loaded (`disable-model-invocation: true`).
- Not a substitute for [domain-modeling](domain-modeling.md): wait-what repairs one missed explanation; building durable shared language is domain-modeling's job.
- No durable artifact writes: the re-pitch lives in conversation only; no files are created or modified.

## Related

- [Wait-what skill](../skills/wait-what/SKILL.md)
- [Workflow docs index](_index.md)
- [Discovery procedure](discovery.md) (local vocabulary lookup)
- [Domain-modeling procedure](domain-modeling.md) (durable shared-language discipline)
