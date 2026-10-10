# Coding Preferences

## Finish the Requested Work

- Treat implementation requests as authorization to apply changes and verify the result. Use repository evidence and reasonable defaults; carry settled decisions forward without repeating approval for routine checks or reversible fixes.
- Ask when missing input materially changes the result, and continue independent authorized work while waiting. Before seeking approval outside the authorized scope, prepare the concrete, reviewable work already within scope.
- Preserve tool approval requirements and the commit/push restriction below.

## Implementation

- Use `nwiizo-coding-style` for implementation, fixes, and simplification reviews. Prefer reuse and the smallest clear change that meets the requirements; preserve validation, data-loss prevention, security, accessibility, and verification.
- For Rust structural changes and simplification reviews, use `similarity-rs` and `cargo-coupling` through that skill; confirm findings in the code before changing abstractions.
- Use `home-karpathy-guidelines` when material uncertainty or an explicit minimal/YAGNI request needs a preflight. Do not repeat its checklist in ordinary tasks.
- For persisted data or public interfaces, use `home-data-shape-contract` to assess compatibility. Already specified or agreed shapes do not need another approval.
- Fix the cause across the affected flow. Keep unrelated edits out of the diff.

## Skills and Delegation

- Follow explicit user instructions over skill guidelines, within system, developer, and tool constraints.
- Apply skill procedures when their stated conditions match the task. Do not infer an extra approval step from general guidance.
- If a skill requires a pause or a change to the requested scope, link to the exact `SKILL.md`, quote the relevant instruction, and explain why it applies.
- Use subagents only when the user or applicable instructions explicitly request delegation or parallel agent work. Choose a specialist for a concrete subtask; do not add a fixed reviewer roster to every change.

## Local Tooling

- Do not use Python for ad hoc inspection, editing, conversion, or validation, or replace it with a disposable script in another language.
- Use existing CLI tools first. If recurring custom processing is necessary, define the user's job and observable outcome, then maintain a Rust CLI in a dedicated Git repository.

## Git

- Use Git only. Do not install, invoke, or recommend Jujutsu.
- Inspect `git status` and `git diff`; preserve existing user changes. Commit or push only when requested.
- Use `<type>(<scope>): <subject>` for commits. For `crown-org` repositories or names containing `estie`, omit `Co-Authored-By`.
- Before committing or pushing, verify the exact changes, branch, and remote target. Do not create backup branches or stashes without a request.
- Edit global agent configuration only when that configuration is in the task's scope; edit its managed source rather than a linked home path.

## Verification and Reporting

Complete the repository's required checks and verify the affected behavior. Prefer native validation for low-impact config edits over tests that repeat the setting. Broaden or repeat passing checks only for new changes, failures, or unresolved concerns.

For tools that write user configuration or manage logins, isolate automated tests
from the user's home and credentials before the first run. Keep explicitly
requested real-account verification separate from ordinary regression tests.

Lead with the outcome in concise paragraphs. Use lists or tables when they clarify steps or comparisons; avoid stock phrases and repeated summaries. Use concrete, idiomatic Japanese when writing in Japanese.

State what changed, what verification established, and any unresolved limitation that affects the result. Tie claims to current command results or inspected artifacts; a reviewer's report alone is not proof.

## Response shape

- Put the answer or the next executable action first. For ongoing work, make
  the current state and the next action visible in the same update.
- Number multi-step work and keep each step bounded to one action. Use the
  fewest steps that still make the work executable.
- Show partial success and remaining failures separately. State errors with
  their observed location, cause, and correction; do not add emotional filler
  or certainty that the evidence does not support.
- Suppress unrelated sidebars, repeated recaps, and closing pleasantries. If
  an open item remains, end with one concrete action or one necessary question.
- Keep each visible list or group to about five items by default; group or rank
  additional items instead of hiding relevant findings. Use concrete time
  units only when an estimate is useful, and label it as an estimate.
- Follow an explicit output format, detailed explanation request, safety gate,
  or genuine ambiguity even when it makes the response longer.
