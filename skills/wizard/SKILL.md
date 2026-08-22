---
name: wizard
description: >-
  Author staged interactive scripts for steps only the human can perform:
  external consoles, credentials, provisioning portals, one-off migrations.
  Values mapped by source, destination, sensitivity, and stage; statically
  validated; handed to the owner to run outside the agent. Never executed
  in-agent.
disable-model-invocation: true
---

# Wizard

## When to use

The remaining work consists of steps only the human can perform because they need browser logins, vendor consoles, credential entry, or physical access. If any step is something the agent could do itself, that step belongs to normal implementation instead.

## Workflow

The companion procedure defines generation: confirm the stages are genuinely human-only, map every value, author the staged script, statically validate, deliver. The caller owns scope approval and runs the result outside the agent.

## Outputs

One authored interactive script plus its value-routing trace, delivered to the owner with run instructions. Nothing is executed by the agent; no real secret values are ever captured into conversation, findings, or logs.

## Read

- [Wizard procedure](../../workflow/wizard.md)

## Must not

Never execute or dry-run the generated script or any part of an interactive procedure; execution belongs exclusively to the owner outside the agent. Never capture or echo real secret values anywhere. Never assume a destination is trusted or permanent without the owner saying so. Never generate wizards for steps the agent can perform itself.

## Related roles

The owner approves the procedure scope, runs the script, and supplies nothing to the agent except confirmations. The agent scopes stages, authors the script, and validates it statically.

## Provenance

Adapted from the pinned mattpocock/skills snapshot at commit 0ab1b63: [source skill](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/wizard/SKILL.md). The upstream fixed Bash template library was replaced by a portable destination-kinds catalog with runtime-chosen scripting language.
