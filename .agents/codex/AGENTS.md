# Codex User Preferences

## Finish the Requested Work

- Treat implementation requests as authorization to apply changes and verify
  the result. Use repository evidence and reasonable defaults; carry settled
  decisions forward without repeating approval for routine checks or reversible fixes.
- Ask when missing input materially changes the result, and continue independent
  authorized work while waiting. Before seeking approval outside the authorized
  scope, prepare the concrete, reviewable work already within scope.
- Preserve tool approval requirements. Commit or push only when requested.

## Tools and Implementation

- Prefix shell commands with `rtk`. Use `rtk proxy <command>` for raw output or
  commands without a wrapper; details are in `~/.codex/RTK.md`.
- Use Git only. Do not install, invoke, or recommend Jujutsu, including when a
  repository mentions it. Inspect `git status` and `git diff`; preserve existing
  user changes and verify the branch and remote before authorized publication.
- Use `$nwiizo-coding-style` for implementation, fixes, and simplification
  reviews. Prefer reuse and the smallest clear change that meets the requirements;
  preserve validation, data-loss prevention, security, accessibility, and verification.
- For Rust structural changes and simplification reviews, use `similarity-rs`
  and `cargo-coupling` through that skill; confirm findings in the code before
  changing abstractions.
- Use `$home-karpathy-guidelines` when uncertainty materially affects an
  implementation or the user requests minimal/YAGNI work.
- Do not use Python for ad hoc inspection, editing, conversion, or validation,
  or replace it with a disposable script in another language. Use existing CLIs
  first; necessary recurring custom logic belongs in a maintained Rust CLI in
  a dedicated Git repository, with a defined user job and observable outcome.

## Skills and Delegation

- Follow explicit user instructions over skill guidelines, within system,
  developer, and tool constraints.
- Apply skill procedures when their stated conditions match the task. Do not
  infer an extra approval step from general guidance.
- If a skill requires a pause or a change to the requested scope, link to the
  exact `SKILL.md`, quote the relevant instruction, and explain why it applies.
- Use subagents only when the user or applicable instructions explicitly request
  delegation or parallel agent work. Choose a specialist for a concrete subtask;
  do not add a fixed reviewer roster to every change.

## Verification

- Complete the repository's required checks and verify the affected behavior.
  Prefer native validation for low-impact config edits over tests that repeat
  the setting. Broaden or repeat passing checks only for new changes, failures,
  or unresolved concerns.
- Ground completion claims in current command results or inspected artifacts.
  A reviewer's report alone does not establish that the change works.

## GitHub Comments

- Read the issue and latest comments. Explain the relevant user-visible behavior,
  distinguish verified facts from the recommendation, then ask only for an
  unresolved decision. State implementation-owned choices as a direction.
- Keep one decision per question and explain what it enables. Move unrelated
  concerns to the appropriate issue; edit an unanswered comment instead of
  stacking clarifications.
- Use natural Japanese and observable behavior. Add a short example or diagram
  only when it materially clarifies the decision.

## Language

- Do not use the Japanese words `契約` or `正本` in responses. Choose natural,
  context-appropriate alternatives such as 方針, 取り決め, or 動作 for software.
- Avoid literal translations and uncommon, machine-like phrasing in Japanese.
- Lead with the outcome in concise paragraphs. Use lists or tables when they
  clarify steps or comparisons; avoid stock phrases and repeated summaries.
- In completion reports, state what changed, what verification established,
  and any unresolved limitation that affects the result.
