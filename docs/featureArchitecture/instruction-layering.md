# Instruction Layering

**Last updated:** 2026-08-20

## Context

This document is **Target** design for how workflow instructions are **budgeted across layers** — not the plan → implement → dual-review **stages** themselves (those live in [intended-workflow.md](./intended-workflow.md)). It is also distinct from **backend** layering (T3 → OpenCode → provider) in [backend-and-provider-abstraction.md](./backend-and-provider-abstraction.md) and from **repository evidence** discovery in [repository-discovery-and-context.md](./repository-discovery-and-context.md).

**Required** portable intent: keep always-on text minimal; load skills, deep procedure docs, and role agents only when needed. Cursor User Rules, `.mdc` rules, and `disable-model-invocation` are **Cursor-specific** mappings of that intent.

Observed Cursor files under [docs/overlays/cursor](../overlays/cursor/_index.md) illustrate the pattern and some anti-patterns (fat interim extract; thin wrappers in Phase 5). Live `~/.cursor` is the running install; the overlay is the in-repo **Observed** record (not Target procedure). This page is SoT for the portable layering contract. Gold-base contracts are Target inventory ([design decisions](../review/design-decisions.md)).

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

This is a **context-budget** optimization. Loop gate semantics stay in [intended-workflow.md](./intended-workflow.md); role I/O stays in [docs/agents/](../agents/_index.md).

### Layer 1 — Always-on (thin)

**Required:** Always-on text states that plan review and implementation review are **default on** unless truly trivial or the user **explicitly** opts out; includes **When in doubt, run the plan loop**; states that eval/harness/multi-step operational work is **not** exempt; lists the skip-trivial list; and points to skills by name (including [implementation-plan](../skills/implementation-plan.md) for Escalation *when*). It must **not** inline full procedures (plan template, reviewer launch scripts, CI command discovery, Agent context specimens).

**Desired:** Keep always-on *gate* text as small as possible while gate behavior remains reliable. There is **no fixed line budget** — not for the whole always-on file, and not as “≤N new lines” Success/Verification metrics. Measure success by expected gate behavior, not character or line count. Always-on sizing is still being dogfooded; do not invent a numeric budget while that is unsettled. Always-on should cover **workflow gates** only — not operator preference rules (git/PR habits, communication style, frontend taste).

**Observed (Cursor):** Three lean [User Rules snippets](../overlays/cursor/skills/implementation-review/user-rules-snippet.md) (plan review, implementation review, optional composer) plus parallel `alwaysApply` `.mdc` rules that note preferring the snippets for enforcement across Cursor versions. That dual-channel state is an Observed Cursor detail, not a Target requirement. Target hosts should prefer **one** always-on surface when the host allows it.

**Cursor-specific mapping:** Customize → Rules → User Rules; optional `alwaysApply` rules under `~/.cursor/rules/`.

### Escalation *when* ownership (Required)

**Sole SoT** for Escalation *when* triggers: Target [implementation-plan](../skills/implementation-plan.md) (→ `skills/implementation-plan/SKILL.md` after Phase 4). Deep [plan-agent-context](../overlays/cursor/docs/workflow/plan-agent-context.md) (Observed overlay interim) and host mirrors keep **field specimen / required headings only** and must **point to** that skill — no competing “≤3 phases usually no” when-table.

### Layer 2 — Skills (on-demand)

**Required:** Skills are **not** always-injected. Each skill carries a short trigger description, a step outline, and a **Read when** table pointing at deep docs. Full loop essays do not live in the skill entry alone when a deep doc exists.

**Cursor-specific mapping:** `disable-model-invocation: true` on SKILL.md (agent loads via skill tool / explicit read, not ambient injection).

**Positive Observed example:** [documentation-architecture SKILL.md](../overlays/cursor/skills/documentation-architecture/SKILL.md) is a lean entry that points to deep [documentation-architecture.md](../overlays/cursor/docs/workflow/documentation-architecture.md).

Target skill contracts: [docs/skills/](../skills/_index.md) (→ `skills/` after Phase 4).

### Layer 3 — Deep workflow docs

**Required:** Full procedures (`discovery`, `iterative-plan-review`, `iterative-code-review`, `ci-ladder`, `plan-agent-context`, `phased-multi-agent`, etc.) live in companion workflow docs at gold bases (`workflow/` after Phase 3). Load only when a skill or escalated plan says so.

**Example (interim Phases 1–2):** [plan-agent-context.md](../overlays/cursor/docs/workflow/plan-agent-context.md) must **not** be pasted into always-on rules or the plan_reviewer output schema — load only when drafting or reviewing escalated plans. After Phase 3, the same leaf lives under `workflow/plan-agent-context.md`.

Observed interim index: [workflow README](../overlays/cursor/docs/workflow/README.md) (overlay Phases 1–2 only). Host adapters may mirror under a host-local `docs/workflow/` path; **Target** contracts land at gold bases (`workflow/` after Phase 3); **interim** deep procedure: overlay extract Phases 1–2, then `workflow/` Phases 3–4 (→ root after Phase 3).

### Layer 4 — Role agents

**Required:** Agent bodies are **role + I/O + must-not + “load skill X / read doc Y”**. Do **not** paste `iterative-code-review` / `iterative-plan-review` into the agent system prompt. Reviewers run in **isolated** child context; the parent passes what they need.

**Lean SoT (Target):** Gold-base agent contracts — interim [docs/agents/](../agents/_index.md) (e.g. [plan_reviewer.md](../agents/plan_reviewer.md), [production_readiness_reviewer.md](../agents/production_readiness_reviewer.md)); → `agents/` after Phase 4.

**Caution — Observed Cursor agents (interim fat extract):** Overlay files [plan-reviewer.md](../overlays/cursor/agents/plan-reviewer.md) and [reviewer-a.md](../overlays/cursor/agents/reviewer-a.md) embed large procedure bodies. Treat those as **legacy / bloated live Cursor wording**, not the recreation pattern. Phase 5 thin wrappers point at gold `agents/`; overlay fat is not the agent-layer ideal.

### Anti-patterns (Required non-goals)

| Anti-pattern | Why |
| ------------ | --- |
| Full loop essays in always-on | Crowds every turn; gates get lost |
| Inventing a fixed always-on line/character budget (e.g. “≤3 lines”, “≤N new lines”) in plans, Success metrics, Verification, smoke criteria, or adapter SOPs | **Recurring agent failure mode** during dogfood. There is **no** set budget yet; measure by gate behavior. Thin pointers yes; numeric budgets no. |
| Full SKILL.md pasted into agent system prompts | Context bloat; duplicates skill registry |
| Always-injecting skill bodies | Defeats on-demand loading |
| Using Observed bloated agent imports as the agent-layer ideal | Wrong SoT — use Target gold-base `agents/` (interim `docs/agents/`) |
| Conflating this page with repository discovery | Repo evidence ≠ process-instruction layers |
| Re-documenting stage tables from intended-workflow here | Duplicate SoT; drift risk |

### Host recreation mapping

| Layer | Portable surface | Example host hooks |
| ----- | ---------------- | ------------------ |
| Always-on | Thin gate markdown | OpenCode `instructions` / root `AGENTS.md`; Cursor User Rules |
| Skills | On-demand skill entries | OpenCode `skills/*/SKILL.md`; Cursor `~/.cursor/skills/` |
| Host overlay | Additive harness constraints only | [skill-source-and-host-overlays](./skill-source-and-host-overlays.md) — not a second loop |
| Deep docs | Companion workflow docs | Host `docs/workflow/` adapted from contracts |
| Role agents | Named subagents; reviewers deny edit | OpenCode `agents/*.md` with `permission.edit: deny` |

Adapters cite this page and gold-base [agents](../agents/_index.md) / [skills](../skills/_index.md). Do not reverse the SoT (host overlay files are not Target contracts).

### Operator resolutions (2026-08-17; clarified 2026-08-19)

| Former open item | Stance |
| ---------------- | ------ |
| Exact always-on line budget | **None** — not for the whole file, and not as invented “≤N new lines” Success metrics. Minimize while gate behavior holds. Dogfood still discovers the right size; agents must **not** invent a budget in plans or Verification. |
| Ship host snippet files from cursorEscape | **Later** — not a near-term decision ([desired-behavior](./desired-behavior-vs-cursor-specific.md)). |
| Repo-local `alwaysApply: false` → portable on-demand hooks | **Low priority** — validate on a host when needed; not a design blocker. |
| Slim Observed Cursor agent snapshots | **Host-dependent** — keep Target agents lean. Cursor import hygiene is **Observed interim** wording, not a second Target procedure tree. |

---

## Implications / open questions

1. Recreation hosts that paste full review procedures into always-on or agent prompts violate this contract even if loop *stages* look correct.
2. Shipping packaged always-on snippet files from this repo remains a later packaging question — documenting the pattern is enough for now.
3. On-demand policy hooks (e.g. Full-before-commit) now have a Target skill: [pre-commit-ci-gate](../skills/pre-commit-ci-gate.md). Host wiring details can still be validated per host.
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
- [Agent role contracts](../agents/_index.md)
- [Skill contracts](../skills/_index.md)
- [pre-commit-ci-gate](../skills/pre-commit-ci-gate.md)
- [Host recreation study](../analysis/host-recreation-2026-08.md)
- [Design decisions](../review/design-decisions.md)
