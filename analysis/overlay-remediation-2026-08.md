# Overlay-remediation migration record (2026-08)

**Last updated:** 2026-08-29

## Context

Record of the [overlay-remediation](../docs/roadmaps/overlay-remediation.md) program through Phase 3: what migrated, what the render-baseline surface pins, and the Reviewer A loop incident. Claim labels: **Observed** / **Inferred**.

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

### Render-baseline index

| Composed dest | Baseline |
| ------------- | ------ |
| `~/.gemini/GEMINI.md` | `scripts/host-sync/render-baselines/phase2/antigravity/` (7 relocation-class baselines verified equal to HEAD-authored leaves; roadmap baseline recaptured for a line-wrap artifact) |

Composed opencode instructions / pre-commit stubs are asserted by the 63 remediation checks (atoms + single-source-per-Dest + render equality against PlannedContent) rather than file baselines.

### Phase 4 (2026-08-31, owner-delegated)

- **Owner rulings:** live-tree management delegated ("you should be able to manage this yourself"); per-host physical smoke + host-restart checks waived ("I don't care that much"); file-state verification declared sufficient.
- **Drift survey (read-only):** in-process dry-run per stack; byte-compared every planned render (`PlannedContent` + recovered hybrid/dual-write renders) against live files — **12 drifted dests**, all explained by Phase 2 composition outputs, shrunken `escape-*` workflows, promoted-twin hybrid rules, and the duplicate-section fix.
- **Apply-leg defect (Observed, fail-loud caught):** first global `-Apply` — OpenCode + Antigravity succeeded; Cursor's two review-rule `.mdc` hybrids were written with unmerged `{{COMPANION_ROOT}}/docs/...` tokens. Root cause: `Invoke-HybridCursorRules` computed the CI-verified render in dry-run but invoked the legacy `overlays/cursor/scripts/Write-HybridCursorRules.ps1` in Apply — mode divergence (D7-class). **Fix:** Apply writes the planned render directly (parity by construction); legacy script no longer invoked. CI 7/7 green post-fix.
- **Verification:** re-Apply `Success: True` all stacks; drift survey **0 drift** (live == planned on all stacks); modified-files audit — 56 files modified, AppliedFiles union = 56, nothing else touched across ~41k files in the three live roots; never-touch `caveman.md` intact. `opencode.json` merge verified structurally (model/provider preserved by the adapter's own post-apply asserts; AGENTS ≡ instructions hash match recorded by Apply).
- **Status:** hosts hold snapshot-at-start config; new harness content takes effect on the owner's next full host restart (waived, not blocking).

## Implications / open questions

1. The doom-loop failure class (reviewer pointed at a doc its contract forbids judging) is recorded in Copilot memory (`opencode-headless-pitfalls.md`) — keep `Invoke-Phase2FullCI.ps1` out of reviewer applicable-docs lists.
2. **Apply-leg CI gap:** mode divergence survived all 7 non-Apply suites because the Apply leg is quarantined. Candidate CI addition: a fixture-based Apply-mode render-parity check (render via dry-run path, write via Apply path into a temp live root, byte-compare) so mode divergence is caught without touching live trees.

## Related

- [Overlay-remediation roadmap](../docs/roadmaps/overlay-remediation.md)
- [Host harness sync README](../scripts/host-sync/README.md)
- [Per-entry v2 FA recording](../docs/featureArchitecture/skill-source-and-host-overlays.md)
- [Analysis index](./_index.md)
