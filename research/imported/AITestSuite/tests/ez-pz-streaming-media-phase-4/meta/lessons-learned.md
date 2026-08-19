> **Imported research** — Source: AITestSuite `tests\ez-pz-streaming-media-phase-4\meta\lessons-learned.md`; copied 2026-08-17 into cursorEscape. Status: Observed/eval-packaging. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Lessons learned — why Phase 4 is a strong AI benchmark

Derived from the real easyPeasyWebsite Phase 4 implementation ([agent transcript 530e8776](530e8776-21cc-446d-8ac4-e7d51a2c062c)): **6 review iterations**, multi-surface spinner/error bugs, VTT misclassification, and a 298-line new test file.

## What makes it hard

1. **Harder than Phase 2** — 6 review iterations vs Phase 2's 4; 7 files across 3 admin surfaces plus a child section component.
2. **Blob/stream split in one component** — `AssetCard` runs both `useCdnBlobUrl` (images) and `useCdnStreamUrl` (video/audio); easy to migrate everything or nothing.
3. **VTT edge case** — Subtitle `.vtt` files are not streamable media; showing "Load failed" is wrong UX (iteration 2 finding).
4. **Spinner/error interaction** — Three separate infinite-spinner bugs across VideoEditor, AudioEditor, and AssetCard (iterations 4–6).
5. **Pattern replication required** — Must read Phase 3 `SelfHostedVideoPlayer`/`AudioBlock` patterns; inventing new UX creates review churn.
6. **Large new test file** — `AssetCard.test.jsx` is ~298 lines / 9 tests; thin editor-only tests are insufficient (iteration 1 test gap).
7. **Playback recovery wiring** — `useStreamPlaybackRecovery` must be integrated in AssetCard and editors with retry UI and remount keys.
8. **Preview unavailable states** — Editors and SelfHostedVideoSection need explicit UX when CDN URL cannot be built.

## Comparison to other streaming phases

| Phase | Iterations | Primary trap |
|-------|------------|--------------|
| Phase 2 | 4 | Hook lifecycle / ESLint |
| Phase 3 | 5 | Playback error false positive / token-wait spinner |
| Phase 4 | 6 | Multi-surface UX / blob-stream split / VTT |

## Autonomy failure modes

- Asking whether VTT files should stream (read MIME type handling in baseline AssetCard)
- Migrating images to stream URLs
- Modifying shared hooks instead of fixing consumer-side spinner gating
- Skipping `AssetCard.test.jsx` creation
- Strong autonomous target: **0–1 stops**

## Review iteration history

| Iter | Key fix |
|------|---------|
| 1 | Initial migration; missing tests, playback/VTT gaps |
| 2 | AssetCard renderPreview errors; VTT file icon; SelfHostedVideoSection unavailable |
| 3 | Editor preview-unavailable + playback tests; `key={streamUrl}` |
| 4 | Editor infinite spinner on token failure |
| 5 | AssetCard infinite spinner on token failure |
| 6 | Consumer error gating aligned with deferred hook errors |

## What separates good submissions

- Reads Phase 3 learner implementations first
- Creates comprehensive `AssetCard.test.jsx` upfront
- Correctly splits blob (images) vs stream (video/audio) in AssetCard
- Handles VTT as file icon
- Gates spinners on error states from the start
- Wires playback recovery consistently across all three surfaces
- Does not touch hooks or learner blocks

## Reference commits

| Role | Commit | Label |
|------|--------|-------|
| Baseline | `915fbd7` | Phase 3 complete |
| Target | `6c30f04` | Phase 4 complete |

## Metrics (frozen)

| Metric | Baseline | Target |
|--------|----------|--------|
| Frontend tests | 1063 | ≥ 1079 |
| Backend tests | 345 | ≥ 345 |

## Known traps (see REMEDIATION_CHECKLIST.md)

A1 VTT misclassification, A3/A4 infinite spinner, A6 streamPreviewError, A10 missing AssetCard tests, A13/A14 blob-stream boundary.
