@{
    # OpenCode host harness manifest (per-entry v2, Phase 2 migration 2026-08-28).
    StackId             = 'OpenCode'
    DisplayName         = 'OpenCode'
    OverlayRelativeRoot = 'overlays/opencode'
    LiveRelativeRoot    = '.config/opencode'
    SharedRoot          = 'overlays/opencode'
    CopyEntries         = @(
        # --- composed pre-commit stub: shared frontmatter + base SoT rule + host footer leaf ---
        @{ Source = 'base:rules/pre-commit-ci-gate.md'; Dest = 'skills/pre-commit-ci-gate/SKILL.md'
           Parts = @('shared:pre-commit-frontmatter.md')
           Footer = @('footers/pre-commit-opencode.md') }
        @{ Source = 'skills/discovery/SKILL.md'; Dest = 'skills/discovery/SKILL.md' }
        @{ Source = 'skills/implementation-plan/SKILL.md'; Dest = 'skills/implementation-plan/SKILL.md' }
        @{ Source = 'skills/plan-review/SKILL.md'; Dest = 'skills/plan-review/SKILL.md' }
        @{ Source = 'skills/implementation-review/SKILL.md'; Dest = 'skills/implementation-review/SKILL.md' }
        @{ Source = 'skills/composer/SKILL.md'; Dest = 'skills/composer/SKILL.md' }
        @{ Source = 'skills/documentation-architecture/SKILL.md'; Dest = 'skills/documentation-architecture/SKILL.md' }
        @{ Source = 'skills/roadmap/SKILL.md'; Dest = 'skills/roadmap/SKILL.md' }
        @{ Source = 'skills/diagnosing-bugs/SKILL.md'; Dest = 'skills/diagnosing-bugs/SKILL.md' }
        @{ Source = 'skills/opencode-headless-run/SKILL.md'; Dest = 'skills/opencode-headless-run/SKILL.md' }
        @{ Source = 'skills/opencode-history-search/SKILL.md'; Dest = 'skills/opencode-history-search/SKILL.md' }
        @{ Source = 'agents/planner.md'; Dest = 'agents/planner.md' }
        @{ Source = 'agents/plan_reviewer.md'; Dest = 'agents/plan_reviewer.md' }
        @{ Source = 'agents/implementer.md'; Dest = 'agents/implementer.md' }
        @{ Source = 'agents/production_readiness_reviewer.md'; Dest = 'agents/production_readiness_reviewer.md' }
        @{ Source = 'agents/bug_reviewer.md'; Dest = 'agents/bug_reviewer.md' }
        @{ Source = 'agents/repository_explorer.md'; Dest = 'agents/repository_explorer.md' }
        @{ Source = 'agents/test_reviewer.md'; Dest = 'agents/test_reviewer.md' }
        @{ Source = 'agents/composer_conductor.md'; Dest = 'agents/composer_conductor.md' }
    )
    # Composed always-on gate (Phase 2): header leaf (overlay) + promoted-twin bodies (base: SoT)
    # + host wiring footer (overlay). Rendered by Invoke-OpenCodeAgentsDualWrite; AGENTS.md mirrors.
    AgentsDualWrite     = @{
        InstructionsRel = 'instructions/cursor-escape-loop.md'
        AgentsRel       = 'AGENTS.md'
        Parts           = @(
            'instructions/__header__.md',
            'base:rules/iterative-plan-review.md',
            'base:rules/iterative-code-review.md'
        )
        Footer          = @('footers/instructions-wiring.md')
    }
    JsonMerge           = @{
        SpecimenRel            = 'opencode.specimen.json'
        DestRel                = 'opencode.json'
        PreserveTopLevelKeys   = @('model', 'provider')
    }
    HybridRuleIds       = @()
    HardExcludes        = @('docs/workflow', 'review-subagent-models')
    NeverTouch          = @('docs/workflow')
}
