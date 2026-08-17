> **Imported research** — Source: live `~/.cursor`; copied 2026-08-17 into cursorEscape. Status: Observed/imported (live canonical for Target workflow). Do not treat as Target cursorEscape design unless a Target doc cites it.
# Plan Agent context (escalated plans)

**Skills:** [implementation-plan](../../skills/implementation-plan/SKILL.md), [roadmap](../../skills/roadmap/SKILL.md), [composer](../../skills/composer/SKILL.md).  
**Agent:** [plan-reviewer](../../agents/plan-reviewer.md).

Use when a plan’s **Escalation** section sets `Agent context required: **yes**`. Typical ≤3-phase work stays on the light Incremental execution template (`Agent context required: **no**`).

Do **not** paste this specimen into always-on rules or the plan-reviewer output schema. Load it when drafting or reviewing escalated plans only.

For a real multi-phase specimen in a product repo, read Accounts `docs/roadmaps/large-file-modularization.md` on demand — do not inline it here.

---

## Escalation field (every non-trivial plan)

Place **immediately after Scope**:

```markdown
### Escalation
- Agent context required: **yes** | **no**
- Reason: `user-labeled-composer` | `complex-or-extensive` | `n/a`
```

| Value | When |
|-------|------|
| **yes** + `user-labeled-composer` | User says composer-level, or asks Composer to **plan** |
| **yes** + `complex-or-extensive` | Planner judges unusually hard / extensive (≤3 phases usually **no**; not a hard cap) |
| **no** + `n/a` | Default light plan — do **not** write Agent context blocks |

If unsure whether to escalate: AskQuestion; do not silently set **yes**.

---

## Required sections when Escalation is **yes**

Beyond the standard [implementation-plan](../../skills/implementation-plan/SKILL.md) template:

1. **Inter-phase contracts** — signatures, behavior matrices, metadata keys, deploy units, shared files (extend-only). **N/A** allowed for a single-phase escalated plan.
2. **Migration / external apply order** — when the repo has user-apply gates; otherwise state none.
3. **Agent context — Phase N** — for **every** execution phase (see headings below).

### Agent context — Phase N (required headings)

For each execution phase, use this block (heading text must be recognizable to plan-reviewer / Composer):

```markdown
#### Agent context — Phase N
- **Goal:** …
- **Depends on / entry gate:** …
- **Do not touch:** …
- **In scope:** …
- **Out of scope:** …
- **Files expected:** …
- **Where to read context:** …
- **Fast CI:** …
- **Full CI:** …
- **Deliverables:**
  - [ ] …
- **Risks:** …
```

---

## Dummy example (~15 lines)

```markdown
### Escalation
- Agent context required: **yes**
- Reason: `complex-or-extensive`

### Inter-phase contracts
- Shared extend-only: `docs/roadmaps/example.md` status checklist

#### Agent context — Phase 1
- **Goal:** Add mode detection without starting the worker.
- **Depends on / entry gate:** Phase 0 docs landed.
- **Do not touch:** `server/`, production Drive DB.
- **In scope:** `config_sync.py`; tests for mutual exclusion.
- **Out of scope:** FastAPI; Sheets on VPS.
- **Files expected:** `config_sync.py`, `tests/test_sync_mode.py`.
- **Where to read context:** this plan; `docs/dev-sync.md`.
- **Fast CI:** `python -m pytest tests/test_sync_mode.py -q`
- **Full CI:** `python -m pytest -q`
- **Deliverables:**
  - [ ] HQ + sync markers fatal; dual APPROVED; Full pass
- **Risks:** Dual writers if HQ still starts sync_manager.
```

---

## After user accepts (roadmap dual path)

| Escalation | Roadmap skill |
|------------|---------------|
| **yes** | **Copy** Agent context (and contracts) from the accepted plan. Fail-closed if missing or stub. Never invent scope. |
| **no** | Optional roadmap for Composer later: **may restructure** thin Incremental execution bullets into Agent context headings **without adding new scope**. |

See [phased-multi-agent.md](phased-multi-agent.md) and [roadmap](../../skills/roadmap/SKILL.md).

## Related

- [phased-multi-agent.md](phased-multi-agent.md)
- [iterative-plan-review.md](iterative-plan-review.md)
- [README.md](README.md)
