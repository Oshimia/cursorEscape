# Tier 1 Finding: wizard

**Snapshot:** Engineering; `mattpocock/skills` commit `0ab1b63`.

- **Source:** [SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/wizard/SKILL.md)
- **Docs:** [wizard.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/wizard.md)

## Verified purpose

`wizard` generates a bash program for manual steps that the agent cannot perform, rather than emitting a fragile numbered chat checklist. The source explicitly covers provisioning, credentials, dashboards, migrations, and cutovers, and says not to use it for steps the agent can perform. This matches the catalog's provisional description.

## Core mechanism

Scope the human-only procedure and its captured values first, obtain confirmation of the ordered stages, then author stages over a fixed `template.sh` library. The library provides progress, confirmation gates, URL opening, hidden secret input, idempotent `.env` writes, GitHub secret/variable writes, and a final summary. Verification is static (`bash -n`, optional `shellcheck`, and value-routing trace); the agent does not execute the interactive script.

## What it does better than the local equivalent

There is no local equivalent in the skills index. The source makes the human/agent boundary executable: “Your job is only to scope the procedure and author its stages,” while the generated artifact owns state and repetition ([SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/wizard/SKILL.md)). Its completion criteria are unusually concrete: every value has a source, destination, sensitivity, and stage; `set_secret` names must match CI references; and a static trace replaces unsafe end-to-end execution. The docs also define ephemeral-by-default handling and rerun behavior ([wizard.md](https://github.com/mattpocock/skills/blob/0ab1b63/docs/engineering/wizard.md)).

## What cursorEscape does better

cursorEscape has a stronger host-neutral contract split: portable root contracts, companion procedures, and host overlays are indexed separately ([skills/_index.md](../../../skills/_index.md), [skill-source-and-host-overlays.md](../../../docs/featureArchitecture/skill-source-and-host-overlays.md)). It also requires independent production-readiness and bug review with clean-context isolation ([agents/_index.md](../../../agents/_index.md), [clean-context-isolation.md](../../../docs/featureArchitecture/clean-context-isolation.md)). The upstream template assumes Bash and optional `gh`; it does not provide an equivalent portable artifact contract for Windows-native workflows or arbitrary secret stores.

## Host dependency

The generated artifact is broadly portable only where Bash exists. The source skill's authoring workflow is harness-neutral in intent, but its implementation depends on the upstream fixed Bash template, browser/URL opening, and GitHub CLI for some destinations. It is not intrinsically Claude-only, though the source docs describe Claude/Codex invocation.

## Fit with cursorEscape philosophy

| Principle | Score (1-5) | Evidence |
|---|---:|---|
| Host-agnostic | 3 | Script output is portable Bash, but template and `gh`/dashboard assumptions need adapters. |
| Thin-harness | 4 | A short trigger can point to a companion template/procedure; the reusable library should not be in the trigger. |
| Gate-able | 5 | Static syntax, shellcheck, destination trace, and secret-name checks are explicit gates. |
| Isolated-reviewable | 4 | Generated scripts can be reviewed statically without running them; human execution remains outside agent context. |

## Adaptation proposal

**Draft verdict: Adapt.** Add a portable `skills/wizard/SKILL.md` pointer and companion workflow defining a human-only-step artifact contract, not a copy of the upstream template. Keep the procedure scope/stage/value matrix, explicit user confirmation, static validation, and “never run interactively” rule. Replace upstream GitHub-specific persistence with destination adapters documented in an overlay (for example, Bash/PowerShell host wrappers), and require local secret-handling and review gates before a repeatable script is committed. Do not make this part of the normal build chain; it is a standalone handoff at the automation boundary.

**Proposed roadmap phase:** Build `skills/wizard/` plus a portable companion and host-overlay adapter note; touch `skills/_index.md` and relevant workflow indexes only after the normal plan/review gates; add focused static-validation examples, without importing `template.sh` verbatim.

## Cost + risk

Medium authoring cost and low-to-medium review burden. The main risk is accidentally shipping a Bash/GitHub implementation as a root contract, or treating generated scripts as trusted despite credential writes and irreversible actions. There is also overlap risk with future setup/migration helpers; scope this to human-only procedures and keep it independent of provisioning policy.

## Verdict

**Adapt (draft; owner discussion required).** The human-in-the-loop artifact and static safety bar fill a real local gap, but the upstream runtime library must be replaced by a portable contract and overlays.
