# Cursor overlay — live workflow (Observed)

**Last updated:** 2026-08-20

## Context

Fat **Observed interim extract** of the owner's **currently active** Cursor workflow from `C:\Users\admin\.cursor` on **2026-08-20** (skills also hashed 2026-08-19; unchanged since extract). Extract bodies carry no provenance banners inside skill, rule, agent, or workflow files. Cursor product trees (`skills-cursor`, extensions, plugins, plans) were **not** copied.

This tree is **Observed** Cursor file wording — **not** a permanent freeze target (thin wrappers in Phase 5). Portable **Target** contracts: repo-root [`workflow/`](../../workflow/_index.md) (deep procedure since Phase 3); interim [docs/skills](../../docs/skills/_index.md) and [docs/agents](../../docs/agents/_index.md) (→ gold bases after Phase 4). The 2026-08-17 bannered snapshot stays under [imported/cursor-global-workflow](../../research/imported/cursor-global-workflow/) for archaeology.

## Substance

### Skills

| Skill | Files |
| ----- | ----- |
| implementation-plan | [SKILL.md](./skills/implementation-plan/SKILL.md), [user-rules-snippet.md](./skills/implementation-plan/user-rules-snippet.md) |
| implementation-review | [SKILL.md](./skills/implementation-review/SKILL.md), [user-rules-snippet.md](./skills/implementation-review/user-rules-snippet.md) |
| composer | [SKILL.md](./skills/composer/SKILL.md), [user-rules-snippet.md](./skills/composer/user-rules-snippet.md) |
| documentation-architecture | [SKILL.md](./skills/documentation-architecture/SKILL.md) |
| roadmap | [SKILL.md](./skills/roadmap/SKILL.md) |

### Rules

| Rule | File |
| ---- | ---- |
| iterative-plan-review | [iterative-plan-review.mdc](./rules/iterative-plan-review.mdc) |
| iterative-code-review | [iterative-code-review.mdc](./rules/iterative-code-review.mdc) |
| pre-commit-ci-gate | [pre-commit-ci-gate.mdc](./rules/pre-commit-ci-gate.mdc) |

### Agents

| Agent | File | Target contract |
| ----- | ---- | --------------- |
| plan-reviewer | [plan-reviewer.md](./agents/plan-reviewer.md) | [plan_reviewer](../../docs/agents/plan_reviewer.md) |
| reviewer-a | [reviewer-a.md](./agents/reviewer-a.md) | [production_readiness_reviewer](../../docs/agents/production_readiness_reviewer.md) |

There is no owner-authored `bugbot` agent file; Bugbot is a Cursor product subagent.

### Deep workflow docs

**Gold SoT (Phase 3+):** repo-root [workflow/_index.md](../../workflow/_index.md). Live Cursor copy-out: `~/.cursor/docs/workflow/` (not overwritten from this repo).

| Doc | File |
| --- | ---- |
| Index + used-by matrix | [workflow/_index.md](../../workflow/_index.md) |
| review-subagent-models (overlay-only) | [review-subagent-models.md](./review-subagent-models.md) |

**Fat extract contract (Phases 3–4):** SKILL.md, agent, and rule **bodies** in this overlay still contain `../../docs/workflow/` links from the live extract. Those paths are **non-navigable in-repo** until Phase 5 thin wrappers retarget them at `workflow/`. Do **not** edit fat bodies for link repair during Phases 3–4; use repo-root `workflow/` for deep procedure.

### SHA256 at extract (live = overlay)

| Path | SHA256 |
| ---- | ------ |
| `skills/composer/SKILL.md` | `13B447CF8300BF846B545DAB7255C66B02BBB5B073B48FD369D3CE42459BEBFA` |
| `skills/composer/user-rules-snippet.md` | `A62DD83E75C565A067AAE57FE2063450AD1588822CFC51018722F2C93A30F5CF` |
| `skills/documentation-architecture/SKILL.md` | `BAB2096395F5C2591EE21769AA82B00134057CF0557B73B84FD437954EBA5593` |
| `skills/implementation-plan/SKILL.md` | `9E68A52F16B8598196F1A326FEDBE471952E7EFA61E8310BC50746407A14BEBA` |
| `skills/implementation-plan/user-rules-snippet.md` | `1D57F5941AEB616D8D3A84B546F218631FEB147284E33A953428AF599BA77741` |
| `skills/implementation-review/SKILL.md` | `08A9E4BCA7EE914762059445F6615E3853CA81786285C6B2F51294B49BFACBEB` |
| `skills/implementation-review/user-rules-snippet.md` | `5FFD0953A28B2C6905EF1C2DC13BB1F3994C009C4D788CE3A5731445BBF0ACAB` |
| `skills/roadmap/SKILL.md` | `285EFF0116A673F9DAED8CE6E28CC7D23BE2419F2A09E301C4C096271EE77501` |
| `rules/iterative-code-review.mdc` | `B23F9EA4A398ACB99D286390EBEF353BE230A7CF174531016C7E8A421C2DA8FD` |
| `rules/iterative-plan-review.mdc` | `B7016FA137F2A7969B26C255657E48299531065FBF82E61E1AE3C452683BDA37` |
| `rules/pre-commit-ci-gate.mdc` | `FF04B91FDAC4D743E623773B0526FFF5A989FEE93FB4B2418944920E3C4CD015` |
| `agents/plan-reviewer.md` | `250D7A06AD24E0CF6558B26C9EFAF56B9D3ABCF88DDA1057E633F7C615D96D97` |
| `agents/reviewer-a.md` | `417A82D3C6AD1E87F25D47C38135134E1D40D99372C58414D679D778653EBA3D` |

Deep workflow procedure moved to repo-root [`workflow/`](../../workflow/_index.md) in Phase 3 — `docs/workflow/` SHA256 rows retired. `review-subagent-models.md` relocated to overlay root and link-updated (hash not tracked post-move).

### How to treat these files (index policy — Approach A)

- **Bodies:** Fat Observed interim extract as of the extract date. **Not** a permanent freeze target — Phase 5 replaces them with thin wrappers pointing at gold bases (`skills/`, `agents/`, `rules/`, `workflow/`). Do **not** edit overlay SKILL/agent/rule bodies for portable procedure during Phases 1–4; portable edits go to repo-root `workflow/`, interim `docs/skills/`, `docs/agents/`, FA, or overlay **index** per [overlay FA](../../docs/featureArchitecture/skill-source-and-host-overlays.md) promotion rule.
- **Do not** copy them to repo-root `.cursor/` (this repo is not a Cursor project tree).
- Refresh extract by re-copying from live `~/.cursor` and updating hashes here when authorized.
- Copy-out **back** to `~/.cursor` is not authorized.

## Implications / open questions

1. Live Cursor still loads `~/.cursor`. This folder is the in-repo record, not the running install.
2. OpenCode adapter files remain under `C:\Users\admin\.config\opencode\` until an OpenCode overlay extract.

## Related

- [Overlays index](../_index.md)
- [Skill contracts](../../docs/skills/_index.md)
- [Agent contracts](../../docs/agents/_index.md)
- [Skill source and host overlays](../../docs/featureArchitecture/skill-source-and-host-overlays.md)
- [Phase 3 import (bannered)](../../research/imported/cursor-global-workflow/)
