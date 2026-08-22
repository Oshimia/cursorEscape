# bug_reviewer finding rubric

**Last updated:** 2026-08-22

## Context

**Target** companion for the [bug_reviewer](../../agents/bug_reviewer.md) role. Encodes **what to report vs ignore** so spawned bug-finder agents suppress nits, out-of-scope, and pre-existing issues while still hunting **introduced production** defects.

Grounded in:

- **Observed** BugBot mission / finding personality (imported openBuggy FA)
- **Observed** DSV4F / promote-audit ignore themes (sibling openBuggy analysis — paraphrased; not a full research import)

Claim labels on Sources below. This page is Target behavior for recreation hosts (OpenCode adapter mirrors under host `docs/workflow/`).

---

## Substance

### Mission (Required)

Identify bugs that may have been **introduced** by the scoped change. A bug is behavior that is **incorrect, unsafe, or likely to break users in production**.

Do **not** report style issues, nits, speculative problems, or intentional behavior.

### Report (all must hold)

| Criterion | Detail |
| --------- | ------ |
| Production impact | Incorrect, unsafe, or likely to break users in production |
| Introduced by change | Present in the scoped diff / change description / Custom Instructions — not merely present in the file |
| In scope | Within stated scope and Custom Instructions (phase theme, regressions to flag) |
| Clear on workspace | Exhibited or strongly evidenced on the reviewed workspace — not env speculation |

If nothing meets all four: emit **empty findings** (host XML empty `<answer></answer>` or equivalent lists all `"None"` with no bug bodies).

### Ignore (do not report)

| Class | Examples (Observed themes) |
| ----- | -------------------------- |
| Style / nits | Formatting, naming bikesheds, import sort |
| Cosmetic / dead-code nits | Unused props/params, dead locals — unless scope explicitly includes them |
| Out-of-scope true defects | Real issue on a wrong surface (e.g. robustness outside stated mint/reopen theme) |
| Speculative / env-coupled | Claims needing environments, grants, or schemas not evidenced on the fixture/workspace |
| Harness / stub / doc-table nits | CWD/runner coupling, malformed README tables on stubs — unless scope includes them |
| Pre-existing | Present on base (`main` / prior revision) and not introduced by the change — verify when diff mode allows |
| Process/docs completeness | Incomplete SOPs, missing tests as process — owned by [production_readiness_reviewer](../../agents/production_readiness_reviewer.md) unless framed as a real production/doc bug |

### Clean / validated-fix context (Required)

When Custom Instructions or envelope signal a **clean** / validated-fix review (e.g. Fast CI passed, “re-check fix only”): high conservatism — **empty findings** unless a report is **unambiguously** wrong on the reviewed workspace.

**Precedence:** Clean / validated-fix context **overrides** the doubt rule’s “report” row. Under clean signals, residual doubt → **do not report**.

### Doubt rule (Required)

Apply only after the Ignore table and clean/validated-fix precedence above. A “report” outcome still must satisfy **all** Report criteria (production impact, introduced by change, in scope, clear on workspace).

| Doubt about… | Action |
| ------------ | ------ |
| Whether an **in-scope production** defect exists (and Report criteria are otherwise met; **not** under clean/validated-fix signals) | **Report** |
| Whether something is a nit / out-of-scope / pre-existing / speculative | **Do not report** |

Do not let “when in doubt, report” become nit spam. That recall bias applies only inside the Report table and never under clean/validated-fix override.

### Evidence discipline

The precedence chain above governs whether something is reported; this section governs how reported findings are evidenced. It adds no report-or-suppress rule and does not reorder the chain.

- **Evidence kinds:** diff, call_path, test, static_analysis, workspace_reproduction, runtime_trace, inference. Cite the strongest kind available per finding.
- **Inference weighting:** an `inference`-only finding should be framed as lower confidence rather than suppressed; the doubt rule above still decides reportability for in-scope production defects.
- **Cheap localization:** when inexpensive, name the smallest changed hunk, input, or branch that shows the issue.
- **Opportunistic reproduction boundary:** read-only inspection or running existing safe commands is allowed only with no file modification, no installation, no service/database mutation, no artifact writes, no added instrumentation, and no material increase in review time. Default is no reproduction.
- **Redaction:** redact secrets and personal data from any captured output before it enters a finding.
- **Follow-up field:** a finding may end with `Follow-up: diagnosis` plus a one-line reason and the evidence still needed. It recommends the separate user-invoked shipped-code diagnosis workflow and never launches it; absence means none.

### Custom Instructions (parent)

Parents may name out-of-scope themes, regressions to re-check, and clean-case signals. Respect those envelopes. Do not invent scope expansion.

---

## Implications / open questions

1. **M5 copy/string recall** (helper-text / UI-copy FNs from DSV4F) is **out of scope** for this rubric revision — document only; may be added later without weakening the Ignore table.
2. Over-suppression risk on borderline introduced defects remains **Unknown** until re-measured on eval corpora.
3. Host adapters must mirror this page (or Read when it) into the bug_reviewer agent load path.

---

## Sources

- **Observed/imported:** [finding-personality.md](../../research/imported/openBuggy/featureArchitecture/cursor-bugbot-agent-review/finding-personality.md), [harness-expansion-and-mission.md](../../research/imported/openBuggy/featureArchitecture/cursor-bugbot-agent-review/harness-expansion-and-mission.md)
- **Observed (sibling, not imported):** openBuggy `docs/analysis/DSV4F/mitigations.md` (M1–M4), `docs/SOPs/agentic-promote-audit.md` reject themes, `docs/analysis/DSV4F/run-report.md`
- **Target analysis:** [opencode-dsv4f-session-2026-08.md](../../analysis/opencode-dsv4f-session-2026-08.md) — eager bugfinder signal
- **Adapted design (sibling, not imported):** openBuggy `docs/featureArchitecture/change-review-and-diagnosis-boundary.md` change-review profile (evidence-first techniques, read-only reproduction boundary, follow-up signal)

---

## Related

- [bug_reviewer](../../agents/bug_reviewer.md)
- [production_readiness_reviewer](../../agents/production_readiness_reviewer.md)
- [intended-workflow](./intended-workflow.md)
- [instruction-layering](./instruction-layering.md)
