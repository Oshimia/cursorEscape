# review (Kilocode overlay — dual review)

---
description: Run the dual-gate review loop (Fast CI → production_readiness_reviewer + bug_reviewer ≤4 iterations → Full CI)
---

Loop per `{{COMPANION_ROOT}}/workflow/iterative-code-review.md`. Observe Fast CI first; then use fresh Kilo task/session isolation for each reviewer leg until attested `subtask` isolation is available. Launch `production_readiness_reviewer` first, record only its findings/verdict for the loop parent, then launch `bug_reviewer` in a new task/session without Reviewer A text. Begin each payload with the canonical envelope at `{{COMPANION_ROOT}}/workflow/agent-invocation.md`, followed by `---`, an attestation marker, and that reviewer's complete scoped inputs. ≤4 dual iterations per block; dual APPROVED → Full CI only. Empty/instant review returns are routing failures — fail loud.
