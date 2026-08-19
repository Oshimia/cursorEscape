> **Imported research** — Source: AITestSuite `tests\ez-pz-streaming-media-phase-4\baseline\referenceFiles\SOPs\review-loop-model-profiles.md`; copied 2026-08-17 into cursorEscape. Status: Observed/eval-packaging. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Review loop model profiles

**Purpose:** Document which AI model each adversarial review subagent uses, how to swap between profiles, and the tradeoffs between them.

| Artifact | Role |
|----------|------|
| [.cursor/review-profiles/](../../.cursor/review-profiles/) | Frozen profile mirrors and swap script |
| [.cursor/review-profiles/activeProfile.json](../../.cursor/review-profiles/activeProfile.json) | Current active profile marker |
| [iterative-plan-review.md](./iterative-plan-review.md) | Plan review loop SOP |
| [iterative-code-review.md](./iterative-code-review.md) | Code review loop SOP |

---

## Active profile: Composer 2.5

**Default for all review subagents:** `composer-2.5` (not `composer-2.5-fast`).

| Subagent | Model |
|----------|-------|
| `plan-reviewer` (all passes) | `composer-2.5` |
| `reviewer-a` (all iterations) | `composer-2.5` |
| `bugbot` (all iterations) | `composer-2.5` |

Set the Task `model` parameter explicitly on every launch.

---

## Premium profile: alternating GPT/Opus

Archived at [.cursor/review-profiles/alternating-gpt-opus/](../../.cursor/review-profiles/alternating-gpt-opus/). Frozen from commit `98cca0fbcfe330102ab11210eed6260c639e4fc6`.

### Plan review rotation

| Review pass | Model |
|-------------|-------|
| 1 of 3 | `gpt-5.5-medium` |
| 2 of 3 | `claude-opus-4-8-thinking-medium` |
| 3 of 3 | `gpt-5.5-medium` |

### Code review rotation

| Review iteration | Reviewer A | Bugbot |
|------------------|------------|--------|
| Odd | `gpt-5.5-medium` | `claude-opus-4-8-thinking-medium` |
| Even | `claude-opus-4-8-thinking-medium` | `gpt-5.5-medium` |

### When to re-enable

- High-stakes database migrations or schema design
- Major architectural changes or new subsystems
- Explicit user request when API budget allows

---

## Accepted tradeoff (Composer 2.5)

The Composer 2.5 profile preserves:

- 3-pass adversarial plan review with synthesis and user gate
- Dual parallel reviewers (Reviewer A + Bugbot) with **different audit charters**
- CI gate, fix-all policy, per-phase boundaries, review iteration tracking

It **does not** preserve cross-model-family diversity (GPT vs Opus alternating perspectives). Reviewer A and Bugbot on the same model may share blind spots. Use the alternating profile when that diversity is worth the API cost.

---

## Swap procedure

### Using the swap script (recommended)

From repo root:

```powershell
# Switch to premium alternating profile
.\.cursor\review-profiles\swap-review-profile.ps1 -Profile alternating-gpt-opus

# Return to default Composer 2.5
.\.cursor\review-profiles\swap-review-profile.ps1 -Profile composer-2.5
```

The script reads `manifest.json` from the target profile, copies each archived file to its live path atomically (via temp directory), and updates `activeProfile.json`.

### Manual swap

Copy each file listed in the profile's `manifest.json` from the profile directory to its `live` path.

### Rollback via git

If the swap script is unavailable or the working tree is clean:

```powershell
git checkout HEAD -- .cursor/agents/plan-reviewer.md .cursor/agents/reviewer-a.md ...
```

**Warning:** `git checkout` discards uncommitted local edits to those paths.

---

## Profile directory layout

```
.cursor/review-profiles/
  activeProfile.json
  swap-review-profile.ps1
  alternating-gpt-opus/
    README.md
    manifest.json
    .cursor/...          # 8 mirrored artifacts
    referenceFiles/SOPs/...
  composer-2.5/
    manifest.json
    .cursor/...          # post-change mirror
    referenceFiles/SOPs/...
```

### manifest.json schema

```json
{
  "profileId": "composer-2.5",
  "sourceCommit": "<git sha when archived>",
  "archivedAt": "YYYY-MM-DD",
  "files": [
    { "archive": ".cursor/agents/plan-reviewer.md", "live": ".cursor/agents/plan-reviewer.md" }
  ]
}
```

---

## Updating model slugs

When Cursor adds or renames model slugs:

1. Update the active profile's 8 live artifacts (rules, agents, skills, SOPs) together.
2. Re-archive the `composer-2.5` profile mirror after changes land.
3. Update this SOP's model tables.

Do not silently substitute unavailable model slugs.

---

## Related

- [Iterative plan review](./iterative-plan-review.md)
- [Iterative code review](./iterative-code-review.md)
- [Alternating profile README](../../.cursor/review-profiles/alternating-gpt-opus/README.md)
