# review (Kilocode overlay — dual review)

---
description: Run the dual-gate review loop (Fast CI → production_readiness_reviewer + bug_reviewer ≤4 iterations → Full CI)
---

Loop per `{{COMPANION_ROOT}}/workflow/iterative-code-review.md`. Observa Fast CI first; then parent-conducted serial reviewer passes (adopt `production_readiness_reviewer` then `bug_reviewer` personas from `{{COMPANION_ROOT}}/agents/*`; platform `subtask`/subagent support is unproven — do not rely until attested at smoke). ≤4 dual iterations per block; dual APPROVED → Full CI only. Empty/instant review returns are routing failures — fail loud.
