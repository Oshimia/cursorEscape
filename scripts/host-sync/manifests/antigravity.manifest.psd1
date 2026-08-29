@{
    # Antigravity host harness manifest (per-entry v2, Phase 2 migration 2026-08-28).
    # caveman.md is intentionally listed in BOTH HardExcludes and NeverTouch:
    # HardExcludes = never copy over; NeverTouch = must remain untouched on the live host.
    StackId             = 'Antigravity'
    DisplayName         = 'Antigravity'
    OverlayRelativeRoot = 'overlays/antigravity'
    LiveRelativeRoot    = '.gemini'
    SharedRoot          = 'overlays/opencode'
    CopyEntries         = @(
        # --- composed gate: host header + promoted-twin bodies + host wiring footer ---
        @{ Source = 'base:rules/iterative-plan-review.md'; Dest = 'GEMINI.md'
           Parts = @('instructions/__header__.md')
           Footer = @('base:rules/iterative-code-review.md', 'footers/gemini-wiring.md') }
        # --- migrated skills (shared: opencode authored leaves + host substitutions; fail-closed exactly-once) ---
        @{ Source = 'shared:skills/discovery/SKILL.md'; Dest = 'config/skills/discovery/SKILL.md'
           Substitutions = @(@{ Find = '(OpenCode harness)'; Replace = '(Antigravity harness)' }) }
        @{ Source = 'shared:skills/implementation-plan/SKILL.md'; Dest = 'config/skills/implementation-plan/SKILL.md'
           Substitutions = @(
               @{ Find = '(OpenCode harness)'; Replace = '(Antigravity harness)' }
               @{ Find = 'Invoke OpenCode agent `plan_reviewer` via Task'; Replace = 'Invoke subagent `plan_reviewer` via `invoke_subagent`' }
           ) }
        @{ Source = 'shared:skills/plan-review/SKILL.md'; Dest = 'config/skills/plan-review/SKILL.md'
           Substitutions = @(@{ Find = '(OpenCode harness)'; Replace = '(Antigravity harness)' }) }
        @{ Source = 'shared:skills/documentation-architecture/SKILL.md'; Dest = 'config/skills/documentation-architecture/SKILL.md'
           Substitutions = @(@{ Find = '(OpenCode harness)'; Replace = '(Antigravity harness)' }) }
        @{ Source = 'shared:skills/roadmap/SKILL.md'; Dest = 'config/skills/roadmap/SKILL.md'
           Substitutions = @(
               @{ Find = '(not under ~/.config/opencode)'; Replace = '(not under the Antigravity adapter tree)' }
               @{ Find = 'Never write them under the OpenCode adapter tree.'; Replace = 'Never write them under the Antigravity adapter tree (`~/.gemini`).' }
               @{ Find = 'Store roadmaps under `~/.config/opencode` or the adapter skills tree'; Replace = 'Store roadmaps under `~/.gemini` or the adapter skills tree' }
               @{ Find = '(OpenCode harness)'; Replace = '(Antigravity harness)' }
           ) }
        @{ Source = 'shared:skills/diagnosing-bugs/SKILL.md'; Dest = 'config/skills/diagnosing-bugs/SKILL.md'
           Substitutions = @(@{ Find = '(OpenCode harness)'; Replace = '(Antigravity harness)' }) }
        @{ Source = 'shared:skills/opencode-headless-run/SKILL.md'; Dest = 'config/skills/opencode-headless-run/SKILL.md'
           Substitutions = @(@{ Find = '(OpenCode harness)'; Replace = '(Antigravity overlay)' }) }
        # --- composed pre-commit stub: shared frontmatter + base SoT rule + host footer leaf ---
        @{ Source = 'base:rules/pre-commit-ci-gate.md'; Dest = 'config/skills/pre-commit-ci-gate/SKILL.md'
           Parts = @('shared:pre-commit-frontmatter.md')
           Footer = @('footers/pre-commit-antigravity.md') }
        # --- authored: real host deltas (implementation-review/composer) or non-substitutable delta (opencode-history-search) ---
        @{ Source = 'skills/composer/SKILL.md'; Dest = 'config/skills/composer/SKILL.md' }
        @{ Source = 'skills/implementation-review/SKILL.md'; Dest = 'config/skills/implementation-review/SKILL.md' }
        @{ Source = 'skills/opencode-history-search/SKILL.md'; Dest = 'config/skills/opencode-history-search/SKILL.md' }
        # --- escape workflows (shrunken to pointer/spawn-only, Phase 2 item 4) ---
        @{ Source = 'workflows/escape-plan.md'; Dest = 'antigravity/global_workflows/escape-plan.md' }
        @{ Source = 'workflows/escape-review.md'; Dest = 'antigravity/global_workflows/escape-review.md' }
        @{ Source = 'workflows/escape-closeout.md'; Dest = 'antigravity/global_workflows/escape-closeout.md' }
        # --- agents: authored frontmatter + body (host deltas confirmed on disk) ---
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
