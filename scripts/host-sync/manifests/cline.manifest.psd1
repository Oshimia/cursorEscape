@{
    # Cline host harness manifest (per-entry v2, kilo-cline bring-up 2026-09-01).
    # Surface map docs-verified: analysis/cline-kilo-probes-2026-09.md; overlay: overlays/cline/_index.md.
    # Live root ~/.cline (global rules under rules/, global workflows under data/workflows/).
    StackId             = 'Cline'
    DisplayName         = 'Cline'
    OverlayRelativeRoot = 'overlays/cline'
    LiveRelativeRoot    = '.cline'
    SharedRoot          = 'overlays/opencode'
    CopyEntries         = @(
        # --- composed always-on rule (toggle-default-ON by Cline scan semantics) ---
        @{ Source = 'base:rules/iterative-plan-review.md'; Dest = 'rules/cursor-escape-loop.md'
           Parts = @('instructions/__header__.md')
           Footer = @('base:rules/iterative-code-review.md', 'base:rules/pre-commit-ci-gate.md', 'footers/cline-wiring.md') }
        # --- plan/review/closeout workflows (serial-dual-review adaptation authored in this overlay) ---
        @{ Source = 'workflows/plan.md'; Dest = 'data/workflows/plan.md' }
        @{ Source = 'workflows/review.md'; Dest = 'data/workflows/review.md' }
        @{ Source = 'workflows/closeout.md'; Dest = 'data/workflows/closeout.md' }
    )
    HardExcludes        = @(
        'review-subagent-models.md',
        'workflows/plan.md',   # never double-write; trio handled above via its own entries
        'workflows/review.md',
        'workflows/closeout.md'
    )
    NeverTouch          = @(
        'data/settings',
        'data/sessions',
        'data/db',
        'data/cache',
        'data/workspaces',
        'data/globalState.json',
        'data/tasks'
    )
}
