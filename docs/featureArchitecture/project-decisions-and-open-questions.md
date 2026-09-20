# Project Decisions and Open Questions

**Last updated:** 2026-09-20

## Context

This page records durable decisions that shape cursorEscape today and the small set of questions that remain genuinely open. It is not a changelog, migration history, or archive of superseded alternatives.

---

## Project decisions

### Stewardship and distribution

| Topic | Decision |
| --- | --- |
| Primary operator | The owner is the single maintainer and primary user. |
| Repository posture | Private-first. Distribution is considered only after a maintainability and private-material review. |
| Open source | Conditional. License, governance, and hosting remain undecided until that review. |
| Monetization | Not a goal. No hosted service, seats, sales motion, or general-market product. |

### Core identity

| Topic | Decision |
| --- | --- |
| Primary job | Maintain portable skills, agents, rules, workflows, and host projections for the owner's agentic loop. |
| Canonical source | Repo-root `workflow/`, `skills/`, `agents/`, and `rules/` own canonical prose; `catalog/` owns machine metadata. |
| Host posture | Seven registered stacks: Cursor, OpenCode, Antigravity, VS Code, Cline, Kilo Code, and Codex. |
| Replaceability | Hosts, models, and providers remain operationally replaceable through host adapters and owner-supplied keys; canonical workflow intent does not depend on a provider brand. |
| Model access | BYOK. The operator supplies model credentials and controls cost. |
| Product boundary | A workflow companion and synchronization manager, not an IDE, hosted runtime, agent platform, or general multi-tenant service. |
| Review model | Default-on plan review and dual implementation review, with isolation and evidence-backed verdicts. |
| Verification | Registry-owned projections, normalization Fast/Full CI, reusable host smoke scorecards, and explicit Apply authorization. |

### Non-goals

| Non-goal | Reason |
| --- | --- |
| General-purpose IDE | The product boundary is workflow contracts and projection, not editing chrome. |
| Hosted SaaS or multi-machine fleet management | The current owner workflow does not require tenant or fleet operations. |
| Provider lock-in | Canonical contracts stay model-agnostic; credentials and routing remain host/operator configuration. |
| A second procedure tree per host | Divergence and upkeep cost outweigh local convenience. |
| Speculative runtime APIs | Build host projections and verification for the actual workflow; introduce a runtime only when an owner decision establishes its need. |
| Automatic publication or push | Local commits and Apply are separate, owner-controlled boundaries. |

---

## Framework and process decisions

### Documentation architecture versus a documentation framework

**Decision:** retain the procedures-versus-design Markdown layout.

Markdown under `workflow/`, `docs/SOPs/`, `docs/featureArchitecture/`, and root contract trees is directly readable by humans and agents. A static-site or documentation framework would add build and template coupling without solving the current discovery or review problem. Revisit only if the owner needs generated public documentation.

### Assertion harness versus a general test framework

**Decision:** retain the fail-fast PowerShell assertion harness for normalization checks.

The current checks are deterministic repository and fixture assertions. They need strict ordering, clear failures, and registry context, not broad test-discovery machinery. Revisit only when test topology becomes too expensive to reason about locally.

### Exact-reference audits versus a third-party link checker

**Decision:** retain repository-local exact-reference and current-state checks as the blocking layer.

Generic link checkers can confirm URL syntax but do not understand frozen imports, managed blocks, required-reading contracts, or source-class boundaries. Revisit only for a narrowly scoped external URL health report; do not make it the semantic gate.

### Explicit operator Apply gates versus a migration framework

**Decision:** retain explicit dry-run, drift, Full CI, fresh authorization, all-host normative Apply, and post-Apply smoke gates.

A general migration framework would hide the safety boundary behind abstractions. Revisit only if the number of routine, repeatable migrations exceeds what explicit entry points can govern clearly.

### Research placement

**Decision:** retain durable imported research in `research/imported/`; keep large working outputs outside the repository.

Current-facing design belongs in architecture and procedure docs. `research/imported/` is a frozen evidence boundary, not active design. Revisit only for reproducibility artifacts that cannot live in an external or ignored workspace.

---

## Open questions

| Question | Current posture |
| --- | --- |
| Should target repositories have a local cursorEscape configuration area, and how should monorepo or multi-root workspaces be scoped? | Unknown. Until decided, narrow each task to one target workspace and one explicit diff scope; do not silently generalize. |
| Is a shared role-to-model-to-provider configuration schema worth maintaining across hosts? | Unknown. Host-specific assignment is acceptable while the registry owns contract identity. |
| Would generated repository indexes materially improve discovery enough to justify maintenance? | Unknown. Rely on `workflow/discovery.md` until a concrete recurring cost is demonstrated. |
| What license and hosting arrangement would apply if the repository is ever published? | Unknown and intentionally deferred until a distribution review is requested. |

Resolving a question requires a same-changeset update to the affected architecture page, contracts, tests, and this decision record.

---

## Related

- [Feature architecture index](./_index.md)
- [Skill source and host overlays](./skill-source-and-host-overlays.md)
- [Procedure registry](./procedure-registry.md)
- [Documenting this repo SOP](../SOPs/documenting-this-repo.md)
