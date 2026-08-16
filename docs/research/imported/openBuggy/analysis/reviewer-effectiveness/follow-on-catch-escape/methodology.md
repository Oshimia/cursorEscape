> **Imported research** — Source: openBuggy `docs/analysis/reviewer-effectiveness/follow-on-catch-escape/methodology.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
> **cursorEscape import adaptation** — Authored for the **openBuggy** repo layout. In cursorEscape this follow-on lives under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/follow-on-catch-escape/`; gitignored sheets (e.g. `.local/follow-on-sheet.json`, git-roots map) remain only in the openBuggy source repo. Do **not** create `.local/` under cursorEscape `docs/analysis/`. Path and closeout guidance below describes **openBuggy operator procedures**, not cursorEscape CI.
# Follow-on methodology

**Last updated:** 2026-08-16  
**Status:** Phase 1 lock still applies; Phase 2 recovery: variant Reviewer-a openers (`Completion gate: review-loop` or `Full Repository Path` without the BugBot bug-review sentence) are coded as Reviewer-a with `fingerprint_ok` false.

## Context

How this follow-on counts findings, catch rates, and escapes. Inherits fingerprints, UUID barrier, dual-leg predicate, and “eval is not an outcome” from [parent methodology](../methodology.md). Overrides **only** launch triage on deep-sample parents and the **escape-scan window**.

## Substance

### Claim legend

Same as parent: **Observed** / **Inferred** / **Unknown**.

### UUID barrier

**In openBuggy (source repo):** committed files under `docs/analysis/` must not contain parent/subagent UUIDs, absolute machine paths, home-directory skill paths, or product/customer strings. Those live only in gitignored `.local/` in the openBuggy source repo (`follow-on-sheet.json`, git-roots map) — **not copied to cursorEscape**. In cursorEscape, read committed prose under `docs/research/imported/openBuggy/analysis/reviewer-effectiveness/follow-on-catch-escape/` only.

### Eval harness is not ground truth

Do not use `eval/cases/` expected XML or scorer nets as catch or escape confirmation.

### Docs and tests

Docs and tests are **high value**. They may be labeled `would-want`. They are not “waste.”

### Deep-sample census (supersedes Phase 3 triage)

On parents locked in [sample.md](./sample.md), code **every** Reviewer-a and BugBot launch, including Phase 3 `sampled_out` rows. Do not inherit under-counting into catch-rate denominators or fate timelines.

Phase 3 triage kept all non-CLEAN launches plus first and last CLEAN; middle CLEAN were `sampled_out`. Expected: most `sampled_out` rows are empty CLEAN (few new findings). Still include them in the **launch census**. If any FINDINGS launch was `sampled_out`, it enters finding denominators.

Phase 2 **opens** in this order: (1) Reviewer-a UUID recovery for S03/S09/S13 or document drop from dual-leg rates; (2) launch-count reconciliation vs the parent Task list (Reviewer-a + BugBot only); (3) apply [sample.md](./sample.md) slot lock. Other subagents stay out of scope.

**Phase 2 applied (recovery):** parent Tasks existed; FIFO `task_id` mapping was empty (no Await). Files were recovered from variant openers. S09 RA file count stayed below parent Task count → **excluded from dual-leg catch rates**.

**Phase 2 applied (escape corpus):** later-parent Reviewer-a / BugBot **finding lists** parsed from assistant output. Full assistant blobs (architecture matrices) over-matched; finding lists are the scorable assistant findings. Recoded parent file excluded. Later parents require `mtime > escape_anchor` (dual-clean clock), not recoded-parent JSONL mtime.

The frozen Phase 3 sheet is **not** mutated. **In openBuggy**, new coding lives in `.local/follow-on-sheet.json` (source repo only; not in cursorEscape).

### Catch-rate metrics (locked)

Unit: **finding** on the follow-on **rate set** (Phase 2: 3 Task-reconciled parents — not Phase 3’s 369). Phase 1 planned 4–6; reconciliation dropped unreconciled defaults.

**Strata (always report separately):**

- **Dual-leg:** parents with both legs coded after Reviewer-a recovery.
- **BugBot-only:** gap slots kept for BugBot fate only if Reviewer-a recovery failed (not in the dual-leg catch rate).

**Primary catch (would-want):**

- Numerator: `value=would-want` and `fate=gone`.
- Denominator: `value=would-want` and fate in `{gone, persisted, transformed, unfixed}`.
- Also report `transformed` as a share of the denominator (partial address, not full catch).

**Over-fix (disagree):**

- Numerator: `value=disagree` and implementer response in `{code, test, docs}` (a change landed).
- Denominator: all `value=disagree` findings.

**Optional-later:** counts only; do not fold into primary catch.

**Parent-level supplement (not a substitute):** share of dual-leg parents whose last coded launch on each leg is CLEAN.

**Follow-on Phase 3** angle rewrites (parent-study catch/escape papers) must **keep** 15 / 182 / 369 as the census layer and add a labeled “follow-on deep sample (n parents / n findings)” using these formulas. Do not treat this sentence as a gate before follow-on Phase 2 recode.

### Escape scan (this follow-on)

**Escape anchor** (start of the **later-parent transcript** window only — **not** the git skim):

- **Dual-coded** parents: timestamp of the **last dual-clean** (both legs last coded launch CLEAN).
- **BugBot-only** gap slots: timestamp of the **last CLEAN on the coded BugBot leg** (there is no dual-clean). Do not skip the transcript escape arm for these slots.

**Clock (locked):** the escape anchor is a single instant:

- **Dual-coded:** the **later** of the two last-CLEAN launch artifacts’ file mtimes (Reviewer-a subagent file vs BugBot subagent file). If a subagent file mtime is missing, use the parent transcript mtime of the turn that recorded that CLEAN.
- **BugBot-only:** last CLEAN BugBot subagent file mtime (same fallback).

Later dual-leg parents are **other** parent JSONL files in the same alias (different file from the recoded parent). Count only if **parent-file mtime > escape anchor**. **Exclude the recoded parent** even if that file’s mtime moves after dual-clean (closeout turns in the same thread are fate, never `escape_hit`). Cap at **15** such later parents (mtime order). This **supersedes** the parent study’s Phase 3 “up to 5” scan **for this follow-on only**.

Search **only** later-parent Reviewer-a and BugBot **finding lists parsed from assistant output** (titles / bullets). Do not use full assistant prose (architecture matrices over-match). Do not scan the recoded parent, user turns, or other subagents for `escape_hit`.

Every finding on a FINDINGS launch in the deep sample gets `escape_hit` / `escape_evidence` (CLEAN launches have zero findings). Match later-thread themes with the **fuzzy** rule in [rubric.md](./rubric.md).

**Git window (locked):** do not start git at the escape anchor. Git **does not** create `escape_hit` by itself.

- `--since` = mtime of the **first later dual-leg parent** in the same alias (the first of the up-to-15). If there is no later dual-leg parent, **skip git**.
- `--until` = HEAD at coding time.
- Code `escape_hit=true` only from a **transcript** fuzzy hit in one of those later parents. If git also fuzzy-matches the same theme in this window, set `escape_evidence=both`; otherwise `transcript`. Git-only theme matches (including same-parent closeout commits that land after another chat started) are **not** escapes (`escape_hit=false`, `escape_evidence=none`).

**Evidence class:** `transcript` / `both` / `none` (no git-only).

**Git skip (mechanical):** do not run or do not credit git when any of:

1. Alias has no mapped repo root in `.local/` git-roots map.
2. Finding cites no path, or the path is not in that parent’s implementer diff.
3. Noise: more than **20** commits on that path in the window with **no** fuzzy theme hit in commit subjects/bodies — record `transcript` or `none`, not a git escape.
4. No later dual-leg parent in the alias (git `--since` undefined).

Do not read the entire `website-primary` tree. Do not treat production incident logs as in-scope.

### Layering

Do not replace parent-study funnel numbers. Label follow-on rates as the **Phase 2 rate set** (3 Task-reconciled parents / 66 launches / 74 findings). State **zero `accounts` parents**. Extra recovered parents in `.local/` are vignettes, not in that n.

## Implications / open questions

1. Unreconciled defaults (S12, S15) and partial S09 are vignettes; dual-leg rates are S01, S02, plus reconciled WP gap **S13** (not the default four).
2. Git skip may leave escape evidence as `transcript` / `none`; do not over-claim rarity.

## Sources

- [../methodology.md](../methodology.md)
- [../coding-rubric.md](../coding-rubric.md)
- [./rubric.md](./rubric.md)
- [./sample.md](./sample.md)
