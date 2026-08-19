> **Imported research** — Source: openBuggy `docs/featureArchitecture/cursor-bugbot-agent-review/output-contract.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Output Contract

**Last updated:** 2026-08-04  
**Status:** Observed reference (Cursor Agent Review)

## Context

BugBot’s machine-usable contract is **strict XML**, not free-form chat and not Reviewer-a’s Verdict markdown. Parents parse/summarize this into a severity table. openBuggy’s proposed JSON schema is a deliberate evolution — see severity mapping in [openbuggy-replication-mapping.md](./openbuggy-replication-mapping.md).

## Substance

### Required final answer shape (**Observed**)

```xml
<answer>
  <bug>
    <title>… ≤8 words …</title>
    <file>…</file>
    <start_line>…</start_line>
    <end_line>…</end_line>
    <category>LOGIC_BUG | SECURITY_ISSUE | …</category>
    <severity>high | medium | low</severity>
    <description>…</description>
    <rationale>…</rationale>
  </bug>
  <!-- zero or more additional <bug> elements -->
</answer>
```

**Clean bar:** If no bugs, output exactly:

```xml
<answer></answer>
```

**Hard rules (**Observed**):**

- Nothing outside `<answer>`
- One primary location per bug (`file` + line range)
- Diff mode: file/line “as given in the diff”; NL mode: file/line from the actual inspected file

### Field writing rules (**Observed**)

| Field         | Rule                                                                                                                                                                 |
| ------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `title`       | Short title of **8 words or fewer**                                                                                                                                  |
| `description` | Concise GitHub PR–style comment; root cause + production impact; avoid examples, code blocks, line numbers, and prescriptive language; wrap identifiers in backticks |
| `rationale`   | Explain why it is a bug in **1–2 paragraphs**                                                                                                                        |
| `severity`    | One of: `high`, `medium`, `low` (no `critical` / `info` in Observed enum)                                                                                            |

### Category enum and definitions (**Observed**)

| Category                      | Definition (from expanded mission)                                                                 |
| ----------------------------- | -------------------------------------------------------------------------------------------------- |
| `LOGIC_BUG`                   | Errors in core reasoning/calculations causing incorrect behavior even with valid inputs            |
| `SECURITY_ISSUE`              | Vulnerabilities allowing unauthorized access, data breaches, or other security compromises         |
| `ACCIDENTALLY_COMMITTED_CODE` | Temporary/debug/personal notes mistakenly included                                                 |
| `CODE_QUALITY_STYLE`          | Correct code introducing unnecessary complexity / non-idiomatic patterns that hurt maintainability |
| `DOCUMENTATION_ISSUE`         | Missing, outdated, or incorrect documentation that makes code harder to use                        |
| `POTENTIAL_EDGE_CASE`         | Issues only under unusual/extreme conditions insufficiently tested                                 |
| `PERFORMANCE_ISSUE`           | Code that could cause significant performance degradation                                          |
| `COMPILATION_ERROR`           | Prevents compilation or contains syntax/typecheck errors                                           |
| `BUGBOT_RULES`                | Violations of rules from user instructions; description must name the rule                         |

Despite `CODE_QUALITY_STYLE` existing, the mission also says not to report style nits — **Inferred:** style category is for severe maintainability defects when reported, not formatting bikesheds. Catalog findings cluster on `LOGIC_BUG` / `SECURITY_ISSUE`, with occasional `DOCUMENTATION_ISSUE` / `BUGBOT_RULES`.

### Parent-facing table (**Observed** — skill)

When findings exist, parents print:

| Severity        | Location    | Finding            |
| --------------- | ----------- | ------------------ |
| high/medium/low | `file:line` | Short finding text |

Sorted highest severity first.

### Shared “APPROVED” bar note (**Inferred** tension)

`implementation-review` says BugBot shares the dual-APPROVED bar (Blocking/Non-blocking/Test gaps all `"None"`). **Observed:** BugBot itself emits XML only — parents **infer** clean from empty `<answer></answer>` and map XML bugs into the fix loop. BugBot does not emit Reviewer-a’s Verdict block.

## Implications / open questions

1. openBuggy should keep a stable machine schema (JSON) while preserving BugBot’s semantic fields (title, evidence/rationale, category, severity, file/lines).
2. Map BugBot `high|medium|low` explicitly — do not assume identity with openBuggy’s `critical|high|medium|low|info`.

## Sources

- Expanded mission headers: [a08f99f3](a08f99f3-6233-40c4-85b8-4132655e6feb), [17bc9f41](17bc9f41-75ba-42cd-a8c7-9e120e9ceebc)
- Finding examples: [run-catalog.md](./run-catalog.md)
- Skill: `~/.cursor/skills-cursor/review-bugbot/SKILL.md`
- Skill: `~/.cursor/skills/implementation-review/SKILL.md`
- Primary source: local Cursor agent transcript / skill text (not independently re-verified via public URL)
