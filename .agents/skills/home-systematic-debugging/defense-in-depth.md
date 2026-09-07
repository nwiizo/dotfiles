# Validation at Relevant Boundaries

Use this reference when the diagnosed failure shows that invalid data can reach
an operation through more than one entry point or trust boundary.

Preserve existing security and data-loss protections. Add a check where it
protects a distinct reachable path or enforces an invariant owned by that layer;
do not duplicate validation at every internal call merely to fill a pattern.

## Choose the Checkpoint

- **External input:** reject malformed or unauthorized input before it becomes
  trusted internal state.
- **Operation invariants:** validate requirements specific to the operation,
  including callers that legitimately bypass the usual entry point.
- **Destructive effects:** resolve the exact destination and use the existing
  containment and authorization checks before filesystem or process mutations.
  A string-prefix comparison alone does not establish path containment; account
  for path components and relevant symlink behavior.
- **Diagnostics:** capture only the context needed to identify an unresolved
  failure. Logging explains a failure; it does not prevent one.

A typed or otherwise enforced invariant may already cover downstream calls.
Identify what could invalidate it before adding another check. Keep necessary
trust-boundary validation even when similar checks exist elsewhere.

## Verify the Protection

Connect each new check to a concrete failure path and exercise that path with a
focused test. Include a permitted operation so the guard does not simply reject
all work. Use isolated resources for tests involving destructive effects.

Keep added protections within the requested fix. Record broader hardening
opportunities separately when they require new scope. Report which paths were
verified and what remains uncertain; passing checks do not prove a bug impossible.
