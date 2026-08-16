# Analysis documentation

**Last updated:** 2026-08-17

## Context

Operator studies of **local workflows** (not proposed engine design, not eval scoring, not market research). Each study has its own subdirectory with a hub `_index.md` when imported or authored.

**Status:** Phase 2 imports landed — closeout pending review loop + Full CI.

---

## Substance

### Content boundaries

| Location | Responsibility |
| -------- | -------------- |
| `docs/analysis/*` (future local studies) | Decision-grade studies of the owner's existing loops |
| [`../research/imported/openBuggy/analysis/`](../research/imported/openBuggy/analysis/_index.md) | Imported openBuggy operator studies (Observed/imported) |
| [`../featureArchitecture/`](../featureArchitecture/_index.md) | Target system design (Phase 4+); Observed openBuggy FA under `research/imported/openBuggy/featureArchitecture/` |
| [`../research/`](../research/_index.md) | Sourced market/product facts |

### Documents (imported openBuggy)

* [Reviewer-a / BugBot effectiveness](../research/imported/openBuggy/analysis/reviewer-effectiveness/_index.md) — dual-reviewer loop study (Phases 1–5 complete in source archive)
* [Catch + escape follow-on](../research/imported/openBuggy/analysis/reviewer-effectiveness/follow-on-catch-escape/_index.md)

---

## Implications / open questions

1. UUID/path coding sheets stay gitignored under study `.local/` directories in source repos — not copied here.
2. Do not treat eval harness scores as live-loop outcomes.

---

## Related

- [Design decisions](../review/design-decisions.md)
- [Documenting this repo (SOP)](../SOPs/documenting-this-repo.md)
- [Roadmap](../Roadmap.md)
- [COPY-MANIFEST](../research/imported/COPY-MANIFEST.md)
