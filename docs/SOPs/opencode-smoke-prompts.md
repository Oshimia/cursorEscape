# OpenCode smoke prompts (copy-paste)

**Last updated:** 2026-08-23

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
@(Get-ChildItem C:/Users/admin/.config/opencode/agents -Filter *.md).Count  # expect 8
```

**Pass:** Live `agent.*` keys match specimen harness set; 9 skills / 8 agents; mirror path absent.

---

## Row 15 — composer_conductor visible

**How:** Fresh CLI process or new Desktop session (post-sync). No tools needed.

```text
List the agents you can select or spawn via Task by name.
Is composer_conductor among them? Quote its permission.task allowlist order if visible in your agent config context.
Do not use bash/shell to list ~/.config/opencode.
```

**Pass:** `composer_conductor` present; task map shows `"*": deny` **before** the named allows (failure mode K).  
**Fail:** Agent missing, or `"*"` not first.

---

## Row 16 — Iteration auto-continue (Desktop, nested)

**How:** Desktop restart window; new chat; assign Composer on a small roadmap with one trivial phase.

```text
Act as Composer per the composer skill. Run phase 1 of the roadmap at docs/roadmaps/<small>.md end-to-end:
launch the implementer subagent and let its dual-review pressure-release block run without asking me
to continue between iterations. Report each iteration number as it happens.
```

**Pass:** Block reaches iteration 2+ (dual APPROVED or iteration 4) with **zero** operator "continue" prompts.  
**Fail:** Session pauses between iterations awaiting permission.

---

## Row 17 — Gate B opencode.db audit

**How:** After any nested run (e.g. row 3 or 16). PowerShell against the live DB — read-only.

```powershell
$db = "$env:USERPROFILE/.local/share/opencode/opencode.db"   # adjust if data dir differs
# sqlite3 CLI may be absent on PATH — python fallback works (Observed 2026-08-23):
#   python -c "import sqlite3;c=sqlite3.connect(r'<db>');[print(r) for r in c.execute('SELECT id, parent_id FROM session ORDER BY rowid DESC LIMIT 10')]"
# child sessions: parent_id chain
sqlite3 $db "SELECT id, parent_id, title FROM session ORDER BY id DESC LIMIT 10;"
# tool-part states for a chosen child session id
sqlite3 $db "SELECT message_id, id, type, state FROM part WHERE session_id = '<child-id>' AND type='tool' LIMIT 20;"
# per-message model
sqlite3 $db "SELECT id, model_id FROM message WHERE session_id = '<child-id>';"
```

**Pass:** Queries return a real parent→child chain (`parent_id` non-null linking to the conductor/implementer session), populated tool-parts, and a non-empty `model_id` — evidence the Task actually ran a model stream.  
**Fail:** Missing/broken `parent_id` chain → REJECT closeout claims from that run.

---

## Row 18 — Headless fallback dry-run (CLI)

**How:** Plain PowerShell terminal (not an OpenCode chat). Confirms the top-level-only fallback mechanics.

```powershell
# 1. Scrub env leakage (B4)
Get-ChildItem Env:OPENCODE_* -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item "Env:$($_.Name)" }
# 2. Brief written beforehand with native write tool to: $env:TEMP\opencode\review-brief.md
pwsh -NoProfile -Command "& 'opencode' 'run' 'Read C:/Users/admin/AppData/Local/Temp/opencode/review-brief.md and follow it. Return the verdict line only.'" *> "$env:TEMP\opencode\fallback-stdout.txt"
Get-Content "$env:TEMP\opencode\fallback-stdout.txt"
```

Brief file must be written with the native `write` tool (no bash redirection); CLI prompt stays single-line (B3 argv truncation).  
**Pass:** Single-line invocation accepted; stdout captured contains the brief-driven verdict; no `OPENCODE_*` env leaked into the child; session id recorded.  
**Fail:** Multi-line prompt truncated, brief unread, or stdout lost.

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

## Results log — composer overlay hardening (2026-08-23)

Post–`Sync-HostHarness -Apply -Target OpenCode`; fresh CLI processes (no Desktop restart — rows **16–17** deferred to restart window).

| # | Result | Notes |
| - | ------ | ----- |
| 15 | **pass** | `opencode debug config` merges `composer_conductor`; synced frontmatter task map `"*": deny` first |
| 18 | **pass** | env scrub → native-write brief → single-line `opencode run` → stdout `VERDICT … echo-marker` verbatim; session `ses_fd15702d5ffeJGJ0MlnUttFFFo` (top-level, `parent_id` null) |

## Results log — post-restart rows 16–17 (2026-08-23, DSV4F default model)

Driven fresh-process headless (`opencode run --agent composer_conductor`) after full restart — same agents/sessions the Desktop UI runs.

| # | Result | Notes |
| - | ------ | ----- |
| 16 | **pass** | 2 iterations back-to-back, 4 parallel reviewer launches, zero pauses/prompts. Bonus gate proof: iteration-2 `production_readiness_reviewer` refused a parent-authored "return DONE" pass condition → CHANGES REQUESTED citing missing required inputs (locked-opener contract enforced against its own parent) |
| 17 | **pass** | Gate B audit: conductor `ses_fd1248c71ffegb0LRPrxD1z1xt` → exactly 4 reviewer children (2×prr, 2×br), all `deepseek-v4-flash` assistant streams; python-sqlite3 recipe |

## Related

- [opencode-host-adapter](./opencode-host-adapter.md)
- [opencode-authoring-adapter](./opencode-authoring-adapter.md) — Failure modes **K–M** (permission `*` order, `edit` vs bash writes, compound bash) observed 2026-08-21 smoke
- [editing-companion-workflow](./editing-companion-workflow.md)
- [Sync-HostHarness](../../scripts/Sync-HostHarness.ps1)
