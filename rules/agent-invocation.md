# Agent invocation (mandatory)

**Default on for every governed spawned child-agent invocation.**

1. Begin each child-facing invocation with the canonical envelope in [`workflow/agent-invocation.md`]({{COMPANION_ROOT}}/workflow/agent-invocation.md): canonical role identity, first-read contract, required companion reading, host alias, isolation, authority, and loop/gate.
2. Put all existing task-specific inputs after the envelope separator. Never rely on host metadata, nearby prose, or prior transcripts to establish identity.
3. A host alias is routing metadata only. The canonical role contract and required reading remain authoritative.
4. If the envelope is missing, malformed, internally contradictory, or unreadable, the child must stop and fail loudly in its role-native output shape. It must not infer identity and proceed.

Detail and role map: [workflow/agent-invocation.md]({{COMPANION_ROOT}}/workflow/agent-invocation.md).
