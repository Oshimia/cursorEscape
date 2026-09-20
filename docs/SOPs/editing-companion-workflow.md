# Editing companion workflow (agent edit map)

**Last updated:** 2026-09-16

## Context

Agents editing **this** repo (cursorEscape) often update companion SoT correctly and miss host harness echoes — or treat overlays as forbidden. This SOP is the checklist for non-trivial changes to portable loops, gates, skills, agents, or always-on text.

Design essays stay in FA ([skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md), [instruction-layering](../featureArchitecture/instruction-layering.md)). Doc hygiene for new leaves: [documenting-this-repo](./documenting-this-repo.md).

---

## Substance

### Architecture (one paragraph)

cursorEscape is the **sole SoT** for skills, rules, agents, workflows, and report schemas. Registered host homes (including `~/.cursor`, `~/.config/opencode`, `~/.gemini`, `~/.copilot`, `~/.cline`, `~/.kilocode`, and Codex's independent `CODEX_HOME` + skill root) hold **thin harness only** (advertisement, permissions, spawn, absolute wiring, thin always-on gates). Deep procedure loads via **companion Reads** to `{{COMPANION_ROOT}}/workflow/`, `skills/`, `agents/` — **not** a host `docs/workflow/` mirror as SoT ([skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)). The [procedure registry](../featureArchitecture/procedure-registry.md) owns machine metadata and semantic composition order; deterministic rendering derives composition-bound host projections. Registered overlays are thin wrappers / harness — they **echo** gate shape and point at companion; they must not become a second authored procedure tree.

```text
Change portable loop/gate
  → begin every child-agent launch with the canonical agent-invocation envelope
  → edit companion SoT (workflow/ skills/ agents/ rules/)
  → if machine metadata changed (identity, order, host binding): edit registry catalog
  → composition-bound host projections: derived automatically at render time
  → hand-authored thin wrappers that mirror changed prose: edit in same changeset
  → FA claim docs if Required/Desired wording moved
  → live sync only when operator authorizes (overlay ≠ live)
```

### Edit map (same-changeset cascade)

| Change | Primary SoT | Same changeset (must also touch) |
| ------ | ----------- | -------------------------------- |
| Agent invocation contract | [`workflow/agent-invocation.md`](../../workflow/agent-invocation.md) + [`rules/agent-invocation.md`](../../rules/agent-invocation.md) | Every governed launch-site skill/workflow; portable agent contracts when fail-loud behavior changes; Cursor [`agent-invocation.mdc`](../../overlays/cursor/rules/agent-invocation.mdc); OpenCode composed C1; Antigravity `GEMINI.md` composition, launch workflows, skills, and reviewer defs; VS Code agent handoffs and composer/review stubs; Cline/Kilo Code workflows and wiring; Codex TOMLs and managed AGENTS block; render baselines/ledger in the same changeset |
| Dual-review / pressure-release loop | [`workflow/iterative-code-review.md`](../../workflow/iterative-code-review.md) + [`skills/implementation-review/SKILL.md`](../../skills/implementation-review/SKILL.md) | [`rules/iterative-code-review.md`](../../rules/iterative-code-review.md); Cursor [`overlays/cursor/skills/implementation-review/`](../../overlays/cursor/skills/implementation-review/) (SKILL + user-rules-snippet) + spawn notes in [`reviewer-a`](../../overlays/cursor/agents/reviewer-a.md) if Inputs change; OpenCode [`overlays/opencode/skills/implementation-review/SKILL.md`](../../overlays/opencode/skills/implementation-review/SKILL.md) + **C1** [`AGENTS.md`](../../overlays/opencode/AGENTS.md) ≡ [`instructions/cursor-escape-loop.md`](../../overlays/opencode/instructions/cursor-escape-loop.md); OpenCode [`implementer`](../../overlays/opencode/agents/implementer.md) / [`production_readiness_reviewer`](../../overlays/opencode/agents/production_readiness_reviewer.md) / [`bug_reviewer`](../../overlays/opencode/agents/bug_reviewer.md) as needed; Antigravity [`overlays/antigravity/skills/implementation-review/SKILL.md`](../../overlays/antigravity/skills/implementation-review/SKILL.md), `/escape-*` workflows, and reviewer subagent defs ([agents](../../overlays/antigravity/agents/)) as needed; portable [`agents/production_readiness_reviewer.md`](../../agents/production_readiness_reviewer.md) if Inputs change; FA [`intended-workflow`](../featureArchitecture/intended-workflow.md) / [`desired-behavior-vs-cursor-specific`](../featureArchitecture/desired-behavior-vs-cursor-specific.md) if Required claims move |
| Composer conductor | [`skills/composer/SKILL.md`](../../skills/composer/SKILL.md) | Cursor + OpenCode composer stubs/snippets; Antigravity `composer` stub + `/escape-*` workflow wording; Codex Composer wrapper / always-on failsafe when needed; [`workflow/phased-multi-agent.md`](../../workflow/phased-multi-agent.md). Use “approval preview” and “implementation subagent”, never the retired paired phase abbreviations. |
| Always-on gate text | [`rules/*.md`](../../rules/_index.md) | Gate-body edits land in the **repo-root rule twin** (SoT) and flow to hosts by registry-owned composition — the semantic order lives in `catalog/workflows.json`, not in any manifest. OpenCode `instructions/cursor-escape-loop.md` is **composed** (host `__header__.md` part + authored base body + [`footers/instructions-wiring.md`](../../overlays/opencode/footers/instructions-wiring.md)) with `AGENTS.md` dual-written from the render; Cursor thin `.mdc` hybrid render + matching user-rules-snippet; Antigravity, VS Code, Cline, and Kilo Code always-on gates compose `rules/agent-invocation.md` first, followed by their loop/gate bodies and host wiring; **Antigravity [`GEMINI.md` expected render](../../scripts/host-sync/render-baselines/antigravity/overlays__antigravity__GEMINI.md)** remains the full-replace regression anchor. Manifest entries use `CompositionId` (never `Parts`/`Footer`) for registry-governed order; the blocking `composition-order-ownership` guard in normalization Fast CI rejects any divergence |
| Report / deep schema | [`workflow/<leaf>.md`](../../workflow/_index.md) (e.g. `plan-reviewer-report.md`) | Thin agent/skill **Read when** only — do **not** paste full schema into `agents/` or overlay stubs |
| Plan-review loop | [`workflow/iterative-plan-review.md`](../../workflow/iterative-plan-review.md) + [`skills/plan-review`](../../skills/plan-review/SKILL.md) / [`implementation-plan`](../../skills/implementation-plan/SKILL.md) | Matching Cursor/OpenCode stubs **and** [Antigravity stubs](../../overlays/antigravity/skills/) (`implementation-plan`, `plan-review`) — gate-text changes also echo the Antigravity `GEMINI.md` always-on; always-on plan section in OpenCode C1 dual-write if gate text changes |
| Composed-gate wiring (manifest `CompositionId` / `base:`/`shared:` classes) | [`catalog/workflows.json`](../../catalog/workflows.json) (semantic order) + [`scripts/host-sync/manifests/*.psd1`](../../scripts/host-sync/) (destination + `CompositionId`) + the referenced part/footer leaves | FA recording ([skill-source-and-host-overlays](../featureArchitecture/skill-source-and-host-overlays.md#per-entry-v2-sourcing-overlay-remediation-phase-12--required)); [host-sync README](../../scripts/host-sync/README.md); render-baselines under [`scripts/host-sync/render-baselines/`](../../scripts/host-sync/render-baselines/) re-captured only from observed current renders; normalization Fast CI validates blocking ownership |

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

### Live installs (Phase 6 owner-authorized only)

**Normative rule (owner, 2026-08-26): live pushes are global — never per-stack by default.** The harness is one global skill set; the sync tool defaults to all stacks and fails closed on single-stack `-Apply` where sources are shared (`-AllowSkew` exists for deliberate exceptions only). There is no per-host sync decision to make when distributing a change.

| Host | Overlay home | Role in a global push |
| ---- | ------------ | --------------------- |
| OpenCode | [`overlays/opencode/`](../../overlays/opencode/_index.md) | included automatically — see [opencode-host-adapter](./opencode-host-adapter.md) |
| Cursor | [`overlays/cursor/`](../../overlays/cursor/_index.md) | included automatically — see [cursor-host-adapter](./cursor-host-adapter.md) |
| Antigravity | [`overlays/antigravity/`](../../overlays/antigravity/_index.md) | included automatically; Apply gated on Phase 6 owner authorization (see [Apply boundary](../featureArchitecture/procedure-registry.md#phase-6-apply-boundary)) |
| VS Code | [`overlays/vscode/`](../../overlays/vscode/_index.md) | included automatically (`~/.copilot`); Apply gated on Phase 6 owner authorization; see [vscode-host-adapter](./vscode-host-adapter.md) |
| Cline | [`overlays/cline/`](../../overlays/cline/_index.md) | included automatically (`~/.cline`); Apply gated on Phase 6 owner authorization; see [cline-host-adapter](./cline-host-adapter.md) |
| Kilo Code | [`overlays/kilocode/`](../../overlays/kilocode/_index.md) | included automatically (`~/.kilocode`); Apply gated on Phase 6 owner authorization; see [kilocode-host-adapter](./kilocode-host-adapter.md) |
| Codex | [`overlays/codex/`](../../overlays/codex/_index.md) | registered and included in all-stack planning/CI; Apply gated on Phase 6 owner authorization; see [codex-host-adapter](./codex-host-adapter.md) |

```powershell
pwsh ./scripts/Sync-HostHarness.ps1          # dry-run all stacks
pwsh ./scripts/Sync-HostHarness.ps1 -Apply   # live write ALL stacks — Phase 6 owner authorization per [Apply boundary](../featureArchitecture/procedure-registry.md#phase-6-apply-boundary)
```

Dry-run default (no live writes): omit `-Apply`. The `BringUp` lifecycle gate blocks any Apply write pass: if any selected stack is `BringUp`, `-Apply` for All is refused before any selected stack writes. Apply is globally preflighted: if any selected stack fails dry-run preflight, no selected stack is written. Sync **does not create backups**; Phase 0 baselines are restore-only ([`scripts/host-sync/baseline-backups.paths.json`](../../scripts/host-sync/baseline-backups.paths.json)). Modular layout: [`scripts/host-sync/README.md`](../../scripts/host-sync/README.md).

Do **not** write live installs unless the user explicitly asks. After overlay edits, note “live sync deferred” in the closeout if applicable.

**Post-push verification is not a step.** The sync script's built-in checks are authoritative ([post-apply verification policy](../../scripts/host-sync/README.md#post-apply-verification-policy)); do not re-check hashes or run smoke after routine pushes — smoke belongs to first-time surfaces and machinery changes only.

### Author-time verification (after a loop/gate change)

```powershell
# Sole normalization Fast gate — primary verification for registry-governed changes
pwsh -NoProfile -File scripts/normalization/Invoke-NormalizationFastCI.ps1
git diff --check

# Stale unbounded loop / old narrowing in OpenCode harness
rg "until dual APPROVED|count >= 9|no hard stop" overlays/opencode/AGENTS.md overlays/opencode/instructions overlays/opencode/skills overlays/opencode/agents

# C1 dual-write still identical
# (hashes of AGENTS.md and instructions/cursor-escape-loop.md must match)
pwsh scripts/host-sync/Invoke-HostSyncChecks.ps1 -Suite Composition

# Exact-render fixture guard and current live drift snapshot
pwsh scripts/host-sync/Invoke-HostSyncDriftFixtureChecks.ps1
pwsh scripts/host-sync/Test-HostHarnessDrift.ps1

# Companion SoT still states the new policy
rg "canonical envelope|agent-invocation|Completion gate: review-loop" workflow/agent-invocation.md rules/agent-invocation.md workflow skills agents overlays

# Active procedure surfaces plus generated evidence must not reintroduce the retired paired phase abbreviations
rg "\b[Nn][AaBb]\b" agents rules scripts/host-sync/render-baselines skills workflow docs/featureArchitecture docs/SOPs overlays --glob '!research/imported/**'

# Composed surfaces: gate atoms flow via composition — verify by render, not by prose grep
pwsh scripts/host-sync/Invoke-HostSyncChecks.ps1 -Suite Unit        # includes U17-U20 and U21-U22 ordering checks
pwsh scripts/host-sync/Invoke-HostSyncChecks.ps1 -Suite Composition # record exact emitted summary
```

Expect: normalization Fast CI exit 0; zero matches on the first `rg` after migrating off unbounded loops; committed C1 mirrors byte-match the planned render; companion SoT still documents the current policy; authoring suites exit 0. Treat the standalone live drift audit as an evidence snapshot, not an authoring suite: exit 2 is expected before owner-authorized Apply when live drift or missing leaves exist. Capture that snapshot, then attest the observed Composition pass/fail summary rather than reusing a historical count.

**Live Apply is Phase 6 only.** Dry-run (`pwsh ./scripts/Sync-HostHarness.ps1`) is always allowed. `-Apply` requires explicit owner authorization per the [procedure registry Apply boundary](../featureArchitecture/procedure-registry.md#phase-6-apply-boundary). No normalization or review step writes to live hosts.

---

## Implications / open questions

1. Prefer extending this edit map when a new change class appears (e.g. new L3 schema leaf) rather than scattering cascade rules across FA essays.
2. User Rules / live `.mdc` paste remains an operator step after Cursor overlay snippet edits.

---

## Related

- [Documenting this repo](./documenting-this-repo.md)
- [Skill source and host overlays](../featureArchitecture/skill-source-and-host-overlays.md)
- [Instruction layering](../featureArchitecture/instruction-layering.md)
- [Discovery](../../workflow/discovery.md)
- [OpenCode host adapter](./opencode-host-adapter.md)
- [Cursor host adapter](./cursor-host-adapter.md)
- [Host harness sync README](../../scripts/host-sync/README.md)
- [Codex host adapter](./codex-host-adapter.md)
