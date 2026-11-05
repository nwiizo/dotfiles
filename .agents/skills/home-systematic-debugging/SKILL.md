---
name: home-systematic-debugging
description: Diagnose unknown bugs, failing tests or builds, and performance regressions from observations; trace confirmed defects into other affected paths.
---

# Find the Failing Mechanism

Capture expected and actual behavior at the affected boundary.
Reproduce it when practical, then trace the wrong value or state to its source.
Reuse current evidence and compare a working path or relevant recent change.

Choose a hypothesis and the smallest observation that can disprove it.
Update the explanation when evidence disagrees. Repeated failed guesses call
for a different assumption or boundary, rather than more speculative patches.

For a fix, correct the cause through affected callers and verify the original
reproduction. Search variants using the known instance first; distinguish real
defects from look-alikes protected elsewhere. State the searched scope.

For latency, identify sequential waits and the path determining completion.
Overlap independent work only with preserved ordering, cancellation, and resource
limits. Compare equivalent inputs and cache conditions; distinguish queueing,
build, tests, elapsed time, total work, throughput, and backend load.

Read [root tracing](root-cause-tracing.md) for deep call chains,
[condition-based waiting](condition-based-waiting.md) for timing failures,
[validation boundaries](defense-in-depth.md) for justified additional checks, or
[Web performance evidence](web-performance-evidence.md) for browser latency.
Diagnosis-only requests end with findings; fix requests continue through verification.
