@{
    StackId             = 'Cursor'
    DisplayName         = 'Cursor'
    OverlayRelativeRoot = 'overlays/cursor'
    LiveRelativeRoot    = '.cursor'
    CopyEntries         = @(
        @{ Source = 'skills/implementation-plan/SKILL.md'; Dest = 'skills/implementation-plan/SKILL.md' }
        @{ Source = 'skills/implementation-plan/user-rules-snippet.md'; Dest = 'skills/implementation-plan/user-rules-snippet.md' }
        @{ Source = 'skills/implementation-review/SKILL.md'; Dest = 'skills/implementation-review/SKILL.md' }
        @{ Source = 'skills/implementation-review/user-rules-snippet.md'; Dest = 'skills/implementation-review/user-rules-snippet.md' }
        @{ Source = 'skills/composer/SKILL.md'; Dest = 'skills/composer/SKILL.md' }
        @{ Source = 'skills/composer/user-rules-snippet.md'; Dest = 'skills/composer/user-rules-snippet.md' }
        @{ Source = 'skills/roadmap/SKILL.md'; Dest = 'skills/roadmap/SKILL.md' }
        @{ Source = 'skills/documentation-architecture/SKILL.md'; Dest = 'skills/documentation-architecture/SKILL.md' }
        @{ Source = 'agents/plan-reviewer.md'; Dest = 'agents/plan-reviewer.md' }
        @{ Source = 'agents/reviewer-a.md'; Dest = 'agents/reviewer-a.md' }
        @{ Source = 'review-subagent-models.md'; Dest = 'review-subagent-models.md' }
    )
    HybridRuleIds       = @('iterative-plan-review', 'iterative-code-review', 'pre-commit-ci-gate')
    HardExcludes        = @('skills-cursor', 'settings.json')
    NeverTouch          = @('docs/workflow')
}
