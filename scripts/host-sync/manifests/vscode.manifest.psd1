@{
    # VS Code (Copilot) host harness manifest (per-entry v2, vscode bring-up 2026-09-01).
    # Surface map docs-verified: analysis/vscode-load-surface-2026-09.md; overlay: overlays/vscode/_index.md.
    # Live root ~/.copilot (user-level instructions/agents/skills; docs 8/26/2026).
    StackId             = 'Vscode'
    DisplayName         = 'VS Code'
    OverlayRelativeRoot = 'overlays/vscode'
    LiveRelativeRoot    = '.copilot'
    SharedRoot          = 'overlays/opencode'
    CopyEntries         = @(
        # --- composed always-on gate instructions (applyTo: '**' at dest, added by footer note) ---
        @{ Source = 'base:rules/iterative-plan-review.md'; Dest = 'instructions/cursor-escape-loop.instructions.md'
           Parts = @('instructions/__header__.md')
           Footer = @('base:rules/iterative-code-review.md', 'footers/instructions-wiring.md') }
        # --- composed pre-commit instructions leaf ---
        @{ Source = 'base:rules/pre-commit-ci-gate.md'; Dest = 'instructions/pre-commit-gate.instructions.md'
           Footer = @('footers/pre-commit-vscode.md') }
        # --- migrated skills (shared: opencode authored leaves + host substitutions; fail-closed exactly-once) ---
        @{ Source = 'shared:skills/discovery/SKILL.md'; Dest = 'skills/discovery/SKILL.md'
           Substitutions = @(@{ Find = '(OpenCode harness)'; Replace = '(VS Code harness)' }) }
        @{ Source = 'shared:skills/implementation-plan/SKILL.md'; Dest = 'skills/implementation-plan/SKILL.md'
           Substitutions = @(@{ Find = '(OpenCode harness)'; Replace = '(VS Code harness)' }) }
        @{ Source = 'shared:skills/plan-review/SKILL.md'; Dest = 'skills/plan-review/SKILL.md'
           Substitutions = @(@{ Find = '(OpenCode harness)'; Replace = '(VS Code harness)' }) }
        @{ Source = 'shared:skills/documentation-architecture/SKILL.md'; Dest = 'skills/documentation-architecture/SKILL.md'
           Substitutions = @(@{ Find = '(OpenCode harness)'; Replace = '(VS Code harness)' }) }
        @{ Source = 'shared:skills/roadmap/SKILL.md'; Dest = 'skills/roadmap/SKILL.md'
           Substitutions = @(
               @{ Find = '(not under ~/.config/opencode)'; Replace = '(not under the VS Code adapter tree)' }
               @{ Find = 'Never write them under the OpenCode adapter tree.'; Replace = 'Never write them under the VS Code adapter tree (`~/.copilot`).' }
               @{ Find = 'Store roadmaps under `~/.config/opencode` or the adapter skills tree'; Replace = 'Store roadmaps under `~/.copilot` or the adapter skills tree' }
               @{ Find = '(OpenCode harness)'; Replace = '(VS Code harness)' }
           ) }
        @{ Source = 'shared:skills/diagnosing-bugs/SKILL.md'; Dest = 'skills/diagnosing-bugs/SKILL.md'
           Substitutions = @(@{ Find = '(OpenCode harness)'; Replace = '(VS Code harness)' }) }
        @{ Source = 'shared:skills/opencode-headless-run/SKILL.md'; Dest = 'skills/opencode-headless-run/SKILL.md'
           Substitutions = @(@{ Find = '(OpenCode harness)'; Replace = '(VS Code overlay)' }) }
        # --- composed pre-commit skill stub: shared frontmatter + base SoT rule + host footer leaf ---
        @{ Source = 'base:rules/pre-commit-ci-gate.md'; Dest = 'skills/pre-commit-ci-gate/SKILL.md'
           Parts = @('shared:pre-commit-frontmatter.md')
           Footer = @('footers/pre-commit-vscode.md') }
        # --- authored: real host deltas (implementation-review/composer) or non-substitutable delta (opencode-history-search) ---
        @{ Source = 'skills/composer/SKILL.md'; Dest = 'skills/composer/SKILL.md' }
        @{ Source = 'skills/implementation-review/SKILL.md'; Dest = 'skills/implementation-review/SKILL.md' }
        @{ Source = 'skills/opencode-history-search/SKILL.md'; Dest = 'skills/opencode-history-search/SKILL.md' }
        # --- agents: authored VS Code frontmatter (tools arrays, handoffs) + thin pointer bodies ---
        @{ Source = 'agents/planner.agent.md'; Dest = 'agents/planner.agent.md' }
        @{ Source = 'agents/plan_reviewer.agent.md'; Dest = 'agents/plan_reviewer.agent.md' }
        @{ Source = 'agents/implementer.agent.md'; Dest = 'agents/implementer.agent.md' }
        @{ Source = 'agents/production_readiness_reviewer.agent.md'; Dest = 'agents/production_readiness_reviewer.agent.md' }
        @{ Source = 'agents/bug_reviewer.agent.md'; Dest = 'agents/bug_reviewer.agent.md' }
        @{ Source = 'agents/repository_explorer.agent.md'; Dest = 'agents/repository_explorer.agent.md' }
        @{ Source = 'agents/test_reviewer.agent.md'; Dest = 'agents/test_reviewer.agent.md' }
        @{ Source = 'agents/composer.agent.md'; Dest = 'agents/composer.agent.md' }
    )
    HardExcludes        = @(
        # Never copy into the live root:
        'review-subagent-models.md',
        'config.json'
    )
    NeverTouch          = @(
        # Must remain untouched on the live host (VS Code/Copilot-managed state):
        'config.json',
        'ide',
        'logs'
    )
}
