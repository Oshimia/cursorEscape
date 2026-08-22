# Prototype pattern (advisory)

A pattern for answering one design question at a time with throwaway code. Companion skill: [prototype](../skills/prototype/SKILL.md). Vocabulary note: when a logic prototype lifts a module-shaped sketch, **interface** and **seam** keep their [codebase-design](../skills/codebase-design/CORE.md) meanings informally; nothing here defines architecture, it borrows vocabulary.

## State the learning question first

One sentence: what would we know after building this that we do not know now? Write it down before any code, together with how the answer will be observed. If no clear answer exists, the right move is discussion, planning, or [grilling](grilling.md#documented-alignment) instead of a prototype.

## Choose the form

**Logic prototype:** answers a behavior or feasibility question. Keep it a pure, liftable module: inputs in, result out, no entanglement with product wiring, and state rendered so a non-developer can see what it shows. **UI prototype:** answers an interaction, layout, or appearance question. Build structurally different variants side by side, each visibly labeled, so comparing them is observation rather than memory.

## Disposable path

Build only on a location the owner approves for throwaways, discovered from the target repo's own conventions (a tmp or scratch area, never product source trees). The path is declared at creation along with the expected lifetime of the artifact; prototypes that outlive their question have failed their purpose.

## Visible state

The answer must be observable by running or inspecting the artifact, not argued from reading it. A logic prototype prints or renders its result clearly; a UI prototype shows its variants distinctly. If the artifact cannot show the answer, the question or the form is wrong: revise one of them rather than debating.

## Disposition gate

When the question is answered, choose explicitly, with the owner: **discard** (delete the artifact), **quarantine** (move it to a clearly named archive location), or **promote** (route it through [implementation-plan](../skills/implementation-plan/SKILL.md) normal gates as a proposed change). Promotion is a decision made through gates, never a side effect of the code existing. Record the choice alongside the answer.

## Record the answer

Write the learned fact into the conversation, plan, or research artifact per the [documented alignment](grilling.md#documented-alignment) policy. The answer outlives the artifact; that is the point of throwing the artifact away.

## Related

- [Prototype skill](../skills/prototype/SKILL.md)
- [Clean context and isolation](../docs/featureArchitecture/clean-context-isolation.md)
- [Documented alignment](grilling.md#documented-alignment)
- [Codebase-design vocabulary](../skills/codebase-design/CORE.md)
- [Workflow docs index](_index.md)
