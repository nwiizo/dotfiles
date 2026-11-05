---
name: home-test-driven-development
description: Use a meaningful failing test for a reproducible bug or non-trivial behavior change with a practical test seam. Validate configuration natively.
---

# Demonstrate the Behavior Before Fixing It

Choose an observable result and a realistic defect that should fail the test.
Run the focused test before the fix and confirm the failure concerns that result.
Implement the correction, rerun it, then run required neighboring checks.

Derive expected results independently. Keep real components where practical,
mock external boundaries without removing the behavior being checked, and
avoid production APIs introduced solely for tests.

For generated cases, justify the property and input domain, pair them with known
examples, and retain a minimized deterministic regression. Round trips prove
identity only for lossless formats; a seed alone may not remain reproducible.

If detection remains uncertain, reintroduce one relevant defect in an isolated
copy and run the same test. Compile errors, timeouts, and broken fixtures do not
establish that the behavioral assertion caught it. A demonstrated RED/GREEN
already supplies that evidence without another mutation run.

Before testing a CLI that writes configuration or logs in, isolate the child
process's platform home and configuration paths and remove inherited auth
overrides. Keep concurrent tests' environments separate. A temporary home does
not isolate OS credential stores; use a controlled executable for login tests.
Real-account checks stay opt-in and separate.

For an existing implementation, use a safe pre-change reproduction if available;
otherwise state that the prior failure was not observed.
Use native parsers for configuration and skip artificial tests for prose.
