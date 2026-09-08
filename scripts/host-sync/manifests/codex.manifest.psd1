@{
    # Codex Phase 1 source-only manifest. Not registered yet; the Phase 2
    # specialized adapter owns two-root writes.
    SchemaVersion                    = 1
    StackId                          = 'Codex'
    DisplayName                      = 'OpenAI Codex'
    OverlayRelativeRoot              = 'overlays/codex'
    LogicalRoots                     = @('codex-home', 'skill-root')
    OwnershipMarker                  = 'cursorEscape-managed:v1'
    ManagedBlockMarker               = 'cursorEscape-managed-block:v1'
    SkillCatalogBudgetCharacters     = 8000

    DestinationEntries               = @(
        @{ LogicalRoot = 'codex-home'; Source = 'instructions/agents-block.md'; Dest = 'AGENTS.md'; Role = 'managed-block-target' }
        @{ LogicalRoot = 'codex-home'; Dest = 'AGENTS.override.md'; Role = 'guard-only-override'; GuardOnly = $true }
        @{ LogicalRoot = 'codex-home'; Source = 'agents/planner.toml'; Dest = 'agents/planner.toml'; Role = 'managed-agent-target' }
        @{ LogicalRoot = 'codex-home'; Source = 'agents/plan_reviewer.toml'; Dest = 'agents/plan_reviewer.toml'; Role = 'managed-agent-target' }
        @{ LogicalRoot = 'codex-home'; Source = 'agents/implementer.toml'; Dest = 'agents/implementer.toml'; Role = 'managed-agent-target' }
        @{ LogicalRoot = 'codex-home'; Source = 'agents/production_readiness_reviewer.toml'; Dest = 'agents/production_readiness_reviewer.toml'; Role = 'managed-agent-target' }
        @{ LogicalRoot = 'codex-home'; Source = 'agents/bug_reviewer.toml'; Dest = 'agents/bug_reviewer.toml'; Role = 'managed-agent-target' }
        @{ LogicalRoot = 'codex-home'; Source = 'agents/repository_explorer.toml'; Dest = 'agents/repository_explorer.toml'; Role = 'managed-agent-target' }
        @{ LogicalRoot = 'codex-home'; Source = 'agents/test_reviewer.toml'; Dest = 'agents/test_reviewer.toml'; Role = 'managed-agent-target' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/architecture-survey/SKILL.md'; Dest = 'architecture-survey/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/bug-review-sweep/SKILL.md'; Dest = 'bug-review-sweep/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/codebase-design/SKILL.md'; Dest = 'codebase-design/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/composer/SKILL.md'; Dest = 'composer/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/diagnosing-bugs/SKILL.md'; Dest = 'diagnosing-bugs/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/discovery/SKILL.md'; Dest = 'discovery/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/documentation-architecture/SKILL.md'; Dest = 'documentation-architecture/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/domain-modeling/SKILL.md'; Dest = 'domain-modeling/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/grilling/SKILL.md'; Dest = 'grilling/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/implementation-plan/SKILL.md'; Dest = 'implementation-plan/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/implementation-review/SKILL.md'; Dest = 'implementation-review/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/opencode-headless-run/SKILL.md'; Dest = 'opencode-headless-run/SKILL.md'; Role = 'generated-skill-wrapper-explicit-only' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/opencode-history-search/SKILL.md'; Dest = 'opencode-history-search/SKILL.md'; Role = 'generated-skill-wrapper-explicit-only' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/plan-review/SKILL.md'; Dest = 'plan-review/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/prototype/SKILL.md'; Dest = 'prototype/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/research/SKILL.md'; Dest = 'research/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/resolving-merge-conflicts/SKILL.md'; Dest = 'resolving-merge-conflicts/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/roadmap/SKILL.md'; Dest = 'roadmap/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/tdd/SKILL.md'; Dest = 'tdd/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/teach/SKILL.md'; Dest = 'teach/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/wait-what/SKILL.md'; Dest = 'wait-what/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/wizard/SKILL.md'; Dest = 'wizard/SKILL.md'; Role = 'generated-skill-wrapper' }
        @{ LogicalRoot = 'skill-root'; Source = 'skills/pre-commit-ci-gate/SKILL.md'; Dest = 'pre-commit-ci-gate/SKILL.md'; Role = 'generated-rule-wrapper' }
    )

    # Minimal Codex skill metadata for deviations from implicit invocation.
    # The Phase 0 schema intentionally pins only SKILL.md destinations, so this
    # metadata remains overlay evidence until its installation seam is expanded
    # in a separately reviewed phase.
    OverlayOnlySkillMetadata         = @(
        @{ SkillId = 'opencode-headless-run'; RelativePath = 'skills/opencode-headless-run/agents/openai.yaml'; AllowImplicitInvocation = $false }
        @{ SkillId = 'opencode-history-search'; RelativePath = 'skills/opencode-history-search/agents/openai.yaml'; AllowImplicitInvocation = $false }
    )

    HardExcludes                     = @(
        'codex-home:config.toml'
        'codex-home:auth.json'
        'codex-home:history.jsonl'
        'codex-home:logs'
        'codex-home:sessions'
        'codex-home:databases'
    )
    NeverTouch                       = @(
        'codex-home:config.toml'
        'codex-home:auth.json'
        'codex-home:history.jsonl'
        'codex-home:logs'
        'codex-home:sessions'
        'codex-home:databases'
    )
}
