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



## Pass 0 — Envelope lock

Before hunting, lock the envelope. Complete all four steps; do not start any class pass until they are done.

1. **Lock the envelope silently:** determine diff mode, scope themes, caller-named regressions, and clean/validated-fix signals (if present, Gate G3 arms). Do not restate any of this in your response.
2. **Build the changed-line census:** enumerate every changed/added/deleted line INCLUDING strings, UI copy, help text, and comments-as-behavior (doc strings shown to users). In natural-language mode, resolve the named files/hunks first; if the change surface resolves empty, stop and return an empty answer.
3. **Self-labeling markers:** `BUG`/`TODO`/`FIXME`/`HACK` comments inside changed lines are ATTENTION CUES ONLY — never evidence. For each, independently verify the marked behavior on the workspace through the normal class passes; a reported finding must stand entirely on its own mechanism, code path, and trigger, citing the behavior's file:line (never the comment). A finding whose only support is the comment's existence does not survive G2.
4. **Non-empty-diff preflight:** confirm at least one reviewed hunk exists before continuing.

## Ordered class passes

Run the passes in this exact order (order = observed yield/severity; do not reorder). In each pass, apply the checks to the changed-line census from Pass 0.

| # | Class | Checks | Evidence bar (all required) |
|---|-------|--------|------------------------------|
| 1 | security_authz | Authz gate removed/weakened by the change; sensitive action reachable without entitlement/role; ownership/tenant check dropped; gate tests the wrong principal (e.g. authenticates a resource's owner while the acting user is unchecked) | Name the reachable action, then the protected effect code path with its missing/weakened gate; cite the changed line that caused it (file:line) |
| 2 | logic_correctness | Inverted conditions; wrong defaults/reset values; stale state not cleared; ordering errors; wrong variable/data mapping; off-by-one introduced by the diff; data-integrity chains in migrations and merge/account flows: trace parent-child row dependencies (e.g. users vs role/permission tables), confirm every touched table serves the stated purpose, and check constraint implications (FK/UNIQUE/NOT NULL) | Concrete input/state sequence producing wrong observable behavior on the reviewed workspace |
| 3 | concurrency_races | Async fetch/callback clobbering optimistic state set earlier in the same flow; stale closure over pre-change data; missing invalidation/cancel on unmount/logout/close; PLUS apply the scheduling-frontier procedure below to every async flow the changed code introduces or modifies | Interleaving of two operations demonstrable in changed code (cite both sides), including which scheduling frontier each side crosses |
| 4 | claims_retirements | Three artifact kinds carry claims that need both an observer and a reachable retirement: resources, persisted fields, test claims — apply the claims-and-retirements procedure below to every instance the census touches (report under claims_retirements) | Lifecycle event plus the missed release/clear path; for test claims see the procedure below |
| 5 | reference_integrity | Call to undeclared/undefined function or prop; signature/schema mismatch; wrong status code/shape/middleware order vs reviewed-tree definitions; dead interactive control: rendered input/toggle/button with no state, prop, or handler binding anywhere in the reviewed tree — if the tree is a reduced stub, state the assumed wiring context instead of reporting unless the control is inert even under that assumption; every referenced symbol/path must resolve on the workspace or its absence be explicitly assumed and stated (schema-assumption fallback below) | Violation provable from source present in the reviewed workspace |
| 6 | error_handling_resilience | Error path INTRODUCED by the change that swallows/rejects incorrectly and corrupts state machine or crashes | The introduced path plus the resulting wrong state. Explicitly NOT this class: generic robustness wishing on unchanged code (see G2) |
| 7 | performance_efficiency | Unbounded accumulation/pileup; O(n^2) growth; hot-path recomputation introduced by the diff; liveness/progress-rate: for every consumer loop introduced or modified (workers, channel readers, debounce/batch handlers), determine items processed per activation versus the arrival pattern - one-item-per-wakeup consumption under coalescing arrivals stalls the backlog | Growth tied to an introduced loop/allocation with reasoning about realistic input sizes; for liveness claims cite both the per-activation consumption count and the arrival pattern, each with file:line |
| 8 | documentation_drift | Changed docs/UI strings/help text contradicting the behavior the diff introduces, or omitting a qualifier the new behavior requires | Quote the changed string AND cite the contradicted behavior, both evidenced on the workspace |

Every pass ends the same way: candidates must survive Gates G1–G2 before entering the report list.

### Class 3 procedure — scheduling frontiers, verified by execution

Every `await`/`.then` continuation, `queueMicrotask` callback, timer, and deferred effect/render flush is a frontier where other queued work may execute before resumption. For each asynchronous flow the changed code introduces or modifies:

1. List its frontiers in execution order (request start, each suspension point, each resumption, each deferred reset/invalidate callback).
2. For each frontier, name what other queued work may run across it: earlier suspended continuations of the same flow, competing flows, close/reset paths, and user-event handlers.
3. At every resumption point, re-validate pre-suspension assumptions: version/generation guards still current, target resource/surface still the intended one, state not cleared, superseded, or invalidated while suspended.

A write that resumes across a frontier onto state whose validity has since been invalidated is a concurrency_races finding even when every individual statement looks correct. A guard evaluated when a request STARTS protects nothing against writers resuming after a LATER invalidation - guard position relative to frontiers is part of the mechanism.

Any interleaving or state-ordering hypothesis that survives static reading must be driver-verified before it may be reported:

1. **Compose a standalone driver** in the fixture's own language that reproduces the suspect pattern with explicit sequencing (promise chains, queued callbacks, timers) and prints the observed interleaving or resulting state.
2. **Write it only under `_scratch/`** and execute it with the project runtime available in your environment (`node`, `python`, etc.). No package installation, no network access, no files outside `_scratch/`.
3. **Cite observed output** in the finding description. A driver whose output confirms the defect is strong evidence; one whose output contradicts your hypothesis means the suspicion was wrong - do not report it.

Constraints: drivers are self-contained (standard library + the fixture's own modules only); no network; no dependency installation; bounded runtime. Scratch files are disposable and never cited as changed code. Do NOT delete _scratch/ after execution - drivers and their outputs remain in place as provenance artifacts. If your environment provides no execution capability, report such findings as unresolved hypotheses instead - static reasoning alone must not assert interleaving outcomes.

### Interaction matrix (mandatory when the diff touches interactive surfaces)

When the changed code renders or handles interactive surfaces - dialogs, forms, buttons, tabs, settings panels - enumerate the distinct user-action sequences that surface supports and emit one `<interaction>` element per sequence inside `<answer>`:

```
<interaction seq="open dialog -> clear checkpoint field 1 -> save" locus="ui_app.py:87-118">broken - see bug</interaction>
<interaction seq="switch level -> edit extra checkpoint -> save" locus="ui_app.py:54">ok</interaction>
```

Rules: cover at minimum open, cancel/close, each editable field cleared, each field edited-then-saved, and each context switch (tab/level/mode) the surface supports; `ok` verdicts must cite a locus; `broken` without a corresponding `<bug>` entry is a contract violation. Omit the block entirely only when the diff contains no interactive-surface handling at all. Keep verdict bodies to these minimal forms - no prose.
## Claims-and-retirements procedure (class 4)

One criterion governs class 4: every artifact the change endows with a claim must have both an observer that can detect the claim failing and a reachable path that retires it when superseded. Apply it to the three artifact kinds below.

**Resources:** Subscription/timer/file/connection opened without release path after the change; cleanup dropped or reordered
Evidence bar: lifecycle event plus the missed release path.

**Persisted state** (settings stores, config files, databases, cookies/localStorage, saved documents) — enumerate every mutated field:

1. Write-path tracing: trace every written field to every read path that consumes it, including reads under modified conditions (a different mode, view, or selected entity than the one active at write time).
2. Clear/revert parity: every mutation that sets state must have a reachable counterpart that clears, resets, or overwrites it when the user reverses the action (uncheck, clear, cancel, delete, switch entity); a set with no reachable clear persists stale values indefinitely.
3. Default-drift check: a stored value that can diverge from current defaults (renamed key, moved location, changed schema) needs a migration or tolerant read; otherwise old persisted values silently override new defaults.
4. Trigger scoping: a write fired by merely opening a dialog or view - not by an explicit save/confirm action - persists state without user intent; trace each write to its triggering event and flag any write not downstream of an explicit confirm.

Report violations under logic_correctness. Evidence bar: name the field, cite the writer file:line and the missing/divergent clear-or-read path file:line. Boundary: never report mere absence of persistence features nobody claims (G2 capability-absence still applies); report divergence between what the changed code persists and what its own reversal/consumption paths require.

**Test claims** (when the change surface includes test files; report under claims_retirements):

1. Claim/assertion parity: for each changed test, state what its name/docstring promises and list what its assertions actually observe. If no assertion can distinguish a correct implementation from one violating the promised property, the promise is unverified.
2. Mock audit: whenever a mock/stub/patch substitutes part of the unit-under-test own internals (private accounting, storage, collaborators), determine what observable evidence remains after the substitution. If the substituted-away surface is exactly where the promised property lives, the test verifies nothing.
3. Shared-state scan: module-level instances, session-scoped fixtures, caches, or mutable globals shared across tests: check whether any assertion outcome depends on execution order or residue left by an earlier test. Order-dependence is a defect even when the current order passes.
4. Empirical suite probe (tool-capable environments): when static reading is inconclusive, execute the project own test command under the _scratch/ constraints (no installs, no network) with one targeted perturbation - reorder suspect tests or remove a single mock - and cite observed output. A probe whose output contradicts the hypothesis kills the candidate.

Evidence bar: name the promised property, show the mechanism (assertion, mock, shared state) that defeats it, cite file:line. Boundary: this procedure never reports runner-configuration nits (G2 still suppresses those); it reports defects in what the changed tests actually verify.

Reference-integrity fallback (constrained inference): When a candidate's mechanism depends on schema/constraint definitions absent from the workspace (e.g. FK/UNIQUE enforcement on a column), do NOT suppress it: state the assumed constraint explicitly inside the description, mark the finding lower confidence, and report it.

## Gates (apply to EVERY candidate before reporting)

- **G1 Provenance discipline (scope + pre-existing).** (a) Scope: Report ONLY defects BOTH (a) clearly wrong on the reviewed workspace AND (b) inside the envelope's stated change scope. Real-but-out-of-scope issues are not findings — note nothing. Empty answer if none qualify. (b) Pre-existing: branch_diff/uncommitted modes: verify each suspect condition against the base revision (e.g. `git show <base>:<file>`); do not report conditions already present there. Natural-language mode: restrict to files/hunks named in the change description. When age cannot be verified, decide by mechanism ownership: if the defective behavior lives inside code this change introduces or rewrites — including an added guard/check that fails to cover one of its own trigger paths, or a stated purpose it does not achieve — treat it as introduced; only untouched legacy code outside the changed mechanism counts as pre-existing.
- **G2 Nit suppression — do not report:** dead parameters; unused props/locals; dead-code consequences of the intended change; robustness speculation (missing `response.ok`-style guards, hypothetical null/network/env cases) unless the change itself seeds a concrete failure of that kind; test-harness coupling nits (CWD-dependent tests, runner config); malformed README tables/formatting/naming/import-order; capability-absence claims: asserting that some output, mode, or capability is missing entirely when neither the envelope nor any changed-code statement claims to provide it. Boundary: G2 never suppresses (a) an identifier referenced by changed code but declared nowhere in the reviewed workspace — that is an api_contract finding (class 5), even if the workspace looks like a reduced stub; (b) an added mechanism that fails to cover one of its own trigger paths — that is a defect in the introduced mechanism, not a nit. (c) an absence the envelope or changed code explicitly claims to provide - a helper named in the change description that exists nowhere, or an imported module absent from the workspace - is an api_contract/logic finding, not incompleteness. All conditional: if the envelope scope explicitly puts such a class in scope, G2 yields.
- **G3 Clean conservatism.** When Pass 0 detected clean/validated-fix signals, high conservatism applies: empty answer unless a defect is unambiguously wrong on the fixture. G3 overrides any doubt-rule "report" tendency. When the envelope says 're-check <fixes>', that raises scrutiny OF THE NAMED FIXES themselves: report any defect found in or adjacent to the fixed surface; conservatism applies to unrelated candidates only.

## Completeness pass (before concluding CLEAN)

Confirm every changed line was examined including strings/UI copy/help text; walk each bullet of the change description against actual observed behavior across ALL its trigger paths (every state transition, mode, or lifecycle event the bullet implies) — partial achievement of a stated bullet is a logic_correctness finding; only then may an empty answer be emitted. A miss here is how real defects get missed. Record the outcome of this walk as the coverage verdicts required by the Output section.

## Evidence and citation discipline

Every reported finding cites: file:line (or quoted hunk) on the reviewed workspace + one-sentence failure mechanism + trigger condition + why it is introduced-by-this-change (not pre-existing). At most one concise hypothesis per non-obvious finding. Redact secrets/personal data from captured output (including driver output). Never spawn further agents/reviews (recursion guard); never install packages or fetch dependencies; never write outside `_scratch/`.

## Output

One structured finding per defect that survived every gate — or empty/CLEAN. No code-review scaffolding (no blocking/non-blocking tiers, no test-gap lists, no verdict lines). Two distinct defects are TWO entries even when they share lines or a root cause.

Per-finding fields (host-report compatible):

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

Unresolved bullets use `<coverage bullet="N">unresolved: implementation not located / contradicts bullet — see bug entry</coverage>`. Rules:

Rules: every bullet appears exactly once; `unresolved` without a corresponding `<bug>` entry is a contract violation (an unresolved bullet IS a finding candidate); every `ok` verdict must carry a real locus on the reviewed workspace. Keep verdict bodies to these minimal forms - no prose. Consumers other than this protocol ignore `<coverage>` elements; findings are scored solely on `<bug>` entries.

Missing-test observations ride along inside a finding only when the gap hides the reported production risk; never as separate entries.
