---
name: home-systematic-debugging
description: Diagnose bugs, test failures, performance regressions, build failures, and unexpected behavior from evidence before proposing or implementing a fix. Use when the cause is unknown or prior fixes failed.
---

# Systematic Debugging

Find the failing mechanism before changing code. Reuse facts already established in the conversation or by current-session tools; do not repeat an investigation merely to satisfy a phase checklist.

## Scope and Authority

- A diagnosis request ends with findings and evidence. Do not implement a fix unless the user asks for one.
- A fix request authorizes the smallest reversible change supported by the evidence.
- Ask the user only when the next step requires unavailable input, a destructive action, or a real scope decision.
- Do not present a root cause as confirmed when the evidence supports only a hypothesis.

## Workflow

1. **Define the symptom**
   - Capture the exact error, observed behavior, expected behavior, and affected boundary.
   - Reproduce it when practical. If it is intermittent, collect timing and environment evidence instead of guessing.
2. **Locate the failure**
   - Check relevant recent changes, configuration, dependencies, and one comparable working path.
   - In multi-component systems, inspect inputs and outputs at the smallest set of boundaries needed to locate the break.
   - Trace a bad value or state backward to the earliest point where it becomes wrong.
3. **Test one hypothesis**
   - State the hypothesis and the observation that would disprove it.
   - Run the smallest discriminating check. Change one variable at a time.
   - If disproved, update the hypothesis from the new evidence rather than stacking fixes.
4. **Fix when authorized**
   - Add a focused regression test or reliable reproduction when practical.
   - Change the source of the failure, not merely the visible symptom.
   - Avoid adjacent cleanup, refactoring, and speculative error handling.
5. **Verify**
   - Re-run the original reproduction and relevant regression checks.
   - Report passes, failures, skipped checks, and remaining uncertainty exactly as observed.

## Escalation

After three evidence-based hypotheses fail, stop adding local patches and question the architecture, hidden shared state, or test premise. Present the evidence and the decision that requires the user; do not continue with a fourth speculative fix.

## References

- Read [root-cause-tracing.md](root-cause-tracing.md) when the bad state originates deep in a call chain.
- Read [condition-based-waiting.md](condition-based-waiting.md) for timing and polling failures.
- Use [defense-in-depth.md](defense-in-depth.md) only after locating the root cause and when additional boundaries are justified.
- Use `home-verification-before-completion` before reporting the fix as verified.
