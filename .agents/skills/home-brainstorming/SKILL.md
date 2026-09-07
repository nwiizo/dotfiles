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

Separate missing user decisions from facts that can be checked during
implementation. A design-only request ends with the design. If implementation
is also requested, continue when its important choices are resolved.

Create a design file only when requested or required by the repository.
Do not add a review round, commit, or approval gate simply to finish the design.

## Requested Design Interview

When the user asks to challenge an existing plan, follow its dependent
decisions and ask one material question at a time. Investigate factual answers
yourself; ask the user about priorities and tradeoffs. Finish with the settled
decisions, reasons, and remaining questions once the acceptance criteria are clear.

## Visual Companion

Use the optional browser companion only when a visual choice would benefit
from it and the user accepts it. Then read [visual-companion.md](visual-companion.md).
A small inline diagram does not require starting the companion.
