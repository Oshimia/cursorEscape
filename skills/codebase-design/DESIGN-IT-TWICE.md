# Design Alternatives

When a caller has a real deepening candidate, compare more than the first
interface that comes to mind. The aim is a reasoned choice, not a mandatory
artifact or a prescribed workflow.

## Frame alternatives

State the problem, caller constraints, dependency categories, and what would
sit behind the seam. Keep the sketch illustrative rather than treating it as
an approved design. Include the interface's observable behavior, invariants,
ordering, and error modes.

## Isolated comparisons

If the caller chooses to seek independent designs, it may invoke isolated
agents in parallel with separate briefs. Use generic isolated-agent language,
not a host-specific tool or named dispatch mechanism. Pack the repository
context, relevant paths, vocabulary, constraints, and each design brief into
every invocation. Do not rely on a prior transcript or shared child memory.

Useful contrasting briefs include:

- minimize the interface to one to three entry points;
- maximize flexibility for justified variation;
- optimize the common caller path;
- place an explicit port and adapters at a cross-seam dependency.

Each response can describe the proposed interface, usage, hidden
implementation, dependency/adapters, and trade-offs. These are suggested
comparison fields, not a required output schema.

## Compare

Compare alternatives by depth and leverage, locality, interface size and
clarity, seam placement, dependency cost, and whether the deletion and
two-adapter seam tests still make sense. A hybrid can be preferable when its
extra surface has a clear payoff. The caller decides whether to recommend,
record, or implement a result; this reference performs none of those actions.
