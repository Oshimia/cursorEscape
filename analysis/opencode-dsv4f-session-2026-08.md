# OpenCode DSV4F session study (2026-08)

**Last updated:** 2026-08-19

## Context

Operator study of one OpenCode Desktop session that ran a limited openBuggy eval pilot (`bb-01`–`bb-05`) with **DeepSeek V4 Flash (free)** as parent and, after a host-config fix, as `bug_reviewer` model. This is a **decision-grade study of local workflow / host recreation**, not an eval scoring write-up and not proposed engine design.

Eval numbers and promote-audit detail live in the sibling openBuggy archive under `docs/analysis/DSV4F/`. This page extracts what matters for **cursorEscape R0**: instruction-layer reliability and automatic plan/review loop enforcement on OpenCode.

Claim labels: **Observed** (session export, logs, operator report), **Inferred** (interpretation), **Unknown** (not settled here).

---

## Substance

### Session facts (Observed)

| Field | Value |
| ----- | ----- |
| Session id | `ses_fefe26e1affe5MSTIrlBnkyD0B` (slug `stellar-tiger`) |
| Host | OpenCode Desktop **1.18.18** |
| Parent model | `opencode/deepseek-v4-flash-free` |
| Workspace | Sibling repo `openBuggy` (`C:\Users\admin\source\repos\general-projects\openBuggy`) |
| Ask | Run first five eval cases via `bug_reviewer`, compare to baseline `2026-08-04T2225Z`, use DeepSeek V4 Flash (free) as bugfinder |
| Export | openBuggy `docs/analysis/DSV4F/opencode-session/` (JSON, markdown, meta, antigravity-hits extract) |
| Scale (approx.) | ~232 messages, ~1030 parts, large cache-read totals; multiple context compactions |

### Failure mode A — Antigravity dependence (historical / resolved)

**Observed:** The first five parallel `bug_reviewer` Tasks completed in ~250ms with empty `task_result`. Logs showed `providerID=google` / `modelID=antigravity-claude-sonnet-4-6` and `AI_LoadAPIKeyError` (no Google Generative AI API key). The parent session was already on DeepSeek.

**Observed (host behavior):**

- Subagent model came from agent / cached config, not from the parent session model.
- Editing the agent markdown did **not** hot-reload; a restart was required.
- A Task `model` parameter was accepted in the call but **ignored** at resolve time (still Antigravity).
- Desktop UI showed empty Tasks as normal “completed”; the strongest operator tell was **how fast they closed**.

**Operator resolution (Observed, post-session):** Antigravity leftover removed entirely. Subsequent tests show subagents normally spawn with the **same model as the parent**. Do not re-investigate Antigravity as a live blocker.

**Keep as historical signature:** reviewer Task finishes in well under ~1s with empty result → treat as routing/auth failure, not “no bugs found.”

### Failure mode B — missing automatic review loops (lasting)

**Observed:** After orientation, the parent drove straight into harness setup (bootstrap, isolate, quarantine, envelopes, Task launches, scoring/docs). It did **not** load or enforce the OpenCode-adapted plan-review / implementation-review gate skills for that work. Later, when a protocol-update plan needed `plan_reviewer`, the gate failed for the (then still live) Antigravity routing issue — but the earlier gap was **skipping the loop entirely**, not only broken reviewer models.

**Target context:** Always-on text is thin **gate pointers**; skills and deep docs are **on-demand** ([instruction layering](../docs/featureArchitecture/instruction-layering.md)). Plan → dual review → closeout is **Required default on** unless truly trivial or the user **explicitly** opts out — eval/harness/multi-step operational work is **not** exempt ([intended workflow](../docs/featureArchitecture/intended-workflow.md), [opencode-host-adapter](../docs/SOPs/opencode-host-adapter.md)). On OpenCode, Fast CI and dual-gate discipline remain **parent skill discipline**, not host-enforced ([host recreation](./host-recreation-2026-08.md)).

**Inferred:** Global adapter files (`instructions/`, skills, agents under `~/.config/opencode/`) existed but were **not sufficiently binding** for this parent + task shape: cheap free parent, eval/harness-shaped ask, weak gate salience relative to “get the run done.”

**cursorEscape analytical focus (this study):** How to make **global instruction surfaces** more reliable so automatic loops fire without the operator babysitting — always-on wording, skill triggers, and when gates must apply even to eval-like or “just run it” asks. **This document does not prescribe the fix.**

```text
User ask (eval / implement)
        │
        ▼
   Parent agent
   ┌────┴────┐
   │         │
   ▼         ▼
Always-on   On-demand skills
(should     (should load when
 bind)       matched)
   │         │
   └────┬────┘
        │
   Target Required: plan gate → dual review Tasks
        │
   Observed often: direct harness work (gates skipped)
```

### What worked (Observed)

- **DeepSeek V4 Flash as parent:** Operator judgment — worked reasonably well for a cheap free-tier test; more complex work will likely use a stronger parent.
- **After model fix:** Isolated TEMP workspaces, label quarantine, parallel `bug_reviewer` Tasks on DeepSeek, contamination audit (reconstructed from permission logs because OpenCode lacked Cursor-style JSONL transcripts), promote-audit with no label promotion, and DSV4F analysis docs completed in openBuggy.
- **Isolation discipline:** Review-window tool paths stayed under isolated TEMP roots (Observed in local opencode permission log / DSV4F run-report).

### Reviewer eagerness signal (Observed, secondary)

Limited pilot net **−1.0** vs baseline first-five **+8.0** (precision loss; recall still 7/9 expecteds). FPs concentrated on clean / nit / copy themes (especially bb-03). Full match graph: openBuggy `docs/analysis/DSV4F/run-report.md`.

**Operator note:** Useful demonstration of an **overly eager** bugfinder. `bug_reviewer` skill/prompt instructions *can* be tightened later (nits, out-of-scope, pre-existing vs introduced). That is a **separate workstream** from cursorEscape loop reliability; no mitigation backlog here.

### Empty-Task UX (Observed)

Empty “completed” Tasks looked normal in the UI. Primary failure indicator was **close speed**. R0 smoke now records this as fail-loud guidance (SOP smoke row 6) — treat sub-~1s empty reviewer Tasks as routing/auth failure until logs show a real model stream.

---

## Implications / open questions

1. How should always-on vs on-demand skill triggers be strengthened so eval-like and “get on with it” tasks still hit plan / dual-review gates on OpenCode?
2. What live probe proves gates fired (see [opencode-host-adapter](../docs/SOPs/opencode-host-adapter.md) smoke row 1 — quote default-on plan loop + when-in-doubt + eval/harness not exempt; requires OpenCode restart after adapter edits)?
3. Keep **bugfinder nit/scope** tuning (openBuggy DSV4F mitigations) separate from **cursorEscape instruction-layer / loop reliability** work — Target finding rubric now lives at [bug-reviewer-finding-rubric](../docs/featureArchitecture/bug-reviewer-finding-rubric.md) (M5 copy-recall still deferred).
4. Historical Antigravity signature remains useful for smoke even though the plugin/path is removed.
5. Post-harness continuation of this session (skill-tool binding, babysat iterative plan passes, desktop model-selection pins) is documented in [session extension study](./opencode-dsv4f-session-extension-2026-08.md).

---

## Sources

- openBuggy `docs/analysis/DSV4F/` — `_index.md`, `run-report.md`, `mitigations.md`, `opencode-session/` export for `ses_fefe26e1affe5MSTIrlBnkyD0B`
- Operator clarifications (2026-08-18) — Antigravity resolved; lasting failure = missing automatic loops; Flash parent “reasonably well”; empty-Task UX; eager bugfinder as useful signal
- Local opencode permission / stream logs cited in DSV4F run-report (not re-verified in this pass)

---

## Related

- [OpenCode DSV4F session extension (2026-08)](./opencode-dsv4f-session-extension-2026-08.md)
- [Host recreation (2026-08)](./host-recreation-2026-08.md)
- [OpenCode host adapter SOP](../docs/SOPs/opencode-host-adapter.md)
- [Instruction layering](../docs/featureArchitecture/instruction-layering.md)
- [Intended workflow](../docs/featureArchitecture/intended-workflow.md)
- [bug-reviewer-finding-rubric](../docs/featureArchitecture/bug-reviewer-finding-rubric.md)
- [Analysis index](./_index.md)
