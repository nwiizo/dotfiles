---
name: home-systematic-debugging
description: Diagnose bugs, test failures, performance regressions, build failures, and unexpected behavior from evidence. Use when the cause is unknown, prior fixes failed, or a confirmed defect needs a search for other affected paths.
---

# Systematic Debugging

Locate the failing mechanism before changing code. Reuse current evidence rather
than restarting discovery to satisfy a checklist.

- Capture the symptom, expected behavior, and affected boundary. Reproduce it
  when practical; intermittent failures may need timing or environment evidence.
- Trace the bad value or state through the smallest relevant set of boundaries.
  Compare recent changes and a working path where useful.
- Test a hypothesis with an observation that can disprove it. Change one relevant
  variable at a time; update the explanation instead of stacking speculative fixes.
- For a fix request, repair the source of the failure across the affected flow
  and verify the original reproduction plus relevant regression checks.
  A diagnosis-only request ends with findings and supporting evidence.
- Separate a confirmed cause from a hypothesis, and completed work from
  unresolved verification.

When a defect is confirmed, describe the input, missing condition, and observable
failure before searching for variants. First confirm the search finds the known
instance, then widen identifiers or call patterns incrementally. Inspect callers,
wrappers, and data flow before treating a match as another bug: validation may
already occur at a different boundary. Keep confirmed cases, safe look-alikes,
and unresolved candidates distinct. Repair within scope and preserve intentional
differences; report searched boundaries rather than claiming repository-wide absence.

For latency, locate sequential waits and the path determining completion before
optimizing small local operations. Overlap only independent work; preserve
authorization, ordering, cancellation, and resource limits. Check throughput,
tail latency, and backend load under comparable inputs before calling a change
faster. Removing a wait from one request can merely move work or contention elsewhere.

For slow builds or CI, separate queueing, setup, compilation, tests, and artifact
handling before choosing a fix. Compare equivalent inputs and cache conditions;
total job time and elapsed workflow time answer different questions. Parallelism
can duplicate setup or add contention. Preserve failing checks and missing-result
signals when changing retries, caches, or report collection; a greener dashboard
does not by itself establish that the original failure is fixed.

Repeated failed hypotheses are a reason to revisit assumptions, shared state,
or the test premise. Continue when a new discriminating check is available.
Ask the user when missing input, a scope decision, or an unsafe next action
actually prevents progress; the number of attempts alone is not a stopping rule.

## Conditional References

- [root-cause-tracing.md](root-cause-tracing.md): a failure originating deep in a call chain.
- [condition-based-waiting.md](condition-based-waiting.md): timing and polling failures.
- [defense-in-depth.md](defense-in-depth.md): additional validation boundaries justified by the diagnosed cause.
