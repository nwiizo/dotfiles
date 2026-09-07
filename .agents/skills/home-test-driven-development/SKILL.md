---
name: home-test-driven-development
description: Use for non-trivial behavior changes or reproducible bugs with a practical automated-test seam. Verify a meaningful failing test before the fix; use native validation for config and skip artificial tests for prose or trivial changes.
---

# Test-Driven Development

Use a focused test to demonstrate the missing or broken behavior, then implement
the smallest change that passes it and run the relevant neighboring checks.
Confirm RED is caused by the intended behavior, not a broken fixture or environment.
Refactor within scope while the tests remain green.

## Test Integrity

- Choose an observable outcome and a realistic bug that would make the test fail.
  Avoid checks of source-text presence, private structure, or intentional constants.
- Derive expected results independently of the implementation under test.
- Use real components where practical. Mock external or slow boundaries without
  removing the side effects or response shapes the behavior depends on.
- Assert call order only when that interaction is itself required behavior.
- Do not add dependencies or production APIs solely to enable a test.

## Existing Work and Exceptions

- Do not manufacture RED for an implementation that already exists. Use a safe
  pre-change reproduction when available; otherwise add the strongest regression
  check and state that the pre-change failure was not observed.
- Respect an explicit user decision to skip tests and use available alternative
  verification. Do not add an approval round for ordinary testing choices.
- Validate config-only edits with the native parser, linter, or application check.
  Do not test prose, generated text, or trivial pass-through code just for process.
- For legacy code, use the nearest stable behavior boundary; do not redesign a
  subsystem solely to test one small change.
- Report the relevant command results and any verification limit.

Adapted from obra/superpowers' test-driven-development and writing-good-tests
guidance (MIT).
