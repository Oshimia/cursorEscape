# Theo `fleet` skill management (Observed)

**Last updated:** 2026-08-19

## Context

Observed characterization of how Theo (t3.gg) manages AI skills in a git repo named **fleet**, from a video walkthrough. This is **not** Target cursorEscape design. Target analog (skill/workflow manager across **stacks**, not machines) lives in [design decisions](../review/design-decisions.md) and [Roadmap](../docs/Roadmap.md). Overlay architecture (how stacks vary without dual documentation trees): [skill-source-and-host-overlays](../docs/featureArchitecture/skill-source-and-host-overlays.md).

Claim labels: **Observed** (transcript), **Target** (cursorEscape intent cited from hubs).

---

## Substance

### What `fleet` is (Observed)

Theo maintains a repository called **fleet** where he keeps skill files and related agent config. He uses **T3 Code** threads against that repo to install or adapt skills (for example pulling **wizard** from Matt Pocock’s skills repo if it is missing). He treats the repo as the place that “saved [his] ass so many times,” and he copies selected skills onto **multiple machines** (laptop, other boxes, a new Mac Mini). After an install, he confirms the skill is “on all my machines.”

He does **not** blindly vendor entire public skill packs. He asks an agent to **rip the parts he wants** into the fleet directory. Public suites mentioned as sources (not imported here): Matt Pocock skills-for-engineering; Lauren’s P-stack (including **unslop**). Most public skill repos he dismisses as slop.

He also described a **T3 skill-manager** UI he was building: cross-computer management, enable/disable, and **groups** of skills (P-stack vs Matt) turned on or off together. That is Observed T3 product intent, not a cursorEscape deliverable.

### Analog and deltas (Target)

| Dimension | Observed (`fleet`) | Target (cursorEscape) |
| --------- | ------------------ | --------------------- |
| Job | Git home for installed skill files | Git home for **personal workflow IP**: skills, agents, gates — later canonical overlay tree |
| Distribution | Copy onto **machines** | Apply across **stacks** (Cursor, OpenCode; T3 as control plane only) |
| Multi-machine sync | Core to his setup | **Non-goal** until the owner says otherwise |
| Public skill packs | Rip selected files into fleet | **Out of scope** for this research note; owner may audit later |
| T3 role | Cockpit **and** skill-manager experiments | Control plane (threads, diffs); **does not own** skill contracts |

cursorEscape remains docs-first until an authorized copy-out: host folders (`~/.config/opencode`, live `~/.cursor`) stay install/adapter locations, not a second authored SoT. Do not create empty `adapters/` trees in this characterization.

### What this note does not cover

- Audit or import of Matt / P-stack skill contents.
- How OpenCode vs Cursor overlays should be authored (Target FA, not Observed fleet).

---

## Implications / open questions

1. Hub identity copy now states **skill/workflow manager** and **stacks not machines** ([design decisions](../review/design-decisions.md)).
2. Live `~/.cursor` import is **Observed interim Cursor wording** (not a procedure SoT). Companion-repo contracts are Target.
3. Installing overlays into host folders (`~/.config/opencode`, `~/.cursor`) is later copy-out from this repo; not multi-machine sync and not implied as done by this Observed note.

---

## Sources

- In-repo transcript: [Theo - t3.gg video transcript.md](./Theo%20-%20t3.gg%20video%20transcript.md) (fleet / machine-sync / skill-manager passages ~21:48–27:57)
- Video: [https://www.youtube.com/watch?v=0oXOOlqVu5M](https://www.youtube.com/watch?v=0oXOOlqVu5M)

---

## Related

- [Design decisions](../review/design-decisions.md)
- [Roadmap](../docs/Roadmap.md)
- [Host recreation](../analysis/host-recreation-2026-08.md)
- [Research index](./_index.md)
- [Skill source and host overlays (Target)](../docs/featureArchitecture/skill-source-and-host-overlays.md)
