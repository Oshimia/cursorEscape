> **Imported research** — Source: openBuggy `docs/featureArchitecture/findings-schema-and-agent-contract.md`; copied 2026-08-17 into cursorEscape. Status: Observed/imported. Do not treat as Target cursorEscape design unless a Target doc cites it.
# Findings Schema and Agent Contract (Proposed)

**Last updated:** 2026-08-04  
**Status:** Target / proposed

## Context

Agents need **stable, structured** output — not chat essays. This contract is what CLI `--json` and MCP tools should emit so fix-and-re-review loops can automate. Cursor Agent Review’s Observed XML contract (`high|medium|low`, category enum, empty `<answer></answer>` clean bar) is documented in [output-contract.md](./cursor-bugbot-agent-review/output-contract.md); severity/category mapping to this schema lives in [openbuggy-replication-mapping.md](./cursor-bugbot-agent-review/openbuggy-replication-mapping.md).

---

## Substance

### Proposed `Finding` object

| Field | Type | Notes |
|-------|------|-------|
| `id` | string | Stable within a run |
| `severity` | `critical` \| `high` \| `medium` \| `low` \| `info` | Canonical vocabulary |
| `title` | string | Short failure-mode name |
| `file` | string | Repo-relative path |
| `start_line` / `end_line` | number | 1-based |
| `evidence` | string | Why this is real (quote / reasoning) |
| `suggestion` | string \| null | Fix guidance; optional patch later |
| `category` | string | e.g. `correctness`, `security`, `concurrency`, `test_gap` |
| `confidence` | number | 0–1 after merge |
| `passes` | string[] | Which passes contributed |

### Proposed review result envelope

```json
{
  "schema_version": "0.1.0",
  "repo_path": "...",
  "scope": "branch|uncommitted",
  "base_branch": "main",
  "findings": [],
  "summary": { "counts_by_severity": {}, "duration_ms": 0 }
}
```

### Agent loop bar (proposed)

For dual-reviewer completion gates inspired by production iterative review practice:

- openBuggy leg is “clean” when **blocking findings list is empty** under the configured severity threshold (default: no `critical`/`high`, or stricter “none at all”).
- Production-readiness reviewer remains a **separate** agent with its own schema/verdict.
- Parent orchestrator decides dual-APPROVED policy; openBuggy should not invent silent auto-approve of incomplete changesets.

### CLI / MCP (proposed)

| Interface | Behavior |
|-----------|----------|
| `openbuggy review --json` | Print envelope to stdout |
| MCP `review_diff` | Same envelope as tool result |
| Exit codes | `0` clean under threshold; `1` findings; `2` engine error |

Exact binary name TBD at implementation.

---

## Implications / open questions

1. Freeze `schema_version` carefully; agents depend on it.
2. Optional unified-diff suggestions are a v1+ enhancement.
3. Align severity names with common tooling to ease cross-bot analytics.
