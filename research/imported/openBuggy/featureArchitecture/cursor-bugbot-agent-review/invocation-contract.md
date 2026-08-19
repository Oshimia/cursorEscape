> **Imported research** — Source: openBuggy `docs/featureArchitecture/cursor-bugbot-agent-review/invocation-contract.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Invocation Contract

**Last updated:** 2026-08-04  
**Status:** Observed reference (Cursor Agent Review)

## Context

Parents do not hand BugBot a free-form “please review” essay as the primary contract. Cursor expects a **fixed Task shape** and a **fixed prompt envelope**. Getting this wrong triggers skill-defined retries or failure.

## Substance

### Task metadata (**Observed** — `review-bugbot` skill + system `available_subagent_types`)

| Field               | Required value / rule                                                    |
| ------------------- | ------------------------------------------------------------------------ |
| `subagent_type`     | `"bugbot"`                                                               |
| `description`       | Exactly `"Bugbot"`                                                       |
| `run_in_background` | `false` unless user explicitly asks for background                       |
| `readonly`          | Commonly `true` in review-loop parents (**Observed** practice)           |
| `model`             | Often `composer-2.5` in EZPZ review loops; not part of the envelope text |
| `resume`            | **Must not** be used — BugBot is single-shot; always launch fresh        |

### Prompt envelope (**Observed**)

Exact shape from `review-bugbot`:

```text
Full Repository Path: <absolute repository path>
Diff: <one of: "branch changes", "uncommitted changes", "natural language">
Base Branch: <only when reviewing branch changes against a known non-default base>
Change Description: <required only when Diff is "natural language">
Custom Instructions: <only when the user or parent skill gave specific review instructions>
```

### Diff mode selection (**Observed**)

| Mode                  | When parents use it                                                                                                     |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `branch changes`      | **Default.** Merge-base with default/base branch; includes committed, staged, and unstaged changes (per skill wording)  |
| `uncommitted changes` | User asks for dirty/working-tree/not-yet-committed-only review                                                          |
| `natural language`    | Last resort after empty/failed diff computation, or when parents deliberately scope a dirty tree via a file-by-file map |

**Observed:** Parents must **not** pre-compute the git diff themselves for normal modes — the review subagent/harness computes it from `Full Repository Path`.

### `Change Description` format (NL mode) (**Observed**)

One block per changed file:

```text
<path> (added|modified|deleted|renamed):
- bullet of what changed (optional L40-58 line hints)
```

### `Custom Instructions` themes (**Observed** in EZPZ `implementation-review`)

When launched from the iterative review loop, Custom Instructions typically include:

- Completion gate: `review-loop`
- Plan phase N of M and/or review iteration N
- What the phase is supposed to accomplish
- Regressions to watch (auth bypass, data leaks, incomplete changeset)
- Out-of-scope items (ignore unrelated dirty-tree files / other phases)
- Note that Fast CI already passed; do not re-run lint/test

Bare `/review-bugbot` may omit Custom Instructions entirely.

### Parent summarization after return (**Observed** — skill)

| BugBot result              | Parent user-facing summary                                                           |
| -------------------------- | ------------------------------------------------------------------------------------ |
| Empty / no issues          | One-liner e.g. “Bugbot found no bugs”                                                |
| Findings                   | Markdown table: **Severity \| Location (file:line) \| Finding**, severity descending |
| Empty diff                 | One sentence: no diff to review                                                      |
| Hard failure after retries | Short error; stop                                                                    |

Parents should **not** fix findings or re-run review unless the user (or review-loop skill) asks for the next step.

### PR/branch checkout special case (**Observed** — skill)

If the user asks to review a specific PR or branch, the parent must check out that branch locally before launching BugBot (stash only after user confirms).

## Implications / open questions

1. openBuggy CLI/MCP should accept an analogous envelope: repo path, scope enum, optional base, optional NL change map, optional user instructions.
2. Exact git flags behind `branch changes` vs `uncommitted` remain **Unknown** — see [unknowns-and-non-replicables.md](./unknowns-and-non-replicables.md).

## Sources

- Skill: `~/.cursor/skills-cursor/review-bugbot/SKILL.md`
- Skill: `~/.cursor/skills/implementation-review/SKILL.md` (Invoke Bugbot section)
- Parent examples: [673cf81a](673cf81a-41fd-424a-9276-8fda415f864d), [c5d86381](c5d86381-0609-4b7f-8296-09dec84bb5e8), [a4e1457e](a4e1457e-e638-4699-bfe2-33ecf3d4b6e9)
- Primary source: local Cursor agent transcript / skill text (not independently re-verified via public URL)
