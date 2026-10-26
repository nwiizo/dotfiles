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
- Check which required checks actually ran against which revision. A green
  workflow or a successful agent process can contain skipped or absent checks.
  Distinguish a missing check configuration from a failing product test; repair
  configuration within scope instead of dropping the requirement to obtain green.

For CLI installation or shell-integration work, check the executable resolved by
the user's PATH and exercise the affected function in the actual shell. A build
in `target/` does not establish that the installed command was updated, and a
shell parser check does not establish that a selection reaches the next process.

For explicitly requested account E2E, distinguish forwarding to a fake executable,
checking a real login identity, and obtaining a real service response. Verify the
requested switching/return path without exposing tokens or persisting identities
in fixtures. If user login is needed, provide the exact local command and leave
codes in the user's terminal. Report the level actually tested; authentication
status alone is not evidence of a successful model response.

Use a safe red/green comparison when it adds meaningful confidence. Do not
revert user work or manufacture a failure merely to claim the sequence occurred.
