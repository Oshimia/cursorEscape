# Editing companion workflow (agent edit map)

**Last updated:** 2026-09-08

## Context

Agents editing **this** repo (cursorEscape) often update companion SoT correctly and miss host harness echoes — or treat overlays as forbidden. This SOP is the checklist for non-trivial changes to portable loops, gates, skills, agents, or always-on text.

Design essays stay in FA ([skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md), [instruction-layering](../featureArchitecture/instruction-layering.md)). Doc hygiene for new leaves: [documenting-this-repo](./documenting-this-repo.md).

---

## Substance

### Architecture (one paragraph)

cursorEscape is the **sole SoT** for skills, rules, agents, workflows, and report schemas. Registered host homes (including `~/.cursor`, `~/.config/opencode`, `~/.gemini`, and Codex's independent `CODEX_HOME` + skill root) hold **thin harness only** (advertisement, permissions, spawn, absolute wiring, thin always-on gates). Deep procedure loads via **companion Reads** to `{{COMPANION_ROOT}}/workflow/`, `skills/`, `agents/` — **not** a host `docs/workflow/` mirror as SoT ([pointer-first](../roadmaps/pointer-first.md)). Registered overlays are thin wrappers / harness — they **echo** gate shape and point at companion; they must not become a second authored procedure tree.

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
| Always-on gate text | [`rules/*.md`](../../rules/_index.md) | Gate-body edits land in the **repo-root rule twin** (SoT) and flow to hosts by composition — OpenCode `instructions/cursor-escape-loop.md` is **composed** (host `__header__.md` part + authored base body + [`footers/instructions-wiring.md`](../../overlays/opencode/footers/instructions-wiring.md)) with `AGENTS.md` dual-written from the render; Cursor thin `.mdc` hybrid render + matching user-rules-snippet; **Antigravity [`GEMINI.md`](../../overlays/antigravity/GEMINI.md)** is **composed** (header + promoted-twin bodies + [`footers/gemini-wiring.md`](../../overlays/antigravity/footers/gemini-wiring.md)) — full-replace global rules surface |
| Report / deep schema | [`workflow/<leaf>.md`](../../workflow/_index.md) (e.g. `plan-reviewer-report.md`) | Thin agent/skill **Read when** only — do **not** paste full schema into `agents/` or overlay stubs |
| Plan-review loop | [`workflow/iterative-plan-review.md`](../../workflow/iterative-plan-review.md) + [`skills/plan-review`](../../skills/plan-review/SKILL.md) / [`implementation-plan`](../../skills/implementation-plan/SKILL.md) | Matching Cursor/OpenCode stubs **and** [Antigravity stubs](../../overlays/antigravity/skills/) (`implementation-plan`, `plan-review`) — gate-text changes also echo the Antigravity `GEMINI.md` always-on; always-on plan section in OpenCode C1 dual-write if gate text changes |
| Composed-gate wiring (manifest `Parts`/`Footer`/`base:`/`shared:` classes) | [`scripts/host-sync/manifests/*.psd1`](../../scripts/host-sync/) + the referenced part/footer leaves | FA recording ([skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md#per-entry-v2-sourcing-overlay-remediation-phase-12--required)); [host-sync README](../../scripts/host-sync/README.md) v2 surface; render-goldens under [`scripts/host-sync/goldens/`](../../scripts/host-sync/goldens/phase2/) re-captured in the same changeset; unit/remediation checks extended if a new field class appears |

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

**Normative rule (owner, 2026-08-26): live pushes are global — never per-stack by default.** The harness is one global skill set; the sync tool defaults to all stacks and fails closed on single-stack `-Apply` where sources are shared (`-AllowSkew` exists for deliberate exceptions only). There is no per-host sync decision to make when distributing a change.

| Host | Overlay home | Role in a global push |
| ---- | ------------ | --------------------- |
| OpenCode | [`overlays/opencode/`](../../overlays/opencode/_index.md) | included automatically — see [opencode-host-adapter](./opencode-host-adapter.md) |
| Cursor | [`overlays/cursor/`](../../overlays/cursor/_index.md) | included automatically — see [cursor-host-adapter](./cursor-host-adapter.md) |
| Antigravity | [`overlays/antigravity/`](../../overlays/antigravity/_index.md) | included automatically; Apply gated on Phase 0 baselines (all present, registered) |
| VS Code | [`overlays/vscode/`](../../overlays/vscode/_index.md) | included automatically (`~/.copilot`); Apply gated on Phase 0 baselines (all 4 present, registered); see [vscode-host-adapter](./vscode-host-adapter.md) |
| Cline | [`overlays/cline/`](../../overlays/cline/_index.md) | included automatically (`~/.cline`); Apply gated on all-six baselines; see [cline-host-adapter](./cline-host-adapter.md) |
| Kilo Code | [`overlays/kilocode/`](../../overlays/kilocode/_index.md) | included automatically (`~/.kilocode`); Apply gated on all-six baselines; see [kilocode-host-adapter](./kilocode-host-adapter.md) |
| Codex | [`overlays/codex/`](../../overlays/codex/_index.md) | registered and included in all-stack planning/CI; `BringUp` refusal prevents any Apply write pass; see [codex-host-adapter](./codex-host-adapter.md) |

```powershell
pwsh ./scripts/Sync-HostHarness.ps1          # dry-run all stacks
pwsh ./scripts/Sync-HostHarness.ps1 -Apply   # live write ALL stacks
```

Dry-run default (no live writes): omit `-Apply`. With Codex forced BringUp, `-Apply` for All is refused before any selected stack writes. Apply is globally preflighted: if any selected stack fails dry-run preflight, no selected stack is written. Sync **does not create backups**; Phase 0 baselines are restore-only ([`scripts/host-sync/baseline-backups.paths.json`](../../scripts/host-sync/baseline-backups.paths.json)). Modular layout: [`scripts/host-sync/README.md`](../../scripts/host-sync/README.md).

Do **not** write live installs unless the user explicitly asks. After overlay edits, note “live sync deferred” in the closeout if applicable.

**Post-push verification is not a step.** The sync script's built-in checks are authoritative ([post-apply verification policy](../../scripts/host-sync/README.md#post-apply-verification-policy)); do not re-check hashes or run smoke after routine pushes — smoke belongs to first-time surfaces and machinery changes only.

### Author-time verification (after a loop/gate change)

```powershell
# Stale unbounded loop / old narrowing in OpenCode harness
rg "until dual APPROVED|count >= 9|no hard stop" overlays/opencode/AGENTS.md overlays/opencode/instructions overlays/opencode/skills overlays/opencode/agents

# C1 dual-write still identical
# (hashes of AGENTS.md and instructions/cursor-escape-loop.md must match)

# Companion SoT still states the new policy (example: pressure release)
rg "pressure-release|4-iteration|cap-exhausted" workflow/iterative-code-review.md skills/implementation-review/SKILL.md skills/composer/SKILL.md

# Composed surfaces (Phase 2+): gate atoms flow via composition — verify by render, not by prose grep
pwsh scripts/host-sync/Invoke-RemediationUnitChecks.ps1      # 22/22 incl. U17-U20 ref-resolution contract
pwsh scripts/host-sync/Invoke-Phase2-RemediationChecks.ps1   # 63/63: composed renders, goldens, atoms, single-source-per-Dest
```

Expect: zero matches on the first `rg` after migrating off unbounded loops; C1 hashes equal; companion SoT still documents the current policy; unit + remediation suites exit 0.

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
- [Codex host adapter](./codex-host-adapter.md)
