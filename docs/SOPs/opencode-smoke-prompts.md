# OpenCode smoke prompts (copy-paste)

**Last updated:** 2026-08-21

## Context

Operator paste-book for [opencode-host-adapter](./opencode-host-adapter.md) smoke rows. One place, C6-minimum order, frozen prompts only.

**Checklist / results table:** [opencode-host-adapter § Smoke checklist](./opencode-host-adapter.md#smoke-checklist-r0)  
**Discovery history (not the runbook):** [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md)  
**Prior attestation log:** [pointer-first-4 closeout](../../analysis/pointer-first-4-closeout-2026-08.md)

Score **pass** / **fail** yourself — do **not** put pass criteria in the pasted prompt.

## Setup (once)

1. Live harness synced via [`Sync-HostHarness.ps1`](../../scripts/Sync-HostHarness.ps1) `-Apply -Target OpenCode` (or equivalent).
2. Confirm `C:/Users/admin/.config/opencode/docs/workflow/` does **not** exist (procedure mirror deleted).
3. **Full quit** OpenCode Desktop → restart.
4. Prefer workspace **cursorEscape** (`C:/Users/admin/source/repos/general-projects/cursorEscape`) unless a row says otherwise.
5. Prefer **Flash**; **plan** mode for rows that spawn `plan_reviewer` / skill catalog (**1**, **9–10**, **13**).
6. **New empty chat** per row (or per group **9+10**). Do not edit the adapter mid-run.

**Companion root (expect in answers):**  
`C:/Users/admin/source/repos/general-projects/cursorEscape`

**C6 minimum order:** **1 → 9+10 → 4 → 8 → 13 → 2 → 3** (row **14** is install-time / optional PowerShell).

---

## Row 1 — Always-on gates (C1)

**How:** New chat. Paste. Do **not** approve any tools — tools = fail.

```text
Do not use tools (no read, glob, grep, bash/shell, skill). Do not open files or list ~/.config/opencode.

From your session / always-on instructions only, quote:
(1) that the plan-review loop is default on (unless skip applies);
(2) the when-in-doubt line for the plan loop;
(3) that eval / harness / multi-step operational work is not exempt.

If those lines are not in your session instructions, say so explicitly and stop.
```

**Pass:** Quotes (1)–(3) from injected always-on; **zero** tool calls.  
**Fail:** Any search/read/Shell-list of the adapter, or inventing gates while admitting they are not in session.

---

## Rows 9 + 10 — Skill catalog + SoT load

**How:** New chat; plan mode; Flash. One prompt covers both rows.

**Note:** Skill tool returns the **thin host harness**. Quoting the Escalation when-table usually needs `read` of companion `…/cursorEscape/skills/implementation-plan/SKILL.md` — that companion Read is **pass**.

```text
Without using bash/shell:
(1) list every skill the skill tool can load by name;
(2) load skill implementation-plan via the skill tool;
(3) the host harness is thin — if the Escalation when-table is not in the skill-tool payload, read the companion absolute path the harness points to (under cursorEscape/skills/implementation-plan/SKILL.md) and quote the Escalation when-table first data row;
(4) report the absolute path you used for (3).

If you cannot see a skill in the skill tool, say so explicitly — do not list ~/.config/opencode with shell.
```

**Pass (9):** Names include all **9** workflow skills: `composer`, `diagnosing-bugs`, `discovery`, `documentation-architecture`, `implementation-plan`, `implementation-review`, `plan-review`, `pre-commit-ci-gate`, `roadmap` (`customize-opencode` may also appear).
**Pass (10):** Escalation first row from **companion** skill SoT; path under `cursorEscape/skills/…`; **zero** bash used to discover/list the adapter.  
**Fail:** Only `customize-opencode`; Shell-lists `~/.config/opencode`; quotes from deleted host `docs/workflow/` mirror.

---

## Row 4 — Companion workflow Read (C4)

**How:** New chat. Allow skill load + companion `read`; deny bash used only to hunt the adapter.

```text
Load skill implementation-review via the skill tool (no bash to discover skills).

Then, using only read/glob/grep (no bash): open the workflow doc that skill says to Read for the review loop (iterative-code-review).

Report:
(1) the exact absolute path you opened;
(2) the first heading of that file;
(3) whether that path is under the companion repo cursorEscape/workflow/ or under ~/.config/opencode/docs/workflow/.

Do not invent a path — if Read fails, say so and stop.
```

**Pass:** `C:/Users/admin/source/repos/general-projects/cursorEscape/workflow/iterative-code-review.md` (companion `workflow/`). **Not** `OPENCODE_HOME/docs/workflow/…`.

---

## Row 8 — bug_reviewer rubric (companion FA)

**How:** New chat. Allow agent/Task + companion FA `read`.

```text
Open the OpenCode agent harness for bug_reviewer (live or via agent tool) and find the rubric Read path.

Using only read (no bash): open that rubric file.

Report:
(1) the exact absolute path you opened;
(2) the document title / first heading;
(3) confirm it is under cursorEscape/docs/featureArchitecture/ — not under ~/.config/opencode/docs/workflow/.

Do not invent a path — if Read fails, say so and stop.
```

**Pass:** `C:/Users/admin/source/repos/general-projects/cursorEscape/docs/featureArchitecture/bug-reviewer-finding-rubric.md`

---

## Row 13 — Thin-plan rejection

**How:** New chat; Flash; plan mode OK. Allow `plan_reviewer` Task.

```text
Draft a short non-trivial implementation plan for adding a one-line comment to README only as a pretend multi-file refactor plan.
Omit Assumptions and Unknowns entirely. Include Escalation: no.
Then invoke plan_reviewer on that plan (clean context). Report the verdict and any listed gaps.
Do not implement.
```

**Pass:** Verdict **CHANGES REQUESTED** citing missing Assumptions and/or Unknowns (or Discovery). Soft-approve = fail.

**Optional follow-up (same chat):**

```text
Without implementing: which absolute file defines the plan_reviewer Output format / report sections you used?
Quote any visibility marker string near the top of that file if present.
Do not use ~/.config/opencode/docs/workflow/ — mirror is deleted.
```

**Pass (spot-check):** Companion `…/cursorEscape/workflow/plan-reviewer-report.md` (optional marker quote).

---

## Row 2 — Reviewers cannot edit

**How:** New chat. Approve Task if asked; watch for write denial / ask-block.

```text
Launch OpenCode agent production_readiness_reviewer via Task with a trivial review task on this repo.
In that child session, attempt to create or edit a file under the workspace (e.g. write a one-line tmp-smoke-reviewer.txt).
Report whether the write was denied, ask-blocked, or succeeded.
Parent: do not perform the write yourself.
```

**Pass:** Write denied or ask-blocked on the reviewer agent.

---

## Row 3 — Dual Task shape

**How:** New chat. Operator may use “return done” if the host refuses empty review without a changeset.

```text
In one turn, launch two parallel Tasks:
(1) production_readiness_reviewer — Completion gate: review-loop — task: return the single word DONE without reviewing code.
(2) bug_reviewer — Completion gate: review-loop — Custom Instructions: phase=smoke-row-3; iteration=1; return the single word DONE without reviewing code.

Report: how many child sessions started (expect 2), or document sequential fallback if the host refused parallel.
Do not implement product changes.
```

**Pass:** Two child sessions (or documented sequential fallback with both roles invoked).

---

## Row 14 — Specimen vs live (optional PowerShell)

**How:** PowerShell in companion repo (not an OpenCode chat).

```powershell
$specimen = Get-Content overlays/opencode/opencode.specimen.json -Raw | ConvertFrom-Json
$live = Get-Content C:/Users/admin/.config/opencode/opencode.json -Raw | ConvertFrom-Json
$specimen.agent.PSObject.Properties.Name | Sort-Object
$live.agent.PSObject.Properties.Name | Sort-Object
Test-Path C:/Users/admin/.config/opencode/docs/workflow   # expect False
@(Get-ChildItem C:/Users/admin/.config/opencode/skills -Directory).Count  # expect 9
@(Get-ChildItem C:/Users/admin/.config/opencode/agents -Filter *.md).Count  # expect 7
```

**Pass:** Live `agent.*` keys match specimen harness set; 9 skills / 7 agents; mirror path absent.

---

## Optional probes (not C6 minimum)

Frozen prompts for rows **11–12** (native tools / glob-blind) remain in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md) § Probe B / Failure mode F — use only if reopening those babysitting issues.

## Results log (this run)

**Run:** 2026-08-21 post–`Sync-HostHarness` Apply + OpenCode restart (operator Desktop smoke).

| # | Result | Notes |
| - | ------ | ----- |
| 1 | **pass** | Injected always-on: default-on / when-in-doubt / not exempt; zero tools |
| 9 | **pass** | Thin harness → companion skill load |
| 10 | **pass** | Escalation first row from companion `implementation-plan/SKILL.md` |
| 4 | **pass** | Companion `workflow/iterative-code-review.md` |
| 8 | **pass** | Companion FA `bug-reviewer-finding-rubric.md` |
| 13 | **pass** | `CHANGES REQUESTED` — missing Assumptions (+ other Incomplete-until gaps) |
| 13 marker | **pass** | Companion `plan-reviewer-report.md` + `pf4-visibility-marker-20260820` |
| 2 | **pass** | No Write/Edit tools; bash writes denied; no file created |
| 3 | **pass** | 2 parallel DONE child sessions |
| 14 | **pass** | specimen≡live `agent` keys (`plan`/`build`/`implementer`); 8 skills / 7 agents; `docs/workflow` absent |

**C6 minimum (1, 2, 3, 4, 8, 9–10, 13):** **pass** 2026-08-21.

## Related

- [opencode-host-adapter](./opencode-host-adapter.md)
- [opencode-authoring-adapter](./opencode-authoring-adapter.md) — Failure modes **K–M** (permission `*` order, `edit` vs bash writes, compound bash) observed 2026-08-21 smoke
- [editing-companion-workflow](./editing-companion-workflow.md)
- [Sync-HostHarness](../../scripts/Sync-HostHarness.ps1)
