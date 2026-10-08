# Sample: 2026-10-08-011631-cr-iter1-blockstart
Source file: rollout-2026-10-08T01-16-31-01a11794-d150-7601-a15b-a393302adade.jsonl

## Invocation envelope (parent payload)

```markdown
You are the `production_readiness_reviewer` agent.
Read `C:\Users\admin\source\repos\general-projects\cursorEscape\agents\production_readiness_reviewer.md` before acting.
Required reading:
- C:\Users\admin\source\repos\general-projects\cursorEscape\agents\production_readiness_reviewer.md
- C:\Users\admin\source\repos\EZPZ\curriculumConversion\.scratch\plans\2026-10-05-audio-workflow-buildout.md (Phase 2, 6, 7, and 8 sections)
- C:\Users\admin\source\repos\EZPZ\curriculumConversion\docs\roadmaps\audio-workflow-buildout.md (Phase 8 section)
- C:\Users\admin\source\repos\EZPZ\curriculumConversion\tools\audio\workflow\promotion.py
- C:\Users\admin\source\repos\EZPZ\curriculumConversion\tools\audio\workflow\cli.py
- C:\Users\admin\source\repos\EZPZ\curriculumConversion\tools\audio\tests\test_audio_workflow_promotion.py

Host alias: none
Isolation: clean-context
Authority: read-only
Loop/gate: review-loop

---

Host-injected AGENTS/environment content may precede this parent-authored payload; rely only on this envelope and required reads.

Repository: `C:\Users\admin\source\repos\EZPZ\curriculumConversion`
Task summary: Implement Phase 8 approval promotion, cache admission, replacement recovery, and cleanup for the audio workflow. Promotion must require complete current approvals/state and valid audio, stage only with explicit safeguards, atomically replace destinations, admit vocabulary payloads and complete-single generations only to their matching durable caches, persist a hash ledger, and provide journal/backup recovery. Tests must not write curriculum resources.
Plan phase: Phase 8 of 9. Prior Phases 0–7 are accepted by the orchestrator.
Review iteration: 1 of a fresh 4-iteration pressure-release block.
Cumulative production_readiness_reviewer launches for this phase: 1.
Completion gate: review-loop.
Review model: inherited host default.
Baseline: branch `main` at commit `a73b401 feat: add safe audio workflow regeneration`. At implementation start, `docs/roadmaps/audio-workflow-buildout.md` already had an orchestrator-owned uncommitted current-phase wording change. Treat that roadmap delta as outside this implementation review; do not require its inspection.
Phase-scope changed-file inventory (relative to implementation baseline):
- Added: `tools/audio/workflow/promotion.py`
- Modified: `tools/audio/workflow/cli.py`
- Added: `tools/audio/tests/test_audio_workflow_promotion.py`
Out of review scope: roadmap/plan status edits, Phase 9 documentation, task JSON, voice maps, curriculum Markdown/MP3s, commits, pushes, advanced lesson execution.
Observed Fast CI, parent-verified (mode: Fast; reviewers must not rerun CI):
- `python -m pytest tools/audio/tests/test_audio_workflow_promotion.py tools/audio/tests/test_audio_workflow_cache.py -q --basetemp=.audio-workflow/tmp/phase8-fast`: pass (56 tests)
- `python -m compileall -q tools/audio`: pass
- `git diff --check`: pass
Supplemental pre-review audio workflow suite, not a substitute for the required Fast gate:
- `python -m pytest tools/audio/tests -q --basetemp=.audio-workflow/tmp/phase8-prereview`: pass (194 tests)
Temporary pytest roots were removed after the runs.

Return only your complete production-readiness report in the exact required structure. Do not edit, run CI, install, commit, push, spawn agents, or rely on prior review transcripts.
```

## Reviewer output(s)

---

## Verdict
CHANGES REQUESTED — the phase exceeds the plan’s non-waivable 1,000-line split threshold, recovery does not fully enforce path containment, and required promotion safeguards lack focused regression coverage.

## Blocking findings
1. **Phase 8 exceeds the mandatory phase-size gate.** The plan defines hand-authored changed/added lines as including production code and tests, requires splitting above 800 lines, and says exceeding 1,000 lines is always split without a waiver (`C:\Users\admin\source\repos\EZPZ\curriculumConversion\.scratch\plans\2026-10-05-audio-workflow-buildout.md:189-194`, `:211`). The reviewed changeset contains 741 lines in `tools\audio\workflow\promotion.py`, 455 in `tools\audio\tests\test_audio_workflow_promotion.py`, and 76 added lines in `tools\audio\workflow\cli.py` — 1,272 total lines and 1,132 non-blank lines. Concrete failure: the phase cannot satisfy the accepted plan’s non-waivable review/process gate, reducing the effectiveness of the pressure-release review boundary. Required correction: split Phase 8 into explicitly bounded sub-slices with separate scoped diffs and review launches, or obtain an owner-approved plan amendment; an ordinary size waiver is insufficient for the plan’s always-split-over-1,000 rule.
2. **Promotion recovery trusts unbounded paths from a locally mutable journal.** `promotion.py:232-257` validates journal field shapes and hashes but not containment or expected relationships. Recovery then resolves `candidate_manifest`, `destination`, decision, state, backup, and vocabulary payload paths directly from journal fields (`promotion.py:693-712`, `:719-727`; `_restore_backup` at `:669-679`; `_vocabulary_payload_path` at `:401-407`). Concrete failure: a tampered or incorrectly reused ignored journal can point `backup_path` and `destination` outside the repository; `_restore_backup` could copy attacker-controlled bytes over that destination if the recorded hash matches. Required correction: require the journal itself and every referenced workflow path to resolve inside its declared root; record the staging root for staging promotions; require production destinations to equal the canonical task output; require backups beneath `WORK/promotion/backups`; and verify candidate/decision/state paths match the recovery invocation and task identity before any restore or admission.
3. **The retained-cache promotion admission branch is untested.** `promotion.py:451-463` reuses an existing vocabulary cache when `retained_audio_sha256` differs from the WAV assembly hash, validates the cache delivery hash, and reports `reused_existing`. The new promotion tests cover new cache writes and replacement (`test_audio_workflow_promotion.py:248-275`, `:308-327`) but never exercise this retained-cache reuse or mismatch branch. Concrete failure: a regression could reuse bytes with the wrong delivery hash or silently transcode/replacing an already retained cache entry, violating the Phase 8 reuse boundary. Required correction: add promotion-level fixtures proving (a) a valid retained cache is reused without invoking FFmpeg and records the retained delivery hash, and (b) a retained-hash mismatch raises `CacheAdmissionError` without replacing cache or destination.

## Non-blocking findings
1. **`_transcode_vocabulary_payload` has an incorrect return contract.** The annotation says `tuple[bytes, dict[str, Any], Prober | None]`, but the implementation returns only the MP3 bytes (`promotion.py:410-428`). Concrete failure: static type checking and future callers will receive a false tuple-shaped contract. Required correction: change the return annotation to `bytes`.

## Architecture alignment
The implementation largely follows the accepted architecture: separate promotion logic, typed cache stores, exact identity/hash admission, atomic JSON/audio writes, explicit production guards, journals, backups, staging beside destinations, and a thin CLI surface align with the plan. The oversized phase and recovery path-containment violation are architecture/process blockers reflected above. Durable CLI documentation remains intentionally deferred to Phase 9 and is not treated as unresolved supersession.

## Supersession closure
- **Workflow promotion/recovery surface; superseded surface: prior “promotion not implemented / `promoted` unavailable” boundary; disposition: Updated; evidence/action:** `promotion.py:575-741` and `cli.py:260-311` establish the current promotion/recovery model. Durable usage guidance remains deferred to the approved Phase 9 documentation phase.
- **README promoted-state claim; superseded surface: `tools\audio\README.md:163-164`; disposition: Retained; evidence/action:** the claim is now stale but Phase 9 explicitly owns durable workflow documentation (`plan:951-985`). Keep it only through the planned Phase 9 pass, then update it to describe promotion, recovery, and cleanup.
- **Durable cache admission; superseded surface: existing Phase 2 cache APIs; disposition: Retained; evidence/action:** `promotion.py:431-495` composes the existing separate stores rather than introducing a parallel cache mechanism.

## Lifecycle and naming closure
- **Promotion/recovery machinery; classification: Durable; fulfillment status: Ongoing; name assessment: Responsibility-based; disposition/action:** retain `promotion`, `recover`, journal, ledger, and cache-admission responsibilities, but split them under the required size gate.
- **Promotion journal and ledger schemas; classification: Durable; fulfillment status: Ongoing; name assessment: Responsibility-based; disposition/action:** retain versioned schemas and add the missing path/relationship validation before approval.
- **Cache-entry replacement backup; classification: Transitional; fulfillment status: Ongoing; name assessment: Phase/provenance-based; disposition/action:** it is removed after successful replacement (`promotion.py:383-398`), but rename it to a responsibility-based temporary name during the required split and ensure crash-orphan cleanup policy is explicit.
- **Focused promotion tests; classification: Durable; fulfillment status: Ongoing; name assessment: Responsibility-based; disposition/action:** retain and extend them after splitting the phase.

## Regression matrix
| Behavior at risk | Result | Evidence |
|---|---|---|
| Missing/stale approvals block promotion | PASS | `promotion.py:135-173`; `test_audio_workflow_promotion.py:218-245` |
| Current workflow-state/planning fingerprint guard | UNTESTED | Guard exists at `promotion.py:159-173`; no promotion test mutates task fingerprint, record plan hash, or workflow plan snapshot/hash |
| Staging/production CLI guards | PASS | `cli.py:252-289`; `test_audio_workflow_promotion.py:243-245`, `:426-455` |
| Atomic destination replacement and cleanup | PASS | `promotion.py:321-335`, `:630-650`; `test_audio_workflow_promotion.py:248-275` |
| Idempotent re-promotion and single-cache admission | PASS | `promotion.py:625-655`; `test_audio_workflow_promotion.py:281-300` |
| Vocabulary cache admission and replacement | PASS | `promotion.py:338-398`, `:431-495`; `test_audio_workflow_promotion.py:248-275`, `:308-327` |
| Retained-cache reuse/mismatch admission | UNTESTED | Branch exists at `promotion.py:451-463`; no focused promotion test found |
| Cache type/corruption boundary | PASS | `promotion.py:338-368`; `test_audio_workflow_promotion.py:401-423` |
| Recovery after successful replacement | PASS | `promotion.py:682-741`; `test_audio_workflow_promotion.py:330-369` |
| Recovery restores mismatched destination | PASS | `promotion.py:669-718`; `test_audio_workflow_promotion.py:372-398` |
| Recovery path containment | FAIL | Journal paths are used without declared-root validation (`promotion.py:693-727`, `:669-679`, `:401-407`) |
| Curriculum-resource isolation in tests | PASS | Promotion fixtures use `tmp_path` as repository root (`test_audio_workflow_promotion.py:121-150`, `:196-215`) |

## Blocking test/docs
1. Add focused retained-cache reuse and retained-hash mismatch tests as described in Blocking finding 3.
2. Add stale workflow-state fingerprint, stale record plan hash, and stale workflow plan snapshot/hash tests that prove promotion rejects each condition before journal creation or destination mutation.
3. Add recovery path-containment and journaled-path relationship tests covering out-of-root candidate/decision/state/backup/destination values and staging-versus-production destination expectations.

## Batchable (deferred)
None

## CI gate status
(parent-reported; not rerun)
- ci mode: Fast
- `python -m pytest tools/audio/tests/test_audio_workflow_promotion.py tools/audio/tests/test_audio_workflow_cache.py -q --basetemp=.audio-workflow/tmp/phase8-fast`: pass
- `python -m compileall -q tools/audio`: pass
- `git diff --check`: pass
- Supplemental `python -m pytest tools/audio/tests -q --basetemp=.audio-workflow/tmp/phase8-prereview`: pass

