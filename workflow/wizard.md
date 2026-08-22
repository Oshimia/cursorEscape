# Wizard generation (advisory)

Procedure for authoring guided scripts for steps only a human can perform. Companion skill: [wizard](../skills/wizard/SKILL.md).

## Scope gate

List the remaining steps and challenge each one: can the agent do this through normal implementation? Anything agent-performable leaves the wizard scope. Confirm the truly human-only list with the owner before authoring anything.

## Value matrix

Map every value the procedure touches into four fields before writing stages: SOURCE (where the human obtains it: vendor console email, portal screen, hardware label), DESTINATION (where it lands: environment file, secret manager entry, vendor form field, service config), SENSITIVITY (public, internal, or secret), STAGE (which ordered step consumes it). A value missing any field is not ready for authoring.

## Stage authoring

Author ordered stages over the confirmed list: each stage states its purpose, prompts only for its own values, pauses for explicit confirmation before destructive or sensitive actions, prefers idempotent operations so reruns are safe, shows progress, and ends with a summary of what changed. Choose the scripting language and destination mechanics from the target repository's discovered conventions at generation time; there is no fixed template library.

## Ephemeral by default

Captured values live only inside the running process unless the owner explicitly chooses persistence for a specific value. Secret-class values are never echoed, logged, printed in summaries, or written to shared artifacts; destinations declared secret-class receive them through the platform's intended mechanism only.

## Static validation gates

Before delivery validate without executing: run the syntax check appropriate to the chosen language; trace every value through its routing proving it reaches exactly its declared destination and nowhere else; audit that secret-class values flow only to secret-class destinations; confirm every destructive action sits behind a confirmation gate.

## Delivery

Hand the owner the script plus its value-routing trace and short run instructions (prerequisites, expected duration, rollback notes where applicable). Execution happens outside the agent; record only the fact of delivery and any owner-reported outcome, never captured values.

## Related

- [Wizard skill](../skills/wizard/SKILL.md)
- [Workflow docs index](_index.md)
