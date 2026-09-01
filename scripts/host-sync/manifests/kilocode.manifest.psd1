@{
    # Kilo Code host harness manifest (per-entry v2, kilo-cline bring-up 2026-09-01).
    # Surface map docs-verified: analysis/cline-kilo-probes-2026-09.md; overlay: overlays/kilocode/_index.md.
    # Live root ~/.kilocode (legacy-compat: rules auto-included; workflows auto-migrate to commands on startup).
    StackId             = 'Kilocode'
    DisplayName         = 'Kilo Code'
    OverlayRelativeRoot = 'overlays/kilocode'
    LiveRelativeRoot    = '.kilocode'
    SharedRoot          = 'overlays/opencode'
    CopyEntries         = @(
        # --- composed always-on rule (auto-included by compat loader; no toggles) ---
        @{ Source = 'base:rules/iterative-plan-review.md'; Dest = 'rules/cursor-escape-loop.md'
           Parts = @('instructions/__header__.md')
           Footer = @('base:rules/iterative-code-review.md', 'base:rules/pre-commit-ci-gate.md', 'footers/kilocode-wiring.md') }
        # --- plan/review/closeout workflows (parent-conducted dual review adaptation authored in this overlay) ---
        @{ Source = 'workflows/plan.md'; Dest = 'workflows/plan.md' }
        @{ Source = 'workflows/review.md'; Dest = 'workflows/review.md' }
        @{ Source = 'workflows/closeout.md'; Dest = 'workflows/closeout.md' }
    )
    HardExcludes        = @(
        'review-subagent-models.md'
    )
    NeverTouch          = @(
        # Kilo platform state: globalStorage holds state.vscdb/mcp/settings (outside USERPROFILE root
        # by APPDATA path — protected by this manifest's narrow copy surface anyway).
        'workflows/probe-slash-20260901.md'
    )
}
