# Code-review evidence frame (optional)

An OPTIONAL evidence frame for the existing dual review gate, adapted from mattpocock/skills code-review at pinned commit [0ab1b63](https://github.com/mattpocock/skills/blob/0ab1b63/skills/engineering/code-review/SKILL.md). It activates ONLY when the parent supplies a fixed point and an originating spec in the reviewer invoke payload. Without those inputs, reviews run exactly as documented in iterative-code-review.md with no framing. It never adds a reviewer, changes verdict bars, or alters the default dual-gate count.

## When the frame applies

Parent opts in per iteration by adding two optional lines to the reviewer invoke payload: `Fixed point:` (a commit, tag, or branch the change set is measured from) and `Spec path:` (the approved plan/spec/issue describing intended behavior). Both must be present; either alone does not activate the frame.

## Fixed-point preflight

Resolve the fixed point before review. Compute the diff from that point to the current state; if the diff is empty there is nothing to review under the frame: report that and continue unframed rather than inventing findings. A non-empty diff is required, matching the local rule that review covers a real changeset.

## The two axes

**Standards:** whether the change follows the repository's own standards documents and conventions, plus explicitly labelled code-smell classes judged with deep-module vocabulary ([codebase-design](../skills/codebase-design/CORE.md)) where useful: shallow interfaces, pass-through layers, duplicated knowledge, misplaced responsibility. Name each smell class; do not import any fixed external checklist.

**Spec:** whether the change faithfully implements the supplied spec or plan: missing requirements, extra behavior beyond scope, and incorrectly implemented requirements. Cite spec lines or requirement identifiers. If no spec was supplied, say so plainly; never infer requirements from the code.

## Citation rules

Every framed finding cites exactly one of: a named standard or convention document plus the offending hunk; a labelled smell class plus the hunk; or a spec line or requirement identifier plus the deviation. Uncitable observations are not reported as framed findings.

## Aggregation

Each reviewer keeps its own lists and verdict bar unchanged. Framed findings are tagged by axis and reported separately; the worst issue per axis is preserved rather than blended into a single ranking. The phase closeout notes that the frame ran, the fixed point used, and the spec path supplied.

## Recursion prohibition

Reviewer agents operating under this frame never invoke the review skill themselves, never spawn further reviewers or subagents, and never re-launch reviews of their own output. The parent owns every launch.

## Related

- [implementation-review](../skills/implementation-review/SKILL.md)
- [iterative-code-review](iterative-code-review.md)
- [codebase-design vocabulary](../skills/codebase-design/SKILL.md)
