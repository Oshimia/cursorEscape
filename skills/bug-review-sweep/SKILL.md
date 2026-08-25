---
name: bug-review-sweep
description: >-
  Structured sweep protocol for bug hunts: ordered passes over eight
  bug-pattern classes with per-class checks and evidence bars, plus scope,
  nit-suppression, pre-existing, and clean-case gates applied before any
  finding is reported. Load before hunting.
disable-model-invocation: true
---

# Bug review sweep


**Canonical SoT:** `cursorEscape` repo, `skills/bug-review-sweep/SKILL.md`.
**Mirror:** `openBuggy` repo, `skills/bug-review-sweep/SKILL.md`, byte-identical by design — regenerate from canonical; never edit the mirror in place. Edit only in cursorEscape.
**Product north star:** a low-cost, quick, single-pass bug finder that matches or exceeds Cursor BugBot's capability. Findings are discrete, precise, and evidenced in ONE pass — never multi-pass/ensemble/retry crutches; cheap-model parity is pursued through instruction quality.
**Policy SoT:** what counts as reportable vs ignorable is the bug-reviewer finding rubric at `cursorEscape: docs/featureArchitecture/bug-reviewer-finding-rubric.md`. This artifact operationalizes it; on conflict, the rubric wins.
**Load marker:** when this protocol is active, quote the line `bug-review-sweep protocol v1 active` at the top of your response so the caller can verify this file loaded.

## Pass 0 — Envelope lock

Before hunting, lock the envelope. Complete all four steps; do not start any class pass until they are done.

1. **Lock the envelope silently:** determine diff mode, scope themes, caller-named regressions, and clean/validated-fix signals (if present, Gate G4 arms). Do not restate any of this in your response.
2. **Build the changed-line census:** enumerate every changed/added/deleted line INCLUDING strings, UI copy, help text, and comments-as-behavior (doc strings shown to users). In natural-language mode, resolve the named files/hunks first; if the change surface resolves empty, stop and return an empty answer.
3. **Self-labeling markers:** `BUG`/`TODO`/`FIXME`/`HACK` comments inside changed lines are ATTENTION CUES ONLY — never evidence. For each, independently verify the marked behavior on the workspace through the normal class passes; a reported finding must stand entirely on its own mechanism, code path, and trigger, citing the behavior's file:line (never the comment). A finding whose only support is the comment's existence does not survive G2.
4. **Non-empty-diff preflight:** confirm at least one reviewed hunk exists before continuing.

## Ordered class passes

Run the passes in this exact order (order = observed yield/severity; do not reorder). In each pass, apply the checks to the changed-line census from Pass 0.

| # | Class | Checks | Evidence bar (all required) |
|---|-------|--------|------------------------------|
| 1 | security_authz | Authz gate removed/weakened by the change; sensitive action reachable without entitlement/role; ownership/tenant check dropped; gate tests the wrong principal (e.g. authenticates a resource's owner while the acting user is unchecked) | Name the reachable action, then the protected effect code path with its missing/weakened gate; cite the changed line that caused it (file:line) |
| 2 | logic_correctness | Inverted conditions; wrong defaults/reset values; stale state not cleared; ordering errors; wrong variable/data mapping; off-by-one introduced by the diff; dead interactive control: rendered input/toggle/button with no state, prop, or handler binding anywhere in the reviewed tree — if the tree is a reduced stub, state the assumed wiring context instead of reporting unless the control is inert even under that assumption; data-integrity chains in migrations and merge/account flows: trace parent-child row dependencies (e.g. users vs role/permission tables), confirm every touched table serves the stated purpose, and check constraint implications (FK/UNIQUE/NOT NULL) | Concrete input/state sequence producing wrong observable behavior on the reviewed workspace |
| 3 | concurrency_races | Async fetch/callback clobbering optimistic state set earlier in the same flow; stale closure over pre-change data; missing invalidation/cancel on unmount/logout/close; PLUS apply the scheduling-frontier procedure below to every async flow the changed code introduces or modifies | Interleaving of two operations demonstrable in changed code (cite both sides), including which scheduling frontier each side crosses |
| 4 | resource_lifecycle | Subscription/timer/file/connection opened without release path after the change; cleanup dropped or reordered | Lifecycle event plus the missed release path |
| 5 | api_contract | Call to undeclared/undefined function or prop; signature/schema mismatch; wrong status code/shape/middleware order vs reviewed-tree definitions | Violation provable from source present in the reviewed workspace |
| 6 | error_handling_resilience | Error path INTRODUCED by the change that swallows/rejects incorrectly and corrupts state machine or crashes | The introduced path plus the resulting wrong state. Explicitly NOT this class: generic robustness wishing on unchanged code (see G2) |
| 7 | performance_efficiency | Unbounded accumulation/pileup; O(n^2) growth; hot-path recomputation introduced by the diff | Growth tied to an introduced loop/allocation with reasoning about realistic input sizes |
| 8 | documentation_drift | Changed docs/UI strings/help text contradicting the behavior the diff introduces, or omitting a qualifier the new behavior requires | Quote the changed string AND cite the contradicted behavior, both evidenced on the workspace |

Every pass ends the same way: candidates must survive Gates G1–G3 before entering the report list.

### Scheduling frontiers (class 3 evidence procedure)

Every `await`/`.then` continuation, `queueMicrotask` callback, timer, and deferred effect/render flush is a frontier where other queued work may execute before resumption. For each asynchronous flow the changed code introduces or modifies:

1. List its frontiers in execution order (request start, each suspension point, each resumption, each deferred reset/invalidate callback).
2. For each frontier, name what other queued work may run across it: earlier suspended continuations of the same flow, competing flows, close/reset paths, and user-event handlers.
3. At every resumption point, re-validate pre-suspension assumptions: version/generation guards still current, target resource/surface still the intended one, state not cleared, superseded, or invalidated while suspended.

A write that resumes across a frontier onto state whose validity has since been invalidated is a concurrency_races finding even when every individual statement looks correct. A guard evaluated when a request STARTS protects nothing against writers resuming after a LATER invalidation - guard position relative to frontiers is part of the mechanism.
### Interaction matrix (mandatory when the diff touches interactive surfaces)

When the changed code renders or handles interactive surfaces - dialogs, forms, buttons, tabs, settings panels - enumerate the distinct user-action sequences that surface supports and emit one `<interaction>` element per sequence inside `<answer>`:

```
<interaction seq="open dialog -> clear checkpoint field 1 -> save" locus="ui_app.py:87-118">broken - see bug</interaction>
<interaction seq="switch level -> edit extra checkpoint -> save" locus="ui_app.py:54">ok</interaction>
```

Rules: cover at minimum open, cancel/close, each editable field cleared, each field edited-then-saved, and each context switch (tab/level/mode) the surface supports; `ok` verdicts must cite a locus; `broken` without a corresponding `<bug>` entry is a contract violation. Omit the block entirely only when the diff contains no interactive-surface handling at all. Keep verdict bodies to these minimal forms - no prose.
## Tests-as-claims review (test-quality procedure, static)

When the change surface includes test files, treat every changed test as a claim about the code under test and audit its evidentiary value by reading alone. A test that cannot fail under any implementation violating its promised property is itself a defect in the change (tests are part of the reviewed product); report it under logic_correctness:

1. Claim/assertion parity: for each changed test, state what its name/docstring promises and list what its assertions actually observe. If no assertion can distinguish a correct implementation from one violating the promised property, the promise is unverified.
2. Mock audit: whenever a mock/stub/patch substitutes part of the unit-under-test own internals (private accounting, storage, collaborators), determine what observable evidence remains after the substitution. If the substituted-away surface is exactly where the promised property lives, the test verifies nothing.
3. Shared-state scan: module-level instances, session-scoped fixtures, caches, or mutable globals shared across tests: check whether any assertion outcome depends on execution order or residue left by an earlier test. Order-dependence is a defect even when the current order passes.

This safe variant has no execution capability: where the tool-capable line would run an empirical suite probe (reorder or remove-one-mock), reason statically instead and mark the mechanism explicitly as hypothesis-grade in the description when the order-dependence or mock-away conclusion cannot be fully confirmed without execution.

Evidence bar: name the promised property, show the mechanism (assertion, mock, shared state) that defeats it, cite file:line. Boundary: this procedure never reports runner-configuration nits (G2 still suppresses those); it reports defects in what the changed tests actually verify.

## Persistence-parity review (state-lifecycle procedure)

When the changed code mutates persisted state - settings stores, config files, databases, cookies/localStorage, saved documents - enumerate every mutated field and audit both directions of its lifecycle:

1. Write-path tracing: trace every written field to every read path that consumes it, including reads under modified conditions (a different mode, view, or selected entity than the one active at write time).
2. Clear/revert parity: every mutation that sets state must have a reachable counterpart that clears, resets, or overwrites it when the user reverses the action (uncheck, clear, cancel, delete, switch entity); a set with no reachable clear persists stale values indefinitely.
3. Default-drift check: a stored value that can diverge from current defaults (renamed key, moved location, changed schema) needs a migration or tolerant read; otherwise old persisted values silently override new defaults.
4. Trigger scoping: a write fired by merely opening a dialog or view - not by an explicit save/confirm action - persists state without user intent; trace each write to its triggering event and flag any write not downstream of an explicit confirm.

Report violations under logic_correctness. Evidence bar: name the field, cite the writer file:line and the missing/divergent clear-or-read path file:line. Boundary: never report mere absence of persistence features nobody claims (G2 capability-absence still applies); report divergence between what the changed code persists and what its own reversal/consumption paths require.

## Gates (apply to EVERY candidate before reporting)

- **G1 Scope discipline.** Report ONLY defects BOTH (a) clearly wrong on the reviewed workspace AND (b) inside the envelope's stated change scope. Real-but-out-of-scope issues are not findings — note nothing. Empty answer if none qualify.
- **G2 Nit suppression — do not report:** dead parameters; unused props/locals; dead-code consequences of the intended change; robustness speculation (missing `response.ok`-style guards, hypothetical null/network/env cases) unless the change itself seeds a concrete failure of that kind; test-harness coupling nits (CWD-dependent tests, runner config); malformed README tables/formatting/naming/import-order; capability-absence claims: asserting that some output, mode, or capability is missing entirely when neither the envelope nor any changed-code statement claims to provide it. Boundary: G2 never suppresses (a) an identifier referenced by changed code but declared nowhere in the reviewed workspace — that is an api_contract finding (class 5), even if the workspace looks like a reduced stub; (b) an added mechanism that fails to cover one of its own trigger paths — that is a defect in the introduced mechanism, not a nit. (c) an absence the envelope or changed code explicitly claims to provide - a helper named in the change description that exists nowhere, or an imported module absent from the workspace - is an api_contract/logic finding, not incompleteness. All conditional: if the envelope scope explicitly puts such a class in scope, G2 yields.
- **G3 Pre-existing gate.** branch_diff/uncommitted modes: verify each suspect condition against the base revision (e.g. `git show <base>:<file>`); do not report conditions already present there. Natural-language mode: restrict to files/hunks named in the change description. When age cannot be verified, decide by mechanism ownership: if the defective behavior lives inside code this change introduces or rewrites — including an added guard/check that fails to cover one of its own trigger paths, or a stated purpose it does not achieve — treat it as introduced; only untouched legacy code outside the changed mechanism counts as pre-existing.
- **G4 Clean conservatism.** When Pass 0 detected clean/validated-fix signals, high conservatism applies: empty answer unless a defect is unambiguously wrong on the fixture. G4 overrides any doubt-rule "report" tendency. When the envelope says 're-check <fixes>', that raises scrutiny OF THE NAMED FIXES themselves: report any defect found in or adjacent to the fixed surface; conservatism applies to unrelated candidates only.

## Completeness pass (before concluding CLEAN)

Confirm every changed line was examined including strings/UI copy/help text; walk each bullet of the change description against actual observed behavior across ALL its trigger paths (every state transition, mode, or lifecycle event the bullet implies) — partial achievement of a stated bullet is a logic_correctness finding; only then may an empty answer be emitted. A miss here is how real defects get missed. Record the outcome of this walk as the coverage verdicts required by the Output section.

## Schema-assumption rule (constrained inference)

When a candidate's mechanism depends on schema/constraint definitions absent from the workspace (e.g. FK/UNIQUE enforcement on a column), do NOT suppress it: state the assumed constraint explicitly inside the description, mark the finding lower confidence, and report it. Suppression is reserved for candidates whose failure cannot be articulated even with stated assumptions.

## Evidence and citation discipline

Every reported finding cites: file:line (or quoted hunk) on the reviewed workspace + one-sentence failure mechanism + trigger condition + why it is introduced-by-this-change (not pre-existing). At most one concise hypothesis per non-obvious finding. No reproduction beyond strictly read-only inspection; redact secrets/personal data from captured output. Never spawn further agents/reviews (recursion guard).

## Output

One structured finding per defect that survived every gate — or empty/CLEAN. No code-review scaffolding (no blocking/non-blocking tiers, no test-gap lists, no verdict lines). Two distinct defects are TWO entries even when they share lines or a root cause.

Per-finding fields (openBuggy `reviewee.xml` compatible):

- **title**
- **file**
- **start_line** / **end_line**
- **category** — the class pass that produced the finding
- **severity** — high / medium / low
- **description** — failure mechanism + trigger condition (+ explicit schema assumptions when the schema-assumption rule applied)
- **rationale** — why introduced-by-this-change

Host XML form: `<answer><bug>` elements carrying those fields; when nothing qualifies emit empty `<answer></answer>` — no bodies, no commentary. If the caller's envelope prescribes a different container, follow it exactly; this protocol defines WHAT may be reported — it never adds tiers or verdicts of its own.

**Coverage verdicts (mandatory, part of the output contract):** inside `<answer>`, emit one `<coverage>` element per change-description bullet, numbered in envelope order:

```xml
<coverage b="1" locus="path/to/file.ext:LINE">ok</coverage>
```

or, when the bullet could not be reconciled with located code:

```xml
<coverage bullet="N">unresolved: implementation not located / contradicts bullet — see bug entry</coverage>
```

Rules: every bullet appears exactly once; `unresolved` without a corresponding `<bug>` entry is a contract violation (an unresolved bullet IS a finding candidate); every `ok` verdict must carry a real locus on the reviewed workspace. Keep verdict bodies to these minimal forms - no prose. Consumers other than this protocol ignore `<coverage>` elements; findings are scored solely on `<bug>` entries.

Missing-test observations ride along inside a finding only when the gap hides the reported production risk; never as separate entries.

A reportable finding simultaneously satisfies: production impact (incorrect, unsafe, or likely to break users), introduced-by-change, in envelope scope, clear-on-workspace — the gates above enforce this; do not restate criteria as output sections.

Doubt rule placement: doubt about whether an in-scope production defect exists → report (unless G4 armed); doubt whether something is a nit/out-of-scope/pre-existing/speculative → do not report.

## Provenance

Adaptation inputs: openBuggy DSV4F M1–M5 census (bb-01..bb-05 pilot), BugBot finding-personality observation, mattpocock/skills code-review audit (pinned https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/code-review/SKILL.md). v3-candidate additions: dead-control check, self-labeling marker check, data-integrity chains, schema-assumption rule, anti-bundling output rule. v3.3-candidate addition: mandatory coverage-verdict elements binding the completeness pass into the output contract. v3.5-candidate addition: scheduling-frontier evidence procedure for class 3 (enumerate frontiers, cross-frontier work, and post-resumption validity). v3.6-candidate addition: interaction-matrix element for interactive surfaces (user-action sequences written and verified before CLEAN).
v3.8.1-candidate addition: static port of the v4.1 tests-as-claims annex - claim/assertion parity, mock audit, shared-state scan; empirical suite probe replaced by explicit hypothesis-grade marking since the safe ruleset denies execution. Motivated by the band-5 bb-53 FN pair under v4 and the open question whether static obligations alone recover it on the safe line.
v3.8.2-candidate addition: persistence-parity annex ported from v4.2 under governance rule 7 (pure read-only procedure; no execution-dependent component) AFTER tool-line probe PASS per the 2026-08-26 sequencing amendment.
