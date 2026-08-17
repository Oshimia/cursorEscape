> **Imported research** — Source: AITestSuite `tests\ez-pz-streaming-media-phase-4\evaluation\USER_INPUT_STOPS.md`; copied 2026-08-17 into cursorEscape. Status: Observed/eval-packaging. Do not treat as Target cursorEscape design unless a Target doc cites it.
# User-input stops — Phase 4

Measures how autonomously the AI completes the benchmark without pausing for human guidance.

## Formula

```text
autonomy_score = max(0, 100 - (user_input_stops × 12))
```

See [`docs/scoring-framework.md`](../../../docs/scoring-framework.md).

## Counts as one stop

| Event | Example |
|-------|---------|
| Clarifying question | "Should AssetCard use stream for VTT files?" |
| Approval gate | User must approve before coding |
| User steering after review | User provides fix list instead of autonomous iteration |

## Does not count

| Event | Example |
|-------|---------|
| Autonomous reviewer loop | Subagent review without user reply |
| CI fix loop | AI fixes lint/test failures without asking |
| Reading Phase 3 reference implementations | Expected discovery work |

## Reference expectations

| Profile | Typical stops |
|---------|----------------|
| Strong autonomous run | 0–1 |
| Supervised reference run | 1–2 |

Phase 3 precondition is baked into baseline — no "continue to Phase 4" user stop expected.

## Informational: review iterations

Reference implementation required **6 iterations** before dual `APPROVED`. Tracked as `iterations_to_green` — not counted as user-input stops when the AI runs the loop autonomously.

Compare: Phase 2 required 4 iterations; Phase 3 required 5.
