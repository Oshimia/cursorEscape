> **Imported research** — Source: openBuggy `docs/review/design-decisions.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Design Decisions & Project Intent

**Last updated:** 2026-08-16

This document is the **canonical record of project intent** for openBuggy while the repository is documentation-only. Implementation must not contradict these decisions without updating this file in the same change set.

---

## Context

openBuggy exists so the owner does not lose a Bugbot-shaped bug-finder gate when leaving Cursor (or if Cursor/Bugbot becomes unavailable). Most commercial alternatives optimize for async PR comments rather than a BYOK local agent loop. See [Roadmap](../Roadmap.md) and [market gap](../featureArchitecture/market-gap-and-positioning.md).

---

## Substance

### Stewardship and distribution

| Topic | Decision |
| ----- | -------- |
| **Primary operator** | Owner (single maintainer). Built for the owner’s agentic review loop, not a multi-tenant service. |
| **Repository posture** | Private-first. Documentation is the durable artifact until (and unless) a runtime is implemented. |
| **Future distribution** | Open source is **conditional** — only if the result is maintainable, scrubbed of private material, and worth supporting others. Not a commitment. License and remote hosting remain TBD until that gate. |
| **Monetization** | **Not a goal.** No hosted SaaS business, seat sales, GTM, “first customers,” or trademark-driven branding exercises. |

### Project decisions

| Topic                          | Decision                                                                                                                                                                                                                                                                       |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Project name**               | **openBuggy** (folder and display name).                                                                                                                                                                                                                                       |
| **Primary job**                | Find real bugs and high-value correctness/security/concurrency issues in a local diff; return machine-readable findings for agent fix loops.                                                                                                                                   |
| **Not the primary job**        | Style nits, docblock essays, PR summaries-as-product, or replacing human review.                                                                                                                                                                                               |
| **Deployment model (initial)** | Local-first engine. Hosted multi-tenant SaaS is out of scope.                                                                                                                                                                                                                  |
| **Keys**                       | **BYOK** — the owner supplies Anthropic/OpenAI/etc. API keys so inference cost and control stay with the operator. Conceptual env shape: [BYOK provider configuration (SOP)](../SOPs/byok-provider-configuration.md).                                                         |
| **Primary interfaces**         | CLI with structured JSON, then MCP. VS Code extension is a **thin client**, not the engine.                                                                                                                                                                                    |
| **Diff scopes**                | Support at least **branch vs base** and **uncommitted-only** modes (details in [diff-and-scope-model](../featureArchitecture/diff-and-scope-model.md)).                                                                                                                        |
| **Quality strategy**           | Multi-pass review + retrieval + eval harness over a single chat prompt. Optional hybrid static analysis later.                                                                                                                                                                 |
| **Eval corpus (v0)**           | **41** anonymized cases under `eval/cases/` (Phases 0–5 **Done** — Phase 4 run `2026-08-15T1540Z` net **+11.0**; Phase 5 public run `2026-08-16T0320Z` net **+12.0**). Public rows are **diversity/matrix** coverage — Phase 5 scored too easily (~93% P/R), likely public-source contamination; **Phase 6 synthetics must skew hard** for capability discrimination ([eval-phase-5-gap-report.md](../featureArchitecture/eval-phase-5-gap-report.md)). Scoring: Composer TEMP BugBot → promote → scorer; policy `scoring-policy-1.1`. Expansion: [eval-suite-expansion.md](../roadmaps/eval-suite-expansion.md). |
| **Cursor dependency**          | **None** for openBuggy runtime. v0 eval **benchmarks** against Cursor BugBot optionally.                                                                                                                                                                                       |
| **Engine language**            | **TBD at implementation** (Node vs Python open). Do not pretend a stack is chosen in this archive.                                                                                                                                                                             |
| **Dual-reviewer loops**        | openBuggy fills the **bug-finder** leg. A separate production-readiness reviewer (changeset completeness, architecture alignment, test gaps) remains complementary — inspired by sibling easyPeasyWebsite iterative review practice, documented here as external lineage only. |
| **Trademark / naming**         | “openBuggy” is a working name for a private concept archive. Revisit before any **public** release (e.g. OSS); non-blocking for docs.                                                                                                                                          |
| **Cursor Agent Review docs home** | Extensive behavioral characterization of Cursor’s local BugBot lives under [`featureArchitecture/cursor-bugbot-agent-review/`](../featureArchitecture/cursor-bugbot-agent-review/_index.md) as an **Observed external harness reference** (not proposed openBuggy runtime). Product/API/billing stays in [`research/bugbot-product-and-api-limits.md`](../research/bugbot-product-and-api-limits.md). Taxonomy rules: [documenting-this-concept-repo.md](../SOPs/documenting-this-concept-repo.md). |

### Non-goals (initial)

| Non-goal                                           | Rationale                                                                 |
| -------------------------------------------------- | ------------------------------------------------------------------------- |
| Monetization or productized SaaS                   | Private workflow preservation; no commercial offering or GTM.             |
| Replace human code review                          | AI review is a gate and assistant, not authority.                         |
| Ship PR-bot SaaS first                             | Agent-loop CLI/MCP is the design focus; PR integration can follow later.  |
| Match Bugbot via stolen/fine-tuned Cursor weights  | Impossible and unwanted; compete with process + eval + retrieval.         |
| Unlimited free hosted inference                    | BYOK keeps costs with the operator.                                       |
| Implement runtime in this documentation change set | Early eval corpus + harness docs may land before engine code.                                         |

---

## Implications / open questions

1. When implementation starts, pick engine language and record it here.
2. Decide license and remote hosting only if/when pursuing an optional public release (OSS).
3. Calibrate “APPROVED” / empty-findings bar for agent loops in [findings-schema-and-agent-contract](../featureArchitecture/findings-schema-and-agent-contract.md) during v0/v1.

---

## Related

- [Roadmap](../Roadmap.md)
- [Feature architecture index](../featureArchitecture/_index.md)
- [Documenting this concept repo (SOP)](../SOPs/documenting-this-concept-repo.md)
- [Reviewer-a / BugBot effectiveness (analysis)](../analysis/reviewer-effectiveness/_index.md)
