> **Imported research** — Source: openBuggy `docs/featureArchitecture/cursor-bugbot-agent-review/run-catalog.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Run Catalog (Evidence Appendix)

**Last updated:** 2026-08-04  
**Status:** Observed reference (Cursor Agent Review)

## Context

Fingerprinted BugBot runs grounding this suite. Rows are **modes, outcomes, and intensities only** — no secrets, no large diff hunks, no full prompts.

## Substance

### Fingerprint definition (locked)

A run counts only if **all** hold:

1. Parent Task uses `description: "Bugbot"` and `subagent_type: "bugbot"` (when parent tool metadata is available), **and**
2. Subagent first user message contains mission opener: `You are reviewing local code changes for bugs` (or equivalent harness marker)

Do **not** count transcripts that merely mention “bugbot” in prose (e.g. plan-reviewer discussing BugBot).

### Corpus

| Field                               | Value                                                                                                 |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------- |
| Project                             | easyPeasyWebsite                                                                                      |
| Transcript root (authoring machine) | `C:\Users\admin\.cursor\projects\c-Users-admin-source-repos-EZPZ-easyPeasyWebsite\agent-transcripts\` |
| Bias                                | Heavy iterative `implementation-review` Custom Instructions                                           |
| NL policy                           | This catalog includes ≥1 natural-language mode run                                                    |

### Catalog (≥8 fingerprinted runs)

| #   | Parent UUID                                      | Subagent UUID                                    | Mode             | ~Assistant turns | Custom Instructions theme                                        | Outcome (titles / CLEAN)                                                       | Category / severity           |
| --- | ------------------------------------------------ | ------------------------------------------------ | ---------------- | ---------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------ | ----------------------------- |
| 1   | [673cf81a](673cf81a-41fd-424a-9276-8fda415f864d) | [17bc9f41](17bc9f41-75ba-42cd-a8c7-9e120e9ceebc) | natural language | ~7               | Ignore unrelated dirty tree; Share modal mint gating / races     | Unintended mint on modal reopen; Stale mint error after leaving private embed  | SECURITY medium; LOGIC medium |
| 2   | [673cf81a](673cf81a-41fd-424a-9276-8fda415f864d) | [fd935f45](fd935f45-e043-446c-8751-4fa3c4c04465) | natural language | ~7               | Reopen race / late-mint invalidation                             | CLEAN                                                                          | —                             |
| 3   | [33ebcc6d](33ebcc6d-cba2-40cd-82cb-63b734d47da5) | [a08f99f3](a08f99f3-6233-40c4-85b8-4132655e6feb) | diff-injected    | ~13              | review-loop; Fast CI passed; migration grants / gen_random_bytes | CLEAN                                                                          | —                             |
| 4   | [429a3195](429a3195-9a20-492c-bff3-a1bfc9e4ad85) | [ad29cd21](ad29cd21-21e3-4b77-87fd-27787647cd11) | diff-injected    | (deep)           | Open-access security/correctness                                 | Pending enrollments get open access                                            | SECURITY                      |
| 5   | [429a3195](429a3195-9a20-492c-bff3-a1bfc9e4ad85) | [9a4010dc](9a4010dc-8716-4962-95c1-0a9c092ad659) | diff-injected    | ~22              | Phase 3 UI/docs focus                                            | Open access shown for platform courses; Helper text omits active enrollment    | LOGIC medium; LOGIC medium    |
| 6   | [429a3195](429a3195-9a20-492c-bff3-a1bfc9e4ad85) | [cb6112e5](cb6112e5-6900-4695-8d97-1a3cfa372aab) | diff-injected    | ~22              | Fresh review; open-access UI/API security                        | CLEAN                                                                          | —                             |
| 7   | [a4e1457e](a4e1457e-e638-4699-bfe2-33ecf3d4b6e9) | [d143b0d4](d143b0d4-0e23-440b-bea8-60468341bafd) | diff-injected    | ~9               | (minimal / empty UI in sample)                                   | merge_users custom roles FK violation; Stale employee platform_roles on bridge | LOGIC high; LOGIC high        |
| 8   | [c5d86381](c5d86381-0609-4b7f-8296-09dec84bb5e8) | [6f30508a](6f30508a-e58e-42d9-93d4-0089cd119a1c) | diff-injected    | ~17              | Re-check logout/stale atom                                       | Inbox repopulates atom after logout                                            | LOGIC medium                  |
| 9   | [c5d86381](c5d86381-0609-4b7f-8296-09dec84bb5e8) | [0f9826dd](0f9826dd-d110-4c9c-ad1f-fb31179481a8) | diff-injected    | ~20              | Unread indicator relocation iteration                            | CLEAN                                                                          | —                             |
| 10  | [0f2d8107](0f2d8107-991d-4907-9c4d-2d4bdedf1b20) | [70b0d3ea](70b0d3ea-22e2-4c99-8abf-fc70721ad3d6) | diff-injected    | ~29              | Phase 5; CI passed; auth/data leaks; workflow tests              | Workflow test title assertion invalid                                          | BUGBOT_RULES medium           |
| 11  | [09284069](09284069-b8f2-4746-83b4-551a2ce926f4) | [1710a420](1710a420-2b96-47b9-9560-b44c11526e6b) | diff-injected    | ~11              | Lesson progress UX; toggle races / SSR null                      | Optimistic toggle clobbered by fetches                                         | LOGIC high                    |
| 12  | [117dfa71](117dfa71-0619-45f9-ab3f-bd2ebb26b8bf) | [1eb3505a](1eb3505a-7a9a-4c3c-816c-3961a549e46c) | natural language | ~25              | Phase 5 docs-only                                                | Delete UI path omits SSO gate                                                  | DOCUMENTATION high            |

**Go/no-go:** ≥8 fingerprinted runs including NL mode — **met** (12 rows).

### Population note

The wider corpus contains hundreds of mission-opener subagent files; this table is a **representative sample** for documentation, not an exhaustive census.

### BUGBOT.md / effort check (**Observed** absence)

Phase 1 search: no `.cursor/BUGBOT.md` or effort-level directives inside fingerprinted mission-opener prompts in this corpus. See [unknowns-and-non-replicables.md](./unknowns-and-non-replicables.md).

## Implications / open questions

1. If openBuggy publishes this archive, anonymized cases live under [`eval/cases/`](../../../eval/cases/README.md); this catalog table may retain theme labels only.
2. Expand catalog when characterizing non-EZPZ parents (bare `/review-bugbot`).

## Sources

- Listed parent/subagent UUIDs (local Cursor agent transcripts)
- Fingerprint methodology: this document
- Primary source: local Cursor agent transcript / skill text (not independently re-verified via public URL)
