---
name: opencode-headless-run
description: >-
  Run reliable headless (non-interactive) OpenCode sessions with opencode run.
  Use when scripting OpenCode, automating reviews or tasks, wiring CI agents, or
  debugging headless failures like empty answers, permission denials, or Session
  not found errors.
---

# Headless OpenCode sessions (OpenCode harness)

Thin harness. Full procedure: Read `{{COMPANION_ROOT}}/skills/opencode-headless-run/SKILL.md`.

## When to use

Scripted/automated `opencode run` invocations; CI or batch review legs; debugging
headless failures (empty answers, permission denials, `Session not found`).

## Read when

| Doc | When |
|-----|------|
| [SKILL.md]({{COMPANION_ROOT}}/skills/opencode-headless-run/SKILL.md) | Invocation flags, environment hygiene, permission rulesets, validation, retry policy |
| [reference-cli.md]({{COMPANION_ROOT}}/skills/opencode-headless-run/reference-cli.md) | Full flag/command tables, permission-model summary, batch + retry examples |

## Must not

- Use skip-permissions workarounds for scripted runs
- Trust exit code alone as success (permission asks resolve as silent denial headlessly)
