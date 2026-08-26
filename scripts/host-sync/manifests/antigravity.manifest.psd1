@{
    # Antigravity host harness manifest.
    # caveman.md is intentionally listed in BOTH HardExcludes and NeverTouch:
    # HardExcludes = never copy over; NeverTouch = must remain untouched on the live host.
    StackId             = 'Antigravity'
    DisplayName         = 'Antigravity'
    OverlayRelativeRoot = 'overlays/antigravity'
    LiveRelativeRoot    = '.gemini'
    CopyEntries         = @(
        @{ Source = 'GEMINI.md'; Dest = 'GEMINI.md' }
        @{ Source = 'skills/discovery/SKILL.md'; Dest = 'config/skills/discovery/SKILL.md' }
        @{ Source = 'skills/implementation-plan/SKILL.md'; Dest = 'config/skills/implementation-plan/SKILL.md' }
        @{ Source = 'skills/plan-review/SKILL.md'; Dest = 'config/skills/plan-review/SKILL.md' }
        @{ Source = 'skills/implementation-review/SKILL.md'; Dest = 'config/skills/implementation-review/SKILL.md' }
        @{ Source = 'skills/pre-commit-ci-gate/SKILL.md'; Dest = 'config/skills/pre-commit-ci-gate/SKILL.md' }
        @{ Source = 'skills/composer/SKILL.md'; Dest = 'config/skills/composer/SKILL.md' }
        @{ Source = 'skills/documentation-architecture/SKILL.md'; Dest = 'config/skills/documentation-architecture/SKILL.md' }
        @{ Source = 'skills/roadmap/SKILL.md'; Dest = 'config/skills/roadmap/SKILL.md' }
        @{ Source = 'skills/diagnosing-bugs/SKILL.md'; Dest = 'config/skills/diagnosing-bugs/SKILL.md' }
        @{ Source = 'skills/opencode-headless-run/SKILL.md'; Dest = 'config/skills/opencode-headless-run/SKILL.md' }
        @{ Source = 'skills/opencode-history-search/SKILL.md'; Dest = 'config/skills/opencode-history-search/SKILL.md' }
        @{ Source = 'workflows/escape-plan.md'; Dest = 'antigravity/global_workflows/escape-plan.md' }
        @{ Source = 'workflows/escape-review.md'; Dest = 'antigravity/global_workflows/escape-review.md' }
        @{ Source = 'workflows/escape-closeout.md'; Dest = 'antigravity/global_workflows/escape-closeout.md' }
        @{ Source = 'agents/plan_reviewer.md'; Dest = 'config/agents/plan_reviewer.md' }
        @{ Source = 'agents/production_readiness_reviewer.md'; Dest = 'config/agents/production_readiness_reviewer.md' }
        @{ Source = 'agents/bug_reviewer.md'; Dest = 'config/agents/bug_reviewer.md' }
    )
    HardExcludes        = @(
        'antigravity/global_workflows/caveman.md',
        'settings.json',
        'config/mcp_config.json',
        'oauth_creds.json',
        'google_accounts.json',
        'state.json',
        'trustedFolders.json',
        'installation_id'
    )
    NeverTouch          = @(
        'antigravity/global_workflows/caveman.md',
        'config/projects'
    )
}
