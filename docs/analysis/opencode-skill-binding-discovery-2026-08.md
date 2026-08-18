# OpenCode skill-binding discovery (2026-08)

**Last updated:** 2026-08-19

## Context

Discovery for R0 babysitting from **bash substituted for workflow skills** (failure modes **C** + **E** in [opencode-dsv4f-session-extension-2026-08](./opencode-dsv4f-session-extension-2026-08.md)). Process SoT: [opencode-host-adapter](../SOPs/opencode-host-adapter.md).

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
| 3 | **model** | Flash bash preference for native tools | Medium — **still open** | Separate from catalog |
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
4. **Authoring SOP** — [opencode-authoring-adapter](../SOPs/opencode-authoring-adapter.md).
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
| 9 | Skill-tool lists workflow skills | **pass** (2026-08-19 A-post2): composer, discovery, documentation-architecture, implementation-plan, implementation-review, plan-review, pre-commit-ci-gate (+ customize-opencode) |
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
| **A′** | build/implementer if needed | n/a (A-post2 passed on plan) | | |
| **B** | Stronger model | deferred | | |
| **C** | `repository_explorer` child | deferred | | |

**Phase 2 gate:** Probe A recorded → Phase 3 unblocked.

**Phase 3 status (closed for catalog):**
1. `permission.skill: { "*": "allow" }` — necessary candidate; alone did **not** expose skills.
2. Always-on skill-tool guidance — applied.
3. Frontmatter `name:` on all 7 skills + `skills.paths` — **required for advertisement** on this host (A-post2 pass).
4. Smoke 9–10 → **pass** (2026-08-19 A-post2).

**Still open:** bash-for-native-tools selection (model/selection); Probes B/C optional.

---

## Implications / open questions

1. **Catalog root cause (settled):** Missing frontmatter `name` (and/or lack of explicit `skills.paths`) prevented global skills from appearing in the skill tool. `permission.skill` allow alone was **not** enough. Contamination ruled out.
2. Adapter hygiene: follow [opencode-authoring-adapter](../SOPs/opencode-authoring-adapter.md) — every OpenCode `SKILL.md` must include `name` matching folder id + `description`; keep `permission.skill: { "*": "allow" }` and `skills.paths` in live `opencode.json`.
3. Bash-for-native-tools (`read`/`glob`/`grep`) remains open — Probe B optional; always-on already nudges prefer native tools.
4. B/C still useful for model/subagent isolation; not required for smoke 9–10.

---

## Sources

- Operator Probe A / A-post1 / A-post2 (2026-08-19) — clean chat; catalog fail → permission-only fail → `name`+paths pass
- [opencode-dsv4f-session-extension-2026-08](./opencode-dsv4f-session-extension-2026-08.md)
- [opencode-host-adapter](../SOPs/opencode-host-adapter.md)
- [opencode-authoring-adapter](../SOPs/opencode-authoring-adapter.md)
- Live adapter edits 2026-08-19 (not committed to cursorEscape)
- [anomalyco/opencode#7069](https://github.com/anomalyco/opencode/issues/7069)
- [opencode.ai/docs/skills](https://opencode.ai/docs/skills/) — required `name` + `description`
- [opencode.ai/v2/docs/skills](https://opencode.ai/v2/docs/skills); [opencode.ai/config.json](https://opencode.ai/config.json)

---

## Related

- [Authoring OpenCode adapter files](../SOPs/opencode-authoring-adapter.md)
- [OpenCode DSV4F session extension](./opencode-dsv4f-session-extension-2026-08.md)
- [OpenCode host adapter SOP](../SOPs/opencode-host-adapter.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md)
- [Analysis index](./_index.md)
