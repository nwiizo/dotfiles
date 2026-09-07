---
name: home-systematic-debugging
description: Diagnose bugs, test failures, performance regressions, build failures, and unexpected behavior from evidence before proposing or implementing a fix. Use when the cause is unknown or prior fixes failed.
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

Repeated failed hypotheses are a reason to revisit assumptions, shared state,
or the test premise. Continue when a new discriminating check is available.
Ask the user when missing input, a scope decision, or an unsafe next action
actually prevents progress; the number of attempts alone is not a stopping rule.

## Conditional References

- [root-cause-tracing.md](root-cause-tracing.md): a failure originating deep in a call chain.
- [condition-based-waiting.md](condition-based-waiting.md): timing and polling failures.
- [defense-in-depth.md](defense-in-depth.md): additional validation boundaries justified by the diagnosed cause.
