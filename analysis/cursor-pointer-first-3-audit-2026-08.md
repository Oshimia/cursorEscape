# Cursor pointer-first-3 — overlay vs portable audit

**Last updated:** 2026-08-20  
**Program:** `pointer-first-3`  
**Companion root:** `C:/Users/admin/source/repos/general-projects/cursorEscape`  
**Cursor home:** `C:/Users/admin/.cursor`

## Context

pointer-first-3 confirms Cursor thin wrappers + **companion reachability when workspace ≠ cursorEscape**. Depends on pointer-first-2 commit `fec0c75`.

## Audit table — overlay harness vs portable SoT

| Harness file | Portable SoT | Pre-pf3 load path | Post-pf3 load path | C1/C2 |
| ------------ | ------------ | ----------------- | ------------------- | ----- |
| `skills/implementation-plan/SKILL.md` | `skills/implementation-plan/SKILL.md` + `workflow/*` | `../../../../` hops (wrong-base J) | `{{COMPANION_ROOT}}/skills/…` + `workflow/…` | **fixed** |
| `skills/implementation-review/SKILL.md` | `skills/implementation-review/SKILL.md` + `workflow/*` | wrong-base hops | `{{COMPANION_ROOT}}/…` | **fixed** |
| `skills/composer/SKILL.md` | `skills/composer/SKILL.md` + `workflow/*` | wrong-base hops | `{{COMPANION_ROOT}}/…` | **fixed** |
| `skills/roadmap/SKILL.md` | `skills/roadmap/SKILL.md` + `workflow/*` | wrong-base hops | `{{COMPANION_ROOT}}/…` | **fixed** |
| `skills/documentation-architecture/SKILL.md` | `skills/documentation-architecture/SKILL.md` + `workflow/*` | wrong-base hops | `{{COMPANION_ROOT}}/…` | **fixed** |
| `agents/plan-reviewer.md` | `agents/plan_reviewer.md` | `../../../agents/` hop | `{{COMPANION_ROOT}}/agents/plan_reviewer.md` | **fixed** |
| `agents/reviewer-a.md` | `agents/production_readiness_reviewer.md` | `../../../agents/` hop | `{{COMPANION_ROOT}}/agents/production_readiness_reviewer.md` | **fixed** |
| `rules/iterative-plan-review.mdc` | `rules/iterative-plan-review.md` | `../../../rules/` hop | `{{COMPANION_ROOT}}/rules/…` | **fixed** |
| `rules/iterative-code-review.mdc` | `rules/iterative-code-review.md` | `../../../rules/` hop | `{{COMPANION_ROOT}}/rules/…` | **fixed** |
| `rules/pre-commit-ci-gate.mdc` | `rules/pre-commit-ci-gate.md` | `../../../rules/` hop | `{{COMPANION_ROOT}}/rules/…` | **fixed** |
| `review-subagent-models.md` | overlay leaf + companion cites | `../../` hops | `{{COMPANION_ROOT}}/…` | **fixed** |
| `discovery` (portable skill) | `skills/discovery/SKILL.md` | no Cursor overlay | via `workflow/discovery.md` from harness | **deferred** — not skill-advertised on Cursor |
| `plan-review` (portable skill) | `skills/plan-review/SKILL.md` | no Cursor overlay | via implementation-plan harness | **deferred** |
| `pre-commit-ci-gate` | `rules/pre-commit-ci-gate.md` | `.mdc` only (no skill stub) | `{{COMPANION_ROOT}}/rules/…` | **OK** — rule surface |

## Live `~/.cursor` gap summary

| Item | Status | Disposition |
| ---- | ------ | ----------- |
| 5 fat skills (pre-Phase 5 extract) | Present | **Deferred** — non-blocking; live sync to thin `{{COMPANION_ROOT}}` stubs operator-gated |
| `docs/workflow/` mirror (8 leaves) | Present | **Deferred** to pointer-first-4 mirror disposition |
| Missing skill ads: discovery, plan-review | Absent | **Deferred** — intentional Cursor harness shape per [skills/_index.md](../skills/_index.md) |
| Rules fat bodies | Present | **C1 pass** at runtime — keep until harness-only sync |
| Token merge procedure | Documented | [cursor-host-adapter.md](../docs/SOPs/cursor-host-adapter.md) |

## Author-time verification (pointer-first-3)

| Check | Command / method | Result |
| ----- | ---------------- | ------ |
| Zero wrong-base hops in overlay | `rg '\.\./\.\./\.\./\.\./' overlays/cursor` | **pass** |
| Zero `../../../agents\|rules` hops | `rg '\.\./\.\./\.\./(agents\|rules)/' overlays/cursor` | **pass** |
| `{{COMPANION_ROOT}}` present in all harness Read tables | `rg 'COMPANION_ROOT' overlays/cursor` | **pass** |
| SOP for live pointers | `docs/SOPs/cursor-host-adapter.md` | **pass** |
| Copy-out map updated | `overlays/cursor/_index.md` | **pass** |

## Implications

- **Workspace ≠ cursorEscape:** After live sync with token merge, harness Reads resolve to companion absolute paths — not workspace-relative overlay hops.
- **C1 live:** Fat `.mdc` gate bodies remain acceptable until operator chooses harness-only sync; overlay documents merge requirement.
- **pointer-first-4:** Runtime smoke rows for Cursor companion-edit + mirror disposition.

## Related

- [pointer-first roadmap](../docs/roadmaps/pointer-first.md)
- [cursor-host-adapter SOP](../docs/SOPs/cursor-host-adapter.md)
- [overlays/cursor/_index.md](../overlays/cursor/_index.md)
