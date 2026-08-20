# Pointer-first-4 — smoke closeout

**Last updated:** 2026-08-20  
**Program:** `pointer-first-4`  
**Companion root:** `C:/Users/admin/source/repos/general-projects/cursorEscape`  
**Live OpenCode:** `C:/Users/admin/.config/opencode`  
**Backup (pf2):** `C:/Users/admin/.config/opencode-backup-pointer-first-2-20260820`

**Changeset note:** Pf4 files **staged** for Composer QC commit; **not committed/pushed** this phase.

## Context

Final phase of the companion pointer-first program: attest C6 minimum smoke set, prove companion-edit visibility without mirror copy-out, delete live OpenCode procedure mirror, and close the roadmap.

## Companion-edit proof (author-time)

| Check | Evidence | Result |
| ----- | -------- | ------ |
| Marker in companion SoT | `workflow/plan-reviewer-report.md` line 4: `pf4-visibility-marker-20260820` | **pass** |
| Harness row **4** Target | `overlays/opencode/skills/implementation-review/SKILL.md` Read → `{{COMPANION_ROOT}}/workflow/iterative-code-review.md` | **pass** |
| Harness row **13** Target | `overlays/opencode/agents/plan_reviewer.md` Read → `{{COMPANION_ROOT}}/workflow/plan-reviewer-report.md` **before emit** | **pass** |
| Harness row **8** Target | `overlays/opencode/agents/bug_reviewer.md` Read → `{{COMPANION_ROOT}}/docs/featureArchitecture/bug-reviewer-finding-rubric.md` | **pass** |
| No mirror re-sync required | Marker **not** copied to `OPENCODE_HOME/docs/workflow/` (mirror deleted) | **pass** |

**Runtime companion-edit:** Author-time marker pass; row **13** operator pass (CHANGES REQUESTED bar); marker spot-check **not reported** — Batchable optional.

## Author-time harness SoT greps

```powershell
# Zero file-relative ../../ hops in OpenCode overlay harness
rg '\.\./\.\./(docs|skills|agents)/' overlays/opencode/skills overlays/opencode/agents overlays/opencode/review-subagent-models.md
# Expect: zero

# Zero positive Target load paths to host docs/workflow/ in live harness (exclude Must-not negatives)
rg '\]\([^)]*docs/workflow/' C:/Users/admin/.config/opencode/skills C:/Users/admin/.config/opencode/agents
# Expect: zero

# All harness Read tables use companion absolute paths
rg 'cursorEscape/(workflow|skills|agents|docs/featureArchitecture)' C:/Users/admin/.config/opencode/skills C:/Users/admin/.config/opencode/agents
# Expect: matches on every stub
```

## Mirror disposition

| Host | Action | Notes |
| ---- | ------ | ----- |
| **OpenCode** `docs/workflow/` | **Deleted** (pf4) | 10 legacy mirror leaves removed; backup at `opencode-backup-pointer-first-2-20260820` and Phase 3 `opencode-backup-20260820-153803` |
| **OpenCode** `review-subagent-models` | **Overlay-Read only** | Harness cites `{{COMPANION_ROOT}}/overlays/opencode/review-subagent-models.md` — no host `docs/workflow/` copy |
| **Cursor** `~/.cursor/docs/workflow/` | **Deferred** (operator) | Fat live skills still cite mirror paths; overlay harness is pointer-first; live sync operator-gated per [cursor-host-adapter](../docs/SOPs/cursor-host-adapter.md) |

## Smoke C6 minimum set — honest attestation

| # | Check | Result | Evidence / notes |
| - | ----- | ------ | ---------------- |
| **1** | Always-on gates visible | **pass** (2026-08-20 operator) | Quoted default-on, when-in-doubt, eval/harness not exempt from injected always-on; zero tools |
| **2** | Reviewers cannot edit | **pass** (2026-08-20 operator) | `production_readiness_reviewer` session had no write/edit tool; bash forbidden for file ops; no workspace mutation |
| **3** | Dual Task shape | **pass** (2026-08-20 operator) | Two parallel child sessions (`ses_fe033c227ffemI2lwZ8HOtHiYD`, `ses_fe033bfe9ffe6sfHydv1wI4x7X`); both returned DONE |
| **4** | Skill paths resolve (companion) | **pass** (2026-08-20 operator) | `…/cursorEscape/workflow/iterative-code-review.md`; heading `# Iterative code review (Reviewer A + Bugbot)`; not host mirror |
| **8** | bug_reviewer rubric (companion FA) | **pass** (2026-08-20 operator) | Rubric at `…/cursorEscape/docs/featureArchitecture/bug-reviewer-finding-rubric.md`; not host mirror. (Resolved via companion portable agent relative link — destination SoT correct) |
| **9** | Skill-tool lists 8 workflow skills | **pass** (2026-08-20 operator) | All 8 workflow skills + `customize-opencode` |
| **10** | SoT load without bash | **pass** (2026-08-20 operator) | Thin harness → companion Read Escalation first row |
| **13** | Thin-plan template rejection | **pass** (2026-08-20 operator) | `plan_reviewer` **CHANGES REQUESTED**; blocking: Assumptions missing (+ Alternative approaches / External dependencies must exist with N/A). Marker spot-check **not reported** |

## Install-time row 14 (separate from C6 minimum)

| # | Check | Result | Evidence / notes |
| - | ----- | ------ | ---------------- |
| **14** | Specimen vs live `agent.*` keys | **pass** (install-time) | Phase 3 / pf4 inventory; operator re-diff **not performed** this session (optional) |

## Operator smoke runbook (post-mirror)

Copy each `text` block into OpenCode as written. Score **pass** / **fail** yourself — do not put pass criteria in the prompt.

### Setup (once)

1. Confirm live harness was resynced (backup e.g. `opencode-backup-pre-smoke-20260820-215747`).
2. Confirm `C:/Users/admin/.config/opencode/docs/workflow/` does **not** exist (mirror deleted).
3. **Full quit** OpenCode Desktop (not just close chat) → restart.
4. Prefer workspace **cursorEscape** (`C:/Users/admin/source/repos/general-projects/cursorEscape`) unless a row says otherwise.
5. Prefer **Flash**; **plan** mode for rows that spawn `plan_reviewer` / skill catalog (1, 9–10, 13).
6. **New empty chat** per row (or per group 9+10). Do not edit adapter mid-run.

**Companion root (expect in answers):**  
`C:/Users/admin/source/repos/general-projects/cursorEscape`

**C6 minimum order:** 1 → 9+10 → 4 → 8 → 13 → 2 → 3 → (14 is install-time; optional re-diff).

---

### Row 1 — Always-on gates (C1)

**How:** New chat. Paste prompt. Do **not** approve any tools if asked — tools = fail.

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

### Rows 9 + 10 — Skill catalog + SoT load (Probe A, pointer-first)

**How:** New chat; plan mode; Flash. One prompt covers both rows.

**Pointer-first expectation:** The skill tool returns the **thin host harness** (no full Escalation when-table pasted). Quoting the when-table **requires** `read` of companion  
`C:/Users/admin/source/repos/general-projects/cursorEscape/skills/implementation-plan/SKILL.md`  
That companion Read is **pass**, not a harness defect.

```text
Without using bash/shell:
(1) list every skill the skill tool can load by name;
(2) load skill implementation-plan via the skill tool;
(3) the host harness is thin — if the Escalation when-table is not in the skill-tool payload, read the companion absolute path the harness points to (under cursorEscape/skills/implementation-plan/SKILL.md) and quote the Escalation when-table first data row;
(4) report the absolute path you used for (3).

If you cannot see a skill in the skill tool, say so explicitly — do not list ~/.config/opencode with shell.
```

**Pass (row 9):** Skill names include all **8** workflow skills: `composer`, `discovery`, `documentation-architecture`, `implementation-plan`, `implementation-review`, `plan-review`, `pre-commit-ci-gate`, `roadmap` (built-in `customize-opencode` may also appear).  
**Pass (row 10):** Skill tool loaded `implementation-plan`; Escalation first row quoted from **companion** skill SoT (e.g. `yes + user-labeled-composer` / User says composer-level…); path under `cursorEscape/skills/…`; **zero** bash approvals used to discover/list the adapter. Native `read` of companion is allowed and expected.  
**Fail:** Only `customize-opencode`; Shell-lists `~/.config/opencode` to find skills; bash used as the SoT discovery path; quotes when-table from a re-hydrated host mirror under `docs/workflow/`.

---

### Row 4 — Companion workflow Read (C4) + companion-edit path

**How:** New chat. Paste prompt. Allow skill load + `read` of companion paths; deny bash used only to hunt the adapter.

```text
Load skill implementation-review via the skill tool (no bash to discover skills).

Then, using only read/glob/grep (no bash): open the workflow doc that skill says to Read for the review loop (iterative-code-review).

Report:
(1) the exact absolute path you opened;
(2) the first heading of that file;
(3) whether that path is under the companion repo cursorEscape/workflow/ or under ~/.config/opencode/docs/workflow/.

Do not invent a path — if Read fails, say so and stop.
```

**Pass:** Path is  
`C:/Users/admin/source/repos/general-projects/cursorEscape/workflow/iterative-code-review.md`  
(or equivalent under companion `workflow/`). **Not** `OPENCODE_HOME/docs/workflow/…`.  
**Fail:** Host mirror path; `../../docs/workflow` resolution; path missing because mirror deleted and companion Read never attempted.

---

### Row 8 — bug_reviewer rubric (companion FA)

**How:** New chat. Paste prompt. Allow agent/Task + `read` of companion FA.

```text
Open the OpenCode agent harness for bug_reviewer (live or via agent tool) and find the rubric Read path.

Using only read (no bash): open that rubric file.

Report:
(1) the exact absolute path you opened;
(2) the document title / first heading;
(3) confirm it is under cursorEscape/docs/featureArchitecture/ — not under ~/.config/opencode/docs/workflow/.

Do not invent a path — if Read fails, say so and stop.
```

**Pass:**  
`C:/Users/admin/source/repos/general-projects/cursorEscape/docs/featureArchitecture/bug-reviewer-finding-rubric.md`  
**Fail:** Host `docs/workflow/bug-reviewer-finding-rubric.md` or missing file with no companion attempt.

---

### Row 13 — Thin-plan rejection + companion report schema / marker

**How:** New chat; Flash; plan mode OK. Paste prompt. Allow `plan_reviewer` Task.

```text
Draft a short non-trivial implementation plan for adding a one-line comment to README only as a pretend multi-file refactor plan.
Omit Assumptions and Unknowns entirely. Include Escalation: no.
Then invoke plan_reviewer on that plan (clean context). Report the verdict and any listed gaps.
Do not implement.
```

**Pass:** Verdict **CHANGES REQUESTED** citing missing Assumptions and/or Unknowns (or Discovery). Soft-approve = fail.

**Companion-edit / schema spot-check (same chat or follow-up):** after the verdict, paste:

```text
Without implementing: which absolute file defines the plan_reviewer Output format / report sections you used?
Quote any visibility marker string near the top of that file if present.
Do not use ~/.config/opencode/docs/workflow/ — mirror is deleted.
```

**Pass (spot-check):** Companion  
`…/cursorEscape/workflow/plan-reviewer-report.md`  
and optional quote of `pf4-visibility-marker-20260820`.  
**Fail:** Host mirror path; marker absent when file was Read from companion (re-check companion file still has the marker).

---

### Row 2 — Reviewers cannot edit

**How:** New chat. Paste prompt. Approve Task if asked; watch for write denial / ask-block.

```text
Launch OpenCode agent production_readiness_reviewer via Task with a trivial review task on this repo.
In that child session, attempt to create or edit a file under the workspace (e.g. write a one-line tmp-smoke-reviewer.txt).
Report whether the write was denied, ask-blocked, or succeeded.
Parent: do not perform the write yourself.
```

**Pass:** Write denied or ask-blocked on the reviewer agent.  
**Fail:** Reviewer successfully writes without operator override of permissions.

---

### Row 3 — Dual Task shape

**How:** New chat. Paste prompt. Operator may use “return done” if host refuses empty review without a changeset.

```text
In one turn, launch two parallel Tasks:
(1) production_readiness_reviewer — Completion gate: review-loop — task: return the single word DONE without reviewing code.
(2) bug_reviewer — Completion gate: review-loop — Custom Instructions: phase=smoke-row-3; iteration=1; return the single word DONE without reviewing code.

Report: how many child sessions started (expect 2), or document sequential fallback if the host refused parallel.
Do not implement product changes.
```

**Pass:** Two child sessions (or documented sequential fallback with both roles invoked).  
**Fail:** Only one reviewer ever launched; silent skip.

---

### Row 14 — Specimen vs live `agent.*` keys (install-time; optional re-check)

**How:** PowerShell in companion repo (not an OpenCode chat prompt).

```powershell
$specimen = Get-Content overlays/opencode/opencode.specimen.json -Raw | ConvertFrom-Json
$live = Get-Content C:/Users/admin/.config/opencode/opencode.json -Raw | ConvertFrom-Json
# Compare agent.* key names (adjust if schema nests under .agent)
$specimen.agent.PSObject.Properties.Name | Sort-Object
$live.agent.PSObject.Properties.Name | Sort-Object
Test-Path C:/Users/admin/.config/opencode/docs/workflow   # expect False
@(Get-ChildItem C:/Users/admin/.config/opencode/skills -Directory).Count  # expect 8
@(Get-ChildItem C:/Users/admin/.config/opencode/agents -Filter *.md).Count  # expect 7
```

**Pass:** Live `agent.*` keys still match specimen harness set; 8 skills / 7 agents; mirror path absent.  
**Already:** install-time **pass** Phase 3 / pf4 — re-run only if you suspect config drift after resync.

---

### Results log (fill while running)

| # | Result | Notes / session |
| - | ------ | --------------- |
| 1 | **pass** | Injected always-on quotes (default-on / when-in-doubt / not exempt) |
| 9 | **pass** | 8 workflow skills + customize-opencode |
| 10 | **pass** | Thin harness → companion Read Escalation first row (`yes + user-labeled-composer`) |
| 4 | **pass** | Companion `workflow/iterative-code-review.md` |
| 8 | **pass** | Companion FA rubric (via portable agent relative → absolute FA) |
| 13 | **pass** | CHANGES REQUESTED — Assumptions (+ Alts/External deps section presence) |
| 13 marker | **not reported** | Optional; re-run spot-check prompt if desired |
| 2 | **pass** | No write tool on reviewer; no mutation |
| 3 | **pass** | Two parallel DONE sessions |
| 14 | pass (install); re-check **skipped** | |

Canonical frozen sources (if wording drifts): [skill-binding discovery](./opencode-skill-binding-discovery-2026-08.md) (rows 1, 9–10, 13); [host-adapter smoke table](../docs/SOPs/opencode-host-adapter.md) (rows 2–3, 4, 8, 14).

## Implications

- **C6 minimum smoke (rows 1, 2, 3, 4, 8, 9–10, 13):** **pass** 2026-08-20 operator (post-mirror, post-resync). **Row 14:** install-time pass retained (Phase 3 / pf4 inventory; live re-diff **skipped** this session). Companion-edit **marker** spot-check on row 13 **not reported** — optional follow-up only.
- Cursor live `~/.cursor` fat skills remain transitional; overlay author-time is pointer-first (pf3).
- Composer next: dual APPROVED renew → Composer commit pointer-first-4 (staged).

## Related

- [pointer-first roadmap](../docs/roadmaps/pointer-first.md)
- [OpenCode host adapter](../docs/SOPs/opencode-host-adapter.md)
- [Cursor host adapter](../docs/SOPs/cursor-host-adapter.md)
- [OpenCode overlay copy-out map](../overlays/opencode/_index.md)
