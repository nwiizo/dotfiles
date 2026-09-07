# Condition-Based Waiting

Use this reference when a failure depends on asynchronous readiness, event
ordering, or an unexplained delay. Wait for the observable condition the test
needs and bound the wait.

## Reuse the Existing Mechanism

Prefer the framework's asynchronous assertions, event subscriptions, process
completion handles, or existing wait helper. Do not add a custom polling
abstraction when the current tools already express the condition.

Choose a condition that demonstrates readiness for the next operation. Process
existence, elapsed time, or the presence of a file may be insufficient if the
operation needs an initialized service or complete file contents.

## Bound and Observe the Wait

- Set a deadline based on the operation and test environment. Include the
  expected condition and last relevant observation in timeout diagnostics.
- Read fresh state on each attempt. Subscribe before triggering an event when
  otherwise the test could miss it.
- Match the polling interval to expected latency and resource cost; do not copy
  a fixed interval into every test.
- Separate successful completion from truthiness when zero, false, or an empty
  result is a valid outcome.
- Clean up subscriptions, timers, and test resources on success, timeout, and
  cancellation.

For debounce, throttling, or other timing behavior, use the framework's controlled
clock when practical. If real elapsed time is part of the requirement, explain
the interval and timing tolerance rather than replacing it with a readiness test.

[condition-based-waiting-example.ts](condition-based-waiting-example.ts) contains
TypeScript examples for event-based tests. Read it only when that setup matches
the task; its timeout and polling defaults are examples, not universal values.
