# Cursor overlay — live workflow (Observed)

**Last updated:** 2026-08-20

## Context

Verbatim copy of the owner's **currently active** Cursor workflow from `C:\Users\admin\.cursor` on **2026-08-20** (skills also hashed 2026-08-19; unchanged since). Bodies were **not** edited (no provenance banners inside skill, rule, agent, or workflow files). Cursor product trees (`skills-cursor`, extensions, plugins, plans) were **not** copied.

This tree is **Observed** Cursor file wording. Portable **Target** summaries remain in [docs/skills](../../skills/_index.md) and [docs/agents](../../agents/_index.md). The 2026-08-17 bannered snapshot stays under [imported/cursor-global-workflow](../../research/imported/cursor-global-workflow/) for archaeology.

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
| plan-reviewer | [plan-reviewer.md](./agents/plan-reviewer.md) | [plan_reviewer](../../agents/plan_reviewer.md) |
| reviewer-a | [reviewer-a.md](./agents/reviewer-a.md) | [production_readiness_reviewer](../../agents/production_readiness_reviewer.md) |

There is no owner-authored `bugbot` agent file; Bugbot is a Cursor product subagent.

### Deep workflow docs

Live path `~/.cursor/docs/workflow/` → [docs/workflow/](./docs/workflow/README.md).

| Doc | File |
| --- | ---- |
| Index | [README.md](./docs/workflow/README.md) |
| ci-ladder | [ci-ladder.md](./docs/workflow/ci-ladder.md) |
| discovery | [discovery.md](./docs/workflow/discovery.md) |
| documentation-architecture | [documentation-architecture.md](./docs/workflow/documentation-architecture.md) |
| iterative-code-review | [iterative-code-review.md](./docs/workflow/iterative-code-review.md) |
| iterative-plan-review | [iterative-plan-review.md](./docs/workflow/iterative-plan-review.md) |
| phased-multi-agent | [phased-multi-agent.md](./docs/workflow/phased-multi-agent.md) |
| plan-agent-context | [plan-agent-context.md](./docs/workflow/plan-agent-context.md) |
| review-subagent-models | [review-subagent-models.md](./docs/workflow/review-subagent-models.md) |

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
| `docs/workflow/ci-ladder.md` | `E65EA861F78F95480E640E78C8E190457CF46F427CD856DA477BE42B67110DEC` |
| `docs/workflow/discovery.md` | `75AAB56E3C9CED2A078D2E83EF2E28494061D08500C0F5F6D228B64CB122F87B` |
| `docs/workflow/documentation-architecture.md` | `13F4DAF01DC429418F0B1D72BF0548A010935325337412212CC43302AED305EC` |
| `docs/workflow/iterative-code-review.md` | `832FAA757508CF864872C76A7BB328B82DCF065FA2E86D136451EAD1070D9D13` |
| `docs/workflow/iterative-plan-review.md` | `4E1D825A3E971B51FCC32ADA0B1A7746CE14C542CD2838AD76E02FED21B4E0CD` |
| `docs/workflow/phased-multi-agent.md` | `7C54BD26DCBE1C8337D1C86464AFD3D559E2E1AF542C95FE897309545457F275` |
| `docs/workflow/plan-agent-context.md` | `84E2F43167D52792770D04FD73381E4424CE9850BD42AA2FC111087BF287AC83` |
| `docs/workflow/README.md` | `CA7992181535FFE95D91EBA09CD125109A002B48EB35A8D793A65814652272D2` |
| `docs/workflow/review-subagent-models.md` | `DB7F24FDDEB1E619D4D54D6F7A80E28883F7940997B378AD4C8F238373A90E6B` |

### How to treat these files

- **Do not rewrite** bodies. They are the active Cursor definitions as of the extract date.
- **Do not** copy them to repo-root `.cursor/` (this repo is not a Cursor project tree).
- Refresh only by re-copying from live `~/.cursor` and updating hashes here.
- Copy-out **back** to `~/.cursor` is not authorized in this change.

## Implications / open questions

1. Live Cursor still loads `~/.cursor`. This folder is the in-repo record, not the running install.
2. OpenCode adapter files remain under `C:\Users\admin\.config\opencode\` until an OpenCode overlay extract.

## Related

- [Overlays index](../_index.md)
- [Skill contracts](../../skills/_index.md)
- [Agent contracts](../../agents/_index.md)
- [Skill source and host overlays](../../featureArchitecture/skill-source-and-host-overlays.md)
- [Phase 3 import (bannered)](../../research/imported/cursor-global-workflow/)
