# OpenCode host adapter

**Last updated:** 2026-08-17

## Context

This SOP documents the **global OpenCode adapter** installed on the operator machine for R0 dogfood of the cursorEscape loop. Contracts remain in this repo ([agents](../agents/_index.md), [skills](../skills/_index.md), [instruction-layering](../featureArchitecture/instruction-layering.md), [clean-context-isolation](../featureArchitecture/clean-context-isolation.md)). Files under `~/.config/opencode/` are the **host adapter**, not a second SoT.

**Install root (this machine):** `C:\Users\admin\.config\opencode\`

---

## Substance

### Layer map

| Layer | Portable contract | OpenCode adapter path |
| ----- | ----------------- | --------------------- |
| Always-on (thin) | Gate pointers only | `instructions/cursor-escape-loop.md` (wired via `opencode.json` → `instructions`) |
| Skills (on-demand) | [docs/skills/](../skills/_index.md) | `skills/*/SKILL.md` |
| Deep workflow docs | Imported/adapted procedures | `docs/workflow/*.md` |
| Role agents | [docs/agents/](../agents/_index.md) | `agents/*.md` (`permission.edit: deny` on reviewers) |

### Inventory

**Always-on**

- `instructions/cursor-escape-loop.md`

**Skills**

- `discovery`, `implementation-plan`, `plan-review`, `implementation-review`, `pre-commit-ci-gate`, `composer`, `documentation-architecture`

**Agents**

- `planner`, `plan_reviewer`, `implementer` (primary), `production_readiness_reviewer`, `bug_reviewer`, `repository_explorer`, `test_reviewer` (optional; Task permission `ask`)

**Deep docs**

- `docs/workflow/` — discovery, iterative-plan-review, iterative-code-review, ci-ladder, plan-agent-context, phased-multi-agent, review-subagent-models, documentation-architecture, README

**Config hooks**

- `opencode.json` — `instructions` array; `agent.build` / `agent.implementer` `permission.task` allowlists for named roles

### Sync rule

1. Update **cursorEscape** contracts first (Target FA / agents / skills).
2. Re-adapt OpenCode files second — do not invent gate semantics only in `~/.config/opencode`.
3. Do **not** commit `~/.config/opencode` into this git repo (secrets, machine paths, provider plugins).

### Dual review on OpenCode

- **One** OpenCode session; **two** Task children (`production_readiness_reviewer` ∥ `bug_reviewer`).
- Not two T3 worktrees.
- Parent owns Observed Fast CI; reviewers `edit: deny`.
- Split envelope: locked opener on production_readiness; Custom Instructions on bug_reviewer.

### Smoke checklist (R0)

Record results when dogfooding. Expected: pass or explicit note.

| # | Check | How | Result |
| - | ----- | --- | ------ |
| 1 | Always-on gates visible | New session; ask model to quote Fast-CI-before-reviewers rule from always-on | _pending_ |
| 2 | Reviewers cannot edit | `@production_readiness_reviewer` or Task: attempt a write → denied / ask-blocked | _pending_ |
| 3 | Dual Task shape | Instruct parent to launch both reviewers in one turn → two child sessions (or document sequential fallback) | _pending_ |
| 4 | Skill paths resolve | Load skill `implementation-review`; confirm `../../docs/workflow/iterative-code-review.md` exists on disk | **pass** (2026-08-17 install check: all skill/workflow paths present) |
| 5 | Config parses | `opencode` starts with current `opencode.json` (no schema crash) | **pass** (2026-08-17: `opencode.json` JSON-parses; live TUI start still operator-confirm) |

**Fast verification (install-time):**

```text
agents/: planner, plan_reviewer, implementer, production_readiness_reviewer, bug_reviewer, repository_explorer, test_reviewer
skills/: discovery, implementation-plan, plan-review, implementation-review, pre-commit-ci-gate, composer, documentation-architecture
docs/workflow/: present
instructions/cursor-escape-loop.md: present
```

Grep agents for required Cursor type names `bugbot` / `reviewer-a` as runtime IDs — should be absent (role names only).

---

## Implications / open questions

1. Smoke rows 1–3 need a live OpenCode session — mark pass/fail when run.
2. Do **not** pin provider-specific models in agent frontmatter — roles inherit the session / `opencode.json` default so the adapter stays portable across BYOK hosts.
3. T3 Code control plane is separate — this SOP covers the OpenCode harness adapter only.

---

## Related

- [Host recreation study](../analysis/host-recreation-2026-08.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md)
- [Clean context and isolation](../featureArchitecture/clean-context-isolation.md)
- [Agent contracts](../agents/_index.md)
- [Skill contracts](../skills/_index.md)
- [Documenting this repo](./documenting-this-repo.md)
