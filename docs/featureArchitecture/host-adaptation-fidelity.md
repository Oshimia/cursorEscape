# Host adaptation fidelity

**Last updated:** 2026-09-22

## Context

Host adaptation is complete only when the same owner workflow behaves correctly on the registered stack. Folder presence, manifest registration, or a successful dry-run does not prove adaptation. The binding evidence is the host's active load surface, on-demand catalog, isolated reviewers, companion reads, and observed smoke behavior.

This page defines the architecture bar and verification classes. Host SOPs own the exact reusable smoke commands and scorecards for their surfaces.

---

## Substance

### Success criterion (Required)

**Done** means the operator can run the same loops on every registered stack—Cursor, OpenCode, Antigravity, VS Code, Cline, Kilo Code, and Codex—with these invariants:

| Loop element | Required parity |
| --- | --- |
| Plan | `implementation-plan` plus `plan_reviewer`, with the plan's Incomplete-until bar enforced. |
| Implementation | An implementer or parent executes an explicit scope in the stated workspace and diff boundary. |
| Review | Observed Fast CI, parallel production-readiness and bug legs, repair, dual APPROVED, then Full CI. |
| Gates | Default on unless truly trivial or explicitly waived; operational work is not exempt. |
| Skills | Named on-demand skills load through the host's real discovery surface. |
| Isolation | Reviewers receive packed inputs without prior transcripts; production reviewer has a locked opener. |

Host chrome, restart mechanics, permission prompts, and native UI may differ. Loop semantics may not.

### Adaptation requirements and anti-patterns

| Requirement | Reject |
| --- | --- |
| Wire always-on gates to a surface that actually injects them. | Treat a file on disk, a skill description, manifest registration, or dry-run success as injection evidence. |
| Advertise every governed skill through the host's actual catalog. | Assume a default scan or rely on descriptions alone. |
| Keep reviewer identities and edit denial explicit in the host projection. | Launch sequential personas or allow reviewers to mutate evidence. |
| Resolve deep procedures through canonical companion pointers. | Copy a second procedure tree into host storage or author file-relative hops that resolve from another base. |
| Preserve host-only deviations in overlays and manifests. | Put host IDs, permission JSON, or host sections into canonical bodies. |
| Attest behavior after restart or reload. | Mark Done because folders and files exist. |

### Path-resolution failure class (Required)

Host harness paths may resolve from the project working directory, host home, or another configured base—not from the Markdown file that contains the link. A relative hop can therefore look correct in the repository and resolve outside the host at runtime.

Required controls:

1. Host bootstrap instructions use explicit host-home tokens such as `{{OPENCODE_HOME}}` where the host requires absolute configuration values.
2. Deep procedure links use canonical companion tokens such as `{{COMPANION_ROOT}}/workflow/...`.
3. Overlay harness leaves contain no file-relative `../../docs`, `../../skills`, or `../../agents` procedure links.
4. Smoke asks the host to resolve and read the linked procedure, not merely to show that the file exists.

### Verification classes C1–C6 (Required)

| Class | Requirement | Minimum evidence |
| --- | --- | --- |
| **C1** | Always-on gates inject. | A clean session can quote the default-on plan and review gates, the when-in-doubt rule, and the non-exemption of operational work without tools. |
| **C2** | Skill catalog is complete. | The host catalog lists the governed skill IDs for that surface; a named skill loads through real host discovery. |
| **C3** | Plan and dual-review routes enforce isolation and gates. | Thin plan gets `CHANGES REQUESTED`; reviewers launch in parallel, deny edits, and receive separate clean inputs. |
| **C4** | Deep workflow reads resolve. | A host-loaded skill reads the named canonical workflow document from its companion pointer. |
| **C5** | Companion architecture and procedure reads work. | A representative FA/SOP/workflow read succeeds through the configured companion access surface without ad-hoc discovery. |
| **C6** | Smoke proves behavior, not presence. | The host scorecard records `pass`, `fail`, or `deferred: reason`; presence alone is never `pass`. |

First activation of a stack requires a full C1–C6 scorecard. A registry or wiring-only change may use the focused subset named by its host SOP, but any change to the active load surface requires renewed C1 and C6 evidence.

### Current activation posture

All seven stacks are registered. Codex activated 2026-09-08 and has a three-client C1–C6 runtime attestation. Other active host procedures remain governed by their host SOPs and the current manifests; historical bring-up narratives are not part of this architecture page.

Every registered overlay now has the structural `rules/` and `hooks/` extension surfaces: Cursor's rules directory retains its four native `.mdc` leaves, Codex's hooks directory carries the manifest-bound Stop hook, and the other new surfaces carry exact UTF-8 no-BOM `_index.md` placeholders. These surfaces are capacity and projection structure, not adaptation evidence by themselves. Content becomes behavior only through that host's manifest-bound load or lifecycle surface; activation still requires the applicable C1–C6 evidence. Codex's active always-on surface is the registry-composed canonical-gate and footer managed block, not a hand-authored overlay body.

Future refreshes and new stacks must meet the same fidelity bar. A stack may have host-specific mechanics, but it may not have a second authored loop, a permanent procedure mirror, or weaker review gates.

### Documentation boundary

| Page | Owns | Must not own |
| --- | --- | --- |
| This page | Fidelity bar, anti-patterns, C1–C6 classes, Done definition. | Per-host command logs or reusable smoke matrices. |
| [`instruction-layering.md`](./instruction-layering.md) | Context budget and load layers. | Host installation procedures. |
| [`skill-source-and-host-overlays.md`](./skill-source-and-host-overlays.md) | Source ownership, overlays, sync, and allowed deviations. | The full smoke matrix. |
| Host SOPs | Reusable setup, verification, smoke, and recovery commands. | Alternate canonical loop semantics. |

---

## Implications

1. Empty catalogs and failed companion reads are adaptation failures, not model preferences.
2. Manifest drift and loop drift are distinct; both must be checked before a host is considered healthy.
3. New host support is an architecture change and requires the implementation-review cycle.

---

## Related

- [Instruction layering](./instruction-layering.md)
- [Skill source and host overlays](./skill-source-and-host-overlays.md)
- [Intended workflow](./intended-workflow.md)
- [Procedure registry](./procedure-registry.md)
- [Host harness sync README](../../scripts/host-sync/README.md)
- [Feature architecture index](./_index.md)
