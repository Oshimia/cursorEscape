# OpenCode skill-binding discovery (2026-08)

**Last updated:** 2026-08-19

## Context

Discovery for R0 babysitting from **bash substituted for workflow skills** (failure modes **C** + **E** in [opencode-dsv4f-session-extension-2026-08](./opencode-dsv4f-session-extension-2026-08.md)). Process SoT: [opencode-host-adapter](../docs/SOPs/opencode-host-adapter.md).

**Host pin:** OpenCode Desktop study evidence = **1.18.18**. CLI on this machine reports **1.4.6** — treat CLI vs Desktop as version-skew (**Unknown** whether behavior matches).

Claim labels: **Observed**, **Inferred**, **Unknown**.

---

## Substance

### Hypothesis ranking (post Probe A)

| Rank | Bucket | Hypothesis | Confidence | Evidence |
| ---- | ------ | ---------- | ---------- | -------- |
| 1 | **config** | Missing `permission.skill` allow | Medium (contributing) | Allow alone failed A-post1; keep as load/allow hygiene |
| 1b | **discovery / frontmatter** | Missing frontmatter `name` (+ explicit `skills.paths`) blocked advertisement | **Confirmed High** | A-post2 pass after `name` + `skills.paths` + restart |
| 2 | **harness / plugin** | Desktop or plugin hides global skills | Low (not needed) | Catalog fixed without plugin removal |
| 3 | **model** | Flash bash preference for native tools | **Low for short lookups** (B0′/B0″/C pass); reopen if long live trials regress | Separate from catalog; closed for R0 probes |
| 4 | **contamination** | Long thread caused empty catalog | **Ruled out** | Clean chat reproduced pre-fix fail |

### Harness vs model (public complaints)

#### Harness (OpenCode)

| Source | Symptom | Relevance |
| ------ | ------- | --------- |
| [anomalyco/opencode#7069](https://github.com/anomalyco/opencode/issues/7069) | Skill tool `<available_skills>` empty; agent sees 0 skills | **Direct match** — Probe A saw only built-in |
| Same issue comment | Fix: `"permission": { "skill": { "*": "allow" } }` | Applied; **insufficient alone** (A-post1) |
| `#21793`, `#29727`, `#7084` | `permission.skill` deny/allow exposure bugs | Permission surface is real |
| `#12741` | Skills not visible until **full restart** | Full quit/restart required after skill/config edits |
| [opencode.ai/docs/skills](https://opencode.ai/docs/skills/) | **`name` and `description` required** in frontmatter | **Decisive** — missing `name` matched pre-fix failure |
| [opencode.ai/v2/docs/skills](https://opencode.ai/v2/docs/skills) | Advertise skills with description; permissions; `skills.paths` | Used with official skills doc |

#### Model (DeepSeek / Flash — separate)

| Source | Symptom | Relevance |
| ------ | ------- | --------- |
| Tool-input repair / Pi deepseek-tools | Flash prefers bash; needs selection guidance | Explains **native-tool** babysitting after catalog is fixed — **not** Probe A failure |

**Split (Observed after probes):** Skill-tool catalog emptiness = **missing frontmatter `name` / path registration** (permission allow alone insufficient; contamination ruled out). Shell-for-standard-tools (`read`/`glob`/`grep`) = separate **model/selection** problem.

### Live adapter audit (Observed)

**Before fix:** no `permission.skill`; 7 skills on disk with `description`; CLI `opencode debug skill` → `[]`.

**After fix (2026-08-19, catalog pass):**

- Top-level + `agent.build` / `agent.implementer`: `"permission": { "skill": { "*": "allow" } }`
- `skills.paths` → global skills dir
- Every workflow `SKILL.md` has matching frontmatter `name` + `description`
- Always-on: prefer `skill` tool; do not bash-discover `~/.config/opencode`; prefer read/glob/grep over bash for files

### Recommended package status

1. **Config skill allow** — applied (hygiene; alone insufficient).
2. **Frontmatter `name` + `skills.paths`** — **required** for advertisement (A-post2).
3. **Always-on anti-bash-for-SoT** — applied.
4. **Authoring SOP** — [opencode-authoring-adapter](../docs/SOPs/opencode-authoring-adapter.md).
5. **Never** primary-fix with bash `allow *`.

---

## Probe card — Phase 2

### Shared metadata

| Field | Value |
| ----- | ----- |
| Desktop version | _(operator — study pin 1.18.18)_ |
| Workspace | openBuggy (operator smoke; new empty context) |
| Agent profile/mode | plan (study parity; operator smoke) |
| Model id | _(operator — Flash expected)_ |
| Restart since last config edit | **no** (pre-fix baseline) |
| Timestamp (UTC) | 2026-08-19 (operator report) |
| Did `skill` tool prompt approval? | no / n/a (only listed skill was customize-opencode) |

### Smoke rows

| # | Check | Result |
| - | ----- | ------ |
| 9 | Skill-tool lists workflow skills | **pass** (2026-08-19 A-post2, seven skills) — **C2 author-time (Phase 2):** expected catalog = **8 workflow skills including `roadmap`**: `composer`, `discovery`, `documentation-architecture`, `implementation-plan`, `implementation-review`, `plan-review`, `pre-commit-ci-gate`, **`roadmap`** (+ `customize-opencode` built-in). Re-probe live host after Phase 3 sync. |
| 10 | SoT load without bash approvals | **pass** (2026-08-19 A-post2): loaded `implementation-plan`; quoted Escalation first row |

### Prompt

```text
Without using bash/shell: (1) list every skill the skill tool can load by name;
(2) load skill implementation-plan via the skill tool;
(3) quote the skill’s Escalation when-table first row.
If you cannot see a skill in the skill tool, say so explicitly — do not list ~/.config/opencode with shell.
```

### Arms

| Arm | Setup | Status | Result summary | Classification |
| --- | ----- | ------ | -------------- | -------------- |
| **A** | New empty-context session; skill probe prompt | **done** (pre-fix) | Only `customize-opencode` | discovery/config; not contamination |
| **A-post1** | After `permission.skill` allow only | **fail** | Still only `customize-opencode` | permission alone insufficient |
| **A-post2** | After `name` frontmatter + `skills.paths` + full restart | **pass** | Listed all 7 workflow skills + `customize-opencode`; loaded `implementation-plan`; quoted Escalation first row (`user-labeled-composer`) | **discovery/frontmatter** (+ paths); skill allow may still be needed for load |
| **A-post2b** | Phase 2 overlay adds `roadmap` skill (author-time C2) | **pending** | Expected: 8 workflow skills incl. `roadmap` on live host after Phase 3 sync | catalog expansion |
| **A′** | build/implementer if needed | n/a (A-post2 passed on plan) | | |
| **B0 / B1** | Native file tools (Flash vs stronger) | **card frozen** — awaiting operator | see [Probe card — native file tools](#probe-card--native-file-tools-bash-vs-readglobgrep) |
| **C** | `repository_explorer` child | deferred until B classifies | run only if B0/B1 mixed or inconclusive |

**Phase 2 gate:** Probe A recorded → Phase 3 unblocked.

**Phase 3 status (closed for catalog):**
1. `permission.skill: { "*": "allow" }` — necessary candidate; alone did **not** expose skills.
2. Always-on skill-tool guidance — applied.
3. Frontmatter `name:` on all **8** skills + `skills.paths` — **required for advertisement** on this host (A-post2 pass on 7; `roadmap` added Phase 2 overlay).
4. Smoke 9–10 → **pass** (2026-08-19 A-post2).

**Still open:** bash-for-native-tools selection (model/selection); Probe B card below; Probe C optional after B.

---

## Probe card — native file tools (bash vs read/glob/grep)

**Purpose:** Classify remaining shell-approval babysitting when the task is **repo file lookup**, not skill/SoT load. Catalog fix (A-post2) is in place; always-on already nudges prefer `read`/`glob`/`grep`. This card isolates **model/selection** vs **instruction/harness**.

**Do not** change live adapter mid-probe. **Do not** set `bash: allow *` as the mitigation under test.

### Shared metadata (fill per arm)

| Field | Value |
| ----- | ----- |
| Desktop version | _(operator — study pin 1.18.18)_ |
| Workspace | openBuggy (new **empty** context; do not continue stellar-tiger) |
| Agent profile/mode | plan (parity with Probe A) |
| Model id | **B0:** Flash (`opencode/deepseek-v4-flash-free` or session default used in study). **B1:** stronger model id operator selects (record exact id) |
| Always-on / skills state | Post A-post2 (skill catalog fixed; prefer-native nudge present) |
| Restart since last config edit | yes / no _(prefer yes if any adapter edit since A-post2)_ |
| Timestamp (UTC) | |
| Operator approvals during run | count of shell/bash approval clicks _(primary pain metric)_ |
| Session id (optional) | for later export |

### Logging fields (per arm — record after run)

| Field | How to fill |
| ----- | ----------- |
| `bash` count | Tool calls named bash/shell during the probe turn(s) |
| `read` / `glob` / `grep` counts | Native file tools only |
| First tool used | Name of first tool call |
| Bash used for file content? | yes / no — e.g. `Get-Content`, `type`, `cat`, `rg`/`findstr` via shell |
| Quoted answer correct? | yes / no — Escalation first row matches SoT |
| Shell approvals | Integer (0 = pass bar for babysitting) |
| Notes | Surprises (e.g. used `skill` then read; refused; invented path) |

### Prompt (frozen)

```text
Repo file lookup only — do not use bash/shell and do not load skills.

(1) Using only native file tools (read, glob, and/or grep — not shell), open
    docs/SOPs/opencode-host-adapter.md in this workspace if it exists; otherwise
    say the path is missing.
(2) Quote the smoke checklist row for check #9 exactly (the Check column text
    and the How column text).
(3) In one short sentence, list which native tools you used (names only).

If you cannot complete this without shell, say so explicitly and stop — do not
fall back to bash.
```

**Note:** openBuggy may lack `docs/SOPs/opencode-host-adapter.md` (that path is cursorEscape). If missing, **pass still requires zero bash** and an explicit “path missing” — do not shell-hunt. Optional stricter variant (same arms): open cursorEscape workspace instead so the file exists and (2) is answerable.

### Prompt B″ — undirected (no tool nudges)

Same deliverables; **no** “use native tools / no bash / no skills” language. Run in **cursorEscape**, empty chat, Flash (and optionally B1). Compare tool mix to B0′.

```text
In this workspace:

(1) Open docs/SOPs/opencode-host-adapter.md if it exists; otherwise say the path is missing.
(2) Quote the smoke checklist row for check #9 exactly (the Check column text and the How column text).
(3) In one short sentence, list which tools you used (names only).
```

**Pass / fail (observer scoring — do not put this in the prompt):** same as B0′ — **pass** if zero bash/shell and correct quote when file exists; **fail** if any bash/shell for this task. Model may still pass while “allowed” to choose badly — that is the point.

### Pass / fail

| Result | Criteria |
| ------ | -------- |
| **pass** | Zero bash/shell tool calls; zero shell approvals; answer uses only `read`/`glob`/`grep` (or stops with explicit cannot-without-shell **without** calling bash); if file exists, (2) quote is correct |
| **fail** | Any bash/shell call for this task, or any shell approval click, or silent invent without tools |
| **inconclusive** | Host blocked native tools, or model refused for unrelated reasons |

### Arms

| Arm | Setup | Status | Result summary | Classification |
| --- | ----- | ------ | -------------- | -------------- |
| **B0** | Empty context; Flash; frozen prompt; current always-on | **partial pass** (2026-08-19 operator screenshot) | Two `glob` calls (`docs/SOPs/opencode-host-adapter.md`, `**/opencode-host-adapter.md`); explicit “path is missing”; **no bash** observed. Path-missing branch — expected if workspace ≠ cursorEscape. (2) quote N/A. Shell approvals: _operator confirm 0_. | Tool **selection** OK on absence path; does **not** yet prove Flash prefers native tools when the file **exists** (needs B0′ in cursorEscape) |
| **B0′** | Same as B0 but **cursorEscape** workspace (file exists) | **pass** (2026-08-19 operator screenshot) | One `read` of `opencode-host-adapter.md`; quoted smoke #9 Check+How correctly; tools: `read`; **no bash** observed | Directed prompt + file present → native tools OK on Flash |
| **B0″** | cursorEscape; Flash; **undirected** prompt (no tool nudges; operator further softened step 3 to “explain how… listing anything relevant”) | **pass** (2026-08-19 operator screenshot) | One `read`; correct #9 quote (incl. line 77); explained Read tool; **no bash** | Undirected user text still OK — always-on prefer-native may still apply (see Implications) |
| **B1** | Empty context; **stronger model**; same prompt; same adapter | deferred (optional) | B0′/B0″ already pass on Flash | |
| **C** | Parent Task → `repository_explorer`; parent must not open the file itself | **pass** (2026-08-19) | See Probe C arm below | Child used native glob/grep/read; correct #9 relay; issue **closed** pending further live use |

### Decision tree (after B0 + B1)

| Pattern | Bucket | Next |
| ------- | ------ | ---- |
| B0 fail, B1 pass | **model** | R0 live trial: prefer stronger model for file-heavy work; document Flash bash bias; optional model pin policy — not bash allow-all |
| B0 fail, B1 fail | **instruction / harness** | Strengthen always-on or agent tool guidance; research OpenCode tool-description / permission shaping; still no bash `allow *` as primary fix |
| B0 pass, B1 pass | **regression watch** | Mark smoke row 11 pass on Flash; keep Probe B as occasional recheck |
| Mixed / child differs | **parent vs child** | Run Probe C; compare explorer permissions vs plan agent |

### Optional smoke row (host-adapter)

| # | Check | How | Result |
| - | ----- | --- | ------ |
| 11 | Native file tools without bash approvals | Probe B0′ / B0″ (Flash, cursorEscape) + Probe **C** (`repository_explorer`); **zero** shell approvals | **pass** (2026-08-19); native-tools babysitting **closed** unless reopened by further live use |

---

## Probe C — subagent lookup (`repository_explorer`)

**Purpose:** Final pre-trial check — does the **child** mishandle file lookup (bash babysitting / wrong tools) when the parent is forced to delegate?

**Setup:** cursorEscape; new empty chat; Flash (same as B0″); current always-on; do not edit adapter mid-run.

**Note:** Live `repository_explorer` already says “Prefer read/search tools” and allows some bash (`rg *`, `find *`) without ask — so child may use shell `rg` **without** approval clicks. Still score: Did child use bash? Did operator get shell approvals? Was the quote correct?

### Prompt (frozen) — paste to **parent**

```text
Do not open docs/SOPs/opencode-host-adapter.md yourself (no read/glob/grep/bash on that file from the parent).

Launch OpenCode agent repository_explorer via Task with:
- Workspace root: this repo
- Thoroughness: quick
- Investigation question: Does docs/SOPs/opencode-host-adapter.md exist? If yes, quote the smoke checklist row for check #9 exactly (Check column text and How column text). Return key file paths.

When the child returns, relay: (1) exists or missing; (2) the exact #9 Check and How quotes; (3) one short sentence on how the child achieved it (anything relevant it reported).
```

### Logging (parent + child)

| Field | Fill |
| ----- | ---- |
| Parent used file tools on the SOP? | **no** (Observed — delegated) |
| Task launched `repository_explorer`? | **yes** |
| Child tools (from UI / export) | `glob` ×2 (`docs/SOPs/**/*.md`, `docs/**/opencode-host-adapter.md`); `grep` (smoke/#9 patterns); `read` (`opencode-host-adapter.md` offset 60 limit 40) |
| Child bash? | **no** |
| Shell approvals (operator) | **0** (Inferred from operator close-out; no approval babysitting reported) |
| #9 quote correct? | **yes** (Check + How match host-adapter smoke row 9) |
| Notes | Parent relay also mentioned SOP `_index.md`; UI showed glob→grep→read on the adapter SOP. Issue marked **closed** unless further live use reopens. |

### Pass / fail

| Result | Criteria |
| ------ | -------- |
| **pass** | Parent did not open the file; Task → `repository_explorer`; #9 quote correct; **zero** shell **approval** clicks (child may still use allowlisted `rg`/`find` — note that separately) |
| **fail** | Parent did the lookup itself; wrong/missing Task; wrong quote; shell approvals required |
| **soft fail (note)** | Correct quote but child used bash (`rg`/`find`/other) — document; not the same as approval babysitting |

### Arms

| Arm | Status | Result summary | Classification |
| --- | ------ | -------------- | -------------- |
| **C** | **pass** (2026-08-19 operator report + screenshot) | Child: glob → grep → read; parent relayed exists + exact #9 Check/How; no bash observed | Subagent native-tool path OK on Flash; short lookups closed |

---

## Failure mode F — glob-blind → serial Shell approvals (2026-08-19)

**Observed (stellar-garden / plan_reviewer):** After empty `glob` on `eval/runs/.../**` (path exists but **gitignored**), child fell back to approval-gated `Get-ChildItem` / `Test-Path`. Parent likewise Shell-listed `~/.config/opencode/docs` after absolute `glob` failed, then correctly `read` absolute paths. Approving one Shell often produced another within seconds (serial babysitting).

**Harness (docs):** OpenCode `glob`/`grep` use ripgrep and respect `.gitignore`; use repo [`.ignore`](https://opencode.ai/docs/tools/) to un-ignore (`!eval/runs/`). `external_directory` defaults to ask for paths outside the workspace ([permissions](https://opencode.ai/docs/permissions/)).

**Mitigation package (Applied 2026-08-19; smoke 12 pass):** openBuggy `.ignore`; live `external_directory` allow for `~/.config/opencode/**`; always-on empty-glob ≠ missing + absolute `read`; narrow bash allow `Get-ChildItem*` / `Test-Path*`. Not `bash: allow *`.

### Always-run whitelist audit (Phase 1b)

**Observed 2026-08-19:** table `permission` in `opencode.db` had **0** durable rows. Session “Allow always” may still accumulate in-memory until restart. Prefer **once**; promote intentional patterns into reviewed config. Procedure: [opencode-authoring-adapter](../docs/SOPs/opencode-authoring-adapter.md) § Always-run audit.

### Frozen probes — smoke row 12

**Frozen run path:** `eval/runs/2026-08-17T143458Z-dsv4flash` (openBuggy; exists; gitignored).

**12a — glob runs** — **pass** (2026-08-19 operator): non-empty (`summary.json`, case artifacts under `bb-05-…`, etc.).

**12b — adapter read** — **pass** (2026-08-19): quoted `**Skill:** implementation-plan. **Agent:** plan_reviewer.` via absolute `read` (no Shell list).

**12c — listing allow** — **pass** (2026-08-19): `Test-Path -LiteralPath "…\iterative-plan-review.md"` → `True` (allowlist / no serial Shell ask reported).

Expect: 12a non-empty after `.ignore`; 12b no Shell list; 12c **no** permission prompt after narrow allowlist + restart. **All met.**

---

## Thin-plan smoke (row 13) — Incomplete until / section checklist

**Purpose:** Prove soft Step 2 lists are closed: a thin plan omitting Assumptions/Unknowns must get **CHANGES REQUESTED** from `plan_reviewer` citing those gaps (missing-Inputs urgency). Parent skip of `plan_reviewer` remains residual outside this smoke.

**Setup:** cursorEscape or openBuggy; new empty chat; Flash; after Phase 2 live soft-gate mirror + **full Desktop restart**. Do not edit adapter mid-run.

### Frozen prompt (row 13)

```text
Draft a short non-trivial implementation plan for adding a one-line comment to README only as a pretend multi-file refactor plan.
Omit Assumptions and Unknowns entirely. Include Escalation: no.
Then invoke plan_reviewer on that plan (clean context). Report the verdict and any listed gaps.
Do not implement.
```

**Expect:** Verdict **CHANGES REQUESTED** citing missing Assumptions and/or Unknowns (or Discovery).

**Host-adapter:** smoke checklist row **13**.

**Portable gate self-check (2026-08-19, Cursor `plan_reviewer` / Grok):** intentional thin plan omitting Assumptions/Unknowns → **CHANGES REQUESTED** citing those SoT gaps.

**OpenCode Flash result (2026-08-19 operator):** **pass.** Thin plan (“Refactor” README one-line comment; Escalation no; no Assumptions/Unknowns) → `plan_reviewer` **CHANGES REQUESTED** with blocking findings for missing Assumptions and missing Unknowns/Discovery; explicit “cannot be soft-approved.” Non-blocking notes (Escalation `n/a` label, pretend-vs-scope contradiction, Skip-list awareness) are bonus — gate criterion met by the two always-required section blockers.

---

## Implications / open questions

1. **Catalog root cause (settled):** Missing frontmatter `name` (and/or lack of explicit `skills.paths`) prevented global skills from appearing in the skill tool. `permission.skill` allow alone was **not** enough. Contamination ruled out.
2. Adapter hygiene: follow [opencode-authoring-adapter](../docs/SOPs/opencode-authoring-adapter.md) — every OpenCode `SKILL.md` must include `name` matching folder id + `description`; keep `permission.skill: { "*": "allow" }` and `skills.paths` in live `opencode.json`.
3. **Short native file tools (B0′/B0″/C):** pass on Flash. **Failure mode F** mitigated — smoke **12** pass (2026-08-19): `.ignore` + `external_directory` + narrow listing allow + guidance.
4. Probe B1 remains optional; not required after B0″ + C pass.
5. Durable Always-run DB was empty at audit; re-check after further live trials.
6. **Thin-plan (row 13):** **pass** (2026-08-19 Flash) — CHANGES REQUESTED for missing Assumptions + Unknowns/Discovery; no soft-approve. Portable Cursor self-check also pass earlier same day.

---

## Sources

- Operator Probe A / A-post1 / A-post2 (2026-08-19) — clean chat; catalog fail → permission-only fail → `name`+paths pass
- Operator Probe B0 (2026-08-19) — Flash; two `glob`; path missing; no bash (workspace likely not cursorEscape)
- Operator Probe B0′ / B0″ (2026-08-19) — Flash; cursorEscape; directed + undirected; `read` only; correct #9 quote
- Operator Probe C (2026-08-19) — Flash; Task → `repository_explorer`; child glob/grep/read; parent relay correct #9; native-tools issue closed unless further live use reopens
- Operator Failure F / Phase 1 (2026-08-19) — glob-blind on gitignored `eval/runs` + adapter Shell list; durable `permission` table **0** rows; `.ignore` + external_directory + listing allow applied
- Operator Thin-plan smoke 13 (2026-08-19) — Flash; thin README “pretend refactor” plan omit Assumptions/Unknowns → plan_reviewer CHANGES REQUESTED (SoT blockers); no soft-approve
- [opencode-dsv4f-session-extension-2026-08](./opencode-dsv4f-session-extension-2026-08.md)
- [opencode-host-adapter](../docs/SOPs/opencode-host-adapter.md)
- [opencode-authoring-adapter](../docs/SOPs/opencode-authoring-adapter.md)
- Live adapter edits 2026-08-19 (not committed to cursorEscape)
- [anomalyco/opencode#7069](https://github.com/anomalyco/opencode/issues/7069)
- [opencode.ai/docs/skills](https://opencode.ai/docs/skills/) — required `name` + `description`
- [opencode.ai/v2/docs/skills](https://opencode.ai/v2/docs/skills); [opencode.ai/config.json](https://opencode.ai/config.json)

---

## Related

- [Authoring OpenCode adapter files](../docs/SOPs/opencode-authoring-adapter.md)
- [OpenCode DSV4F session extension](./opencode-dsv4f-session-extension-2026-08.md)
- [OpenCode host adapter SOP](../docs/SOPs/opencode-host-adapter.md)
- [Instruction layering](../docs/featureArchitecture/instruction-layering.md)
- [Analysis index](./_index.md)
