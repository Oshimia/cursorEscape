> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/follow-on-catch-escape/rubric.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this follow-on lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/follow-on-catch-escape/`; gitignored sheets (e.g. `.local/follow-on-sheet.json`, git-roots map) remain only in the openBuggy source repo. Do **not** create `.local/` under cursorEscape `docs/analysis/`. Path and closeout guidance below describes **openBuggy operator procedures**, not cursorEscape CI.
# Follow-on coding rubric

**Last updated:** 2026-08-16  
**Status:** Phase 2 — fields locked; fate re-raise and escape finding-list corpus applied

## Context

Finding-level fields for gitignored `.local/follow-on-sheet.json`. Does **not** add columns to the frozen Phase 3 sheet. Parent launch fields (`leg`, `iteration`, `outcome`, `fingerprint_ok`, `class`) are reused; fate and value are new.

## Substance

### Field glossary

| Field | Enum / type | Serves |
|-------|-------------|--------|
| `fate` | `gone` \| `persisted` \| `transformed` \| `unfixed` | What happened to **this** finding after implementer turns before the next same-leg launch (or through last launch if none) |
| `value` | `would-want` \| `optional-later` \| `disagree` | Operator judgment: would this have blocked ship? |
| `implementer_response` | `code` \| `test` \| `docs` \| `prose-only` \| `unknown` | What the parent actually changed |
| `fate_confidence` | `high` \| `medium` \| `low` | Single rater |
| `escape_hit` | bool | True only on a fuzzy hit in a later other-parent RA/BugBot **finding list** parsed from assistant output. Never full assistant prose, the recoded parent, user turns, or other subagents. Git never sets this alone. |
| `escape_evidence` | `transcript` \| `both` \| `none` | `both` = transcript hit plus git corroboration in the git window. Git-only matches are `none`. |
| `stratum` | `dual-coded` \| `bugbot-only` | Set at sample lock per parent |

Reuse from Phase 3 where present: `class`, `fingerprint_ok`. Do not copy `process_tp` or `wasted_fix` into follow-on rates.

### Fate protocol (implementer trace, not fuzzy titles)

For finding *F* on launch *N* of a given leg:

1. Read **parent** assistant/user turns **after** launch *N* returns and **before** launch *N+1* on the **same** leg (or through parent end if no later same-leg launch).
2. Note implementer edits (code / tests / docs) vs prose-only replies (“fixed”, rubber-stamp CLEAN).
3. Assign `implementer_response` from those turns, then `fate`:

| Fate | When |
|------|------|
| `gone` | The specific issue is addressed in the trace (edit matches the claim); later same-leg launch does not re-raise that issue |
| `persisted` | Same issue is still present in the next same-leg FINDINGS (or still visible in the remaining diff) with no material change |
| `transformed` | Partial or adjacent fix: some of the claim is addressed, a remnant or related gap remains |
| `unfixed` | No relevant edit; later CLEAN without a matching implementer change is **not** `gone` — prefer `unfixed` + `prose-only` or `unknown` + `fate_confidence: low` |

Do **not** set `gone` because a later launch on that leg was CLEAN. Do **not** use the **escape** fuzzy matcher as the fate rule.

**Phase 2 applied:** `implementer_response` from parent tool names after that launch’s Task. Re-raise = later same-leg finding title with ≥4 stem overlap (protocol step “later launch does not re-raise”). That is not the escape scan.

Last launch on a leg: code fate from remaining parent turns after that launch; if the parent ends, `unfixed` or `gone`/`transformed` from the trace only.

### Value labels

| Label | Meaning |
|-------|---------|
| `would-want` | Operator would treat this as blocking ship for this change (logic/security, misleading docs, this-change test regressions) |
| `optional-later` | Real but batchable (coverage wish-list, polish) |
| `disagree` | Would not have filed or would have dismissed |

`BUGBOT_RULES` and `process` **can** be `would-want` if the operator would block ship. Docs and tests are eligible for `would-want`. Overlapping legs: code **each finding once per launch**; do not collapse cross-leg duplicates into one row.

### Worked example A — `gone`

Launch N BugBot finding: nickname save races two writers. Parent then patches a lock in the save path (`implementer_response=code`). Launch N+1 BugBot is CLEAN or files unrelated titles only. **Fate:** `gone`. **Value:** typically `would-want`.

### Worked example B — `transformed`

Launch N Reviewer-a finding: add route tests for GET and POST on a resource. Parent adds tests for POST only (`implementer_response=test`). Launch N+1 Reviewer-a still lists GET coverage. **Fate:** `transformed` (not `gone`, not `persisted`). **Value:** `would-want` if GET was in this change’s contract; else `optional-later`.

### Escape fuzzy match (escape arm only)

A later-parent or git theme matches when **at least four** significant-word **stems** overlap with the original finding title/body (drop stopwords: a, the, of, on, in, for, and, to, with).

Worked non-match: original “stale employee platform role on bridge” vs later “employee platform roles leftover after merge”. Shared stems: `employe`, `platform`, `role` (**three**). `bridge` does not stem-equal `merge`; `stale` does not stem-equal `leftover`. **No match** (need four). Prefer over-reject vs the Phase 3 8-token exact matcher.

Do not use this rule for fate.

### Git skip

See [methodology.md](./methodology.md). If git is skipped, a transcript hit is still `escape_evidence=transcript`.

## Implications / open questions

1. Rubber-stamp CLEAN after `prose-only` stays `unfixed` unless the diff shows the fix.
2. Sheet schema must match this glossary; do not invent columns in `.local/` without amending this file.

## Sources

- [../coding-rubric.md](../coding-rubric.md)
- [./methodology.md](./methodology.md)
