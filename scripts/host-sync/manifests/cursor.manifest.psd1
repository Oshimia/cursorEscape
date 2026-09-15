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
        @{ Source = 'skills/opencode-headless-run/SKILL.md'; Dest = 'skills/opencode-headless-run/SKILL.md' }
        @{ Source = 'skills/opencode-history-search/SKILL.md'; Dest = 'skills/opencode-history-search/SKILL.md' }
        @{ Source = 'agents/planner.md'; Dest = 'agents/planner.md' }
        @{ Source = 'agents/plan-reviewer.md'; Dest = 'agents/plan-reviewer.md' }
        @{ Source = 'agents/reviewer-a.md'; Dest = 'agents/reviewer-a.md' }
        @{ Source = 'agents/repository_explorer.md'; Dest = 'agents/repository_explorer.md' }
        @{ Source = 'agents/implementer.md'; Dest = 'agents/implementer.md' }
        @{ Source = 'agents/test_reviewer.md'; Dest = 'agents/test_reviewer.md' }
        @{ Source = 'review-subagent-models.md'; Dest = 'review-subagent-models.md' }
    )
    HybridRuleIds       = @('agent-invocation', 'iterative-plan-review', 'iterative-code-review', 'pre-commit-ci-gate')
    HybridCompositions  = @(
        @{ RuleId = 'agent-invocation'; CompositionId = 'cursor-agent-invocation'; Destination = 'rules/agent-invocation.mdc' }
        @{ RuleId = 'iterative-plan-review'; CompositionId = 'cursor-iterative-plan-review'; Destination = 'rules/iterative-plan-review.mdc' }
        @{ RuleId = 'iterative-code-review'; CompositionId = 'cursor-iterative-code-review'; Destination = 'rules/iterative-code-review.mdc' }
        @{ RuleId = 'pre-commit-ci-gate'; CompositionId = 'cursor-pre-commit-ci-gate'; Destination = 'rules/pre-commit-ci-gate.mdc' }
    )
    HardExcludes        = @('skills-cursor', 'settings.json')
    NeverTouch          = @('docs/workflow')
}
