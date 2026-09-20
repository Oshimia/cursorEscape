# Standard Operating Procedures

**Last updated:** 2026-09-20

## Context

This index lists the current repeatable procedures for maintaining cursorEscape documentation and operating its seven registered host adapters. Portable procedure and contracts live in repo-root `workflow/`, `skills/`, `agents/`, and `rules/`; SOPs describe how maintainers apply and verify those contracts in this repository.

**Path rule:** in-repo links use repo-relative paths. External projects may be named in prose, imported only under the owner-frozen `research/imported/` boundary, or represented by host-native files under `overlays/`. Do not copy external trees into this repository as active documentation.

## Documentation hygiene

- [Editing companion workflow](./editing-companion-workflow.md) — agent entry point and same-changeset cascade for portable loop, gate, skill, agent, and overlay changes.
- [Documenting this repo](./documenting-this-repo.md) — documentation taxonomy, source-of-truth rules, update and verification workflow.

## Host adapters

- [Cursor host adapter](./cursor-host-adapter.md) — global `~/.cursor`; hybrid rules, thin skills/agents, and companion Reads.
- [OpenCode host adapter](./opencode-host-adapter.md) — global `~/.config/opencode`; dual-written C1 surfaces, skills, agents, and reusable smoke scorecard.
- [OpenCode smoke prompts](./opencode-smoke-prompts.md) — copy-paste runbook for the OpenCode smoke scorecard.
- [Authoring OpenCode adapter files](./opencode-authoring-adapter.md) — OpenCode-specific skills, agents, instructions, permissions, and failure modes.
- [Antigravity host adapter](./antigravity-host-adapter.md) — global `~/.gemini`; full-replace `GEMINI.md`, skills, workflows, and subagent routes.
- [VS Code host adapter](./vscode-host-adapter.md) — user-level `~/.copilot`; composed instructions, skills, and agents.
- [Cline host adapter](./cline-host-adapter.md) — global `~/.cline`; shared generic adapter and serial-review adaptation.
- [Kilo Code host adapter](./kilocode-host-adapter.md) — global `~/.kilocode`; shared generic adapter and slash-command adaptation.
- [Codex host adapter](./codex-host-adapter.md) — explicit `CODEX_HOME` and skill root; managed `AGENTS.md`, TOML agents, and thin skill wrappers.
- [Host harness sync README](../../scripts/host-sync/README.md) — modular adapter layout, restore baselines, render ownership, and expansion recipe.

Live Apply always requires fresh explicit owner authorization. Dry-run is the default and performs no live writes.

## Rules for this index

1. Add a new SOP leaf only when it documents a repeatable current procedure.
2. Update this index in the same change as the leaf.
3. Remove or fold a procedure when its current-architecture purpose is complete; rely on Git history for completed work.
4. Label external observations as Observed and keep them separate from Target contracts.

## Related

- [Project decisions and open questions](../featureArchitecture/project-decisions-and-open-questions.md)
- [Feature architecture index](../featureArchitecture/_index.md)
- [Overlays](../../overlays/_index.md)
- [Workflow index](../../workflow/_index.md)
- [Skills index](../../skills/_index.md)
- [Agent contracts](../../agents/_index.md)
