# OpenCode DSV4F session extension study (2026-08)

**Last updated:** 2026-08-19

## Context

Follow-on operator study of the **same** OpenCode Desktop session (`ses_fefe26e1affe5MSTIrlBnkyD0B`, slug `stellar-tiger`) after it continued past the first-five DSV4F harness work covered in [opencode-dsv4f-session-2026-08](./opencode-dsv4f-session-2026-08.md). Same host/model/workspace. Still a **decision-grade study of local workflow / host recreation** for **cursorEscape R0** (instruction-layer reliability and automatic plan/review loop enforcement) — not eval scoring and not proposed engine design.

This page focuses on the **post-harness** slice: protocol planning, empty `plan_reviewer` Tasks, desktop model-selection diagnosis, Antigravity-removal smoke, and the contamination-audit plan that eventually completed a 3-pass gate only after operator babysitting.

**Operator primary pain (clarification 2026-08-19):** constant babysitting — not only “continue the plan loop,” but **shell-approval churn**. Bash was used instead of OpenCode skills throughout; each shell call needed user review, so the operator had to touch the thread roughly every **2–3 minutes**. Failure modes **C** and **E** below are that mechanism and its UX cost.

Claim labels: **Observed** (session export / live DB / operator report), **Inferred** (interpretation), **Unknown** (not settled here).

---

## Substance

### Handoff from study 1

| Study 1 | This extension |
| ------- | -------------- |
| **A** Antigravity empty `bug_reviewer` (~250 ms) | **A′** Same empty-fast signature on `plan_reviewer` (~284–309 ms); refined root as desktop `workspace:model-selection` pins; resolved by operator; smoke confirms DeepSeek |
| **B** Gates skipped on harness / “get the run done” | **B′** Even after an **explicit** plan + iterative-review ask, the multi-pass loop still needed operator prompts to start and continue |
| (weakly inferred skill binding) | **C** Skill-tool catalog/binding failure — Observed; drives bash substitution |
| (not covered) | **D** Transcript / DB opacity; earlier wrong “no subagent store” claim |
| (not covered) | **E** Shell-approval babysitting — operator’s largest live-session cost |

### Session facts (Observed)

| Field | Value |
| ----- | ----- |
| Session id | `ses_fefe26e1affe5MSTIrlBnkyD0B` (slug `stellar-tiger`) |
| Host | OpenCode Desktop **1.18.18** |
| Parent model | `opencode/deepseek-v4-flash-free` (agent mode `plan` for later slice) |
| Workspace | Sibling repo `openBuggy` |
| Export | openBuggy `docs/analysis/DSV4F/opencode-session/` — re-exported 2026-08-18 (~18:07Z) after exporter ID-join fix |
| Scale | **276** messages, **1223** parts (was ~232 / ~1030 in study 1); large cache-read totals; compactions including mid plan-review loop |
| Tool mix (full session) | **`bash` 160**, `read` 86, `task` 24, … **`skill` 3** (all `customize-opencode`: [38], [185], [211]) — ~49% of tool calls were bash |

### Failure mode A′ — empty `plan_reviewer` via desktop model pin (historical / resolved)

**Observed:** After the user asked to use the planning skill and iterative review ([184]), the parent spawned a `planner` Task then three `plan_reviewer` Tasks ([189]–[191]). Each `plan_reviewer` completed in **~284–309 ms** with **empty** `task_result`, metadata `google` / `antigravity-claude-sonnet-4-6` — same empty-fast signature as study 1’s `bug_reviewer` failures.

**Observed (refined host behavior):** Parent diagnosis ([212]): Desktop persists per-session overrides under `AppData\Roaming\ai.opencode.desktop\…opencode.workspace….dat` → `workspace:model-selection`, pinning specific `plan_reviewer` child sessions to Antigravity even when agent markdown had no `model:` field. Operator later removed Antigravity reliance.

**Observed (smoke after fix):** User [232] asked for a default-model subagent test. Explore + `plan_reviewer` resolved to `opencode/deepseek-v4-flash-free`; test review ~6.5 s with non-empty result ([234]). Parent reported the gate “should work now” ([235]) but **did not** auto-re-run the deferred protocol-plan gate.

**Keep:** sub-~1s empty reviewer Task → routing/auth failure, not “plan is fine.”

### Failure mode B′ — iterative loop still operator-babysat (lasting)

**Observed sequence:**

1. User [184] explicitly required planning skill + iterative review.
2. Parent attempted `planner` + `plan_reviewer` (better than pure harness skip in study 1), but the gate failed empty (A′).
3. After model smoke ([235]), parent offered to re-run the deferred gate later — did not self-start it.
4. On the contamination-audit ask ([236]), parent researched and **presented a full plan** ([258]) **without** invoking `plan_reviewer` until the user said “Review the plan please” ([259]).
5. Pass 1 returned CHANGES REQUESTED ([260], ~19 min, non-empty DeepSeek). Parent revised, then after the user asked what the iterative plan-review skill requires ([263]), correctly restated max-3 clean-context rules ([266]–[267]) — and **asked permission** for pass 2 instead of auto-continuing.
6. User “Please continue” ([268]) → passes 2–3 ([269], [271]) → APPROVED. Compaction ([273]) then host “Continue…” ([274]) mid closeout.

**Target context (unchanged):** Plan → iterative `plan_reviewer` is **Required default on** unless truly trivial or **explicit** opt-out; eval/harness/multi-step is not exempt ([intended workflow](../featureArchitecture/intended-workflow.md), [opencode-host-adapter](../SOPs/opencode-host-adapter.md)). On OpenCode this remains **parent skill discipline**.

**Inferred:** Salient user wording and even correctly quoted skill text are not enough for this parent + task shape to run passes 2–3 without chat babysitting. Study 1’s “skipped entirely” and this study’s “started but incomplete without operator” are the same R0 binding problem with a sharper evidence shape.

**Supporting (Observed):** Planner Task output included: `Escalation: No — standard plan-review gate only. No plan_reviewer loop beyond the normal gate.` — wording that can normalize single-pass review against the max-3 iterative skill.

### Failure mode C — skill-tool catalog / binding (new)

**Observed:** Across the whole session the `skill` tool was invoked three times and **always** with `customize-opencode`. When the user asked for the planning skill ([184]), the parent loaded `customize-opencode` ([185]), then reasoned that it “isn’t quite the planning skill” and that “the system prompt only lists `customize-opencode` as an available skill” ([186]), pivoting to a `planner` Task that might load `implementation-plan` internally.

**Observed:** Global skills including `implementation-plan` and `plan-review` existed under `~/.config/opencode/skills/` (listed later via bash). The `plan-review` skill body and `iterative-plan-review.md` were first loaded via **`read`** after the operator’s explicit question ([263]–[266]) — not via the `skill` tool earlier.

**Inferred:** Custom/global workflow skills are on disk but not reliably skill-tool-discoverable or auto-bound for this host/parent. The parent improvises agent-shaped approximations (`planner` / `plan_reviewer` Tasks) and falls back to **bash/`read` discovery** of `~/.config/opencode/` instead of loading SoT skills. **Unknown:** whether the skill-tool catalog is intentionally minimal (host design) vs misconfigured adapter registration — Observed is the tool behavior and the parent’s stated catalog.

```text
User: "use the planning skill + iterative review"
        │
        ▼
   skill tool → customize-opencode only
        │
        ├──────────────┐
        ▼              ▼
   planner/plan_reviewer   bash/read filesystem
   Tasks (B′)              discovery (→ E)
```

### Failure mode D — transcript / storage opacity (new, secondary)

**Observed:** User asked where the conversation transcript lives ([214]); parent needed a multi-step bash hunt before identifying `~\.local\share\opencode\opencode.db` (not Cursor-style per-session JSONL / legacy `storage/message/` layout).

**Observed:** Earlier in-session DSV4F write-up assumed no full sub-agent message store for contamination audit; later research ([249]/[258]) corrected that child `bug_reviewer` sessions **are** in `opencode.db` with `parent_id` and tool parts.

**Inferred:** Opaque host storage raises wrong architecture conclusions in docs and eval tooling — separate openBuggy product workstream, but relevant to R0 smoke/audit honesty. It also **feeds E**: hunting the transcript and host layout was done with long bash chains that each needed approval.

### Failure mode E — shell-approval babysitting (new; operator primary pain)

**Observed (export):** Full-session tool counts — **`bash` 160** vs **`skill` 3**. Bash dominated (~half of all tool calls). Skills that should have been on-demand SoT loads were largely bypassed; the parent used shell (and `read`) to inspect agents, logs, desktop `.dat` pins, and `opencode.db`.

**Observed (operator report, 2026-08-19):** On this Desktop host, shell commands require user review. Substituting bash for skills therefore forced the operator to interact with the thread about every **2–3 minutes without fail** — a continuous babysitting tax distinct from the occasional “Please continue” of B′.

**Inferred:** C (undiscoverable / unbound workflow skills) is not only a correctness problem for plan/review gates; it is an **attention-cost** problem. Even when the parent is “making progress,” the wrong tool class keeps the human in the approval loop. R0 reliability includes “gates fire” **and** “routine SoT loads do not require a human click every few minutes.”

**cursorEscape analytical focus:** Prefer skill-tool (or other non-approval) paths for adapter/SoT material so exploratory babysitting is not the default cost of OpenCode dogfood. **This document does not prescribe the fix** (permission policy vs catalog registration vs always-on pointers).

### What worked (Observed)

- After Antigravity cleanup, subagents inherit parent DeepSeek; real `plan_reviewer` reviews take minutes and return non-empty verdicts.
- When the operator forces the loop, **3-pass clean-context** review works (CHANGES → revise → APPROVED).
- `question` tool used before planning on the contamination approach.
- Plan mode mostly held (research/plan before implement) for protocol + contamination work.
- Live DB contains recoverable child Task sessions (enables future exporters).

### What this study does not prescribe

No Target always-on wording, skill-trigger, permission policy, or adapter change is proposed here. Analytical focus remains: how global instruction / skill surfaces must bind so loops fire **and** routine SoT work does not force shell-approval babysitting — including when the user already named the skills.

---

## Implications / open questions

1. How should OpenCode skill-tool discovery expose global workflow skills (`implementation-plan`, `plan-review`, …) so parents do not only see `customize-opencode` — and stop substituting **approval-gated bash** for those loads?
2. What always-on / skill trigger makes passes 2–3 **auto-continue** after CHANGES REQUESTED without “Please continue”?
3. What R0 smoke / metric catches shell-approval babysitting (e.g. bash:skill ratio, or “adapter SoT loaded via skill not bash”)? — SOP smoke rows **9–10** drafted; awaiting Probe A ([skill-binding discovery](./opencode-skill-binding-discovery-2026-08.md)).
4. How should R0 smoke detect desktop `workspace:model-selection` pins (beyond empty-fast Tasks) after agent markdown looks clean?
5. Keep openBuggy contamination-audit / transcript-exporter product work separate from cursorEscape instruction-layer binding.
6. Live probe that gates fired remains [opencode-host-adapter](../SOPs/opencode-host-adapter.md) smoke row 1 (restart after adapter edits).
7. **Discovery + probes (2026-08-19):** Catalog fixed (smoke 9–10). Short native lookups pass (B/C). Glob-blind residual **F** mitigated — smoke **12** pass (`.ignore` + `external_directory` + listing allow); see [skill-binding discovery](./opencode-skill-binding-discovery-2026-08.md).

---

## Sources

- openBuggy `docs/analysis/DSV4F/opencode-session/` export for `ses_fefe26e1affe5MSTIrlBnkyD0B` (re-export ~276 messages / ~1223 parts; exporter ID-join fix applied locally in `export-opencode-session.py` — **sibling commit of that fix not assumed** in this pass)
- Live SoT during study: `C:\Users\admin\.local\share\opencode\opencode.db` (read-only)
- [OpenCode DSV4F session study (2026-08)](./opencode-dsv4f-session-2026-08.md) — first slice / Failure A–B
- Operator Antigravity removal and agent updates (outside chat; confirmed by smoke [232]–[235])
- Operator clarification (2026-08-19) — primary live pain = shell-approval babysitting (~every 2–3 minutes) because bash substituted for OpenCode skills
- [OpenCode skill-binding discovery (2026-08)](./opencode-skill-binding-discovery-2026-08.md) — harness vs model vs config; Probe A–C deferred

---

## Related

- [OpenCode skill-binding discovery (2026-08)](./opencode-skill-binding-discovery-2026-08.md)
- [Authoring OpenCode adapter files](../SOPs/opencode-authoring-adapter.md)
- [OpenCode DSV4F session study (2026-08)](./opencode-dsv4f-session-2026-08.md)
- [Host recreation (2026-08)](./host-recreation-2026-08.md)
- [OpenCode host adapter SOP](../SOPs/opencode-host-adapter.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md)
- [Intended workflow](../featureArchitecture/intended-workflow.md)
- [Analysis index](./_index.md)
