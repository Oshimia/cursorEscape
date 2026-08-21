# Cross-cutting Infrastructure

Snapshot evidence is pinned to `mattpocock/skills` commit `0ab1b63a410a03d3627979a109c8695de27af954`. Upstream infrastructure claims are compared with local indexes and architecture/SOP documents. The upstream `CONTEXT.md`, `.agents/`, and `.out-of-scope/` paths listed in the catalog are not present in cursorEscape.

## Skill authoring format
- **Recommendation:** **Adopt-pattern**.
- **Evidence:** Upstream separates a pointer-sized `SKILL.md` from deep companions, assigns model metadata in pinned [agents/openai.yaml](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/ask-matt/agents/openai.yaml), and uses companion format pages such as pinned [CONTEXT-FORMAT.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/domain-modeling/CONTEXT-FORMAT.md). Local [skills index](../../../skills/_index.md) and pointer-first architecture already make thin harness plus companion split the stronger SoT.
- **Local authoring impact:** Preserve repo-root `skills/*/SKILL.md` contracts and `workflow/` deep procedure. Adopt format discipline only; do not import `agents/openai.yaml` as a second model-assignment SoT. Host IDs and permissions remain overlays.

## User vs model invocation
- **Recommendation:** **Adopt-pattern**.
- **Evidence:** Upstream distinguishes explicit skills with `disable-model-invocation: true` and `policy.allow_implicit_invocation: false`, as shown in pinned [wait-what SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/wait-what/SKILL.md) and [openai.yaml](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/wait-what/agents/openai.yaml). Local [instruction-layering](../../../docs/featureArchitecture/instruction-layering.md) already treats disable-model-invocation as a Cursor-specific mapping of portable on-demand intent.
- **Local authoring impact:** Keep one portable trigger contract and encode invocation per host. Add richer trigger descriptions where useful, but do not copy OpenAI policy YAML into shared skills.

## CONTEXT.md / ADR discipline
- **Recommendation:** **Adopt-pattern**.
- **Evidence:** Upstream [domain-modeling SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/domain-modeling/SKILL.md) and pinned [ADR-FORMAT.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/domain-modeling/ADR-FORMAT.md) make glossary updates and inline ADR decisions part of modeling. Those upstream paths are absent locally; cursorEscape instead has `review/design-decisions.md` and feature-architecture documents.
- **Local authoring impact:** Use existing decision and architecture SoTs unless a later owner decision creates a glossary. Do not add `CONTEXT.md` or ADR scaffolding during this audit; future adoption must define write authorization and avoid a parallel decision tree.

## Human-facing docs pages
- **Recommendation:** **Adopt-pattern**.
- **Evidence:** Pinned [writing-docs.md](https://github.com/mattpocock/skills/blob/0ab1b63/.agents/writing-docs.md) frames each promoted skill around what it does, when to reach for it, common questions, success signals, and where it fits. The catalog says every promoted upstream skill has such a page. Local `skills/_index.md` has contract links but no per-skill human-facing tree.
- **Local authoring impact:** For future promoted skills, consider a human-facing page under an approved local docs home, linked from the skill index and distinct from the contract. Do not create pages for rejected or reference-only items.

## ask-matt router
- **Recommendation:** **Reject**.
- **Evidence:** Pinned [ask-matt SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/ask-matt/SKILL.md) routes users across a changing skill set. Local `skills/_index.md` is the inventory SoT, and the Tier 2 finding notes that a second hand-maintained map violates single-SoT discipline.
- **Local authoring impact:** Keep the static index authoritative. If routing is ever needed, derive it from that index or add routing metadata to the same SoT; do not add an independently maintained router.

## Distribution
- **Recommendation:** **Reject**.
- **Evidence:** Upstream combines plugin manifests, changesets, CHANGELOG, release workflow, and pinned [link-skills.sh](https://github.com/mattpocock/skills/blob/0ab1b63/scripts/link-skills.sh). Local distribution is already defined by `scripts/Sync-HostHarness.ps1`, overlays, and pointer-first companion reads.
- **Local authoring impact:** Retain Sync-HostHarness and overlay manifests. Do not add Claude plugin packaging, upstream changeset release machinery, or a second symlink distribution script.

## House style
- **Recommendation:** **Adopt-pattern**.
- **Evidence:** The upstream catalog records a no-em-dash prose convention, and pinned [writing-for-agents SKILL.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/productivity/writing-for-agents/SKILL.md) treats authoring discipline as part of agent comprehension. Local docs do not consistently enforce this, so this is prospective guidance rather than a claim that the tree is clean.
- **Local authoring impact:** Apply the style to new audit findings and future edited prose, preferably through documentation guidance rather than a broad cleanup. Avoid changing unrelated existing docs.

## Out-of-scope discipline
- **Recommendation:** **Adopt-pattern**.
- **Evidence:** Upstream uses explicit non-goal pages, including pinned [OUT-OF-SCOPE.md](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/triage/OUT-OF-SCOPE.md), to prevent scope expansion. cursorEscape has no `.out-of-scope/` directory, but its roadmap and architecture docs already use “Do not touch”, “Out of scope”, and forbidden-pattern sections.
- **Local authoring impact:** Continue documenting non-goals in the owning roadmap/SOP/architecture artifact instead of creating a parallel `.out-of-scope/` tree by default. Add a dedicated artifact only when a recurring boundary needs one canonical home.
