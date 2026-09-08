# Instruction Layering

**Last updated:** 2026-09-08

## Context

This document is **Target** design for how workflow instructions are **budgeted across layers** — not the plan → implement → dual-review **stages** themselves (those live in [intended-workflow.md](./intended-workflow.md)). It is also distinct from **backend** layering (T3 → OpenCode → provider) in [backend-and-provider-abstraction.md](./backend-and-provider-abstraction.md) and from **repository evidence** discovery in [repository-discovery-and-context.md](./repository-discovery-and-context.md).

**Required** portable intent: keep always-on text minimal; load skills, deep procedure docs, and role agents only when needed. Cursor User Rules, `.mdc` rules, and `disable-model-invocation` are **Cursor-specific** mappings of that intent.

Observed Cursor files under [overlays/cursor](../../overlays/cursor/_index.md) illustrate the pattern (**thin wrappers**). Live `~/.cursor` is the running install; the overlay is the in-repo copy-out map (not Target procedure). This page is SoT for the portable layering contract. repo-root contracts are Target inventory ([design decisions](../../review/design-decisions.md)).

---

## Substance

### Why layer instructions

Agents that always carry full plan/review procedures waste context and dilute gates. The owner's Cursor setup separates:

| Layer | What belongs | When loaded |
| ----- | ------------ | ----------- |
| **Always-on (thin)** | When to plan / dual-review; skip-trivial list; “load skill X” pointers | Every turn |
| **Skills (on-demand)** | Triggers, step outline, **Read when** links into deep docs | When the skill matches the task |
| **Deep workflow docs** | Full procedures, specimens, CI ladder detail | When a skill (or escalated plan) says to read them |
| **Role agents** | Purpose, inputs, outputs, must-not, “load skill / read doc Y” | Isolated child session for that role |

This is a **context-budget** optimization. Loop gate semantics stay in [intended-workflow.md](./intended-workflow.md); role I/O stays in [agents/_index.md](../../agents/_index.md).

### Layer 1 — Always-on (thin)

**Required:** Always-on text states that plan review and implementation review are **default on** unless truly trivial or the user **explicitly** opts out; includes **When in doubt, run the plan loop**; states that eval/harness/multi-step operational work is **not** exempt; lists the skip-trivial list; and points to skills by name (including [implementation-plan/SKILL.md](../../skills/implementation-plan/SKILL.md) for Escalation *when*). It must **not** inline full procedures (plan template, reviewer launch scripts, CI command discovery, Agent context specimens).

**Desired:** Keep always-on *gate* text as small as possible while gate behavior remains reliable. There is **no fixed line budget** — not for the whole always-on file, and not as “≤N new lines” Success/Verification metrics. Measure success by expected gate behavior, not character or line count. Always-on sizing is still being validated in practice; do not invent a numeric budget while that is unsettled. Always-on should cover **workflow gates** only — not operator preference rules (git/PR habits, communication style, frontend taste).

**Observed (Cursor):** Three lean [User Rules snippets](../../overlays/cursor/skills/implementation-review/user-rules-snippet.md) (plan review, implementation review, optional composer) plus parallel `alwaysApply` `.mdc` rules that note preferring the snippets for enforcement across Cursor versions. That dual-channel state is an Observed Cursor detail, not a Target requirement. Target hosts should prefer **one** always-on surface when the host allows it.

**Cursor-specific mapping:** Customize → Rules → User Rules; optional `alwaysApply` rules under `~/.cursor/rules/`.

**Codex mapping (registered, BringUp only):** one marker-bounded managed block in `CODEX_HOME/AGENTS.md` is the thin always-on gate; wrappers under the independent skill root stay on-demand; seven TOML role agents point back at companion SoT. The two `opencode-*` tooling wrappers are explicit-only by overlay policy. Runtime injection is not attested in Phase 3.

### Escalation *when* ownership (Required)

**Sole SoT** for Escalation *when* triggers: [implementation-plan/SKILL.md](../../skills/implementation-plan/SKILL.md). Deep [plan-agent-context](../../workflow/plan-agent-context.md) and host mirrors keep **field specimen / required headings only** and must **point to** that skill — no competing “≤3 phases usually no” when-table.

### Layer 2 — Skills (on-demand)

**Required:** Skills are **not** always-injected. Each skill carries a short trigger description, a step outline, and a **Read when** table pointing at deep docs. Full loop essays do not live in the skill entry alone when a deep doc exists.

**Cursor-specific mapping:** `disable-model-invocation: true` on SKILL.md (agent loads via skill tool / explicit read, not ambient injection).

**Positive layering pattern (Target):** Lean skill entry at `skills/*/SKILL.md` → deep doc at repo-root [`workflow/`](../../workflow/_index.md). **Cursor overlay:** thin wrapper SKILLs add spawn blocks + Read tables pointing at repo-root bases and `workflow/` ([documentation-architecture.md](../../workflow/documentation-architecture.md) example).

Target skill contracts: [skills/_index.md](../../skills/_index.md).

### Layer 3 — Deep workflow docs

**Required:** Full procedures (`discovery`, `iterative-plan-review`, `iterative-code-review`, `ci-ladder`, `plan-agent-context`, `plan-reviewer-report`, `phased-multi-agent`, etc.) live in companion workflow docs at repo-root bases ([`workflow/`](../../workflow/_index.md)). Load only when a skill or escalated plan says so.

**Required (pointer-first):** Host adapters must **not** rely on a host `docs/workflow/` procedure mirror as SoT. Thin harness skills and agents **Read** absolute companion paths — e.g. `{{COMPANION_ROOT}}/workflow/<leaf>.md` (example: `C:/Users/admin/source/repos/general-projects/cursorEscape/workflow/iterative-code-review.md`). A mirrored copy under host `docs/workflow/` (if still present from [opencode-overlays-sot](../roadmaps/opencode-overlays-sot.md) Phase 3) is **transitional** only; [pointer-first](../roadmaps/pointer-first.md) supersedes mirror-as-load-path. Rubric stays companion FA + absolute Read (`{{COMPANION_ROOT}}/docs/featureArchitecture/bug-reviewer-finding-rubric.md`).

**Example:** [plan-agent-context.md](../../workflow/plan-agent-context.md) must **not** be pasted into always-on rules — load only when drafting or reviewing escalated plans. [plan-reviewer-report.md](../../workflow/plan-reviewer-report.md) is the on-demand L3 SoT for plan-reviewer output limits, severity ranking, overflow lines, and exact report structure — load via agent/skill Read when, not into always-on or skill bodies.

Workflow index: [workflow/_index.md](../../workflow/_index.md). **Target** contracts land at repo-root `workflow/`; host mirror is not a second authored procedure tree.

### Layer 4 — Role agents

**Required:** Agent bodies are **role + I/O + must-not + “load skill X / read doc Y”**. Do **not** paste `iterative-code-review` / `iterative-plan-review` into the agent system prompt. Reviewers run in **isolated** child context; the parent passes what they need.

**Lean SoT (Target):** repo-root agent contracts — [agents/_index.md](../../agents/_index.md) (e.g. [plan_reviewer.md](../../agents/plan_reviewer.md), [production_readiness_reviewer.md](../../agents/production_readiness_reviewer.md)).

**Cursor overlay agents:** [plan-reviewer.md](../../overlays/cursor/agents/plan-reviewer.md) and [reviewer-a.md](../../overlays/cursor/agents/reviewer-a.md) are **thin wrappers** (Cursor name + spawn one-pager + Read → `agents/`). Do not paste full loop procedure into overlay agent files.

### Anti-patterns (Required non-goals)

| Anti-pattern | Why |
| ------------ | --- |
| Full loop essays in always-on | Crowds every turn; gates get lost |
| Inventing a fixed always-on line/character budget (e.g. “≤3 lines”, “≤N new lines”) in plans, Success metrics, Verification, smoke criteria, or adapter SOPs | **Recurring agent failure mode** during live trials. There is **no** set budget yet; measure by gate behavior. Thin pointers yes; numeric budgets no. |
| Full SKILL.md pasted into agent system prompts | Context bloat; duplicates skill registry |
| Always-injecting skill bodies | Defeats on-demand loading |
| Using Observed bloated agent imports as the agent-layer ideal | Wrong SoT — use Target repo-root `agents/` |
| Conflating this page with repository discovery | Repo evidence ≠ process-instruction layers |
| Re-documenting stage tables from intended-workflow here | Duplicate SoT; drift risk |

### Host recreation mapping

| Layer | Portable surface | Example host hooks |
| ----- | ---------------- | ------------------ |
| Always-on | Thin gate markdown | OpenCode `instructions` / root `AGENTS.md`; Cursor User Rules; Codex managed `AGENTS.md` block |
| Skills | On-demand skill entries | OpenCode `skills/*/SKILL.md`; Cursor `~/.cursor/skills/`; Codex independent-root `SKILL.md` wrappers |
| Host overlay | Additive harness constraints only | [skill-source-and-host-overlays](./skill-source-and-host-overlays.md) — not a second loop |
| Deep docs | Companion workflow docs at `{{COMPANION_ROOT}}/workflow/` | Absolute Read from thin harness; legacy host `docs/workflow/` mirror transitional only ([pointer-first](../roadmaps/pointer-first.md)) |
| Role agents | Named subagents; reviewers deny edit | OpenCode `agents/*.md` with `permission.edit: deny`; Codex read-only-sandbox TOML agents |

Adapters cite this page and [agents/_index.md](../../agents/_index.md) / [skills/_index.md](../../skills/_index.md). Do not reverse the SoT (host overlay files are not Target contracts).

### Operator resolutions (2026-08-17; clarified 2026-08-19)

| Former open item | Stance |
| ---------------- | ------ |
| Exact always-on line budget | **None** — not for the whole file, and not as invented “≤N new lines” Success metrics. Minimize while gate behavior holds. Live use still discovers the right size; agents must **not** invent a budget in plans or Verification. |
| Ship host snippet files from cursorEscape | **Later** — not a near-term decision ([desired-behavior](./desired-behavior-vs-cursor-specific.md)). |
| Repo-local `alwaysApply: false` → portable on-demand hooks | **Low priority** — validate on a host when needed; not a design blocker. |
| Slim Observed Cursor agent snapshots | **Host-dependent** — keep Target agents lean. Cursor import hygiene is **Observed interim** wording, not a second Target procedure tree. |

---

## Implications / open questions

1. Recreation hosts that paste full review procedures into always-on or agent prompts violate this contract even if loop *stages* look correct.
2. Shipping packaged always-on snippet files from this repo remains a later packaging question — documenting the pattern is enough for now.
3. On-demand policy hooks (e.g. Full-before-commit) now have a Target rule: [pre-commit-ci-gate.md](../../rules/pre-commit-ci-gate.md). Host wiring details can still be validated per host.
4. Extra host restrictiveness (OpenCode anti-bash, deny-edit) belongs in overlays, not always-on shared contracts — [skill-source-and-host-overlays](./skill-source-and-host-overlays.md).

---

## Related

- [Intended workflow](./intended-workflow.md) — loop stages and dual-gate semantics
- [Clean context and isolation](./clean-context-isolation.md) — isolation honesty (not token budget)
- [Desired behavior vs Cursor-specific](./desired-behavior-vs-cursor-specific.md)
- [Cursor behavior to reproduce](./cursor-behavior-to-reproduce.md)
- [Repository discovery and context](./repository-discovery-and-context.md) — repo evidence, not instruction layers
- [Backend and provider abstraction](./backend-and-provider-abstraction.md) — different “layering”
- [Skill source and host overlays](./skill-source-and-host-overlays.md) — host axis of the instruction budget
- [Codex overlay](../../overlays/codex/_index.md) — registered source-only BringUp mapping
- [Agent role contracts](../../agents/_index.md)
- [Skill contracts](../../skills/_index.md)
- [pre-commit-ci-gate](../../rules/pre-commit-ci-gate.md)
- [Host recreation study](../../analysis/host-recreation-2026-08.md)
- [Design decisions](../../review/design-decisions.md)
- [Companion pointer-first](../roadmaps/pointer-first.md)
