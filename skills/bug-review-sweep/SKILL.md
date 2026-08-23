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
**Policy SoT:** what counts as reportable vs ignorable is the bug-reviewer finding rubric at `cursorEscape: docs/featureArchitecture/bug-reviewer-finding-rubric.md`. This artifact operationalizes it; on conflict, the rubric wins.
**Product north star:** a low-cost, quick, single-pass bug finder that matches or exceeds Cursor BugBot's capability. Findings are discrete, precise, and evidenced in ONE pass — never multi-pass/ensemble/retry crutches; cheap-model parity is pursued through instruction quality.
**Load marker:** when this protocol is active, quote the line `bug-review-sweep protocol v1 active` at the top of your response so the caller can verify this file loaded.

## Pass 0 — Envelope lock

Before hunting, lock the envelope. Complete all three steps; do not start any class pass until they are done.

1. **Restate the envelope** in one short block:
   - Diff mode: `branch_diff`, `uncommitted_diff`, or natural-language change description.
   - Stated scope themes and out-of-scope themes.
   - Regressions-to-flag named by the caller.
   - Clean/validated-fix signals (e.g. "Fast CI passed", "validated fix", clean band) — if present, Gate G4 arms.
2. **Build the changed-line census:** enumerate every changed/added/deleted line INCLUDING strings, UI copy, help text, and comments-as-behavior (doc strings shown to users). In natural-language mode, resolve the named files/hunks first; if the change surface resolves empty, stop and return an empty answer.
3. **Non-empty-diff preflight:** confirm at least one reviewed hunk exists before continuing.

## Ordered class passes

Run the passes in this exact order (order = observed yield/severity; do not reorder). In each pass, apply the checks to the changed-line census from Pass 0.

| # | Class | Checks | Evidence bar (all required) |
|---|-------|--------|------------------------------|
| 1 | security_authz | Authz gate removed/weakened by the change; sensitive action reachable without entitlement/role; ownership/tenant check dropped | Name the reachable action, then the protected effect code path with its missing/weakened gate; cite the changed line that caused it (file:line) |
| 2 | logic_correctness | Inverted conditions; wrong defaults/reset values; stale state not cleared; ordering errors; wrong variable/data mapping; off-by-one introduced by the diff | Concrete input/state sequence producing wrong observable behavior on the reviewed workspace |
| 3 | concurrency_races | Async fetch/callback clobbering optimistic state set earlier in the same flow; stale closure over pre-change data; missing invalidation/cancel on unmount/logout/close | Interleaving of two operations demonstrable in changed code (cite both sides) |
| 4 | resource_lifecycle | Subscription/timer/file/connection opened without release path after the change; cleanup dropped or reordered | Lifecycle event plus the missed release path |
| 5 | api_contract | Call to undeclared/undefined function or prop; signature/schema mismatch; wrong status code/shape/middleware order vs reviewed-tree definitions | Violation provable from source present in the reviewed workspace |
| 6 | error_handling_resilience | Error path INTRODUCED by the change that swallows/rejects incorrectly and corrupts state machine or crashes | The introduced path plus the resulting wrong state. Explicitly NOT this class: generic robustness wishing on unchanged code (see G2) |
| 7 | performance_efficiency | Unbounded accumulation/pileup; O(n^2) growth; hot-path recomputation introduced by the diff | Growth tied to an introduced loop/allocation with reasoning about realistic input sizes |
| 8 | documentation_drift | Changed docs/UI strings/help text contradicting the behavior the diff introduces, or omitting a qualifier the new behavior requires | Quote the changed string AND cite the contradicted behavior, both evidenced on the workspace |

Every pass ends the same way: candidates must survive Gates G1–G3 before entering the report list.

## Gates (apply to EVERY candidate before reporting)

- **G1 Scope discipline.** Report ONLY defects BOTH (a) clearly wrong on the reviewed workspace AND (b) inside the envelope's stated change scope. Real-but-out-of-scope issues are not findings — note nothing. Empty answer if none qualify.
- **G2 Nit suppression — do not report:** dead parameters; unused props/locals; dead-code consequences of the intended change; robustness speculation (missing `response.ok`-style guards, hypothetical null/network/env cases) unless the change itself seeds a concrete failure of that kind; test-harness coupling nits (CWD-dependent tests, runner config); malformed README tables/formatting/naming/import-order. All conditional: if the envelope scope explicitly puts such a class in scope, G2 yields. Boundary: G2 never suppresses (a) an identifier referenced by changed code but declared nowhere in the reviewed workspace — that is an api_contract finding (class 5), even if the workspace looks like a reduced stub; (b) an added mechanism that fails to cover one of its own trigger paths — that is a defect in the introduced mechanism, not a nit.
- **G3 Pre-existing gate.** branch_diff/uncommitted modes: verify each suspect condition against the base revision (e.g. `git show <base>:<file>`); do not report conditions already present there. Natural-language mode: restrict to files/hunks named in the change description. When age cannot be verified, decide by mechanism ownership: if the defective behavior lives inside code this change introduces or rewrites — including an added guard/check that fails to cover one of its own trigger paths, or a stated purpose it does not achieve — treat it as introduced; only untouched legacy code outside the changed mechanism counts as pre-existing.
- **G4 Clean conservatism.** When Pass 0 detected clean/validated-fix signals, high conservatism applies: empty answer unless a defect is unambiguously wrong on the fixture. G4 overrides any doubt-rule "report" tendency. When the envelope says 're-check <fixes>', that raises scrutiny OF THE NAMED FIXES themselves: report any defect found in or adjacent to the fixed surface; conservatism applies to unrelated candidates only.

## Completeness pass (before concluding CLEAN)

Confirm every changed line was examined including strings/UI copy/help text; walk each bullet of the change description against actual observed behavior; only then may an empty answer be emitted. A miss here is how real defects get missed. For each change-description bullet, verify the described behavior is achieved across ALL its trigger paths (every state transition, mode, or lifecycle event the bullet implies). Partial achievement of a stated bullet is a logic_correctness finding.

## Evidence and citation discipline

Every reported finding cites: file:line (or quoted hunk) on the reviewed workspace + one-sentence failure mechanism + trigger condition + why it is introduced-by-this-change (not pre-existing). At most one concise hypothesis per non-obvious finding. No reproduction beyond strictly read-only inspection; redact secrets/personal data from captured output. Never spawn further agents/reviews (recursion guard).

## Output

One structured finding per defect that survived every gate — or empty/CLEAN. No code-review scaffolding (no blocking/non-blocking tiers, no test-gap lists, no verdict lines).

Per-finding fields (openBuggy `reviewee.xml` compatible):

- **title**
- **file**
- **start_line** / **end_line**
- **category** — the class pass that produced the finding
- **severity** — high / medium / low
- **description** — failure mechanism + trigger condition
- **rationale** — why introduced-by-this-change

Host XML form: `<answer><bug>` elements carrying those fields; when nothing qualifies emit empty `<answer></answer>` — no bodies, no commentary. If the caller's envelope prescribes a different container, follow it exactly; this protocol defines WHAT may be reported — it never adds tiers or verdicts of its own.

Missing-test observations ride along inside a finding only when the gap hides the reported production risk; never as separate entries.

A reportable finding simultaneously satisfies: production impact (incorrect, unsafe, or likely to break users), introduced-by-change, in envelope scope, clear-on-workspace — the gates above enforce this; do not restate criteria as output sections.

Doubt rule placement: doubt about whether an in-scope production defect exists → report (unless G4 armed); doubt whether something is a nit/out-of-scope/pre-existing/speculative → do not report.

## Provenance

Adaptation inputs: openBuggy DSV4F M1–M5 census (bb-01..bb-05 pilot), BugBot finding-personality observation, mattpocock/skills code-review audit (pinned https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/code-review/SKILL.md).
