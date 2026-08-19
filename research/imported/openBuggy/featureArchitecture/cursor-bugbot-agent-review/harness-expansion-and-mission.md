> **Imported research** — Source: openBuggy `docs/featureArchitecture/cursor-bugbot-agent-review/harness-expansion-and-mission.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Harness Expansion and Mission

**Last updated:** 2026-08-04  
**Status:** Observed reference (Cursor Agent Review)

## Context

The parent envelope is short. The BugBot subagent’s first user message is a **long harness-expanded mission**. This doc paraphrases that mission (quote depth policy: paraphrase + short excerpts only — not a full proprietary prompt dump).

## Substance

### Expansion pipeline (**Observed**)

```text
Parent envelope
  → Cursor harness computes diff OR accepts NL Change Description
  → Injects mission template + <user_instructions> + <diff> OR NL change map
  → BugBot subagent runs tool loop
  → Final message must be XML-only <answer>…
```

### Mission skeleton (paraphrase) (**Observed**)

Common opener (verbatim excerpt):

> “You are reviewing local code changes for bugs.”

Core directives (paraphrased from expanded prompts):

1. Identify bugs that may have been **introduced** by the provided changes.
2. Primary goal: catch potential production bugs; **a missed bug is far more costly than a false positive**.
3. When in doubt, report; investigate suspicious patterns thoroughly before dismissing.
4. Report only bugs introduced by the change set — not pre-existing issues in unrelated code.
5. A bug is behavior that is **incorrect, unsafe, or likely to break users in production**.
6. Do **not** report style issues, nits, speculative problems, or intentional behavior.
7. Use tools to inspect surrounding code; **do not modify files**.

### Diff-mode vs NL-mode framing (**Observed**)

| Mode             | Additional framing                                                                                                                                                                                                                    |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Diff-injected    | “only report bugs … introduced by the changes in the **provided diff**”; file/line fields should match the diff                                                                                                                       |
| Natural language | “You were **NOT** given a diff”; treat the description as a **map of where to look**, not as evidence; **read actual current code** before reporting; because pre-change state is invisible, rely on the description for what changed |

### `<user_instructions>` (**Observed**)

When the parent includes `Custom Instructions`, they appear inside `<user_instructions>…</user_instructions>` and the mission says to take them into account. Examples: phase focus, ignore unrelated dirty tree, “CI already passed”, security surfaces.

### Output mandate (**Observed**)

The mission ends with a mandatory XML schema (see [output-contract.md](./output-contract.md)) and:

- If no bugs: output exactly `<answer></answer>`
- Do not output anything outside `<answer>`
- If multiple locations share one bug, choose a single best primary location

### Quote-depth policy (this archive)

| Allowed                                                        | Forbidden                                                |
| -------------------------------------------------------------- | -------------------------------------------------------- |
| Short verbatim excerpts (1–2 sentences) that establish wording | Pasting the full expanded prompt or full `<diff>` bodies |
| Paraphrase of rules and categories                             | Shipping Cursor skill files into this repo               |

### What is **not** visible in the expanded user message (**Unknown**)

- Hidden system prompts beyond the expanded user_query
- Model routing / temperature
- Server-side second-pass critics
- Tool allowlist configuration beyond what the agent actually calls

## Implications / open questions

1. openBuggy should implement an explicit “mission template” stage after scope resolution — parents should not invent divergent bug definitions.
2. Recall bias (“missed bug worse than FP”) plus style suppression is the core personality; replicate both, not just one.

## Sources

- Subagent headers: [17bc9f41](17bc9f41-75ba-42cd-a8c7-9e120e9ceebc) (NL), [a08f99f3](a08f99f3-6233-40c4-85b8-4132655e6feb) (diff), [d143b0d4](d143b0d4-0e23-440b-bea8-60468341bafd) (diff)
- Parents: [673cf81a](673cf81a-41fd-424a-9276-8fda415f864d), [33ebcc6d](33ebcc6d-cba2-40cd-82cb-63b734d47da5), [a4e1457e](a4e1457e-e638-4699-bfe2-33ecf3d4b6e9)
- Primary source: local Cursor agent transcript / skill text (not independently re-verified via public URL)
