# Authoring OpenCode adapter files (skills, agents, rules, config)

**Last updated:** 2026-08-19

## Context

How to write and maintain the **OpenCode host adapter** under `~/.config/opencode/` (and optional project `.opencode/`) so skills, agents, always-on instructions, and permissions actually load. Portable **contracts** stay in cursorEscape ([agents](../agents/_index.md), [skills](../skills/_index.md), [instruction-layering](../featureArchitecture/instruction-layering.md)); this SOP is the **authoring checklist** for the OpenCode mirror.

**Install root (this machine):** `C:\Users\admin\.config\opencode\`

**Process SoT for inventory / smoke:** [opencode-host-adapter](./opencode-host-adapter.md)  
**Evidence for skill-catalog failures:** [opencode-skill-binding-discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md)

Official OpenCode documentation (read before inventing local conventions):

| Topic | Official docs |
| ----- | ------------- |
| Skills | [Agent Skills](https://opencode.ai/docs/skills/) · [v2 skills](https://opencode.ai/v2/docs/skills) |
| Agents | [Agents](https://opencode.ai/docs/agents/) |
| Rules / AGENTS.md / instructions | [Rules](https://opencode.ai/docs/rules/) |
| Config | [Config](https://opencode.ai/docs/config/) · [schema](https://opencode.ai/config.json) |
| Permissions | Covered under [Agents → Permissions](https://opencode.ai/docs/agents/#permissions) and [Skills → Configure permissions](https://opencode.ai/docs/skills/#configure-permissions) |

---

## Substance

### Sync rule (cursorEscape first)

Same as [opencode-host-adapter](./opencode-host-adapter.md):

1. Update **cursorEscape** Target contracts / this SOP first when semantics change.
2. Re-adapt files under `~/.config/opencode/` second — do not invent gate semantics only on the host.
3. Do **not** commit `~/.config/opencode` into this git repo.
4. After any change to `opencode.json`, skills, agents, instructions, or other config-time files: **fully quit and restart OpenCode** (Desktop: quit tray/process, not only a new chat). No hot-reload — Observed DSV4F / skill-binding discovery.

---

### Layer map (what to author where)

| Layer | Purpose | Typical paths | Always injected? |
| ----- | ------- | ------------- | ---------------- |
| **Rules** | Project/personal standing instructions | Project `AGENTS.md`; global `~/.config/opencode/AGENTS.md`; optional `CLAUDE.md` fallbacks | Yes (per [Rules](https://opencode.ai/docs/rules/) precedence) |
| **Instructions** | Extra markdown pulled in via config | Paths/globs/URLs in `opencode.json` → `instructions` | Yes (combined with AGENTS.md) |
| **Skills** | On-demand SoT procedures | `~/.config/opencode/skills/<id>/SKILL.md`; project `.opencode/skills/…` | **No** — advertised via `skill` tool, body loaded on call |
| **Agents** | Primary / subagent roles | `~/.config/opencode/agents/*.md` and/or `opencode.json` → `agent` | Role prompt when selected / Task-invoked |
| **Deep docs** | Full procedures | `~/.config/opencode/docs/workflow/*.md` | No — load when a skill/agent says to `read` |

Keep always-on / AGENTS / instructions **thin** (gate pointers). Put full loops in skills + deep docs — [instruction-layering](../featureArchitecture/instruction-layering.md). Always-on edits: short gate pointers only; **do not invent** fixed line/character budgets (“≤3 lines”, “≤N new lines”) in plans, Success, Verification, or this SOP — measure by gate behavior ([instruction-layering](../featureArchitecture/instruction-layering.md) Anti-patterns).

### Hard gates vs soft lists (audit log)

Soft-spot audit from 2026-08-19 dogfood; status after this harden pass:

| Target | Soft spot (pre-harden) | Status |
| ------ | ---------------------- | ------ |
| implementation-plan | Advisory Step 2 section list | **done 2026-08-19** — Incomplete until SoT |
| plan-review / plan_reviewer / planner | APPROVED / handoff without section bar | **done 2026-08-19** |
| always-on | No incompleteness pointer | **done 2026-08-19** — short gate pointer (no line budget) |
| implementer | No phase Incomplete until | **done 2026-08-19** |
| instruction-layering (+ this SOP) | Agents invent ≤N always-on budgets | **done 2026-08-19** — forbid invented budgets |
| implementation-review dual “when possible” | Soft | **LOW — defer** |
| composer QC | Soft | **LOW — defer** |
| discovery / documentation-architecture / explorers / test_reviewer / dual-reviewers / pre-commit | Prefer or already hard | **skip** |

Single section-checklist SoT: [implementation-plan](../skills/implementation-plan.md) **Incomplete until**. `plan-review` / `plan_reviewer` point at that SoT — do not paste a second full enum.

---

### Skills (required checklist)

Follow [OpenCode Agent Skills](https://opencode.ai/docs/skills/) exactly. Observed dogfood (2026-08-19): skills with **description only** and **no `name`** did **not** appear in the skill tool (only built-in `customize-opencode` showed) until `name` was added and `skills.paths` was set — see [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md).

#### Layout

```text
~/.config/opencode/skills/<skill-id>/SKILL.md
```

- Folder name = skill id.
- File name must be exactly `SKILL.md` (all caps).
- Prefer directory form (supports relative references beside the skill).

Also searched by OpenCode (see official discovery list): `.opencode/skills/`, `.claude/skills/`, `.agents/skills/` (project + global variants).

#### Frontmatter (required fields)

Every `SKILL.md` **must** start with YAML frontmatter including:

| Field | Required | Rules |
| ----- | -------- | ----- |
| `name` | **Yes** | 1–64 chars; `^[a-z0-9]+(-[a-z0-9]+)*$`; **must match the directory name** |
| `description` | **Yes** | 1–1024 chars; specific enough for model choice; third person (“Use when…”) |
| `license` | No | Optional |
| `compatibility` | No | Optional |
| `metadata` | No | Optional string→string map (v2 also documents `metadata.opencode/autoinvoke: false` to omit from model advertisement while keeping the skill registered) |

**Do not** ship skills with only `description` and no `name` on this host.

Example:

```markdown
---
name: implementation-plan
description: >-
  Draft structured implementation plans. Default on unless truly trivial or
  explicit user opt-out. Escalation when-table SoT. Then invoke plan_reviewer.
---

# Implementation plan
…
```

#### Permissions for skills

From [Skills → Configure permissions](https://opencode.ai/docs/skills/#configure-permissions):

```json
{
  "permission": {
    "skill": {
      "*": "allow",
      "internal-*": "deny",
      "experimental-*": "ask"
    }
  }
}
```

| Effect | Behavior |
| ------ | -------- |
| `allow` | Skill can load (and is advertised if frontmatter valid) |
| `deny` | Hidden / rejected |
| `ask` | Advertised; approval on load |

**This adapter:** keep global (and parent agents’) `"skill": { "*": "allow" }` so workflow skills are not filtered after discovery. **Observed:** allow alone does **not** fix missing `name` / unscanned paths.

Per-agent overrides: agent markdown frontmatter `permission.skill` or `opencode.json` → `agent.<id>.permission.skill` ([docs](https://opencode.ai/docs/skills/#override-per-agent)).

Disable skill tool entirely: `tools.skill: false` on an agent ([docs](https://opencode.ai/docs/skills/#disable-the-skill-tool)) — then `<available_skills>` is omitted. Do **not** set this on parents that must load workflow skills.

#### Explicit skill paths

Schema supports additional scan roots:

```json
{
  "skills": {
    "paths": ["C:/Users/admin/.config/opencode/skills"]
  }
}
```

Use when default discovery is unreliable; still keep files under a standard `skills/<id>/SKILL.md` tree. Relative paths resolve from the **active working directory**, not necessarily the config file directory ([v2 docs](https://opencode.ai/v2/docs/skills)).

#### How the model loads a skill

OpenCode advertises permitted skills (name + description) on the **`skill` tool**. The agent calls:

```text
skill({ name: "implementation-plan" })
```

([Recognize tool description](https://opencode.ai/docs/skills/#recognize-tool-description).)

**Authoring implication:** always-on text should say “load skill `<id>` via the skill tool,” not “bash-list `~/.config/opencode`.” Prefer native `read` / `glob` / `grep` for repo files; reserve bash for real commands.

#### Skill authoring vs cursorEscape contracts

| In cursorEscape | On OpenCode adapter |
| --------------- | ------------------- |
| `docs/skills/<id>.md` (portable contract) | `skills/<id>/SKILL.md` (host entry + frontmatter) |
| Deep procedure in FA / imported workflow docs | Mirror under `docs/workflow/` and **Read when** from the skill |

Do not paste full iterative-plan / dual-review essays into always-on instructions.

#### Troubleshoot skills (official + Observed)

Official ([Troubleshoot loading](https://opencode.ai/docs/skills/#troubleshoot-loading)):

1. `SKILL.md` spelled in all caps  
2. Frontmatter includes **`name` and `description`**  
3. Names unique across locations  
4. Permissions not `deny`  

Additional Observed (this machine, Desktop ~1.18.18):

5. Fully restart OpenCode after edits  
6. Confirm `skills.paths` / install root if catalog still empty  
7. CLI `opencode debug skill` may differ from Desktop version — treat version skew as Unknown  
8. Some plugins (e.g. oh-my-opencode) have hidden user skills while built-ins remain — disable plugin to test  
9. Smoke: [opencode-host-adapter](./opencode-host-adapter.md) rows **9–10**

---

### Agents

Follow [OpenCode Agents](https://opencode.ai/docs/agents/).

#### Types

| Type | Role | Examples |
| ---- | ---- | -------- |
| Primary | Main chat (Tab cycle) | `build`, `plan`, custom primaries |
| Subagent | Task / `@` mention | `explore`, `general`, `plan_reviewer`, `bug_reviewer`, … |

#### Markdown agents (preferred for this adapter)

Place under `~/.config/opencode/agents/<agent-name>.md` (or project `.opencode/agents/`). File name = agent name.

Required / important frontmatter ([docs](https://opencode.ai/docs/agents/#options)):

- `description` — required for discovery / when to use  
- `mode` — `primary` \| `subagent` \| `all`  
- `permission` — prefer over deprecated `tools`  
- `temperature`, `color`, `hidden`, etc. as needed  

**cursorEscape adapter rules:**

- Reviewers / plan_reviewer: `permission.edit: deny`; bash mostly `ask` with narrow git allowlists  
- Do **not** pin provider-specific `model:` on reviewers — inherit session default ([host adapter](./opencode-host-adapter.md))  
- Do **not** use Cursor type names (`bugbot`, `reviewer-a`) as runtime agent ids  
- Body = role + I/O + must-not + “load skill X / read doc Y” — not full loop essays  

JSON agents under `opencode.json` → `agent` are also valid ([docs](https://opencode.ai/docs/agents/#json)); keep Task allowlists on `build` / `implementer` (`permission.task`).

#### Task permissions

`permission.task` with globs controls which subagents a parent may spawn ([docs](https://opencode.ai/docs/agents/#task-permissions)). Denied agents are removed from the Task tool description.

---

### Rules and always-on instructions

Follow [OpenCode Rules](https://opencode.ai/docs/rules/).

#### AGENTS.md (rules)

| Location | Scope |
| -------- | ----- |
| Project `AGENTS.md` | That repo (and subdirs) |
| `~/.config/opencode/AGENTS.md` | Personal global |
| `CLAUDE.md` / `~/.claude/CLAUDE.md` | Fallbacks if AGENTS.md absent |

Precedence: local walk-up → global OpenCode AGENTS → Claude fallback ([docs](https://opencode.ai/docs/rules/#precedence)).

Use for project facts and personal prefs — **not** for full plan/review procedures.

#### `instructions` in `opencode.json`

```json
{
  "instructions": [
    "instructions/cursor-escape-loop.md",
    "docs/guidelines.md"
  ]
}
```

Paths, globs, and remote URLs are supported ([docs](https://opencode.ai/docs/rules/#custom-instructions)). Combined with AGENTS.md.

**This adapter:** thin gate file `instructions/cursor-escape-loop.md` — default-on plan/dual-review pointers; plan **Incomplete until** / template-fidelity pointer (load skill `implementation-plan` for the list; no invented line budgets); skill ids; prefer skill tool; prefer read/glob/grep over bash for files; empty-Task fail-loud.

---

### Config and permissions (summary)

Schema: [https://opencode.ai/config.json](https://opencode.ai/config.json) · guide: [Config](https://opencode.ai/docs/config/).

Minimum skill-related hooks for this adapter:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["instructions/cursor-escape-loop.md"],
  "permission": {
    "skill": { "*": "allow" }
  },
  "skills": {
    "paths": ["C:/Users/admin/.config/opencode/skills"]
  },
  "agent": {
    "build": {
      "permission": {
        "skill": { "*": "allow" },
        "task": { "*": "deny", "plan_reviewer": "allow", "bug_reviewer": "allow" }
      }
    }
  }
}
```

(Extend `task` allowlists to match [host adapter inventory](./opencode-host-adapter.md).)

Permission keys include `read`, `edit`, `bash`, `task`, `skill`, `external_directory`, etc. ([Agents → Permissions](https://opencode.ai/docs/agents/#permissions); [Permissions](https://opencode.ai/docs/permissions/)). Prefer pattern objects with `"*"` first, then specific overrides (last matching rule wins).

**Glob / gitignore:** `glob`/`grep` use ripgrep and respect `.gitignore`. To let agents see gitignored trees (e.g. openBuggy `eval/runs/`), add a repo-root [`.ignore`](https://opencode.ai/docs/tools/) with un-ignore lines such as `!eval/runs/`. Do not track those trees in git solely for agent convenience.

**Out-of-workspace adapter paths:** `external_directory` defaults to **ask**. For this host, allow `~/.config/opencode/**` (and absolute Windows form if needed) so native `read`/`glob` can reach global workflow docs without Shell listing. Prefer `edit: deny` under that tree if configuring edit rules.

**Narrow listing bash allow (safety net only):** when models still fall back after empty glob, allow only `Get-ChildItem*` and `Test-Path*` (keep `bash: "*": ask`). Do **not** set `bash: allow *`. Skip `dir`/`ls` unless probes prove `Get-ChildItem*` alone fails. Do not allowlist `python -c *` by default.

**Do not** “fix” skill babysitting by setting parent bash to `allow *` as the primary mitigation.

#### Always-run / durable permission audit

UI **Allow always** may persist project-scoped rows (v2: durable) in SQLite `%USERPROFILE%\.local\share\opencode\opencode.db` table `permission` (`project_id`, `action`, `resource`). Session-only Always clears on Desktop restart.

**Procedure (re-run when click-fatigue accumulates):**

1. Inventory: `SELECT p.action, p.resource, pr.worktree FROM permission p JOIN project pr ON pr.id = p.project_id` (read-only).
2. Classify: keep & promote to reviewed `opencode.json` / agent bash → revoke junk (esp. `resource=*`, destructive, obsolete) → narrow broad patterns.
3. Prefer approving **once** unless promoting a pattern into config SoT.
4. After revokes or config edits: full Desktop restart; re-count rows (lean table).

**Observed 2026-08-19:** durable `permission` table had **0** rows on this host at audit time — session Always and intentional config are the live surfaces. Re-audit after dogfood if the table grows.

---

### Verification after authoring

1. Frontmatter: every skill has matching `name` + `description`.  
2. `opencode.json` validates against schema (starts without crash).  
3. **Full restart** OpenCode.  
4. Clean-chat Probe A (from [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md)): skill tool lists workflow ids; load `implementation-plan`; quote Escalation row.  
5. Update [host adapter](./opencode-host-adapter.md) smoke rows 4–5 / 9–10 as appropriate.  
6. If Target semantics changed, update cursorEscape contracts in the **same** doc change set ([documenting-this-repo](./documenting-this-repo.md)).

---

## Implications / open questions

1. Skill-tool catalog emptiness is usually **authoring/discovery** (`name`, paths, restart, permissions) — not native tool failure and not session contamination.  
2. Bash-for-`read`/`glob`/`grep` on short prompts was OK in Probe B/C; residual babysitting is often **glob-blind** (gitignore / external_directory) — see Failure mode F in [skill-binding discovery](../../analysis/opencode-skill-binding-discovery-2026-08.md).  
3. Re-check this SOP when OpenCode Desktop major versions change schema (nested `permission` vs v2 `permissions[]`). Periodically audit durable Always-run rows (`opencode.db` `permission`).

---

## Sources

- [OpenCode Agent Skills](https://opencode.ai/docs/skills/)
- [OpenCode Skills (v2)](https://opencode.ai/v2/docs/skills)
- [OpenCode Agents](https://opencode.ai/docs/agents/)
- [OpenCode Rules](https://opencode.ai/docs/rules/)
- [OpenCode Config](https://opencode.ai/docs/config/)
- [opencode.ai/config.json](https://opencode.ai/config.json)
- [opencode-skill-binding-discovery-2026-08](../../analysis/opencode-skill-binding-discovery-2026-08.md) — Observed `name` / `skills.paths` / permission allow sequence

---

## Related

- [OpenCode host adapter](./opencode-host-adapter.md)
- [Documenting this repo](./documenting-this-repo.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md)
- [Skill contracts](../skills/_index.md)
- [Agent contracts](../agents/_index.md)
- [SOPs index](./_index.md)
