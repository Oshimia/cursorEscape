# Editing companion workflow (agent edit map)

**Last updated:** 2026-08-24

## Context

Agents editing **this** repo (cursorEscape) often update companion SoT correctly and miss host harness echoes — or treat overlays as forbidden. This SOP is the checklist for non-trivial changes to portable loops, gates, skills, agents, or always-on text.

Design essays stay in FA ([skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md), [instruction-layering](../featureArchitecture/instruction-layering.md)). Doc hygiene for new leaves: [documenting-this-repo](./documenting-this-repo.md).

---

## Substance

### Architecture (one paragraph)

cursorEscape is the **sole SoT** for skills, rules, agents, workflows, and report schemas. Host folders (`~/.cursor`, `~/.config/opencode`, `~/.gemini`) hold **thin harness only** (advertisement, permissions, spawn, absolute `{{COMPANION_ROOT}}` / `{{OPENCODE_HOME}}` wiring, thin always-on gates). Deep procedure loads via **companion Reads** to `{{COMPANION_ROOT}}/workflow/`, `skills/`, `agents/` — **not** a host `docs/workflow/` mirror as SoT ([pointer-first](../roadmaps/pointer-first.md)). Overlays under `overlays/cursor/`, `overlays/opencode/`, and `overlays/antigravity/` are thin wrappers / harness — they **echo** gate shape and point at companion; they must not become a second authored procedure tree.

```text
Change portable loop/gate
  → edit companion SoT (workflow/ skills/ agents/ rules/)
  → same changeset: Cursor thin overlay echo
  → same changeset: OpenCode thin harness echo (AGENTS ≡ instructions)
  → same changeset: Antigravity harness echo (GEMINI.md gate + stubs/workflows/subagent defs)
  → FA claim docs if Required/Desired wording moved
  → live sync only when operator authorizes (overlay ≠ live)
```

### Edit map (same-changeset cascade)

| Change | Primary SoT | Same changeset (must also touch) |
| ------ | ----------- | -------------------------------- |
| Dual-review / pressure-release loop | [`workflow/iterative-code-review.md`](../../workflow/iterative-code-review.md) + [`skills/implementation-review/SKILL.md`](../../skills/implementation-review/SKILL.md) | [`rules/iterative-code-review.md`](../../rules/iterative-code-review.md); Cursor [`overlays/cursor/skills/implementation-review/`](../../overlays/cursor/skills/implementation-review/) (SKILL + user-rules-snippet) + spawn notes in [`reviewer-a`](../../overlays/cursor/agents/reviewer-a.md) if Inputs change; OpenCode [`overlays/opencode/skills/implementation-review/SKILL.md`](../../overlays/opencode/skills/implementation-review/SKILL.md) + **C1** [`AGENTS.md`](../../overlays/opencode/AGENTS.md) ≡ [`instructions/cursor-escape-loop.md`](../../overlays/opencode/instructions/cursor-escape-loop.md); OpenCode [`implementer`](../../overlays/opencode/agents/implementer.md) / [`production_readiness_reviewer`](../../overlays/opencode/agents/production_readiness_reviewer.md) / [`bug_reviewer`](../../overlays/opencode/agents/bug_reviewer.md) as needed; Antigravity [`overlays/antigravity/skills/implementation-review/SKILL.md`](../../overlays/antigravity/skills/implementation-review/SKILL.md), `/escape-*` workflows, and reviewer subagent defs ([agents](../../overlays/antigravity/agents/)) as needed; portable [`agents/production_readiness_reviewer.md`](../../agents/production_readiness_reviewer.md) if Inputs change; FA [`intended-workflow`](../featureArchitecture/intended-workflow.md) / [`desired-behavior-vs-cursor-specific`](../featureArchitecture/desired-behavior-vs-cursor-specific.md) if Required claims move |
| Composer conductor | [`skills/composer/SKILL.md`](../../skills/composer/SKILL.md) | Cursor + OpenCode composer stubs/snippets; Antigravity `composer` stub + `/escape-*` workflow wording; [`workflow/phased-multi-agent.md`](../../workflow/phased-multi-agent.md) |
| Always-on gate text | [`rules/*.md`](../../rules/_index.md) | OpenCode `AGENTS.md` ≡ `instructions/cursor-escape-loop.md` (byte-identical gate body); Cursor thin `.mdc` pointer + matching user-rules-snippet; **Antigravity [`GEMINI.md`](../../overlays/antigravity/GEMINI.md)** (full-replace global rules surface — must echo the same gate shape) |
| Report / deep schema | [`workflow/<leaf>.md`](../../workflow/_index.md) (e.g. `plan-reviewer-report.md`) | Thin agent/skill **Read when** only — do **not** paste full schema into `agents/` or overlay stubs |
| Plan-review loop | [`workflow/iterative-plan-review.md`](../../workflow/iterative-plan-review.md) + [`skills/plan-review`](../../skills/plan-review/SKILL.md) / [`implementation-plan`](../../skills/implementation-plan/SKILL.md) | Matching Cursor/OpenCode stubs **and** [Antigravity stubs](../../overlays/antigravity/skills/) (`implementation-plan`, `plan-review`) — gate-text changes also echo the Antigravity `GEMINI.md` always-on; always-on plan section in OpenCode C1 dual-write if gate text changes |

### Anti-patterns

| Do not | Why |
| ------ | --- |
| Edit only `skills/` or `workflow/` and skip overlays | Hosts load thin harness first; stale Steps / always-on fight companion SoT |
| Treat Path rules as “never edit overlay bodies” | Thin **echo** of a changed gate (Steps, always-on summary) **must** update; pasting full procedure into overlays remains forbidden |
| Hardcode machine paths in overlay harness leaves | Token merge cannot catch them; use `{{COMPANION_ROOT}}` (Fast CI guards the Antigravity tree) |
| Treat `research/imported/**` as Target SoT | Archaeology / Observed only |
| Reintroduce host `docs/workflow/` as procedure SoT | Superseded by pointer-first |
| Leave OpenCode always-on saying “until dual APPROVED” after SoT moved to ≤4 pressure-release blocks | C1 drift; agents follow injected text |
| Claim live `~/.cursor` / `~/.config/opencode` / `~/.gemini` updated because overlay changed | Overlay edit ≠ live sync |

### Live installs (operator-gated)

| Host | Overlay home | Live sync |
| ---- | ------------ | --------- |
| OpenCode | [`overlays/opencode/`](../../overlays/opencode/_index.md) | `pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target OpenCode` — see [opencode-host-adapter](./opencode-host-adapter.md) |
| Cursor | [`overlays/cursor/`](../../overlays/cursor/_index.md) | `pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target Cursor` — see [cursor-host-adapter](./cursor-host-adapter.md) |
| Antigravity | [`overlays/antigravity/`](../../overlays/antigravity/_index.md) | `pwsh ./scripts/Sync-HostHarness.ps1 -Apply -Target Antigravity` — see [antigravity-host-adapter](./antigravity-host-adapter.md); Apply gated on all three stacks' Phase 0 baselines |

Dry-run default (no live writes): omit `-Apply`. Sync **does not create backups**; Phase 0 baselines are restore-only ([`scripts/host-sync/baseline-backups.paths.json`](../../scripts/host-sync/baseline-backups.paths.json)). Modular layout: [`scripts/host-sync/README.md`](../../scripts/host-sync/README.md).

Do **not** write live installs unless the user explicitly asks. After overlay edits, note “live sync deferred” in the closeout if applicable.

### Author-time verification (after a loop/gate change)

```powershell
# Stale unbounded loop / old narrowing in OpenCode harness
rg "until dual APPROVED|count >= 9|no hard stop" overlays/opencode/AGENTS.md overlays/opencode/instructions overlays/opencode/skills overlays/opencode/agents

# C1 dual-write still identical
# (hashes of AGENTS.md and instructions/cursor-escape-loop.md must match)

# Companion SoT still states the new policy (example: pressure release)
rg "pressure-release|4-iteration|cap-exhausted" workflow/iterative-code-review.md skills/implementation-review/SKILL.md skills/composer/SKILL.md
```

Expect: zero matches on the first `rg` after migrating off unbounded loops; C1 hashes equal; companion Still documents the current policy.

---

## Implications / open questions

1. Prefer extending this edit map when a new change class appears (e.g. new L3 schema leaf) rather than scattering cascade rules across FA essays.
2. User Rules / live `.mdc` paste remains an operator step after Cursor overlay snippet edits.

---

## Related

- [Documenting this repo](./documenting-this-repo.md)
- [Skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md)
- [Pointer-first roadmap](../roadmaps/pointer-first.md)
- [Discovery](../../workflow/discovery.md)
- [OpenCode host adapter](./opencode-host-adapter.md)
- [Cursor host adapter](./cursor-host-adapter.md)
- [Host harness sync README](../../scripts/host-sync/README.md)
