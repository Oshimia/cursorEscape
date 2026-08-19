> **Imported research** — Source: openBuggy `docs/research/bugbot-product-and-api-limits.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Bugbot Product and API Limits

**Last updated:** 2026-08-04

## Context

openBuggy is motivated partly by the difficulty of keeping Cursor Bugbot when leaving the Cursor ecosystem. This note separates **what Bugbot is**, **how it is billed**, and **what APIs exist** — as of mid-2026 — so design decisions are not based on wishful “just call the model” assumptions.

For **how local Agent Review BugBot is invoked and behaves** (envelope, mission, tools, XML output, review loops), see the Observed FA suite: [cursor-bugbot-agent-review](../featureArchitecture/cursor-bugbot-agent-review/_index.md). This research doc stays focused on product surfaces and packaging.

---

## Substance

### Two related products

Cursor documents a distinction between:

1. **Bugbot (PR product)** — reviews pull/merge requests on connected SCM providers, posts inline comments and check statuses, supports rules (including `.cursor/BUGBOT.md`), effort levels, optional autofix via Cloud Agents, and dashboard analytics.
2. **Local Agent Review** — IDE/agent flows such as `/review-bugbot` that review local branch or uncommitted diffs before push. These use Cursor’s proprietary `bugbot` subagent path inside the Cursor agent runtime.

They complement each other; they are not the same deployment surface. Community forum guidance frames Agent Review as early local checking and Bugbot as the PR-stage gate.

### Billing and seats (as of mid-2026)

Cursor moved Bugbot toward **usage-based billing** for Teams and Individual plans. Official help text states the average Bugbot run costs between **$1.00 and $1.50**, depending on PR size and complexity. Teams charge Bugbot from on-demand usage; Individual plans consume included usage first, then on-demand if enabled.

Forum clarification from Cursor staff (June 2026): Bugbot no longer has a dedicated per-seat Bugbot fee in the new model, but on a **Team plan Bugbot still requires at least one active paid Team member**. If seats drop to zero, Bugbot stops. A single paid seat can keep automatic PR reviews available across enabled repositories; contributors need not each hold Cursor seats for automatic reviews. Running Bugbot **inside** Cursor still requires the operator’s own IDE seat. Manual comment triggers (`bugbot run` / `cursor review`) are gated by team membership and Bugbot access settings.

There is **no** documented path to use proprietary Bugbot without an active Cursor Individual or Team relationship.

### APIs

Cursor’s API overview lists a **Bugbot API** (trigger reviews / analytics) as available to **Enterprise teams**. It is not a public chat-completions endpoint for “the Bugbot model.” Cloud Agents API and Cursor SDKs run Cursor agent workflows under Cursor account billing; docs explicitly state they are not a standalone model-inference API.

### Implications for openBuggy

| Wish                                                           | Reality (mid-2026)                                                 |
| -------------------------------------------------------------- | ------------------------------------------------------------------ |
| Call Bugbot model via metered API, cancel Cursor subscription  | Not offered                                                        |
| Keep PR Bugbot without IDE                                     | Possible only while Cursor plan/seat requirements remain satisfied |
| Drop Bugbot into a non-Cursor agent as `subagent_type: bugbot` | Proprietary to Cursor’s agent runtime                              |

---

## Implications / open questions

1. openBuggy must assume **zero** Cursor Bugbot API dependency.
2. Users who only need PR comments may still prefer staying on Bugbot or switching to CodeRabbit/Greptile — openBuggy’s design focus is the **local agent loop**, not necessarily displacing every PR bot.
3. Re-verify packaging (seat vs usage) before any public comparison blog; Cursor pricing pages change.
4. For harness behavior (invocation, XML output, tool loops), see [cursor-bugbot-agent-review](../featureArchitecture/cursor-bugbot-agent-review/_index.md).

---

## Sources

- [Bugbot documentation](https://cursor.com/docs/bugbot)
- [Cursor APIs overview (Bugbot API = Enterprise)](https://cursor.com/docs/api)
- [Bugbot usage-based billing](https://cursor.com/help/account-and-billing/bugbot-usage-based-billing)
- [Team seat requirements (Cursor forum, Jun 2026)](https://forum.cursor.com/t/clarification-on-bugbot-usage-and-team-seat-requirements/162971)
- [Bugbot vs Agent Review (Cursor forum)](https://forum.cursor.com/t/difference-between-bugbot-and-agent-review/163425)
