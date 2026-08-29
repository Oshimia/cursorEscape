# Overlay-remediation migration record (2026-08)

**Last updated:** 2026-08-29

## Context

Record of the [overlay-remediation](../docs/roadmaps/overlay-remediation.md) program through Phase 3: what migrated, what the golden-render surface pins, and the Reviewer A loop incident. Claim labels: **Observed** / **Inferred**.

## Substance

### Phases 0–2 (committed through 7f6452c)

- **Phase 0** (24ac0ca): 7-script CI matrix with known-red baseline (Phase2FastCI `expectedNine`, `Count-9`); D9 severability verdict; D2 schema mini-fixture proof; D5 composed-gate feasibility verdict; D4 single-owner-per-assert map.
- **Phase 1** (74abae7): per-entry v2 render machinery in `HostSync.Core.ps1` (`base:` / `shared:` / plain source classes, `Parts`/`Footer` composition, fail-closed `Substitutions`, `PlannedContent` capture); skew-guard v2; promoted rule twins (`rules/iterative-plan-review.md`, `rules/iterative-code-review.md`); unit checks (grew 18 → 22 with U17–U20 ref-resolution contract).
- **Phase 2** (7f6452c, 2026-08-29): manifests ×3 migrated to per-entry v2; antigravity differences-only (shared skill rows + `Substitutions`; GEMINI.md composed from header + promoted-twin bodies + wiring footer; pre-commit stub composed from shared frontmatter + `base:` rule + host footer); opencode instructions composed (dual-write flows; AGENTS.md mirror captured in `PlannedContent`); migrated overlay leaf copies deleted; NEW [`Invoke-Phase2-RemediationChecks.ps1`](../scripts/host-sync/Invoke-Phase2-RemediationChecks.ps1) (63 checks). Reviewer A **waived** by owner ruling: the headless audit ran clean through the whole changeset pre-loop, then the session doom-looped (143 byte-identical reads of the Apply-leg script its contract forbids judging) and was aborted without a verdict; the owner waived and committed.

### Phase 3 (worktree, 2026-08-29)

- **Known-reds retired:** `Phase2FastCI` inventory asserts 9 → 11 (variable renamed `$expectedSkillIds`; labels honest); `Phase1FullCI` wording-regex decoupled to a **structural twin-containment** assert (planned hybrid render must contain the token-merged rule twin after mirroring the exact `Get-PlannedHybridRuleContentCore` rewrite set, in order).
- **Full non-Apply CI green:** all seven suites exit 0 (unit 22/22; Phase0Fast; Phase1Fast; Phase2-RemediationChecks 63/63; Phase1Full; Phase2Fast; Phase3Full).
- **Docs cascade:** overlay `_index` ×3 (eleven-id inventories; composed pre-commit note); SOPs ×3 count/citation fixes (opencode C2 eleven + Phase-4 re-run due note; antigravity C2 eleven); FA per-entry v2 recording ([skill-source-and-host-overlays](../docs/featureArchitecture/skill-source-and-host-overlays.md)); [editing-companion-workflow](../docs/SOPs/editing-companion-workflow.md) per-cell link repair + composed-wiring row + render-based author-time verification specimen; [host-sync README](../scripts/host-sync/README.md) v2 manifest surface; roadmap status rows ×3.
- **Recovered reviewer finding fixed (Observed):** `overlays/opencode/footers/instructions-wiring.md` carried a duplicated `## Shell & native tools (all repos)` section (em-dash vs hyphen variants) — the finding the doom-looped reviewer never delivered. Removed the duplicate; composed instructions now render it once.
- **No new review loop** — owner ruling 2026-08-29 ("we don't need *another* review of this. Just get moving onto the next thing").

### Golden-render index

| Composed dest | Golden |
| ------------- | ------ |
| `~/.gemini/GEMINI.md` | `scripts/host-sync/goldens/phase2/antigravity/` (7 relocation-class goldens verified equal to HEAD-authored leaves; roadmap golden recaptured for a line-wrap artifact) |

Composed opencode instructions / pre-commit stubs are asserted by the 63 remediation checks (atoms + single-source-per-Dest + render equality against PlannedContent) rather than file goldens.

## Implications / open questions

1. The doom-loop failure class (reviewer pointed at a doc its contract forbids judging) is recorded in Copilot memory (`opencode-headless-pitfalls.md`) — keep `Invoke-Phase2FullCI.ps1` out of reviewer applicable-docs lists.
2. Phase 4 Apply requires: live-vs-planned incl. golden renders, per-stack Apply only for drifted surfaces, OpenCode re-baseline first, operator restarts + smoke.

## Related

- [Overlay-remediation roadmap](../docs/roadmaps/overlay-remediation.md)
- [Host harness sync README](../scripts/host-sync/README.md)
- [Per-entry v2 FA recording](../docs/featureArchitecture/skill-source-and-host-overlays.md)
- [Analysis index](./_index.md)
