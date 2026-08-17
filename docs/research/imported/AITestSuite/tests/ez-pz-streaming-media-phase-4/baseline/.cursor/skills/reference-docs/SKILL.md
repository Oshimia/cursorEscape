> **Imported research** — Source: AITestSuite `tests\ez-pz-streaming-media-phase-4\baseline\.cursor\skills\reference-docs\SKILL.md`; copied 2026-08-17 into cursorEscape. Status: Observed/eval-packaging. Do not treat as Target cursorEscape design unless a Target doc cites it.
---
name: reference-docs
description: >-
  Consult project SOPs and feature architecture before any code work. Covers
  index search, applicable doc selection, documented-pattern implementation, and
  same-changeset doc updates. Use before writing or recommending code in this
  repository.
disable-model-invocation: true
---

# Reference docs

Use before any code change in this repository. Canonical policy: [reference-docs-check.md](../../../referenceFiles/SOPs/reference-docs-check.md)

---

## Workflow

```text
Open indexes → select applicable docs → read → implement with documented patterns → update docs in same changeset
```

1. **Search the indexes first** (read-only):
   - [`referenceFiles/SOPs/_index.md`](../../../referenceFiles/SOPs/_index.md) — procedures and conventions
   - [`referenceFiles/featureArchitecture/_index.md`](../../../referenceFiles/featureArchitecture/_index.md) — design and behavior
2. **Read every doc** that applies to the area you are touching (editor, API, database, auth, testing, etc.). Use the SOP [quick pointers](../../../referenceFiles/SOPs/reference-docs-check.md#quick-pointers-non-exhaustive) as an entry ramp.
3. **Implement using documented patterns** — match naming, file locations, hooks, and workflows already described.
4. **Do not invent parallel patterns** when an SOP or architecture doc exists or should exist.

---

## When documentation is missing or incomplete

- **Stop and consult the user** before implementing a new pattern, workflow, or feature area.
- **Create or update** the appropriate SOP or feature architecture doc.
- **Link it** from the relevant `_index.md` in the **same change set** as the code.
- Do not ship undocumented architecture.

---

## Doc update checklist (same changeset as code)

- [ ] New or changed pattern documented in SOP or feature architecture
- [ ] Relevant `_index.md` entry added or updated
- [ ] No silent divergence from existing architecture docs

---

## Related workflows

| Task | Also consult |
|------|----------------|
| Planning | [implementation-plan skill](../implementation-plan/SKILL.md) |
| Post-implementation review | [implementation-review skill](../implementation-review/SKILL.md) — per plan phase on multi-phase work |
