---
name: home-brainstorming
description: Clarify an idea or stress-test an existing design when material choices remain unresolved. Use for design exploration or a requested decision interview; skip routine implementation whose important choices are settled.
---

# Design Exploration

Produce a recommendation the user can assess from its intended outcome,
constraints, meaningful tradeoffs, and verification criteria.

Inspect the relevant project and settled decisions before asking questions.
Recommend an approach once the evidence supports it; show alternatives only
when a real tradeoff could change the user's choice. Discuss components, data
flow, failures, or migration only to the depth the design needs.

Express success as observable behavior, including the material failure case and
constraints. Separate the problem and intended outcome from a proposed technology.
If several capabilities can be delivered and verified independently, identify
their dependencies and the smallest end-to-end slice that tests the uncertain
assumption. Preserve the rest of the requested scope; a slice is an execution
order, not permission to drop requirements. Do not impose file-count thresholds.

When feasibility is the unknown, propose or run an authorized, bounded experiment
with a question and stop condition. Label prototype results and implementation
shortcuts; do not silently make the experiment the final design.

Separate missing user decisions from facts that can be checked during
implementation. A design-only request ends with the design. If implementation
is also requested, continue when its important choices are resolved.

Create a design file only when requested or required by the repository.
Do not add a review round, commit, or approval gate simply to finish the design.

If independent spec review is requested or otherwise authorized and useful, use
[spec-document-reviewer-prompt.md](spec-document-reviewer-prompt.md) for the review
criteria. A reviewer verdict does not replace a user's unresolved decision.

Adapted from [The Good Spec (2026-01-13)](https://addyosmani.com/blog/good-spec/),
reviewed 2026-10-27: keep outcomes testable and context scoped to the task, without
requiring a separate document or approval at every phase.

## Requested Design Interview

When the user asks to challenge an existing plan, follow its dependent
decisions and ask one material question at a time. Investigate factual answers
yourself; ask the user about priorities and tradeoffs. Finish with the settled
decisions, reasons, and remaining questions once the acceptance criteria are clear.

## Visual Companion

Use the optional browser companion only when a visual choice would benefit
from it and the user requests or has accepted it; do not ask again for existing
authorization. Then read [visual-companion.md](visual-companion.md).
A small inline diagram does not require starting the companion.
