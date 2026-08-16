> **Imported research** — Source: openBuggy `docs/featureArchitecture/cursor-bugbot-agent-review/finding-personality.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Finding Personality

**Last updated:** 2026-08-04  
**Status:** Observed reference (Cursor Agent Review)

## Context

“BugBot quality” is as much about **what it refuses to report** as what it catches. This doc summarizes Observed finding personality from the fingerprinted catalog and mission rules.

## Substance

### Mission personality (**Observed**)

| Bias                        | Effect                                                                         |
| --------------------------- | ------------------------------------------------------------------------------ |
| Recall over precision       | “Missed bug is far more costly than a false positive”; “when in doubt, report” |
| Production impact filter    | Must be incorrect, unsafe, or likely to break users                            |
| Introduced-by-change filter | Skip pre-existing issues outside the diff/description                          |
| Style suppression           | Do not report style, nits, speculative problems, intentional behavior          |

There is **no Observed separate adversarial confidence stage** — see [tooling-and-navigation.md](./tooling-and-navigation.md).

### What it looks for (**Observed** finding examples)

| Theme                          | Category / severity examples                                                      | Catalog anchors                                                                                            |
| ------------------------------ | --------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| AuthZ / access control holes   | `SECURITY_ISSUE` medium — e.g. pending enrollments gaining open access            | [ad29cd21](ad29cd21-21e3-4b77-87fd-27787647cd11) / parent [429a3195](429a3195-9a20-492c-bff3-a1bfc9e4ad85) |
| Unintended sensitive actions   | `SECURITY_ISSUE` medium — e.g. unintended mint on modal reopen                    | [17bc9f41](17bc9f41-75ba-42cd-a8c7-9e120e9ceebc)                                                           |
| Ordering / FK / data integrity | `LOGIC_BUG` high — e.g. merge_users insert order                                  | [d143b0d4](d143b0d4-0e23-440b-bea8-60468341bafd)                                                           |
| Races / lifecycle              | `LOGIC_BUG` medium/high — logout atom repopulation; optimistic toggle clobber     | [6f30508a](6f30508a-e58e-42d9-93d4-0089cd119a1c), [1710a420](1710a420-2b96-47b9-9560-b44c11526e6b)         |
| UI/API/policy mismatch         | `LOGIC_BUG` medium — open-access UI shown for platform courses                    | [9a4010dc](9a4010dc-8716-4962-95c1-0a9c092ad659)                                                           |
| Instruction / rule violations  | `BUGBOT_RULES` medium — e.g. invalid test assertion vs review instructions        | [70b0d3ea](70b0d3ea-22e2-4c99-8abf-fc70721ad3d6)                                                           |
| Docs that mislead operators    | `DOCUMENTATION_ISSUE` high — e.g. delete UI path omitting SSO gate in docs review | [1eb3505a](1eb3505a-7a9a-4c3c-816c-3961a549e46c)                                                           |

### What it ignores or rarely emits (**Observed** + mission)

- Pure formatting / import sort / naming bikesheds
- Speculative “might be nice” refactors without production failure mode
- Pre-existing bugs outside the scoped change
- Process/docs completeness that Reviewer-a owns (unless framed as a real production/doc bug or `BUGBOT_RULES`)

### Clean re-reviews (**Observed**)

After fixes, a **fresh** BugBot launch often returns `<answer></answer>` (e.g. Share modal iter 2 [fd935f45](fd935f45-e043-446c-8751-4fa3c4c04465); open-access deep clean [cb6112e5](cb6112e5-6900-4695-8d97-1a3cfa372aab)). Community reports of flip-flop after fixes remain a risk — see [failure-modes-and-retries.md](./failure-modes-and-retries.md).

### Dominant categories in this corpus (**Observed**)

Primarily `LOGIC_BUG` and `SECURITY_ISSUE`; severity mostly `medium`, sometimes `high`. Other enum values appear but less often.

## Implications / open questions

1. openBuggy’s bug-first principle matches this personality; do not optimize for style essays.
2. Eval corpora should label Fixed / N/A / nit explicitly so “when in doubt report” does not regress into nit spam — see [eval-harness-and-tuning.md](../eval-harness-and-tuning.md).

## Sources

- [run-catalog.md](./run-catalog.md)
- Mission personality: [harness-expansion-and-mission.md](./harness-expansion-and-mission.md)
- Research community notes: [community-benchmarks-and-opinions.md](../../research/community-benchmarks-and-opinions.md)
- Primary source: local Cursor agent transcript / skill text (not independently re-verified via public URL)
