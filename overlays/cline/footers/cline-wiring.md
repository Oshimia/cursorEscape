## Cline harness pointers

Thin harness. Host: Cline VS Code extension, user-level global surface at `~/.cline/` (rules + workflows).

- **Workflows** live at `~/.cline/data/workflows/` — invoke via workflow name in chat (slash-style). Companion procedure ids (`discovery`, `implementation-plan`, `plan-review`, …) map 1:1 to synced workflow files; load the matching one before non-trivial work; deep procedure via companion **Read**.
- **Dual review (serial):** Cline has no nested subagent spawn. `production_readiness_reviewer` and `bug_reviewer` are **personified roles you adopt consecutively in-chat**, one pass each per review iteration — parent maintains isolation by keeping each review's reasoning in its own block, never merging review streams. Max 4 dual-review iterations per pressure-release block. Empty or instant "reviews" are routing failures — fail loud, never treat as APPROVED.
- **Gates always-on, toggle-able:** the composed always-on rule is default-enabled; the user may toggle rules in the Rules panel — do not treat a toggled-off gate as satisfied; re-enable before loop-critical steps.
- **Verification:** Rules panel (scale icon) lists discovered global rules; workflows list shows registered commands. Gate/workflow missing = discovery failure, fail loud.
- Prefer native tools over shell equivalents; git red line: read/discovery git pre-allowed, all mutating git verbs prompt — the pre-commit gate is the only sanctioned path to a local commit after dual APPROVED + Full CI; never `git push`.
