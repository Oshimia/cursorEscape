---
name: review-subagent-models
description: Pointer file — recommended reviewer/plan-reviewer model slugs are Cursor-native and live in the companion. Never synced to host.
---

# Review subagent models (VS Code harness)

Pointer-only. Never copied to `~/.copilot` by the sync harness.

Recommended `plan_reviewer` model per pass: `{{COMPANION_ROOT}}/overlays/cursor/review-subagent-models.md` (Cursor-native slugs).

VS Code note: `.agent.md` supports a `model` frontmatter field (single name or fallback array). Models are host-config-specific and BYOK; the vscode overlay leaves `model` unset (chat picker default) pending owner decision (unresolved architectural question U13). Set per-agent explicitly only when the owner assigns one.
