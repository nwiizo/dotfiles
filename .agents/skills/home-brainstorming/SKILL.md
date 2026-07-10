---
name: home-brainstorming
description: Use before non-trivial creative work when a material product or design choice is still unresolved. Clarifies purpose, constraints, success criteria, and tradeoffs before implementation. Skip when the request is trivial or already well specified.
---

# Brainstorming Ideas Into Designs

Turn an unclear idea into a decision-ready design. Scale the process to the uncertainty; do not force a ceremony onto a task whose important choices are already settled.

## Boundary

- This skill produces a design or recommendation. Do not implement unless the user also asks for implementation.
- Do not create or commit a design document unless the user requests one or the repository requires it.
- Inspect project context before asking questions. Resolve facts from files and tools when possible.
- Pause only for a choice that materially changes scope, an irreversible action, or information only the user can provide.
- When enough information is available, recommend and finish the design. Do not add approval gates between sections.

## Workflow

1. Read the relevant files, local guidance, and recent changes.
2. State the work contract in compact form:
   - purpose: what progress the design should enable
   - scope: what is included and excluded
   - success: observable acceptance and verification criteria
   - constraints: compatibility, safety, cost, and operational boundaries
3. Identify only the unknowns that could change the design. Ask one question at a time when an answer must come from the user.
4. Lead with the recommended approach. Present alternatives only when they expose a real tradeoff the user may choose differently.
5. Describe the design at the level the task needs: components, data flow, failure behavior, migration, and validation. Omit irrelevant sections.
6. Separate unresolved decisions from facts to verify during implementation.

## Working in Existing Codebases

- Follow existing patterns unless they cause a problem inside the requested scope.
- Include targeted structural improvements only when the requested design depends on them.
- Avoid unrelated refactoring and hypothetical extensibility.
- Prefer small units with explicit interfaces when isolation materially improves testing or change safety.

## Output

Lead with the recommendation, then give:

- the design and why it fits
- meaningful tradeoffs and rejected alternatives
- acceptance and verification criteria
- unresolved user decisions, if any
- implementation-time checks that do not block the design

## Visual Companion

Offer `visual-companion.md` only when a mockup, layout, or diagram would materially clarify a live decision. Ask once, at the point it becomes useful. If accepted, read the reference and use the browser for visual choices; keep textual requirements and tradeoffs in the conversation.
