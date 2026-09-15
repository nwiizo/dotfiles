---
name: home-verification-before-completion
description: Check completion claims against tests and artifacts when verification evidence is missing, uncertain, or supplied by another agent.
---

# Verification Before Completion

Match each material claim to current evidence and the risk of the change.

- Run checks relevant to the final changed state and read their exit codes.
  Reuse current-session results while the tested state and dependencies remain
  unchanged; do not rerun a passing check just to complete a ritual.
- A fix needs the original reproduction or an equivalent regression check.
  A formatter does not prove a build, and a unit test does not prove integration.
- Inspect delegated artifacts and their verification evidence. An agent's
  completion message alone is insufficient.
- Report failed and unavailable checks with the affected limit on confidence.
  Do not treat an empty output, a skipped check, or a blocked environment as a pass.
- Separate completed edits from unresolved verification. Repeat a blocked check
  only after something relevant changes.

Use a safe red/green comparison when it adds meaningful confidence. Do not
revert user work or manufacture a failure merely to claim the sequence occurred.
