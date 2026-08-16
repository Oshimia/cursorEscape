> **Imported research** — Source: openBuggy `docs/research/latency-and-api-gap.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Latency and the API Gap

**Last updated:** 2026-08-04

## Context

A recurring desire when leaving Cursor is: “call Bugbot (or equivalent) as an API from my agent loop, get structured findings quickly, pay only for usage.” This note explains why that product shape is rare and what openBuggy should optimize for instead.

---

## Substance

### Specialized reviewers are usually jobs, not chat completions

CodeRabbit’s own CLI documentation tells agent authors that reviews can take **7–30+ minutes** depending on change scope, and to run the CLI in the background. Greptile CLI exposes `review status` exit code **3** for “still running,” which likewise assumes asynchronous completion. Multi-pass or codebase-indexed review is expensive; vendors queue work and return later.

Cursor Bugbot’s HTTP surface (Enterprise) triggers a **PR review** asynchronously — it is not documented as a low-latency “diff in, findings out” inference API, and it still requires Cursor commercial relationship (see [Bugbot product and API limits](./bugbot-product-and-api-limits.md)).

### What “API drop-in” can mean

| Shape | Latency class | Bugbot-like quality? |
|-------|---------------|----------------------|
| Proprietary Bugbot without Cursor plan | N/A | Not offered (mid-2026) |
| Vendor CLI/MCP (`--agent` / `--json`) | Minutes typical | Peer products; different personalities |
| Generic frontier model + custom bug-finder prompt | Seconds to low minutes | Depends entirely on prompt + retrieval + eval |
| openBuggy target (engine + BYOK) | Aim for loop-usable; offer light vs deep modes | Process + eval; not Cursor weights |

### Practical hybrid for agent loops

While building openBuggy (or until deep mode is fast enough):

1. Keep a **fast** custom bug-finder (or light mode) inside the iterative loop.
2. Optionally run a **commercial** CLI reviewer at phase closeout / pre-PR only.

That preserves iteration speed without pretending minutes-long jobs are sync APIs.

---

## Implications / open questions

1. openBuggy’s v2 **light/deep** modes exist specifically because of this latency gap.
2. If docs are shared publicly, do not promise “Bugbot quality in 5 seconds” without eval evidence.
3. MCP tool timeouts for deep reviews must be documented honestly (minutes possible).

---

## Sources

- [CodeRabbit CLI (7–30+ minute agent guidance)](https://docs.coderabbit.ai/cli)
- [Greptile CLI (`review status` running exit code)](https://www.greptile.com/docs/code-review/greptile-cli)
- [Cursor APIs overview](https://cursor.com/docs/api)
- [Bugbot docs](https://cursor.com/docs/bugbot)
- [DEV study latency table (CodeRabbit ~9.5 min mean in that dataset)](https://dev.to/_vjk/best-ai-code-reviewer-in-2026-we-ran-4-in-parallel-for-3-weeks-146-prs-679-findings-1c0f)
