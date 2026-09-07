# Root Cause Tracing

Use this reference when a bad value or state reaches a failing operation through
several callers. Find where the value first becomes invalid or violates an
established assumption.

## Trace the Smallest Relevant Chain

- Record the failing operation, actual input, expected input, and runtime context.
- Follow the value through callers, defaults, conversions, and initialization.
  Compare a working path when it helps distinguish the cause.
- Add temporary instrumentation only where the chain is unclear. Use the
  project's test output or logger, capture the relevant stack or state, and
  avoid dumping credentials or unrelated environment variables.
- Verify a suspected source with an observation or focused reproduction.
  Do not treat the nearest visible failure as proof of its origin.

For example, a test fixture may expose an empty working directory before setup
runs. A later process launch then uses the current directory and creates files
in the source tree. Correct the fixture lifecycle and reject invalid input at
the operation's actual boundary; choose additional guards from the paths that
can still reach the operation.

If the source is outside the editable scope, document it and distinguish any
authorized mitigation from a permanent fix. Do not keep tracing unrelated code
merely to avoid reporting that boundary.

## Find a Test That Leaves State Behind

Use the repository's test filters or bisection support in an isolated workspace.
Check the suspected artifact before and after each run and inspect test exit
codes. Preserve existing user files and state.

The bundled [find-polluter.sh](find-polluter.sh) is an npm-specific diagnostic
example. It suppresses test failures and skips cases when the artifact already
exists, so its final message does not prove that the tests ran successfully.
Inspect those limitations before using it; prefer the project's existing runner.

After fixing the source, verify the original reproduction and relevant
regressions. Read [defense-in-depth.md](defense-in-depth.md) when another reachable
boundary still needs protection. Report the observed coverage without claiming
that every future variant is impossible.
