## Kilo harness pointers

Thin harness. Host: Kilo Code (Kilo CLI platform), global surface at `~/.kilocode/` (rules auto-included; workflows auto-migrate to slash commands on startup).

- **Workflows/commands** at `~/.kilocode/workflows/` register as slash commands (`/plan`, `/review`, `/closeout`, workflow-name style). Companion procedure ids map 1:1 to synced workflows; load the matching one before non-trivial work; deep procedure via companion **Read**.
- **Rules concatenate always-on** (no toggles; global-first, project precedence on conflict). Do not author second always-on surfaces here — keep budget thin.
- **Subagents:** first-class in this platform (NEW); treat depth/behavior as unproven until the Phase 4 smoke probe (`subtask: true` capability) — do not rely on nested spawn until attested. Until then, dual review uses separate fresh task/session passes, one reviewer per leg, max 4 dual iterations per block. Begin each reviewer payload with the canonical envelope from `{{COMPANION_ROOT}}/workflow/agent-invocation.md`; never transfer prior reviewer reasoning into the next leg.
- **Verification:** Settings → Agent Behaviour shows rules/commands lists; workflows appear in the `/` picker. Missing surface = discovery failure, fail loud.
- Prefer native tools over shell equivalents; git red line: read/discovery pre-allowed; mutating verbs prompt — pre-commit gate is the only sanctioned commit path after dual APPROVED + Full CI; never `git push`.
