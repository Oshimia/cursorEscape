> **Imported research** — Source: AITestSuite `tests\ez-pz-streaming-media-phase-4\REVIEW_LOOP.md`; copied 2026-08-17 into cursorEscape. Status: Observed/eval-packaging (test-scoped prompts; NOT portable process). Do not treat as Target cursorEscape design unless a Target doc cites it.
# Phase 4 — mandatory review loop

**Candidate-facing.** Run this after your first implementation pass and CI gate — not optional.

A first-pass implementation that passes lint/tests is often not production-ready. **Do not declare done until both reviewers return `APPROVED`.** Address every finding the reviewers report — derive remedies from reviewer output, baseline docs, and Phase 3 reference implementations.

---

## Workflow

1. **Implement** Phase 4 per `PROMPT.md`.
2. **Run CI gate** — all four commands green.
3. **Launch Reviewer A** — use the prompt below.
4. **Launch Bugbot** — use the prompt below in parallel or immediately after Reviewer A.
5. If either returns **`CHANGES REQUESTED`**: fix **every** blocking, non-blocking, and test-gap item; re-run CI; go to step 3 with the **full prompts**.
6. Repeat until **both** reviewers return **`APPROVED`** with Blocking, Non-blocking, and Test gaps all literally `"None"`.
7. Run CI one final time.

```text
Implement → CI → Reviewer A + Bugbot → fix all findings → CI → re-review → … → APPROVED
```

**Autonomy:** Running this loop yourself does **not** count as a user-input stop.

**Out of scope:** Phase 5 SSR prefetch, Phase 6 docs, learner block changes, hook rewrites.

---

## Reviewer A prompt

```text
You are Reviewer A performing a production readiness review of Phase 4 admin media preview streaming migration in the candidate workspace.

Review ALL changes from baseline. Read SelfHostedVideoPlayer.jsx, AudioBlock.jsx, useCdnStreamUrl.js, useStreamPlaybackRecovery.js, and referenceFiles/SOPs/how-to-implement-media-content-blocks.md.

Return ALL findings — blocking AND non-blocking. Do not summarize or omit items.

Verdict APPROVED is ONLY valid when Blocking findings, Non-blocking findings, and Test gaps are all literally "None".

Use this exact output structure:

## Verdict
APPROVED | CHANGES REQUESTED (with reason)

## Blocking findings
(numbered list; write "None" if empty)

## Non-blocking findings
(numbered list; write "None" if empty)

## Architecture alignment

## Regression matrix
PASS/FAIL/UNTESTED with evidence

## Test gaps
(numbered list; write "None" if empty)

## Commands run
List exact pass/fail for all four CI-parity commands.

Run the four CI commands yourself and report results.
```

---

## Bugbot prompt

```text
Full Repository Path: <candidate workspace>
Diff: all changes from baseline
Custom Instructions: Phase 4 admin preview streaming — VideoEditor, SelfHostedVideoSection, AudioEditor, AssetCard. Video/audio must use useCdnStreamUrl (no blob fetch). Images must stay on useCdnBlobUrl. VTT/subtitle files must not show Load failed. Flag: infinite spinner on token failure, missing playback recovery, missing preview-unavailable UX, blob fetch for video/audio, image migration to stream, learner block regressions, missing AssetCard.test.jsx.

Phase 5+ OUT OF SCOPE.

Return ALL findings. APPROVED only when Blocking, Non-blocking, Test gaps all "None".

## Verdict
## Blocking findings
## Non-blocking findings
## Security and correctness
## Regression matrix
## Test gaps
```

---

## Done criteria

- [ ] All four CI commands green (final run)
- [ ] Reviewer A: **APPROVED**
- [ ] Bugbot: **APPROVED**
- [ ] Deliverables checklist in `PROMPT.md` satisfied
