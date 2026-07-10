---
name: home-verification-before-completion
description: Ground progress and completion claims in fresh tool evidence. Use before reporting work complete, fixed, passing, ready to commit, or ready to publish, especially after agent delegation.
---

# Verification Before Completion

Report the observed state, not the expected state. Verification strength should match the claim and the risk of the change.

## Claim Audit

Before a progress or completion report:

1. List the claims you are about to make.
2. Name the command, artifact, or tool result that supports each claim.
3. Run the relevant checks after the final change.
4. Read the exit code and result counts; do not infer one check from another.
5. Classify each claim as verified, failed, skipped, or blocked.
6. Report the result without hedging verified work or hiding gaps.

## Evidence Map

| Claim | Evidence |
|---|---|
| Tests pass | Relevant test command completed with zero failures |
| Linter is clean | Relevant lint command completed with zero errors |
| Build succeeds | Build command exited successfully |
| Bug is fixed | Original symptom or regression test now passes |
| Requirements are met | Acceptance checklist checked against artifacts and results |
| Agent work is complete | Inspect the diff or artifact, then run independent verification |

A formatter does not prove a build. Unit tests do not prove an unrun integration suite. An agent's status message does not prove its artifact.

## Partial and Blocked Verification

- Separate implementation state from verification state.
- State successful checks with their results.
- State failed or unrun checks and the affected confidence boundary.
- Name the external condition or user input needed to finish verification.
- Do not rerun a blocked check in a loop without a state change.

## Regression Checks

Use a red-green check when it is practical and materially increases confidence: show that the regression test fails without the fix and passes with it. Do not force destructive or high-cost reversions merely to satisfy the pattern; explain the safer evidence used instead.

## Final Report

Lead with the outcome. Include the verification command and observed result in plain language, then list any remaining unverified area. Never describe a skipped or failed check as passing.
